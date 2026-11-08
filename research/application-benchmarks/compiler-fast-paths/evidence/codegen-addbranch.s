codegen.Add64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	TEXT	codegen.Add64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	FUNCDATA	$5, codegen.Add64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	FUNCDATA	$6, codegen.Add64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	CALL	runtime.dadd64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	MOVD	$3584865303386914816, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	EOR	R2, R0, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	MOVD.P	48(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:19)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 02 38 e6 d2 00 00 02 ca  .........8......
	0x0030 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6 e0 87 00 a9  .._...C..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 36+4 t=R_CALLARM64 runtime.dadd64+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.MulAdd64 STEXT size=112 align=0x0 args=0x18 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	TEXT	codegen.MulAdd64(SB), ABIInternal, $48-24
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	BLS	80
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	FUNCDATA	$5, codegen.MulAdd64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	FUNCDATA	$6, codegen.MulAdd64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	R2, codegen.z+16(FP)
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	PCDATA	$3, $2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	$3584865303386914816, R2
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	EOR	R2, R1, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	EOR	R2, R0, R0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	PCDATA	$1, $0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	CALL	runtime.dmul64(SB)
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	codegen.z+16(FP), R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	$3584865303386914816, R3
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	EOR	R3, R2, R1
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	CALL	runtime.dadd64(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	$3584865303386914816, R2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	EOR	R0, R2, R0
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	-8(RSP), R29
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD.P	48(RSP), R30
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	RET	(R30)
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	NOP
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$1, $-1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$0, $-2
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	STP	(R0, R1), 8(RSP)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	MOVD	R2, 24(RSP)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	MOVD	R30, R3
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	CALL	runtime.morestack_noctxt(SB)
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$0, $-1
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	LDP	8(RSP), (R0, R1)
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	MOVD	24(RSP), R2
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 02 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 e2 27 00 f9 02 38 e6 d2  .....#...'...8..
	0x0020 21 00 02 ca 00 00 02 ca 00 00 00 94 e2 27 40 f9  !............'@.
	0x0030 03 38 e6 d2 41 00 03 ca 00 00 00 94 02 38 e6 d2  .8..A........8..
	0x0040 40 00 00 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  @....._...C..._.
	0x0050 e0 87 00 a9 e2 0f 00 f9 e3 03 1e aa 00 00 00 94  ................
	0x0060 e0 87 40 a9 e2 0f 40 f9 e6 ff ff 17 00 00 00 00  ..@...@.........
	rel 40+4 t=R_CALLARM64 runtime.dmul64+0
	rel 56+4 t=R_CALLARM64 runtime.dadd64+0
	rel 92+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Sub64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	TEXT	codegen.Sub64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	FUNCDATA	$5, codegen.Sub64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	FUNCDATA	$6, codegen.Sub64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	CALL	runtime.dsub64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	MOVD	$3584865303386914816, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	EOR	R2, R0, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	MOVD.P	48(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:29)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 02 38 e6 d2 00 00 02 ca  .........8......
	0x0030 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6 e0 87 00 a9  .._...C..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 36+4 t=R_CALLARM64 runtime.dsub64+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Div64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	TEXT	codegen.Div64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	FUNCDATA	$5, codegen.Div64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	FUNCDATA	$6, codegen.Div64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	CALL	runtime.ddiv64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	MOVD	$3584865303386914816, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	EOR	R2, R0, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	MOVD.P	48(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:34)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 02 38 e6 d2 00 00 02 ca  .........8......
	0x0030 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6 e0 87 00 a9  .._...C..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 36+4 t=R_CALLARM64 runtime.ddiv64+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Less64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	TEXT	codegen.Less64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	BLS	52
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	FUNCDATA	$5, codegen.Less64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	FUNCDATA	$6, codegen.Less64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	CALL	runtime.dlt64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	MOVD	-8(RSP), R29
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	MOVD.P	48(RSP), R30
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	RET	(R30)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:39)	NOP
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	PCDATA	$1, $-1
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	PCDATA	$0, $-2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	STP	(R0, R1), 8(RSP)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	MOVD	R30, R3
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	CALL	runtime.morestack_noctxt(SB)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	PCDATA	$0, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	LDP	8(RSP), (R0, R1)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 69 01 00 54 fe 0f 1d f8  ..@..c0.i..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 fd 83 5f f8 fe 07 43 f8  .........._...C.
	0x0030 c0 03 5f d6 e0 87 00 a9 e3 03 1e aa 00 00 00 94  .._.............
	0x0040 e0 87 40 a9 ef ff ff 17 00 00 00 00 00 00 00 00  ..@.............
	rel 36+4 t=R_CALLARM64 runtime.dlt64+0
	rel 60+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Add128 STEXT size=176 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	TEXT	codegen.Add128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	BLS	140
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$5, codegen.Add128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$6, codegen.Add128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R3, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BNE	80
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	TST	$562949953421311, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BNE	80
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	AND	$6917529027641081856, R1, R4
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$4611686018427387904, R5
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R5, R4
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BEQ	80
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADDS	R2, R0, R0
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADC	ZR, ZR, R2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R2, R1, R1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R1, R4
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R0, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	JMP	120
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$3476778912330022912, R4
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R1, R5
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R3, R4
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R0, R1
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R2, R3
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R5, R0
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R4, R2
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	PCDATA	$1, $0
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CALL	runtime.dadd128(SB)
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$3476778912330022912, R4
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R0, R4
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R1, R0
	0x007c 00124 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R4, R1
	0x0080 00128 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	-8(RSP), R29
	0x0084 00132 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD.P	80(RSP), R30
	0x0088 00136 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	RET	(R30)
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	NOP
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$1, $-1
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-2
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	STP	(R0, R1), 8(RSP)
	0x0090 00144 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	STP	(R2, R3), 24(RSP)
	0x0094 00148 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	R30, R3
	0x0098 00152 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	CALL	runtime.morestack_noctxt(SB)
	0x009c 00156 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-1
	0x009c 00156 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	LDP	8(RSP), (R0, R1)
	0x00a0 00160 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	LDP	24(RSP), (R2, R3)
	0x00a4 00164 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 29 04 00 54 fe 0f 1b f8  ..@..c0.)..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 3f 00 03 eb a1 01 00 54  .....#..?......T
	0x0020 3f c0 40 f2 61 01 00 54 24 04 43 92 05 00 e8 d2  ?.@.a..T$.C.....
	0x0030 9f 00 05 eb e0 00 00 54 00 00 02 ab e2 03 1f 9a  .......T........
	0x0040 21 00 02 aa e4 03 01 aa e1 03 00 aa 0b 00 00 14  !...............
	0x0050 04 08 e6 d2 25 00 04 ca 64 00 04 ca e1 03 00 aa  ....%...d.......
	0x0060 e3 03 02 aa e0 03 05 aa e2 03 04 aa 00 00 00 94  ................
	0x0070 04 08 e6 d2 04 00 04 ca e0 03 01 aa e1 03 04 aa  ................
	0x0080 fd 83 5f f8 fe 07 45 f8 c0 03 5f d6 e0 87 00 a9  .._...E..._.....
	0x0090 e2 8f 01 a9 e3 03 1e aa 00 00 00 94 e0 87 40 a9  ..............@.
	0x00a0 e2 8f 41 a9 d7 ff ff 17 00 00 00 00 00 00 00 00  ..A.............
	rel 108+4 t=R_CALLARM64 runtime.dadd128+0
	rel 152+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Mul128 STEXT size=112 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	TEXT	codegen.Mul128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	BLS	84
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$5, codegen.Mul128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$6, codegen.Mul128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	EOR	R4, R3, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	EOR	R4, R1, R4
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	R0, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	R2, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	R5, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	PCDATA	$1, $0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	CALL	runtime.dmul128(SB)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	$3476778912330022912, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	EOR	R4, R0, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	R1, R0
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	R4, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD	-8(RSP), R29
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	MOVD.P	80(RSP), R30
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	RET	(R30)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:51)	NOP
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$1, $-1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-2
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	STP	(R0, R1), 8(RSP)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	STP	(R2, R3), 24(RSP)
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD	R30, R3
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	CALL	runtime.morestack_noctxt(SB)
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-1
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	LDP	8(RSP), (R0, R1)
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	LDP	24(RSP), (R2, R3)
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 69 02 00 54 fe 0f 1b f8  ..@..c0.i..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 65 00 04 ca  .....#......e...
	0x0020 24 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 04 aa  $...............
	0x0030 e2 03 05 aa 00 00 00 94 04 08 e6 d2 04 00 04 ca  ................
	0x0040 e0 03 01 aa e1 03 04 aa fd 83 5f f8 fe 07 45 f8  .........._...E.
	0x0050 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0060 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 e5 ff ff 17  ......@...A.....
	rel 52+4 t=R_CALLARM64 runtime.dmul128+0
	rel 96+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Eq128 STEXT size=96 align=0x0 args=0x20 locals=0x38 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	TEXT	codegen.Eq128(SB), ABIInternal, $64-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	BLS	68
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	MOVD.W	R30, -64(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	FUNCDATA	$5, codegen.Eq128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	FUNCDATA	$6, codegen.Eq128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	EOR	R4, R3, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	EOR	R4, R1, R4
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	R0, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	R2, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	R5, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$1, $0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	CALL	runtime.deq128(SB)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	-8(RSP), R29
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD.P	64(RSP), R30
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	RET	(R30)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	NOP
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	PCDATA	$1, $-1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	PCDATA	$0, $-2
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	STP	(R0, R1), 8(RSP)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	STP	(R2, R3), 24(RSP)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	MOVD	R30, R3
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	CALL	runtime.morestack_noctxt(SB)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	PCDATA	$0, $-1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	LDP	8(RSP), (R0, R1)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	LDP	24(RSP), (R2, R3)
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:54)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb e9 01 00 54 fe 0f 1c f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 65 00 04 ca  .....#......e...
	0x0020 24 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 04 aa  $...............
	0x0030 e2 03 05 aa 00 00 00 94 fd 83 5f f8 fe 07 44 f8  .........._...D.
	0x0040 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0050 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 e9 ff ff 17  ......@...A.....
	rel 52+4 t=R_CALLARM64 runtime.deq128+0
	rel 80+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Zero64 STEXT size=96 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	TEXT	codegen.Zero64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	FUNCDATA	$5, codegen.Zero64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	FUNCDATA	$6, codegen.Zero64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	$3584865303386914816, R1
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	EOR	R1, R0, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	AND	$2251799813685247, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	AND	$6917529027641081856, R1, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	AND	$8646911284551352320, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	$6917529027641081856, R5
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CMP	R5, R3
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CSET	EQ, R3
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CSET	NE, R5
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	$992800745259007, R6
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CMP	R6, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CSET	HI, R2
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	AND	R3, R2, R2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	$8646911284551352320, R3
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CMP	R3, R4
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CSET	NE, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	TST	$9007199254740991, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CSET	EQ, R1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	AND	R5, R1, R1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	ORR	R2, R1, R1
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	AND	R3, R1, R0
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	RET	(R30)
	0x0000 01 38 e6 d2 01 00 01 ca 22 c8 40 92 23 04 43 92  .8......".@.#.C.
	0x0010 24 0c 45 92 05 00 ec d2 7f 00 05 eb e3 17 9f 9a  $.E.............
	0x0020 e5 07 9f 9a e6 07 b2 92 46 de d0 f2 66 00 e0 f2  ........F...f...
	0x0030 5f 00 06 eb e2 97 9f 9a 42 00 03 8a 03 00 ef d2  _.......B.......
	0x0040 9f 00 03 eb e3 07 9f 9a 3f d0 40 f2 e1 17 9f 9a  ........?.@.....
	0x0050 21 00 05 8a 21 00 02 aa 20 00 03 8a c0 03 5f d6  !...!... ....._.
