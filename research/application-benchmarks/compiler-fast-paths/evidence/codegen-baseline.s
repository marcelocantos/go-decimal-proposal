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
<unlinkable>.Add128 STEXT size=112 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	TEXT	<unlinkable>.Add128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	BLS	84
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$5, <unlinkable>.Add128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	FUNCDATA	$6, <unlinkable>.Add128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	EOR	R4, R3, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	EOR	R4, R1, R4
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	R0, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	R2, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	R5, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	PCDATA	$1, $0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	CALL	runtime.dadd128(SB)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	$3476778912330022912, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	EOR	R4, R0, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	R1, R0
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	R4, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD	-8(RSP), R29
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	MOVD.P	80(RSP), R30
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	RET	(R30)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:45)	NOP
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$1, $-1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-2
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	STP	(R0, R1), 8(RSP)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	STP	(R2, R3), 24(RSP)
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	MOVD	R30, R3
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	CALL	runtime.morestack_noctxt(SB)
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	PCDATA	$0, $-1
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	LDP	8(RSP), (R0, R1)
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	LDP	24(RSP), (R2, R3)
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:42)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 69 02 00 54 fe 0f 1b f8  ..@..c0.i..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 65 00 04 ca  .....#......e...
	0x0020 24 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 04 aa  $...............
	0x0030 e2 03 05 aa 00 00 00 94 04 08 e6 d2 04 00 04 ca  ................
	0x0040 e0 03 01 aa e1 03 04 aa fd 83 5f f8 fe 07 45 f8  .........._...E.
	0x0050 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0060 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 e5 ff ff 17  ......@...A.....
	rel 52+4 t=R_CALLARM64 runtime.dadd128+0
	rel 96+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Mul128 STEXT size=112 align=0x0 args=0x20 locals=0x48 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	TEXT	<unlinkable>.Mul128(SB), ABIInternal, $80-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	BLS	84
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	MOVD.W	R30, -80(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	FUNCDATA	$5, <unlinkable>.Mul128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	FUNCDATA	$6, <unlinkable>.Mul128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	EOR	R4, R3, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	EOR	R4, R1, R4
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	R0, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	R2, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	R5, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	PCDATA	$1, $0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	CALL	runtime.dmul128(SB)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	$3476778912330022912, R4
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	EOR	R4, R0, R4
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	R1, R0
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	R4, R1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD	-8(RSP), R29
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	MOVD.P	80(RSP), R30
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	RET	(R30)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:50)	NOP
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	PCDATA	$1, $-1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	PCDATA	$0, $-2
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	STP	(R0, R1), 8(RSP)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	STP	(R2, R3), 24(RSP)
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	MOVD	R30, R3
	0x0060 00096 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	CALL	runtime.morestack_noctxt(SB)
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	PCDATA	$0, $-1
	0x0064 00100 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	LDP	8(RSP), (R0, R1)
	0x0068 00104 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	LDP	24(RSP), (R2, R3)
	0x006c 00108 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:48)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 69 02 00 54 fe 0f 1b f8  ..@..c0.i..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 65 00 04 ca  .....#......e...
	0x0020 24 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 04 aa  $...............
	0x0030 e2 03 05 aa 00 00 00 94 04 08 e6 d2 04 00 04 ca  ................
	0x0040 e0 03 01 aa e1 03 04 aa fd 83 5f f8 fe 07 45 f8  .........._...E.
	0x0050 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0060 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 e5 ff ff 17  ......@...A.....
	rel 52+4 t=R_CALLARM64 runtime.dmul128+0
	rel 96+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Eq128 STEXT size=96 align=0x0 args=0x20 locals=0x38 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	TEXT	<unlinkable>.Eq128(SB), ABIInternal, $64-32
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	BLS	68
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD.W	R30, -64(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	FUNCDATA	$5, <unlinkable>.Eq128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	FUNCDATA	$6, <unlinkable>.Eq128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	EOR	R4, R3, R5
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	EOR	R4, R1, R4
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD	R0, R1
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD	R2, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD	R5, R2
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	PCDATA	$1, $0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	CALL	runtime.deq128(SB)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD	-8(RSP), R29
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	MOVD.P	64(RSP), R30
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	RET	(R30)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:55)	NOP
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$1, $-1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$0, $-2
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	STP	(R0, R1), 8(RSP)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	STP	(R2, R3), 24(RSP)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	MOVD	R30, R3
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	CALL	runtime.morestack_noctxt(SB)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	PCDATA	$0, $-1
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	LDP	8(RSP), (R0, R1)
	0x0058 00088 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	LDP	24(RSP), (R2, R3)
	0x005c 00092 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:53)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb e9 01 00 54 fe 0f 1c f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 65 00 04 ca  .....#......e...
	0x0020 24 00 04 ca e1 03 00 aa e3 03 02 aa e0 03 04 aa  $...............
	0x0030 e2 03 05 aa 00 00 00 94 fd 83 5f f8 fe 07 44 f8  .........._...D.
	0x0040 c0 03 5f d6 e0 87 00 a9 e2 8f 01 a9 e3 03 1e aa  .._.............
	0x0050 00 00 00 94 e0 87 40 a9 e2 8f 41 a9 e9 ff ff 17  ......@...A.....
	rel 52+4 t=R_CALLARM64 runtime.deq128+0
	rel 80+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Zero64 STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	TEXT	<unlinkable>.Zero64(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	FUNCDATA	$5, <unlinkable>.Zero64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	FUNCDATA	$6, <unlinkable>.Zero64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	CALL	runtime.deq64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:61)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:58)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 00 00 01 ca  .....#...8......
	0x0020 00 00 00 94 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.deq64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Nonzero64 STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	TEXT	<unlinkable>.Nonzero64(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	BLS	56
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	FUNCDATA	$5, <unlinkable>.Nonzero64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	FUNCDATA	$6, <unlinkable>.Nonzero64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	EOR	R2, R0, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	MOVD	$3566850904877432832, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	CALL	runtime.deq64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	EOR	$1, R0, R0
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	MOVD	-8(RSP), R29
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	MOVD.P	48(RSP), R30
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	RET	(R30)
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:67)	NOP
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$1, $-1
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$0, $-2
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R0, 8(RSP)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	R30, R3
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	CALL	runtime.morestack_noctxt(SB)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	PCDATA	$0, $-1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	MOVD	8(RSP), R0
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:64)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 89 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 01 00 02 ca  .....#...8......
	0x0020 00 30 e6 d2 00 00 00 94 00 00 40 d2 fd 83 5f f8  .0........@..._.
	0x0030 fe 07 43 f8 c0 03 5f d6 e0 07 00 f9 e3 03 1e aa  ..C..._.........
	0x0040 00 00 00 94 e0 07 40 f9 ee ff ff 17 00 00 00 00  ......@.........
	rel 36+4 t=R_CALLARM64 runtime.deq64+0
	rel 64+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Zero128 STEXT size=80 align=0x0 args=0x10 locals=0x38 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	TEXT	<unlinkable>.Zero128(SB), ABIInternal, $64-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD.W	R30, -64(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	FUNCDATA	$5, <unlinkable>.Zero128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	FUNCDATA	$6, <unlinkable>.Zero128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	EOR	R4, R1, R2
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	MOVD	ZR, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	MOVD	R0, R3
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	MOVD	R4, R0
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	PCDATA	$1, $0
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	CALL	runtime.deq128(SB)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	MOVD.P	64(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:73)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:70)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1c f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 22 00 04 ca  .....#......"...
	0x0020 e1 03 1f aa e3 03 00 aa e0 03 04 aa 00 00 00 94  ................
	0x0030 fd 83 5f f8 fe 07 44 f8 c0 03 5f d6 e0 87 00 a9  .._...D..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 44+4 t=R_CALLARM64 runtime.deq128+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Nonzero128 STEXT size=96 align=0x0 args=0x10 locals=0x38 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	TEXT	<unlinkable>.Nonzero128(SB), ABIInternal, $64-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	BLS	68
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD.W	R30, -64(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	FUNCDATA	$5, <unlinkable>.Nonzero128.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	FUNCDATA	$6, <unlinkable>.Nonzero128.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD	$3476778912330022912, R4
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	EOR	R4, R1, R4
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD	R0, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD	$3475653012423180288, R2
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD	ZR, R3
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD	R4, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	PCDATA	$1, $0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	CALL	runtime.deq128(SB)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	EOR	$1, R0, R0
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD	-8(RSP), R29
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	MOVD.P	64(RSP), R30
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	RET	(R30)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:79)	NOP
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	PCDATA	$1, $-1
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	PCDATA	$0, $-2
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	STP	(R0, R1), 8(RSP)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	MOVD	R30, R3
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	CALL	runtime.morestack_noctxt(SB)
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	PCDATA	$0, $-1
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	LDP	8(RSP), (R0, R1)
	0x0054 00084 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:76)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb e9 01 00 54 fe 0f 1c f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 04 08 e6 d2 24 00 04 ca  .....#......$...
	0x0020 e1 03 00 aa 82 07 e6 d2 e3 03 1f aa e0 03 04 aa  ................
	0x0030 00 00 00 94 00 00 40 d2 fd 83 5f f8 fe 07 44 f8  ......@..._...D.
	0x0040 c0 03 5f d6 e0 87 00 a9 e3 03 1e aa 00 00 00 94  .._.............
	0x0050 e0 87 40 a9 eb ff ff 17 00 00 00 00 00 00 00 00  ..@.............
	rel 48+4 t=R_CALLARM64 runtime.deq128+0
	rel 76+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Widen STEXT size=96 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	TEXT	<unlinkable>.Widen(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	BLS	64
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	FUNCDATA	$5, <unlinkable>.Widen.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	FUNCDATA	$6, <unlinkable>.Widen.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	EOR	R0, R1, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	CALL	runtime.dd64tod128(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	MOVD	$3476778912330022912, R2
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	EOR	R2, R0, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	MOVD	R1, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	MOVD	R2, R1
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	MOVD	-8(RSP), R29
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	MOVD.P	48(RSP), R30
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	RET	(R30)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:84)	NOP
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	PCDATA	$1, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	PCDATA	$0, $-2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	R0, 8(RSP)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	R30, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	CALL	runtime.morestack_noctxt(SB)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	PCDATA	$0, $-1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	MOVD	8(RSP), R0
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:82)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 20 00 00 ca  .....#...8.. ...
	0x0020 00 00 00 94 02 08 e6 d2 02 00 02 ca e0 03 01 aa  ................
	0x0030 e1 03 02 aa fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0040 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0050 ec ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64tod128+0
	rel 72+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Narrow STEXT size=96 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	TEXT	<unlinkable>.Narrow(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	BLS	64
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	FUNCDATA	$5, <unlinkable>.Narrow.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	FUNCDATA	$6, <unlinkable>.Narrow.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	MOVD	$3476778912330022912, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	EOR	R1, R2, R2
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	MOVD	R0, R1
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	MOVD	R2, R0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	PCDATA	$1, $0
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	CALL	runtime.dd128tod64(SB)
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	MOVD	$3584865303386914816, R2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	EOR	R2, R0, R0
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	MOVD	-8(RSP), R29
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	MOVD.P	48(RSP), R30
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	RET	(R30)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:89)	NOP
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	PCDATA	$1, $-1
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	PCDATA	$0, $-2
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	STP	(R0, R1), 8(RSP)
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	MOVD	R30, R3
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	CALL	runtime.morestack_noctxt(SB)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	PCDATA	$0, $-1
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	LDP	8(RSP), (R0, R1)
	0x0050 00080 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:87)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb c9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 08 e6 d2 42 00 01 ca  .....#......B...
	0x0020 e1 03 00 aa e0 03 02 aa 00 00 00 94 02 38 e6 d2  .............8..
	0x0030 00 00 02 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0040 e0 87 00 a9 e3 03 1e aa 00 00 00 94 e0 87 40 a9  ..............@.
	0x0050 ec ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 40+4 t=R_CALLARM64 runtime.dd128tod64+0
	rel 72+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.FromInt STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	TEXT	<unlinkable>.FromInt(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	FUNCDATA	$5, <unlinkable>.FromInt.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	FUNCDATA	$6, <unlinkable>.FromInt.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	PCDATA	$1, $0
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	CALL	runtime.di64tod64(SB)
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	MOVD	$3584865303386914816, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	EOR	R1, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:94)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:92)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 00 00 00 94 01 38 e6 d2  .....#.......8..
	0x0020 00 00 01 ca fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 24+4 t=R_CALLARM64 runtime.di64tod64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.ToInt STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	TEXT	<unlinkable>.ToInt(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	FUNCDATA	$5, <unlinkable>.ToInt.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	FUNCDATA	$6, <unlinkable>.ToInt.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	CALL	runtime.dd64toi64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:99)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:97)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb 49 01 00 54 fe 0f 1d f8  ..@..c0.I..T....
	0x0010 fd 83 1f f8 fd 23 00 d1 01 38 e6 d2 00 00 01 ca  .....#...8......
	0x0020 00 00 00 94 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6  ......_...C..._.
	0x0030 e0 07 00 f9 e3 03 1e aa 00 00 00 94 e0 07 40 f9  ..............@.
	0x0040 f0 ff ff 17 00 00 00 00 00 00 00 00 00 00 00 00  ................
	rel 32+4 t=R_CALLARM64 runtime.dd64toi64+0
	rel 56+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Min64 STEXT size=80 align=0x0 args=0x10 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	TEXT	<unlinkable>.Min64(SB), ABIInternal, $48-16
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	BLS	60
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	FUNCDATA	$5, <unlinkable>.Min64.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	FUNCDATA	$6, <unlinkable>.Min64.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	MOVD	$3584865303386914816, R2
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	EOR	R2, R1, R1
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	EOR	R2, R0, R0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	PCDATA	$1, $0
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	CALL	runtime.dmin64(SB)
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	MOVD	$3584865303386914816, R2
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	EOR	R2, R0, R0
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	MOVD	-8(RSP), R29
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	MOVD.P	48(RSP), R30
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	RET	(R30)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:104)	NOP
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	PCDATA	$1, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	PCDATA	$0, $-2
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	STP	(R0, R1), 8(RSP)
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	MOVD	R30, R3
	0x0044 00068 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	CALL	runtime.morestack_noctxt(SB)
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	PCDATA	$0, $-1
	0x0048 00072 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	LDP	8(RSP), (R0, R1)
	0x004c 00076 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:102)	JMP	0
	0x0000 90 0b 40 f9 ff 63 30 eb a9 01 00 54 fe 0f 1d f8  ..@..c0....T....
	0x0010 fd 83 1f f8 fd 23 00 d1 02 38 e6 d2 21 00 02 ca  .....#...8..!...
	0x0020 00 00 02 ca 00 00 00 94 02 38 e6 d2 00 00 02 ca  .........8......
	0x0030 fd 83 5f f8 fe 07 43 f8 c0 03 5f d6 e0 87 00 a9  .._...C..._.....
	0x0040 e3 03 1e aa 00 00 00 94 e0 87 40 a9 ed ff ff 17  ..........@.....
	rel 36+4 t=R_CALLARM64 runtime.dmin64+0
	rel 68+4 t=R_CALLARM64 runtime.morestack_noctxt+0
