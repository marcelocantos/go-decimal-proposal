TEXT internal/bid_test.opCmp64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/operators_test.go
  operators_test.go:55	0x10023dfb0		b9000bff		MOVW ZR, 8(RSP)				
  operators_test.go:55	0x10023dfb4		79001bff		MOVH ZR, 12(RSP)			
  operators_test.go:56	0x10023dfb8		92430402		AND $6917529027641081856, R0, R2	
  operators_test.go:56	0x10023dfbc		9240d023		AND $9007199254740991, R1, R3		
  operators_test.go:56	0x10023dfc0		9240d004		AND $9007199254740991, R0, R4		
  operators_test.go:56	0x10023dfc4		d2e80005		MOVD $4611686018427387904, R5		
  operators_test.go:56	0x10023dfc8		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023dfcc		54000180		BEQ 12(PC)				
  operators_test.go:56	0x10023dfd0		92430426		AND $6917529027641081856, R1, R6	
  operators_test.go:56	0x10023dfd4		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023dfd8		54000120		BEQ 9(PC)				
  operators_test.go:56	0x10023dfdc		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023dfe0		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023dfe4		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023dfe8		d375f8e7		UBFX $53, R7, $10, R7			
  operators_test.go:56	0x10023dfec		d375f8c6		UBFX $53, R6, $10, R6			
  operators_test.go:56	0x10023dff0		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023dff4		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023dff8		14000042		JMP 66(PC)				
  operators_test.go:56	0x10023dffc		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e000		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e004		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e008		924610e8		AND $8935141660703064064, R7, R8	
  operators_test.go:56	0x10023e00c		924610c9		AND $8935141660703064064, R6, R9	
  operators_test.go:56	0x10023e010		d2ef800a		MOVD $8935141660703064064, R10		
  operators_test.go:56	0x10023e014		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e018		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023e01c		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e020		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e024		aa080128		ORR R8, R9, R8				
  operators_test.go:56	0x10023e028		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e02c		36000068		TBZ $0, R8, 3(PC)			
  operators_test.go:56	0x10023e030		aa1f03e6		MOVD ZR, R6				
  operators_test.go:56	0x10023e034		1400006b		JMP 107(PC)				
  operators_test.go:56	0x10023e038		92450ce8		AND $8646911284551352320, R7, R8	
  operators_test.go:56	0x10023e03c		92450cc9		AND $8646911284551352320, R6, R9	
  operators_test.go:56	0x10023e040		d2ef000a		MOVD $8646911284551352320, R10		
  operators_test.go:56	0x10023e044		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e048		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023e04c		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e050		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e054		aa08012a		ORR R8, R9, R10				
  operators_test.go:56	0x10023e058		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e05c		360000ea		TBZ $0, R10, 7(PC)			
  operators_test.go:56	0x10023e060		8a080126		AND R8, R9, R6				
  operators_test.go:56	0x10023e064		d37ffc27		LSR $63, R1, R7				
  operators_test.go:56	0x10023e068		ca40fce7		EOR R0>>63, R7, R7			
  operators_test.go:56	0x10023e06c		d24000e7		EOR $1, R7, R7				
  operators_test.go:56	0x10023e070		8a0600e6		AND R6, R7, R6				
  operators_test.go:56	0x10023e074		1400005b		JMP 91(PC)				
  operators_test.go:56	0x10023e078		d373f0e8		UBFX $51, R7, $10, R8			
  operators_test.go:56	0x10023e07c		d373f0c9		UBFX $51, R6, $10, R9			
  operators_test.go:56	0x10023e080		d375f8ea		UBFX $53, R7, $10, R10			
  operators_test.go:56	0x10023e084		d375f8cb		UBFX $53, R6, $10, R11			
  operators_test.go:56	0x10023e088		9240c8ec		AND $2251799813685247, R7, R12		
  operators_test.go:56	0x10023e08c		b24b018c		ORR $9007199254740992, R12, R12		
  operators_test.go:56	0x10023e090		9240c8cd		AND $2251799813685247, R6, R13		
  operators_test.go:56	0x10023e094		b24b01ad		ORR $9007199254740992, R13, R13		
  operators_test.go:56	0x10023e098		9240d0ee		AND $9007199254740991, R7, R14		
  operators_test.go:56	0x10023e09c		9240d0cf		AND $9007199254740991, R6, R15		
  operators_test.go:56	0x10023e0a0		924304f0		AND $6917529027641081856, R7, R16	
  operators_test.go:56	0x10023e0a4		924304d1		AND $6917529027641081856, R6, R17	
  operators_test.go:56	0x10023e0a8		d2ec0013		MOVD $6917529027641081856, R19		
  operators_test.go:56	0x10023e0ac		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e0b0		9a8b0126		CSEL EQ, R9, R11, R6			
  operators_test.go:56	0x10023e0b4		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e0b8		9a8a0107		CSEL EQ, R8, R10, R7			
  operators_test.go:56	0x10023e0bc		92b207e8		MOVD $-2420047873, R8			
  operators_test.go:56	0x10023e0c0		f2d0de48		MOVK $(34546<<32), R8			
  operators_test.go:56	0x10023e0c4		f2e00468		MOVK $(35<<48), R8			
  operators_test.go:56	0x10023e0c8		eb0801bf		CMP R8, R13				
  operators_test.go:56	0x10023e0cc		9a9f91a9		CSEL LS, R13, ZR, R9			
  operators_test.go:56	0x10023e0d0		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e0d4		9a8f0129		CSEL EQ, R9, R15, R9			
  operators_test.go:56	0x10023e0d8		eb08019f		CMP R8, R12				
  operators_test.go:56	0x10023e0dc		9a9f9188		CSEL LS, R12, ZR, R8			
  operators_test.go:56	0x10023e0e0		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e0e4		9a8e0108		CSEL EQ, R8, R14, R8			
  operators_test.go:56	0x10023e0e8		aa0803ea		MOVD R8, R10				
  operators_test.go:56	0x10023e0ec		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e0f0		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023e0f4		aa0903eb		MOVD R9, R11				
  operators_test.go:56	0x10023e0f8		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e0fc		aa0b03e3		MOVD R11, R3				
  operators_test.go:56	0x10023e100		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e104		9a9f07ea		CSET NE, R10				
  operators_test.go:56	0x10023e108		8a40fd4a		AND R0>>63, R10, R10			
  operators_test.go:56	0x10023e10c		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e110		9a9f07eb		CSET NE, R11				
  operators_test.go:56	0x10023e114		8a41fd6b		AND R1>>63, R11, R11			
  operators_test.go:56	0x10023e118		ca0a016a		EOR R10, R11, R10			
  operators_test.go:56	0x10023e11c		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e120		360000ca		TBZ $0, R10, 6(PC)			
  operators_test.go:56	0x10023e124		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e128		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e12c		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e130		aa1f03e6		MOVD ZR, R6				
  operators_test.go:56	0x10023e134		1400002b		JMP 43(PC)				
  operators_test.go:56	0x10023e138		9a9f17ea		CSET EQ, R10				
  operators_test.go:56	0x10023e13c		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e140		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e144		aa0b014a		ORR R11, R10, R10			
  operators_test.go:56	0x10023e148		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e14c		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e150		aa0b014a		ORR R11, R10, R10			
  operators_test.go:56	0x10023e154		3600010a		TBZ $0, R10, 8(PC)			
  operators_test.go:56	0x10023e158		eb04007f		CMP R4, R3				
  operators_test.go:56	0x10023e15c		9a9f17e3		CSET EQ, R3				
  operators_test.go:56	0x10023e160		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e164		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e168		aa0303e6		MOVD R3, R6				
  operators_test.go:56	0x10023e16c		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e170		1400001c		JMP 28(PC)				
  operators_test.go:56	0x10023e174		cb0700ca		SUB R7, R6, R10				
  operators_test.go:56	0x10023e178		cb0600eb		SUB R6, R7, R11				
  operators_test.go:56	0x10023e17c		9a8b814a		CSEL HI, R10, R11, R10			
  operators_test.go:56	0x10023e180		f1004d5f		CMP $19, R10				
  operators_test.go:56	0x10023e184		54000268		BHI 19(PC)				
  operators_test.go:56	0x10023e188		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e18c		9a848066		CSEL HI, R3, R4, R6			
  operators_test.go:56	0x10023e190		9a838083		CSEL HI, R4, R3, R3			
  operators_test.go:56	0x10023e194		900004c4		ADRP 622592(PC), R4			
  operators_test.go:56	0x10023e198		910d3084		ADD $844, R4, R4			
  operators_test.go:56	0x10023e19c		f86a7884		MOVD (R4)(R10<<3), R4			
  operators_test.go:56	0x10023e1a0		9bc67c87		UMULH R6, R4, R7			
  operators_test.go:56	0x10023e1a4		9b067c84		MUL R6, R4, R4				
  operators_test.go:56	0x10023e1a8		eb04007f		CMP R4, R3				
  operators_test.go:56	0x10023e1ac		9a9f17e3		CSET EQ, R3				
  operators_test.go:56	0x10023e1b0		f10000ff		CMP $0, R7				
  operators_test.go:56	0x10023e1b4		9a9f17e4		CSET EQ, R4				
  operators_test.go:56	0x10023e1b8		8a040063		AND R4, R3, R3				
  operators_test.go:56	0x10023e1bc		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e1c0		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e1c4		aa0303e6		MOVD R3, R6				
  operators_test.go:56	0x10023e1c8		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e1cc		14000005		JMP 5(PC)				
  operators_test.go:56	0x10023e1d0		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e1d4		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e1d8		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e1dc		aa1f03e6		MOVD ZR, R6				
  operators_test.go:56	0x10023e1e0		390023e6		MOVB R6, 8(RSP)				
  operators_test.go:56	0x10023e1e4		54000180		BEQ 12(PC)				
  operators_test.go:56	0x10023e1e8		92430426		AND $6917529027641081856, R1, R6	
  operators_test.go:56	0x10023e1ec		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023e1f0		54000120		BEQ 9(PC)				
  operators_test.go:56	0x10023e1f4		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e1f8		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e1fc		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e200		d375f8e7		UBFX $53, R7, $10, R7			
  operators_test.go:56	0x10023e204		d375f8c6		UBFX $53, R6, $10, R6			
  operators_test.go:56	0x10023e208		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e20c		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e210		14000043		JMP 67(PC)				
  operators_test.go:56	0x10023e214		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e218		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e21c		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e220		924610e8		AND $8935141660703064064, R7, R8	
  operators_test.go:56	0x10023e224		924610c9		AND $8935141660703064064, R6, R9	
  operators_test.go:56	0x10023e228		d2ef800a		MOVD $8935141660703064064, R10		
  operators_test.go:56	0x10023e22c		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e230		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023e234		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e238		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e23c		aa080128		ORR R8, R9, R8				
  operators_test.go:56	0x10023e240		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e244		36000068		TBZ $0, R8, 3(PC)			
  operators_test.go:56	0x10023e248		b24003e6		ORR $1, ZR, R6				
  operators_test.go:56	0x10023e24c		1400006a		JMP 106(PC)				
  operators_test.go:56	0x10023e250		92450ce8		AND $8646911284551352320, R7, R8	
  operators_test.go:56	0x10023e254		92450cc9		AND $8646911284551352320, R6, R9	
  operators_test.go:56	0x10023e258		d2ef000a		MOVD $8646911284551352320, R10		
  operators_test.go:56	0x10023e25c		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e260		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023e264		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e268		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e26c		aa08012a		ORR R8, R9, R10				
  operators_test.go:56	0x10023e270		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e274		3600010a		TBZ $0, R10, 8(PC)			
  operators_test.go:56	0x10023e278		8a080126		AND R8, R9, R6				
  operators_test.go:56	0x10023e27c		d37ffc27		LSR $63, R1, R7				
  operators_test.go:56	0x10023e280		ca40fce7		EOR R0>>63, R7, R7			
  operators_test.go:56	0x10023e284		d24000e7		EOR $1, R7, R7				
  operators_test.go:56	0x10023e288		8a0600e6		AND R6, R7, R6				
  operators_test.go:56	0x10023e28c		d24000c6		EOR $1, R6, R6				
  operators_test.go:56	0x10023e290		14000059		JMP 89(PC)				
  operators_test.go:56	0x10023e294		d373f0e8		UBFX $51, R7, $10, R8			
  operators_test.go:56	0x10023e298		d373f0c9		UBFX $51, R6, $10, R9			
  operators_test.go:56	0x10023e29c		d375f8ea		UBFX $53, R7, $10, R10			
  operators_test.go:56	0x10023e2a0		d375f8cb		UBFX $53, R6, $10, R11			
  operators_test.go:56	0x10023e2a4		9240c8ec		AND $2251799813685247, R7, R12		
  operators_test.go:56	0x10023e2a8		b24b018c		ORR $9007199254740992, R12, R12		
  operators_test.go:56	0x10023e2ac		9240c8cd		AND $2251799813685247, R6, R13		
  operators_test.go:56	0x10023e2b0		b24b01ad		ORR $9007199254740992, R13, R13		
  operators_test.go:56	0x10023e2b4		9240d0ee		AND $9007199254740991, R7, R14		
  operators_test.go:56	0x10023e2b8		9240d0cf		AND $9007199254740991, R6, R15		
  operators_test.go:56	0x10023e2bc		924304f0		AND $6917529027641081856, R7, R16	
  operators_test.go:56	0x10023e2c0		924304d1		AND $6917529027641081856, R6, R17	
  operators_test.go:56	0x10023e2c4		d2ec0013		MOVD $6917529027641081856, R19		
  operators_test.go:56	0x10023e2c8		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e2cc		9a8a0107		CSEL EQ, R8, R10, R7			
  operators_test.go:56	0x10023e2d0		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e2d4		9a8b0126		CSEL EQ, R9, R11, R6			
  operators_test.go:56	0x10023e2d8		92b207e8		MOVD $-2420047873, R8			
  operators_test.go:56	0x10023e2dc		f2d0de48		MOVK $(34546<<32), R8			
  operators_test.go:56	0x10023e2e0		f2e00468		MOVK $(35<<48), R8			
  operators_test.go:56	0x10023e2e4		eb0801bf		CMP R8, R13				
  operators_test.go:56	0x10023e2e8		9a9f91a9		CSEL LS, R13, ZR, R9			
  operators_test.go:56	0x10023e2ec		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e2f0		9a8f0129		CSEL EQ, R9, R15, R9			
  operators_test.go:56	0x10023e2f4		eb08019f		CMP R8, R12				
  operators_test.go:56	0x10023e2f8		9a9f9188		CSEL LS, R12, ZR, R8			
  operators_test.go:56	0x10023e2fc		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e300		9a8e0108		CSEL EQ, R8, R14, R8			
  operators_test.go:56	0x10023e304		aa0803ea		MOVD R8, R10				
  operators_test.go:56	0x10023e308		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e30c		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023e310		aa0903eb		MOVD R9, R11				
  operators_test.go:56	0x10023e314		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e318		aa0b03e3		MOVD R11, R3				
  operators_test.go:56	0x10023e31c		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e320		9a9f07ea		CSET NE, R10				
  operators_test.go:56	0x10023e324		8a41fd4a		AND R1>>63, R10, R10			
  operators_test.go:56	0x10023e328		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e32c		9a9f07eb		CSET NE, R11				
  operators_test.go:56	0x10023e330		8a40fd6b		AND R0>>63, R11, R11			
  operators_test.go:56	0x10023e334		ca0b014a		EOR R11, R10, R10			
  operators_test.go:56	0x10023e338		360000ca		TBZ $0, R10, 6(PC)			
  operators_test.go:56	0x10023e33c		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e340		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e344		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e348		b24003e6		ORR $1, ZR, R6				
  operators_test.go:56	0x10023e34c		1400002a		JMP 42(PC)				
  operators_test.go:56	0x10023e350		9a9f17ea		CSET EQ, R10				
  operators_test.go:56	0x10023e354		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e358		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e35c		aa0b014a		ORR R11, R10, R10			
  operators_test.go:56	0x10023e360		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e364		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e368		aa0a016a		ORR R10, R11, R10			
  operators_test.go:56	0x10023e36c		360000ea		TBZ $0, R10, 7(PC)			
  operators_test.go:56	0x10023e370		eb04007f		CMP R4, R3				
  operators_test.go:56	0x10023e374		9a9f07e6		CSET NE, R6				
  operators_test.go:56	0x10023e378		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e37c		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e380		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e384		1400001c		JMP 28(PC)				
  operators_test.go:56	0x10023e388		cb0700ca		SUB R7, R6, R10				
  operators_test.go:56	0x10023e38c		cb0600eb		SUB R6, R7, R11				
  operators_test.go:56	0x10023e390		9a8b814a		CSEL HI, R10, R11, R10			
  operators_test.go:56	0x10023e394		f1004d5f		CMP $19, R10				
  operators_test.go:56	0x10023e398		54000268		BHI 19(PC)				
  operators_test.go:56	0x10023e39c		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e3a0		9a848067		CSEL HI, R3, R4, R7			
  operators_test.go:56	0x10023e3a4		9a838083		CSEL HI, R4, R3, R3			
  operators_test.go:56	0x10023e3a8		900004c4		ADRP 622592(PC), R4			
  operators_test.go:56	0x10023e3ac		910d3084		ADD $844, R4, R4			
  operators_test.go:56	0x10023e3b0		f86a7884		MOVD (R4)(R10<<3), R4			
  operators_test.go:56	0x10023e3b4		9bc77c8a		UMULH R7, R4, R10			
  operators_test.go:56	0x10023e3b8		9b077c84		MUL R7, R4, R4				
  operators_test.go:56	0x10023e3bc		eb04007f		CMP R4, R3				
  operators_test.go:56	0x10023e3c0		9a9f17e3		CSET EQ, R3				
  operators_test.go:56	0x10023e3c4		f100015f		CMP $0, R10				
  operators_test.go:56	0x10023e3c8		9a9f17e4		CSET EQ, R4				
  operators_test.go:56	0x10023e3cc		8a040063		AND R4, R3, R3				
  operators_test.go:56	0x10023e3d0		d2400066		EOR $1, R3, R6				
  operators_test.go:56	0x10023e3d4		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e3d8		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e3dc		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e3e0		14000005		JMP 5(PC)				
  operators_test.go:56	0x10023e3e4		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e3e8		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e3ec		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e3f0		b24003e6		ORR $1, ZR, R6				
  operators_test.go:56	0x10023e3f4		390027e6		MOVB R6, 9(RSP)				
  operators_test.go:56	0x10023e3f8		54000180		BEQ 12(PC)				
  operators_test.go:56	0x10023e3fc		92430426		AND $6917529027641081856, R1, R6	
  operators_test.go:56	0x10023e400		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023e404		54000120		BEQ 9(PC)				
  operators_test.go:56	0x10023e408		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e40c		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e410		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e414		d375f8e7		UBFX $53, R7, $10, R7			
  operators_test.go:56	0x10023e418		d375f8c6		UBFX $53, R6, $10, R6			
  operators_test.go:56	0x10023e41c		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e420		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e424		1400004d		JMP 77(PC)				
  operators_test.go:56	0x10023e428		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e42c		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e430		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e434		924610e8		AND $8935141660703064064, R7, R8	
  operators_test.go:56	0x10023e438		924610c9		AND $8935141660703064064, R6, R9	
  operators_test.go:56	0x10023e43c		d2ef800a		MOVD $8935141660703064064, R10		
  operators_test.go:56	0x10023e440		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e444		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023e448		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e44c		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e450		aa080128		ORR R8, R9, R8				
  operators_test.go:56	0x10023e454		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e458		36000068		TBZ $0, R8, 3(PC)			
  operators_test.go:56	0x10023e45c		aa1f03ea		MOVD ZR, R10				
  operators_test.go:56	0x10023e460		1400007d		JMP 125(PC)				
  operators_test.go:56	0x10023e464		92450ce8		AND $8646911284551352320, R7, R8	
  operators_test.go:56	0x10023e468		92450cc9		AND $8646911284551352320, R6, R9	
  operators_test.go:56	0x10023e46c		d2ef000a		MOVD $8646911284551352320, R10		
  operators_test.go:56	0x10023e470		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e474		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e478		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e47c		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e480		aa0b012c		ORR R11, R9, R12			
  operators_test.go:56	0x10023e484		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e488		3600024c		TBZ $0, R12, 18(PC)			
  operators_test.go:56	0x10023e48c		9a9f07e6		CSET NE, R6				
  operators_test.go:56	0x10023e490		8a0b0127		AND R11, R9, R7				
  operators_test.go:56	0x10023e494		8a40fd68		AND R0>>63, R11, R8			
  operators_test.go:56	0x10023e498		d37ffc2a		LSR $63, R1, R10			
  operators_test.go:56	0x10023e49c		ca40fd4b		EOR R0>>63, R10, R11			
  operators_test.go:56	0x10023e4a0		d240016b		EOR $1, R11, R11			
  operators_test.go:56	0x10023e4a4		8a070167		AND R7, R11, R7				
  operators_test.go:56	0x10023e4a8		d24000e7		EOR $1, R7, R7				
  operators_test.go:56	0x10023e4ac		8a0800e8		AND R8, R7, R8				
  operators_test.go:56	0x10023e4b0		d240014a		EOR $1, R10, R10			
  operators_test.go:56	0x10023e4b4		8a090149		AND R9, R10, R9				
  operators_test.go:56	0x10023e4b8		8a060126		AND R6, R9, R6				
  operators_test.go:56	0x10023e4bc		aa060106		ORR R6, R8, R6				
  operators_test.go:56	0x10023e4c0		8a0600e6		AND R6, R7, R6				
  operators_test.go:56	0x10023e4c4		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e4c8		aa0603ea		MOVD R6, R10				
  operators_test.go:56	0x10023e4cc		14000062		JMP 98(PC)				
  operators_test.go:56	0x10023e4d0		d373f0e8		UBFX $51, R7, $10, R8			
  operators_test.go:56	0x10023e4d4		d373f0c9		UBFX $51, R6, $10, R9			
  operators_test.go:56	0x10023e4d8		d375f8ea		UBFX $53, R7, $10, R10			
  operators_test.go:56	0x10023e4dc		d375f8cb		UBFX $53, R6, $10, R11			
  operators_test.go:56	0x10023e4e0		9240c8ec		AND $2251799813685247, R7, R12		
  operators_test.go:56	0x10023e4e4		b24b018c		ORR $9007199254740992, R12, R12		
  operators_test.go:56	0x10023e4e8		9240c8cd		AND $2251799813685247, R6, R13		
  operators_test.go:56	0x10023e4ec		b24b01ad		ORR $9007199254740992, R13, R13		
  operators_test.go:56	0x10023e4f0		9240d0ee		AND $9007199254740991, R7, R14		
  operators_test.go:56	0x10023e4f4		9240d0cf		AND $9007199254740991, R6, R15		
  operators_test.go:56	0x10023e4f8		924304f0		AND $6917529027641081856, R7, R16	
  operators_test.go:56	0x10023e4fc		924304d1		AND $6917529027641081856, R6, R17	
  operators_test.go:56	0x10023e500		d2ec0013		MOVD $6917529027641081856, R19		
  operators_test.go:56	0x10023e504		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e508		9a8a0107		CSEL EQ, R8, R10, R7			
  operators_test.go:56	0x10023e50c		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e510		9a8b0126		CSEL EQ, R9, R11, R6			
  operators_test.go:56	0x10023e514		92b207e8		MOVD $-2420047873, R8			
  operators_test.go:56	0x10023e518		f2d0de48		MOVK $(34546<<32), R8			
  operators_test.go:56	0x10023e51c		f2e00468		MOVK $(35<<48), R8			
  operators_test.go:56	0x10023e520		eb0801bf		CMP R8, R13				
  operators_test.go:56	0x10023e524		9a9f91a9		CSEL LS, R13, ZR, R9			
  operators_test.go:56	0x10023e528		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e52c		9a8f0129		CSEL EQ, R9, R15, R9			
  operators_test.go:56	0x10023e530		eb08019f		CMP R8, R12				
  operators_test.go:56	0x10023e534		9a9f9188		CSEL LS, R12, ZR, R8			
  operators_test.go:56	0x10023e538		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e53c		9a8e0108		CSEL EQ, R8, R14, R8			
  operators_test.go:56	0x10023e540		aa0803ea		MOVD R8, R10				
  operators_test.go:56	0x10023e544		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e548		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023e54c		aa0903eb		MOVD R9, R11				
  operators_test.go:56	0x10023e550		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e554		aa0b03e3		MOVD R11, R3				
  operators_test.go:56	0x10023e558		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e55c		9a9f07ea		CSET NE, R10				
  operators_test.go:56	0x10023e560		8a40fd4a		AND R0>>63, R10, R10			
  operators_test.go:56	0x10023e564		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e568		9a9f07eb		CSET NE, R11				
  operators_test.go:56	0x10023e56c		8a41fd6b		AND R1>>63, R11, R11			
  operators_test.go:56	0x10023e570		ca0a016b		EOR R10, R11, R11			
  operators_test.go:56	0x10023e574		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e578		360000ab		TBZ $0, R11, 5(PC)			
  operators_test.go:56	0x10023e57c		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e580		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e584		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e588		14000033		JMP 51(PC)				
  operators_test.go:56	0x10023e58c		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e590		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e594		9a9f17ec		CSET EQ, R12				
  operators_test.go:56	0x10023e598		aa0c016b		ORR R12, R11, R11			
  operators_test.go:56	0x10023e59c		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e5a0		9a9f17ec		CSET EQ, R12				
  operators_test.go:56	0x10023e5a4		aa0b018b		ORR R11, R12, R11			
  operators_test.go:56	0x10023e5a8		3600014b		TBZ $0, R11, 10(PC)			
  operators_test.go:56	0x10023e5ac		eb04007f		CMP R4, R3				
  operators_test.go:56	0x10023e5b0		9a9f97e3		CSET HI, R3				
  operators_test.go:56	0x10023e5b4		9a9f07e4		CSET NE, R4				
  operators_test.go:56	0x10023e5b8		ca0a0063		EOR R10, R3, R3				
  operators_test.go:56	0x10023e5bc		8a03008a		AND R3, R4, R10				
  operators_test.go:56	0x10023e5c0		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e5c4		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e5c8		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e5cc		14000022		JMP 34(PC)				
  operators_test.go:56	0x10023e5d0		9a9f97eb		CSET HI, R11				
  operators_test.go:56	0x10023e5d4		cb0700cc		SUB R7, R6, R12				
  operators_test.go:56	0x10023e5d8		cb0600ed		SUB R6, R7, R13				
  operators_test.go:56	0x10023e5dc		9a8d818c		CSEL HI, R12, R13, R12			
  operators_test.go:56	0x10023e5e0		f1004d9f		CMP $19, R12				
  operators_test.go:56	0x10023e5e4		54000308		BHI 24(PC)				
  operators_test.go:56	0x10023e5e8		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e5ec		9a848066		CSEL HI, R3, R4, R6			
  operators_test.go:56	0x10023e5f0		9a838083		CSEL HI, R4, R3, R3			
  operators_test.go:56	0x10023e5f4		ca0a0164		EOR R10, R11, R4			
  operators_test.go:56	0x10023e5f8		900004c7		ADRP 622592(PC), R7			
  operators_test.go:56	0x10023e5fc		910d30e7		ADD $844, R7, R7			
  operators_test.go:56	0x10023e600		f86c78e7		MOVD (R7)(R12<<3), R7			
  operators_test.go:56	0x10023e604		9bc67ceb		UMULH R6, R7, R11			
  operators_test.go:56	0x10023e608		9b067ce6		MUL R6, R7, R6				
  operators_test.go:56	0x10023e60c		eb06007f		CMP R6, R3				
  operators_test.go:56	0x10023e610		9a9f17e3		CSET EQ, R3				
  operators_test.go:56	0x10023e614		9a9f97e6		CSET HI, R6				
  operators_test.go:56	0x10023e618		f100017f		CMP $0, R11				
  operators_test.go:56	0x10023e61c		9a9f17e7		CSET EQ, R7				
  operators_test.go:56	0x10023e620		8a070063		AND R7, R3, R3				
  operators_test.go:56	0x10023e624		8a0700c6		AND R7, R6, R6				
  operators_test.go:56	0x10023e628		ca0400c4		EOR R4, R6, R4				
  operators_test.go:56	0x10023e62c		d2400063		EOR $1, R3, R3				
  operators_test.go:56	0x10023e630		8a04006a		AND R4, R3, R10				
  operators_test.go:56	0x10023e634		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e638		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e63c		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e640		14000005		JMP 5(PC)				
  operators_test.go:56	0x10023e644		ca0a016a		EOR R10, R11, R10			
  operators_test.go:56	0x10023e648		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e64c		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e650		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e654		39002bea		MOVB R10, 10(RSP)			
  operators_test.go:56	0x10023e658		54000180		BEQ 12(PC)				
  operators_test.go:56	0x10023e65c		92430426		AND $6917529027641081856, R1, R6	
  operators_test.go:56	0x10023e660		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023e664		54000120		BEQ 9(PC)				
  operators_test.go:56	0x10023e668		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e66c		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e670		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e674		d375f8e7		UBFX $53, R7, $10, R7			
  operators_test.go:56	0x10023e678		d375f8c6		UBFX $53, R6, $10, R6			
  operators_test.go:56	0x10023e67c		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e680		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e684		1400004b		JMP 75(PC)				
  operators_test.go:56	0x10023e688		d2e63806		MOVD $3584865303386914816, R6		
  operators_test.go:56	0x10023e68c		ca060007		EOR R6, R0, R7				
  operators_test.go:56	0x10023e690		ca060026		EOR R6, R1, R6				
  operators_test.go:56	0x10023e694		924610e8		AND $8935141660703064064, R7, R8	
  operators_test.go:56	0x10023e698		924610c9		AND $8935141660703064064, R6, R9	
  operators_test.go:56	0x10023e69c		d2ef800a		MOVD $8935141660703064064, R10		
  operators_test.go:56	0x10023e6a0		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e6a4		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023e6a8		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e6ac		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e6b0		aa080128		ORR R8, R9, R8				
  operators_test.go:56	0x10023e6b4		36000068		TBZ $0, R8, 3(PC)			
  operators_test.go:56	0x10023e6b8		aa1f03ea		MOVD ZR, R10				
  operators_test.go:56	0x10023e6bc		14000077		JMP 119(PC)				
  operators_test.go:56	0x10023e6c0		92450ce8		AND $8646911284551352320, R7, R8	
  operators_test.go:56	0x10023e6c4		92450cc9		AND $8646911284551352320, R6, R9	
  operators_test.go:56	0x10023e6c8		d2ef000a		MOVD $8646911284551352320, R10		
  operators_test.go:56	0x10023e6cc		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e6d0		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e6d4		eb0a013f		CMP R10, R9				
  operators_test.go:56	0x10023e6d8		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e6dc		aa0b012c		ORR R11, R9, R12			
  operators_test.go:56	0x10023e6e0		eb0a011f		CMP R10, R8				
  operators_test.go:56	0x10023e6e4		3600022c		TBZ $0, R12, 17(PC)			
  operators_test.go:56	0x10023e6e8		9a9f07e6		CSET NE, R6				
  operators_test.go:56	0x10023e6ec		8a0b0127		AND R11, R9, R7				
  operators_test.go:56	0x10023e6f0		8a40fd68		AND R0>>63, R11, R8			
  operators_test.go:56	0x10023e6f4		d37ffc2a		LSR $63, R1, R10			
  operators_test.go:56	0x10023e6f8		ca40fd4b		EOR R0>>63, R10, R11			
  operators_test.go:56	0x10023e6fc		d240016b		EOR $1, R11, R11			
  operators_test.go:56	0x10023e700		8a070167		AND R7, R11, R7				
  operators_test.go:56	0x10023e704		d24000eb		EOR $1, R7, R11				
  operators_test.go:56	0x10023e708		8a080168		AND R8, R11, R8				
  operators_test.go:56	0x10023e70c		d240014a		EOR $1, R10, R10			
  operators_test.go:56	0x10023e710		8a090149		AND R9, R10, R9				
  operators_test.go:56	0x10023e714		8a060126		AND R6, R9, R6				
  operators_test.go:56	0x10023e718		aa060106		ORR R6, R8, R6				
  operators_test.go:56	0x10023e71c		aa0600e6		ORR R6, R7, R6				
  operators_test.go:56	0x10023e720		aa0603ea		MOVD R6, R10				
  operators_test.go:56	0x10023e724		1400005d		JMP 93(PC)				
  operators_test.go:56	0x10023e728		d373f0e8		UBFX $51, R7, $10, R8			
  operators_test.go:56	0x10023e72c		d373f0c9		UBFX $51, R6, $10, R9			
  operators_test.go:56	0x10023e730		d375f8ea		UBFX $53, R7, $10, R10			
  operators_test.go:56	0x10023e734		d375f8cb		UBFX $53, R6, $10, R11			
  operators_test.go:56	0x10023e738		9240c8ec		AND $2251799813685247, R7, R12		
  operators_test.go:56	0x10023e73c		b24b018c		ORR $9007199254740992, R12, R12		
  operators_test.go:56	0x10023e740		9240c8cd		AND $2251799813685247, R6, R13		
  operators_test.go:56	0x10023e744		b24b01ad		ORR $9007199254740992, R13, R13		
  operators_test.go:56	0x10023e748		9240d0ee		AND $9007199254740991, R7, R14		
  operators_test.go:56	0x10023e74c		9240d0cf		AND $9007199254740991, R6, R15		
  operators_test.go:56	0x10023e750		924304f0		AND $6917529027641081856, R7, R16	
  operators_test.go:56	0x10023e754		924304d1		AND $6917529027641081856, R6, R17	
  operators_test.go:56	0x10023e758		d2ec0013		MOVD $6917529027641081856, R19		
  operators_test.go:56	0x10023e75c		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e760		9a8a0107		CSEL EQ, R8, R10, R7			
  operators_test.go:56	0x10023e764		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e768		9a8b0126		CSEL EQ, R9, R11, R6			
  operators_test.go:56	0x10023e76c		92b207e8		MOVD $-2420047873, R8			
  operators_test.go:56	0x10023e770		f2d0de48		MOVK $(34546<<32), R8			
  operators_test.go:56	0x10023e774		f2e00468		MOVK $(35<<48), R8			
  operators_test.go:56	0x10023e778		eb0801bf		CMP R8, R13				
  operators_test.go:56	0x10023e77c		9a9f91a9		CSEL LS, R13, ZR, R9			
  operators_test.go:56	0x10023e780		eb13023f		CMP R19, R17				
  operators_test.go:56	0x10023e784		9a8f0129		CSEL EQ, R9, R15, R9			
  operators_test.go:56	0x10023e788		eb08019f		CMP R8, R12				
  operators_test.go:56	0x10023e78c		9a9f9188		CSEL LS, R12, ZR, R8			
  operators_test.go:56	0x10023e790		eb13021f		CMP R19, R16				
  operators_test.go:56	0x10023e794		9a8e0108		CSEL EQ, R8, R14, R8			
  operators_test.go:56	0x10023e798		aa0803ea		MOVD R8, R10				
  operators_test.go:56	0x10023e79c		aa0403e8		MOVD R4, R8				
  operators_test.go:56	0x10023e7a0		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023e7a4		aa0903eb		MOVD R9, R11				
  operators_test.go:56	0x10023e7a8		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e7ac		aa0b03e3		MOVD R11, R3				
  operators_test.go:56	0x10023e7b0		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e7b4		9a9f07ea		CSET NE, R10				
  operators_test.go:56	0x10023e7b8		8a40fd4a		AND R0>>63, R10, R10			
  operators_test.go:56	0x10023e7bc		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e7c0		9a9f07eb		CSET NE, R11				
  operators_test.go:56	0x10023e7c4		8a41fd6b		AND R1>>63, R11, R11			
  operators_test.go:56	0x10023e7c8		ca0a016b		EOR R10, R11, R11			
  operators_test.go:56	0x10023e7cc		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023e7d0		3600008b		TBZ $0, R11, 4(PC)			
  operators_test.go:56	0x10023e7d4		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e7d8		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e7dc		1400002f		JMP 47(PC)				
  operators_test.go:56	0x10023e7e0		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023e7e4		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023e7e8		9a9f17ec		CSET EQ, R12				
  operators_test.go:56	0x10023e7ec		aa0c016b		ORR R12, R11, R11			
  operators_test.go:56	0x10023e7f0		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e7f4		9a9f17ec		CSET EQ, R12				
  operators_test.go:56	0x10023e7f8		aa0c016b		ORR R12, R11, R11			
  operators_test.go:56	0x10023e7fc		3600012b		TBZ $0, R11, 9(PC)			
  operators_test.go:56	0x10023e800		eb04007f		CMP R4, R3				
  operators_test.go:56	0x10023e804		9a9f97e3		CSET HI, R3				
  operators_test.go:56	0x10023e808		9a9f17e4		CSET EQ, R4				
  operators_test.go:56	0x10023e80c		ca0a0063		EOR R10, R3, R3				
  operators_test.go:56	0x10023e810		aa04006a		ORR R4, R3, R10				
  operators_test.go:56	0x10023e814		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e818		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e81c		1400001f		JMP 31(PC)				
  operators_test.go:56	0x10023e820		9a9f97eb		CSET HI, R11				
  operators_test.go:56	0x10023e824		cb0700cc		SUB R7, R6, R12				
  operators_test.go:56	0x10023e828		cb0600ed		SUB R6, R7, R13				
  operators_test.go:56	0x10023e82c		9a8d818c		CSEL HI, R12, R13, R12			
  operators_test.go:56	0x10023e830		f1004d9f		CMP $19, R12				
  operators_test.go:56	0x10023e834		540002c8		BHI 22(PC)				
  operators_test.go:56	0x10023e838		eb0700df		CMP R7, R6				
  operators_test.go:56	0x10023e83c		9a848066		CSEL HI, R3, R4, R6			
  operators_test.go:56	0x10023e840		9a838083		CSEL HI, R4, R3, R3			
  operators_test.go:56	0x10023e844		ca0a0164		EOR R10, R11, R4			
  operators_test.go:56	0x10023e848		900004c7		ADRP 622592(PC), R7			
  operators_test.go:56	0x10023e84c		910d30e7		ADD $844, R7, R7			
  operators_test.go:56	0x10023e850		f86c78e7		MOVD (R7)(R12<<3), R7			
  operators_test.go:56	0x10023e854		9bc67ceb		UMULH R6, R7, R11			
  operators_test.go:56	0x10023e858		9b067ce6		MUL R6, R7, R6				
  operators_test.go:56	0x10023e85c		eb06007f		CMP R6, R3				
  operators_test.go:56	0x10023e860		9a9f17e3		CSET EQ, R3				
  operators_test.go:56	0x10023e864		9a9f97e6		CSET HI, R6				
  operators_test.go:56	0x10023e868		f100017f		CMP $0, R11				
  operators_test.go:56	0x10023e86c		9a9f17e7		CSET EQ, R7				
  operators_test.go:56	0x10023e870		8a070063		AND R7, R3, R3				
  operators_test.go:56	0x10023e874		8a0700c6		AND R7, R6, R6				
  operators_test.go:56	0x10023e878		ca0400c4		EOR R4, R6, R4				
  operators_test.go:56	0x10023e87c		aa04006a		ORR R4, R3, R10				
  operators_test.go:56	0x10023e880		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e884		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e888		14000004		JMP 4(PC)				
  operators_test.go:56	0x10023e88c		ca0a016a		EOR R10, R11, R10			
  operators_test.go:56	0x10023e890		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023e894		aa0803e4		MOVD R8, R4				
  operators_test.go:56	0x10023e898		39002fea		MOVB R10, 11(RSP)			
  operators_test.go:56	0x10023e89c		92430426		AND $6917529027641081856, R1, R6	
  operators_test.go:56	0x10023e8a0		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023e8a4		54000160		BEQ 11(PC)				
  operators_test.go:56	0x10023e8a8		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023e8ac		54000120		BEQ 9(PC)				
  operators_test.go:56	0x10023e8b0		d2e63807		MOVD $3584865303386914816, R7		
  operators_test.go:56	0x10023e8b4		ca070028		EOR R7, R1, R8				
  operators_test.go:56	0x10023e8b8		ca070007		EOR R7, R0, R7				
  operators_test.go:56	0x10023e8bc		d375f908		UBFX $53, R8, $10, R8			
  operators_test.go:56	0x10023e8c0		d375f8e7		UBFX $53, R7, $10, R7			
  operators_test.go:56	0x10023e8c4		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e8c8		aa0403ea		MOVD R4, R10				
  operators_test.go:56	0x10023e8cc		1400004e		JMP 78(PC)				
  operators_test.go:56	0x10023e8d0		d2e63807		MOVD $3584865303386914816, R7		
  operators_test.go:56	0x10023e8d4		ca070028		EOR R7, R1, R8				
  operators_test.go:56	0x10023e8d8		ca070007		EOR R7, R0, R7				
  operators_test.go:56	0x10023e8dc		92461109		AND $8935141660703064064, R8, R9	
  operators_test.go:56	0x10023e8e0		924610ea		AND $8935141660703064064, R7, R10	
  operators_test.go:56	0x10023e8e4		d2ef800b		MOVD $8935141660703064064, R11		
  operators_test.go:56	0x10023e8e8		eb0b013f		CMP R11, R9				
  operators_test.go:56	0x10023e8ec		9a9f17e9		CSET EQ, R9				
  operators_test.go:56	0x10023e8f0		eb0b015f		CMP R11, R10				
  operators_test.go:56	0x10023e8f4		9a9f17ea		CSET EQ, R10				
  operators_test.go:56	0x10023e8f8		aa0a0129		ORR R10, R9, R9				
  operators_test.go:56	0x10023e8fc		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023e900		36000069		TBZ $0, R9, 3(PC)			
  operators_test.go:56	0x10023e904		aa1f03ec		MOVD ZR, R12				
  operators_test.go:56	0x10023e908		1400007d		JMP 125(PC)				
  operators_test.go:56	0x10023e90c		92450d09		AND $8646911284551352320, R8, R9	
  operators_test.go:56	0x10023e910		92450cea		AND $8646911284551352320, R7, R10	
  operators_test.go:56	0x10023e914		d2ef000b		MOVD $8646911284551352320, R11		
  operators_test.go:56	0x10023e918		eb0b013f		CMP R11, R9				
  operators_test.go:56	0x10023e91c		9a9f17ec		CSET EQ, R12				
  operators_test.go:56	0x10023e920		eb0b015f		CMP R11, R10				
  operators_test.go:56	0x10023e924		9a9f17ea		CSET EQ, R10				
  operators_test.go:56	0x10023e928		aa0a018d		ORR R10, R12, R13			
  operators_test.go:56	0x10023e92c		eb0b013f		CMP R11, R9				
  operators_test.go:56	0x10023e930		3600026d		TBZ $0, R13, 19(PC)			
  operators_test.go:56	0x10023e934		9a9f07e7		CSET NE, R7				
  operators_test.go:56	0x10023e938		8a0a0188		AND R10, R12, R8			
  operators_test.go:56	0x10023e93c		8a41fd89		AND R1>>63, R12, R9			
  operators_test.go:56	0x10023e940		d37ffc2b		LSR $63, R1, R11			
  operators_test.go:56	0x10023e944		ca40fd6b		EOR R0>>63, R11, R11			
  operators_test.go:56	0x10023e948		d240016b		EOR $1, R11, R11			
  operators_test.go:56	0x10023e94c		8a080168		AND R8, R11, R8				
  operators_test.go:56	0x10023e950		d2400108		EOR $1, R8, R8				
  operators_test.go:56	0x10023e954		8a090109		AND R9, R8, R9				
  operators_test.go:56	0x10023e958		d37ffc0b		LSR $63, R0, R11			
  operators_test.go:56	0x10023e95c		d240016b		EOR $1, R11, R11			
  operators_test.go:56	0x10023e960		8a0a016a		AND R10, R11, R10			
  operators_test.go:56	0x10023e964		8a070147		AND R7, R10, R7				
  operators_test.go:56	0x10023e968		aa070127		ORR R7, R9, R7				
  operators_test.go:56	0x10023e96c		8a070107		AND R7, R8, R7				
  operators_test.go:56	0x10023e970		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023e974		aa0703ec		MOVD R7, R12				
  operators_test.go:56	0x10023e978		14000061		JMP 97(PC)				
  operators_test.go:56	0x10023e97c		d373f109		UBFX $51, R8, $10, R9			
  operators_test.go:56	0x10023e980		d373f0ea		UBFX $51, R7, $10, R10			
  operators_test.go:56	0x10023e984		d375f90b		UBFX $53, R8, $10, R11			
  operators_test.go:56	0x10023e988		d375f8ec		UBFX $53, R7, $10, R12			
  operators_test.go:56	0x10023e98c		9240c90d		AND $2251799813685247, R8, R13		
  operators_test.go:56	0x10023e990		b24b01ad		ORR $9007199254740992, R13, R13		
  operators_test.go:56	0x10023e994		9240c8ee		AND $2251799813685247, R7, R14		
  operators_test.go:56	0x10023e998		b24b01ce		ORR $9007199254740992, R14, R14		
  operators_test.go:56	0x10023e99c		9240d10f		AND $9007199254740991, R8, R15		
  operators_test.go:56	0x10023e9a0		9240d0f0		AND $9007199254740991, R7, R16		
  operators_test.go:56	0x10023e9a4		92430511		AND $6917529027641081856, R8, R17	
  operators_test.go:56	0x10023e9a8		924304f3		AND $6917529027641081856, R7, R19	
  operators_test.go:56	0x10023e9ac		d2ec0014		MOVD $6917529027641081856, R20		
  operators_test.go:56	0x10023e9b0		eb14023f		CMP R20, R17				
  operators_test.go:56	0x10023e9b4		9a8b0128		CSEL EQ, R9, R11, R8			
  operators_test.go:56	0x10023e9b8		eb14027f		CMP R20, R19				
  operators_test.go:56	0x10023e9bc		9a8c0147		CSEL EQ, R10, R12, R7			
  operators_test.go:56	0x10023e9c0		92b207e9		MOVD $-2420047873, R9			
  operators_test.go:56	0x10023e9c4		f2d0de49		MOVK $(34546<<32), R9			
  operators_test.go:56	0x10023e9c8		f2e00469		MOVK $(35<<48), R9			
  operators_test.go:56	0x10023e9cc		eb0901df		CMP R9, R14				
  operators_test.go:56	0x10023e9d0		9a9f91ca		CSEL LS, R14, ZR, R10			
  operators_test.go:56	0x10023e9d4		eb14027f		CMP R20, R19				
  operators_test.go:56	0x10023e9d8		9a90014a		CSEL EQ, R10, R16, R10			
  operators_test.go:56	0x10023e9dc		eb0901bf		CMP R9, R13				
  operators_test.go:56	0x10023e9e0		9a9f91a9		CSEL LS, R13, ZR, R9			
  operators_test.go:56	0x10023e9e4		eb14023f		CMP R20, R17				
  operators_test.go:56	0x10023e9e8		9a8f0129		CSEL EQ, R9, R15, R9			
  operators_test.go:56	0x10023e9ec		aa0903eb		MOVD R9, R11				
  operators_test.go:56	0x10023e9f0		aa0303e9		MOVD R3, R9				
  operators_test.go:56	0x10023e9f4		aa0b03e3		MOVD R11, R3				
  operators_test.go:56	0x10023e9f8		aa0a03ec		MOVD R10, R12				
  operators_test.go:56	0x10023e9fc		aa0403ea		MOVD R4, R10				
  operators_test.go:56	0x10023ea00		aa0c03e4		MOVD R12, R4				
  operators_test.go:56	0x10023ea04		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023ea08		9a9f07eb		CSET NE, R11				
  operators_test.go:56	0x10023ea0c		8a40fd6b		AND R0>>63, R11, R11			
  operators_test.go:56	0x10023ea10		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023ea14		9a9f07ec		CSET NE, R12				
  operators_test.go:56	0x10023ea18		8a41fd8c		AND R1>>63, R12, R12			
  operators_test.go:56	0x10023ea1c		ca0c016b		EOR R12, R11, R11			
  operators_test.go:56	0x10023ea20		360000ab		TBZ $0, R11, 5(PC)			
  operators_test.go:56	0x10023ea24		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023ea28		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023ea2c		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023ea30		14000033		JMP 51(PC)				
  operators_test.go:56	0x10023ea34		9a9f17eb		CSET EQ, R11				
  operators_test.go:56	0x10023ea38		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023ea3c		9a9f17ed		CSET EQ, R13				
  operators_test.go:56	0x10023ea40		aa0d016b		ORR R13, R11, R11			
  operators_test.go:56	0x10023ea44		eb0800ff		CMP R8, R7				
  operators_test.go:56	0x10023ea48		9a9f17ed		CSET EQ, R13				
  operators_test.go:56	0x10023ea4c		aa0b01ab		ORR R11, R13, R11			
  operators_test.go:56	0x10023ea50		3600014b		TBZ $0, R11, 10(PC)			
  operators_test.go:56	0x10023ea54		eb03009f		CMP R3, R4				
  operators_test.go:56	0x10023ea58		9a9f97e3		CSET HI, R3				
  operators_test.go:56	0x10023ea5c		9a9f07e4		CSET NE, R4				
  operators_test.go:56	0x10023ea60		ca0c0063		EOR R12, R3, R3				
  operators_test.go:56	0x10023ea64		8a03008c		AND R3, R4, R12				
  operators_test.go:56	0x10023ea68		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023ea6c		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023ea70		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023ea74		14000022		JMP 34(PC)				
  operators_test.go:56	0x10023ea78		9a9f97eb		CSET HI, R11				
  operators_test.go:56	0x10023ea7c		cb0800ed		SUB R8, R7, R13				
  operators_test.go:56	0x10023ea80		cb07010e		SUB R7, R8, R14				
  operators_test.go:56	0x10023ea84		9a8e81ad		CSEL HI, R13, R14, R13			
  operators_test.go:56	0x10023ea88		f1004dbf		CMP $19, R13				
  operators_test.go:56	0x10023ea8c		54000308		BHI 24(PC)				
  operators_test.go:56	0x10023ea90		eb0800ff		CMP R8, R7				
  operators_test.go:56	0x10023ea94		9a838087		CSEL HI, R4, R3, R7			
  operators_test.go:56	0x10023ea98		9a848063		CSEL HI, R3, R4, R3			
  operators_test.go:56	0x10023ea9c		ca0c0164		EOR R12, R11, R4			
  operators_test.go:56	0x10023eaa0		900004c8		ADRP 622592(PC), R8			
  operators_test.go:56	0x10023eaa4		910d3108		ADD $844, R8, R8			
  operators_test.go:56	0x10023eaa8		f86d7908		MOVD (R8)(R13<<3), R8			
  operators_test.go:56	0x10023eaac		9bc77d0b		UMULH R7, R8, R11			
  operators_test.go:56	0x10023eab0		9b077d07		MUL R7, R8, R7				
  operators_test.go:56	0x10023eab4		eb07007f		CMP R7, R3				
  operators_test.go:56	0x10023eab8		9a9f17e3		CSET EQ, R3				
  operators_test.go:56	0x10023eabc		9a9f97e7		CSET HI, R7				
  operators_test.go:56	0x10023eac0		f100017f		CMP $0, R11				
  operators_test.go:56	0x10023eac4		9a9f17e8		CSET EQ, R8				
  operators_test.go:56	0x10023eac8		8a080063		AND R8, R3, R3				
  operators_test.go:56	0x10023eacc		8a0800e7		AND R8, R7, R7				
  operators_test.go:56	0x10023ead0		ca0400e4		EOR R4, R7, R4				
  operators_test.go:56	0x10023ead4		d2400063		EOR $1, R3, R3				
  operators_test.go:56	0x10023ead8		8a04006c		AND R4, R3, R12				
  operators_test.go:56	0x10023eadc		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023eae0		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023eae4		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023eae8		14000005		JMP 5(PC)				
  operators_test.go:56	0x10023eaec		ca0c016c		EOR R12, R11, R12			
  operators_test.go:56	0x10023eaf0		eb0500df		CMP R5, R6				
  operators_test.go:56	0x10023eaf4		aa0903e3		MOVD R9, R3				
  operators_test.go:56	0x10023eaf8		aa0a03e4		MOVD R10, R4				
  operators_test.go:56	0x10023eafc		390033ec		MOVB R12, 12(RSP)			
  operators_test.go:56	0x10023eb00		54000120		BEQ 9(PC)				
  operators_test.go:56	0x10023eb04		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023eb08		540000e0		BEQ 7(PC)				
  operators_test.go:56	0x10023eb0c		d2e63802		MOVD $3584865303386914816, R2		
  operators_test.go:56	0x10023eb10		ca020025		EOR R2, R1, R5				
  operators_test.go:56	0x10023eb14		ca020002		EOR R2, R0, R2				
  operators_test.go:56	0x10023eb18		d375f8a5		UBFX $53, R5, $10, R5			
  operators_test.go:56	0x10023eb1c		d375f842		UBFX $53, R2, $10, R2			
  operators_test.go:56	0x10023eb20		14000046		JMP 70(PC)				
  operators_test.go:56	0x10023eb24		d2e63802		MOVD $3584865303386914816, R2		
  operators_test.go:56	0x10023eb28		ca020023		EOR R2, R1, R3				
  operators_test.go:56	0x10023eb2c		ca020002		EOR R2, R0, R2				
  operators_test.go:56	0x10023eb30		92461064		AND $8935141660703064064, R3, R4	
  operators_test.go:56	0x10023eb34		92461045		AND $8935141660703064064, R2, R5	
  operators_test.go:56	0x10023eb38		d2ef8006		MOVD $8935141660703064064, R6		
  operators_test.go:56	0x10023eb3c		eb06009f		CMP R6, R4				
  operators_test.go:56	0x10023eb40		9a9f17e4		CSET EQ, R4				
  operators_test.go:56	0x10023eb44		eb0600bf		CMP R6, R5				
  operators_test.go:56	0x10023eb48		9a9f17e5		CSET EQ, R5				
  operators_test.go:56	0x10023eb4c		aa050084		ORR R5, R4, R4				
  operators_test.go:56	0x10023eb50		36000064		TBZ $0, R4, 3(PC)			
  operators_test.go:56	0x10023eb54		aa1f03e1		MOVD ZR, R1				
  operators_test.go:56	0x10023eb58		14000068		JMP 104(PC)				
  operators_test.go:56	0x10023eb5c		92450c64		AND $8646911284551352320, R3, R4	
  operators_test.go:56	0x10023eb60		92450c45		AND $8646911284551352320, R2, R5	
  operators_test.go:56	0x10023eb64		d2ef0006		MOVD $8646911284551352320, R6		
  operators_test.go:56	0x10023eb68		eb06009f		CMP R6, R4				
  operators_test.go:56	0x10023eb6c		9a9f17e7		CSET EQ, R7				
  operators_test.go:56	0x10023eb70		eb0600bf		CMP R6, R5				
  operators_test.go:56	0x10023eb74		9a9f17e5		CSET EQ, R5				
  operators_test.go:56	0x10023eb78		aa0500e8		ORR R5, R7, R8				
  operators_test.go:56	0x10023eb7c		eb06009f		CMP R6, R4				
  operators_test.go:56	0x10023eb80		36000248		TBZ $0, R8, 18(PC)			
  operators_test.go:56	0x10023eb84		9a9f07e2		CSET NE, R2				
  operators_test.go:56	0x10023eb88		8a0500e3		AND R5, R7, R3				
  operators_test.go:56	0x10023eb8c		8a41fce4		AND R1>>63, R7, R4			
  operators_test.go:56	0x10023eb90		d37ffc21		LSR $63, R1, R1				
  operators_test.go:56	0x10023eb94		ca40fc21		EOR R0>>63, R1, R1			
  operators_test.go:56	0x10023eb98		d2400021		EOR $1, R1, R1				
  operators_test.go:56	0x10023eb9c		8a030021		AND R3, R1, R1				
  operators_test.go:56	0x10023eba0		d2400023		EOR $1, R1, R3				
  operators_test.go:56	0x10023eba4		8a040063		AND R4, R3, R3				
  operators_test.go:56	0x10023eba8		d37ffc00		LSR $63, R0, R0				
  operators_test.go:56	0x10023ebac		d2400000		EOR $1, R0, R0				
  operators_test.go:56	0x10023ebb0		8a050000		AND R5, R0, R0				
  operators_test.go:56	0x10023ebb4		8a020000		AND R2, R0, R0				
  operators_test.go:56	0x10023ebb8		aa000060		ORR R0, R3, R0				
  operators_test.go:56	0x10023ebbc		aa000020		ORR R0, R1, R0				
  operators_test.go:56	0x10023ebc0		aa0003e1		MOVD R0, R1				
  operators_test.go:56	0x10023ebc4		1400004d		JMP 77(PC)				
  operators_test.go:56	0x10023ebc8		d373f066		UBFX $51, R3, $10, R6			
  operators_test.go:56	0x10023ebcc		d373f047		UBFX $51, R2, $10, R7			
  operators_test.go:56	0x10023ebd0		d375f868		UBFX $53, R3, $10, R8			
  operators_test.go:56	0x10023ebd4		d375f849		UBFX $53, R2, $10, R9			
  operators_test.go:56	0x10023ebd8		9240c86a		AND $2251799813685247, R3, R10		
  operators_test.go:56	0x10023ebdc		b24b014a		ORR $9007199254740992, R10, R10		
  operators_test.go:56	0x10023ebe0		9240c84b		AND $2251799813685247, R2, R11		
  operators_test.go:56	0x10023ebe4		b24b016b		ORR $9007199254740992, R11, R11		
  operators_test.go:56	0x10023ebe8		9240d06c		AND $9007199254740991, R3, R12		
  operators_test.go:56	0x10023ebec		9240d04d		AND $9007199254740991, R2, R13		
  operators_test.go:56	0x10023ebf0		9243046e		AND $6917529027641081856, R3, R14	
  operators_test.go:56	0x10023ebf4		9243044f		AND $6917529027641081856, R2, R15	
  operators_test.go:56	0x10023ebf8		d2ec0010		MOVD $6917529027641081856, R16		
  operators_test.go:56	0x10023ebfc		eb1001df		CMP R16, R14				
  operators_test.go:56	0x10023ec00		9a8800c5		CSEL EQ, R6, R8, R5			
  operators_test.go:56	0x10023ec04		eb1001ff		CMP R16, R15				
  operators_test.go:56	0x10023ec08		9a8900e2		CSEL EQ, R7, R9, R2			
  operators_test.go:56	0x10023ec0c		92b207e6		MOVD $-2420047873, R6			
  operators_test.go:56	0x10023ec10		f2d0de46		MOVK $(34546<<32), R6			
  operators_test.go:56	0x10023ec14		f2e00466		MOVK $(35<<48), R6			
  operators_test.go:56	0x10023ec18		eb06017f		CMP R6, R11				
  operators_test.go:56	0x10023ec1c		9a9f9167		CSEL LS, R11, ZR, R7			
  operators_test.go:56	0x10023ec20		eb1001ff		CMP R16, R15				
  operators_test.go:56	0x10023ec24		9a8d00e4		CSEL EQ, R7, R13, R4			
  operators_test.go:56	0x10023ec28		eb06015f		CMP R6, R10				
  operators_test.go:56	0x10023ec2c		9a9f9146		CSEL LS, R10, ZR, R6			
  operators_test.go:56	0x10023ec30		eb1001df		CMP R16, R14				
  operators_test.go:56	0x10023ec34		9a8c00c3		CSEL EQ, R6, R12, R3			
  operators_test.go:56	0x10023ec38		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023ec3c		9a9f07e6		CSET NE, R6				
  operators_test.go:56	0x10023ec40		8a40fcc0		AND R0>>63, R6, R0			
  operators_test.go:56	0x10023ec44		f100007f		CMP $0, R3				
  operators_test.go:56	0x10023ec48		9a9f07e6		CSET NE, R6				
  operators_test.go:56	0x10023ec4c		8a41fcc1		AND R1>>63, R6, R1			
  operators_test.go:56	0x10023ec50		ca010000		EOR R1, R0, R0				
  operators_test.go:56	0x10023ec54		37000520		TBNZ $0, R0, 41(PC)			
  operators_test.go:56	0x10023ec58		9a9f17e0		CSET EQ, R0				
  operators_test.go:56	0x10023ec5c		f100009f		CMP $0, R4				
  operators_test.go:56	0x10023ec60		9a9f17e6		CSET EQ, R6				
  operators_test.go:56	0x10023ec64		aa060000		ORR R6, R0, R0				
  operators_test.go:56	0x10023ec68		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023ec6c		9a9f17e6		CSET EQ, R6				
  operators_test.go:56	0x10023ec70		aa0000c0		ORR R0, R6, R0				
  operators_test.go:56	0x10023ec74		360000e0		TBZ $0, R0, 7(PC)			
  operators_test.go:56	0x10023ec78		eb03009f		CMP R3, R4				
  operators_test.go:56	0x10023ec7c		9a9f97e0		CSET HI, R0				
  operators_test.go:56	0x10023ec80		9a9f17e2		CSET EQ, R2				
  operators_test.go:56	0x10023ec84		ca010000		EOR R1, R0, R0				
  operators_test.go:56	0x10023ec88		aa000041		ORR R0, R2, R1				
  operators_test.go:56	0x10023ec8c		1400001b		JMP 27(PC)				
  operators_test.go:56	0x10023ec90		9a9f97e0		CSET HI, R0				
  operators_test.go:56	0x10023ec94		cb050046		SUB R5, R2, R6				
  operators_test.go:56	0x10023ec98		cb0200a7		SUB R2, R5, R7				
  operators_test.go:56	0x10023ec9c		9a8780c6		CSEL HI, R6, R7, R6			
  operators_test.go:56	0x10023eca0		f1004cdf		CMP $19, R6				
  operators_test.go:56	0x10023eca4		54000288		BHI 20(PC)				
  operators_test.go:56	0x10023eca8		eb05005f		CMP R5, R2				
  operators_test.go:56	0x10023ecac		9a838082		CSEL HI, R4, R3, R2			
  operators_test.go:56	0x10023ecb0		9a848063		CSEL HI, R3, R4, R3			
  operators_test.go:56	0x10023ecb4		ca010000		EOR R1, R0, R0				
  operators_test.go:56	0x10023ecb8		900004c4		ADRP 622592(PC), R4			
  operators_test.go:56	0x10023ecbc		910d3084		ADD $844, R4, R4			
  operators_test.go:56	0x10023ecc0		f8667884		MOVD (R4)(R6<<3), R4			
  operators_test.go:56	0x10023ecc4		9bc27c85		UMULH R2, R4, R5			
  operators_test.go:56	0x10023ecc8		9b027c82		MUL R2, R4, R2				
  operators_test.go:56	0x10023eccc		eb02007f		CMP R2, R3				
  operators_test.go:56	0x10023ecd0		9a9f17e2		CSET EQ, R2				
  operators_test.go:56	0x10023ecd4		9a9f97e3		CSET HI, R3				
  operators_test.go:56	0x10023ecd8		f10000bf		CMP $0, R5				
  operators_test.go:56	0x10023ecdc		9a9f17e4		CSET EQ, R4				
  operators_test.go:56	0x10023ece0		8a040042		AND R4, R2, R2				
  operators_test.go:56	0x10023ece4		8a040063		AND R4, R3, R3				
  operators_test.go:56	0x10023ece8		ca000060		EOR R0, R3, R0				
  operators_test.go:56	0x10023ecec		aa000041		ORR R0, R2, R1				
  operators_test.go:56	0x10023ecf0		14000002		JMP 2(PC)				
  operators_test.go:56	0x10023ecf4		ca010001		EOR R1, R0, R1				
  operators_test.go:56	0x10023ecf8		390037e1		MOVB R1, 13(RSP)			
  operators_test.go:56	0x10023ecfc		d65f03c0		RET					