codegen.Nonzero64 STEXT size=112 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:65)	TEXT	codegen.Nonzero64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:65)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:65)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:65)	FUNCDATA	$5, codegen.Nonzero64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:65)	FUNCDATA	$6, codegen.Nonzero64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:65)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	MOVD	$3584865303386914816, R1
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	EOR	R1, R0, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	AND	$2251799813685247, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	AND	$6917529027641081856, R1, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	AND	$8646911284551352320, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	MOVD	$6917529027641081856, R5
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CMP	R5, R3
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CSET	EQ, R3
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CSET	NE, R5
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	MOVD	$992800745259007, R6
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CMP	R6, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CSET	HI, R2
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	AND	R3, R2, R2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	MOVD	$8646911284551352320, R3
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CMP	R3, R4
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CSET	NE, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	TST	$9007199254740991, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	CSET	EQ, R1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	AND	R5, R1, R1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	ORR	R2, R1, R1
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	AND	R3, R1, R1
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	EOR	$1, R1, R0
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:68)	RET	(R30)
	0x0000 01 38 e6 d2 01 00 01 ca 22 c8 40 92 23 04 43 92  .8......".@.#.C.
	0x0010 24 0c 45 92 05 00 ec d2 7f 00 05 eb e3 17 9f 9a  $.E.............
	0x0020 e5 07 9f 9a e6 07 b2 92 46 de d0 f2 66 00 e0 f2  ........F...f...
	0x0030 5f 00 06 eb e2 97 9f 9a 42 00 03 8a 03 00 ef d2  _.......B.......
	0x0040 9f 00 03 eb e3 07 9f 9a 3f d0 40 f2 e1 17 9f 9a  ........?.@.....
	0x0050 21 00 05 8a 21 00 02 aa 21 00 03 8a 20 00 40 d2  !...!...!... .@.
	0x0060 c0 03 5f d6 00 00 00 00 00 00 00 00 00 00 00 00  .._.............