<unlinkable>.Neg64 STEXT size=16 align=0x0 args=0x8 locals=0x0 funcid=0x0 leaf
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:107)	TEXT	<unlinkable>.Neg64(SB), LEAF|NOFRAME|ABIInternal, $0-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:107)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:107)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:107)	FUNCDATA	$5, <unlinkable>.Neg64.arginfo1(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:107)	FUNCDATA	$6, <unlinkable>.Neg64.argliveinfo(SB)
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:107)	PCDATA	$3, $1
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:109)	EOR	$-9223372036854775808, R0, R0
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:109)	RET	(R30)
	0x0000 00 00 41 d2 c0 03 5f d6 00 00 00 00 00 00 00 00  ..A..._.........
<unlinkable>.ToFloat STEXT size=80 align=0x0 args=0x8 locals=0x28 funcid=0x0
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	TEXT	<unlinkable>.ToFloat(SB), ABIInternal, $48-8
	0x0000 00000 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	MOVD	16(g), R16
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	PCDATA	$0, $-2
	0x0004 00004 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	CMP	R16, RSP
	0x0008 00008 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	BLS	48
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	PCDATA	$0, $-1
	0x000c 00012 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	MOVD.W	R30, -48(RSP)
	0x0010 00016 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	MOVD	R29, -8(RSP)
	0x0014 00020 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	SUB	$8, RSP, R29
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	FUNCDATA	$0, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	FUNCDATA	$1, gclocals·g5+hNtRBP6YXNjfog7aZjQ==(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	FUNCDATA	$5, <unlinkable>.ToFloat.arginfo1(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	FUNCDATA	$6, <unlinkable>.ToFloat.argliveinfo(SB)
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	PCDATA	$3, $1
	0x0018 00024 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	MOVD	$3584865303386914816, R1
	0x001c 00028 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	EOR	R1, R0, R0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	PCDATA	$1, $0
	0x0020 00032 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	CALL	runtime.dd64tof64(SB)
	0x0024 00036 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	MOVD	-8(RSP), R29
	0x0028 00040 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	MOVD.P	48(RSP), R30
	0x002c 00044 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	RET	(R30)
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:115)	NOP
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	PCDATA	$1, $-1
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	PCDATA	$0, $-2
	0x0030 00048 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	MOVD	R0, 8(RSP)
	0x0034 00052 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	MOVD	R30, R3
	0x0038 00056 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	CALL	runtime.morestack_noctxt(SB)
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	PCDATA	$0, $-1
	0x003c 00060 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	MOVD	8(RSP), R0
	0x0040 00064 (/Users/marcelo/work/wt/gd-survey/test/codegen/decimal.go:112)	JMP	0
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
