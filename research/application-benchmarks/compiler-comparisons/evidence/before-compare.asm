TEXT internal/bid_test.opCmp128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/operators_test.go
  operators_test.go:60	0x10023d4e0		f9400b90		MOVD 16(R28), R16			
  operators_test.go:60	0x10023d4e4		eb3063ff		CMP R16, RSP				
  operators_test.go:60	0x10023d4e8		540006a9		BLS 53(PC)				
  operators_test.go:60	0x10023d4ec		f81b0ffe		MOVD.W R30, -80(RSP)			
  operators_test.go:60	0x10023d4f0		f81f83fd		MOVD R29, -8(RSP)			
  operators_test.go:60	0x10023d4f4		d10023fd		SUB $8, RSP, R29			
  operators_test.go:61	0x10023d4f8		f9003be2		MOVD R2, 112(RSP)			
  operators_test.go:61	0x10023d4fc		f90033e0		MOVD R0, 96(RSP)			
  operators_test.go:60	0x10023d500		b9005bff		MOVW ZR, 88(RSP)			
  operators_test.go:60	0x10023d504		7900bbff		MOVH ZR, 92(RSP)			
  operators_test.go:61	0x10023d508		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023d50c		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023d510		f90023e5		MOVD R5, 64(RSP)			
  operators_test.go:61	0x10023d514		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023d518		f9001fe4		MOVD R4, 56(RSP)			
  operators_test.go:61	0x10023d51c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023d520		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023d524		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023d528		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023d52c		97f7921d		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023d530		390163e0		MOVB R0, 88(RSP)			
  operators_test.go:61	0x10023d534		f94023e0		MOVD 64(RSP), R0			
  operators_test.go:61	0x10023d538		f94033e1		MOVD 96(RSP), R1			
  operators_test.go:61	0x10023d53c		f9401fe2		MOVD 56(RSP), R2			
  operators_test.go:61	0x10023d540		f9403be3		MOVD 112(RSP), R3			
  operators_test.go:61	0x10023d544		97f79217		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023d548		d2400004		EOR $1, R0, R4				
  operators_test.go:61	0x10023d54c		390167e4		MOVB R4, 89(RSP)			
  operators_test.go:61	0x10023d550		f94023e0		MOVD 64(RSP), R0			
  operators_test.go:61	0x10023d554		f94033e1		MOVD 96(RSP), R1			
  operators_test.go:61	0x10023d558		f9401fe2		MOVD 56(RSP), R2			
  operators_test.go:61	0x10023d55c		f9403be3		MOVD 112(RSP), R3			
  operators_test.go:61	0x10023d560		97f79228		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023d564		39016be0		MOVB R0, 90(RSP)			
  operators_test.go:61	0x10023d568		f94023e0		MOVD 64(RSP), R0			
  operators_test.go:61	0x10023d56c		f94033e1		MOVD 96(RSP), R1			
  operators_test.go:61	0x10023d570		f9401fe2		MOVD 56(RSP), R2			
  operators_test.go:61	0x10023d574		f9403be3		MOVD 112(RSP), R3			
  operators_test.go:61	0x10023d578		97f7923a		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023d57c		39016fe0		MOVB R0, 91(RSP)			
  operators_test.go:61	0x10023d580		f9401fe0		MOVD 56(RSP), R0			
  operators_test.go:61	0x10023d584		f9403be1		MOVD 112(RSP), R1			
  operators_test.go:61	0x10023d588		f94023e2		MOVD 64(RSP), R2			
  operators_test.go:61	0x10023d58c		f94033e3		MOVD 96(RSP), R3			
  operators_test.go:61	0x10023d590		97f7921c		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023d594		390173e0		MOVB R0, 92(RSP)			
  operators_test.go:61	0x10023d598		f9401fe0		MOVD 56(RSP), R0			
  operators_test.go:61	0x10023d59c		f9403be1		MOVD 112(RSP), R1			
  operators_test.go:61	0x10023d5a0		f94023e2		MOVD 64(RSP), R2			
  operators_test.go:61	0x10023d5a4		f94033e3		MOVD 96(RSP), R3			
  operators_test.go:61	0x10023d5a8		97f7922e		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023d5ac		390177e0		MOVB R0, 93(RSP)			
  operators_test.go:61	0x10023d5b0		f85f83fd		MOVD -8(RSP), R29			
  operators_test.go:61	0x10023d5b4		f84507fe		MOVD.P 80(RSP), R30			
  operators_test.go:61	0x10023d5b8		d65f03c0		RET					
  operators_test.go:60	0x10023d5bc		a90107e0		STP (R0, R1), 16(RSP)			
  operators_test.go:60	0x10023d5c0		a9020fe2		STP (R2, R3), 32(RSP)			
  operators_test.go:60	0x10023d5c4		aa1e03e3		MOVD R30, R3				
  operators_test.go:60	0x10023d5c8		97f9538e		CALL runtime.morestack_noctxt.abi0(SB)	
  operators_test.go:60	0x10023d5cc		a94107e0		LDP 16(RSP), (R0, R1)			
  operators_test.go:60	0x10023d5d0		a9420fe2		LDP 32(RSP), (R2, R3)			
  operators_test.go:60	0x10023d5d4		17ffffc3		JMP internal/bid_test.opCmp128(SB)	
  operators_test.go:60	0x10023d5d8		00000000		?					
  operators_test.go:60	0x10023d5dc		00000000		?					
