TEXT internal/bid_test.compiledQuant64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:22	0x100204b40		f9400b90		MOVD 16(R28), R16						
  compiler_round_test.go:22	0x100204b44		eb3063ff		CMP R16, RSP							
  compiler_round_test.go:22	0x100204b48		540001c9		BLS 14(PC)							
  compiler_round_test.go:22	0x100204b4c		f81d0ffe		MOVD.W R30, -48(RSP)						
  compiler_round_test.go:22	0x100204b50		f81f83fd		MOVD R29, -8(RSP)						
  compiler_round_test.go:22	0x100204b54		d10023fd		SUB $8, RSP, R29						
  decimal.go:164		0x100204b58		f0001804		ADRP 3158016(PC), R4						
  decimal.go:164		0x100204b5c		91278084		ADD $2528, R4, R4						
  decimal.go:164		0x100204b60		aa0203e3		MOVD R2, R3							
  decimal.go:164		0x100204b64		aa0103e2		MOVD R1, R2							
  decimal.go:164		0x100204b68		aa0003e1		MOVD R0, R1							
  decimal.go:164		0x100204b6c		aa0403e0		MOVD R4, R0							
  decimal.go:164		0x100204b70		94026cb8		CALL internal/decimal.QuantizeMode[go.shape.decimal64](SB)	
  compiler_round_test.go:22	0x100204b74		f85f83fd		MOVD -8(RSP), R29						
  compiler_round_test.go:22	0x100204b78		f84307fe		MOVD.P 48(RSP), R30						
  compiler_round_test.go:22	0x100204b7c		d65f03c0		RET								
  compiler_round_test.go:22	0x100204b80		a90087e0		STP (R0, R1), 8(RSP)						
  compiler_round_test.go:22	0x100204b84		390063e2		MOVB R2, 24(RSP)						
  compiler_round_test.go:22	0x100204b88		aa1e03e3		MOVD R30, R3							
  compiler_round_test.go:22	0x100204b8c		97fa361d		CALL runtime.morestack_noctxt.abi0(SB)				
  compiler_round_test.go:22	0x100204b90		a94087e0		LDP 8(RSP), (R0, R1)						
  compiler_round_test.go:22	0x100204b94		394063e2		MOVBU 24(RSP), R2						
  compiler_round_test.go:22	0x100204b98		17ffffea		JMP internal/bid_test.compiledQuant64(SB)			
  compiler_round_test.go:22	0x100204b9c		00000000		?								

TEXT internal/bid_test.compiledQuant128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:25	0x100204ba0		f9400b90		MOVD 16(R28), R16						
  compiler_round_test.go:25	0x100204ba4		eb3063ff		CMP R16, RSP							
  compiler_round_test.go:25	0x100204ba8		54000209		BLS 16(PC)							
  compiler_round_test.go:25	0x100204bac		f81c0ffe		MOVD.W R30, -64(RSP)						
  compiler_round_test.go:25	0x100204bb0		f81f83fd		MOVD R29, -8(RSP)						
  compiler_round_test.go:25	0x100204bb4		d10023fd		SUB $8, RSP, R29						
  decimal.go:164		0x100204bb8		f0001806		ADRP 3158016(PC), R6						
  decimal.go:164		0x100204bbc		912380c6		ADD $2272, R6, R6						
  decimal.go:164		0x100204bc0		aa0403e5		MOVD R4, R5							
  decimal.go:164		0x100204bc4		aa0303e4		MOVD R3, R4							
  decimal.go:164		0x100204bc8		aa0203e3		MOVD R2, R3							
  decimal.go:164		0x100204bcc		aa0103e2		MOVD R1, R2							
  decimal.go:164		0x100204bd0		aa0003e1		MOVD R0, R1							
  decimal.go:164		0x100204bd4		aa0603e0		MOVD R6, R0							
  decimal.go:164		0x100204bd8		94026c56		CALL internal/decimal.QuantizeMode[go.shape.decimal128](SB)	
  compiler_round_test.go:26	0x100204bdc		f85f83fd		MOVD -8(RSP), R29						
  compiler_round_test.go:26	0x100204be0		f84407fe		MOVD.P 64(RSP), R30						
  compiler_round_test.go:26	0x100204be4		d65f03c0		RET								
  compiler_round_test.go:25	0x100204be8		a90087e0		STP (R0, R1), 8(RSP)						
  compiler_round_test.go:25	0x100204bec		a9018fe2		STP (R2, R3), 24(RSP)						
  compiler_round_test.go:25	0x100204bf0		3900a3e4		MOVB R4, 40(RSP)						
  compiler_round_test.go:25	0x100204bf4		aa1e03e3		MOVD R30, R3							
  compiler_round_test.go:25	0x100204bf8		97fa3602		CALL runtime.morestack_noctxt.abi0(SB)				
  compiler_round_test.go:25	0x100204bfc		a94087e0		LDP 8(RSP), (R0, R1)						
  compiler_round_test.go:25	0x100204c00		a9418fe2		LDP 24(RSP), (R2, R3)						
  compiler_round_test.go:25	0x100204c04		3940a3e4		MOVBU 40(RSP), R4						
  compiler_round_test.go:25	0x100204c08		17ffffe6		JMP internal/bid_test.compiledQuant128(SB)			
  compiler_round_test.go:25	0x100204c0c		00000000		?								

