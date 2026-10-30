//go:build linux

package main

import "syscall"

// rlimitNPROC is RLIMIT_NPROC. Go's syscall package omits it on Linux
// (it lives in golang.org/x/sys/unix, which this zero-dependency binary
// does not pull in), so the value comes from the kernel's own
// asm-generic/resource.h: CPU 0, FSIZE 1, DATA 2, STACK 3, CORE 4,
// RSS 5, NPROC 6, NOFILE 7, MEMLOCK 8, AS 9.
//
// A wrong number here would silently limit the wrong resource, which is
// exactly the kind of quiet failure this file must not have — so
// TestLinuxRlimitConstantsMatchKernel sets each limit and reads it back
// on the platform that matters, and CI runs it.
const rlimitNPROC = 6

// rlimitAS is enforced on Linux, so the memory bound in sandbox.go is
// real here. This is the platform production runs on.
const rlimitAS = syscall.RLIMIT_AS
