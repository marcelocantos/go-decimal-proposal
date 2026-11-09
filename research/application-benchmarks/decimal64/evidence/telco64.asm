TEXT main.bill(SB) github.com/migueldecimal128/go-decimal128-app-benchmark/apps/telco/cmd/telco/main.go
  main.go:47			0x1000a0160		f9400b90		MOVD 16(R28), R16											
  main.go:47			0x1000a0164		d101c3f1		SUB $112, RSP, R17											
  main.go:47			0x1000a0168		eb10023f		CMP R16, R17												
  main.go:47			0x1000a016c		54002929		BLS 329(PC)												
  main.go:47			0x1000a0170		f8110ffe		MOVD.W R30, -240(RSP)											
  main.go:47			0x1000a0174		f81f83fd		MOVD R29, -8(RSP)											
  main.go:47			0x1000a0178		d10023fd		SUB $8, RSP, R29											
  main.go:47			0x1000a017c		f9008be3		MOVD R3, 272(RSP)											
  main.go:49			0x1000a0180		a9100be1		STP (R1, R2), 256(RSP)											
  main.go:49			0x1000a0184		f9007fe0		MOVD R0, 248(RSP)											
  main.go:49			0x1000a0188		aa1f03e6		MOVD ZR, R6												
  main.go:49			0x1000a018c		aa1f03e7		MOVD ZR, R7												
  main.go:49			0x1000a0190		aa1f03e8		MOVD ZR, R8												
  main.go:49			0x1000a0194		aa1f03e9		MOVD ZR, R9												
  main.go:49			0x1000a0198		aa1f03ea		MOVD ZR, R10												
  main.go:49			0x1000a019c		1400000d		JMP 13(PC)												
  main.go:67			0x1000a01a0		d100082b		SUB $2, R1, R11												
  main.go:67			0x1000a01a4		d28141ac		MOVD $2573, R12												
  main.go:67			0x1000a01a8		782b68ec		MOVH R12, (R7)(R11)											
  main.go:49			0x1000a01ac		f9404fe6		MOVD 152(RSP), R6											
  main.go:49			0x1000a01b0		aa0003e8		MOVD R0, R8												
  main.go:49			0x1000a01b4		a94aabe9		LDP 168(RSP), (R9, R10)											
  main.go:49			0x1000a01b8		aa0703e3		MOVD R7, R3												
  main.go:49			0x1000a01bc		aa0203e5		MOVD R2, R5												
  main.go:49			0x1000a01c0		aa0103e4		MOVD R1, R4												
  binary.go:207			0x1000a01c4		a94f87e0		LDP 248(RSP), (R0, R1)											
  main.go:50			0x1000a01c8		f94087e2		MOVD 264(RSP), R2											
  main.go:49			0x1000a01cc		f94043e7		MOVD 128(RSP), R7											
  main.go:49			0x1000a01d0		a90a9fe9		STP (R9, R7), 168(RSP)											
  main.go:49			0x1000a01d4		f90053ea		MOVD R10, 160(RSP)											
  main.go:49			0x1000a01d8		910020cb		ADD $8, R6, R11												
  main.go:49			0x1000a01dc		eb0b003f		CMP R11, R1												
  main.go:49			0x1000a01e0		5400224b		BLT 274(PC)												
  main.go:50			0x1000a01e4		eb06003f		CMP R6, R1												
  main.go:50			0x1000a01e8		54002503		BCC 296(PC)												
  main.go:50			0x1000a01ec		cb06002c		SUB R6, R1, R12												
  main.go:50			0x1000a01f0		cb0200cd		SUB R2, R6, R13												
  main.go:50			0x1000a01f4		8a8dfcc6		AND R13->63, R6, R6											
  binary.go:205			0x1000a01f8		f1001d9f		CMP $7, R12												
  binary.go:205			0x1000a01fc		54002449		BLS 290(PC)												
  main.go:49			0x1000a0200		a9092fe5		STP (R5, R11), 144(RSP)											
  main.go:49			0x1000a0204		f90047e4		MOVD R4, 136(RSP)											
  main.go:49			0x1000a0208		f90073e3		MOVD R3, 224(RSP)											
  main.go:49			0x1000a020c		39017fe8		MOVB R8, 95(RSP)											
  binary.go:207			0x1000a0210		f8666806		MOVD (R0)(R6), R6											
  main.go:52			0x1000a0214		b000081b		ADRP 1052672(PC), R27											
  main.go:52			0x1000a0218		f940db6c		MOVD 432(R27), R12											
  binary.go:207			0x1000a021c		dac00cc6		REV R6, R6												
  main.go:53			0x1000a0220		36000066		TBZ $0, R6, 3(PC)											
  main.go:54			0x1000a0224		b000081b		ADRP 1052672(PC), R27											
  main.go:54			0x1000a0228		f940df6c		MOVD 440(R27), R12											
  binary.go:207			0x1000a022c		f90043e6		MOVD R6, 128(RSP)											
  lib_go_decimal_poc64.go:123	0x1000a0230		d2e63801		MOVD $3584865303386914816, R1										
  lib_go_decimal_poc64.go:123	0x1000a0234		ca010181		EOR R1, R12, R1												
  lib_go_decimal_poc64.go:123	0x1000a0238		f9003fe1		MOVD R1, 120(RSP)											
  lib_go_decimal_poc64.go:59	0x1000a023c		aa0603e0		MOVD R6, R0												
  lib_go_decimal_poc64.go:59	0x1000a0240		97fdd224		CALL runtime.di64tod64(SB)										
  lib_go_decimal_poc64.go:123	0x1000a0244		aa0003e1		MOVD R0, R1												
  lib_go_decimal_poc64.go:123	0x1000a0248		f9403fe0		MOVD 120(RSP), R0											
  lib_go_decimal_poc64.go:123	0x1000a024c		97fdd1f5		CALL runtime.dmul64(SB)											
  lib_go_decimal_poc64.go:123	0x1000a0250		d2e63801		MOVD $3584865303386914816, R1										
  lib_go_decimal_poc64.go:123	0x1000a0254		ca010002		EOR R1, R0, R2												
  arithmetic.go:268		0x1000a0258		92430443		AND $6917529027641081856, R2, R3									
  main.go:56			0x1000a025c		b000081b		ADRP 1052672(PC), R27											
  main.go:56			0x1000a0260		f940eb64		MOVD 464(R27), R4											
  lib_go_decimal_poc64.go:126	0x1000a0264		d503201f		NOOP													
  decimal.go:159		0x1000a0268		d503201f		NOOP													
  arithmetic.go:268		0x1000a026c		d2e80005		MOVD $4611686018427387904, R5										
  arithmetic.go:268		0x1000a0270		eb05007f		CMP R5, R3												
  arithmetic.go:268		0x1000a0274		540004a0		BEQ 37(PC)												
  arithmetic.go:268		0x1000a0278		92430483		AND $6917529027641081856, R4, R3									
  arithmetic.go:268		0x1000a027c		eb05007f		CMP R5, R3												
  arithmetic.go:268		0x1000a0280		54000440		BEQ 34(PC)												
  arithmetic.go:268		0x1000a0284		ca010083		EOR R1, R4, R3												
  arithmetic.go:268		0x1000a0288		d375f805		UBFX $53, R0, $10, R5											
  arithmetic.go:268		0x1000a028c		d375f866		UBFX $53, R3, $10, R6											
  arithmetic.go:268		0x1000a0290		eb0500df		CMP R5, R6												
  arithmetic.go:268		0x1000a0294		54000061		BNE 3(PC)												
  arithmetic.go:262		0x1000a0298		aa0203e0		MOVD R2, R0												
  arithmetic.go:268		0x1000a029c		1400001f		JMP 31(PC)												
  arithmetic.go:268		0x1000a02a0		cb0500c5		SUB R5, R6, R5												
  arithmetic.go:268		0x1000a02a4		d10004a5		SUB $1, R5, R5												
  arithmetic.go:268		0x1000a02a8		f10048bf		CMP $18, R5												
  arithmetic.go:268		0x1000a02ac		540002e8		BHI 23(PC)												
  arithmetic.go:268		0x1000a02b0		924b2463		AND $9214364837600034816, R3, R3									
  arithmetic.go:268		0x1000a02b4		92410004		AND $-9223372036854775808, R0, R4									
  arithmetic.go:268		0x1000a02b8		aa030083		ORR R3, R4, R3												
  arithmetic.go:268		0x1000a02bc		ca010063		EOR R1, R3, R3												
  arithmetic.go:268		0x1000a02c0		d0000044		ADRP 40960(PC), R4											
  arithmetic.go:268		0x1000a02c4		910a9c84		ADD $679, R4, R4											
  arithmetic.go:268		0x1000a02c8		f8657884		MOVD (R4)(R5<<3), R4											
  arithmetic.go:268		0x1000a02cc		9240d005		AND $9007199254740991, R0, R5										
  arithmetic.go:268		0x1000a02d0		9ac408a6		UDIV R4, R5, R6												
  arithmetic.go:268		0x1000a02d4		9b069485		MSUB R6, R5, R4, R5											
  arithmetic.go:268		0x1000a02d8		eb4404bf		CMP R4>>1, R5												
  arithmetic.go:268		0x1000a02dc		9a9f97e4		CSET HI, R4												
  arithmetic.go:268		0x1000a02e0		9a9f17e5		CSET EQ, R5												
  arithmetic.go:268		0x1000a02e4		f24000df		TST $1, R6												
  arithmetic.go:268		0x1000a02e8		9a9f07e7		CSET NE, R7												
  arithmetic.go:268		0x1000a02ec		8a0700a5		AND R7, R5, R5												
  arithmetic.go:268		0x1000a02f0		aa050084		ORR R5, R4, R4												
  arithmetic.go:268		0x1000a02f4		d3401c84		UBFX $0, R4, $8, R4											
  arithmetic.go:268		0x1000a02f8		8b0400c4		ADD R4, R6, R4												
  arithmetic.go:268		0x1000a02fc		aa030082		ORR R3, R4, R2												
  arithmetic.go:262		0x1000a0300		aa0203e0		MOVD R2, R0												
  arithmetic.go:268		0x1000a0304		14000005		JMP 5(PC)												
  arithmetic.go:268		0x1000a0308		aa0203e0		MOVD R2, R0												
  arithmetic.go:268		0x1000a030c		aa0403e1		MOVD R4, R1												
  arithmetic.go:268		0x1000a0310		aa1f03e2		MOVD ZR, R2												
  arithmetic.go:268		0x1000a0314		97ff6ecb		CALL internal/decimal.quantize64(SB)									
  main.go:57			0x1000a0318		b000081b		ADRP 1052672(PC), R27											
  main.go:57			0x1000a031c		f940e362		MOVD 448(R27), R2											
  lib_go_decimal_poc64.go:123	0x1000a0320		d2e63803		MOVD $3584865303386914816, R3										
  lib_go_decimal_poc64.go:123	0x1000a0324		ca030041		EOR R3, R2, R1												
  lib_go_decimal_poc64.go:123	0x1000a0328		ca030000		EOR R3, R0, R0												
  lib_go_decimal_poc64.go:123	0x1000a032c		f9003fe0		MOVD R0, 120(RSP)											
  lib_go_decimal_poc64.go:123	0x1000a0330		97fdd1bc		CALL runtime.dmul64(SB)											
  lib_go_decimal_poc64.go:123	0x1000a0334		d2e63802		MOVD $3584865303386914816, R2										
  lib_go_decimal_poc64.go:123	0x1000a0338		ca020003		EOR R2, R0, R3												
  arithmetic.go:268		0x1000a033c		92430464		AND $6917529027641081856, R3, R4									
  main.go:57			0x1000a0340		b000081b		ADRP 1052672(PC), R27											
  main.go:57			0x1000a0344		f940eb61		MOVD 464(R27), R1											
  lib_go_decimal_poc64.go:154	0x1000a0348		d503201f		NOOP													
  arithmetic.go:268		0x1000a034c		d2e80005		MOVD $4611686018427387904, R5										
  arithmetic.go:268		0x1000a0350		eb05009f		CMP R5, R4												
  arithmetic.go:268		0x1000a0354		54000360		BEQ 27(PC)												
  arithmetic.go:268		0x1000a0358		92430424		AND $6917529027641081856, R1, R4									
  arithmetic.go:268		0x1000a035c		eb05009f		CMP R5, R4												
  arithmetic.go:268		0x1000a0360		54000300		BEQ 24(PC)												
  arithmetic.go:268		0x1000a0364		ca020024		EOR R2, R1, R4												
  arithmetic.go:268		0x1000a0368		d375f805		UBFX $53, R0, $10, R5											
  arithmetic.go:268		0x1000a036c		d375f886		UBFX $53, R4, $10, R6											
  arithmetic.go:268		0x1000a0370		eb0500df		CMP R5, R6												
  arithmetic.go:268		0x1000a0374		54000061		BNE 3(PC)												
  decimal.go:164		0x1000a0378		aa0303e0		MOVD R3, R0												
  arithmetic.go:268		0x1000a037c		14000014		JMP 20(PC)												
  arithmetic.go:268		0x1000a0380		cb0500c5		SUB R5, R6, R5												
  arithmetic.go:268		0x1000a0384		d10004a5		SUB $1, R5, R5												
  arithmetic.go:268		0x1000a0388		f10048bf		CMP $18, R5												
  arithmetic.go:268		0x1000a038c		540001a8		BHI 13(PC)												
  arithmetic.go:268		0x1000a0390		924b2484		AND $9214364837600034816, R4, R4									
  arithmetic.go:268		0x1000a0394		92410006		AND $-9223372036854775808, R0, R6									
  arithmetic.go:268		0x1000a0398		aa0400c4		ORR R4, R6, R4												
  arithmetic.go:268		0x1000a039c		ca020084		EOR R2, R4, R4												
  arithmetic.go:268		0x1000a03a0		d0000046		ADRP 40960(PC), R6											
  arithmetic.go:268		0x1000a03a4		910a9cc6		ADD $679, R6, R6											
  arithmetic.go:268		0x1000a03a8		f86578c5		MOVD (R6)(R5<<3), R5											
  arithmetic.go:268		0x1000a03ac		9240d006		AND $9007199254740991, R0, R6										
  arithmetic.go:268		0x1000a03b0		9ac508c5		UDIV R5, R6, R5												
  arithmetic.go:268		0x1000a03b4		aa0400a3		ORR R4, R5, R3												
  decimal.go:164		0x1000a03b8		aa0303e0		MOVD R3, R0												
  arithmetic.go:268		0x1000a03bc		14000004		JMP 4(PC)												
  arithmetic.go:268		0x1000a03c0		aa0303e0		MOVD R3, R0												
  arithmetic.go:268		0x1000a03c4		b27f03e2		ORR $2, ZR, R2												
  arithmetic.go:268		0x1000a03c8		97ff6e9e		CALL internal/decimal.quantize64(SB)									
  lib_go_decimal_poc64.go:121	0x1000a03cc		d2e63802		MOVD $3584865303386914816, R2										
  lib_go_decimal_poc64.go:121	0x1000a03d0		ca020001		EOR R2, R0, R1												
  lib_go_decimal_poc64.go:121	0x1000a03d4		f9003be1		MOVD R1, 112(RSP)											
  lib_go_decimal_poc64.go:121	0x1000a03d8		f94057e3		MOVD 168(RSP), R3											
  lib_go_decimal_poc64.go:121	0x1000a03dc		ca020060		EOR R2, R3, R0												
  main.go:58			0x1000a03e0		d503201f		NOOP													
  lib_go_decimal_poc64.go:121	0x1000a03e4		97fdd17f		CALL runtime.dadd64(SB)											
  lib_go_decimal_poc64.go:121	0x1000a03e8		f90057e0		MOVD R0, 168(RSP)											
  main.go:59			0x1000a03ec		d503201f		NOOP													
  lib_go_decimal_poc64.go:121	0x1000a03f0		a94703e1		LDP 112(RSP), (R1, R0)											
  lib_go_decimal_poc64.go:121	0x1000a03f4		97fdd17b		CALL runtime.dadd64(SB)											
  lib_go_decimal_poc64.go:121	0x1000a03f8		f94057e2		MOVD 168(RSP), R2											
  lib_go_decimal_poc64.go:121	0x1000a03fc		d2e63803		MOVD $3584865303386914816, R3										
  lib_go_decimal_poc64.go:121	0x1000a0400		ca030042		EOR R3, R2, R2												
  lib_go_decimal_poc64.go:121	0x1000a0404		f90057e2		MOVD R2, 168(RSP)											
  lib_go_decimal_poc64.go:121	0x1000a0408		ca030004		EOR R3, R0, R4												
  main.go:60			0x1000a040c		f94043e1		MOVD 128(RSP), R1											
  main.go:60			0x1000a0410		37000061		TBNZ $0, R1, 3(PC)											
  main.go:65			0x1000a0414		f9405be7		MOVD 176(RSP), R7											
  main.go:60			0x1000a0418		1400003e		JMP 62(PC)												
  lib_go_decimal_poc64.go:121	0x1000a041c		f90043e0		MOVD R0, 128(RSP)											
  main.go:61			0x1000a0420		b000081b		ADRP 1052672(PC), R27											
  main.go:61			0x1000a0424		f940e762		MOVD 456(R27), R2											
  lib_go_decimal_poc64.go:123	0x1000a0428		ca030041		EOR R3, R2, R1												
  lib_go_decimal_poc64.go:123	0x1000a042c		f9403fe0		MOVD 120(RSP), R0											
  lib_go_decimal_poc64.go:123	0x1000a0430		97fdd17c		CALL runtime.dmul64(SB)											
  lib_go_decimal_poc64.go:123	0x1000a0434		d2e63802		MOVD $3584865303386914816, R2										
  lib_go_decimal_poc64.go:123	0x1000a0438		ca020003		EOR R2, R0, R3												
  arithmetic.go:268		0x1000a043c		92430464		AND $6917529027641081856, R3, R4									
  main.go:61			0x1000a0440		b000081b		ADRP 1052672(PC), R27											
  main.go:61			0x1000a0444		f940eb61		MOVD 464(R27), R1											
  lib_go_decimal_poc64.go:154	0x1000a0448		d503201f		NOOP													
  arithmetic.go:268		0x1000a044c		d2e80005		MOVD $4611686018427387904, R5										
  arithmetic.go:268		0x1000a0450		eb05009f		CMP R5, R4												
  arithmetic.go:268		0x1000a0454		54000360		BEQ 27(PC)												
  arithmetic.go:268		0x1000a0458		92430424		AND $6917529027641081856, R1, R4									
  arithmetic.go:268		0x1000a045c		eb05009f		CMP R5, R4												
  arithmetic.go:268		0x1000a0460		54000300		BEQ 24(PC)												
  arithmetic.go:268		0x1000a0464		ca020024		EOR R2, R1, R4												
  arithmetic.go:268		0x1000a0468		d375f805		UBFX $53, R0, $10, R5											
  arithmetic.go:268		0x1000a046c		d375f886		UBFX $53, R4, $10, R6											
  arithmetic.go:268		0x1000a0470		eb0500df		CMP R5, R6												
  arithmetic.go:268		0x1000a0474		54000061		BNE 3(PC)												
  decimal.go:164		0x1000a0478		aa0303e0		MOVD R3, R0												
  arithmetic.go:268		0x1000a047c		14000014		JMP 20(PC)												
  arithmetic.go:268		0x1000a0480		cb0500c5		SUB R5, R6, R5												
  arithmetic.go:268		0x1000a0484		d10004a5		SUB $1, R5, R5												
  arithmetic.go:268		0x1000a0488		f10048bf		CMP $18, R5												
  arithmetic.go:268		0x1000a048c		540001a8		BHI 13(PC)												
  arithmetic.go:268		0x1000a0490		924b2484		AND $9214364837600034816, R4, R4									
  arithmetic.go:268		0x1000a0494		92410006		AND $-9223372036854775808, R0, R6									
  arithmetic.go:268		0x1000a0498		aa0400c4		ORR R4, R6, R4												
  arithmetic.go:268		0x1000a049c		ca020084		EOR R2, R4, R4												
  arithmetic.go:268		0x1000a04a0		d0000046		ADRP 40960(PC), R6											
  arithmetic.go:268		0x1000a04a4		910a9cc6		ADD $679, R6, R6											
  arithmetic.go:268		0x1000a04a8		f86578c5		MOVD (R6)(R5<<3), R5											
  arithmetic.go:268		0x1000a04ac		9240d006		AND $9007199254740991, R0, R6										
  arithmetic.go:268		0x1000a04b0		9ac508c5		UDIV R5, R6, R5												
  arithmetic.go:268		0x1000a04b4		aa0400a3		ORR R4, R5, R3												
  decimal.go:164		0x1000a04b8		aa0303e0		MOVD R3, R0												
  arithmetic.go:268		0x1000a04bc		14000004		JMP 4(PC)												
  arithmetic.go:268		0x1000a04c0		aa0303e0		MOVD R3, R0												
  arithmetic.go:268		0x1000a04c4		b27f03e2		ORR $2, ZR, R2												
  arithmetic.go:268		0x1000a04c8		97ff6e5e		CALL internal/decimal.quantize64(SB)									
  lib_go_decimal_poc64.go:121	0x1000a04cc		f9405be2		MOVD 176(RSP), R2											
  lib_go_decimal_poc64.go:121	0x1000a04d0		d2e63803		MOVD $3584865303386914816, R3										
  lib_go_decimal_poc64.go:121	0x1000a04d4		ca030042		EOR R3, R2, R2												
  lib_go_decimal_poc64.go:121	0x1000a04d8		ca030001		EOR R3, R0, R1												
  lib_go_decimal_poc64.go:121	0x1000a04dc		f9005be1		MOVD R1, 176(RSP)											
  main.go:62			0x1000a04e0		d503201f		NOOP													
  lib_go_decimal_poc64.go:121	0x1000a04e4		aa0203e0		MOVD R2, R0												
  lib_go_decimal_poc64.go:121	0x1000a04e8		97fdd13e		CALL runtime.dadd64(SB)											
  lib_go_decimal_poc64.go:121	0x1000a04ec		f9003fe0		MOVD R0, 120(RSP)											
  main.go:63			0x1000a04f0		d503201f		NOOP													
  lib_go_decimal_poc64.go:121	0x1000a04f4		f94043e0		MOVD 128(RSP), R0											
  lib_go_decimal_poc64.go:121	0x1000a04f8		f9405be1		MOVD 176(RSP), R1											
  lib_go_decimal_poc64.go:121	0x1000a04fc		97fdd139		CALL runtime.dadd64(SB)											
  lib_go_decimal_poc64.go:121	0x1000a0500		f9403fe2		MOVD 120(RSP), R2											
  lib_go_decimal_poc64.go:121	0x1000a0504		d2e63803		MOVD $3584865303386914816, R3										
  lib_go_decimal_poc64.go:121	0x1000a0508		ca030047		EOR R3, R2, R7												
  lib_go_decimal_poc64.go:121	0x1000a050c		ca030004		EOR R3, R0, R4												
  main.go:65			0x1000a0510		f9005be4		MOVD R4, 176(RSP)											
  main.go:65			0x1000a0514		f90043e7		MOVD R7, 128(RSP)											
  lib_go_decimal_poc64.go:121	0x1000a0518		ca030081		EOR R3, R4, R1												
  lib_go_decimal_poc64.go:121	0x1000a051c		f94053e2		MOVD 160(RSP), R2											
  lib_go_decimal_poc64.go:121	0x1000a0520		ca030040		EOR R3, R2, R0												
  lib_go_decimal_poc64.go:121	0x1000a0524		97fdd12f		CALL runtime.dadd64(SB)											
  lib_go_decimal_poc64.go:121	0x1000a0528		f90053e0		MOVD R0, 160(RSP)											
  main.go:66			0x1000a052c		f9405be0		MOVD 176(RSP), R0											
  main.go:66			0x1000a0530		97fffc90		CALL github.com/migueldecimal128/go-decimal128-app-benchmark/internal/decimal.Decimal128.String(SB)	
  main.go:66			0x1000a0534		f94047e2		MOVD 136(RSP), R2											
  main.go:66			0x1000a0538		8b010043		ADD R1, R2, R3												
  lib_go_decimal_poc64.go:121	0x1000a053c		f94053e4		MOVD 160(RSP), R4											
  lib_go_decimal_poc64.go:121	0x1000a0540		d2e63805		MOVD $3584865303386914816, R5										
  lib_go_decimal_poc64.go:121	0x1000a0544		ca050084		EOR R5, R4, R4												
  lib_go_decimal_poc64.go:121	0x1000a0548		f9005be4		MOVD R4, 176(RSP)											
  main.go:66			0x1000a054c		f9404be6		MOVD 144(RSP), R6											
  main.go:66			0x1000a0550		eb0300df		CMP R3, R6												
  main.go:66			0x1000a0554		54000063		BCC 3(PC)												
  main.go:66			0x1000a0558		f94073e7		MOVD 224(RSP), R7											
  main.go:66			0x1000a055c		14000011		JMP 17(PC)												
  main.go:66			0x1000a0560		f90037e1		MOVD R1, 104(RSP)											
  main.go:66			0x1000a0564		f9006fe0		MOVD R0, 216(RSP)											
  main.go:66			0x1000a0568		f94073e0		MOVD 224(RSP), R0											
  main.go:66			0x1000a056c		aa0603e2		MOVD R6, R2												
  main.go:66			0x1000a0570		d0000604		ADRP 794624(PC), R4											
  main.go:66			0x1000a0574		9102c084		ADD $176, R4, R4											
  main.go:66			0x1000a0578		aa0103e5		MOVD R1, R5												
  main.go:66			0x1000a057c		aa0303e1		MOVD R3, R1												
  main.go:66			0x1000a0580		aa0503e3		MOVD R5, R3												
  main.go:66			0x1000a0584		97ff533b		CALL runtime.growslice(SB)										
  main.go:66			0x1000a0588		aa0203e6		MOVD R2, R6												
  main.go:66			0x1000a058c		aa0003e7		MOVD R0, R7												
  main.go:66			0x1000a0590		aa0103e3		MOVD R1, R3												
  main.go:66			0x1000a0594		f9406fe0		MOVD 216(RSP), R0											
  main.go:66			0x1000a0598		f94037e1		MOVD 104(RSP), R1											
  main.go:66			0x1000a059c		f94047e2		MOVD 136(RSP), R2											
  main.go:66			0x1000a05a0		a9060fe6		STP (R6, R3), 96(RSP)											
  main.go:66			0x1000a05a4		f9006fe7		MOVD R7, 216(RSP)											
  main.go:66			0x1000a05a8		8b0200e3		ADD R2, R7, R3												
  main.go:66			0x1000a05ac		aa0103e2		MOVD R1, R2												
  main.go:66			0x1000a05b0		aa0003e1		MOVD R0, R1												
  main.go:66			0x1000a05b4		aa0303e0		MOVD R3, R0												
  main.go:66			0x1000a05b8		97ff64be		CALL runtime.memmove(SB)										
  main.go:67			0x1000a05bc		f94037e3		MOVD 104(RSP), R3											
  main.go:67			0x1000a05c0		91000861		ADD $2, R3, R1												
  main.go:67			0x1000a05c4		f94033e2		MOVD 96(RSP), R2											
  main.go:67			0x1000a05c8		eb01005f		CMP R1, R2												
  main.go:67			0x1000a05cc		54000083		BCC 4(PC)												
  main.go:67			0x1000a05d0		f9406fe7		MOVD 216(RSP), R7											
  main.go:67			0x1000a05d4		39417fe0		MOVBU 95(RSP), R0											
  main.go:67			0x1000a05d8		17fffef2		JMP -270(PC)												
  main.go:67			0x1000a05dc		f100803f		CMP $32, R1												
  main.go:67			0x1000a05e0		5400014c		BGT 10(PC)												
  main.go:67			0x1000a05e4		39417fe0		MOVBU 95(RSP), R0											
  main.go:67			0x1000a05e8		37000100		TBNZ $0, R0, 8(PC)											
  main.go:67			0x1000a05ec		b50000e3		CBNZ R3, 7(PC)												
  main.go:67			0x1000a05f0		9102e3e7		ADD $184, RSP, R7											
  main.go:67			0x1000a05f4		a9007cff		STP (ZR, ZR), (R7)											
  main.go:67			0x1000a05f8		a9017cff		STP (ZR, ZR), 16(R7)											
  main.go:67			0x1000a05fc		b27b03e2		ORR $32, ZR, R2												
  main.go:67			0x1000a0600		b24003e0		ORR $1, ZR, R0												
  main.go:67			0x1000a0604		17fffee7		JMP -281(PC)												
  main.go:67			0x1000a0608		f9406fe0		MOVD 216(RSP), R0											
  main.go:67			0x1000a060c		b27f03e3		ORR $2, ZR, R3												
  main.go:67			0x1000a0610		d0000604		ADRP 794624(PC), R4											
  main.go:67			0x1000a0614		9102c084		ADD $176, R4, R4											
  main.go:67			0x1000a0618		97ff5316		CALL runtime.growslice(SB)										
  main.go:67			0x1000a061c		aa0003e7		MOVD R0, R7												
  main.go:67			0x1000a0620		39417fe0		MOVBU 95(RSP), R0											
  main.go:67			0x1000a0624		17fffedf		JMP -289(PC)												
  main.go:69			0x1000a0628		9103c3e6		ADD $240, RSP, R6											
  main.go:69			0x1000a062c		910003e8		MOVD RSP, R8												
  main.go:69			0x1000a0630		cb0800c6		SUB R8, R6, R6												
  main.go:69			0x1000a0634		aa0303e0		MOVD R3, R0												
  main.go:69			0x1000a0638		cb080068		SUB R8, R3, R8												
  main.go:69			0x1000a063c		eb06011f		CMP R6, R8												
  main.go:69			0x1000a0640		54000122		BCS 9(PC)												
  main.go:69			0x1000a0644		aa0003e1		MOVD R0, R1												
  main.go:69			0x1000a0648		aa0403e2		MOVD R4, R2												
  main.go:69			0x1000a064c		b24003e0		ORR $1, ZR, R0												
  main.go:69			0x1000a0650		97fee3b4		CALL runtime.moveSliceNoCapNoScan(SB)									
  main.go:69			0x1000a0654		a94a9fe9		LDP 168(RSP), (R9, R7)											
  main.go:69			0x1000a0658		f94053ea		MOVD 160(RSP), R10											
  main.go:69			0x1000a065c		aa0103e4		MOVD R1, R4												
  main.go:69			0x1000a0660		aa0203e5		MOVD R2, R5												
  main.go:69			0x1000a0664		aa0403e1		MOVD R4, R1												
  main.go:69			0x1000a0668		aa0503e2		MOVD R5, R2												
  main.go:69			0x1000a066c		aa0a03e3		MOVD R10, R3												
  main.go:69			0x1000a0670		aa0903e4		MOVD R9, R4												
  main.go:69			0x1000a0674		aa0703e5		MOVD R7, R5												
  main.go:69			0x1000a0678		f85f83fd		MOVD -8(RSP), R29											
  main.go:69			0x1000a067c		f84f07fe		MOVD.P 240(RSP), R30											
  main.go:69			0x1000a0680		d65f03c0		RET													
  binary.go:205			0x1000a0684		97ff6407		CALL runtime.panicBounds(SB)										
  main.go:50			0x1000a0688		97ff6406		CALL runtime.panicBounds(SB)										
  main.go:50			0x1000a068c		d503201f		NOOP													
  main.go:47			0x1000a0690		a90087e0		STP (R0, R1), 8(RSP)											
  main.go:47			0x1000a0694		a9018fe2		STP (R2, R3), 24(RSP)											
  main.go:47			0x1000a0698		a90297e4		STP (R4, R5), 40(RSP)											
  main.go:47			0x1000a069c		aa1e03e3		MOVD R30, R3												
  main.go:47			0x1000a06a0		97ff5bbc		CALL runtime.morestack_noctxt.abi0(SB)									
  main.go:47			0x1000a06a4		a94087e0		LDP 8(RSP), (R0, R1)											
  main.go:47			0x1000a06a8		a9418fe2		LDP 24(RSP), (R2, R3)											
  main.go:47			0x1000a06ac		a94297e4		LDP 40(RSP), (R4, R5)											
  main.go:47			0x1000a06b0		17fffeac		JMP main.bill(SB)											
  main.go:47			0x1000a06b4		00000000		?													
  main.go:47			0x1000a06b8		00000000		?													
  main.go:47			0x1000a06bc		00000000		?													