codegen.Zero128 STEXT size=128 align=0x0 args=0x10 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:71)	TEXT	codegen.Zero128(SB), LEAF|NOFRAME|ABIInternal, $0-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:71)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:71)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:71)	FUNCDATA	$5, codegen.Zero128.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:71)	FUNCDATA	$6, codegen.Zero128.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:71)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	MOVD	$3476778912330022912, R2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	EOR	R2, R1, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	AND	$562949953421311, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	ORR	R0, R2, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	AND	$6917529027641081856, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	AND	$8646911284551352320, R1, R1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	MOVD	$542101086242752, R5
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CMP	R5, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CSET	HI, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CSET	EQ, R5
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	MOVD	$6917529027641081856, R6
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CMP	R6, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CSET	EQ, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	MOVD	$8646911284551352320, R6
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CMP	R6, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CSET	NE, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	MOVD	$4003012203950112767, R6
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CMP	R6, R0
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CSET	HI, R6
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	AND	R6, R5, R5
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	ORR	R2, R5, R2
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	ORR	R4, R2, R2
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CMP	$0, R3
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	CSET	EQ, R3
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	ORR	R2, R3, R2
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	AND	R2, R1, R0
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:74)	RET	(R30)
	0x0000 02 08 e6 d2 21 00 02 ca 22 c0 40 92 43 00 00 aa  ....!...".@.C...
	0x0010 24 04 43 92 21 0c 45 92 05 f8 90 d2 a5 d5 b7 f2  $.C.!.E.........
	0x0020 25 a1 dd f2 25 00 e0 f2 5f 00 05 eb e2 97 9f 9a  %...%..._.......
	0x0030 e5 17 9f 9a 06 00 ec d2 9f 00 06 eb e4 17 9f 9a  ................
	0x0040 06 00 ef d2 3f 00 06 eb e1 07 9f 9a 86 33 ce 92  ....?........3..
	0x0050 a6 f1 e6 f2 1f 00 06 eb e6 97 9f 9a a5 00 06 8a  ................
	0x0060 a2 00 02 aa 42 00 04 aa 7f 00 00 f1 e3 17 9f 9a  ....B...........
	0x0070 62 00 02 aa 20 00 02 8a c0 03 5f d6 00 00 00 00  b... ....._.....