TEXT internal/bid_test.compiledCent64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:30	0x100204c10		f9400b90		MOVD 16(R28), R16						
  compiler_round_test.go:30	0x100204c14		eb3063ff		CMP R16, RSP							
  compiler_round_test.go:30	0x100204c18		54000209		BLS 16(PC)							
  compiler_round_test.go:30	0x100204c1c		f81d0ffe		MOVD.W R30, -48(RSP)						
  compiler_round_test.go:30	0x100204c20		f81f83fd		MOVD R29, -8(RSP)						
  compiler_round_test.go:30	0x100204c24		d10023fd		SUB $8, RSP, R29						
  arithmetic.go:262		0x100204c28		f0001804		ADRP 3158016(PC), R4						
  arithmetic.go:262		0x100204c2c		91278084		ADD $2528, R4, R4						
  decimal.go:159		0x100204c30		d503201f		NOOP								
  arithmetic.go:262		0x100204c34		aa0003e1		MOVD R0, R1							
  arithmetic.go:262		0x100204c38		d2800022		MOVD $1, R2							
  arithmetic.go:262		0x100204c3c		f2e00802		MOVK $(64<<48), R2						
  arithmetic.go:262		0x100204c40		aa1f03e3		MOVD ZR, R3							
  arithmetic.go:262		0x100204c44		aa0403e0		MOVD R4, R0							
  arithmetic.go:262		0x100204c48		94026c82		CALL internal/decimal.QuantizeMode[go.shape.decimal64](SB)	
  compiler_round_test.go:30	0x100204c4c		f85f83fd		MOVD -8(RSP), R29						
  compiler_round_test.go:30	0x100204c50		f84307fe		MOVD.P 48(RSP), R30						
  compiler_round_test.go:30	0x100204c54		d65f03c0		RET								
  compiler_round_test.go:30	0x100204c58		f90007e0		MOVD R0, 8(RSP)							
  compiler_round_test.go:30	0x100204c5c		aa1e03e3		MOVD R30, R3							
  compiler_round_test.go:30	0x100204c60		97fa35e8		CALL runtime.morestack_noctxt.abi0(SB)				
  compiler_round_test.go:30	0x100204c64		f94007e0		MOVD 8(RSP), R0							
  compiler_round_test.go:30	0x100204c68		17ffffea		JMP internal/bid_test.compiledCent64(SB)			
  compiler_round_test.go:30	0x100204c6c		00000000		?								

