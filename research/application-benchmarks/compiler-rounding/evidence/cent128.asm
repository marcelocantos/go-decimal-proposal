TEXT internal/bid_test.compiledCent128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:33	0x1002050e0		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:33	0x1002050e4		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:33	0x1002050e8		54000609		BLS 48(PC)					
  compiler_round_test.go:33	0x1002050ec		f81b0ffe		MOVD.W R30, -80(RSP)				
  compiler_round_test.go:33	0x1002050f0		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:33	0x1002050f4		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:33	0x1002050f8		92430425		AND $6917529027641081856, R1, R5		
  decimal.go:159		0x1002050fc		d503201f		NOOP						
  arithmetic.go:262		0x100205100		d503201f		NOOP						
  arithmetic.go:270		0x100205104		d2e60806		MOVD $3476778912330022912, R6			
  arithmetic.go:270		0x100205108		ca060027		EOR R6, R1, R7					
  arithmetic.go:270		0x10020510c		d2e80008		MOVD $4611686018427387904, R8			
  arithmetic.go:270		0x100205110		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x100205114		540003c0		BEQ 30(PC)					
  arithmetic.go:270		0x100205118		f240c0ff		TST $562949953421311, R7			
  arithmetic.go:270		0x10020511c		54000381		BNE 28(PC)					
  arithmetic.go:270		0x100205120		d371f8e5		UBFX $49, R7, $14, R5				
  arithmetic.go:270		0x100205124		d28303c8		MOVD $6174, R8					
  arithmetic.go:270		0x100205128		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x10020512c		54000380		BEQ 28(PC)					
  arithmetic.go:270		0x100205130		d28303a8		MOVD $6173, R8					
  arithmetic.go:270		0x100205134		cb050105		SUB R5, R8, R5					
  arithmetic.go:270		0x100205138		f10048bf		CMP $18, R5					
  arithmetic.go:270		0x10020513c		54000288		BHI 20(PC)					
  arithmetic.go:270		0x100205140		90000642		ADRP 819200(PC), R2				
  arithmetic.go:270		0x100205144		91248c42		ADD $2339, R2, R2				
  arithmetic.go:270		0x100205148		f8657842		MOVD (R2)(R5<<3), R2				
  arithmetic.go:270		0x10020514c		9ac20803		UDIV R2, R0, R3					
  arithmetic.go:270		0x100205150		9b038044		MSUB R3, R0, R2, R4				
  arithmetic.go:270		0x100205154		924100e5		AND $-9223372036854775808, R7, R5		
  arithmetic.go:270		0x100205158		d2e60787		MOVD $3475653012423180288, R7			
  arithmetic.go:270		0x10020515c		aa0700a5		ORR R7, R5, R5					
  arithmetic.go:270		0x100205160		ca0600a1		EOR R6, R5, R1					
  arithmetic.go:270		0x100205164		eb42049f		CMP R2>>1, R4					
  arithmetic.go:270		0x100205168		9a9f97e2		CSET HI, R2					
  arithmetic.go:270		0x10020516c		9a9f17e4		CSET EQ, R4					
  arithmetic.go:270		0x100205170		f240007f		TST $1, R3					
  arithmetic.go:270		0x100205174		9a9f07e5		CSET NE, R5					
  arithmetic.go:270		0x100205178		8a050084		AND R5, R4, R4					
  arithmetic.go:270		0x10020517c		aa040042		ORR R4, R2, R2					
  arithmetic.go:270		0x100205180		d3401c42		UBFX $0, R2, $8, R2				
  arithmetic.go:270		0x100205184		8b030040		ADD R3, R2, R0					
  arithmetic.go:270		0x100205188		14000005		JMP 5(PC)					
  arithmetic.go:270		0x10020518c		b24003e2		ORR $1, ZR, R2					
  arithmetic.go:270		0x100205190		d2e00f83		MOVD $34902897112121344, R3			
  arithmetic.go:270		0x100205194		aa1f03e4		MOVD ZR, R4					
  arithmetic.go:270		0x100205198		97faef8e		CALL internal/decimal.quantize128(SB)		
  compiler_round_test.go:33	0x10020519c		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:33	0x1002051a0		f84507fe		MOVD.P 80(RSP), R30				
  compiler_round_test.go:33	0x1002051a4		d65f03c0		RET						
  compiler_round_test.go:33	0x1002051a8		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:33	0x1002051ac		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:33	0x1002051b0		97fa3494		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:33	0x1002051b4		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:33	0x1002051b8		17ffffca		JMP internal/bid_test.compiledCent128(SB)	
  compiler_round_test.go:33	0x1002051bc		00000000		?						