codegen.Nonzero128 STEXT size=128 align=0x0 args=0x10 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:77)	TEXT	codegen.Nonzero128(SB), LEAF|NOFRAME|ABIInternal, $0-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:77)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:77)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:77)	FUNCDATA	$5, codegen.Nonzero128.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:77)	FUNCDATA	$6, codegen.Nonzero128.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:77)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	MOVD	$3476778912330022912, R2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	EOR	R2, R1, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	AND	$562949953421311, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	ORR	R0, R2, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	AND	$6917529027641081856, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	AND	$8646911284551352320, R1, R1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	MOVD	$542101086242752, R5
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CMP	R5, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CSET	HI, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CSET	EQ, R5
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	MOVD	$6917529027641081856, R6
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CMP	R6, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CSET	EQ, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	MOVD	$8646911284551352320, R6
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CMP	R6, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CSET	NE, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	MOVD	$4003012203950112767, R6
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CMP	R6, R0
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CSET	HI, R6
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	AND	R6, R5, R5
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	ORR	R2, R5, R2
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	ORR	R4, R2, R2
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CMP	$0, R3
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	CSET	EQ, R3
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	ORR	R2, R3, R2
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	AND	R2, R1, R1
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	EOR	$1, R1, R0
	0x007c 00124 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:80)	RET	(R30)
	0x0000 02 08 e6 d2 21 00 02 ca 22 c0 40 92 43 00 00 aa  ....!...".@.C...
	0x0010 24 04 43 92 21 0c 45 92 05 f8 90 d2 a5 d5 b7 f2  $.C.!.E.........
	0x0020 25 a1 dd f2 25 00 e0 f2 5f 00 05 eb e2 97 9f 9a  %...%..._.......
	0x0030 e5 17 9f 9a 06 00 ec d2 9f 00 06 eb e4 17 9f 9a  ................
	0x0040 06 00 ef d2 3f 00 06 eb e1 07 9f 9a 86 33 ce 92  ....?........3..
	0x0050 a6 f1 e6 f2 1f 00 06 eb e6 97 9f 9a a5 00 06 8a  ................
	0x0060 a2 00 02 aa 42 00 04 aa 7f 00 00 f1 e3 17 9f 9a  ....B...........
	0x0070 62 00 02 aa 21 00 02 8a 20 00 40 d2 c0 03 5f d6  b...!... .@..._.
