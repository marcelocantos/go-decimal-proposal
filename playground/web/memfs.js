// Copyright 2026 Marcelo Cantos. Use of this source code is governed by
// a BSD-style license (see the Go project's LICENSE).

// An in-memory filesystem behind the Go js/wasm runtime.
//
// The Go js runtime makes its file-system calls through globalThis.fs
// using the Node.js callback API (syscall/fs_js.go), asks globalThis.process
// for the working directory, and resolves paths with globalThis.path. In a
// browser none of these exist, and wasm_exec.js installs stubs that fail
// every call except writes to stdout. This file replaces those stubs with a
// small filesystem held in memory, enough for cmd/compile, cmd/link and the
// compiled program: open, read, write, stat, mkdir, readdir, rename, unlink.
//
// Writes to file descriptors 1 and 2 go to memfs.onOutput(fd, bytes), so the
// worker can route each program's output to the page.
//
// It must be installed before wasm_exec.js is loaded: wasm_exec.js only
// installs its stubs when globalThis.fs is unset.

"use strict";

(() => {
	const S_IFDIR = 0o040000;
	const S_IFREG = 0o100000;

	// Flag values are ours to choose: fs_js.go reads them from fs.constants.
	const O_WRONLY = 1;
	const O_RDWR = 2;
	const O_CREAT = 0o100;
	const O_EXCL = 0o200;
	const O_TRUNC = 0o1000;
	const O_APPEND = 0o2000;
	const O_DIRECTORY = 0o200000;
	const O_ACCMODE = 3;

	const FIRST_FD = 3; // 0, 1 and 2 are stdin, stdout and stderr.

	function fsError(code, path) {
		const err = new Error(path ? `${code}: ${path}` : code);
		err.code = code;
		return err;
	}

	// normalize turns an absolute path into its components, resolving "."
	// and "..". The root is the empty list.
	function components(abs) {
		const out = [];
		for (const part of abs.split("/")) {
			if (part === "" || part === ".") continue;
			if (part === "..") out.pop();
			else out.push(part);
		}
		return out;
	}

	class MemFS {
		constructor() {
			this.nextIno = 1;
			this.root = this.newDir(0o755);
			this.fds = new Map();
			this.nextFd = FIRST_FD;
			this.cwd = "/";
			this.onOutput = () => {};
			this.constants = { O_WRONLY, O_RDWR, O_CREAT, O_TRUNC, O_APPEND, O_EXCL, O_DIRECTORY };
		}

		newDir(mode) {
			return { dir: true, children: new Map(), mode: S_IFDIR | mode, ino: this.nextIno++, mtimeMs: Date.now() };
		}

		newFile(mode) {
			return { dir: false, data: new Uint8Array(0), size: 0, mode: S_IFREG | mode, ino: this.nextIno++, mtimeMs: Date.now() };
		}

		resolve(path) {
			const abs = path.startsWith("/") ? path : this.cwd + "/" + path;
			return "/" + components(abs).join("/");
		}

		// lookup returns the node at path, or throws ENOENT/ENOTDIR.
		lookup(path) {
			let node = this.root;
			for (const name of components(this.resolve(path))) {
				if (!node.dir) throw fsError("ENOTDIR", path);
				node = node.children.get(name);
				if (!node) throw fsError("ENOENT", path);
			}
			return node;
		}

		// parentOf returns the directory that holds path and the final name.
		parentOf(path) {
			const parts = components(this.resolve(path));
			if (parts.length === 0) throw fsError("EINVAL", path);
			const name = parts.pop();
			const parent = this.lookup("/" + parts.join("/"));
			if (!parent.dir) throw fsError("ENOTDIR", path);
			return { parent, name };
		}

		fd(fd) {
			const f = this.fds.get(fd);
			if (!f) throw fsError("EBADF");
			return f;
		}

		// Synchronous helpers, used by the worker to populate the filesystem.

		mkdirAll(path) {
			let node = this.root;
			for (const name of components(this.resolve(path))) {
				let next = node.children.get(name);
				if (!next) {
					next = this.newDir(0o755);
					node.children.set(name, next);
				}
				if (!next.dir) throw fsError("ENOTDIR", path);
				node = next;
			}
		}

		writeFile(path, bytes) {
			const parts = components(this.resolve(path));
			parts.pop();
			this.mkdirAll("/" + parts.join("/"));
			const { parent, name } = this.parentOf(path);
			const file = this.newFile(0o644);
			file.data = bytes;
			file.size = bytes.length;
			parent.children.set(name, file);
		}

		readFile(path) {
			const node = this.lookup(path);
			if (node.dir) throw fsError("EISDIR", path);
			return node.data.subarray(0, node.size);
		}

		removeAll(path) {
			try {
				const { parent, name } = this.parentOf(path);
				parent.children.delete(name);
			} catch (e) {
				if (e.code !== "ENOENT") throw e;
			}
		}

		stats(node) {
			const size = node.dir ? 0 : node.size;
			return {
				dev: 1, ino: node.ino, mode: node.mode, nlink: 1, uid: 0, gid: 0, rdev: 0,
				size, blksize: 4096, blocks: Math.ceil(size / 512),
				atimeMs: node.mtimeMs, mtimeMs: node.mtimeMs, ctimeMs: node.mtimeMs,
				isDirectory() { return node.dir; },
			};
		}

		// ensureCapacity grows a file's backing array geometrically, so the
		// linker's many small writes do not copy the whole file each time.
		ensureCapacity(node, n) {
			if (n <= node.data.length) return;
			const grown = new Uint8Array(Math.max(n, node.data.length * 2, 4096));
			grown.set(node.data.subarray(0, node.size));
			node.data = grown;
		}

		// The Node.js callback API that fs_js.go calls. Each method runs
		// synchronously and calls back before returning, which the Go side
		// allows (wasm_exec.js's own stubs do the same).

		call(cb, fn) {
			let result;
			try {
				result = fn();
			} catch (e) {
				if (e.code === undefined) throw e;
				cb(e);
				return;
			}
			cb(null, result);
		}

		open(path, flags, mode, cb) {
			this.call(cb, () => {
				let node;
				try {
					node = this.lookup(path);
					if ((flags & O_CREAT) && (flags & O_EXCL)) throw fsError("EEXIST", path);
				} catch (e) {
					if (e.code !== "ENOENT" || !(flags & O_CREAT)) throw e;
					const { parent, name } = this.parentOf(path);
					node = this.newFile(mode & 0o777);
					parent.children.set(name, node);
				}
				if ((flags & O_DIRECTORY) && !node.dir) throw fsError("ENOTDIR", path);
				const writable = (flags & O_ACCMODE) !== 0;
				if (node.dir && writable) throw fsError("EISDIR", path);
				if (writable && (flags & O_TRUNC)) {
					node.size = 0;
					node.mtimeMs = Date.now();
				}
				const fd = this.nextFd++;
				this.fds.set(fd, { node, pos: 0, append: (flags & O_APPEND) !== 0, writable });
				return fd;
			});
		}

		close(fd, cb) {
			this.call(cb, () => {
				this.fd(fd);
				this.fds.delete(fd);
			});
		}

		read(fd, buf, offset, length, position, cb) {
			this.call(cb, () => {
				if (fd === 0) return 0; // stdin is empty.
				const f = this.fd(fd);
				if (f.node.dir) throw fsError("EISDIR");
				const pos = position === null ? f.pos : position;
				const n = Math.max(0, Math.min(length, f.node.size - pos));
				buf.set(f.node.data.subarray(pos, pos + n), offset);
				if (position === null) f.pos += n;
				return n;
			});
		}

		writeSync(fd, buf) {
			if (fd === 1 || fd === 2) {
				this.onOutput(fd, buf.slice());
				return buf.length;
			}
			let n;
			this.write(fd, buf, 0, buf.length, null, (err, written) => {
				if (err) throw err;
				n = written;
			});
			return n;
		}

		write(fd, buf, offset, length, position, cb) {
			if (fd === 1 || fd === 2) {
				this.onOutput(fd, buf.slice(offset, offset + length));
				cb(null, length);
				return;
			}
			this.call(cb, () => {
				const f = this.fd(fd);
				if (!f.writable) throw fsError("EBADF");
				const node = f.node;
				let pos = position === null ? f.pos : position;
				if (f.append) pos = node.size;
				this.ensureCapacity(node, pos + length);
				if (pos > node.size) node.data.fill(0, node.size, pos);
				node.data.set(buf.subarray(offset, offset + length), pos);
				node.size = Math.max(node.size, pos + length);
				node.mtimeMs = Date.now();
				if (position === null) f.pos = pos + length;
				return length;
			});
		}

		fstat(fd, cb) {
			this.call(cb, () => {
				if (fd >= 0 && fd < FIRST_FD) {
					return { ...this.stats(this.newFile(0o620)), mode: 0o020620, isDirectory() { return false; } };
				}
				return this.stats(this.fd(fd).node);
			});
		}

		stat(path, cb) { this.call(cb, () => this.stats(this.lookup(path))); }
		lstat(path, cb) { this.call(cb, () => this.stats(this.lookup(path))); }

		mkdir(path, perm, cb) {
			this.call(cb, () => {
				const { parent, name } = this.parentOf(path);
				if (parent.children.has(name)) throw fsError("EEXIST", path);
				parent.children.set(name, this.newDir(perm & 0o777));
			});
		}

		readdir(path, cb) {
			this.call(cb, () => {
				const node = this.lookup(path);
				if (!node.dir) throw fsError("ENOTDIR", path);
				return [...node.children.keys()].sort();
			});
		}

		unlink(path, cb) {
			this.call(cb, () => {
				const { parent, name } = this.parentOf(path);
				const node = parent.children.get(name);
				if (!node) throw fsError("ENOENT", path);
				if (node.dir) throw fsError("EISDIR", path);
				parent.children.delete(name);
			});
		}

		rmdir(path, cb) {
			this.call(cb, () => {
				const { parent, name } = this.parentOf(path);
				const node = parent.children.get(name);
				if (!node) throw fsError("ENOENT", path);
				if (!node.dir) throw fsError("ENOTDIR", path);
				if (node.children.size > 0) throw fsError("ENOTEMPTY", path);
				parent.children.delete(name);
			});
		}

		rename(from, to, cb) {
			this.call(cb, () => {
				const src = this.parentOf(from);
				const node = src.parent.children.get(src.name);
				if (!node) throw fsError("ENOENT", from);
				const dst = this.parentOf(to);
				src.parent.children.delete(src.name);
				dst.parent.children.set(dst.name, node);
			});
		}

		truncateNode(node, length) {
			if (node.dir) throw fsError("EISDIR");
			this.ensureCapacity(node, length);
			if (length > node.size) node.data.fill(0, node.size, length);
			node.size = length;
			node.mtimeMs = Date.now();
		}

		truncate(path, length, cb) { this.call(cb, () => this.truncateNode(this.lookup(path), length)); }
		ftruncate(fd, length, cb) { this.call(cb, () => this.truncateNode(this.fd(fd).node, length)); }

		chmod(path, mode, cb) {
			this.call(cb, () => {
				const node = this.lookup(path);
				node.mode = (node.mode & ~0o7777) | (mode & 0o7777);
			});
		}

		fchmod(fd, mode, cb) {
			this.call(cb, () => {
				const node = this.fd(fd).node;
				node.mode = (node.mode & ~0o7777) | (mode & 0o7777);
			});
		}

		chown(path, uid, gid, cb) { this.call(cb, () => { this.lookup(path); }); }
		fchown(fd, uid, gid, cb) { this.call(cb, () => { this.fd(fd); }); }
		lchown(path, uid, gid, cb) { this.call(cb, () => { this.lookup(path); }); }

		utimes(path, atime, mtime, cb) {
			this.call(cb, () => { this.lookup(path).mtimeMs = mtime * 1000; });
		}

		fsync(fd, cb) { this.call(cb, () => { this.fd(fd); }); }
		readlink(path, cb) { this.call(cb, () => { this.lookup(path); throw fsError("EINVAL", path); }); }
		symlink(path, link, cb) { cb(fsError("ENOSYS")); }
		link(path, link, cb) { cb(fsError("ENOSYS")); }
	}

	// install points the Go runtime's globals at memfs.
	MemFS.prototype.install = function () {
		const memfs = this;
		globalThis.fs = memfs;
		globalThis.process = {
			getuid() { return 0; },
			getgid() { return 0; },
			geteuid() { return 0; },
			getegid() { return 0; },
			getgroups() { return [0]; },
			pid: 1,
			ppid: 0,
			umask() { return 0o022; },
			cwd() { return memfs.cwd; },
			chdir(path) {
				if (!memfs.lookup(path).dir) throw fsError("ENOTDIR", path);
				memfs.cwd = memfs.resolve(path);
			},
		};
		globalThis.path = {
			resolve(...segments) {
				let abs = memfs.cwd;
				for (const s of segments) abs = s.startsWith("/") ? s : abs + "/" + s;
				return memfs.resolve(abs);
			},
		};
	};

	globalThis.MemFS = MemFS;
})();
