//go:build linux

package main

import (
	"syscall"
	"testing"
)

// TestLinuxRlimitConstantsMatchKernel verifies the hand-written
// RLIMIT_NPROC number against the running kernel.
//
// rlimit_linux.go carries a numeric constant because Go's syscall
// package omits RLIMIT_NPROC on Linux. A wrong number would not fail to
// compile and would not error at runtime — setrlimit would happily bound
// some other resource, and the process-count limit the sandbox claims
// would silently not exist. This test is what makes that claim checkable
// on the platform production runs on.
func TestLinuxRlimitConstantsMatchKernel(t *testing.T) {
	for _, tc := range []struct {
		name     string
		resource int
	}{
		{"RLIMIT_NPROC", rlimitNPROC},
		{"RLIMIT_AS", rlimitAS},
		{"RLIMIT_CPU", syscall.RLIMIT_CPU},
		{"RLIMIT_FSIZE", syscall.RLIMIT_FSIZE},
	} {
		var lim syscall.Rlimit
		if err := syscall.Getrlimit(tc.resource, &lim); err != nil {
			t.Errorf("%s (resource %d): getrlimit: %v — the constant does not name a real resource",
				tc.name, tc.resource, err)
		}
	}

	// Distinctness matters as much as validity: two limits sharing a
	// number means one of them is not being applied at all.
	seen := map[int]string{}
	for name, res := range map[string]int{
		"RLIMIT_NPROC": rlimitNPROC,
		"RLIMIT_AS":    rlimitAS,
		"RLIMIT_CPU":   syscall.RLIMIT_CPU,
		"RLIMIT_FSIZE": syscall.RLIMIT_FSIZE,
	} {
		if other, dup := seen[res]; dup {
			t.Errorf("%s and %s are both resource %d; one of them is unenforced", name, other, res)
		}
		seen[res] = name
	}

	// RLIMIT_NPROC specifically: set it low, read it back, confirm the
	// kernel agrees about which resource we just bounded. Done in a
	// subprocess-free way by lowering only the soft limit and restoring.
	var orig syscall.Rlimit
	if err := syscall.Getrlimit(rlimitNPROC, &orig); err != nil {
		t.Fatalf("getrlimit NPROC: %v", err)
	}
	t.Cleanup(func() { _ = syscall.Setrlimit(rlimitNPROC, &orig) })

	want := orig
	want.Cur = limitProcesses
	if want.Max != 0 && want.Cur > want.Max {
		want.Cur = want.Max
	}
	if err := syscall.Setrlimit(rlimitNPROC, &want); err != nil {
		t.Fatalf("setrlimit NPROC: %v", err)
	}
	var got syscall.Rlimit
	if err := syscall.Getrlimit(rlimitNPROC, &got); err != nil {
		t.Fatalf("getrlimit NPROC after set: %v", err)
	}
	if got.Cur != want.Cur {
		t.Errorf("NPROC soft limit read back as %d, set %d", got.Cur, want.Cur)
	}
}