codegen.Widen STEXT size=96 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	TEXT	codegen.Widen(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	BLS	64
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	FUNCDATA	$5, codegen.Widen.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	FUNCDATA	$6, codegen.Widen.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	EOR	R0, R1, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	CALL	runtime.dd64tod128(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	MOVD	$3476778912330022912, R2
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	EOR	R2, R0, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	MOVD	R1, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	MOVD	R2, R1
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	MOVD	-8(RSP), R29
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	MOVD.P	48(RSP), R30
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	RET	(R30)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	NOP
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	PCDATA	$1, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	PCDATA	$0, $-2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	MOVD	R0, 8(RSP)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	MOVD	R30, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	CALL	runtime.morestack_noctxt(SB)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	PCDATA	$0, $-1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	MOVD	8(RSP), R0
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:83)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 20 00 00 ca  .....#...8.. ...
	0x0020 00 00 00 94 02 08 e6 d2 02 00 02 ca e0 03 01 aa  ................
	0x0030 e1 03 02 aa fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0040 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0050 ec ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64tod128+0
	rel 72+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Narrow STEXT size=96 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	TEXT	codegen.Narrow(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	BLS	64
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	FUNCDATA	$5, codegen.Narrow.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	FUNCDATA	$6, codegen.Narrow.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	MOVD	$3476778912330022912, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	EOR	R1, R2, R2
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	MOVD	R0, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	MOVD	R2, R0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	PCDATA	$1, $0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	CALL	runtime.dd128tod64(SB)
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	MOVD	$3584865303386914816, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	EOR	R2, R0, R0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	MOVD	-8(RSP), R29
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	MOVD.P	48(RSP), R30
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	RET	(R30)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:90)	NOP
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	PCDATA	$1, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	PCDATA	$0, $-2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	STP	(R0, R1), 8(RSP)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	R30, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CALL	runtime.morestack_noctxt(SB)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	PCDATA	$0, $-1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	LDP	8(RSP), (R0, R1)
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 08 e6 d2 42 00 01 ca  .....#......B...
	0x0020 e1 03 00 aa e0 03 02 aa 00 00 00 94 02 38 e6 d2  .............8..
	0x0030 00 00 02 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0040 e0 87 00 a9 e3 03 1e aa 00 00 00 94 e0 87 40 a9  ..............@.
	0x0050 ec ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 40+4 t=R_CALLARM64 runtime.dd128tod64+0
	rel 72+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.FromInt STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	TEXT	codegen.FromInt(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	FUNCDATA	$5, codegen.FromInt.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	FUNCDATA	$6, codegen.FromInt.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	PCDATA	$1, $0
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	CALL	runtime.di64tod64(SB)
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	MOVD	$3584865303386914816, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	EOR	R1, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:95)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 00 00 00 94 01 38 e6 d2  .....#.......8..
	0x0020 00 00 01 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 24+4 t=R_CALLARM64 runtime.di64tod64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.ToInt STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	TEXT	codegen.ToInt(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	FUNCDATA	$5, codegen.ToInt.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	FUNCDATA	$6, codegen.ToInt.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	CALL	runtime.dd64toi64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:100)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 00 00 01 ca  .....#...8......
	0x0020 00 00 00 94 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64toi64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Min64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	TEXT	codegen.Min64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	FUNCDATA	$5, codegen.Min64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	FUNCDATA	$6, codegen.Min64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	CALL	runtime.dmin64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	MOVD	$3584865303386914816, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	EOR	R2, R0, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	MOVD.P	48(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:105)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 02 38 e6 d2 00 00 02 ca  .........8......
	0x0030 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6 e0 87 00 a9  .._...C..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 36+4 t=R_CALLARM64 runtime.dmin64+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
codegen.Neg64 STEXT size=16 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	TEXT	codegen.Neg64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	FUNCDATA	$5, codegen.Neg64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	FUNCDATA	$6, codegen.Neg64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:110)	EOR	$-9223372036854775808, R0, R0
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:110)	RET	(R30)
	0x0000 00 00 41 d2 c0 03 5f d6 00 00 00 00 00 00 00 00  ..A..._.........