TEXT internal/bid_test.compiledCent128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:33	0x100204c70		f9400b90		MOVD 16(R28), R16						
  compiler_round_test.go:33	0x100204c74		eb3063ff		CMP R16, RSP							
  compiler_round_test.go:33	0x100204c78		54000229		BLS 17(PC)							
  compiler_round_test.go:33	0x100204c7c		f81c0ffe		MOVD.W R30, -64(RSP)						
  compiler_round_test.go:33	0x100204c80		f81f83fd		MOVD R29, -8(RSP)						
  compiler_round_test.go:33	0x100204c84		d10023fd		SUB $8, RSP, R29						
  arithmetic.go:262		0x100204c88		f0001806		ADRP 3158016(PC), R6						
  arithmetic.go:262		0x100204c8c		912380c6		ADD $2272, R6, R6						
  decimal.go:159		0x100204c90		d503201f		NOOP								
  arithmetic.go:262		0x100204c94		aa0103e2		MOVD R1, R2							
  arithmetic.go:262		0x100204c98		b24003e3		ORR $1, ZR, R3							
  arithmetic.go:262		0x100204c9c		d2e00f84		MOVD $34902897112121344, R4					
  arithmetic.go:262		0x100204ca0		aa1f03e5		MOVD ZR, R5							
  arithmetic.go:262		0x100204ca4		aa0003e1		MOVD R0, R1							
  arithmetic.go:262		0x100204ca8		aa0603e0		MOVD R6, R0							
  arithmetic.go:262		0x100204cac		94026c21		CALL internal/decimal.QuantizeMode[go.shape.decimal128](SB)	
  compiler_round_test.go:33	0x100204cb0		f85f83fd		MOVD -8(RSP), R29						
  compiler_round_test.go:33	0x100204cb4		f84407fe		MOVD.P 64(RSP), R30						
  compiler_round_test.go:33	0x100204cb8		d65f03c0		RET								
  compiler_round_test.go:33	0x100204cbc		a90087e0		STP (R0, R1), 8(RSP)						
  compiler_round_test.go:33	0x100204cc0		aa1e03e3		MOVD R30, R3							
  compiler_round_test.go:33	0x100204cc4		97fa35cf		CALL runtime.morestack_noctxt.abi0(SB)				
  compiler_round_test.go:33	0x100204cc8		a94087e0		LDP 8(RSP), (R0, R1)						
  compiler_round_test.go:33	0x100204ccc		17ffffe9		JMP internal/bid_test.compiledCent128(SB)			

TEXT internal/bid_test.compiledAway64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:39	0x100204cd0		f9400b90		MOVD 16(R28), R16						
  compiler_round_test.go:39	0x100204cd4		eb3063ff		CMP R16, RSP							
  compiler_round_test.go:39	0x100204cd8		540001e9		BLS 15(PC)							
  compiler_round_test.go:39	0x100204cdc		f81d0ffe		MOVD.W R30, -48(RSP)						
  compiler_round_test.go:39	0x100204ce0		f81f83fd		MOVD R29, -8(RSP)						
  compiler_round_test.go:39	0x100204ce4		d10023fd		SUB $8, RSP, R29						
  decimal.go:164		0x100204ce8		f0001804		ADRP 3158016(PC), R4						
  decimal.go:164		0x100204cec		91268084		ADD $2464, R4, R4						
  decimal.go:164		0x100204cf0		aa0003e1		MOVD R0, R1							
  decimal.go:164		0x100204cf4		d2800022		MOVD $1, R2							
  decimal.go:164		0x100204cf8		f2e00802		MOVK $(64<<48), R2						
  decimal.go:164		0x100204cfc		b24003e3		ORR $1, ZR, R3							
  decimal.go:164		0x100204d00		aa0403e0		MOVD R4, R0							
  decimal.go:164		0x100204d04		94026c53		CALL internal/decimal.QuantizeMode[go.shape.decimal64](SB)	
  compiler_round_test.go:40	0x100204d08		f85f83fd		MOVD -8(RSP), R29						
  compiler_round_test.go:40	0x100204d0c		f84307fe		MOVD.P 48(RSP), R30						
  compiler_round_test.go:40	0x100204d10		d65f03c0		RET								
  compiler_round_test.go:39	0x100204d14		f90007e0		MOVD R0, 8(RSP)							
  compiler_round_test.go:39	0x100204d18		aa1e03e3		MOVD R30, R3							
  compiler_round_test.go:39	0x100204d1c		97fa35b9		CALL runtime.morestack_noctxt.abi0(SB)				
  compiler_round_test.go:39	0x100204d20		f94007e0		MOVD 8(RSP), R0							
  compiler_round_test.go:39	0x100204d24		17ffffeb		JMP internal/bid_test.compiledAway64(SB)			
  compiler_round_test.go:39	0x100204d28		00000000		?								
  compiler_round_test.go:39	0x100204d2c		00000000		?								

