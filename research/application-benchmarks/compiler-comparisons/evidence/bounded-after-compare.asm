TEXT internal/bid_test.opCmp128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/operators_test.go
  operators_test.go:60	0x10023dea0		f9400b90		MOVD 16(R28), R16			
  operators_test.go:60	0x10023dea4		eb3063ff		CMP R16, RSP				
  operators_test.go:60	0x10023dea8		54002a89		BLS 340(PC)				
  operators_test.go:60	0x10023deac		f81b0ffe		MOVD.W R30, -80(RSP)			
  operators_test.go:60	0x10023deb0		f81f83fd		MOVD R29, -8(RSP)			
  operators_test.go:60	0x10023deb4		d10023fd		SUB $8, RSP, R29			
  operators_test.go:61	0x10023deb8		a9070fe2		STP (R2, R3), 112(RSP)			
  operators_test.go:61	0x10023debc		a90607e0		STP (R0, R1), 96(RSP)			
  operators_test.go:60	0x10023dec0		b9005bff		MOVW ZR, 88(RSP)			
  operators_test.go:60	0x10023dec4		7900bbff		MOVH ZR, 92(RSP)			
  operators_test.go:61	0x10023dec8		aa010064		ORR R1, R3, R4				
  operators_test.go:61	0x10023decc		f90023e4		MOVD R4, 64(RSP)			
  operators_test.go:61	0x10023ded0		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023ded4		54000481		BNE 36(PC)				
  operators_test.go:61	0x10023ded8		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023dedc		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023dee0		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023dee4		54000400		BEQ 32(PC)				
  operators_test.go:61	0x10023dee8		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023deec		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023def0		540003a0		BEQ 29(PC)				
  operators_test.go:61	0x10023def4		ca030025		EOR R3, R1, R5				
  operators_test.go:61	0x10023def8		b7f80365		TBNZ $63, R5, 27(PC)			
  operators_test.go:61	0x10023defc		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023df00		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023df04		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023df08		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023df0c		d371f8a5		UBFX $49, R5, $14, R5			
  operators_test.go:61	0x10023df10		cb0600a7		SUB R6, R5, R7				
  operators_test.go:61	0x10023df14		cb0500c8		SUB R5, R6, R8				
  operators_test.go:61	0x10023df18		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023df1c		9a8880e7		CSEL HI, R7, R8, R7			
  operators_test.go:61	0x10023df20		f1004cff		CMP $19, R7				
  operators_test.go:61	0x10023df24		54000208		BHI 16(PC)				
  operators_test.go:61	0x10023df28		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023df2c		9a808045		CSEL HI, R2, R0, R5			
  operators_test.go:61	0x10023df30		9a828006		CSEL HI, R0, R2, R6			
  operators_test.go:61	0x10023df34		d00004a8		ADRP 614400(PC), R8			
  operators_test.go:61	0x10023df38		91142d08		ADD $1291, R8, R8			
  operators_test.go:61	0x10023df3c		f8677907		MOVD (R8)(R7<<3), R7			
  operators_test.go:61	0x10023df40		9bc57ce8		UMULH R5, R7, R8			
  operators_test.go:61	0x10023df44		9b057ce5		MUL R5, R7, R5				
  operators_test.go:61	0x10023df48		eb0500df		CMP R5, R6				
  operators_test.go:61	0x10023df4c		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023df50		f100011f		CMP $0, R8				
  operators_test.go:61	0x10023df54		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023df58		8a0500c5		AND R5, R6, R5				
  operators_test.go:61	0x10023df5c		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023df60		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023df64		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023df68		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023df6c		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023df70		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023df74		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023df78		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023df7c		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023df80		97f78f88		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023df84		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023df88		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023df8c		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023df90		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023df94		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023df98		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023df9c		390163e5		MOVB R5, 88(RSP)			
  operators_test.go:61	0x10023dfa0		54000481		BNE 36(PC)				
  operators_test.go:61	0x10023dfa4		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023dfa8		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023dfac		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023dfb0		54000400		BEQ 32(PC)				
  operators_test.go:61	0x10023dfb4		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023dfb8		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023dfbc		540003a0		BEQ 29(PC)				
  operators_test.go:61	0x10023dfc0		ca030025		EOR R3, R1, R5				
  operators_test.go:61	0x10023dfc4		b7f80365		TBNZ $63, R5, 27(PC)			
  operators_test.go:61	0x10023dfc8		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023dfcc		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023dfd0		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023dfd4		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023dfd8		d371f8a5		UBFX $49, R5, $14, R5			
  operators_test.go:61	0x10023dfdc		cb0600a7		SUB R6, R5, R7				
  operators_test.go:61	0x10023dfe0		cb0500c8		SUB R5, R6, R8				
  operators_test.go:61	0x10023dfe4		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023dfe8		9a8880e7		CSEL HI, R7, R8, R7			
  operators_test.go:61	0x10023dfec		f1004cff		CMP $19, R7				
  operators_test.go:61	0x10023dff0		54000208		BHI 16(PC)				
  operators_test.go:61	0x10023dff4		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023dff8		9a808045		CSEL HI, R2, R0, R5			
  operators_test.go:61	0x10023dffc		9a828006		CSEL HI, R0, R2, R6			
  operators_test.go:61	0x10023e000		b00004a8		ADRP 610304(PC), R8			
  operators_test.go:61	0x10023e004		91142d08		ADD $1291, R8, R8			
  operators_test.go:61	0x10023e008		f8677907		MOVD (R8)(R7<<3), R7			
  operators_test.go:61	0x10023e00c		9bc57ce8		UMULH R5, R7, R8			
  operators_test.go:61	0x10023e010		9b057ce5		MUL R5, R7, R5				
  operators_test.go:61	0x10023e014		eb0500df		CMP R5, R6				
  operators_test.go:61	0x10023e018		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023e01c		f100011f		CMP $0, R8				
  operators_test.go:61	0x10023e020		9a9f17e6		CSET EQ, R6				
  operators_test.go:61	0x10023e024		8a0500c5		AND R5, R6, R5				
  operators_test.go:61	0x10023e028		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e02c		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023e030		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023e034		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023e038		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023e03c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023e040		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023e044		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023e048		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023e04c		97f78f55		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023e050		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023e054		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e058		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023e05c		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023e060		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023e064		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023e068		d24000a5		EOR $1, R5, R5				
  operators_test.go:61	0x10023e06c		390167e5		MOVB R5, 89(RSP)			
  operators_test.go:61	0x10023e070		54000561		BNE 43(PC)				
  operators_test.go:61	0x10023e074		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023e078		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023e07c		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e080		540004e0		BEQ 39(PC)				
  operators_test.go:61	0x10023e084		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023e088		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e08c		54000480		BEQ 36(PC)				
  operators_test.go:61	0x10023e090		ca030025		EOR R3, R1, R5				
  operators_test.go:61	0x10023e094		b7f80445		TBNZ $63, R5, 34(PC)			
  operators_test.go:61	0x10023e098		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023e09c		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023e0a0		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023e0a4		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023e0a8		d371f8a5		UBFX $49, R5, $14, R5			
  operators_test.go:61	0x10023e0ac		cb0600a7		SUB R6, R5, R7				
  operators_test.go:61	0x10023e0b0		cb0500c8		SUB R5, R6, R8				
  operators_test.go:61	0x10023e0b4		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e0b8		9a8880e7		CSEL HI, R7, R8, R7			
  operators_test.go:61	0x10023e0bc		f1004cff		CMP $19, R7				
  operators_test.go:61	0x10023e0c0		540002e8		BHI 23(PC)				
  operators_test.go:61	0x10023e0c4		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e0c8		9a808045		CSEL HI, R2, R0, R5			
  operators_test.go:61	0x10023e0cc		9a828006		CSEL HI, R0, R2, R6			
  operators_test.go:61	0x10023e0d0		9a9f97e8		CSET HI, R8				
  operators_test.go:61	0x10023e0d4		ca41fd08		EOR R1>>63, R8, R8			
  operators_test.go:61	0x10023e0d8		b00004a9		ADRP 610304(PC), R9			
  operators_test.go:61	0x10023e0dc		91142d29		ADD $1291, R9, R9			
  operators_test.go:61	0x10023e0e0		f8677927		MOVD (R9)(R7<<3), R7			
  operators_test.go:61	0x10023e0e4		9bc57ce9		UMULH R5, R7, R9			
  operators_test.go:61	0x10023e0e8		9b057ce5		MUL R5, R7, R5				
  operators_test.go:61	0x10023e0ec		eb0500df		CMP R5, R6				
  operators_test.go:61	0x10023e0f0		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023e0f4		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023e0f8		f100013f		CMP $0, R9				
  operators_test.go:61	0x10023e0fc		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023e100		8a0500e5		AND R5, R7, R5				
  operators_test.go:61	0x10023e104		8a0700c6		AND R7, R6, R6				
  operators_test.go:61	0x10023e108		ca0800c6		EOR R8, R6, R6				
  operators_test.go:61	0x10023e10c		d24000a5		EOR $1, R5, R5				
  operators_test.go:61	0x10023e110		8a0600a5		AND R6, R5, R5				
  operators_test.go:61	0x10023e114		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e118		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023e11c		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023e120		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023e124		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023e128		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023e12c		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023e130		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023e134		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023e138		97f78f32		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023e13c		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023e140		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e144		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023e148		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023e14c		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023e150		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023e154		39016be5		MOVB R5, 90(RSP)			
  operators_test.go:61	0x10023e158		54000541		BNE 42(PC)				
  operators_test.go:61	0x10023e15c		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023e160		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023e164		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e168		540004c0		BEQ 38(PC)				
  operators_test.go:61	0x10023e16c		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023e170		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e174		54000460		BEQ 35(PC)				
  operators_test.go:61	0x10023e178		ca030025		EOR R3, R1, R5				
  operators_test.go:61	0x10023e17c		b7f80425		TBNZ $63, R5, 33(PC)			
  operators_test.go:61	0x10023e180		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023e184		ca050026		EOR R5, R1, R6				
  operators_test.go:61	0x10023e188		ca050065		EOR R5, R3, R5				
  operators_test.go:61	0x10023e18c		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023e190		d371f8a5		UBFX $49, R5, $14, R5			
  operators_test.go:61	0x10023e194		cb0600a7		SUB R6, R5, R7				
  operators_test.go:61	0x10023e198		cb0500c8		SUB R5, R6, R8				
  operators_test.go:61	0x10023e19c		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e1a0		9a8880e7		CSEL HI, R7, R8, R7			
  operators_test.go:61	0x10023e1a4		f1004cff		CMP $19, R7				
  operators_test.go:61	0x10023e1a8		540002c8		BHI 22(PC)				
  operators_test.go:61	0x10023e1ac		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e1b0		9a808045		CSEL HI, R2, R0, R5			
  operators_test.go:61	0x10023e1b4		9a828006		CSEL HI, R0, R2, R6			
  operators_test.go:61	0x10023e1b8		9a9f97e8		CSET HI, R8				
  operators_test.go:61	0x10023e1bc		ca41fd08		EOR R1>>63, R8, R8			
  operators_test.go:61	0x10023e1c0		b00004a9		ADRP 610304(PC), R9			
  operators_test.go:61	0x10023e1c4		91142d29		ADD $1291, R9, R9			
  operators_test.go:61	0x10023e1c8		f8677927		MOVD (R9)(R7<<3), R7			
  operators_test.go:61	0x10023e1cc		9bc57ce9		UMULH R5, R7, R9			
  operators_test.go:61	0x10023e1d0		9b057ce5		MUL R5, R7, R5				
  operators_test.go:61	0x10023e1d4		eb0500df		CMP R5, R6				
  operators_test.go:61	0x10023e1d8		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023e1dc		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023e1e0		f100013f		CMP $0, R9				
  operators_test.go:61	0x10023e1e4		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023e1e8		8a0500e5		AND R5, R7, R5				
  operators_test.go:61	0x10023e1ec		8a0700c6		AND R7, R6, R6				
  operators_test.go:61	0x10023e1f0		ca0800c6		EOR R8, R6, R6				
  operators_test.go:61	0x10023e1f4		aa0600a5		ORR R6, R5, R5				
  operators_test.go:61	0x10023e1f8		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e1fc		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023e200		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023e204		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023e208		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023e20c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023e210		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023e214		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023e218		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023e21c		97f78f11		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023e220		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023e224		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e228		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023e22c		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023e230		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023e234		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023e238		39016fe5		MOVB R5, 91(RSP)			
  operators_test.go:61	0x10023e23c		54000561		BNE 43(PC)				
  operators_test.go:61	0x10023e240		92430465		AND $6917529027641081856, R3, R5	
  operators_test.go:61	0x10023e244		d2e80006		MOVD $4611686018427387904, R6		
  operators_test.go:61	0x10023e248		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e24c		540004e0		BEQ 39(PC)				
  operators_test.go:61	0x10023e250		92430425		AND $6917529027641081856, R1, R5	
  operators_test.go:61	0x10023e254		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e258		54000480		BEQ 36(PC)				
  operators_test.go:61	0x10023e25c		ca030025		EOR R3, R1, R5				
  operators_test.go:61	0x10023e260		b7f80445		TBNZ $63, R5, 34(PC)			
  operators_test.go:61	0x10023e264		d2e60805		MOVD $3476778912330022912, R5		
  operators_test.go:61	0x10023e268		ca050066		EOR R5, R3, R6				
  operators_test.go:61	0x10023e26c		ca050025		EOR R5, R1, R5				
  operators_test.go:61	0x10023e270		d371f8c6		UBFX $49, R6, $14, R6			
  operators_test.go:61	0x10023e274		d371f8a5		UBFX $49, R5, $14, R5			
  operators_test.go:61	0x10023e278		cb0600a7		SUB R6, R5, R7				
  operators_test.go:61	0x10023e27c		cb0500c8		SUB R5, R6, R8				
  operators_test.go:61	0x10023e280		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e284		9a8880e7		CSEL HI, R7, R8, R7			
  operators_test.go:61	0x10023e288		f1004cff		CMP $19, R7				
  operators_test.go:61	0x10023e28c		540002e8		BHI 23(PC)				
  operators_test.go:61	0x10023e290		eb0600bf		CMP R6, R5				
  operators_test.go:61	0x10023e294		9a828005		CSEL HI, R0, R2, R5			
  operators_test.go:61	0x10023e298		9a808046		CSEL HI, R2, R0, R6			
  operators_test.go:61	0x10023e29c		9a9f97e8		CSET HI, R8				
  operators_test.go:61	0x10023e2a0		ca43fd08		EOR R3>>63, R8, R8			
  operators_test.go:61	0x10023e2a4		b00004a9		ADRP 610304(PC), R9			
  operators_test.go:61	0x10023e2a8		91142d29		ADD $1291, R9, R9			
  operators_test.go:61	0x10023e2ac		f8677927		MOVD (R9)(R7<<3), R7			
  operators_test.go:61	0x10023e2b0		9bc57ce9		UMULH R5, R7, R9			
  operators_test.go:61	0x10023e2b4		9b057ce5		MUL R5, R7, R5				
  operators_test.go:61	0x10023e2b8		eb0500df		CMP R5, R6				
  operators_test.go:61	0x10023e2bc		9a9f17e5		CSET EQ, R5				
  operators_test.go:61	0x10023e2c0		9a9f97e6		CSET HI, R6				
  operators_test.go:61	0x10023e2c4		f100013f		CMP $0, R9				
  operators_test.go:61	0x10023e2c8		9a9f17e7		CSET EQ, R7				
  operators_test.go:61	0x10023e2cc		8a0500e5		AND R5, R7, R5				
  operators_test.go:61	0x10023e2d0		8a0700c6		AND R7, R6, R6				
  operators_test.go:61	0x10023e2d4		ca0800c6		EOR R8, R6, R6				
  operators_test.go:61	0x10023e2d8		d24000a5		EOR $1, R5, R5				
  operators_test.go:61	0x10023e2dc		8a0600a5		AND R6, R5, R5				
  operators_test.go:61	0x10023e2e0		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e2e4		1400000f		JMP 15(PC)				
  operators_test.go:61	0x10023e2e8		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023e2ec		ca040065		EOR R4, R3, R5				
  operators_test.go:61	0x10023e2f0		ca040024		EOR R4, R1, R4				
  operators_test.go:61	0x10023e2f4		aa0203e1		MOVD R2, R1				
  operators_test.go:61	0x10023e2f8		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023e2fc		aa0003e3		MOVD R0, R3				
  operators_test.go:61	0x10023e300		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023e304		97f78ebf		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023e308		f94023e4		MOVD 64(RSP), R4			
  operators_test.go:61	0x10023e30c		f240c09f		TST $562949953421311, R4		
  operators_test.go:61	0x10023e310		a9468be1		LDP 104(RSP), (R1, R2)			
  operators_test.go:61	0x10023e314		f9403fe3		MOVD 120(RSP), R3			
  operators_test.go:61	0x10023e318		aa0003e5		MOVD R0, R5				
  operators_test.go:61	0x10023e31c		f94033e0		MOVD 96(RSP), R0			
  operators_test.go:61	0x10023e320		390173e5		MOVB R5, 92(RSP)			
  operators_test.go:61	0x10023e324		54000521		BNE 41(PC)				
  operators_test.go:61	0x10023e328		92430464		AND $6917529027641081856, R3, R4	
  operators_test.go:61	0x10023e32c		d2e80005		MOVD $4611686018427387904, R5		
  operators_test.go:61	0x10023e330		eb05009f		CMP R5, R4				
  operators_test.go:61	0x10023e334		540004a0		BEQ 37(PC)				
  operators_test.go:61	0x10023e338		92430424		AND $6917529027641081856, R1, R4	
  operators_test.go:61	0x10023e33c		eb05009f		CMP R5, R4				
  operators_test.go:61	0x10023e340		54000440		BEQ 34(PC)				
  operators_test.go:61	0x10023e344		ca030024		EOR R3, R1, R4				
  operators_test.go:61	0x10023e348		b7f80404		TBNZ $63, R4, 32(PC)			
  operators_test.go:61	0x10023e34c		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023e350		ca040065		EOR R4, R3, R5				
  operators_test.go:61	0x10023e354		ca040024		EOR R4, R1, R4				
  operators_test.go:61	0x10023e358		d371f8a5		UBFX $49, R5, $14, R5			
  operators_test.go:61	0x10023e35c		d371f884		UBFX $49, R4, $14, R4			
  operators_test.go:61	0x10023e360		cb050086		SUB R5, R4, R6				
  operators_test.go:61	0x10023e364		cb0400a7		SUB R4, R5, R7				
  operators_test.go:61	0x10023e368		eb05009f		CMP R5, R4				
  operators_test.go:61	0x10023e36c		9a8780c6		CSEL HI, R6, R7, R6			
  operators_test.go:61	0x10023e370		f1004cdf		CMP $19, R6				
  operators_test.go:61	0x10023e374		540002a8		BHI 21(PC)				
  operators_test.go:61	0x10023e378		eb05009f		CMP R5, R4				
  operators_test.go:61	0x10023e37c		9a828001		CSEL HI, R0, R2, R1			
  operators_test.go:61	0x10023e380		9a808040		CSEL HI, R2, R0, R0			
  operators_test.go:61	0x10023e384		9a9f97e2		CSET HI, R2				
  operators_test.go:61	0x10023e388		ca43fc42		EOR R3>>63, R2, R2			
  operators_test.go:61	0x10023e38c		b00004a3		ADRP 610304(PC), R3			
  operators_test.go:61	0x10023e390		91142c63		ADD $1291, R3, R3			
  operators_test.go:61	0x10023e394		f8667863		MOVD (R3)(R6<<3), R3			
  operators_test.go:61	0x10023e398		9bc17c64		UMULH R1, R3, R4			
  operators_test.go:61	0x10023e39c		9b017c61		MUL R1, R3, R1				
  operators_test.go:61	0x10023e3a0		eb01001f		CMP R1, R0				
  operators_test.go:61	0x10023e3a4		9a9f17e0		CSET EQ, R0				
  operators_test.go:61	0x10023e3a8		9a9f97e1		CSET HI, R1				
  operators_test.go:61	0x10023e3ac		f100009f		CMP $0, R4				
  operators_test.go:61	0x10023e3b0		9a9f17e3		CSET EQ, R3				
  operators_test.go:61	0x10023e3b4		8a000060		AND R0, R3, R0				
  operators_test.go:61	0x10023e3b8		8a030021		AND R3, R1, R1				
  operators_test.go:61	0x10023e3bc		ca020021		EOR R2, R1, R1				
  operators_test.go:61	0x10023e3c0		aa010000		ORR R1, R0, R0				
  operators_test.go:61	0x10023e3c4		14000009		JMP 9(PC)				
  operators_test.go:61	0x10023e3c8		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023e3cc		ca040065		EOR R4, R3, R5				
  operators_test.go:61	0x10023e3d0		ca040024		EOR R4, R1, R4				
  operators_test.go:61	0x10023e3d4		aa0203e1		MOVD R2, R1				
  operators_test.go:61	0x10023e3d8		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023e3dc		aa0003e3		MOVD R0, R3				
  operators_test.go:61	0x10023e3e0		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023e3e4		97f78e9f		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023e3e8		390177e0		MOVB R0, 93(RSP)			
  operators_test.go:61	0x10023e3ec		f85f83fd		MOVD -8(RSP), R29			
  operators_test.go:61	0x10023e3f0		f84507fe		MOVD.P 80(RSP), R30			
  operators_test.go:61	0x10023e3f4		d65f03c0		RET					
  operators_test.go:60	0x10023e3f8		a90107e0		STP (R0, R1), 16(RSP)			
  operators_test.go:60	0x10023e3fc		a9020fe2		STP (R2, R3), 32(RSP)			
  operators_test.go:60	0x10023e400		aa1e03e3		MOVD R30, R3				
  operators_test.go:60	0x10023e404		97f94fff		CALL runtime.morestack_noctxt.abi0(SB)	
  operators_test.go:60	0x10023e408		a94107e0		LDP 16(RSP), (R0, R1)			
  operators_test.go:60	0x10023e40c		a9420fe2		LDP 32(RSP), (R2, R3)			
  operators_test.go:60	0x10023e410		17fffea4		JMP internal/bid_test.opCmp128(SB)	
  operators_test.go:60	0x10023e414		00000000		?					
  operators_test.go:60	0x10023e418		00000000		?					
  operators_test.go:60	0x10023e41c		00000000		?					
