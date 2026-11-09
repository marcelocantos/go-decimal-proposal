TEXT main.bill(SB) github.com/migueldecimal128/go-decimal128-app-benchmark/apps/telco/cmd/telco/main.go
  main.go:47			0x10009fdb0		f9400b90		MOVD 16(R28), R16											
  main.go:47			0x10009fdb4		d10443f1		SUB $272, RSP, R17											
  main.go:47			0x10009fdb8		eb10023f		CMP R16, R17												
  main.go:47			0x10009fdbc		54007069		BLS 899(PC)												
  main.go:47			0x10009fdc0		d10643f4		SUB $400, RSP, R20											
  main.go:47			0x10009fdc4		a93ffa9d		STP (R29, R30), -8(R20)											
  main.go:47			0x10009fdc8		9100029f		MOVD R20, RSP												
  main.go:47			0x10009fdcc		d10023fd		SUB $8, RSP, R29											
  main.go:47			0x10009fdd0		f900dbe3		MOVD R3, 432(RSP)											
  main.go:49			0x10009fdd4		a91a0be1		STP (R1, R2), 416(RSP)											
  main.go:49			0x10009fdd8		f900cfe0		MOVD R0, 408(RSP)											
  main.go:47			0x10009fddc		910183e9		ADD $96, RSP, R9											
  main.go:47			0x10009fde0		a9007d3f		STP (ZR, ZR), (R9)											
  main.go:47			0x10009fde4		a9017d3f		STP (ZR, ZR), 16(R9)											
  main.go:47			0x10009fde8		a9027d3f		STP (ZR, ZR), 32(R9)											
  main.go:49			0x10009fdec		aa1f03e6		MOVD ZR, R6												
  main.go:49			0x10009fdf0		aa1f03e7		MOVD ZR, R7												
  main.go:49			0x10009fdf4		aa1f03e8		MOVD ZR, R8												
  main.go:49			0x10009fdf8		aa1f03e9		MOVD ZR, R9												
  main.go:49			0x10009fdfc		aa1f03ea		MOVD ZR, R10												
  main.go:49			0x10009fe00		aa1f03eb		MOVD ZR, R11												
  main.go:49			0x10009fe04		aa1f03ec		MOVD ZR, R12												
  main.go:49			0x10009fe08		aa1f03ed		MOVD ZR, R13												
  main.go:49			0x10009fe0c		14000010		JMP 16(PC)												
  main.go:67			0x10009fe10		d100082e		SUB $2, R1, R14												
  main.go:67			0x10009fe14		d28141af		MOVD $2573, R15												
  main.go:67			0x10009fe18		782e68af		MOVH R15, (R5)(R14)											
  main.go:49			0x10009fe1c		f940abe6		MOVD 336(RSP), R6											
  main.go:49			0x10009fe20		aa0003e7		MOVD R0, R7												
  main.go:49			0x10009fe24		f9407fe8		MOVD 248(RSP), R8											
  main.go:49			0x10009fe28		f94087e9		MOVD 264(RSP), R9											
  main.go:49			0x10009fe2c		a94eafea		LDP 232(RSP), (R10, R11)										
  main.go:49			0x10009fe30		f94083ec		MOVD 256(RSP), R12											
  main.go:49			0x10009fe34		f94073ed		MOVD 224(RSP), R13											
  main.go:49			0x10009fe38		aa0503e3		MOVD R5, R3												
  main.go:49			0x10009fe3c		aa0203e5		MOVD R2, R5												
  main.go:49			0x10009fe40		aa0103e4		MOVD R1, R4												
  binary.go:207			0x10009fe44		a95987e0		LDP 408(RSP), (R0, R1)											
  main.go:50			0x10009fe48		f940d7e2		MOVD 424(RSP), R2											
  main.go:49			0x10009fe4c		a90e2bed		STP (R13, R10), 224(RSP)										
  main.go:49			0x10009fe50		a91027ec		STP (R12, R9), 256(RSP)											
  main.go:49			0x10009fe54		a90f23eb		STP (R11, R8), 240(RSP)											
  main.go:49			0x10009fe58		910020ce		ADD $8, R6, R14												
  main.go:49			0x10009fe5c		eb0e003f		CMP R14, R1												
  main.go:49			0x10009fe60		5400670b		BLT 824(PC)												
  main.go:50			0x10009fe64		eb06003f		CMP R6, R1												
  main.go:50			0x10009fe68		54006ac3		BCC 854(PC)												
  main.go:50			0x10009fe6c		cb06002f		SUB R6, R1, R15												
  main.go:50			0x10009fe70		cb0200d0		SUB R2, R6, R16												
  main.go:50			0x10009fe74		8a90fcc6		AND R16->63, R6, R6											
  binary.go:205			0x10009fe78		f1001dff		CMP $7, R15												
  binary.go:205			0x10009fe7c		54006a09		BLS 848(PC)												
  main.go:49			0x10009fe80		a914bbe5		STP (R5, R14), 328(RSP)											
  main.go:49			0x10009fe84		f900a3e4		MOVD R4, 320(RSP)											
  main.go:49			0x10009fe88		f900c3e3		MOVD R3, 384(RSP)											
  main.go:49			0x10009fe8c		39017fe7		MOVB R7, 95(RSP)											
  main.go:52			0x10009fe90		d000081b		ADRP 1056768(PC), R27											
  main.go:52			0x10009fe94		910f037b		ADD $960, R27, R27											
  main.go:52			0x10009fe98		a940436f		LDP (R27), (R15, R16)											
  binary.go:207			0x10009fe9c		f8666806		MOVD (R0)(R6), R6											
  binary.go:207			0x10009fea0		dac00cc6		REV R6, R6												
  main.go:53			0x10009fea4		36000086		TBZ $0, R6, 4(PC)											
  main.go:54			0x10009fea8		d000081b		ADRP 1056768(PC), R27											
  main.go:54			0x10009feac		910f437b		ADD $976, R27, R27											
  main.go:54			0x10009feb0		a940436f		LDP (R27), (R15, R16)											
  binary.go:207			0x10009feb4		f9009fe6		MOVD R6, 312(RSP)											
  main.go:56			0x10009feb8		a91143ef		STP (R15, R16), 272(RSP)										
  lib_go_decimal_poc.go:46	0x10009febc		aa0603e0		MOVD R6, R0												
  lib_go_decimal_poc.go:46	0x10009fec0		97fdd238		CALL runtime.di64tod128(SB)										
  lib_go_decimal_poc.go:46	0x10009fec4		d2e60802		MOVD $3476778912330022912, R2										
  lib_go_decimal_poc.go:46	0x10009fec8		ca020003		EOR R2, R0, R3												
  lib_go_decimal_poc.go:110	0x10009fecc		f9408fe4		MOVD 280(RSP), R4											
  lib_go_decimal_poc.go:110	0x10009fed0		aa040065		ORR R4, R3, R5												
  lib_go_decimal_poc.go:110	0x10009fed4		f240c0bf		TST $562949953421311, R5										
  lib_go_decimal_poc.go:110	0x10009fed8		540005c1		BNE 46(PC)												
  lib_go_decimal_poc.go:110	0x10009fedc		92430485		AND $6917529027641081856, R4, R5									
  lib_go_decimal_poc.go:110	0x10009fee0		d2e80006		MOVD $4611686018427387904, R6										
  lib_go_decimal_poc.go:110	0x10009fee4		eb0600bf		CMP R6, R5												
  lib_go_decimal_poc.go:110	0x10009fee8		54000500		BEQ 40(PC)												
  lib_go_decimal_poc.go:110	0x10009feec		92430465		AND $6917529027641081856, R3, R5									
  lib_go_decimal_poc.go:110	0x10009fef0		eb0600bf		CMP R6, R5												
  lib_go_decimal_poc.go:110	0x10009fef4		54000460		BEQ 35(PC)												
  lib_go_decimal_poc.go:110	0x10009fef8		ca020085		EOR R2, R4, R5												
  lib_go_decimal_poc.go:110	0x10009fefc		d371f8a5		UBFX $49, R5, $14, R5											
  lib_go_decimal_poc.go:110	0x10009ff00		d371f807		UBFX $49, R0, $14, R7											
  lib_go_decimal_poc.go:110	0x10009ff04		8b0500e5		ADD R5, R7, R5												
  lib_go_decimal_poc.go:110	0x10009ff08		d2830407		MOVD $6176, R7												
  lib_go_decimal_poc.go:110	0x10009ff0c		cb0700a5		SUB R7, R5, R5												
  lib_go_decimal_poc.go:110	0x10009ff10		d285ffe7		MOVD $12287, R7												
  lib_go_decimal_poc.go:110	0x10009ff14		eb0700bf		CMP R7, R5												
  lib_go_decimal_poc.go:110	0x10009ff18		54000308		BHI 24(PC)												
  lib_go_decimal_poc.go:110	0x10009ff1c		f9408be7		MOVD 272(RSP), R7											
  lib_go_decimal_poc.go:110	0x10009ff20		9bc17ce8		UMULH R1, R7, R8											
  lib_go_decimal_poc.go:110	0x10009ff24		9b017ce9		MUL R1, R7, R9												
  lib_go_decimal_poc.go:110	0x10009ff28		d290f80a		MOVD $34752, R10											
  lib_go_decimal_poc.go:110	0x10009ff2c		f2b7d5aa		MOVK $(48813<<16), R10											
  lib_go_decimal_poc.go:110	0x10009ff30		f2dda12a		MOVK $(60681<<32), R10											
  lib_go_decimal_poc.go:110	0x10009ff34		f2e0002a		MOVK $(1<<48), R10											
  lib_go_decimal_poc.go:110	0x10009ff38		eb0a011f		CMP R10, R8												
  lib_go_decimal_poc.go:110	0x10009ff3c		54000103		BCC 8(PC)												
  lib_go_decimal_poc.go:110	0x10009ff40		9a9f17ea		CSET EQ, R10												
  lib_go_decimal_poc.go:110	0x10009ff44		92ce338b		MOVD $-124914828836865, R11										
  lib_go_decimal_poc.go:110	0x10009ff48		f2e6f1ab		MOVK $(14221<<48), R11											
  lib_go_decimal_poc.go:110	0x10009ff4c		eb0b013f		CMP R11, R9												
  lib_go_decimal_poc.go:110	0x10009ff50		9a9f87eb		CSET LS, R11												
  lib_go_decimal_poc.go:110	0x10009ff54		8a0a016a		AND R10, R11, R10											
  lib_go_decimal_poc.go:110	0x10009ff58		360001ea		TBZ $0, R10, 15(PC)											
  lib_go_decimal_poc.go:110	0x10009ff5c		ca000087		EOR R0, R4, R7												
  lib_go_decimal_poc.go:110	0x10009ff60		ca0200e7		EOR R2, R7, R7												
  lib_go_decimal_poc.go:110	0x10009ff64		924100e7		AND $-9223372036854775808, R7, R7									
  lib_go_decimal_poc.go:110	0x10009ff68		aa05c4e5		ORR R5<<49, R7, R5											
  lib_go_decimal_poc.go:110	0x10009ff6c		ca0200a5		EOR R2, R5, R5												
  lib_go_decimal_poc.go:110	0x10009ff70		aa050101		ORR R5, R8, R1												
  lib_go_decimal_poc.go:110	0x10009ff74		14000014		JMP 20(PC)												
  lib_go_decimal_poc.go:110	0x10009ff78		f9408be7		MOVD 272(RSP), R7											
  lib_go_decimal_poc.go:110	0x10009ff7c		14000006		JMP 6(PC)												
  lib_go_decimal_poc.go:110	0x10009ff80		f9408be7		MOVD 272(RSP), R7											
  lib_go_decimal_poc.go:110	0x10009ff84		14000004		JMP 4(PC)												
  lib_go_decimal_poc.go:110	0x10009ff88		f9408be7		MOVD 272(RSP), R7											
  lib_go_decimal_poc.go:110	0x10009ff8c		14000002		JMP 2(PC)												
  lib_go_decimal_poc.go:110	0x10009ff90		f9408be7		MOVD 272(RSP), R7											
  lib_go_decimal_poc.go:110	0x10009ff94		ca020084		EOR R2, R4, R4												
  lib_go_decimal_poc.go:110	0x10009ff98		aa0003e2		MOVD R0, R2												
  lib_go_decimal_poc.go:110	0x10009ff9c		aa0103e3		MOVD R1, R3												
  lib_go_decimal_poc.go:110	0x10009ffa0		aa0403e0		MOVD R4, R0												
  lib_go_decimal_poc.go:110	0x10009ffa4		aa0703e1		MOVD R7, R1												
  lib_go_decimal_poc.go:110	0x10009ffa8		97fdd182		CALL runtime.dmul128(SB)										
  lib_go_decimal_poc.go:110	0x10009ffac		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:110	0x10009ffb0		ca040005		EOR R4, R0, R5												
  lib_go_decimal_poc.go:46	0x10009ffb4		d2e60802		MOVD $3476778912330022912, R2										
  lib_go_decimal_poc.go:110	0x10009ffb8		d2e80006		MOVD $4611686018427387904, R6										
  main.go:56			0x10009ffbc		aa0103e9		MOVD R1, R9												
  main.go:56			0x10009ffc0		aa0503e1		MOVD R5, R1												
  main.go:56			0x10009ffc4		d000081b		ADRP 1056768(PC), R27											
  main.go:56			0x10009ffc8		9110037b		ADD $1024, R27, R27											
  main.go:56			0x10009ffcc		a9400f65		LDP (R27), (R5, R3)											
  arithmetic.go:270		0x10009ffd0		92430427		AND $6917529027641081856, R1, R7									
  lib_go_decimal_poc.go:113	0x10009ffd4		d503201f		NOOP													
  decimal.go:159		0x10009ffd8		d503201f		NOOP													
  arithmetic.go:270		0x10009ffdc		ca010048		EOR R1, R2, R8												
  arithmetic.go:270		0x10009ffe0		eb0600ff		CMP R6, R7												
  arithmetic.go:270		0x10009ffe4		540004a0		BEQ 37(PC)												
  arithmetic.go:270		0x10009ffe8		f240c11f		TST $562949953421311, R8										
  arithmetic.go:270		0x10009ffec		54000461		BNE 35(PC)												
  arithmetic.go:270		0x10009fff0		92430467		AND $6917529027641081856, R3, R7									
  arithmetic.go:270		0x10009fff4		eb0600ff		CMP R6, R7												
  arithmetic.go:270		0x10009fff8		54000400		BEQ 32(PC)												
  arithmetic.go:270		0x10009fffc		ca020067		EOR R2, R3, R7												
  arithmetic.go:270		0x1000a0000		d371f90a		UBFX $49, R8, $14, R10											
  arithmetic.go:270		0x1000a0004		d371f8eb		UBFX $49, R7, $14, R11											
  arithmetic.go:270		0x1000a0008		eb0a017f		CMP R10, R11												
  arithmetic.go:270		0x1000a000c		54000061		BNE 3(PC)												
  arithmetic.go:262		0x1000a0010		aa0903e0		MOVD R9, R0												
  arithmetic.go:270		0x1000a0014		1400001d		JMP 29(PC)												
  arithmetic.go:270		0x1000a0018		cb0a016a		SUB R10, R11, R10											
  arithmetic.go:270		0x1000a001c		d100054a		SUB $1, R10, R10											
  arithmetic.go:270		0x1000a0020		f100495f		CMP $18, R10												
  arithmetic.go:270		0x1000a0024		540002a8		BHI 21(PC)												
  arithmetic.go:270		0x1000a0028		924f34e5		AND $9222809086901354496, R7, R5									
  arithmetic.go:270		0x1000a002c		d0000047		ADRP 40960(PC), R7											
  arithmetic.go:270		0x1000a0030		912080e7		ADD $2080, R7, R7											
  arithmetic.go:270		0x1000a0034		f86a78e7		MOVD (R7)(R10<<3), R7											
  arithmetic.go:270		0x1000a0038		9ac7092a		UDIV R7, R9, R10											
  arithmetic.go:270		0x1000a003c		9b0aa4eb		MSUB R10, R9, R7, R11											
  arithmetic.go:270		0x1000a0040		92410108		AND $-9223372036854775808, R8, R8									
  arithmetic.go:270		0x1000a0044		aa050105		ORR R5, R8, R5												
  arithmetic.go:270		0x1000a0048		ca0200a1		EOR R2, R5, R1												
  arithmetic.go:270		0x1000a004c		eb47057f		CMP R7>>1, R11												
  arithmetic.go:270		0x1000a0050		9a9f97e5		CSET HI, R5												
  arithmetic.go:270		0x1000a0054		9a9f17e7		CSET EQ, R7												
  arithmetic.go:270		0x1000a0058		f240015f		TST $1, R10												
  arithmetic.go:270		0x1000a005c		9a9f07e8		CSET NE, R8												
  arithmetic.go:270		0x1000a0060		8a070107		AND R7, R8, R7												
  arithmetic.go:270		0x1000a0064		aa0700a5		ORR R7, R5, R5												
  arithmetic.go:270		0x1000a0068		d3401ca5		UBFX $0, R5, $8, R5											
  arithmetic.go:270		0x1000a006c		8b0a00a9		ADD R10, R5, R9												
  arithmetic.go:262		0x1000a0070		aa0903e0		MOVD R9, R0												
  arithmetic.go:270		0x1000a0074		14000005		JMP 5(PC)												
  arithmetic.go:270		0x1000a0078		aa0903e0		MOVD R9, R0												
  arithmetic.go:270		0x1000a007c		aa0503e2		MOVD R5, R2												
  arithmetic.go:270		0x1000a0080		aa1f03e4		MOVD ZR, R4												
  arithmetic.go:270		0x1000a0084		97ff6e93		CALL internal/decimal.quantize128(SB)									
  arithmetic.go:262		0x1000a0088		f90067e1		MOVD R1, 200(RSP)											
  arithmetic.go:262		0x1000a008c		f90057e0		MOVD R0, 168(RSP)											
  main.go:57			0x1000a0090		b000081b		ADRP 1052672(PC), R27											
  main.go:57			0x1000a0094		910f837b		ADD $992, R27, R27											
  main.go:57			0x1000a0098		a9401763		LDP (R27), (R3, R5)											
  lib_go_decimal_poc.go:110	0x1000a009c		92430426		AND $6917529027641081856, R1, R6									
  lib_go_decimal_poc.go:110	0x1000a00a0		f9009be6		MOVD R6, 304(RSP)											
  lib_go_decimal_poc.go:110	0x1000a00a4		aa050027		ORR R5, R1, R7												
  lib_go_decimal_poc.go:110	0x1000a00a8		f240c0ff		TST $562949953421311, R7										
  arithmetic.go:262		0x1000a00ac		54000561		BNE 43(PC)												
  lib_go_decimal_poc.go:110	0x1000a00b0		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:110	0x1000a00b4		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:110	0x1000a00b8		540004c0		BEQ 38(PC)												
  lib_go_decimal_poc.go:110	0x1000a00bc		924304a8		AND $6917529027641081856, R5, R8									
  lib_go_decimal_poc.go:110	0x1000a00c0		eb07011f		CMP R7, R8												
  lib_go_decimal_poc.go:110	0x1000a00c4		54000420		BEQ 33(PC)												
  lib_go_decimal_poc.go:110	0x1000a00c8		d2e60808		MOVD $3476778912330022912, R8										
  lib_go_decimal_poc.go:110	0x1000a00cc		ca080029		EOR R8, R1, R9												
  lib_go_decimal_poc.go:110	0x1000a00d0		ca0800aa		EOR R8, R5, R10												
  lib_go_decimal_poc.go:110	0x1000a00d4		d371f929		UBFX $49, R9, $14, R9											
  lib_go_decimal_poc.go:110	0x1000a00d8		d371f94a		UBFX $49, R10, $14, R10											
  lib_go_decimal_poc.go:110	0x1000a00dc		8b090149		ADD R9, R10, R9												
  lib_go_decimal_poc.go:110	0x1000a00e0		d283040a		MOVD $6176, R10												
  lib_go_decimal_poc.go:110	0x1000a00e4		cb0a0129		SUB R10, R9, R9												
  lib_go_decimal_poc.go:110	0x1000a00e8		d285ffea		MOVD $12287, R10											
  lib_go_decimal_poc.go:110	0x1000a00ec		eb0a013f		CMP R10, R9												
  lib_go_decimal_poc.go:110	0x1000a00f0		54000368		BHI 27(PC)												
  lib_go_decimal_poc.go:110	0x1000a00f4		9bc07c6a		UMULH R0, R3, R10											
  lib_go_decimal_poc.go:110	0x1000a00f8		9b007c6b		MUL R0, R3, R11												
  lib_go_decimal_poc.go:110	0x1000a00fc		d290f80c		MOVD $34752, R12											
  lib_go_decimal_poc.go:110	0x1000a0100		f2b7d5ac		MOVK $(48813<<16), R12											
  lib_go_decimal_poc.go:110	0x1000a0104		f2dda12c		MOVK $(60681<<32), R12											
  lib_go_decimal_poc.go:110	0x1000a0108		f2e0002c		MOVK $(1<<48), R12											
  lib_go_decimal_poc.go:110	0x1000a010c		eb0c015f		CMP R12, R10												
  lib_go_decimal_poc.go:110	0x1000a0110		54000103		BCC 8(PC)												
  lib_go_decimal_poc.go:110	0x1000a0114		9a9f17ec		CSET EQ, R12												
  lib_go_decimal_poc.go:110	0x1000a0118		92ce338d		MOVD $-124914828836865, R13										
  lib_go_decimal_poc.go:110	0x1000a011c		f2e6f1ad		MOVK $(14221<<48), R13											
  lib_go_decimal_poc.go:110	0x1000a0120		eb0d017f		CMP R13, R11												
  lib_go_decimal_poc.go:110	0x1000a0124		9a9f87ed		CSET LS, R13												
  lib_go_decimal_poc.go:110	0x1000a0128		8a0d018c		AND R13, R12, R12											
  lib_go_decimal_poc.go:110	0x1000a012c		3600018c		TBZ $0, R12, 12(PC)											
  lib_go_decimal_poc.go:110	0x1000a0130		ca050025		EOR R5, R1, R5												
  lib_go_decimal_poc.go:110	0x1000a0134		924100a5		AND $-9223372036854775808, R5, R5									
  lib_go_decimal_poc.go:110	0x1000a0138		aa09c4a5		ORR R9<<49, R5, R5											
  lib_go_decimal_poc.go:110	0x1000a013c		ca0800a5		EOR R8, R5, R5												
  lib_go_decimal_poc.go:110	0x1000a0140		aa050145		ORR R5, R10, R5												
  lib_go_decimal_poc.go:110	0x1000a0144		14000013		JMP 19(PC)												
  lib_go_decimal_poc.go:46	0x1000a0148		d2e60808		MOVD $3476778912330022912, R8										
  lib_go_decimal_poc.go:110	0x1000a014c		14000004		JMP 4(PC)												
  lib_go_decimal_poc.go:46	0x1000a0150		d2e60808		MOVD $3476778912330022912, R8										
  lib_go_decimal_poc.go:110	0x1000a0154		14000002		JMP 2(PC)												
  lib_go_decimal_poc.go:46	0x1000a0158		d2e60808		MOVD $3476778912330022912, R8										
  lib_go_decimal_poc.go:110	0x1000a015c		ca080024		EOR R8, R1, R4												
  lib_go_decimal_poc.go:110	0x1000a0160		ca0800a2		EOR R8, R5, R2												
  lib_go_decimal_poc.go:110	0x1000a0164		aa0003e1		MOVD R0, R1												
  lib_go_decimal_poc.go:110	0x1000a0168		aa0403e0		MOVD R4, R0												
  lib_go_decimal_poc.go:110	0x1000a016c		97fdd111		CALL runtime.dmul128(SB)										
  lib_go_decimal_poc.go:110	0x1000a0170		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:110	0x1000a0174		ca040005		EOR R4, R0, R5												
  lib_go_decimal_poc.go:108	0x1000a0178		f94057e0		MOVD 168(RSP), R0											
  lib_go_decimal_poc.go:110	0x1000a017c		f9409be6		MOVD 304(RSP), R6											
  lib_go_decimal_poc.go:110	0x1000a0180		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a0184		d2e60808		MOVD $3476778912330022912, R8										
  main.go:57			0x1000a0188		aa0103eb		MOVD R1, R11												
  lib_go_decimal_poc.go:108	0x1000a018c		f94067e1		MOVD 200(RSP), R1											
  main.go:57			0x1000a0190		b000081b		ADRP 1052672(PC), R27											
  main.go:57			0x1000a0194		9110037b		ADD $1024, R27, R27											
  main.go:57			0x1000a0198		a9400f62		LDP (R27), (R2, R3)											
  arithmetic.go:270		0x1000a019c		924304a9		AND $6917529027641081856, R5, R9									
  lib_go_decimal_poc.go:141	0x1000a01a0		d503201f		NOOP													
  arithmetic.go:270		0x1000a01a4		ca05010a		EOR R5, R8, R10												
  arithmetic.go:270		0x1000a01a8		eb07013f		CMP R7, R9												
  arithmetic.go:270		0x1000a01ac		54000300		BEQ 24(PC)												
  arithmetic.go:270		0x1000a01b0		f240c15f		TST $562949953421311, R10										
  arithmetic.go:270		0x1000a01b4		540002c1		BNE 22(PC)												
  arithmetic.go:270		0x1000a01b8		92430469		AND $6917529027641081856, R3, R9									
  arithmetic.go:270		0x1000a01bc		eb07013f		CMP R7, R9												
  arithmetic.go:270		0x1000a01c0		54000260		BEQ 19(PC)												
  arithmetic.go:270		0x1000a01c4		ca080069		EOR R8, R3, R9												
  arithmetic.go:270		0x1000a01c8		d371f94c		UBFX $49, R10, $14, R12											
  arithmetic.go:270		0x1000a01cc		d371f92d		UBFX $49, R9, $14, R13											
  arithmetic.go:270		0x1000a01d0		eb0c01bf		CMP R12, R13												
  arithmetic.go:270		0x1000a01d4		54000320		BEQ 25(PC)												
  arithmetic.go:270		0x1000a01d8		cb0c01ac		SUB R12, R13, R12											
  arithmetic.go:270		0x1000a01dc		d100058c		SUB $1, R12, R12											
  arithmetic.go:270		0x1000a01e0		f100499f		CMP $18, R12												
  arithmetic.go:270		0x1000a01e4		54000148		BHI 10(PC)												
  arithmetic.go:270		0x1000a01e8		924f3529		AND $9222809086901354496, R9, R9									
  arithmetic.go:270		0x1000a01ec		d000004d		ADRP 40960(PC), R13											
  arithmetic.go:270		0x1000a01f0		912081ad		ADD $2080, R13, R13											
  arithmetic.go:270		0x1000a01f4		f86c79ac		MOVD (R13)(R12<<3), R12											
  arithmetic.go:270		0x1000a01f8		9241014a		AND $-9223372036854775808, R10, R10									
  arithmetic.go:270		0x1000a01fc		aa090149		ORR R9, R10, R9												
  arithmetic.go:270		0x1000a0200		9acc096b		UDIV R12, R11, R11											
  arithmetic.go:270		0x1000a0204		ca080125		EOR R8, R9, R5												
  arithmetic.go:270		0x1000a0208		1400000c		JMP 12(PC)												
  arithmetic.go:270		0x1000a020c		aa0b03e0		MOVD R11, R0												
  arithmetic.go:270		0x1000a0210		aa0503e1		MOVD R5, R1												
  arithmetic.go:270		0x1000a0214		b27f03e4		ORR $2, ZR, R4												
  arithmetic.go:270		0x1000a0218		97ff6e2e		CALL internal/decimal.quantize128(SB)									
  lib_go_decimal_poc.go:110	0x1000a021c		f9409be6		MOVD 304(RSP), R6											
  lib_go_decimal_poc.go:110	0x1000a0220		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a0224		d2e60808		MOVD $3476778912330022912, R8										
  decimal.go:164		0x1000a0228		aa0103e5		MOVD R1, R5												
  decimal.go:164		0x1000a022c		aa0003eb		MOVD R0, R11												
  lib_go_decimal_poc.go:108	0x1000a0230		f94057e0		MOVD 168(RSP), R0											
  lib_go_decimal_poc.go:108	0x1000a0234		f94067e1		MOVD 200(RSP), R1											
  lib_go_decimal_poc.go:108	0x1000a0238		f94087e9		MOVD 264(RSP), R9											
  lib_go_decimal_poc.go:108	0x1000a023c		9243052a		AND $6917529027641081856, R9, R10									
  lib_go_decimal_poc.go:108	0x1000a0240		eb0900bf		CMP R9, R5												
  decimal.go:164		0x1000a0244		54000141		BNE 10(PC)												
  lib_go_decimal_poc.go:108	0x1000a0248		f240c13f		TST $562949953421311, R9										
  lib_go_decimal_poc.go:108	0x1000a024c		54000821		BNE 65(PC)												
  lib_go_decimal_poc.go:108	0x1000a0250		eb07015f		CMP R7, R10												
  lib_go_decimal_poc.go:108	0x1000a0254		540007e0		BEQ 63(PC)												
  lib_go_decimal_poc.go:108	0x1000a0258		f94083ea		MOVD 256(RSP), R10											
  lib_go_decimal_poc.go:108	0x1000a025c		ab0a016a		ADDS R10, R11, R10											
  lib_go_decimal_poc.go:108	0x1000a0260		9a1f03ec		ADC ZR, ZR, R12												
  lib_go_decimal_poc.go:108	0x1000a0264		aa090189		ORR R9, R12, R9												
  lib_go_decimal_poc.go:108	0x1000a0268		1400004b		JMP 75(PC)												
  lib_go_decimal_poc.go:108	0x1000a026c		aa05012c		ORR R5, R9, R12												
  lib_go_decimal_poc.go:108	0x1000a0270		f240c19f		TST $562949953421311, R12										
  lib_go_decimal_poc.go:108	0x1000a0274		540006e1		BNE 55(PC)												
  lib_go_decimal_poc.go:108	0x1000a0278		eb07015f		CMP R7, R10												
  lib_go_decimal_poc.go:108	0x1000a027c		540006a0		BEQ 53(PC)												
  lib_go_decimal_poc.go:108	0x1000a0280		924304aa		AND $6917529027641081856, R5, R10									
  lib_go_decimal_poc.go:108	0x1000a0284		eb07015f		CMP R7, R10												
  lib_go_decimal_poc.go:108	0x1000a0288		54000640		BEQ 50(PC)												
  lib_go_decimal_poc.go:108	0x1000a028c		ca08012a		EOR R8, R9, R10												
  lib_go_decimal_poc.go:108	0x1000a0290		ca0800ac		EOR R8, R5, R12												
  lib_go_decimal_poc.go:108	0x1000a0294		d371f94a		UBFX $49, R10, $14, R10											
  lib_go_decimal_poc.go:108	0x1000a0298		d371f98c		UBFX $49, R12, $14, R12											
  lib_go_decimal_poc.go:108	0x1000a029c		cb0a018d		SUB R10, R12, R13											
  lib_go_decimal_poc.go:108	0x1000a02a0		cb0c014e		SUB R12, R10, R14											
  lib_go_decimal_poc.go:108	0x1000a02a4		eb0a019f		CMP R10, R12												
  lib_go_decimal_poc.go:108	0x1000a02a8		9a8e81ad		CSEL HI, R13, R14, R13											
  lib_go_decimal_poc.go:108	0x1000a02ac		f10039bf		CMP $14, R13												
  lib_go_decimal_poc.go:108	0x1000a02b0		54000508		BHI 40(PC)												
  lib_go_decimal_poc.go:108	0x1000a02b4		eb0a019f		CMP R10, R12												
  lib_go_decimal_poc.go:108	0x1000a02b8		f94083ea		MOVD 256(RSP), R10											
  lib_go_decimal_poc.go:108	0x1000a02bc		9a8a816c		CSEL HI, R11, R10, R12											
  lib_go_decimal_poc.go:108	0x1000a02c0		9a8b814a		CSEL HI, R10, R11, R10											
  lib_go_decimal_poc.go:108	0x1000a02c4		9a85812e		CSEL HI, R9, R5, R14											
  lib_go_decimal_poc.go:108	0x1000a02c8		9a8980af		CSEL HI, R5, R9, R15											
  lib_go_decimal_poc.go:108	0x1000a02cc		d0000050		ADRP 40960(PC), R16											
  lib_go_decimal_poc.go:108	0x1000a02d0		911ea210		ADD $1960, R16, R16											
  lib_go_decimal_poc.go:108	0x1000a02d4		f86d7a0d		MOVD (R16)(R13<<3), R13											
  lib_go_decimal_poc.go:108	0x1000a02d8		9b0c7db0		MUL R12, R13, R16											
  lib_go_decimal_poc.go:108	0x1000a02dc		9bcc7dac		UMULH R12, R13, R12											
  lib_go_decimal_poc.go:108	0x1000a02e0		ca050129		EOR R5, R9, R9												
  lib_go_decimal_poc.go:108	0x1000a02e4		b7f800c9		TBNZ $63, R9, 6(PC)											
  lib_go_decimal_poc.go:108	0x1000a02e8		ab0a020a		ADDS R10, R16, R10											
  lib_go_decimal_poc.go:108	0x1000a02ec		9a1f03ed		ADC ZR, ZR, R13												
  lib_go_decimal_poc.go:108	0x1000a02f0		8b0d018c		ADD R13, R12, R12											
  lib_go_decimal_poc.go:108	0x1000a02f4		aa0c01c9		ORR R12, R14, R9											
  lib_go_decimal_poc.go:108	0x1000a02f8		14000027		JMP 39(PC)												
  lib_go_decimal_poc.go:108	0x1000a02fc		cb10014d		SUB R16, R10, R13											
  lib_go_decimal_poc.go:108	0x1000a0300		9240f9d1		AND $9223372036854775807, R14, R17									
  lib_go_decimal_poc.go:108	0x1000a0304		eb0a0213		SUBS R10, R16, R19											
  lib_go_decimal_poc.go:108	0x1000a0308		da1f03f4		NGC ZR, R20												
  lib_go_decimal_poc.go:108	0x1000a030c		8b140194		ADD R20, R12, R20											
  lib_go_decimal_poc.go:108	0x1000a0310		eb10015f		CMP R16, R10												
  lib_go_decimal_poc.go:108	0x1000a0314		9a9f97f0		CSET HI, R16												
  lib_go_decimal_poc.go:108	0x1000a0318		f100019f		CMP $0, R12												
  lib_go_decimal_poc.go:108	0x1000a031c		9a9f17ec		CSET EQ, R12												
  lib_go_decimal_poc.go:108	0x1000a0320		8a0c020c		AND R12, R16, R12											
  lib_go_decimal_poc.go:108	0x1000a0324		7200019f		TSTW $1, R12												
  lib_go_decimal_poc.go:108	0x1000a0328		9a9311aa		CSEL NE, R13, R19, R10											
  lib_go_decimal_poc.go:108	0x1000a032c		9a8f11cc		CSEL NE, R14, R15, R12											
  lib_go_decimal_poc.go:108	0x1000a0330		9a9f028d		CSEL EQ, R20, ZR, R13											
  lib_go_decimal_poc.go:108	0x1000a0334		aa0d014e		ORR R13, R10, R14											
  lib_go_decimal_poc.go:108	0x1000a0338		9241018c		AND $-9223372036854775808, R12, R12									
  lib_go_decimal_poc.go:108	0x1000a033c		f10001df		CMP $0, R14												
  lib_go_decimal_poc.go:108	0x1000a0340		9a9f118c		CSEL NE, R12, ZR, R12											
  lib_go_decimal_poc.go:108	0x1000a0344		aa0c022c		ORR R12, R17, R12											
  lib_go_decimal_poc.go:108	0x1000a0348		aa0d0189		ORR R13, R12, R9											
  lib_go_decimal_poc.go:108	0x1000a034c		14000012		JMP 18(PC)												
  decimal.go:164		0x1000a0350		f90063e5		MOVD R5, 192(RSP)											
  decimal.go:164		0x1000a0354		f90053eb		MOVD R11, 160(RSP)											
  lib_go_decimal_poc.go:108	0x1000a0358		ca080120		EOR R8, R9, R0												
  lib_go_decimal_poc.go:108	0x1000a035c		ca0800a2		EOR R8, R5, R2												
  lib_go_decimal_poc.go:108	0x1000a0360		f94083e1		MOVD 256(RSP), R1											
  lib_go_decimal_poc.go:108	0x1000a0364		aa0b03e3		MOVD R11, R3												
  lib_go_decimal_poc.go:108	0x1000a0368		97fdd07e		CALL runtime.dadd128(SB)										
  lib_go_decimal_poc.go:108	0x1000a036c		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:108	0x1000a0370		ca040009		EOR R4, R0, R9												
  lib_go_decimal_poc.go:108	0x1000a0374		f94057e0		MOVD 168(RSP), R0											
  lib_go_decimal_poc.go:108	0x1000a0378		f94063e5		MOVD 192(RSP), R5											
  lib_go_decimal_poc.go:110	0x1000a037c		f9409be6		MOVD 304(RSP), R6											
  lib_go_decimal_poc.go:110	0x1000a0380		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a0384		d2e60808		MOVD $3476778912330022912, R8										
  lib_go_decimal_poc.go:108	0x1000a0388		f94053eb		MOVD 160(RSP), R11											
  main.go:58			0x1000a038c		aa0103ea		MOVD R1, R10												
  lib_go_decimal_poc.go:108	0x1000a0390		f94067e1		MOVD 200(RSP), R1											
  main.go:58			0x1000a0394		a91027ea		STP (R10, R9), 256(RSP)											
  lib_go_decimal_poc.go:108	0x1000a0398		eb05003f		CMP R5, R1												
  lib_go_decimal_poc.go:108	0x1000a039c		54000121		BNE 9(PC)												
  lib_go_decimal_poc.go:108	0x1000a03a0		f240c03f		TST $562949953421311, R1										
  lib_go_decimal_poc.go:108	0x1000a03a4		540007e1		BNE 63(PC)												
  lib_go_decimal_poc.go:110	0x1000a03a8		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:108	0x1000a03ac		540007a0		BEQ 61(PC)												
  lib_go_decimal_poc.go:108	0x1000a03b0		ab0b0003		ADDS R11, R0, R3											
  lib_go_decimal_poc.go:108	0x1000a03b4		9a1f03e5		ADC ZR, ZR, R5												
  lib_go_decimal_poc.go:108	0x1000a03b8		aa0100a5		ORR R1, R5, R5												
  lib_go_decimal_poc.go:108	0x1000a03bc		14000047		JMP 71(PC)												
  lib_go_decimal_poc.go:108	0x1000a03c0		aa05002c		ORR R5, R1, R12												
  lib_go_decimal_poc.go:108	0x1000a03c4		f240c19f		TST $562949953421311, R12										
  lib_go_decimal_poc.go:108	0x1000a03c8		540006c1		BNE 54(PC)												
  lib_go_decimal_poc.go:110	0x1000a03cc		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:108	0x1000a03d0		54000680		BEQ 52(PC)												
  lib_go_decimal_poc.go:108	0x1000a03d4		924304ac		AND $6917529027641081856, R5, R12									
  lib_go_decimal_poc.go:108	0x1000a03d8		eb07019f		CMP R7, R12												
  lib_go_decimal_poc.go:108	0x1000a03dc		54000620		BEQ 49(PC)												
  lib_go_decimal_poc.go:108	0x1000a03e0		ca08002c		EOR R8, R1, R12												
  lib_go_decimal_poc.go:108	0x1000a03e4		ca0800ad		EOR R8, R5, R13												
  lib_go_decimal_poc.go:108	0x1000a03e8		d371f98c		UBFX $49, R12, $14, R12											
  lib_go_decimal_poc.go:108	0x1000a03ec		d371f9ad		UBFX $49, R13, $14, R13											
  lib_go_decimal_poc.go:108	0x1000a03f0		cb0c01ae		SUB R12, R13, R14											
  lib_go_decimal_poc.go:108	0x1000a03f4		cb0d018f		SUB R13, R12, R15											
  lib_go_decimal_poc.go:108	0x1000a03f8		eb0c01bf		CMP R12, R13												
  lib_go_decimal_poc.go:108	0x1000a03fc		9a8f81ce		CSEL HI, R14, R15, R14											
  lib_go_decimal_poc.go:108	0x1000a0400		f10039df		CMP $14, R14												
  lib_go_decimal_poc.go:108	0x1000a0404		540004e8		BHI 39(PC)												
  lib_go_decimal_poc.go:108	0x1000a0408		eb0c01bf		CMP R12, R13												
  lib_go_decimal_poc.go:108	0x1000a040c		9a80816c		CSEL HI, R11, R0, R12											
  lib_go_decimal_poc.go:108	0x1000a0410		9a8b800b		CSEL HI, R0, R11, R11											
  lib_go_decimal_poc.go:108	0x1000a0414		9a85802d		CSEL HI, R1, R5, R13											
  lib_go_decimal_poc.go:108	0x1000a0418		9a8180af		CSEL HI, R5, R1, R15											
  lib_go_decimal_poc.go:108	0x1000a041c		d0000050		ADRP 40960(PC), R16											
  lib_go_decimal_poc.go:108	0x1000a0420		911ea210		ADD $1960, R16, R16											
  lib_go_decimal_poc.go:108	0x1000a0424		f86e7a0e		MOVD (R16)(R14<<3), R14											
  lib_go_decimal_poc.go:108	0x1000a0428		9b0c7dd0		MUL R12, R14, R16											
  lib_go_decimal_poc.go:108	0x1000a042c		9bcc7dcc		UMULH R12, R14, R12											
  lib_go_decimal_poc.go:108	0x1000a0430		ca050025		EOR R5, R1, R5												
  lib_go_decimal_poc.go:108	0x1000a0434		b7f800c5		TBNZ $63, R5, 6(PC)											
  lib_go_decimal_poc.go:108	0x1000a0438		ab0b0203		ADDS R11, R16, R3											
  lib_go_decimal_poc.go:108	0x1000a043c		9a1f03eb		ADC ZR, ZR, R11												
  lib_go_decimal_poc.go:108	0x1000a0440		8b0b018b		ADD R11, R12, R11											
  lib_go_decimal_poc.go:108	0x1000a0444		aa0b01a5		ORR R11, R13, R5											
  lib_go_decimal_poc.go:108	0x1000a0448		14000024		JMP 36(PC)												
  lib_go_decimal_poc.go:108	0x1000a044c		cb10016e		SUB R16, R11, R14											
  lib_go_decimal_poc.go:108	0x1000a0450		9240f9b1		AND $9223372036854775807, R13, R17									
  lib_go_decimal_poc.go:108	0x1000a0454		eb0b0213		SUBS R11, R16, R19											
  lib_go_decimal_poc.go:108	0x1000a0458		da1f03f4		NGC ZR, R20												
  lib_go_decimal_poc.go:108	0x1000a045c		8b140194		ADD R20, R12, R20											
  lib_go_decimal_poc.go:108	0x1000a0460		eb10017f		CMP R16, R11												
  lib_go_decimal_poc.go:108	0x1000a0464		9a9f97eb		CSET HI, R11												
  lib_go_decimal_poc.go:108	0x1000a0468		f100019f		CMP $0, R12												
  lib_go_decimal_poc.go:108	0x1000a046c		9a9f17ec		CSET EQ, R12												
  lib_go_decimal_poc.go:108	0x1000a0470		8a0c016b		AND R12, R11, R11											
  lib_go_decimal_poc.go:108	0x1000a0474		7200017f		TSTW $1, R11												
  lib_go_decimal_poc.go:108	0x1000a0478		9a9311c3		CSEL NE, R14, R19, R3											
  lib_go_decimal_poc.go:108	0x1000a047c		9a8f11ab		CSEL NE, R13, R15, R11											
  lib_go_decimal_poc.go:108	0x1000a0480		9a9f028c		CSEL EQ, R20, ZR, R12											
  lib_go_decimal_poc.go:108	0x1000a0484		aa0c006d		ORR R12, R3, R13											
  lib_go_decimal_poc.go:108	0x1000a0488		9241016b		AND $-9223372036854775808, R11, R11									
  lib_go_decimal_poc.go:108	0x1000a048c		f10001bf		CMP $0, R13												
  lib_go_decimal_poc.go:108	0x1000a0490		9a9f116b		CSEL NE, R11, ZR, R11											
  lib_go_decimal_poc.go:108	0x1000a0494		aa0b022b		ORR R11, R17, R11											
  lib_go_decimal_poc.go:108	0x1000a0498		aa0c0165		ORR R12, R11, R5											
  lib_go_decimal_poc.go:108	0x1000a049c		1400000f		JMP 15(PC)												
  lib_go_decimal_poc.go:108	0x1000a04a0		ca080024		EOR R8, R1, R4												
  lib_go_decimal_poc.go:108	0x1000a04a4		ca0800a2		EOR R8, R5, R2												
  lib_go_decimal_poc.go:108	0x1000a04a8		aa0003e1		MOVD R0, R1												
  lib_go_decimal_poc.go:108	0x1000a04ac		aa0b03e3		MOVD R11, R3												
  lib_go_decimal_poc.go:108	0x1000a04b0		aa0403e0		MOVD R4, R0												
  lib_go_decimal_poc.go:108	0x1000a04b4		97fdd02b		CALL runtime.dadd128(SB)										
  lib_go_decimal_poc.go:108	0x1000a04b8		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:108	0x1000a04bc		ca040005		EOR R4, R0, R5												
  lib_go_decimal_poc.go:110	0x1000a04c0		f94057e0		MOVD 168(RSP), R0											
  lib_go_decimal_poc.go:110	0x1000a04c4		f9409be6		MOVD 304(RSP), R6											
  lib_go_decimal_poc.go:110	0x1000a04c8		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a04cc		d2e60808		MOVD $3476778912330022912, R8										
  main.go:59			0x1000a04d0		aa0103e3		MOVD R1, R3												
  lib_go_decimal_poc.go:110	0x1000a04d4		f94067e1		MOVD 200(RSP), R1											
  main.go:60			0x1000a04d8		f9409fe2		MOVD 312(RSP), R2											
  main.go:60			0x1000a04dc		36002142		TBZ $0, R2, 266(PC)											
  main.go:59			0x1000a04e0		f9005fe5		MOVD R5, 184(RSP)											
  main.go:59			0x1000a04e4		f9004fe3		MOVD R3, 152(RSP)											
  main.go:61			0x1000a04e8		b000081b		ADRP 1052672(PC), R27											
  main.go:61			0x1000a04ec		910fc37b		ADD $1008, R27, R27											
  main.go:61			0x1000a04f0		a940336b		LDP (R27), (R11, R12)											
  lib_go_decimal_poc.go:110	0x1000a04f4		aa0c002d		ORR R12, R1, R13											
  lib_go_decimal_poc.go:110	0x1000a04f8		f240c1bf		TST $562949953421311, R13										
  lib_go_decimal_poc.go:110	0x1000a04fc		540004a1		BNE 37(PC)												
  lib_go_decimal_poc.go:110	0x1000a0500		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:110	0x1000a0504		54000460		BEQ 35(PC)												
  lib_go_decimal_poc.go:110	0x1000a0508		92430586		AND $6917529027641081856, R12, R6									
  lib_go_decimal_poc.go:110	0x1000a050c		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:110	0x1000a0510		54000400		BEQ 32(PC)												
  lib_go_decimal_poc.go:110	0x1000a0514		ca080026		EOR R8, R1, R6												
  lib_go_decimal_poc.go:110	0x1000a0518		ca08018d		EOR R8, R12, R13											
  lib_go_decimal_poc.go:110	0x1000a051c		d371f8c6		UBFX $49, R6, $14, R6											
  lib_go_decimal_poc.go:110	0x1000a0520		d371f9ad		UBFX $49, R13, $14, R13											
  lib_go_decimal_poc.go:110	0x1000a0524		8b0601a6		ADD R6, R13, R6												
  lib_go_decimal_poc.go:110	0x1000a0528		d283040d		MOVD $6176, R13												
  lib_go_decimal_poc.go:110	0x1000a052c		cb0d00c6		SUB R13, R6, R6												
  lib_go_decimal_poc.go:110	0x1000a0530		d285ffed		MOVD $12287, R13											
  lib_go_decimal_poc.go:110	0x1000a0534		eb0d00df		CMP R13, R6												
  lib_go_decimal_poc.go:110	0x1000a0538		540002c8		BHI 22(PC)												
  lib_go_decimal_poc.go:110	0x1000a053c		9bcb7c0d		UMULH R11, R0, R13											
  lib_go_decimal_poc.go:110	0x1000a0540		9b0b7c0e		MUL R11, R0, R14											
  lib_go_decimal_poc.go:110	0x1000a0544		d290f80f		MOVD $34752, R15											
  lib_go_decimal_poc.go:110	0x1000a0548		f2b7d5af		MOVK $(48813<<16), R15											
  lib_go_decimal_poc.go:110	0x1000a054c		f2dda12f		MOVK $(60681<<32), R15											
  lib_go_decimal_poc.go:110	0x1000a0550		f2e0002f		MOVK $(1<<48), R15											
  lib_go_decimal_poc.go:110	0x1000a0554		eb0f01bf		CMP R15, R13												
  lib_go_decimal_poc.go:110	0x1000a0558		54000103		BCC 8(PC)												
  lib_go_decimal_poc.go:110	0x1000a055c		9a9f17ef		CSET EQ, R15												
  lib_go_decimal_poc.go:110	0x1000a0560		92ce3390		MOVD $-124914828836865, R16										
  lib_go_decimal_poc.go:110	0x1000a0564		f2e6f1b0		MOVK $(14221<<48), R16											
  lib_go_decimal_poc.go:110	0x1000a0568		eb1001df		CMP R16, R14												
  lib_go_decimal_poc.go:110	0x1000a056c		9a9f87f0		CSET LS, R16												
  lib_go_decimal_poc.go:110	0x1000a0570		8a1001ef		AND R16, R15, R15											
  lib_go_decimal_poc.go:110	0x1000a0574		360000ef		TBZ $0, R15, 7(PC)											
  lib_go_decimal_poc.go:110	0x1000a0578		ca0c002b		EOR R12, R1, R11											
  lib_go_decimal_poc.go:110	0x1000a057c		9241016b		AND $-9223372036854775808, R11, R11									
  lib_go_decimal_poc.go:110	0x1000a0580		aa06c566		ORR R6<<49, R11, R6											
  lib_go_decimal_poc.go:110	0x1000a0584		ca0800c6		EOR R8, R6, R6												
  lib_go_decimal_poc.go:110	0x1000a0588		aa0601a1		ORR R6, R13, R1												
  lib_go_decimal_poc.go:110	0x1000a058c		1400000f		JMP 15(PC)												
  lib_go_decimal_poc.go:110	0x1000a0590		ca080024		EOR R8, R1, R4												
  lib_go_decimal_poc.go:110	0x1000a0594		ca080182		EOR R8, R12, R2												
  lib_go_decimal_poc.go:110	0x1000a0598		aa0003e1		MOVD R0, R1												
  lib_go_decimal_poc.go:110	0x1000a059c		aa0b03e3		MOVD R11, R3												
  lib_go_decimal_poc.go:110	0x1000a05a0		aa0403e0		MOVD R4, R0												
  lib_go_decimal_poc.go:110	0x1000a05a4		97fdd003		CALL runtime.dmul128(SB)										
  lib_go_decimal_poc.go:110	0x1000a05a8		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:110	0x1000a05ac		ca040005		EOR R4, R0, R5												
  lib_go_decimal_poc.go:108	0x1000a05b0		f9404fe3		MOVD 152(RSP), R3											
  lib_go_decimal_poc.go:110	0x1000a05b4		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a05b8		d2e60808		MOVD $3476778912330022912, R8										
  main.go:61			0x1000a05bc		aa0103ee		MOVD R1, R14												
  main.go:61			0x1000a05c0		aa0503e1		MOVD R5, R1												
  lib_go_decimal_poc.go:108	0x1000a05c4		f9405fe5		MOVD 184(RSP), R5											
  main.go:61			0x1000a05c8		b000081b		ADRP 1052672(PC), R27											
  main.go:61			0x1000a05cc		9110037b		ADD $1024, R27, R27											
  main.go:61			0x1000a05d0		a9401b62		LDP (R27), (R2, R6)											
  arithmetic.go:270		0x1000a05d4		9243042b		AND $6917529027641081856, R1, R11									
  lib_go_decimal_poc.go:141	0x1000a05d8		d503201f		NOOP													
  arithmetic.go:270		0x1000a05dc		ca01010c		EOR R1, R8, R12												
  arithmetic.go:270		0x1000a05e0		eb07017f		CMP R7, R11												
  arithmetic.go:270		0x1000a05e4		54000300		BEQ 24(PC)												
  arithmetic.go:270		0x1000a05e8		f240c19f		TST $562949953421311, R12										
  arithmetic.go:270		0x1000a05ec		540002c1		BNE 22(PC)												
  arithmetic.go:270		0x1000a05f0		924304cb		AND $6917529027641081856, R6, R11									
  arithmetic.go:270		0x1000a05f4		eb07017f		CMP R7, R11												
  arithmetic.go:270		0x1000a05f8		54000260		BEQ 19(PC)												
  arithmetic.go:270		0x1000a05fc		ca0800cb		EOR R8, R6, R11												
  arithmetic.go:270		0x1000a0600		d371f98d		UBFX $49, R12, $14, R13											
  arithmetic.go:270		0x1000a0604		d371f96f		UBFX $49, R11, $14, R15											
  arithmetic.go:270		0x1000a0608		eb0d01ff		CMP R13, R15												
  arithmetic.go:270		0x1000a060c		540002e0		BEQ 23(PC)												
  arithmetic.go:270		0x1000a0610		cb0d01ed		SUB R13, R15, R13											
  arithmetic.go:270		0x1000a0614		d10005ad		SUB $1, R13, R13											
  arithmetic.go:270		0x1000a0618		f10049bf		CMP $18, R13												
  arithmetic.go:270		0x1000a061c		54000148		BHI 10(PC)												
  arithmetic.go:270		0x1000a0620		924f3564		AND $9222809086901354496, R11, R4									
  arithmetic.go:270		0x1000a0624		d0000046		ADRP 40960(PC), R6											
  arithmetic.go:270		0x1000a0628		912080c6		ADD $2080, R6, R6											
  arithmetic.go:270		0x1000a062c		f86d78c6		MOVD (R6)(R13<<3), R6											
  arithmetic.go:270		0x1000a0630		9241018b		AND $-9223372036854775808, R12, R11									
  arithmetic.go:270		0x1000a0634		aa040164		ORR R4, R11, R4												
  arithmetic.go:270		0x1000a0638		9ac609ce		UDIV R6, R14, R14											
  arithmetic.go:270		0x1000a063c		ca080081		EOR R8, R4, R1												
  arithmetic.go:270		0x1000a0640		1400000a		JMP 10(PC)												
  arithmetic.go:270		0x1000a0644		aa0e03e0		MOVD R14, R0												
  arithmetic.go:270		0x1000a0648		aa0603e3		MOVD R6, R3												
  arithmetic.go:270		0x1000a064c		b27f03e4		ORR $2, ZR, R4												
  arithmetic.go:270		0x1000a0650		97ff6d20		CALL internal/decimal.quantize128(SB)									
  lib_go_decimal_poc.go:108	0x1000a0654		f9404fe3		MOVD 152(RSP), R3											
  lib_go_decimal_poc.go:108	0x1000a0658		f9405fe5		MOVD 184(RSP), R5											
  lib_go_decimal_poc.go:110	0x1000a065c		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a0660		d2e60808		MOVD $3476778912330022912, R8										
  decimal.go:164		0x1000a0664		aa0003ee		MOVD R0, R14												
  lib_go_decimal_poc.go:108	0x1000a0668		f9407fe4		MOVD 248(RSP), R4											
  lib_go_decimal_poc.go:108	0x1000a066c		92430486		AND $6917529027641081856, R4, R6									
  lib_go_decimal_poc.go:108	0x1000a0670		eb04003f		CMP R4, R1												
  decimal.go:164		0x1000a0674		54000141		BNE 10(PC)												
  lib_go_decimal_poc.go:108	0x1000a0678		f240c09f		TST $562949953421311, R4										
  lib_go_decimal_poc.go:108	0x1000a067c		54000821		BNE 65(PC)												
  lib_go_decimal_poc.go:108	0x1000a0680		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:108	0x1000a0684		540007e0		BEQ 63(PC)												
  lib_go_decimal_poc.go:108	0x1000a0688		f9407be6		MOVD 240(RSP), R6											
  lib_go_decimal_poc.go:108	0x1000a068c		ab0601c6		ADDS R6, R14, R6											
  lib_go_decimal_poc.go:108	0x1000a0690		9a1f03eb		ADC ZR, ZR, R11												
  lib_go_decimal_poc.go:108	0x1000a0694		aa040164		ORR R4, R11, R4												
  lib_go_decimal_poc.go:108	0x1000a0698		1400004a		JMP 74(PC)												
  lib_go_decimal_poc.go:108	0x1000a069c		aa01008b		ORR R1, R4, R11												
  lib_go_decimal_poc.go:108	0x1000a06a0		f240c17f		TST $562949953421311, R11										
  lib_go_decimal_poc.go:108	0x1000a06a4		540006e1		BNE 55(PC)												
  lib_go_decimal_poc.go:108	0x1000a06a8		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:108	0x1000a06ac		540006a0		BEQ 53(PC)												
  lib_go_decimal_poc.go:108	0x1000a06b0		92430426		AND $6917529027641081856, R1, R6									
  lib_go_decimal_poc.go:108	0x1000a06b4		eb0700df		CMP R7, R6												
  lib_go_decimal_poc.go:108	0x1000a06b8		54000640		BEQ 50(PC)												
  lib_go_decimal_poc.go:108	0x1000a06bc		ca080086		EOR R8, R4, R6												
  lib_go_decimal_poc.go:108	0x1000a06c0		ca08002b		EOR R8, R1, R11												
  lib_go_decimal_poc.go:108	0x1000a06c4		d371f8c6		UBFX $49, R6, $14, R6											
  lib_go_decimal_poc.go:108	0x1000a06c8		d371f96b		UBFX $49, R11, $14, R11											
  lib_go_decimal_poc.go:108	0x1000a06cc		cb06016c		SUB R6, R11, R12											
  lib_go_decimal_poc.go:108	0x1000a06d0		cb0b00cd		SUB R11, R6, R13											
  lib_go_decimal_poc.go:108	0x1000a06d4		eb06017f		CMP R6, R11												
  lib_go_decimal_poc.go:108	0x1000a06d8		9a8d818c		CSEL HI, R12, R13, R12											
  lib_go_decimal_poc.go:108	0x1000a06dc		f100399f		CMP $14, R12												
  lib_go_decimal_poc.go:108	0x1000a06e0		54000508		BHI 40(PC)												
  lib_go_decimal_poc.go:108	0x1000a06e4		eb06017f		CMP R6, R11												
  lib_go_decimal_poc.go:108	0x1000a06e8		f9407be6		MOVD 240(RSP), R6											
  lib_go_decimal_poc.go:108	0x1000a06ec		9a8681cb		CSEL HI, R14, R6, R11											
  lib_go_decimal_poc.go:108	0x1000a06f0		9a8e80c6		CSEL HI, R6, R14, R6											
  lib_go_decimal_poc.go:108	0x1000a06f4		9a81808d		CSEL HI, R4, R1, R13											
  lib_go_decimal_poc.go:108	0x1000a06f8		9a84802f		CSEL HI, R1, R4, R15											
  lib_go_decimal_poc.go:108	0x1000a06fc		d0000050		ADRP 40960(PC), R16											
  lib_go_decimal_poc.go:108	0x1000a0700		911ea210		ADD $1960, R16, R16											
  lib_go_decimal_poc.go:108	0x1000a0704		f86c7a0c		MOVD (R16)(R12<<3), R12											
  lib_go_decimal_poc.go:108	0x1000a0708		9b0b7d90		MUL R11, R12, R16											
  lib_go_decimal_poc.go:108	0x1000a070c		9bcb7d8b		UMULH R11, R12, R11											
  lib_go_decimal_poc.go:108	0x1000a0710		ca010084		EOR R1, R4, R4												
  lib_go_decimal_poc.go:108	0x1000a0714		b7f800c4		TBNZ $63, R4, 6(PC)											
  lib_go_decimal_poc.go:108	0x1000a0718		ab060206		ADDS R6, R16, R6											
  lib_go_decimal_poc.go:108	0x1000a071c		9a1f03ec		ADC ZR, ZR, R12												
  lib_go_decimal_poc.go:108	0x1000a0720		8b0c016b		ADD R12, R11, R11											
  lib_go_decimal_poc.go:108	0x1000a0724		aa0b01a4		ORR R11, R13, R4											
  lib_go_decimal_poc.go:108	0x1000a0728		14000026		JMP 38(PC)												
  lib_go_decimal_poc.go:108	0x1000a072c		cb1000cc		SUB R16, R6, R12											
  lib_go_decimal_poc.go:108	0x1000a0730		9240f9b1		AND $9223372036854775807, R13, R17									
  lib_go_decimal_poc.go:108	0x1000a0734		eb060213		SUBS R6, R16, R19											
  lib_go_decimal_poc.go:108	0x1000a0738		da1f03f4		NGC ZR, R20												
  lib_go_decimal_poc.go:108	0x1000a073c		8b140174		ADD R20, R11, R20											
  lib_go_decimal_poc.go:108	0x1000a0740		eb1000df		CMP R16, R6												
  lib_go_decimal_poc.go:108	0x1000a0744		9a9f97f0		CSET HI, R16												
  lib_go_decimal_poc.go:108	0x1000a0748		f100017f		CMP $0, R11												
  lib_go_decimal_poc.go:108	0x1000a074c		9a9f17eb		CSET EQ, R11												
  lib_go_decimal_poc.go:108	0x1000a0750		8a0b020b		AND R11, R16, R11											
  lib_go_decimal_poc.go:108	0x1000a0754		7200017f		TSTW $1, R11												
  lib_go_decimal_poc.go:108	0x1000a0758		9a931186		CSEL NE, R12, R19, R6											
  lib_go_decimal_poc.go:108	0x1000a075c		9a8f11ab		CSEL NE, R13, R15, R11											
  lib_go_decimal_poc.go:108	0x1000a0760		9a9f028c		CSEL EQ, R20, ZR, R12											
  lib_go_decimal_poc.go:108	0x1000a0764		aa0c00cd		ORR R12, R6, R13											
  lib_go_decimal_poc.go:108	0x1000a0768		9241016b		AND $-9223372036854775808, R11, R11									
  lib_go_decimal_poc.go:108	0x1000a076c		f10001bf		CMP $0, R13												
  lib_go_decimal_poc.go:108	0x1000a0770		9a9f116b		CSEL NE, R11, ZR, R11											
  lib_go_decimal_poc.go:108	0x1000a0774		aa0b022b		ORR R11, R17, R11											
  lib_go_decimal_poc.go:108	0x1000a0778		aa0c0164		ORR R12, R11, R4											
  lib_go_decimal_poc.go:108	0x1000a077c		14000011		JMP 17(PC)												
  decimal.go:164		0x1000a0780		f9005be1		MOVD R1, 176(RSP)											
  decimal.go:164		0x1000a0784		f9004bee		MOVD R14, 144(RSP)											
  lib_go_decimal_poc.go:108	0x1000a0788		ca080080		EOR R8, R4, R0												
  lib_go_decimal_poc.go:108	0x1000a078c		ca080022		EOR R8, R1, R2												
  lib_go_decimal_poc.go:108	0x1000a0790		f9407be1		MOVD 240(RSP), R1											
  lib_go_decimal_poc.go:108	0x1000a0794		aa0e03e3		MOVD R14, R3												
  lib_go_decimal_poc.go:108	0x1000a0798		97fdcf72		CALL runtime.dadd128(SB)										
  lib_go_decimal_poc.go:108	0x1000a079c		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:108	0x1000a07a0		ca040005		EOR R4, R0, R5												
  lib_go_decimal_poc.go:108	0x1000a07a4		f9404fe3		MOVD 152(RSP), R3											
  lib_go_decimal_poc.go:110	0x1000a07a8		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a07ac		d2e60808		MOVD $3476778912330022912, R8										
  lib_go_decimal_poc.go:108	0x1000a07b0		f9404bee		MOVD 144(RSP), R14											
  main.go:62			0x1000a07b4		aa0503e4		MOVD R5, R4												
  main.go:62			0x1000a07b8		aa0103e6		MOVD R1, R6												
  lib_go_decimal_poc.go:108	0x1000a07bc		a94b17e1		LDP 176(RSP), (R1, R5)											
  main.go:62			0x1000a07c0		a90f13e6		STP (R6, R4), 240(RSP)											
  lib_go_decimal_poc.go:108	0x1000a07c4		924304ab		AND $6917529027641081856, R5, R11									
  lib_go_decimal_poc.go:108	0x1000a07c8		eb05003f		CMP R5, R1												
  lib_go_decimal_poc.go:108	0x1000a07cc		54000121		BNE 9(PC)												
  lib_go_decimal_poc.go:108	0x1000a07d0		f240c0bf		TST $562949953421311, R5										
  lib_go_decimal_poc.go:108	0x1000a07d4		540007e1		BNE 63(PC)												
  lib_go_decimal_poc.go:108	0x1000a07d8		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a07dc		540007a0		BEQ 61(PC)												
  lib_go_decimal_poc.go:108	0x1000a07e0		ab0e0063		ADDS R14, R3, R3											
  lib_go_decimal_poc.go:108	0x1000a07e4		9a1f03eb		ADC ZR, ZR, R11												
  lib_go_decimal_poc.go:108	0x1000a07e8		aa050161		ORR R5, R11, R1												
  lib_go_decimal_poc.go:108	0x1000a07ec		14000048		JMP 72(PC)												
  lib_go_decimal_poc.go:108	0x1000a07f0		aa05002c		ORR R5, R1, R12												
  lib_go_decimal_poc.go:108	0x1000a07f4		f240c19f		TST $562949953421311, R12										
  lib_go_decimal_poc.go:108	0x1000a07f8		540006c1		BNE 54(PC)												
  lib_go_decimal_poc.go:108	0x1000a07fc		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a0800		54000680		BEQ 52(PC)												
  lib_go_decimal_poc.go:108	0x1000a0804		9243042b		AND $6917529027641081856, R1, R11									
  lib_go_decimal_poc.go:108	0x1000a0808		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a080c		54000620		BEQ 49(PC)												
  lib_go_decimal_poc.go:108	0x1000a0810		ca0800ab		EOR R8, R5, R11												
  lib_go_decimal_poc.go:108	0x1000a0814		ca08002c		EOR R8, R1, R12												
  lib_go_decimal_poc.go:108	0x1000a0818		d371f96b		UBFX $49, R11, $14, R11											
  lib_go_decimal_poc.go:108	0x1000a081c		d371f98c		UBFX $49, R12, $14, R12											
  lib_go_decimal_poc.go:108	0x1000a0820		cb0b018d		SUB R11, R12, R13											
  lib_go_decimal_poc.go:108	0x1000a0824		cb0c016f		SUB R12, R11, R15											
  lib_go_decimal_poc.go:108	0x1000a0828		eb0b019f		CMP R11, R12												
  lib_go_decimal_poc.go:108	0x1000a082c		9a8f81ad		CSEL HI, R13, R15, R13											
  lib_go_decimal_poc.go:108	0x1000a0830		f10039bf		CMP $14, R13												
  lib_go_decimal_poc.go:108	0x1000a0834		540004e8		BHI 39(PC)												
  lib_go_decimal_poc.go:108	0x1000a0838		eb0b019f		CMP R11, R12												
  lib_go_decimal_poc.go:108	0x1000a083c		9a8381cb		CSEL HI, R14, R3, R11											
  lib_go_decimal_poc.go:108	0x1000a0840		9a8e806c		CSEL HI, R3, R14, R12											
  lib_go_decimal_poc.go:108	0x1000a0844		9a8180ae		CSEL HI, R5, R1, R14											
  lib_go_decimal_poc.go:108	0x1000a0848		9a85802f		CSEL HI, R1, R5, R15											
  lib_go_decimal_poc.go:108	0x1000a084c		d0000050		ADRP 40960(PC), R16											
  lib_go_decimal_poc.go:108	0x1000a0850		911ea210		ADD $1960, R16, R16											
  lib_go_decimal_poc.go:108	0x1000a0854		f86d7a0d		MOVD (R16)(R13<<3), R13											
  lib_go_decimal_poc.go:108	0x1000a0858		9b0b7db0		MUL R11, R13, R16											
  lib_go_decimal_poc.go:108	0x1000a085c		9bcb7dab		UMULH R11, R13, R11											
  lib_go_decimal_poc.go:108	0x1000a0860		ca050025		EOR R5, R1, R5												
  lib_go_decimal_poc.go:108	0x1000a0864		b7f800c5		TBNZ $63, R5, 6(PC)											
  lib_go_decimal_poc.go:108	0x1000a0868		ab0c0203		ADDS R12, R16, R3											
  lib_go_decimal_poc.go:108	0x1000a086c		9a1f03e5		ADC ZR, ZR, R5												
  lib_go_decimal_poc.go:108	0x1000a0870		8b050165		ADD R5, R11, R5												
  lib_go_decimal_poc.go:108	0x1000a0874		aa0e00a1		ORR R14, R5, R1												
  lib_go_decimal_poc.go:108	0x1000a0878		14000025		JMP 37(PC)												
  lib_go_decimal_poc.go:108	0x1000a087c		cb100185		SUB R16, R12, R5											
  lib_go_decimal_poc.go:108	0x1000a0880		9240f9cd		AND $9223372036854775807, R14, R13									
  lib_go_decimal_poc.go:108	0x1000a0884		eb0c0211		SUBS R12, R16, R17											
  lib_go_decimal_poc.go:108	0x1000a0888		da1f03f3		NGC ZR, R19												
  lib_go_decimal_poc.go:108	0x1000a088c		8b130173		ADD R19, R11, R19											
  lib_go_decimal_poc.go:108	0x1000a0890		eb10019f		CMP R16, R12												
  lib_go_decimal_poc.go:108	0x1000a0894		9a9f97ec		CSET HI, R12												
  lib_go_decimal_poc.go:108	0x1000a0898		f100017f		CMP $0, R11												
  lib_go_decimal_poc.go:108	0x1000a089c		9a9f17eb		CSET EQ, R11												
  lib_go_decimal_poc.go:108	0x1000a08a0		8a0b018b		AND R11, R12, R11											
  lib_go_decimal_poc.go:108	0x1000a08a4		7200017f		TSTW $1, R11												
  lib_go_decimal_poc.go:108	0x1000a08a8		9a9110a3		CSEL NE, R5, R17, R3											
  lib_go_decimal_poc.go:108	0x1000a08ac		9a8f11c5		CSEL NE, R14, R15, R5											
  lib_go_decimal_poc.go:108	0x1000a08b0		9a9f026b		CSEL EQ, R19, ZR, R11											
  lib_go_decimal_poc.go:108	0x1000a08b4		aa0b006c		ORR R11, R3, R12											
  lib_go_decimal_poc.go:108	0x1000a08b8		924100a5		AND $-9223372036854775808, R5, R5									
  lib_go_decimal_poc.go:108	0x1000a08bc		f100019f		CMP $0, R12												
  lib_go_decimal_poc.go:108	0x1000a08c0		9a9f10a5		CSEL NE, R5, ZR, R5											
  lib_go_decimal_poc.go:108	0x1000a08c4		aa0501a5		ORR R5, R13, R5												
  lib_go_decimal_poc.go:108	0x1000a08c8		aa0b00a1		ORR R11, R5, R1												
  lib_go_decimal_poc.go:108	0x1000a08cc		14000010		JMP 16(PC)												
  lib_go_decimal_poc.go:108	0x1000a08d0		ca0800a0		EOR R8, R5, R0												
  lib_go_decimal_poc.go:108	0x1000a08d4		ca080022		EOR R8, R1, R2												
  lib_go_decimal_poc.go:108	0x1000a08d8		aa0303e1		MOVD R3, R1												
  lib_go_decimal_poc.go:108	0x1000a08dc		aa0e03e3		MOVD R14, R3												
  lib_go_decimal_poc.go:108	0x1000a08e0		97fdcf20		CALL runtime.dadd128(SB)										
  lib_go_decimal_poc.go:108	0x1000a08e4		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:108	0x1000a08e8		ca040005		EOR R4, R0, R5												
  main.go:65			0x1000a08ec		a94f13e6		LDP 240(RSP), (R6, R4)											
  lib_go_decimal_poc.go:110	0x1000a08f0		d2e80007		MOVD $4611686018427387904, R7										
  lib_go_decimal_poc.go:46	0x1000a08f4		d2e60808		MOVD $3476778912330022912, R8										
  main.go:63			0x1000a08f8		aa0103e3		MOVD R1, R3												
  main.go:63			0x1000a08fc		aa0503e1		MOVD R5, R1												
  lib_go_decimal_poc.go:108	0x1000a0900		14000003		JMP 3(PC)												
  main.go:65			0x1000a0904		aa0503e1		MOVD R5, R1												
  main.go:65			0x1000a0908		a94f13e6		LDP 240(RSP), (R6, R4)											
  main.go:65			0x1000a090c		a90f13e6		STP (R6, R4), 240(RSP)											
  lib_go_decimal_poc.go:108	0x1000a0910		f94077e5		MOVD 232(RSP), R5											
  lib_go_decimal_poc.go:108	0x1000a0914		924304ab		AND $6917529027641081856, R5, R11									
  lib_go_decimal_poc.go:108	0x1000a0918		eb05003f		CMP R5, R1												
  lib_go_decimal_poc.go:108	0x1000a091c		54000141		BNE 10(PC)												
  lib_go_decimal_poc.go:108	0x1000a0920		f240c0bf		TST $562949953421311, R5										
  lib_go_decimal_poc.go:108	0x1000a0924		54000821		BNE 65(PC)												
  lib_go_decimal_poc.go:108	0x1000a0928		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a092c		540007e0		BEQ 63(PC)												
  lib_go_decimal_poc.go:108	0x1000a0930		f94073e2		MOVD 224(RSP), R2											
  lib_go_decimal_poc.go:108	0x1000a0934		ab020062		ADDS R2, R3, R2												
  lib_go_decimal_poc.go:108	0x1000a0938		9a1f03e7		ADC ZR, ZR, R7												
  lib_go_decimal_poc.go:108	0x1000a093c		aa0500e5		ORR R5, R7, R5												
  lib_go_decimal_poc.go:108	0x1000a0940		14000044		JMP 68(PC)												
  lib_go_decimal_poc.go:108	0x1000a0944		aa0100ac		ORR R1, R5, R12												
  lib_go_decimal_poc.go:108	0x1000a0948		f240c19f		TST $562949953421311, R12										
  lib_go_decimal_poc.go:108	0x1000a094c		540006e1		BNE 55(PC)												
  lib_go_decimal_poc.go:108	0x1000a0950		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a0954		540006a0		BEQ 53(PC)												
  lib_go_decimal_poc.go:108	0x1000a0958		9243042b		AND $6917529027641081856, R1, R11									
  lib_go_decimal_poc.go:108	0x1000a095c		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a0960		54000640		BEQ 50(PC)												
  lib_go_decimal_poc.go:108	0x1000a0964		ca0800a7		EOR R8, R5, R7												
  lib_go_decimal_poc.go:108	0x1000a0968		ca08002b		EOR R8, R1, R11												
  lib_go_decimal_poc.go:108	0x1000a096c		d371f8e7		UBFX $49, R7, $14, R7											
  lib_go_decimal_poc.go:108	0x1000a0970		d371f96b		UBFX $49, R11, $14, R11											
  lib_go_decimal_poc.go:108	0x1000a0974		cb07016c		SUB R7, R11, R12											
  lib_go_decimal_poc.go:108	0x1000a0978		cb0b00ed		SUB R11, R7, R13											
  lib_go_decimal_poc.go:108	0x1000a097c		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a0980		9a8d818c		CSEL HI, R12, R13, R12											
  lib_go_decimal_poc.go:108	0x1000a0984		f100399f		CMP $14, R12												
  lib_go_decimal_poc.go:108	0x1000a0988		54000508		BHI 40(PC)												
  lib_go_decimal_poc.go:108	0x1000a098c		eb07017f		CMP R7, R11												
  lib_go_decimal_poc.go:108	0x1000a0990		f94073e2		MOVD 224(RSP), R2											
  lib_go_decimal_poc.go:108	0x1000a0994		9a828067		CSEL HI, R3, R2, R7											
  lib_go_decimal_poc.go:108	0x1000a0998		9a838042		CSEL HI, R2, R3, R2											
  lib_go_decimal_poc.go:108	0x1000a099c		9a8180a8		CSEL HI, R5, R1, R8											
  lib_go_decimal_poc.go:108	0x1000a09a0		9a85802b		CSEL HI, R1, R5, R11											
  lib_go_decimal_poc.go:108	0x1000a09a4		d000004d		ADRP 40960(PC), R13											
  lib_go_decimal_poc.go:108	0x1000a09a8		911ea1ad		ADD $1960, R13, R13											
  lib_go_decimal_poc.go:108	0x1000a09ac		f86c79ac		MOVD (R13)(R12<<3), R12											
  lib_go_decimal_poc.go:108	0x1000a09b0		9b077d8d		MUL R7, R12, R13											
  lib_go_decimal_poc.go:108	0x1000a09b4		9bc77d87		UMULH R7, R12, R7											
  lib_go_decimal_poc.go:108	0x1000a09b8		ca0100a5		EOR R1, R5, R5												
  lib_go_decimal_poc.go:108	0x1000a09bc		b7f800c5		TBNZ $63, R5, 6(PC)											
  lib_go_decimal_poc.go:108	0x1000a09c0		ab0201a2		ADDS R2, R13, R2											
  lib_go_decimal_poc.go:108	0x1000a09c4		9a1f03eb		ADC ZR, ZR, R11												
  lib_go_decimal_poc.go:108	0x1000a09c8		8b0b00e7		ADD R11, R7, R7												
  lib_go_decimal_poc.go:108	0x1000a09cc		aa0800e5		ORR R8, R7, R5												
  lib_go_decimal_poc.go:108	0x1000a09d0		14000020		JMP 32(PC)												
  lib_go_decimal_poc.go:108	0x1000a09d4		cb0d004c		SUB R13, R2, R12											
  lib_go_decimal_poc.go:108	0x1000a09d8		9240f90e		AND $9223372036854775807, R8, R14									
  lib_go_decimal_poc.go:108	0x1000a09dc		eb0201af		SUBS R2, R13, R15											
  lib_go_decimal_poc.go:108	0x1000a09e0		da1f03f0		NGC ZR, R16												
  lib_go_decimal_poc.go:108	0x1000a09e4		8b1000f0		ADD R16, R7, R16											
  lib_go_decimal_poc.go:108	0x1000a09e8		eb0d005f		CMP R13, R2												
  lib_go_decimal_poc.go:108	0x1000a09ec		9a9f97ed		CSET HI, R13												
  lib_go_decimal_poc.go:108	0x1000a09f0		f10000ff		CMP $0, R7												
  lib_go_decimal_poc.go:108	0x1000a09f4		9a9f17e7		CSET EQ, R7												
  lib_go_decimal_poc.go:108	0x1000a09f8		8a0701a7		AND R7, R13, R7												
  lib_go_decimal_poc.go:108	0x1000a09fc		720000ff		TSTW $1, R7												
  lib_go_decimal_poc.go:108	0x1000a0a00		9a8f1182		CSEL NE, R12, R15, R2											
  lib_go_decimal_poc.go:108	0x1000a0a04		9a8b1107		CSEL NE, R8, R11, R7											
  lib_go_decimal_poc.go:108	0x1000a0a08		9a9f0208		CSEL EQ, R16, ZR, R8											
  lib_go_decimal_poc.go:108	0x1000a0a0c		aa08004b		ORR R8, R2, R11												
  lib_go_decimal_poc.go:108	0x1000a0a10		924100e7		AND $-9223372036854775808, R7, R7									
  lib_go_decimal_poc.go:108	0x1000a0a14		f100017f		CMP $0, R11												
  lib_go_decimal_poc.go:108	0x1000a0a18		9a9f10e7		CSEL NE, R7, ZR, R7											
  lib_go_decimal_poc.go:108	0x1000a0a1c		aa0701c7		ORR R7, R14, R7												
  lib_go_decimal_poc.go:108	0x1000a0a20		aa0800e5		ORR R8, R7, R5												
  lib_go_decimal_poc.go:108	0x1000a0a24		1400000b		JMP 11(PC)												
  main.go:65			0x1000a0a28		a90d07e3		STP (R3, R1), 208(RSP)											
  lib_go_decimal_poc.go:108	0x1000a0a2c		ca0800a0		EOR R8, R5, R0												
  lib_go_decimal_poc.go:108	0x1000a0a30		ca080022		EOR R8, R1, R2												
  lib_go_decimal_poc.go:108	0x1000a0a34		f94073e1		MOVD 224(RSP), R1											
  lib_go_decimal_poc.go:108	0x1000a0a38		97fdceca		CALL runtime.dadd128(SB)										
  lib_go_decimal_poc.go:108	0x1000a0a3c		d2e60804		MOVD $3476778912330022912, R4										
  lib_go_decimal_poc.go:108	0x1000a0a40		ca040005		EOR R4, R0, R5												
  main.go:66			0x1000a0a44		f9406be3		MOVD 208(RSP), R3											
  main.go:65			0x1000a0a48		aa0103e2		MOVD R1, R2												
  main.go:66			0x1000a0a4c		f9406fe1		MOVD 216(RSP), R1											
  main.go:65			0x1000a0a50		a90e17e2		STP (R2, R5), 224(RSP)											
  main.go:66			0x1000a0a54		aa0303e0		MOVD R3, R0												
  main.go:66			0x1000a0a58		97fffa56		CALL github.com/migueldecimal128/go-decimal128-app-benchmark/internal/decimal.Decimal128.String(SB)	
  main.go:66			0x1000a0a5c		f940a3e2		MOVD 320(RSP), R2											
  main.go:66			0x1000a0a60		8b010043		ADD R1, R2, R3												
  main.go:66			0x1000a0a64		f940a7e4		MOVD 328(RSP), R4											
  main.go:66			0x1000a0a68		eb03009f		CMP R3, R4												
  main.go:66			0x1000a0a6c		54000063		BCC 3(PC)												
  main.go:66			0x1000a0a70		f940c3e5		MOVD 384(RSP), R5											
  main.go:66			0x1000a0a74		14000011		JMP 17(PC)												
  main.go:66			0x1000a0a78		f90097e1		MOVD R1, 296(RSP)											
  main.go:66			0x1000a0a7c		f900bfe0		MOVD R0, 376(RSP)											
  main.go:66			0x1000a0a80		f940c3e0		MOVD 384(RSP), R0											
  main.go:66			0x1000a0a84		aa0403e2		MOVD R4, R2												
  main.go:66			0x1000a0a88		d0000604		ADRP 794624(PC), R4											
  main.go:66			0x1000a0a8c		9102c084		ADD $176, R4, R4											
  main.go:66			0x1000a0a90		aa0103e5		MOVD R1, R5												
  main.go:66			0x1000a0a94		aa0303e1		MOVD R3, R1												
  main.go:66			0x1000a0a98		aa0503e3		MOVD R5, R3												
  main.go:66			0x1000a0a9c		97ff5119		CALL runtime.growslice(SB)										
  main.go:66			0x1000a0aa0		aa0203e4		MOVD R2, R4												
  main.go:66			0x1000a0aa4		aa0003e5		MOVD R0, R5												
  main.go:66			0x1000a0aa8		aa0103e3		MOVD R1, R3												
  main.go:66			0x1000a0aac		f940bfe0		MOVD 376(RSP), R0											
  main.go:66			0x1000a0ab0		f94097e1		MOVD 296(RSP), R1											
  main.go:66			0x1000a0ab4		f940a3e2		MOVD 320(RSP), R2											
  main.go:66			0x1000a0ab8		a91213e3		STP (R3, R4), 288(RSP)											
  main.go:66			0x1000a0abc		f900bfe5		MOVD R5, 376(RSP)											
  main.go:66			0x1000a0ac0		8b0200a3		ADD R2, R5, R3												
  main.go:66			0x1000a0ac4		aa0103e2		MOVD R1, R2												
  main.go:66			0x1000a0ac8		aa0003e1		MOVD R0, R1												
  main.go:66			0x1000a0acc		aa0303e0		MOVD R3, R0												
  main.go:66			0x1000a0ad0		97ff629c		CALL runtime.memmove(SB)										
  main.go:67			0x1000a0ad4		f94093e3		MOVD 288(RSP), R3											
  main.go:67			0x1000a0ad8		91000861		ADD $2, R3, R1												
  main.go:67			0x1000a0adc		f94097e2		MOVD 296(RSP), R2											
  main.go:67			0x1000a0ae0		eb01005f		CMP R1, R2												
  main.go:67			0x1000a0ae4		54000083		BCC 4(PC)												
  main.go:67			0x1000a0ae8		f940bfe5		MOVD 376(RSP), R5											
  main.go:67			0x1000a0aec		39417fe0		MOVBU 95(RSP), R0											
  main.go:67			0x1000a0af0		17fffcc8		JMP -824(PC)												
  main.go:67			0x1000a0af4		f100803f		CMP $32, R1												
  main.go:67			0x1000a0af8		5400014c		BGT 10(PC)												
  main.go:67			0x1000a0afc		39417fe0		MOVBU 95(RSP), R0											
  main.go:67			0x1000a0b00		37000100		TBNZ $0, R0, 8(PC)											
  main.go:67			0x1000a0b04		b50000e3		CBNZ R3, 7(PC)												
  main.go:67			0x1000a0b08		910563e5		ADD $344, RSP, R5											
  main.go:67			0x1000a0b0c		a9007cbf		STP (ZR, ZR), (R5)											
  main.go:67			0x1000a0b10		a9017cbf		STP (ZR, ZR), 16(R5)											
  main.go:67			0x1000a0b14		b27b03e2		ORR $32, ZR, R2												
  main.go:67			0x1000a0b18		b24003e0		ORR $1, ZR, R0												
  main.go:67			0x1000a0b1c		17fffcbd		JMP -835(PC)												
  main.go:67			0x1000a0b20		f940bfe0		MOVD 376(RSP), R0											
  main.go:67			0x1000a0b24		b27f03e3		ORR $2, ZR, R3												
  main.go:67			0x1000a0b28		d0000604		ADRP 794624(PC), R4											
  main.go:67			0x1000a0b2c		9102c084		ADD $176, R4, R4											
  main.go:67			0x1000a0b30		97ff50f4		CALL runtime.growslice(SB)										
  main.go:67			0x1000a0b34		aa0003e5		MOVD R0, R5												
  main.go:67			0x1000a0b38		39417fe0		MOVBU 95(RSP), R0											
  main.go:67			0x1000a0b3c		17fffcb5		JMP -843(PC)												
  main.go:69			0x1000a0b40		910643ee		ADD $400, RSP, R14											
  main.go:69			0x1000a0b44		910003ef		MOVD RSP, R15												
  main.go:69			0x1000a0b48		cb0f01ce		SUB R15, R14, R14											
  main.go:69			0x1000a0b4c		aa0303e0		MOVD R3, R0												
  main.go:69			0x1000a0b50		cb0f0070		SUB R15, R3, R16											
  main.go:69			0x1000a0b54		eb0e021f		CMP R14, R16												
  main.go:69			0x1000a0b58		54000182		BCS 12(PC)												
  main.go:69			0x1000a0b5c		aa0003e1		MOVD R0, R1												
  main.go:69			0x1000a0b60		aa0403e2		MOVD R4, R2												
  main.go:69			0x1000a0b64		b24003e0		ORR $1, ZR, R0												
  main.go:69			0x1000a0b68		97fee192		CALL runtime.moveSliceNoCapNoScan(SB)									
  main.go:69			0x1000a0b6c		f9407fe8		MOVD 248(RSP), R8											
  main.go:69			0x1000a0b70		f94087e9		MOVD 264(RSP), R9											
  main.go:69			0x1000a0b74		a94eafea		LDP 232(RSP), (R10, R11)										
  main.go:69			0x1000a0b78		f94083ec		MOVD 256(RSP), R12											
  main.go:69			0x1000a0b7c		f94073ed		MOVD 224(RSP), R13											
  main.go:69			0x1000a0b80		aa0103e4		MOVD R1, R4												
  main.go:69			0x1000a0b84		aa0203e5		MOVD R2, R5												
  main.go:69			0x1000a0b88		a9062bed		STP (R13, R10), 96(RSP)											
  main.go:69			0x1000a0b8c		a90727ec		STP (R12, R9), 112(RSP)											
  main.go:69			0x1000a0b90		a90823eb		STP (R11, R8), 128(RSP)											
  main.go:69			0x1000a0b94		a9462be3		LDP 96(RSP), (R3, R10)											
  main.go:69			0x1000a0b98		aa0403e1		MOVD R4, R1												
  main.go:69			0x1000a0b9c		aa0503e2		MOVD R5, R2												
  main.go:69			0x1000a0ba0		aa0a03e4		MOVD R10, R4												
  main.go:69			0x1000a0ba4		aa0c03e5		MOVD R12, R5												
  main.go:69			0x1000a0ba8		aa0903e6		MOVD R9, R6												
  main.go:69			0x1000a0bac		aa0b03e7		MOVD R11, R7												
  main.go:69			0x1000a0bb0		a97ffbfd		LDP -8(RSP), (R29, R30)											
  main.go:69			0x1000a0bb4		910643ff		ADD $400, RSP, RSP											
  main.go:69			0x1000a0bb8		d65f03c0		RET													
  binary.go:205			0x1000a0bbc		97ff61dd		CALL runtime.panicBounds(SB)										
  main.go:50			0x1000a0bc0		97ff61dc		CALL runtime.panicBounds(SB)										
  main.go:50			0x1000a0bc4		d503201f		NOOP													
  main.go:47			0x1000a0bc8		a90087e0		STP (R0, R1), 8(RSP)											
  main.go:47			0x1000a0bcc		a9018fe2		STP (R2, R3), 24(RSP)											
  main.go:47			0x1000a0bd0		a90297e4		STP (R4, R5), 40(RSP)											
  main.go:47			0x1000a0bd4		aa1e03e3		MOVD R30, R3												
  main.go:47			0x1000a0bd8		97ff5992		CALL runtime.morestack_noctxt.abi0(SB)									
  main.go:47			0x1000a0bdc		a94087e0		LDP 8(RSP), (R0, R1)											
  main.go:47			0x1000a0be0		a9418fe2		LDP 24(RSP), (R2, R3)											
  main.go:47			0x1000a0be4		a94297e4		LDP 40(RSP), (R4, R5)											
  main.go:47			0x1000a0be8		17fffc72		JMP main.bill(SB)											
  main.go:47			0x1000a0bec		00000000		?													
