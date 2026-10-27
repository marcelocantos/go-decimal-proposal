//go:build unix

package main

import (
	"os/exec"
	"syscall"
)

// setProcessGroup puts the child in its own process group so the whole
// tree can be signalled. `go run` is a parent of the compiler and of the
// submitted program; signalling only the direct child leaves the
// submitted program running after a timeout.
func setProcessGroup(cmd *exec.Cmd) {
	if cmd.SysProcAttr == nil {
		cmd.SysProcAttr = &syscall.SysProcAttr{}
	}
	cmd.SysProcAttr.Setpgid = true
}

// killGroup SIGKILLs the child's whole process group. The negative pid
// is the group. Safe to call more than once and after exit; a missing
// group is not an error worth propagating.
func killGroup(cmd *exec.Cmd) error {
	if cmd.Process == nil {
		return nil
	}
	pgid, err := syscall.Getpgid(cmd.Process.Pid)
	if err != nil {
		// Already reaped, or never started.
		return nil
	}
	_ = syscall.Kill(-pgid, syscall.SIGKILL)
	return nil
}