TEXT internal/bid_test.opCmp128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/operators_test.go
  operators_test.go:60	0x10023ed00		f9400b90		MOVD 16(R28), R16			
  operators_test.go:60	0x10023ed04		eb3063ff		CMP R16, RSP				
  operators_test.go:60	0x10023ed08		54005a09		BLS 720(PC)				
  operators_test.go:60	0x10023ed0c		f81b0ffe		MOVD.W R30, -80(RSP)			
  operators_test.go:60	0x10023ed10		f81f83fd		MOVD R29, -8(RSP)			
  operators_test.go:60	0x10023ed14		d10023fd		SUB $8, RSP, R29			
  operators_test.go:61	0x10023ed18		a9070fe2		STP (R2, R3), 112(RSP)			
  operators_test.go:61	0x10023ed1c		a90607e0		STP (R0, R1), 96(RSP)			
  operators_test.go:60	0x10023ed20		b9005bff		MOVW ZR, 88(RSP)			
  operators_test.go:60	0x10023ed24		7900bbff		MOVH ZR, 92(RSP)			
  operators_test.go:61	0x10023ed28		aa010064		ORR R1, R3, R4				
  operators_test.go:61	0x10023ed2c		f90023e4		MOVD R4, 64(RSP)			
  operators_test.go:61	0x10023ed30		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ed34		54000b61		BNE 91(PC)				
  operators_test.go:61	0x10023ed38		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023ed3c		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023ed40		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023ed44		54000700		BEQ 56(PC)				
  operators_test.go:61	0x10023ed48		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023ed4c		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023ed50		540006a0		BEQ 53(PC)				
  operators_test.go:61	0x10023ed54		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023ed58		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023ed5c		8a41fca5		AND R1>>63, R5, R5			
  operators_test.go:61	0x10023ed60		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023ed64		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023ed68		8a43fcc6		AND R3>>63, R6, R6			
  operators_test.go:61	0x10023ed6c		ca0600a5		EOR R6, R5, R5				
  operators_test.go:61	0x10023ed70		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023ed74		36000085		TBZ $0, R5, 4(PC)			
  operators_test.go:61	0x10023ed78		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ed7c		aa1f03e5		MOVD ZR, R5				
  operators_test.go:61	0x10023ed80		14000056		JMP 86(PC)				
  operators_test.go:61	0x10023ed84		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023ed88		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023ed8c		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023ed90		aa0600a5		ORR R6, R5, R5				
  operators_test.go:61	0x10023ed94		d2e60806		MOVD $3476778912330022912, R6		
  operators_test.go:61	0x10023ed98		ca060027		EOR R6, R1, R7				
  operators_test.go:61	0x10023ed9c		ca060066		EOR R6, R3, R6				
  operators_test.go:61	0x10023eda0		d371f8e7		UBFX $49, R7, $14, R7			
  operators_test.go:61	0x10023eda4		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023eda8		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023edac		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023edb0		aa0800a5		ORR R8, R5, R5				
  operators_test.go:61	0x10023edb4		360000a5		TBZ $0, R5, 5(PC)			
  operators_test.go:61	0x10023edb8		eb02001f		CMP R2, R0				
  operators_test.go:61	0x10023edbc		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023edc0		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023edc4		14000045		JMP 69(PC)				
  operators_test.go:61	0x10023edc8		cb0700c5		SUB R7, R6, R5				
  operators_test.go:61	0x10023edcc		cb0600e8		SUB R6, R7, R8				
  operators_test.go:61	0x10023edd0		9a8880a5		CSEL HI, R5, R8, R5			
  operators_test.go:61	0x10023edd4		f1004cbf		CMP $19, R5				
  operators_test.go:61	0x10023edd8		54000208		BHI 16(PC)				
  operators_test.go:61	0x10023eddc		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023ede0		9a808046		CSEL HI, R2, R0, R6			
  operators_test.go:61	0x10023ede4		9a828007		CSEL HI, R0, R2, R7			
  operators_test.go:61	0x10023ede8		900004c8		ADRP 622592(PC), R8			
  operators_test.go:61	0x10023edec		910d3108		ADD $844, R8, R8			
  operators_test.go:61	0x10023edf0		f8657905		MOVD (R8)(R5<<3), R5			
  operators_test.go:61	0x10023edf4		9bc67ca8		UMULH R6, R5, R8			
  operators_test.go:61	0x10023edf8		9b067ca5		MUL R6, R5, R5				
  operators_test.go:61	0x10023edfc		eb0500ff		CMP R5, R7				
  operators_test.go:61	0x10023ee00		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023ee04		f100011f		CMP $0, R8				
  operators_test.go:61	0x10023ee08		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023ee0c		8a0500c5		AND R5, R6, R5				
  operators_test.go:61	0x10023ee10		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ee14		14000031		JMP 49(PC)				
  operators_test.go:61	0x10023ee18		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ee1c		aa1f03e5		MOVD ZR, R5				
  operators_test.go:61	0x10023ee20		1400002e		JMP 46(PC)				
  operators_test.go:61	0x10023ee24		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023ee28		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023ee2c		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023ee30		924610c7		AND $8935141660703064064, R6, R7	
  operators_test.go:61	0x10023ee34		924610a8		AND $8935141660703064064, R5, R8	
  operators_test.go:61	0x10023ee38		d2ef8009		MOVD $8935141660703064064, R9		
  operators_test.go:61	0x10023ee3c		eb09011f		CMP R9, R8				
  operators_test.go:61	0x10023ee40		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023ee44		eb0900ff		CMP R9, R7				
  operators_test.go:61	0x10023ee48		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023ee4c		aa0800e7		ORR R8, R7, R7				
  operators_test.go:61	0x10023ee50		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ee54		36000067		TBZ $0, R7, 3(PC)			
  operators_test.go:61	0x10023ee58		aa1f03e5		MOVD ZR, R5				
  operators_test.go:61	0x10023ee5c		1400001f		JMP 31(PC)				
  operators_test.go:61	0x10023ee60		92450cc6		AND $8646911284551352320, R6, R6	
  operators_test.go:61	0x10023ee64		92450ca5		AND $8646911284551352320, R5, R5	
  operators_test.go:61	0x10023ee68		d2ef0007		MOVD $8646911284551352320, R7		
  operators_test.go:61	0x10023ee6c		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023ee70		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023ee74		eb0700bf		CMP R7, R5				
  operators_test.go:61	0x10023ee78		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023ee7c		aa0500c7		ORR R5, R6, R7				
  operators_test.go:61	0x10023ee80		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ee84		360000e7		TBZ $0, R7, 7(PC)			
  operators_test.go:61	0x10023ee88		8a0500c5		AND R5, R6, R5				
  operators_test.go:61	0x10023ee8c		d37ffc66		LSR $63, R3, R6				
  operators_test.go:61	0x10023ee90		ca41fcc6		EOR R1>>63, R6, R6			
  operators_test.go:61	0x10023ee94		d24000c6		EOR $1, R6, R6				
  operators_test.go:61	0x10023ee98		8a0500c5		AND R5, R6, R5				
  operators_test.go:61	0x10023ee9c		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023eea0		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023eea4		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023eea8		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023eeac		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023eeb0		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023eeb4		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023eeb8		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023eebc		97f78bb9		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023eec0		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023eec4		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023eec8		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023eecc		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023eed0		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023eed4		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023eed8		390163e5		MOVB R5, 88(RSP)			
  operators_test.go:61	0x10023eedc		54000ba1		BNE 93(PC)				
  operators_test.go:61	0x10023eee0		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023eee4		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023eee8		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023eeec		54000720		BEQ 57(PC)				
  operators_test.go:61	0x10023eef0		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023eef4		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023eef8		540006c0		BEQ 54(PC)				
  operators_test.go:61	0x10023eefc		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023ef00		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023ef04		8a41fca5		AND R1>>63, R5, R5			
  operators_test.go:61	0x10023ef08		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023ef0c		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023ef10		8a43fcc6		AND R3>>63, R6, R6			
  operators_test.go:61	0x10023ef14		ca0600a5		EOR R6, R5, R5				
  operators_test.go:61	0x10023ef18		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023ef1c		36000085		TBZ $0, R5, 4(PC)			
  operators_test.go:61	0x10023ef20		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ef24		b24003e5		ORR $1, ZR, R5				
  operators_test.go:61	0x10023ef28		14000057		JMP 87(PC)				
  operators_test.go:61	0x10023ef2c		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023ef30		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023ef34		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023ef38		aa0600a5		ORR R6, R5, R5				
  operators_test.go:61	0x10023ef3c		d2e60806		MOVD $3476778912330022912, R6		
  operators_test.go:61	0x10023ef40		ca060027		EOR R6, R1, R7				
  operators_test.go:61	0x10023ef44		ca060066		EOR R6, R3, R6				
  operators_test.go:61	0x10023ef48		d371f8e7		UBFX $49, R7, $14, R7			
  operators_test.go:61	0x10023ef4c		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023ef50		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023ef54		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023ef58		aa0800a5		ORR R8, R5, R5				
  operators_test.go:61	0x10023ef5c		360000a5		TBZ $0, R5, 5(PC)			
  operators_test.go:61	0x10023ef60		eb02001f		CMP R2, R0				
  operators_test.go:61	0x10023ef64		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023ef68		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ef6c		14000046		JMP 70(PC)				
  operators_test.go:61	0x10023ef70		cb0700c5		SUB R7, R6, R5				
  operators_test.go:61	0x10023ef74		cb0600e8		SUB R6, R7, R8				
  operators_test.go:61	0x10023ef78		9a8880a5		CSEL HI, R5, R8, R5			
  operators_test.go:61	0x10023ef7c		f1004cbf		CMP $19, R5				
  operators_test.go:61	0x10023ef80		54000228		BHI 17(PC)				
  operators_test.go:61	0x10023ef84		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023ef88		9a808046		CSEL HI, R2, R0, R6			
  operators_test.go:61	0x10023ef8c		9a828007		CSEL HI, R0, R2, R7			
  operators_test.go:61	0x10023ef90		900004c8		ADRP 622592(PC), R8			
  operators_test.go:61	0x10023ef94		910d3108		ADD $844, R8, R8			
  operators_test.go:61	0x10023ef98		f8657908		MOVD (R8)(R5<<3), R8			
  operators_test.go:61	0x10023ef9c		9bc67d09		UMULH R6, R8, R9			
  operators_test.go:61	0x10023efa0		9b067d06		MUL R6, R8, R6				
  operators_test.go:61	0x10023efa4		eb0600ff		CMP R6, R7				
  operators_test.go:61	0x10023efa8		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023efac		f100013f		CMP $0, R9				
  operators_test.go:61	0x10023efb0		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023efb4		8a0600e6		AND R6, R7, R6				
  operators_test.go:61	0x10023efb8		d24000c5		EOR $1, R6, R5				
  operators_test.go:61	0x10023efbc		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023efc0		14000031		JMP 49(PC)				
  operators_test.go:61	0x10023efc4		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023efc8		b24003e5		ORR $1, ZR, R5				
  operators_test.go:61	0x10023efcc		1400002e		JMP 46(PC)				
  operators_test.go:61	0x10023efd0		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023efd4		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023efd8		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023efdc		924610c7		AND $8935141660703064064, R6, R7	
  operators_test.go:61	0x10023efe0		924610a8		AND $8935141660703064064, R5, R8	
  operators_test.go:61	0x10023efe4		d2ef8009		MOVD $8935141660703064064, R9		
  operators_test.go:61	0x10023efe8		eb09011f		CMP R9, R8				
  operators_test.go:61	0x10023efec		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023eff0		eb0900ff		CMP R9, R7				
  operators_test.go:61	0x10023eff4		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023eff8		aa0800e7		ORR R8, R7, R7				
  operators_test.go:61	0x10023effc		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f000		36000067		TBZ $0, R7, 3(PC)			
  operators_test.go:61	0x10023f004		b24003e5		ORR $1, ZR, R5				
  operators_test.go:61	0x10023f008		1400001f		JMP 31(PC)				
  operators_test.go:61	0x10023f00c		92450cc6		AND $8646911284551352320, R6, R6	
  operators_test.go:61	0x10023f010		92450ca5		AND $8646911284551352320, R5, R5	
  operators_test.go:61	0x10023f014		d2ef0007		MOVD $8646911284551352320, R7		
  operators_test.go:61	0x10023f018		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f01c		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f020		eb0700bf		CMP R7, R5				
  operators_test.go:61	0x10023f024		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023f028		aa0500c7		ORR R5, R6, R7				
  operators_test.go:61	0x10023f02c		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f030		36000107		TBZ $0, R7, 8(PC)			
  operators_test.go:61	0x10023f034		8a0500c6		AND R5, R6, R6				
  operators_test.go:61	0x10023f038		d37ffc67		LSR $63, R3, R7				
  operators_test.go:61	0x10023f03c		ca41fce7		EOR R1>>63, R7, R7			
  operators_test.go:61	0x10023f040		d24000e7		EOR $1, R7, R7				
  operators_test.go:61	0x10023f044		8a0600e6		AND R6, R7, R6				
  operators_test.go:61	0x10023f048		d24000c5		EOR $1, R6, R5				
  operators_test.go:61	0x10023f04c		1400000e		JMP 14(PC)				
  operators_test.go:61	0x10023f050		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023f054		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023f058		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023f05c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023f060		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023f064		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023f068		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023f06c		97f78b4d		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023f070		d2400005		EOR $1, R0, R5				
  operators_test.go:61	0x10023f074		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023f078		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f07c		a94607e0		LDP 96(RSP), (R0, R1)			
  operators_test.go:61	0x10023f080		a9470fe2		LDP 112(RSP), (R2, R3)			
  operators_test.go:61	0x10023f084		390167e5		MOVB R5, 89(RSP)			
  operators_test.go:61	0x10023f088		54000dc1		BNE 110(PC)				
  operators_test.go:61	0x10023f08c		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023f090		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023f094		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f098		54000820		BEQ 65(PC)				
  operators_test.go:61	0x10023f09c		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023f0a0		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f0a4		540007c0		BEQ 62(PC)				
  operators_test.go:61	0x10023f0a8		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f0ac		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023f0b0		8a41fca5		AND R1>>63, R5, R5			
  operators_test.go:61	0x10023f0b4		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f0b8		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023f0bc		8a43fcc6		AND R3>>63, R6, R6			
  operators_test.go:61	0x10023f0c0		ca0600a6		EOR R6, R5, R6				
  operators_test.go:61	0x10023f0c4		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f0c8		36000066		TBZ $0, R6, 3(PC)			
  operators_test.go:61	0x10023f0cc		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f0d0		1400006a		JMP 106(PC)				
  operators_test.go:61	0x10023f0d4		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f0d8		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f0dc		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f0e0		aa0700c6		ORR R7, R6, R6				
  operators_test.go:61	0x10023f0e4		d2e60807		MOVD $3476778912330022912, R7		
  operators_test.go:61	0x10023f0e8		ca070028		EOR R7, R1, R8				
  operators_test.go:61	0x10023f0ec		ca070067		EOR R7, R3, R7				
  operators_test.go:61	0x10023f0f0		d371f908		UBFX $49, R8, $14, R8			
  operators_test.go:61	0x10023f0f4		d371f8e7		UBFX $49, R7, $14, R7			
  operators_test.go:61	0x10023f0f8		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f0fc		9a9f17e9		CSET EQ, R9				
  operators_test.go:61	0x10023f100		aa0900c6		ORR R9, R6, R6				
  operators_test.go:61	0x10023f104		36000106		TBZ $0, R6, 8(PC)			
  operators_test.go:61	0x10023f108		eb02001f		CMP R2, R0				
  operators_test.go:61	0x10023f10c		9a9f27e6		CSET LO, R6				
  operators_test.go:61	0x10023f110		9a9f07e7		CSET NE, R7				
  operators_test.go:61	0x10023f114		ca0500c6		EOR R5, R6, R6				
  operators_test.go:61	0x10023f118		8a0700c5		AND R7, R6, R5				
  operators_test.go:61	0x10023f11c		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f120		14000056		JMP 86(PC)				
  operators_test.go:61	0x10023f124		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023f128		cb0800e9		SUB R8, R7, R9				
  operators_test.go:61	0x10023f12c		cb07010a		SUB R7, R8, R10				
  operators_test.go:61	0x10023f130		9a8a8129		CSEL HI, R9, R10, R9			
  operators_test.go:61	0x10023f134		f1004d3f		CMP $19, R9				
  operators_test.go:61	0x10023f138		540002c8		BHI 22(PC)				
  operators_test.go:61	0x10023f13c		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f140		9a808047		CSEL HI, R2, R0, R7			
  operators_test.go:61	0x10023f144		9a828008		CSEL HI, R0, R2, R8			
  operators_test.go:61	0x10023f148		ca0600a6		EOR R6, R5, R6				
  operators_test.go:61	0x10023f14c		f00004aa		ADRP 618496(PC), R10			
  operators_test.go:61	0x10023f150		910d314a		ADD $844, R10, R10			
  operators_test.go:61	0x10023f154		f8697949		MOVD (R10)(R9<<3), R9			
  operators_test.go:61	0x10023f158		9bc77d2a		UMULH R7, R9, R10			
  operators_test.go:61	0x10023f15c		9b077d27		MUL R7, R9, R7				
  operators_test.go:61	0x10023f160		eb07011f		CMP R7, R8				
  operators_test.go:61	0x10023f164		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f168		9a9f97e8		CSET HI, R8				
  operators_test.go:61	0x10023f16c		f100015f		CMP $0, R10				
  operators_test.go:61	0x10023f170		9a9f17e9		CSET EQ, R9				
  operators_test.go:61	0x10023f174		8a070127		AND R7, R9, R7				
  operators_test.go:61	0x10023f178		8a090108		AND R9, R8, R8				
  operators_test.go:61	0x10023f17c		ca060106		EOR R6, R8, R6				
  operators_test.go:61	0x10023f180		d24000e7		EOR $1, R7, R7				
  operators_test.go:61	0x10023f184		8a0700c5		AND R7, R6, R5				
  operators_test.go:61	0x10023f188		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f18c		1400003b		JMP 59(PC)				
  operators_test.go:61	0x10023f190		ca0600a5		EOR R6, R5, R5				
  operators_test.go:61	0x10023f194		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f198		14000038		JMP 56(PC)				
  operators_test.go:61	0x10023f19c		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023f1a0		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023f1a4		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023f1a8		924610c7		AND $8935141660703064064, R6, R7	
  operators_test.go:61	0x10023f1ac		924610a8		AND $8935141660703064064, R5, R8	
  operators_test.go:61	0x10023f1b0		d2ef8009		MOVD $8935141660703064064, R9		
  operators_test.go:61	0x10023f1b4		eb0900ff		CMP R9, R7				
  operators_test.go:61	0x10023f1b8		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f1bc		eb09011f		CMP R9, R8				
  operators_test.go:61	0x10023f1c0		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023f1c4		aa0800e7		ORR R8, R7, R7				
  operators_test.go:61	0x10023f1c8		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f1cc		36000067		TBZ $0, R7, 3(PC)			
  operators_test.go:61	0x10023f1d0		aa1f03e5		MOVD ZR, R5				
  operators_test.go:61	0x10023f1d4		14000029		JMP 41(PC)				
  operators_test.go:61	0x10023f1d8		92450cc6		AND $8646911284551352320, R6, R6	
  operators_test.go:61	0x10023f1dc		92450ca5		AND $8646911284551352320, R5, R5	
  operators_test.go:61	0x10023f1e0		d2ef0007		MOVD $8646911284551352320, R7		
  operators_test.go:61	0x10023f1e4		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f1e8		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023f1ec		eb0700bf		CMP R7, R5				
  operators_test.go:61	0x10023f1f0		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023f1f4		aa050109		ORR R5, R8, R9				
  operators_test.go:61	0x10023f1f8		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f1fc		36000229		TBZ $0, R9, 17(PC)			
  operators_test.go:61	0x10023f200		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023f204		8a050107		AND R5, R8, R7				
  operators_test.go:61	0x10023f208		8a41fd08		AND R1>>63, R8, R8			
  operators_test.go:61	0x10023f20c		d37ffc69		LSR $63, R3, R9				
  operators_test.go:61	0x10023f210		ca41fd2a		EOR R1>>63, R9, R10			
  operators_test.go:61	0x10023f214		d240014a		EOR $1, R10, R10			
  operators_test.go:61	0x10023f218		8a070147		AND R7, R10, R7				
  operators_test.go:61	0x10023f21c		d24000e7		EOR $1, R7, R7				
  operators_test.go:61	0x10023f220		8a0800e8		AND R8, R7, R8				
  operators_test.go:61	0x10023f224		d2400129		EOR $1, R9, R9				
  operators_test.go:61	0x10023f228		8a050129		AND R5, R9, R9				
  operators_test.go:61	0x10023f22c		8a060126		AND R6, R9, R6				
  operators_test.go:61	0x10023f230		aa060106		ORR R6, R8, R6				
  operators_test.go:61	0x10023f234		8a0600e5		AND R6, R7, R5				
  operators_test.go:61	0x10023f238		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f23c		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023f240		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023f244		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023f248		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023f24c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023f250		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023f254		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023f258		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023f25c		97f78ae9		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023f260		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023f264		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f268		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023f26c		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023f270		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023f274		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023f278		39016be5		MOVB R5, 90(RSP)			
  operators_test.go:61	0x10023f27c		54000da1		BNE 109(PC)				
  operators_test.go:61	0x10023f280		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023f284		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023f288		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f28c		54000800		BEQ 64(PC)				
  operators_test.go:61	0x10023f290		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023f294		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f298		540007a0		BEQ 61(PC)				
  operators_test.go:61	0x10023f29c		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f2a0		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023f2a4		8a41fca5		AND R1>>63, R5, R5			
  operators_test.go:61	0x10023f2a8		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f2ac		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023f2b0		8a43fcc6		AND R3>>63, R6, R6			
  operators_test.go:61	0x10023f2b4		ca0600a6		EOR R6, R5, R6				
  operators_test.go:61	0x10023f2b8		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f2bc		36000066		TBZ $0, R6, 3(PC)			
  operators_test.go:61	0x10023f2c0		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f2c4		14000069		JMP 105(PC)				
  operators_test.go:61	0x10023f2c8		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f2cc		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f2d0		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f2d4		aa0700c6		ORR R7, R6, R6				
  operators_test.go:61	0x10023f2d8		d2e60807		MOVD $3476778912330022912, R7		
  operators_test.go:61	0x10023f2dc		ca070028		EOR R7, R1, R8				
  operators_test.go:61	0x10023f2e0		ca070067		EOR R7, R3, R7				
  operators_test.go:61	0x10023f2e4		d371f908		UBFX $49, R8, $14, R8			
  operators_test.go:61	0x10023f2e8		d371f8e7		UBFX $49, R7, $14, R7			
  operators_test.go:61	0x10023f2ec		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f2f0		9a9f17e9		CSET EQ, R9				
  operators_test.go:61	0x10023f2f4		aa0900c6		ORR R9, R6, R6				
  operators_test.go:61	0x10023f2f8		36000106		TBZ $0, R6, 8(PC)			
  operators_test.go:61	0x10023f2fc		eb02001f		CMP R2, R0				
  operators_test.go:61	0x10023f300		9a9f27e6		CSET LO, R6				
  operators_test.go:61	0x10023f304		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f308		ca0500c6		EOR R5, R6, R6				
  operators_test.go:61	0x10023f30c		aa0700c5		ORR R7, R6, R5				
  operators_test.go:61	0x10023f310		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f314		14000055		JMP 85(PC)				
  operators_test.go:61	0x10023f318		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023f31c		cb0800e9		SUB R8, R7, R9				
  operators_test.go:61	0x10023f320		cb07010a		SUB R7, R8, R10				
  operators_test.go:61	0x10023f324		9a8a8129		CSEL HI, R9, R10, R9			
  operators_test.go:61	0x10023f328		f1004d3f		CMP $19, R9				
  operators_test.go:61	0x10023f32c		540002a8		BHI 21(PC)				
  operators_test.go:61	0x10023f330		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f334		9a808047		CSEL HI, R2, R0, R7			
  operators_test.go:61	0x10023f338		9a828008		CSEL HI, R0, R2, R8			
  operators_test.go:61	0x10023f33c		ca0600a6		EOR R6, R5, R6				
  operators_test.go:61	0x10023f340		f00004aa		ADRP 618496(PC), R10			
  operators_test.go:61	0x10023f344		910d314a		ADD $844, R10, R10			
  operators_test.go:61	0x10023f348		f8697949		MOVD (R10)(R9<<3), R9			
  operators_test.go:61	0x10023f34c		9bc77d2a		UMULH R7, R9, R10			
  operators_test.go:61	0x10023f350		9b077d27		MUL R7, R9, R7				
  operators_test.go:61	0x10023f354		eb07011f		CMP R7, R8				
  operators_test.go:61	0x10023f358		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f35c		9a9f97e8		CSET HI, R8				
  operators_test.go:61	0x10023f360		f100015f		CMP $0, R10				
  operators_test.go:61	0x10023f364		9a9f17e9		CSET EQ, R9				
  operators_test.go:61	0x10023f368		8a070127		AND R7, R9, R7				
  operators_test.go:61	0x10023f36c		8a090108		AND R9, R8, R8				
  operators_test.go:61	0x10023f370		ca060106		EOR R6, R8, R6				
  operators_test.go:61	0x10023f374		aa0700c5		ORR R7, R6, R5				
  operators_test.go:61	0x10023f378		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f37c		1400003b		JMP 59(PC)				
  operators_test.go:61	0x10023f380		ca0600a5		EOR R6, R5, R5				
  operators_test.go:61	0x10023f384		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f388		14000038		JMP 56(PC)				
  operators_test.go:61	0x10023f38c		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023f390		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023f394		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023f398		924610c7		AND $8935141660703064064, R6, R7	
  operators_test.go:61	0x10023f39c		924610a8		AND $8935141660703064064, R5, R8	
  operators_test.go:61	0x10023f3a0		d2ef8009		MOVD $8935141660703064064, R9		
  operators_test.go:61	0x10023f3a4		eb0900ff		CMP R9, R7				
  operators_test.go:61	0x10023f3a8		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f3ac		eb09011f		CMP R9, R8				
  operators_test.go:61	0x10023f3b0		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023f3b4		aa0800e7		ORR R8, R7, R7				
  operators_test.go:61	0x10023f3b8		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f3bc		36000067		TBZ $0, R7, 3(PC)			
  operators_test.go:61	0x10023f3c0		aa1f03e5		MOVD ZR, R5				
  operators_test.go:61	0x10023f3c4		14000029		JMP 41(PC)				
  operators_test.go:61	0x10023f3c8		92450cc6		AND $8646911284551352320, R6, R6	
  operators_test.go:61	0x10023f3cc		92450ca5		AND $8646911284551352320, R5, R5	
  operators_test.go:61	0x10023f3d0		d2ef0007		MOVD $8646911284551352320, R7		
  operators_test.go:61	0x10023f3d4		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f3d8		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023f3dc		eb0700bf		CMP R7, R5				
  operators_test.go:61	0x10023f3e0		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023f3e4		aa050109		ORR R5, R8, R9				
  operators_test.go:61	0x10023f3e8		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f3ec		36000229		TBZ $0, R9, 17(PC)			
  operators_test.go:61	0x10023f3f0		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023f3f4		8a050107		AND R5, R8, R7				
  operators_test.go:61	0x10023f3f8		8a41fd08		AND R1>>63, R8, R8			
  operators_test.go:61	0x10023f3fc		d37ffc69		LSR $63, R3, R9				
  operators_test.go:61	0x10023f400		ca41fd2a		EOR R1>>63, R9, R10			
  operators_test.go:61	0x10023f404		d240014a		EOR $1, R10, R10			
  operators_test.go:61	0x10023f408		8a070147		AND R7, R10, R7				
  operators_test.go:61	0x10023f40c		d24000ea		EOR $1, R7, R10				
  operators_test.go:61	0x10023f410		8a080148		AND R8, R10, R8				
  operators_test.go:61	0x10023f414		d2400129		EOR $1, R9, R9				
  operators_test.go:61	0x10023f418		8a050129		AND R5, R9, R9				
  operators_test.go:61	0x10023f41c		8a060126		AND R6, R9, R6				
  operators_test.go:61	0x10023f420		aa060106		ORR R6, R8, R6				
  operators_test.go:61	0x10023f424		aa0600e5		ORR R6, R7, R5				
  operators_test.go:61	0x10023f428		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f42c		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023f430		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023f434		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023f438		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023f43c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023f440		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023f444		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023f448		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023f44c		97f78a85		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023f450		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023f454		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f458		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023f45c		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023f460		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023f464		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023f468		39016fe5		MOVB R5, 91(RSP)			
  operators_test.go:61	0x10023f46c		54000de1		BNE 111(PC)				
  operators_test.go:61	0x10023f470		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023f474		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023f478		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f47c		54000820		BEQ 65(PC)				
  operators_test.go:61	0x10023f480		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023f484		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f488		540007c0		BEQ 62(PC)				
  operators_test.go:61	0x10023f48c		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f490		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023f494		8a43fca5		AND R3>>63, R5, R5			
  operators_test.go:61	0x10023f498		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f49c		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023f4a0		8a41fcc6		AND R1>>63, R6, R6			
  operators_test.go:61	0x10023f4a4		ca0500c6		EOR R5, R6, R6				
  operators_test.go:61	0x10023f4a8		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f4ac		36000066		TBZ $0, R6, 3(PC)			
  operators_test.go:61	0x10023f4b0		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f4b4		1400006b		JMP 107(PC)				
  operators_test.go:61	0x10023f4b8		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f4bc		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f4c0		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f4c4		aa0600e6		ORR R6, R7, R6				
  operators_test.go:61	0x10023f4c8		d2e60807		MOVD $3476778912330022912, R7		
  operators_test.go:61	0x10023f4cc		ca070068		EOR R7, R3, R8				
  operators_test.go:61	0x10023f4d0		ca070027		EOR R7, R1, R7				
  operators_test.go:61	0x10023f4d4		d371f908		UBFX $49, R8, $14, R8			
  operators_test.go:61	0x10023f4d8		d371f8e7		UBFX $49, R7, $14, R7			
  operators_test.go:61	0x10023f4dc		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f4e0		9a9f17e9		CSET EQ, R9				
  operators_test.go:61	0x10023f4e4		aa0900c6		ORR R9, R6, R6				
  operators_test.go:61	0x10023f4e8		36000106		TBZ $0, R6, 8(PC)			
  operators_test.go:61	0x10023f4ec		eb02001f		CMP R2, R0				
  operators_test.go:61	0x10023f4f0		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023f4f4		9a9f07e7		CSET NE, R7				
  operators_test.go:61	0x10023f4f8		ca0600a6		EOR R6, R5, R6				
  operators_test.go:61	0x10023f4fc		8a0700c5		AND R7, R6, R5				
  operators_test.go:61	0x10023f500		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f504		14000057		JMP 87(PC)				
  operators_test.go:61	0x10023f508		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023f50c		cb0800e9		SUB R8, R7, R9				
  operators_test.go:61	0x10023f510		cb07010a		SUB R7, R8, R10				
  operators_test.go:61	0x10023f514		9a8a8129		CSEL HI, R9, R10, R9			
  operators_test.go:61	0x10023f518		f1004d3f		CMP $19, R9				
  operators_test.go:61	0x10023f51c		540002c8		BHI 22(PC)				
  operators_test.go:61	0x10023f520		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f524		9a828007		CSEL HI, R0, R2, R7			
  operators_test.go:61	0x10023f528		9a808048		CSEL HI, R2, R0, R8			
  operators_test.go:61	0x10023f52c		ca0600a6		EOR R6, R5, R6				
  operators_test.go:61	0x10023f530		f00004aa		ADRP 618496(PC), R10			
  operators_test.go:61	0x10023f534		910d314a		ADD $844, R10, R10			
  operators_test.go:61	0x10023f538		f8697949		MOVD (R10)(R9<<3), R9			
  operators_test.go:61	0x10023f53c		9bc77d2a		UMULH R7, R9, R10			
  operators_test.go:61	0x10023f540		9b077d27		MUL R7, R9, R7				
  operators_test.go:61	0x10023f544		eb07011f		CMP R7, R8				
  operators_test.go:61	0x10023f548		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f54c		9a9f97e8		CSET HI, R8				
  operators_test.go:61	0x10023f550		f100015f		CMP $0, R10				
  operators_test.go:61	0x10023f554		9a9f17e9		CSET EQ, R9				
  operators_test.go:61	0x10023f558		8a0900e7		AND R9, R7, R7				
  operators_test.go:61	0x10023f55c		8a080128		AND R8, R9, R8				
  operators_test.go:61	0x10023f560		ca060106		EOR R6, R8, R6				
  operators_test.go:61	0x10023f564		d24000e7		EOR $1, R7, R7				
  operators_test.go:61	0x10023f568		8a0600e5		AND R6, R7, R5				
  operators_test.go:61	0x10023f56c		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f570		1400003c		JMP 60(PC)				
  operators_test.go:61	0x10023f574		ca0600a5		EOR R6, R5, R5				
  operators_test.go:61	0x10023f578		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f57c		14000039		JMP 57(PC)				
  operators_test.go:61	0x10023f580		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023f584		ca050066		EOR R5, R3, R6				
  operators_test.go:61	0x10023f588		ca050025		EOR R5, R1, R5				
  operators_test.go:61	0x10023f58c		924610c7		AND $8935141660703064064, R6, R7	
  operators_test.go:61	0x10023f590		924610a8		AND $8935141660703064064, R5, R8	
  operators_test.go:61	0x10023f594		d2ef8009		MOVD $8935141660703064064, R9		
  operators_test.go:61	0x10023f598		eb0900ff		CMP R9, R7				
  operators_test.go:61	0x10023f59c		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f5a0		eb09011f		CMP R9, R8				
  operators_test.go:61	0x10023f5a4		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023f5a8		aa070107		ORR R7, R8, R7				
  operators_test.go:61	0x10023f5ac		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f5b0		36000067		TBZ $0, R7, 3(PC)			
  operators_test.go:61	0x10023f5b4		aa1f03e5		MOVD ZR, R5				
  operators_test.go:61	0x10023f5b8		1400002a		JMP 42(PC)				
  operators_test.go:61	0x10023f5bc		92450cc6		AND $8646911284551352320, R6, R6	
  operators_test.go:61	0x10023f5c0		92450ca5		AND $8646911284551352320, R5, R5	
  operators_test.go:61	0x10023f5c4		d2ef0007		MOVD $8646911284551352320, R7		
  operators_test.go:61	0x10023f5c8		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f5cc		9a9f17e8		CSET EQ, R8				
  operators_test.go:61	0x10023f5d0		eb0700bf		CMP R7, R5				
  operators_test.go:61	0x10023f5d4		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023f5d8		aa0800a9		ORR R8, R5, R9				
  operators_test.go:61	0x10023f5dc		eb0700df		CMP R7, R6				
  operators_test.go:61	0x10023f5e0		36000249		TBZ $0, R9, 18(PC)			
  operators_test.go:61	0x10023f5e4		9a9f07e6		CSET NE, R6				
  operators_test.go:61	0x10023f5e8		8a0800a7		AND R8, R5, R7				
  operators_test.go:61	0x10023f5ec		8a43fd08		AND R3>>63, R8, R8			
  operators_test.go:61	0x10023f5f0		d37ffc69		LSR $63, R3, R9				
  operators_test.go:61	0x10023f5f4		ca41fd29		EOR R1>>63, R9, R9			
  operators_test.go:61	0x10023f5f8		d2400129		EOR $1, R9, R9				
  operators_test.go:61	0x10023f5fc		8a070127		AND R7, R9, R7				
  operators_test.go:61	0x10023f600		d24000e7		EOR $1, R7, R7				
  operators_test.go:61	0x10023f604		8a0800e8		AND R8, R7, R8				
  operators_test.go:61	0x10023f608		d37ffc29		LSR $63, R1, R9				
  operators_test.go:61	0x10023f60c		d2400129		EOR $1, R9, R9				
  operators_test.go:61	0x10023f610		8a050129		AND R5, R9, R9				
  operators_test.go:61	0x10023f614		8a060126		AND R6, R9, R6				
  operators_test.go:61	0x10023f618		aa060106		ORR R6, R8, R6				
  operators_test.go:61	0x10023f61c		8a0600e5		AND R6, R7, R5				
  operators_test.go:61	0x10023f620		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f624		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023f628		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023f62c		ca040065		EOR R4, R3, R5				
  operators_test.go:61	0x10023f630		ca040024		EOR R4, R1, R4				
  operators_test.go:61	0x10023f634		aa0203e1		MOVD R2, R1				
  operators_test.go:61	0x10023f638		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023f63c		aa0003e3		MOVD R0, R3				
  operators_test.go:61	0x10023f640		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023f644		97f789ef		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023f648		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023f64c		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023f650		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023f654		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023f658		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023f65c		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023f660		390173e5		MOVB R5, 92(RSP)			
  operators_test.go:61	0x10023f664		54000da1		BNE 109(PC)				
  operators_test.go:61	0x10023f668		92430464		AND $6917529027641081856, R3, R4	
  operators_test.go:61	0x10023f66c		d2e80005		MOVD $4611686018427387904, R5		
  operators_test.go:61	0x10023f670		eb05009f		CMP R5, R4				
  operators_test.go:61	0x10023f674		54000800		BEQ 64(PC)				
  operators_test.go:61	0x10023f678		92430424		AND $6917529027641081856, R1, R4	
  operators_test.go:61	0x10023f67c		eb05009f		CMP R5, R4				
  operators_test.go:61	0x10023f680		540007a0		BEQ 61(PC)				
  operators_test.go:61	0x10023f684		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f688		9a9f07e4		CSET NE, R4				
  operators_test.go:61	0x10023f68c		8a43fc84		AND R3>>63, R4, R4			
  operators_test.go:61	0x10023f690		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f694		9a9f07e5		CSET NE, R5				
  operators_test.go:61	0x10023f698		8a41fca5		AND R1>>63, R5, R5			
  operators_test.go:61	0x10023f69c		ca0400a5		EOR R4, R5, R5				
  operators_test.go:61	0x10023f6a0		f100005f		CMP $0, R2				
  operators_test.go:61	0x10023f6a4		36000065		TBZ $0, R5, 3(PC)			
  operators_test.go:61	0x10023f6a8		aa0403e0		MOVD R4, R0				
  operators_test.go:61	0x10023f6ac		14000063		JMP 99(PC)				
  operators_test.go:61	0x10023f6b0		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023f6b4		f100001f		CMP $0, R0				
  operators_test.go:61	0x10023f6b8		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f6bc		aa0500c5		ORR R5, R6, R5				
  operators_test.go:61	0x10023f6c0		d2e60806		MOVD $3476778912330022912, R6		
  operators_test.go:61	0x10023f6c4		ca060063		EOR R6, R3, R3				
  operators_test.go:61	0x10023f6c8		ca060021		EOR R6, R1, R1				
  operators_test.go:61	0x10023f6cc		d371f863		UBFX $49, R3, $14, R3			
  operators_test.go:61	0x10023f6d0		d371f821		UBFX $49, R1, $14, R1			
  operators_test.go:61	0x10023f6d4		eb03003f		CMP R3, R1				
  operators_test.go:61	0x10023f6d8		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f6dc		aa0600a5		ORR R6, R5, R5				
  operators_test.go:61	0x10023f6e0		36000105		TBZ $0, R5, 8(PC)			
  operators_test.go:61	0x10023f6e4		eb02001f		CMP R2, R0				
  operators_test.go:61	0x10023f6e8		9a9f97e0		CSET HI, R0				
  operators_test.go:61	0x10023f6ec		9a9f17e1		CSET EQ, R1				
  operators_test.go:61	0x10023f6f0		ca000080		EOR R0, R4, R0				
  operators_test.go:61	0x10023f6f4		aa010004		ORR R1, R0, R4				
  operators_test.go:61	0x10023f6f8		aa0403e0		MOVD R4, R0				
  operators_test.go:61	0x10023f6fc		1400004f		JMP 79(PC)				
  operators_test.go:61	0x10023f700		9a9f97e5		CSET HI, R5				
  operators_test.go:61	0x10023f704		cb030026		SUB R3, R1, R6				
  operators_test.go:61	0x10023f708		cb010067		SUB R1, R3, R7				
  operators_test.go:61	0x10023f70c		9a8780c6		CSEL HI, R6, R7, R6			
  operators_test.go:61	0x10023f710		f1004cdf		CMP $19, R6				
  operators_test.go:61	0x10023f714		540002a8		BHI 21(PC)				
  operators_test.go:61	0x10023f718		eb03003f		CMP R3, R1				
  operators_test.go:61	0x10023f71c		9a828001		CSEL HI, R0, R2, R1			
  operators_test.go:61	0x10023f720		9a808040		CSEL HI, R2, R0, R0			
  operators_test.go:61	0x10023f724		ca050082		EOR R5, R4, R2				
  operators_test.go:61	0x10023f728		f00004a3		ADRP 618496(PC), R3			
  operators_test.go:61	0x10023f72c		910d3063		ADD $844, R3, R3			
  operators_test.go:61	0x10023f730		f8667863		MOVD (R3)(R6<<3), R3			
  operators_test.go:61	0x10023f734		9bc17c65		UMULH R1, R3, R5			
  operators_test.go:61	0x10023f738		9b017c61		MUL R1, R3, R1				
  operators_test.go:61	0x10023f73c		eb01001f		CMP R1, R0				
  operators_test.go:61	0x10023f740		9a9f17e0		CSET EQ, R0				
  operators_test.go:61	0x10023f744		9a9f97e1		CSET HI, R1				
  operators_test.go:61	0x10023f748		f10000bf		CMP $0, R5				
  operators_test.go:61	0x10023f74c		9a9f17e3		CSET EQ, R3				
  operators_test.go:61	0x10023f750		8a030000		AND R3, R0, R0				
  operators_test.go:61	0x10023f754		8a010061		AND R1, R3, R1				
  operators_test.go:61	0x10023f758		ca020021		EOR R2, R1, R1				
  operators_test.go:61	0x10023f75c		aa000024		ORR R0, R1, R4				
  operators_test.go:61	0x10023f760		aa0403e0		MOVD R4, R0				
  operators_test.go:61	0x10023f764		14000035		JMP 53(PC)				
  operators_test.go:61	0x10023f768		ca050084		EOR R5, R4, R4				
  operators_test.go:61	0x10023f76c		aa0403e0		MOVD R4, R0				
  operators_test.go:61	0x10023f770		14000032		JMP 50(PC)				
  operators_test.go:61	0x10023f774		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023f778		ca040065		EOR R4, R3, R5				
  operators_test.go:61	0x10023f77c		ca040024		EOR R4, R1, R4				
  operators_test.go:61	0x10023f780		924610a6		AND $8935141660703064064, R5, R6	
  operators_test.go:61	0x10023f784		92461087		AND $8935141660703064064, R4, R7	
  operators_test.go:61	0x10023f788		d2ef8008		MOVD $8935141660703064064, R8		
  operators_test.go:61	0x10023f78c		eb0800df		CMP R8, R6				
  operators_test.go:61	0x10023f790		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023f794		eb0800ff		CMP R8, R7				
  operators_test.go:61	0x10023f798		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f79c		aa0600e6		ORR R6, R7, R6				
  operators_test.go:61	0x10023f7a0		36000066		TBZ $0, R6, 3(PC)			
  operators_test.go:61	0x10023f7a4		aa1f03e0		MOVD ZR, R0				
  operators_test.go:61	0x10023f7a8		14000024		JMP 36(PC)				
  operators_test.go:61	0x10023f7ac		92450ca5		AND $8646911284551352320, R5, R5	
  operators_test.go:61	0x10023f7b0		92450c84		AND $8646911284551352320, R4, R4	
  operators_test.go:61	0x10023f7b4		d2ef0006		MOVD $8646911284551352320, R6		
  operators_test.go:61	0x10023f7b8		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f7bc		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023f7c0		eb06009f		CMP R6, R4				
  operators_test.go:61	0x10023f7c4		9a9f17e4		CSET EQ, R4				
  operators_test.go:61	0x10023f7c8		aa070088		ORR R7, R4, R8				
  operators_test.go:61	0x10023f7cc		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023f7d0		36000248		TBZ $0, R8, 18(PC)			
  operators_test.go:61	0x10023f7d4		9a9f07e0		CSET NE, R0				
  operators_test.go:61	0x10023f7d8		8a070082		AND R7, R4, R2				
  operators_test.go:61	0x10023f7dc		8a43fce5		AND R3>>63, R7, R5			
  operators_test.go:61	0x10023f7e0		d37ffc63		LSR $63, R3, R3				
  operators_test.go:61	0x10023f7e4		ca41fc63		EOR R1>>63, R3, R3			
  operators_test.go:61	0x10023f7e8		d2400063		EOR $1, R3, R3				
  operators_test.go:61	0x10023f7ec		8a020062		AND R2, R3, R2				
  operators_test.go:61	0x10023f7f0		d2400043		EOR $1, R2, R3				
  operators_test.go:61	0x10023f7f4		8a050063		AND R5, R3, R3				
  operators_test.go:61	0x10023f7f8		d37ffc21		LSR $63, R1, R1				
  operators_test.go:61	0x10023f7fc		d2400021		EOR $1, R1, R1				
  operators_test.go:61	0x10023f800		8a040021		AND R4, R1, R1				
  operators_test.go:61	0x10023f804		8a000020		AND R0, R1, R0				
  operators_test.go:61	0x10023f808		aa000060		ORR R0, R3, R0				
  operators_test.go:61	0x10023f80c		aa000044		ORR R0, R2, R4				
  operators_test.go:61	0x10023f810		aa0403e0		MOVD R4, R0				
  operators_test.go:61	0x10023f814		14000009		JMP 9(PC)				
  operators_test.go:61	0x10023f818		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023f81c		ca040065		EOR R4, R3, R5				
  operators_test.go:61	0x10023f820		ca040024		EOR R4, R1, R4				
  operators_test.go:61	0x10023f824		aa0203e1		MOVD R2, R1				
  operators_test.go:61	0x10023f828		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023f82c		aa0003e3		MOVD R0, R3				
  operators_test.go:61	0x10023f830		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023f834		97f7898b		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023f838		390177e0		MOVB R0, 93(RSP)			
  operators_test.go:61	0x10023f83c		f85f83fd		MOVD -8(RSP), R29			
  operators_test.go:61	0x10023f840		f84507fe		MOVD.P 80(RSP), R30			
  operators_test.go:61	0x10023f844		d65f03c0		RET					
  operators_test.go:60	0x10023f848		a90107e0		STP (R0, R1), 16(RSP)			
  operators_test.go:60	0x10023f84c		a9020fe2		STP (R2, R3), 32(RSP)			
  operators_test.go:60	0x10023f850		aa1e03e3		MOVD R30, R3				
  operators_test.go:60	0x10023f854		97f94aaf		CALL runtime.morestack_noctxt.abi0(SB)	
  operators_test.go:60	0x10023f858		a94107e0		LDP 16(RSP), (R0, R1)			
  operators_test.go:60	0x10023f85c		a9420fe2		LDP 32(RSP), (R2, R3)			
  operators_test.go:60	0x10023f860		17fffd28		JMP internal/bid_test.opCmp128(SB)	
  operators_test.go:60	0x10023f864		00000000		?					
  operators_test.go:60	0x10023f868		00000000		?					
  operators_test.go:60	0x10023f86c		00000000		?					