TEXT internal/bid_test.compiledAway128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:44	0x100204d30		f9400b90		MOVD 16(R28), R16						
  compiler_round_test.go:44	0x100204d34		eb3063ff		CMP R16, RSP							
  compiler_round_test.go:44	0x100204d38		54000209		BLS 16(PC)							
  compiler_round_test.go:44	0x100204d3c		f81c0ffe		MOVD.W R30, -64(RSP)						
  compiler_round_test.go:44	0x100204d40		f81f83fd		MOVD R29, -8(RSP)						
  compiler_round_test.go:44	0x100204d44		d10023fd		SUB $8, RSP, R29						
  decimal.go:164		0x100204d48		f0001806		ADRP 3158016(PC), R6						
  decimal.go:164		0x100204d4c		912580c6		ADD $2400, R6, R6						
  decimal.go:164		0x100204d50		aa0103e2		MOVD R1, R2							
  decimal.go:164		0x100204d54		b24003e3		ORR $1, ZR, R3							
  decimal.go:164		0x100204d58		d2e00f84		MOVD $34902897112121344, R4					
  decimal.go:164		0x100204d5c		b24003e5		ORR $1, ZR, R5							
  decimal.go:164		0x100204d60		aa0003e1		MOVD R0, R1							
  decimal.go:164		0x100204d64		aa0603e0		MOVD R6, R0							
  decimal.go:164		0x100204d68		94026bf2		CALL internal/decimal.QuantizeMode[go.shape.decimal128](SB)	
  compiler_round_test.go:45	0x100204d6c		f85f83fd		MOVD -8(RSP), R29						
  compiler_round_test.go:45	0x100204d70		f84407fe		MOVD.P 64(RSP), R30						
  compiler_round_test.go:45	0x100204d74		d65f03c0		RET								
  compiler_round_test.go:44	0x100204d78		a90087e0		STP (R0, R1), 8(RSP)						
  compiler_round_test.go:44	0x100204d7c		aa1e03e3		MOVD R30, R3							
  compiler_round_test.go:44	0x100204d80		97fa35a0		CALL runtime.morestack_noctxt.abi0(SB)				
  compiler_round_test.go:44	0x100204d84		a94087e0		LDP 8(RSP), (R0, R1)						
  compiler_round_test.go:44	0x100204d88		17ffffea		JMP internal/bid_test.compiledAway128(SB)			
  compiler_round_test.go:44	0x100204d8c		00000000		?								

