<unlinkable>.Add64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	TEXT	<unlinkable>.Add64(SB), ABIInternal, $48-16
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
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	FUNCDATA	$5, <unlinkable>.Add64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:15)	FUNCDATA	$6, <unlinkable>.Add64.argliveinfo(SB)
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
<unlinkable>.MulAdd64 STEXT size=112 align=0x0 args=0x18 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	TEXT	<unlinkable>.MulAdd64(SB), ABIInternal, $48-24
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
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	FUNCDATA	$5, <unlinkable>.MulAdd64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	FUNCDATA	$6, <unlinkable>.MulAdd64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:22)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	R2, <unlinkable>.z+16(FP)
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	PCDATA	$3, $2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	$3584865303386914816, R2
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	EOR	R2, R1, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	EOR	R2, R0, R0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	PCDATA	$1, $0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	CALL	runtime.dmul64(SB)
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:24)	MOVD	<unlinkable>.z+16(FP), R2
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
<unlinkable>.Sub64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	TEXT	<unlinkable>.Sub64(SB), ABIInternal, $48-16
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
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	FUNCDATA	$5, <unlinkable>.Sub64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:27)	FUNCDATA	$6, <unlinkable>.Sub64.argliveinfo(SB)
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
<unlinkable>.Div64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	TEXT	<unlinkable>.Div64(SB), ABIInternal, $48-16
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
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	FUNCDATA	$5, <unlinkable>.Div64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:32)	FUNCDATA	$6, <unlinkable>.Div64.argliveinfo(SB)
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
<unlinkable>.Less64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	TEXT	<unlinkable>.Less64(SB), ABIInternal, $48-16
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
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	FUNCDATA	$5, <unlinkable>.Less64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:37)	FUNCDATA	$6, <unlinkable>.Less64.argliveinfo(SB)
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
<unlinkable>.Add128 STEXT size=416 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	TEXT	<unlinkable>.Add128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	BLS	388
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$5, <unlinkable>.Add128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$6, <unlinkable>.Add128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	AND	$6917529027641081856, R1, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R1, R3
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BNE	80
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	TST	$562949953421311, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BNE	328
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$4611686018427387904, R5
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R5, R4
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BEQ	328
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADDS	R2, R0, R0
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADC	ZR, ZR, R2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R2, R1, R1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R1, R4
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R0, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	JMP	368
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R1, R3, R5
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	TST	$562949953421311, R5
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BNE	328
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$4611686018427387904, R5
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R5, R4
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BEQ	328
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	AND	$6917529027641081856, R3, R4
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R5, R4
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BEQ	328
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$3476778912330022912, R4
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R1, R5
	0x007c 00124 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R3, R4
	0x0080 00128 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	UBFX	$49, R5, $14, R5
	0x0084 00132 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	UBFX	$49, R4, $14, R4
	0x0088 00136 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	SUB	R5, R4, R6
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	SUB	R4, R5, R7
	0x0090 00144 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R5, R4
	0x0094 00148 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	HI, R6, R7, R6
	0x0098 00152 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	$14, R6
	0x009c 00156 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	BHI	328
	0x00a0 00160 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R5, R4
	0x00a4 00164 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	HI, R2, R0, R4
	0x00a8 00168 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	HI, R0, R2, R2
	0x00ac 00172 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	HI, R1, R3, R5
	0x00b0 00176 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	HI, R3, R1, R7
	0x00b4 00180 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$go:string..gostring.120.3s366cuyPc63nbTckXogWg==(SB), R8
	0x00bc 00188 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	(R8)(R6<<3), R6
	0x00c0 00192 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MUL	R6, R4, R8
	0x00c4 00196 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	UMULH	R6, R4, R4
	0x00c8 00200 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R1, R3, R3
	0x00cc 00204 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	TBNZ	$63, R3, 236
	0x00d0 00208 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADDS	R2, R8, R0
	0x00d4 00212 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADC	ZR, ZR, R2
	0x00d8 00216 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADD	R2, R4, R2
	0x00dc 00220 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R5, R2, R1
	0x00e0 00224 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R1, R4
	0x00e4 00228 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R0, R1
	0x00e8 00232 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	JMP	368
	0x00ec 00236 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	SUB	R8, R2, R3
	0x00f0 00240 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	AND	$9223372036854775807, R5, R6
	0x00f4 00244 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	SUBS	R2, R8, R9
	0x00f8 00248 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	NGC	ZR, R10
	0x00fc 00252 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ADD	R4, R10, R10
	0x0100 00256 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	R8, R2
	0x0104 00260 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSET	HI, R2
	0x0108 00264 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	$0, R4
	0x010c 00268 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSET	EQ, R4
	0x0110 00272 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	AND	R2, R4, R2
	0x0114 00276 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	TSTW	$1, R2
	0x0118 00280 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	NE, R3, R9, R0
	0x011c 00284 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	NE, R5, R7, R2
	0x0120 00288 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	EQ, R10, ZR, R3
	0x0124 00292 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R0, R3, R4
	0x0128 00296 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	AND	$-9223372036854775808, R2, R2
	0x012c 00300 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CMP	$0, R4
	0x0130 00304 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CSEL	NE, R2, ZR, R2
	0x0134 00308 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R2, R6, R2
	0x0138 00312 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	ORR	R2, R3, R1
	0x013c 00316 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R1, R4
	0x0140 00320 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R0, R1
	0x0144 00324 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	JMP	368
	0x0148 00328 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$3476778912330022912, R4
	0x014c 00332 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R1, R5
	0x0150 00336 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R3, R4
	0x0154 00340 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R0, R1
	0x0158 00344 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R2, R3
	0x015c 00348 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R5, R0
	0x0160 00352 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R4, R2
	0x0164 00356 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	PCDATA	$1, $0
	0x0164 00356 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	CALL	runtime.dadd128(SB)
	0x0168 00360 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	$3476778912330022912, R4
	0x016c 00364 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	EOR	R4, R0, R4
	0x0170 00368 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R1, R0
	0x0174 00372 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	R4, R1
	0x0178 00376 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD	-8(RSP), R29
	0x017c 00380 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	MOVD.P	80(RSP), R30
	0x0180 00384 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	RET	(R30)
	0x0184 00388 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:46)	NOP
	0x0184 00388 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$1, $-1
	0x0184 00388 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-2
	0x0184 00388 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	STP	(R0, R1), 8(RSP)
	0x0188 00392 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	STP	(R2, R3), 24(RSP)
	0x018c 00396 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	R30, R3
	0x0190 00400 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	CALL	runtime.morestack_noctxt(SB)
	0x0194 00404 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-1
	0x0194 00404 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	LDP	8(RSP), (R0, R1)
	0x0198 00408 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	LDP	24(RSP), (R2, R3)
	0x019c 00412 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb e9 0b 00 54 fe 0f 1b f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 24 04 43 92 7f 00 01 eb  .....#..$.C.....
	0x0020 81 01 00 54 3f c0 40 f2 01 09 00 54 05 00 e8 d2  ...T?.@....T....
	0x0030 9f 00 05 eb a0 08 00 54 00 00 02 ab e2 03 1f 9a  .......T........
	0x0040 21 00 02 aa e4 03 01 aa e1 03 00 aa 49 00 00 14  !...........I...
	0x0050 65 00 01 aa bf c0 40 f2 81 07 00 54 05 00 e8 d2  e.....@....T....
	0x0060 9f 00 05 eb 20 07 00 54 64 04 43 92 9f 00 05 eb  .... ..Td.C.....
	0x0070 c0 06 00 54 04 08 e6 d2 25 00 04 ca 64 00 04 ca  ...T....%...d...
	0x0080 a5 f8 71 d3 84 f8 71 d3 86 00 05 cb a7 00 04 cb  ..q...q.........
	0x0090 9f 00 05 eb c6 80 87 9a df 38 00 f1 68 05 00 54  .........8..h..T
	0x00a0 9f 00 05 eb 44 80 80 9a 02 80 82 9a 25 80 83 9a  ....D.......%...
	0x00b0 67 80 81 9a 08 00 00 90 08 01 00 91 06 79 66 f8  g............yf.
	0x00c0 88 7c 06 9b 84 7c c6 9b 63 00 01 ca 03 01 f8 b7  .|...|..c.......
	0x00d0 00 01 02 ab e2 03 1f 9a 82 00 02 8b 41 00 05 aa  ............A...
	0x00e0 e4 03 01 aa e1 03 00 aa 22 00 00 14 43 00 08 cb  ........"...C...
	0x00f0 a6 f8 40 92 09 01 02 eb ea 03 1f da 4a 01 04 8b  ..@.........J...
	0x0100 5f 00 08 eb e2 97 9f 9a 9f 00 00 f1 e4 17 9f 9a  _...............
	0x0110 82 00 02 8a 5f 00 00 72 60 10 89 9a a2 10 87 9a  ...._..r`.......
	0x0120 43 01 9f 9a 64 00 00 aa 42 00 41 92 9f 00 00 f1  C...d...B.A.....
	0x0130 42 10 9f 9a c2 00 02 aa 61 00 02 aa e4 03 01 aa  B.......a.......
	0x0140 e1 03 00 aa 0b 00 00 14 04 08 e6 d2 25 00 04 ca  ............%...
	0x0150 64 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 05 aa  d...............
	0x0160 e2 03 04 aa 00 00 00 94 04 08 e6 d2 04 00 04 ca  ................
	0x0170 e0 03 01 aa e1 03 04 aa fd 83 5f f8 fe 07 45 f8  .........._...E.
	0x0180 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0190 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 99 ff ff 17  ......@...A.....
	rel 180+8 t=R_ADDRARM64 go:string..gostring.120.3s366cuyPc63nbTckXogWg==+0
	rel 356+4 t=R_CALLARM64 runtime.dadd128+0
	rel 400+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Sub128 STEXT size=432 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	TEXT	<unlinkable>.Sub128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	BLS	400
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$5, <unlinkable>.Sub128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	FUNCDATA	$6, <unlinkable>.Sub128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	$-9223372036854775808, R3, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	AND	$6917529027641081856, R1, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R4, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BNE	84
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	TST	$562949953421311, R1
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BNE	340
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$4611686018427387904, R4
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R4, R5
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BEQ	340
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ADDS	R2, R0, R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ADC	ZR, ZR, R2
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ORR	R2, R1, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R1, R4
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R0, R1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	JMP	380
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ORR	R4, R1, R6
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	TST	$562949953421311, R6
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BNE	340
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$4611686018427387904, R6
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R6, R5
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BEQ	340
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	AND	$6917529027641081856, R4, R5
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R6, R5
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BEQ	340
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$-5746593124524752896, R5
	0x007c 00124 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	R3, R5, R5
	0x0080 00128 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	UBFX	$49, R5, $14, R5
	0x0084 00132 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$3476778912330022912, R6
	0x0088 00136 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	R6, R1, R6
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	UBFX	$49, R6, $14, R6
	0x0090 00144 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	SUB	R6, R5, R7
	0x0094 00148 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	SUB	R5, R6, R8
	0x0098 00152 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R6, R5
	0x009c 00156 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	HI, R7, R8, R7
	0x00a0 00160 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	$14, R7
	0x00a4 00164 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BHI	340
	0x00a8 00168 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R6, R5
	0x00ac 00172 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	HI, R2, R0, R5
	0x00b0 00176 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	HI, R0, R2, R2
	0x00b4 00180 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	HI, R1, R4, R6
	0x00b8 00184 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	HI, R4, R1, R4
	0x00bc 00188 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	R3, R1, R3
	0x00c0 00192 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$go:string..gostring.120.3s366cuyPc63nbTckXogWg==(SB), R8
	0x00c8 00200 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	(R8)(R7<<3), R7
	0x00cc 00204 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MUL	R7, R5, R8
	0x00d0 00208 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	UMULH	R7, R5, R5
	0x00d4 00212 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	$-9223372036854775808, R3, R3
	0x00d8 00216 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	TBNZ	$63, R3, 248
	0x00dc 00220 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ADDS	R2, R8, R0
	0x00e0 00224 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ADC	ZR, ZR, R2
	0x00e4 00228 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ADD	R2, R5, R2
	0x00e8 00232 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ORR	R6, R2, R1
	0x00ec 00236 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R1, R4
	0x00f0 00240 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R0, R1
	0x00f4 00244 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	JMP	380
	0x00f8 00248 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	SUB	R8, R2, R3
	0x00fc 00252 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	AND	$9223372036854775807, R6, R7
	0x0100 00256 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	SUBS	R2, R8, R9
	0x0104 00260 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	NGC	ZR, R10
	0x0108 00264 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ADD	R5, R10, R10
	0x010c 00268 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R8, R2
	0x0110 00272 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSET	HI, R2
	0x0114 00276 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	$0, R5
	0x0118 00280 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSET	EQ, R5
	0x011c 00284 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	AND	R2, R5, R2
	0x0120 00288 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	TSTW	$1, R2
	0x0124 00292 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	NE, R3, R9, R0
	0x0128 00296 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	NE, R6, R4, R2
	0x012c 00300 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	EQ, R10, ZR, R3
	0x0130 00304 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ORR	R0, R3, R4
	0x0134 00308 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	AND	$-9223372036854775808, R2, R2
	0x0138 00312 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	$0, R4
	0x013c 00316 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CSEL	NE, R2, ZR, R2
	0x0140 00320 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ORR	R2, R7, R2
	0x0144 00324 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	ORR	R2, R3, R1
	0x0148 00328 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R1, R4
	0x014c 00332 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R0, R1
	0x0150 00336 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	JMP	380
	0x0154 00340 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$3476778912330022912, R4
	0x0158 00344 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	R4, R1, R5
	0x015c 00348 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	R4, R3, R4
	0x0160 00352 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R0, R1
	0x0164 00356 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R2, R3
	0x0168 00360 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R5, R0
	0x016c 00364 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R4, R2
	0x0170 00368 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$1, $0
	0x0170 00368 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CALL	runtime.dsub128(SB)
	0x0174 00372 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	$3476778912330022912, R4
	0x0178 00376 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	EOR	R4, R0, R4
	0x017c 00380 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R1, R0
	0x0180 00384 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R4, R1
	0x0184 00388 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	-8(RSP), R29
	0x0188 00392 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD.P	80(RSP), R30
	0x018c 00396 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	RET	(R30)
	0x0190 00400 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	NOP
	0x0190 00400 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$1, $-1
	0x0190 00400 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-2
	0x0190 00400 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	STP	(R0, R1), 8(RSP)
	0x0194 00404 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	STP	(R2, R3), 24(RSP)
	0x0198 00408 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	MOVD	R30, R3
	0x019c 00412 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	CALL	runtime.morestack_noctxt(SB)
	0x01a0 00416 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	PCDATA	$0, $-1
	0x01a0 00416 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	LDP	8(RSP), (R0, R1)
	0x01a4 00420 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	LDP	24(RSP), (R2, R3)
	0x01a8 00424 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:49)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 0c 00 54 fe 0f 1b f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 64 00 41 d2 25 04 43 92  .....#..d.A.%.C.
	0x0020 3f 00 04 eb 81 01 00 54 3f c0 40 f2 41 09 00 54  ?......T?.@.A..T
	0x0030 04 00 e8 d2 bf 00 04 eb e0 08 00 54 00 00 02 ab  ...........T....
	0x0040 e2 03 1f 9a 21 00 02 aa e4 03 01 aa e1 03 00 aa  ....!...........
	0x0050 4b 00 00 14 26 00 04 aa df c0 40 f2 c1 07 00 54  K...&.....@....T
	0x0060 06 00 e8 d2 bf 00 06 eb 60 07 00 54 85 04 43 92  ........`..T..C.
	0x0070 bf 00 06 eb 00 07 00 54 05 08 f6 d2 a5 00 03 ca  .......T........
	0x0080 a5 f8 71 d3 06 08 e6 d2 26 00 06 ca c6 f8 71 d3  ..q.....&.....q.
	0x0090 a7 00 06 cb c8 00 05 cb bf 00 06 eb e7 80 88 9a  ................
	0x00a0 ff 38 00 f1 88 05 00 54 bf 00 06 eb 45 80 80 9a  .8.....T....E...
	0x00b0 02 80 82 9a 26 80 84 9a 84 80 81 9a 23 00 03 ca  ....&.......#...
	0x00c0 08 00 00 90 08 01 00 91 07 79 67 f8 a8 7c 07 9b  .........yg..|..
	0x00d0 a5 7c c7 9b 63 00 41 d2 03 01 f8 b7 00 01 02 ab  .|..c.A.........
	0x00e0 e2 03 1f 9a a2 00 02 8b 41 00 06 aa e4 03 01 aa  ........A.......
	0x00f0 e1 03 00 aa 22 00 00 14 43 00 08 cb c7 f8 40 92  ...."...C.....@.
	0x0100 09 01 02 eb ea 03 1f da 4a 01 05 8b 5f 00 08 eb  ........J..._...
	0x0110 e2 97 9f 9a bf 00 00 f1 e5 17 9f 9a a2 00 02 8a  ................
	0x0120 5f 00 00 72 60 10 89 9a c2 10 84 9a 43 01 9f 9a  _..r`.......C...
	0x0130 64 00 00 aa 42 00 41 92 9f 00 00 f1 42 10 9f 9a  d...B.A.....B...
	0x0140 e2 00 02 aa 61 00 02 aa e4 03 01 aa e1 03 00 aa  ....a...........
	0x0150 0b 00 00 14 04 08 e6 d2 25 00 04 ca 64 00 04 ca  ........%...d...
	0x0160 e1 03 00 aa e3 03 02 aa e0 03 05 aa e2 03 04 aa  ................
	0x0170 00 00 00 94 04 08 e6 d2 04 00 04 ca e0 03 01 aa  ................
	0x0180 e1 03 04 aa fd 83 5f f8 fe 07 45 f8 c0 03 5f d6  ......_...E..._.
	0x0190 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa 00 00 00 94  ................
	0x01a0 e0 87 40 a9 e2 8f 41 a9 96 ff ff 17 00 00 00 00  ..@...A.........
	rel 192+8 t=R_ADDRARM64 go:string..gostring.120.3s366cuyPc63nbTckXogWg==+0
	rel 368+4 t=R_CALLARM64 runtime.dsub128+0
	rel 412+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Mul128 STEXT size=288 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	TEXT	<unlinkable>.Mul128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	BLS	256
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	FUNCDATA	$5, <unlinkable>.Mul128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	FUNCDATA	$6, <unlinkable>.Mul128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	ORR	R1, R3, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	TST	$562949953421311, R4
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	BNE	192
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	AND	$6917529027641081856, R1, R4
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$4611686018427387904, R5
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CMP	R5, R4
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	BEQ	192
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	AND	$6917529027641081856, R3, R4
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CMP	R5, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	BEQ	192
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$3476778912330022912, R4
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R4, R1, R5
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R4, R3, R6
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	UBFX	$49, R5, $14, R5
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	UBFX	$49, R6, $14, R6
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	ADD	R6, R5, R5
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$6176, R6
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	SUB	R6, R5, R5
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$12287, R6
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CMP	R6, R5
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	BHI	192
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	UMULH	R2, R0, R6
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MUL	R2, R0, R7
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$542101086242752, R8
	0x0084 00132 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CMP	R8, R6
	0x0088 00136 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	BLO	168
	0x008c 00140 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CSET	EQ, R8
	0x0090 00144 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$4003012203950112767, R9
	0x0098 00152 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CMP	R9, R7
	0x009c 00156 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CSET	LS, R9
	0x00a0 00160 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	AND	R9, R8, R8
	0x00a4 00164 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	TBZ	$0, R8, 192
	0x00a8 00168 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R1, R3, R2
	0x00ac 00172 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	AND	$-9223372036854775808, R2, R2
	0x00b0 00176 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	ORR	R5<<49, R2, R2
	0x00b4 00180 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R4, R2, R2
	0x00b8 00184 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	ORR	R2, R6, R1
	0x00bc 00188 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	JMP	240
	0x00c0 00192 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$3476778912330022912, R4
	0x00c4 00196 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R4, R1, R5
	0x00c8 00200 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R4, R3, R4
	0x00cc 00204 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R0, R1
	0x00d0 00208 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R2, R3
	0x00d4 00212 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R5, R0
	0x00d8 00216 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R4, R2
	0x00dc 00220 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	PCDATA	$1, $0
	0x00dc 00220 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	CALL	runtime.dmul128(SB)
	0x00e0 00224 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	$3476778912330022912, R4
	0x00e4 00228 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	EOR	R4, R0, R4
	0x00e8 00232 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R1, R7
	0x00ec 00236 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R4, R1
	0x00f0 00240 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	R7, R0
	0x00f4 00244 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD	-8(RSP), R29
	0x00f8 00248 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	MOVD.P	80(RSP), R30
	0x00fc 00252 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	RET	(R30)
	0x0100 00256 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:59)	NOP
	0x0100 00256 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$1, $-1
	0x0100 00256 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$0, $-2
	0x0100 00256 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	STP	(R0, R1), 8(RSP)
	0x0104 00260 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	STP	(R2, R3), 24(RSP)
	0x0108 00264 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	MOVD	R30, R3
	0x010c 00268 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	CALL	runtime.morestack_noctxt(SB)
	0x0110 00272 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	PCDATA	$0, $-1
	0x0110 00272 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	LDP	8(RSP), (R0, R1)
	0x0114 00276 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	LDP	24(RSP), (R2, R3)
	0x0118 00280 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:56)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 07 00 54 fe 0f 1b f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 64 00 01 aa 9f c0 40 f2  .....#..d.....@.
	0x0020 01 05 00 54 24 04 43 92 05 00 e8 d2 9f 00 05 eb  ...T$.C.........
	0x0030 80 04 00 54 64 04 43 92 9f 00 05 eb 20 04 00 54  ...Td.C..... ..T
	0x0040 04 08 e6 d2 25 00 04 ca 66 00 04 ca a5 f8 71 d3  ....%...f.....q.
	0x0050 c6 f8 71 d3 a5 00 06 8b 06 04 83 d2 a5 00 06 cb  ..q.............
	0x0060 e6 ff 85 d2 bf 00 06 eb c8 02 00 54 06 7c c2 9b  ...........T.|..
	0x0070 07 7c 02 9b 08 f8 90 d2 a8 d5 b7 f2 28 a1 dd f2  .|..........(...
	0x0080 28 00 e0 f2 df 00 08 eb 03 01 00 54 e8 17 9f 9a  (..........T....
	0x0090 89 33 ce 92 a9 f1 e6 f2 ff 00 09 eb e9 87 9f 9a  .3..............
	0x00a0 08 01 09 8a e8 00 00 36 62 00 01 ca 42 00 41 92  .......6b...B.A.
	0x00b0 42 c4 05 aa 42 00 04 ca c1 00 02 aa 0d 00 00 14  B...B...........
	0x00c0 04 08 e6 d2 25 00 04 ca 64 00 04 ca e1 03 00 aa  ....%...d.......
	0x00d0 e3 03 02 aa e0 03 05 aa e2 03 04 aa 00 00 00 94  ................
	0x00e0 04 08 e6 d2 04 00 04 ca e7 03 01 aa e1 03 04 aa  ................
	0x00f0 e0 03 07 aa fd 83 5f f8 fe 07 45 f8 c0 03 5f d6  ......_...E..._.
	0x0100 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa 00 00 00 94  ................
	0x0110 e0 87 40 a9 e2 8f 41 a9 ba ff ff 17 00 00 00 00  ..@...A.........
	rel 220+4 t=R_CALLARM64 runtime.dmul128+0
	rel 268+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Eq128 STEXT size=96 align=0x0 args=0x20 locals=0x38 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	TEXT	<unlinkable>.Eq128(SB), ABIInternal, $64-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	BLS	68
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD.W	R30, -64(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	FUNCDATA	$5, <unlinkable>.Eq128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	FUNCDATA	$6, <unlinkable>.Eq128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	EOR	R4, R3, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	EOR	R4, R1, R4
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R0, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R2, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R5, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$1, $0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	CALL	runtime.deq128(SB)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	-8(RSP), R29
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD.P	64(RSP), R30
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	RET	(R30)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	NOP
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	PCDATA	$1, $-1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	PCDATA	$0, $-2
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	STP	(R0, R1), 8(RSP)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	STP	(R2, R3), 24(RSP)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	MOVD	R30, R3
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	CALL	runtime.morestack_noctxt(SB)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	PCDATA	$0, $-1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	LDP	8(RSP), (R0, R1)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	LDP	24(RSP), (R2, R3)
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:62)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb e9 01 00 54 fe 0f 1c f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 65 00 04 ca  .....#......e...
	0x0020 24 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 04 aa  $...............
	0x0030 e2 03 05 aa 00 00 00 94 fd 83 5f f8 fe 07 44 f8  .........._...D.
	0x0040 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0050 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 e9 ff ff 17  ......@...A.....
	rel 52+4 t=R_CALLARM64 runtime.deq128+0
	rel 80+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Zero64 STEXT size=96 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	TEXT	<unlinkable>.Zero64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	FUNCDATA	$5, <unlinkable>.Zero64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	FUNCDATA	$6, <unlinkable>.Zero64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	$3584865303386914816, R1
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	EOR	R1, R0, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	AND	$2251799813685247, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	AND	$6917529027641081856, R1, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	AND	$8646911284551352320, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	$6917529027641081856, R5
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CMP	R5, R3
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CSET	EQ, R3
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CSET	NE, R5
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	$992800745259007, R6
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CMP	R6, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CSET	HI, R2
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	AND	R3, R2, R2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	$8646911284551352320, R3
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CMP	R3, R4
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CSET	NE, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	TST	$9007199254740991, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CSET	EQ, R1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	AND	R5, R1, R1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	ORR	R2, R1, R1
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	AND	R3, R1, R0
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	RET	(R30)
	0x0000 01 38 e6 d2 01 00 01 ca 22 c8 40 92 23 04 43 92  .8......".@.#.C.
	0x0010 24 0c 45 92 05 00 ec d2 7f 00 05 eb e3 17 9f 9a  $.E.............
	0x0020 e5 07 9f 9a e6 07 b2 92 46 de d0 f2 66 00 e0 f2  ........F...f...
	0x0030 5f 00 06 eb e2 97 9f 9a 42 00 03 8a 03 00 ef d2  _.......B.......
	0x0040 9f 00 03 eb e3 07 9f 9a 3f d0 40 f2 e1 17 9f 9a  ........?.@.....
	0x0050 21 00 05 8a 21 00 02 aa 20 00 03 8a c0 03 5f d6  !...!... ....._.
<unlinkable>.Nonzero64 STEXT size=112 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	TEXT	<unlinkable>.Nonzero64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	FUNCDATA	$5, <unlinkable>.Nonzero64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	FUNCDATA	$6, <unlinkable>.Nonzero64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	$3584865303386914816, R1
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	EOR	R1, R0, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	AND	$2251799813685247, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	AND	$6917529027641081856, R1, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	AND	$8646911284551352320, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	$6917529027641081856, R5
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CMP	R5, R3
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CSET	EQ, R3
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CSET	NE, R5
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	$992800745259007, R6
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CMP	R6, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CSET	HI, R2
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	AND	R3, R2, R2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	$8646911284551352320, R3
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CMP	R3, R4
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CSET	NE, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	TST	$9007199254740991, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CSET	EQ, R1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	AND	R5, R1, R1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	ORR	R2, R1, R1
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	AND	R3, R1, R1
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	EOR	$1, R1, R0
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	RET	(R30)
	0x0000 01 38 e6 d2 01 00 01 ca 22 c8 40 92 23 04 43 92  .8......".@.#.C.
	0x0010 24 0c 45 92 05 00 ec d2 7f 00 05 eb e3 17 9f 9a  $.E.............
	0x0020 e5 07 9f 9a e6 07 b2 92 46 de d0 f2 66 00 e0 f2  ........F...f...
	0x0030 5f 00 06 eb e2 97 9f 9a 42 00 03 8a 03 00 ef d2  _.......B.......
	0x0040 9f 00 03 eb e3 07 9f 9a 3f d0 40 f2 e1 17 9f 9a  ........?.@.....
	0x0050 21 00 05 8a 21 00 02 aa 21 00 03 8a 20 00 40 d2  !...!...!... .@.
	0x0060 c0 03 5f d6 00 00 00 00 00 00 00 00 00 00 00 00  .._.............
<unlinkable>.Zero128 STEXT size=128 align=0x0 args=0x10 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	TEXT	<unlinkable>.Zero128(SB), LEAF|NOFRAME|ABIInternal, $0-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	FUNCDATA	$5, <unlinkable>.Zero128.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	FUNCDATA	$6, <unlinkable>.Zero128.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	$3476778912330022912, R2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	EOR	R2, R1, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	AND	$562949953421311, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	ORR	R0, R2, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	AND	$6917529027641081856, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	AND	$8646911284551352320, R1, R1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	$542101086242752, R5
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CMP	R5, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CSET	HI, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CSET	EQ, R5
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	$6917529027641081856, R6
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CMP	R6, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CSET	EQ, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	$8646911284551352320, R6
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CMP	R6, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CSET	NE, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	$4003012203950112767, R6
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CMP	R6, R0
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CSET	HI, R6
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	AND	R6, R5, R5
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	ORR	R2, R5, R2
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	ORR	R4, R2, R2
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CMP	$0, R3
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CSET	EQ, R3
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	ORR	R2, R3, R2
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	AND	R2, R1, R0
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	RET	(R30)
	0x0000 02 08 e6 d2 21 00 02 ca 22 c0 40 92 43 00 00 aa  ....!...".@.C...
	0x0010 24 04 43 92 21 0c 45 92 05 f8 90 d2 a5 d5 b7 f2  $.C.!.E.........
	0x0020 25 a1 dd f2 25 00 e0 f2 5f 00 05 eb e2 97 9f 9a  %...%..._.......
	0x0030 e5 17 9f 9a 06 00 ec d2 9f 00 06 eb e4 17 9f 9a  ................
	0x0040 06 00 ef d2 3f 00 06 eb e1 07 9f 9a 86 33 ce 92  ....?........3..
	0x0050 a6 f1 e6 f2 1f 00 06 eb e6 97 9f 9a a5 00 06 8a  ................
	0x0060 a2 00 02 aa 42 00 04 aa 7f 00 00 f1 e3 17 9f 9a  ....B...........
	0x0070 62 00 02 aa 20 00 02 8a c0 03 5f d6 00 00 00 00  b... ....._.....
<unlinkable>.Nonzero128 STEXT size=128 align=0x0 args=0x10 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	TEXT	<unlinkable>.Nonzero128(SB), LEAF|NOFRAME|ABIInternal, $0-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	FUNCDATA	$5, <unlinkable>.Nonzero128.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	FUNCDATA	$6, <unlinkable>.Nonzero128.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:85)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	$3476778912330022912, R2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	EOR	R2, R1, R1
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	AND	$562949953421311, R1, R2
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	ORR	R0, R2, R3
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	AND	$6917529027641081856, R1, R4
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	AND	$8646911284551352320, R1, R1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	$542101086242752, R5
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CMP	R5, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CSET	HI, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CSET	EQ, R5
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	$6917529027641081856, R6
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CMP	R6, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CSET	EQ, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	$8646911284551352320, R6
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CMP	R6, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CSET	NE, R1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	MOVD	$4003012203950112767, R6
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CMP	R6, R0
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CSET	HI, R6
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	AND	R6, R5, R5
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	ORR	R2, R5, R2
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	ORR	R4, R2, R2
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CMP	$0, R3
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	CSET	EQ, R3
	0x0070 00112 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	ORR	R2, R3, R2
	0x0074 00116 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	AND	R2, R1, R1
	0x0078 00120 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	EOR	$1, R1, R0
	0x007c 00124 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:88)	RET	(R30)
	0x0000 02 08 e6 d2 21 00 02 ca 22 c0 40 92 43 00 00 aa  ....!...".@.C...
	0x0010 24 04 43 92 21 0c 45 92 05 f8 90 d2 a5 d5 b7 f2  $.C.!.E.........
	0x0020 25 a1 dd f2 25 00 e0 f2 5f 00 05 eb e2 97 9f 9a  %...%..._.......
	0x0030 e5 17 9f 9a 06 00 ec d2 9f 00 06 eb e4 17 9f 9a  ................
	0x0040 06 00 ef d2 3f 00 06 eb e1 07 9f 9a 86 33 ce 92  ....?........3..
	0x0050 a6 f1 e6 f2 1f 00 06 eb e6 97 9f 9a a5 00 06 8a  ................
	0x0060 a2 00 02 aa 42 00 04 aa 7f 00 00 f1 e3 17 9f 9a  ....B...........
	0x0070 62 00 02 aa 21 00 02 8a 20 00 40 d2 c0 03 5f d6  b...!... .@..._.
<unlinkable>.Widen STEXT size=96 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	TEXT	<unlinkable>.Widen(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	BLS	64
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	FUNCDATA	$5, <unlinkable>.Widen.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	FUNCDATA	$6, <unlinkable>.Widen.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	EOR	R0, R1, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	CALL	runtime.dd64tod128(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	$3476778912330022912, R2
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	EOR	R2, R0, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	R1, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	R2, R1
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD	-8(RSP), R29
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	MOVD.P	48(RSP), R30
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	RET	(R30)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:93)	NOP
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	PCDATA	$1, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	PCDATA	$0, $-2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	MOVD	R0, 8(RSP)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	MOVD	R30, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	CALL	runtime.morestack_noctxt(SB)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	PCDATA	$0, $-1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	MOVD	8(RSP), R0
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:91)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 20 00 00 ca  .....#...8.. ...
	0x0020 00 00 00 94 02 08 e6 d2 02 00 02 ca e0 03 01 aa  ................
	0x0030 e1 03 02 aa fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0040 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0050 ec ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64tod128+0
	rel 72+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Narrow STEXT size=96 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	TEXT	<unlinkable>.Narrow(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	BLS	64
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	FUNCDATA	$5, <unlinkable>.Narrow.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	FUNCDATA	$6, <unlinkable>.Narrow.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	$3476778912330022912, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	EOR	R1, R2, R2
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	R0, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	R2, R0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	PCDATA	$1, $0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	CALL	runtime.dd128tod64(SB)
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	$3584865303386914816, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	EOR	R2, R0, R0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD	-8(RSP), R29
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	MOVD.P	48(RSP), R30
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	RET	(R30)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:98)	NOP
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	PCDATA	$1, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	PCDATA	$0, $-2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	STP	(R0, R1), 8(RSP)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	MOVD	R30, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	CALL	runtime.morestack_noctxt(SB)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	PCDATA	$0, $-1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	LDP	8(RSP), (R0, R1)
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:96)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 08 e6 d2 42 00 01 ca  .....#......B...
	0x0020 e1 03 00 aa e0 03 02 aa 00 00 00 94 02 38 e6 d2  .............8..
	0x0030 00 00 02 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0040 e0 87 00 a9 e3 03 1e aa 00 00 00 94 e0 87 40 a9  ..............@.
	0x0050 ec ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 40+4 t=R_CALLARM64 runtime.dd128tod64+0
	rel 72+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.FromInt STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	TEXT	<unlinkable>.FromInt(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	FUNCDATA	$5, <unlinkable>.FromInt.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	FUNCDATA	$6, <unlinkable>.FromInt.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	PCDATA	$1, $0
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	CALL	runtime.di64tod64(SB)
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD	$3584865303386914816, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	EOR	R1, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:103)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:101)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 00 00 00 94 01 38 e6 d2  .....#.......8..
	0x0020 00 00 01 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 24+4 t=R_CALLARM64 runtime.di64tod64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.ToInt STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	TEXT	<unlinkable>.ToInt(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	FUNCDATA	$5, <unlinkable>.ToInt.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	FUNCDATA	$6, <unlinkable>.ToInt.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	CALL	runtime.dd64toi64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:108)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:106)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 00 00 01 ca  .....#...8......
	0x0020 00 00 00 94 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64toi64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Min64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	TEXT	<unlinkable>.Min64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	FUNCDATA	$5, <unlinkable>.Min64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	FUNCDATA	$6, <unlinkable>.Min64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	CALL	runtime.dmin64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	$3584865303386914816, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	EOR	R2, R0, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	MOVD.P	48(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:113)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:111)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 02 38 e6 d2 00 00 02 ca  .........8......
	0x0030 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6 e0 87 00 a9  .._...C..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 36+4 t=R_CALLARM64 runtime.dmin64+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Neg64 STEXT size=16 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	TEXT	<unlinkable>.Neg64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	FUNCDATA	$5, <unlinkable>.Neg64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	FUNCDATA	$6, <unlinkable>.Neg64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:116)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:118)	EOR	$-9223372036854775808, R0, R0
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:118)	RET	(R30)
	0x0000 00 00 41 d2 c0 03 5f d6 00 00 00 00 00 00 00 00  ..A..._.........
<unlinkable>.ToFloat STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	TEXT	<unlinkable>.ToFloat(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	FUNCDATA	$5, <unlinkable>.ToFloat.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	FUNCDATA	$6, <unlinkable>.ToFloat.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	CALL	runtime.dd64tof64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:124)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:121)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 00 00 01 ca  .....#...8......
	0x0020 00 00 00 94 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64tof64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
go:cuinfo.producer.<unlinkable> SDWARFCUINFO dupok size=0 align=0x0
	0x0000 72 65 67 61 62 69                                regabi
go:cuinfo.packagename.<unlinkable> SDWARFCUINFO dupok size=0 align=0x0
	0x0000 63 6f 64 65 67 65 6e                             codegen
go:string..gostring.120.3s366cuyPc63nbTckXogWg== SRODATA dupok size=120 align=0x1
	0x0000 01 00 00 00 00 00 00 00 0a 00 00 00 00 00 00 00  ................
	0x0010 64 00 00 00 00 00 00 00 e8 03 00 00 00 00 00 00  d...............
	0x0020 10 27 00 00 00 00 00 00 a0 86 01 00 00 00 00 00  .'..............
	0x0030 40 42 0f 00 00 00 00 00 80 96 98 00 00 00 00 00  @B..............
	0x0040 00 e1 f5 05 00 00 00 00 00 ca 9a 3b 00 00 00 00  ...........;....
	0x0050 00 e4 0b 54 02 00 00 00 00 e8 76 48 17 00 00 00  ...T......vH....
	0x0060 00 10 a5 d4 e8 00 00 00 00 a0 72 4e 18 09 00 00  ..........rN....
	0x0070 00 40 7a 10 f3 5a 00 00                          .@z..Z..
gclocals·g5+hNtRBP6YXNjfog7aZjQ== SRODATA dupok size=8 align=0x4
	0x0000 01 00 00 00 00 00 00 00                          ........
<unlinkable>.Add64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
<unlinkable>.Add64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.MulAdd64.arginfo1 SRODATA static dupok size=7 align=0x1
	0x0000 00 08 08 08 10 08 ff                             .......
<unlinkable>.MulAdd64.argliveinfo SRODATA static dupok size=3 align=0x1
	0x0000 00 00 04                                         ...
<unlinkable>.Sub64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
<unlinkable>.Sub64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Div64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
<unlinkable>.Div64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Less64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
<unlinkable>.Less64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Add128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
<unlinkable>.Add128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Sub128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
<unlinkable>.Sub128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Mul128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
<unlinkable>.Mul128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Eq128.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 10 10 10 ff                                   .....
<unlinkable>.Eq128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Zero64.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.Zero64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Nonzero64.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.Nonzero64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Zero128.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 10 ff                                         ...
<unlinkable>.Zero128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Nonzero128.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 10 ff                                         ...
<unlinkable>.Nonzero128.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Widen.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.Widen.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Narrow.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 10 ff                                         ...
<unlinkable>.Narrow.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.FromInt.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.FromInt.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.ToInt.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.ToInt.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Min64.arginfo1 SRODATA static dupok size=5 align=0x1
	0x0000 00 08 08 08 ff                                   .....
<unlinkable>.Min64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.Neg64.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.Neg64.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
<unlinkable>.ToFloat.arginfo1 SRODATA static dupok size=3 align=0x1
	0x0000 00 08 ff                                         ...
<unlinkable>.ToFloat.argliveinfo SRODATA static dupok size=2 align=0x1
	0x0000 00 00                                            ..
