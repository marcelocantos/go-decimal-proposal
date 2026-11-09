TEXT internal/bid_test.opCmp64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/operators_test.go
  operators_test.go:55	0x10023da60		f9400b90		MOVD 16(R28), R16			
  operators_test.go:55	0x10023da64		eb3063ff		CMP R16, RSP				
  operators_test.go:55	0x10023da68		54000409		BLS 32(PC)				
  operators_test.go:55	0x10023da6c		f81c0ffe		MOVD.W R30, -64(RSP)			
  operators_test.go:55	0x10023da70		f81f83fd		MOVD R29, -8(RSP)			
  operators_test.go:55	0x10023da74		d10023fd		SUB $8, RSP, R29			
  operators_test.go:55	0x10023da78		b9004bff		MOVW ZR, 72(RSP)			
  operators_test.go:55	0x10023da7c		79009bff		MOVH ZR, 76(RSP)			
  operators_test.go:56	0x10023da80		d2e63802		MOVD $3584865303386914816, R2		
  operators_test.go:56	0x10023da84		ca020000		EOR R2, R0, R0				
  operators_test.go:56	0x10023da88		f9001be0		MOVD R0, 48(RSP)			
  operators_test.go:56	0x10023da8c		ca020021		EOR R2, R1, R1				
  operators_test.go:56	0x10023da90		f90017e1		MOVD R1, 40(RSP)			
  operators_test.go:56	0x10023da94		97f79197		CALL runtime.deq64(SB)			
  operators_test.go:56	0x10023da98		390123e0		MOVB R0, 72(RSP)			
  operators_test.go:56	0x10023da9c		a94283e1		LDP 40(RSP), (R1, R0)			
  operators_test.go:56	0x10023daa0		97f79194		CALL runtime.deq64(SB)			
  operators_test.go:56	0x10023daa4		d2400002		EOR $1, R0, R2				
  operators_test.go:56	0x10023daa8		390127e2		MOVB R2, 73(RSP)			
  operators_test.go:56	0x10023daac		a94283e1		LDP 40(RSP), (R1, R0)			
  operators_test.go:56	0x10023dab0		97f791a4		CALL runtime.dlt64(SB)			
  operators_test.go:56	0x10023dab4		39012be0		MOVB R0, 74(RSP)			
  operators_test.go:56	0x10023dab8		a94283e1		LDP 40(RSP), (R1, R0)			
  operators_test.go:56	0x10023dabc		97f791b5		CALL runtime.dle64(SB)			
  operators_test.go:56	0x10023dac0		39012fe0		MOVB R0, 75(RSP)			
  operators_test.go:56	0x10023dac4		a94287e0		LDP 40(RSP), (R0, R1)			
  operators_test.go:56	0x10023dac8		97f7919e		CALL runtime.dlt64(SB)			
  operators_test.go:56	0x10023dacc		390133e0		MOVB R0, 76(RSP)			
  operators_test.go:56	0x10023dad0		a94287e0		LDP 40(RSP), (R0, R1)			
  operators_test.go:56	0x10023dad4		97f791af		CALL runtime.dle64(SB)			
  operators_test.go:56	0x10023dad8		390137e0		MOVB R0, 77(RSP)			
  operators_test.go:56	0x10023dadc		f85f83fd		MOVD -8(RSP), R29			
  operators_test.go:56	0x10023dae0		f84407fe		MOVD.P 64(RSP), R30			
  operators_test.go:56	0x10023dae4		d65f03c0		RET					
  operators_test.go:55	0x10023dae8		a90107e0		STP (R0, R1), 16(RSP)			
  operators_test.go:55	0x10023daec		aa1e03e3		MOVD R30, R3				
  operators_test.go:55	0x10023daf0		97f95244		CALL runtime.morestack_noctxt.abi0(SB)	
  operators_test.go:55	0x10023daf4		a94107e0		LDP 16(RSP), (R0, R1)			
  operators_test.go:55	0x10023daf8		17ffffda		JMP internal/bid_test.opCmp64(SB)	
  operators_test.go:55	0x10023dafc		00000000		?					