TEXT internal/bid_test.compiledIntegral64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:49	0x100204d90		f9400b90		MOVD 16(R28), R16					
  compiler_round_test.go:49	0x100204d94		eb3063ff		CMP R16, RSP						
  compiler_round_test.go:49	0x100204d98		54000689		BLS 52(PC)						
  compiler_round_test.go:49	0x100204d9c		f81b0ffe		MOVD.W R30, -80(RSP)					
  compiler_round_test.go:49	0x100204da0		f81f83fd		MOVD R29, -8(RSP)					
  compiler_round_test.go:49	0x100204da4		d10023fd		SUB $8, RSP, R29					
  compiler_round_test.go:50	0x100204da8		f90043e0		MOVD R0, 128(RSP)					
  compiler_round_test.go:49	0x100204dac		910163e3		ADD $88, RSP, R3					
  compiler_round_test.go:49	0x100204db0		a9007c7f		STP (ZR, ZR), (R3)					
  compiler_round_test.go:49	0x100204db4		a9017c7f		STP (ZR, ZR), 16(R3)					
  compiler_round_test.go:49	0x100204db8		f900107f		MOVD ZR, 32(R3)						
  arithmetic.go:208		0x100204dbc		f0001803		ADRP 3158016(PC), R3					
  arithmetic.go:208		0x100204dc0		91248063		ADD $2336, R3, R3					
  decimal.go:117		0x100204dc4		d503201f		NOOP							
  arithmetic.go:208		0x100204dc8		aa0003e1		MOVD R0, R1						
  arithmetic.go:208		0x100204dcc		aa1f03e2		MOVD ZR, R2						
  arithmetic.go:208		0x100204dd0		aa0303e0		MOVD R3, R0						
  arithmetic.go:208		0x100204dd4		94026c03		CALL internal/decimal.integral[go.shape.decimal64](SB)	
  arithmetic.go:208		0x100204dd8		f90023e0		MOVD R0, 64(RSP)					
  arithmetic.go:205		0x100204ddc		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:205		0x100204de0		91248000		ADD $2336, R0, R0					
  decimal.go:114		0x100204de4		d503201f		NOOP							
  arithmetic.go:205		0x100204de8		f94043e1		MOVD 128(RSP), R1					
  arithmetic.go:205		0x100204dec		b24003e2		ORR $1, ZR, R2						
  arithmetic.go:205		0x100204df0		94026bfc		CALL internal/decimal.integral[go.shape.decimal64](SB)	
  arithmetic.go:205		0x100204df4		f9001fe0		MOVD R0, 56(RSP)					
  arithmetic.go:196		0x100204df8		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:196		0x100204dfc		91248000		ADD $2336, R0, R0					
  decimal.go:105		0x100204e00		d503201f		NOOP							
  arithmetic.go:196		0x100204e04		f94043e1		MOVD 128(RSP), R1					
  arithmetic.go:196		0x100204e08		b27f03e2		ORR $2, ZR, R2						
  arithmetic.go:196		0x100204e0c		94026bf5		CALL internal/decimal.integral[go.shape.decimal64](SB)	
  arithmetic.go:196		0x100204e10		f9001be0		MOVD R0, 48(RSP)					
  arithmetic.go:202		0x100204e14		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:202		0x100204e18		91248000		ADD $2336, R0, R0					
  decimal.go:111		0x100204e1c		d503201f		NOOP							
  arithmetic.go:202		0x100204e20		f94043e1		MOVD 128(RSP), R1					
  arithmetic.go:202		0x100204e24		b24007e2		ORR $3, ZR, R2						
  arithmetic.go:202		0x100204e28		94026bee		CALL internal/decimal.integral[go.shape.decimal64](SB)	
  arithmetic.go:202		0x100204e2c		f90017e0		MOVD R0, 40(RSP)					
  arithmetic.go:199		0x100204e30		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:199		0x100204e34		91248000		ADD $2336, R0, R0					
  decimal.go:108		0x100204e38		d503201f		NOOP							
  arithmetic.go:199		0x100204e3c		f94043e1		MOVD 128(RSP), R1					
  arithmetic.go:199		0x100204e40		b27e03e2		ORR $4, ZR, R2						
  arithmetic.go:199		0x100204e44		94026be7		CALL internal/decimal.integral[go.shape.decimal64](SB)	
  compiler_round_test.go:50	0x100204e48		a9438fe4		LDP 56(RSP), (R4, R3)					
  compiler_round_test.go:50	0x100204e4c		a90593e3		STP (R3, R4), 88(RSP)					
  compiler_round_test.go:50	0x100204e50		a9428fe4		LDP 40(RSP), (R4, R3)					
  compiler_round_test.go:50	0x100204e54		a90693e3		STP (R3, R4), 104(RSP)					
  compiler_round_test.go:50	0x100204e58		f9003fe0		MOVD R0, 120(RSP)					
  compiler_round_test.go:50	0x100204e5c		f85f83fd		MOVD -8(RSP), R29					
  compiler_round_test.go:50	0x100204e60		f84507fe		MOVD.P 80(RSP), R30					
  compiler_round_test.go:50	0x100204e64		d65f03c0		RET							
  compiler_round_test.go:49	0x100204e68		f9001be0		MOVD R0, 48(RSP)					
  compiler_round_test.go:49	0x100204e6c		aa1e03e3		MOVD R30, R3						
  compiler_round_test.go:49	0x100204e70		97fa3564		CALL runtime.morestack_noctxt.abi0(SB)			
  compiler_round_test.go:49	0x100204e74		f9401be0		MOVD 48(RSP), R0					
  compiler_round_test.go:49	0x100204e78		17ffffc6		JMP internal/bid_test.compiledIntegral64(SB)		
  compiler_round_test.go:49	0x100204e7c		00000000		?							