codegen.ToFloat STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	TEXT	codegen.ToFloat(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	FUNCDATA	$5, codegen.ToFloat.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	FUNCDATA	$6, codegen.ToFloat.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	CALL	runtime.dd64tof64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 00 00 01 ca  .....#...8......
	0x0020 00 00 00 94 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64tof64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
go:cuinfo.producer.codegen SDWARFCUINFO dupok size=0 align=0x0
	0x0000 72 65 67 61 62 69                                regabi
go:cuinfo.packagename.codegen SDWARFCUINFO dupok size=0 align=0x0
	0x0000 63 6f 64 65 67 65 6e                             codegen
gclocals·g5+hNtRBP6YXNjfog7aZjQ== SRODATA dupok size=8 align=0x4
	0x0000 01 00 00 00 00 00 00 00                          ........
codegen.Add64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
codegen.Add64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.MulAdd64.arginfo1 SRODATA static dupok size=7 align=0x1
	0x0000 00 08 08 08 10 08 ff                             .......
codegen.MulAdd64.argliveinfo SRODATA static dupok size=3 align=0x1
	0x0000 00 00 04                                         ...
codegen.Sub64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
codegen.Sub64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Div64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
codegen.Div64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Less64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
codegen.Less64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Add128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
codegen.Add128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Mul128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
codegen.Mul128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Eq128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
codegen.Eq128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Zero64.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.Zero64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Nonzero64.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.Nonzero64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Zero128.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 10 ff                                         ...
codegen.Zero128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Nonzero128.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 10 ff                                         ...
codegen.Nonzero128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Widen.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.Widen.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Narrow.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 10 ff                                         ...
codegen.Narrow.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.FromInt.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.FromInt.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.ToInt.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.ToInt.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Min64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
codegen.Min64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.Neg64.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.Neg64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
codegen.ToFloat.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
codegen.ToFloat.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