TEXT internal/bid_test.opCmp128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/operators_test.go
  operators_test.go:60	0x10023db00		f9400b90		MOVD 16(R28), R16			
  operators_test.go:60	0x10023db04		eb3063ff		CMP R16, RSP				
  operators_test.go:60	0x10023db08		540006a9		BLS 53(PC)				
  operators_test.go:60	0x10023db0c		f81b0ffe		MOVD.W R30, -80(RSP)			
  operators_test.go:60	0x10023db10		f81f83fd		MOVD R29, -8(RSP)			
  operators_test.go:60	0x10023db14		d10023fd		SUB $8, RSP, R29			
  operators_test.go:61	0x10023db18		f9003be2		MOVD R2, 112(RSP)			
  operators_test.go:61	0x10023db1c		f90033e0		MOVD R0, 96(RSP)			
  operators_test.go:60	0x10023db20		b9005bff		MOVW ZR, 88(RSP)			
  operators_test.go:60	0x10023db24		7900bbff		MOVH ZR, 92(RSP)			
  operators_test.go:61	0x10023db28		d2e60804		MOVD $3476778912330022912, R4		
  operators_test.go:61	0x10023db2c		ca040025		EOR R4, R1, R5				
  operators_test.go:61	0x10023db30		f90023e5		MOVD R5, 64(RSP)			
  operators_test.go:61	0x10023db34		ca040064		EOR R4, R3, R4				
  operators_test.go:61	0x10023db38		f9001fe4		MOVD R4, 56(RSP)			
  operators_test.go:61	0x10023db3c		aa0003e1		MOVD R0, R1				
  operators_test.go:61	0x10023db40		aa0203e3		MOVD R2, R3				
  operators_test.go:61	0x10023db44		aa0503e0		MOVD R5, R0				
  operators_test.go:61	0x10023db48		aa0403e2		MOVD R4, R2				
  operators_test.go:61	0x10023db4c		97f79095		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023db50		390163e0		MOVB R0, 88(RSP)			
  operators_test.go:61	0x10023db54		f94023e0		MOVD 64(RSP), R0			
  operators_test.go:61	0x10023db58		f94033e1		MOVD 96(RSP), R1			
  operators_test.go:61	0x10023db5c		f9401fe2		MOVD 56(RSP), R2			
  operators_test.go:61	0x10023db60		f9403be3		MOVD 112(RSP), R3			
  operators_test.go:61	0x10023db64		97f7908f		CALL runtime.deq128(SB)			
  operators_test.go:61	0x10023db68		d2400004		EOR $1, R0, R4				
  operators_test.go:61	0x10023db6c		390167e4		MOVB R4, 89(RSP)			
  operators_test.go:61	0x10023db70		f94023e0		MOVD 64(RSP), R0			
  operators_test.go:61	0x10023db74		f94033e1		MOVD 96(RSP), R1			
  operators_test.go:61	0x10023db78		f9401fe2		MOVD 56(RSP), R2			
  operators_test.go:61	0x10023db7c		f9403be3		MOVD 112(RSP), R3			
  operators_test.go:61	0x10023db80		97f790a0		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023db84		39016be0		MOVB R0, 90(RSP)			
  operators_test.go:61	0x10023db88		f94023e0		MOVD 64(RSP), R0			
  operators_test.go:61	0x10023db8c		f94033e1		MOVD 96(RSP), R1			
  operators_test.go:61	0x10023db90		f9401fe2		MOVD 56(RSP), R2			
  operators_test.go:61	0x10023db94		f9403be3		MOVD 112(RSP), R3			
  operators_test.go:61	0x10023db98		97f790b2		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023db9c		39016fe0		MOVB R0, 91(RSP)			
  operators_test.go:61	0x10023dba0		f9401fe0		MOVD 56(RSP), R0			
  operators_test.go:61	0x10023dba4		f9403be1		MOVD 112(RSP), R1			
  operators_test.go:61	0x10023dba8		f94023e2		MOVD 64(RSP), R2			
  operators_test.go:61	0x10023dbac		f94033e3		MOVD 96(RSP), R3			
  operators_test.go:61	0x10023dbb0		97f79094		CALL runtime.dlt128(SB)			
  operators_test.go:61	0x10023dbb4		390173e0		MOVB R0, 92(RSP)			
  operators_test.go:61	0x10023dbb8		f9401fe0		MOVD 56(RSP), R0			
  operators_test.go:61	0x10023dbbc		f9403be1		MOVD 112(RSP), R1			
  operators_test.go:61	0x10023dbc0		f94023e2		MOVD 64(RSP), R2			
  operators_test.go:61	0x10023dbc4		f94033e3		MOVD 96(RSP), R3			
  operators_test.go:61	0x10023dbc8		97f790a6		CALL runtime.dle128(SB)			
  operators_test.go:61	0x10023dbcc		390177e0		MOVB R0, 93(RSP)			
  operators_test.go:61	0x10023dbd0		f85f83fd		MOVD -8(RSP), R29			
  operators_test.go:61	0x10023dbd4		f84507fe		MOVD.P 80(RSP), R30			
  operators_test.go:61	0x10023dbd8		d65f03c0		RET					
  operators_test.go:60	0x10023dbdc		a90107e0		STP (R0, R1), 16(RSP)			
  operators_test.go:60	0x10023dbe0		a9020fe2		STP (R2, R3), 32(RSP)			
  operators_test.go:60	0x10023dbe4		aa1e03e3		MOVD R30, R3				
  operators_test.go:60	0x10023dbe8		97f95206		CALL runtime.morestack_noctxt.abi0(SB)	
  operators_test.go:60	0x10023dbec		a94107e0		LDP 16(RSP), (R0, R1)			
  operators_test.go:60	0x10023dbf0		a9420fe2		LDP 32(RSP), (R2, R3)			
  operators_test.go:60	0x10023dbf4		17ffffc3		JMP internal/bid_test.opCmp128(SB)	
  operators_test.go:60	0x10023dbf8		00000000		?					
  operators_test.go:60	0x10023dbfc		00000000		?					