TEXT internal/bid_test.compiledIntegral128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:54	0x100204e80		f9400b90		MOVD 16(R28), R16					
  compiler_round_test.go:54	0x100204e84		eb3063ff		CMP R16, RSP						
  compiler_round_test.go:54	0x100204e88		54000869		BLS 67(PC)						
  compiler_round_test.go:54	0x100204e8c		f8190ffe		MOVD.W R30, -112(RSP)					
  compiler_round_test.go:54	0x100204e90		f81f83fd		MOVD R29, -8(RSP)					
  compiler_round_test.go:54	0x100204e94		d10023fd		SUB $8, RSP, R29					
  compiler_round_test.go:55	0x100204e98		a90c87e0		STP (R0, R1), 200(RSP)					
  compiler_round_test.go:54	0x100204e9c		9101e3e4		ADD $120, RSP, R4					
  compiler_round_test.go:54	0x100204ea0		a9007c9f		STP (ZR, ZR), (R4)					
  compiler_round_test.go:54	0x100204ea4		a9017c9f		STP (ZR, ZR), 16(R4)					
  compiler_round_test.go:54	0x100204ea8		a9027c9f		STP (ZR, ZR), 32(R4)					
  compiler_round_test.go:54	0x100204eac		a9037c9f		STP (ZR, ZR), 48(R4)					
  compiler_round_test.go:54	0x100204eb0		a9047c9f		STP (ZR, ZR), 64(R4)					
  arithmetic.go:208		0x100204eb4		f0001804		ADRP 3158016(PC), R4					
  arithmetic.go:208		0x100204eb8		91228084		ADD $2208, R4, R4					
  decimal.go:117		0x100204ebc		d503201f		NOOP							
  arithmetic.go:208		0x100204ec0		aa0103e2		MOVD R1, R2						
  arithmetic.go:208		0x100204ec4		aa1f03e3		MOVD ZR, R3						
  arithmetic.go:208		0x100204ec8		aa0003e1		MOVD R0, R1						
  arithmetic.go:208		0x100204ecc		aa0403e0		MOVD R4, R0						
  arithmetic.go:208		0x100204ed0		94026b7c		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  arithmetic.go:208		0x100204ed4		f90023e0		MOVD R0, 64(RSP)					
  arithmetic.go:208		0x100204ed8		f90033e1		MOVD R1, 96(RSP)					
  arithmetic.go:205		0x100204edc		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:205		0x100204ee0		91228000		ADD $2208, R0, R0					
  decimal.go:114		0x100204ee4		d503201f		NOOP							
  arithmetic.go:205		0x100204ee8		a94c8be1		LDP 200(RSP), (R1, R2)					
  arithmetic.go:205		0x100204eec		b24003e3		ORR $1, ZR, R3						
  arithmetic.go:205		0x100204ef0		94026b74		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  arithmetic.go:205		0x100204ef4		f9001fe0		MOVD R0, 56(RSP)					
  arithmetic.go:205		0x100204ef8		f9002fe1		MOVD R1, 88(RSP)					
  arithmetic.go:196		0x100204efc		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:196		0x100204f00		91228000		ADD $2208, R0, R0					
  decimal.go:105		0x100204f04		d503201f		NOOP							
  arithmetic.go:196		0x100204f08		a94c8be1		LDP 200(RSP), (R1, R2)					
  arithmetic.go:196		0x100204f0c		b27f03e3		ORR $2, ZR, R3						
  arithmetic.go:196		0x100204f10		94026b6c		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  arithmetic.go:196		0x100204f14		f9001be0		MOVD R0, 48(RSP)					
  arithmetic.go:196		0x100204f18		f9002be1		MOVD R1, 80(RSP)					
  arithmetic.go:202		0x100204f1c		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:202		0x100204f20		91228000		ADD $2208, R0, R0					
  decimal.go:111		0x100204f24		d503201f		NOOP							
  arithmetic.go:202		0x100204f28		a94c8be1		LDP 200(RSP), (R1, R2)					
  arithmetic.go:202		0x100204f2c		b24007e3		ORR $3, ZR, R3						
  arithmetic.go:202		0x100204f30		94026b64		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  arithmetic.go:202		0x100204f34		f90017e0		MOVD R0, 40(RSP)					
  arithmetic.go:202		0x100204f38		f90027e1		MOVD R1, 72(RSP)					
  arithmetic.go:199		0x100204f3c		f0001800		ADRP 3158016(PC), R0					
  arithmetic.go:199		0x100204f40		91228000		ADD $2208, R0, R0					
  decimal.go:108		0x100204f44		d503201f		NOOP							
  arithmetic.go:199		0x100204f48		a94c8be1		LDP 200(RSP), (R1, R2)					
  arithmetic.go:199		0x100204f4c		b27e03e3		ORR $4, ZR, R3						
  arithmetic.go:199		0x100204f50		94026b5c		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  compiler_round_test.go:55	0x100204f54		f94023e4		MOVD 64(RSP), R4					
  compiler_round_test.go:55	0x100204f58		f94033e5		MOVD 96(RSP), R5					
  compiler_round_test.go:55	0x100204f5c		a90797e4		STP (R4, R5), 120(RSP)					
  compiler_round_test.go:55	0x100204f60		f9401fe4		MOVD 56(RSP), R4					
  compiler_round_test.go:55	0x100204f64		f9402fe5		MOVD 88(RSP), R5					
  compiler_round_test.go:55	0x100204f68		a90897e4		STP (R4, R5), 136(RSP)					
  compiler_round_test.go:55	0x100204f6c		f9401be4		MOVD 48(RSP), R4					
  compiler_round_test.go:55	0x100204f70		f9402be5		MOVD 80(RSP), R5					
  compiler_round_test.go:55	0x100204f74		a90997e4		STP (R4, R5), 152(RSP)					
  compiler_round_test.go:55	0x100204f78		f94017e4		MOVD 40(RSP), R4					
  compiler_round_test.go:55	0x100204f7c		f94027e5		MOVD 72(RSP), R5					
  compiler_round_test.go:55	0x100204f80		a90a97e4		STP (R4, R5), 168(RSP)					
  compiler_round_test.go:55	0x100204f84		a90b87e0		STP (R0, R1), 184(RSP)					
  compiler_round_test.go:55	0x100204f88		f85f83fd		MOVD -8(RSP), R29					
  compiler_round_test.go:55	0x100204f8c		f84707fe		MOVD.P 112(RSP), R30					
  compiler_round_test.go:55	0x100204f90		d65f03c0		RET							
  compiler_round_test.go:54	0x100204f94		a90587e0		STP (R0, R1), 88(RSP)					
  compiler_round_test.go:54	0x100204f98		aa1e03e3		MOVD R30, R3						
  compiler_round_test.go:54	0x100204f9c		97fa3519		CALL runtime.morestack_noctxt.abi0(SB)			
  compiler_round_test.go:54	0x100204fa0		a94587e0		LDP 88(RSP), (R0, R1)					
  compiler_round_test.go:54	0x100204fa4		17ffffb7		JMP internal/bid_test.compiledIntegral128(SB)		
  compiler_round_test.go:54	0x100204fa8		00000000		?							
  compiler_round_test.go:54	0x100204fac		00000000		?							

TEXT internal/bid_test.compiledTrunc128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:200	0x1002054d0		f9400b90		MOVD 16(R28), R16					
  compiler_round_test.go:200	0x1002054d4		eb3063ff		CMP R16, RSP						
  compiler_round_test.go:200	0x1002054d8		540001e9		BLS 15(PC)						
  compiler_round_test.go:200	0x1002054dc		f81d0ffe		MOVD.W R30, -48(RSP)					
  compiler_round_test.go:200	0x1002054e0		f81f83fd		MOVD R29, -8(RSP)					
  compiler_round_test.go:200	0x1002054e4		d10023fd		SUB $8, RSP, R29					
  arithmetic.go:196		0x1002054e8		d0001804		ADRP 3153920(PC), R4					
  arithmetic.go:196		0x1002054ec		91228084		ADD $2208, R4, R4					
  decimal.go:105		0x1002054f0		d503201f		NOOP							
  arithmetic.go:196		0x1002054f4		aa0103e2		MOVD R1, R2						
  arithmetic.go:196		0x1002054f8		b27f03e3		ORR $2, ZR, R3						
  arithmetic.go:196		0x1002054fc		aa0003e1		MOVD R0, R1						
  arithmetic.go:196		0x100205500		aa0403e0		MOVD R4, R0						
  arithmetic.go:196		0x100205504		940269ef		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  compiler_round_test.go:200	0x100205508		f85f83fd		MOVD -8(RSP), R29					
  compiler_round_test.go:200	0x10020550c		f84307fe		MOVD.P 48(RSP), R30					
  compiler_round_test.go:200	0x100205510		d65f03c0		RET							
  compiler_round_test.go:200	0x100205514		a90087e0		STP (R0, R1), 8(RSP)					
  compiler_round_test.go:200	0x100205518		aa1e03e3		MOVD R30, R3						
  compiler_round_test.go:200	0x10020551c		97fa33b9		CALL runtime.morestack_noctxt.abi0(SB)			
  compiler_round_test.go:200	0x100205520		a94087e0		LDP 8(RSP), (R0, R1)					
  compiler_round_test.go:200	0x100205524		17ffffeb		JMP internal/bid_test.compiledTrunc128(SB)		
  compiler_round_test.go:200	0x100205528		00000000		?							
  compiler_round_test.go:200	0x10020552c		00000000		?							

TEXT internal/bid_test.compiledEven128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:203	0x100205530		f9400b90		MOVD 16(R28), R16					
  compiler_round_test.go:203	0x100205534		eb3063ff		CMP R16, RSP						
  compiler_round_test.go:203	0x100205538		540001e9		BLS 15(PC)						
  compiler_round_test.go:203	0x10020553c		f81d0ffe		MOVD.W R30, -48(RSP)					
  compiler_round_test.go:203	0x100205540		f81f83fd		MOVD R29, -8(RSP)					
  compiler_round_test.go:203	0x100205544		d10023fd		SUB $8, RSP, R29					
  arithmetic.go:208		0x100205548		d0001804		ADRP 3153920(PC), R4					
  arithmetic.go:208		0x10020554c		91228084		ADD $2208, R4, R4					
  decimal.go:117		0x100205550		d503201f		NOOP							
  arithmetic.go:208		0x100205554		aa0103e2		MOVD R1, R2						
  arithmetic.go:208		0x100205558		aa1f03e3		MOVD ZR, R3						
  arithmetic.go:208		0x10020555c		aa0003e1		MOVD R0, R1						
  arithmetic.go:208		0x100205560		aa0403e0		MOVD R4, R0						
  arithmetic.go:208		0x100205564		940269d7		CALL internal/decimal.integral[go.shape.decimal128](SB)	
  compiler_round_test.go:203	0x100205568		f85f83fd		MOVD -8(RSP), R29					
  compiler_round_test.go:203	0x10020556c		f84307fe		MOVD.P 48(RSP), R30					
  compiler_round_test.go:203	0x100205570		d65f03c0		RET							
  compiler_round_test.go:203	0x100205574		a90087e0		STP (R0, R1), 8(RSP)					
  compiler_round_test.go:203	0x100205578		aa1e03e3		MOVD R30, R3						
  compiler_round_test.go:203	0x10020557c		97fa33a1		CALL runtime.morestack_noctxt.abi0(SB)			
  compiler_round_test.go:203	0x100205580		a94087e0		LDP 8(RSP), (R0, R1)					
  compiler_round_test.go:203	0x100205584		17ffffeb		JMP internal/bid_test.compiledEven128(SB)		
  compiler_round_test.go:203	0x100205588		00000000		?							
  compiler_round_test.go:203	0x10020558c		00000000		?							
