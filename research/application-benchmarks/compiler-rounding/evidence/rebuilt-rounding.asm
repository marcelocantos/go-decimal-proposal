TEXT internal/bid_test.compiledQuant64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:22	0x100204da0		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:22	0x100204da4		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:22	0x100204da8		54000889		BLS 68(PC)					
  compiler_round_test.go:22	0x100204dac		f81c0ffe		MOVD.W R30, -64(RSP)				
  compiler_round_test.go:22	0x100204db0		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:22	0x100204db4		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:22	0x100204db8		92430403		AND $6917529027641081856, R0, R3		
  decimal.go:164		0x100204dbc		d503201f		NOOP						
  arithmetic.go:268		0x100204dc0		d2e63804		MOVD $3584865303386914816, R4			
  arithmetic.go:268		0x100204dc4		ca040005		EOR R4, R0, R5					
  arithmetic.go:268		0x100204dc8		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:268		0x100204dcc		eb06007f		CMP R6, R3					
  arithmetic.go:268		0x100204dd0		540006c0		BEQ 54(PC)					
  arithmetic.go:268		0x100204dd4		92430423		AND $6917529027641081856, R1, R3		
  arithmetic.go:268		0x100204dd8		eb06007f		CMP R6, R3					
  arithmetic.go:268		0x100204ddc		54000660		BEQ 51(PC)					
  arithmetic.go:268		0x100204de0		ca040023		EOR R4, R1, R3					
  arithmetic.go:268		0x100204de4		d375f8a6		UBFX $53, R5, $10, R6				
  arithmetic.go:268		0x100204de8		d375f867		UBFX $53, R3, $10, R7				
  arithmetic.go:268		0x100204dec		eb0600ff		CMP R6, R7					
  arithmetic.go:268		0x100204df0		540005e0		BEQ 47(PC)					
  arithmetic.go:268		0x100204df4		cb0600e6		SUB R6, R7, R6					
  arithmetic.go:268		0x100204df8		d10004c6		SUB $1, R6, R6					
  arithmetic.go:268		0x100204dfc		f10048df		CMP $18, R6					
  arithmetic.go:268		0x100204e00		54000548		BHI 42(PC)					
  arithmetic.go:268		0x100204e04		d3401c41		UBFX $0, R2, $8, R1				
  arithmetic.go:268		0x100204e08		9240d0a2		AND $9007199254740991, R5, R2			
  arithmetic.go:268		0x100204e0c		d0000647		ADRP 827392(PC), R7				
  arithmetic.go:268		0x100204e10		912688e7		ADD $2466, R7, R7				
  arithmetic.go:268		0x100204e14		f86678e6		MOVD (R7)(R6<<3), R6				
  arithmetic.go:268		0x100204e18		9ac60847		UDIV R6, R2, R7					
  arithmetic.go:268		0x100204e1c		9b0788c2		MSUB R7, R2, R6, R2				
  arithmetic.go:268		0x100204e20		d37ffca8		LSR $63, R5, R8					
  arithmetic.go:268		0x100204e24		d2400108		EOR $1, R8, R8					
  arithmetic.go:268		0x100204e28		924b2463		AND $9214364837600034816, R3, R3		
  arithmetic.go:268		0x100204e2c		924100a9		AND $-9223372036854775808, R5, R9		
  arithmetic.go:268		0x100204e30		aa090063		ORR R9, R3, R3					
  arithmetic.go:268		0x100204e34		ca040063		EOR R4, R3, R3					
  arithmetic.go:268		0x100204e38		eb46045f		CMP R6>>1, R2					
  arithmetic.go:268		0x100204e3c		9a9f97e4		CSET HI, R4					
  arithmetic.go:268		0x100204e40		9a9f17e6		CSET EQ, R6					
  arithmetic.go:268		0x100204e44		aa0400c9		ORR R4, R6, R9					
  arithmetic.go:268		0x100204e48		d3401d29		UBFX $0, R9, $8, R9				
  arithmetic.go:268		0x100204e4c		f100005f		CMP $0, R2					
  arithmetic.go:268		0x100204e50		9a9f07e2		CSET NE, R2					
  arithmetic.go:268		0x100204e54		8a020108		AND R2, R8, R8					
  arithmetic.go:268		0x100204e58		8a45fc42		AND R5>>63, R2, R2				
  arithmetic.go:268		0x100204e5c		d3401d05		UBFX $0, R8, $8, R5				
  arithmetic.go:268		0x100204e60		d3401c42		UBFX $0, R2, $8, R2				
  arithmetic.go:268		0x100204e64		7100043f		CMPW $1, R1					
  arithmetic.go:268		0x100204e68		f24000ff		TST $1, R7					
  arithmetic.go:268		0x100204e6c		9a9f07e8		CSET NE, R8					
  arithmetic.go:268		0x100204e70		8a0800c6		AND R8, R6, R6					
  arithmetic.go:268		0x100204e74		aa0400c4		ORR R4, R6, R4					
  arithmetic.go:268		0x100204e78		d3401c84		UBFX $0, R4, $8, R4				
  arithmetic.go:268		0x100204e7c		7100043f		CMPW $1, R1					
  arithmetic.go:268		0x100204e80		9a840124		CSEL EQ, R9, R4, R4				
  arithmetic.go:268		0x100204e84		7100083f		CMPW $2, R1					
  arithmetic.go:268		0x100204e88		9a9f1084		CSEL NE, R4, ZR, R4				
  arithmetic.go:268		0x100204e8c		71000c3f		CMPW $3, R1					
  arithmetic.go:268		0x100204e90		9a8400a4		CSEL EQ, R5, R4, R4				
  arithmetic.go:268		0x100204e94		7100103f		CMPW $4, R1					
  arithmetic.go:268		0x100204e98		9a840041		CSEL EQ, R2, R4, R1				
  arithmetic.go:268		0x100204e9c		8b0100e1		ADD R1, R7, R1					
  arithmetic.go:268		0x100204ea0		aa030020		ORR R3, R1, R0					
  arithmetic.go:268		0x100204ea4		14000002		JMP 2(PC)					
  arithmetic.go:268		0x100204ea8		97faf016		CALL internal/decimal.quantize64(SB)		
  compiler_round_test.go:22	0x100204eac		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:22	0x100204eb0		f84407fe		MOVD.P 64(RSP), R30				
  compiler_round_test.go:22	0x100204eb4		d65f03c0		RET						
  compiler_round_test.go:22	0x100204eb8		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:22	0x100204ebc		390063e2		MOVB R2, 24(RSP)				
  compiler_round_test.go:22	0x100204ec0		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:22	0x100204ec4		97fa354f		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:22	0x100204ec8		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:22	0x100204ecc		394063e2		MOVBU 24(RSP), R2				
  compiler_round_test.go:22	0x100204ed0		17ffffb4		JMP internal/bid_test.compiledQuant64(SB)	
  compiler_round_test.go:22	0x100204ed4		00000000		?						
  compiler_round_test.go:22	0x100204ed8		00000000		?						
  compiler_round_test.go:22	0x100204edc		00000000		?						

TEXT internal/bid_test.compiledQuant128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:25	0x100204ee0		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:25	0x100204ee4		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:25	0x100204ee8		54000869		BLS 67(PC)					
  compiler_round_test.go:25	0x100204eec		f81b0ffe		MOVD.W R30, -80(RSP)				
  compiler_round_test.go:25	0x100204ef0		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:25	0x100204ef4		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:26	0x100204ef8		92430425		AND $6917529027641081856, R1, R5		
  decimal.go:164		0x100204efc		d503201f		NOOP						
  arithmetic.go:270		0x100204f00		d2e60806		MOVD $3476778912330022912, R6			
  arithmetic.go:270		0x100204f04		ca060027		EOR R6, R1, R7					
  arithmetic.go:270		0x100204f08		d2e80008		MOVD $4611686018427387904, R8			
  arithmetic.go:270		0x100204f0c		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x100204f10		540006a0		BEQ 53(PC)					
  arithmetic.go:270		0x100204f14		f240c0ff		TST $562949953421311, R7			
  arithmetic.go:270		0x100204f18		54000661		BNE 51(PC)					
  arithmetic.go:270		0x100204f1c		92430465		AND $6917529027641081856, R3, R5		
  arithmetic.go:270		0x100204f20		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x100204f24		54000600		BEQ 48(PC)					
  arithmetic.go:270		0x100204f28		ca060065		EOR R6, R3, R5					
  arithmetic.go:270		0x100204f2c		d371f8e8		UBFX $49, R7, $14, R8				
  arithmetic.go:270		0x100204f30		d371f8a9		UBFX $49, R5, $14, R9				
  arithmetic.go:270		0x100204f34		eb08013f		CMP R8, R9					
  arithmetic.go:270		0x100204f38		54000580		BEQ 44(PC)					
  arithmetic.go:270		0x100204f3c		cb080128		SUB R8, R9, R8					
  arithmetic.go:270		0x100204f40		d1000508		SUB $1, R8, R8					
  arithmetic.go:270		0x100204f44		f100491f		CMP $18, R8					
  arithmetic.go:270		0x100204f48		540004e8		BHI 39(PC)					
  arithmetic.go:270		0x100204f4c		d3401c82		UBFX $0, R4, $8, R2				
  arithmetic.go:270		0x100204f50		d0000643		ADRP 827392(PC), R3				
  arithmetic.go:270		0x100204f54		91268863		ADD $2466, R3, R3				
  arithmetic.go:270		0x100204f58		f8687863		MOVD (R3)(R8<<3), R3				
  arithmetic.go:270		0x100204f5c		9ac30804		UDIV R3, R0, R4					
  arithmetic.go:270		0x100204f60		9b048068		MSUB R4, R0, R3, R8				
  arithmetic.go:270		0x100204f64		d37ffce9		LSR $63, R7, R9					
  arithmetic.go:270		0x100204f68		d2400129		EOR $1, R9, R9					
  arithmetic.go:270		0x100204f6c		924f34a5		AND $9222809086901354496, R5, R5		
  arithmetic.go:270		0x100204f70		924100ea		AND $-9223372036854775808, R7, R10		
  arithmetic.go:270		0x100204f74		aa050145		ORR R5, R10, R5					
  arithmetic.go:270		0x100204f78		ca0600a1		EOR R6, R5, R1					
  arithmetic.go:270		0x100204f7c		eb43051f		CMP R3>>1, R8					
  arithmetic.go:270		0x100204f80		9a9f97e3		CSET HI, R3					
  arithmetic.go:270		0x100204f84		9a9f17e5		CSET EQ, R5					
  arithmetic.go:270		0x100204f88		aa0300a6		ORR R3, R5, R6					
  arithmetic.go:270		0x100204f8c		d3401cc6		UBFX $0, R6, $8, R6				
  arithmetic.go:270		0x100204f90		f100011f		CMP $0, R8					
  arithmetic.go:270		0x100204f94		9a9f07e8		CSET NE, R8					
  arithmetic.go:270		0x100204f98		8a080129		AND R8, R9, R9					
  arithmetic.go:270		0x100204f9c		8a47fd07		AND R7>>63, R8, R7				
  arithmetic.go:270		0x100204fa0		d3401d28		UBFX $0, R9, $8, R8				
  arithmetic.go:270		0x100204fa4		d3401ce7		UBFX $0, R7, $8, R7				
  arithmetic.go:270		0x100204fa8		f240009f		TST $1, R4					
  arithmetic.go:270		0x100204fac		9a9f07e9		CSET NE, R9					
  arithmetic.go:270		0x100204fb0		8a0900a5		AND R9, R5, R5					
  arithmetic.go:270		0x100204fb4		aa0300a3		ORR R3, R5, R3					
  arithmetic.go:270		0x100204fb8		d3401c63		UBFX $0, R3, $8, R3				
  arithmetic.go:270		0x100204fbc		7100045f		CMPW $1, R2					
  arithmetic.go:270		0x100204fc0		9a8300c3		CSEL EQ, R6, R3, R3				
  arithmetic.go:270		0x100204fc4		7100085f		CMPW $2, R2					
  arithmetic.go:270		0x100204fc8		9a9f1063		CSEL NE, R3, ZR, R3				
  arithmetic.go:270		0x100204fcc		71000c5f		CMPW $3, R2					
  arithmetic.go:270		0x100204fd0		9a830103		CSEL EQ, R8, R3, R3				
  arithmetic.go:270		0x100204fd4		7100105f		CMPW $4, R2					
  arithmetic.go:270		0x100204fd8		9a8300e2		CSEL EQ, R7, R3, R2				
  arithmetic.go:270		0x100204fdc		8b020080		ADD R2, R4, R0					
  arithmetic.go:270		0x100204fe0		14000002		JMP 2(PC)					
  arithmetic.go:270		0x100204fe4		97faeffb		CALL internal/decimal.quantize128(SB)		
  compiler_round_test.go:26	0x100204fe8		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:26	0x100204fec		f84507fe		MOVD.P 80(RSP), R30				
  compiler_round_test.go:26	0x100204ff0		d65f03c0		RET						
  compiler_round_test.go:25	0x100204ff4		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:25	0x100204ff8		a9018fe2		STP (R2, R3), 24(RSP)				
  compiler_round_test.go:25	0x100204ffc		3900a3e4		MOVB R4, 40(RSP)				
  compiler_round_test.go:25	0x100205000		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:25	0x100205004		97fa34ff		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:25	0x100205008		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:25	0x10020500c		a9418fe2		LDP 24(RSP), (R2, R3)				
  compiler_round_test.go:25	0x100205010		3940a3e4		MOVBU 40(RSP), R4				
  compiler_round_test.go:25	0x100205014		17ffffb3		JMP internal/bid_test.compiledQuant128(SB)	
  compiler_round_test.go:25	0x100205018		00000000		?						
  compiler_round_test.go:25	0x10020501c		00000000		?						

TEXT internal/bid_test.compiledCent64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:30	0x100205020		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:30	0x100205024		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:30	0x100205028		540005e9		BLS 47(PC)					
  compiler_round_test.go:30	0x10020502c		f81c0ffe		MOVD.W R30, -64(RSP)				
  compiler_round_test.go:30	0x100205030		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:30	0x100205034		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:30	0x100205038		92430403		AND $6917529027641081856, R0, R3		
  decimal.go:159		0x10020503c		d503201f		NOOP						
  arithmetic.go:262		0x100205040		d503201f		NOOP						
  arithmetic.go:268		0x100205044		d2e63804		MOVD $3584865303386914816, R4			
  arithmetic.go:268		0x100205048		ca040005		EOR R4, R0, R5					
  arithmetic.go:268		0x10020504c		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:268		0x100205050		eb06007f		CMP R6, R3					
  arithmetic.go:268		0x100205054		540003a0		BEQ 29(PC)					
  arithmetic.go:268		0x100205058		d375f8a3		UBFX $53, R5, $10, R3				
  arithmetic.go:268		0x10020505c		f106307f		CMP $396, R3					
  arithmetic.go:268		0x100205060		540003c0		BEQ 30(PC)					
  arithmetic.go:268		0x100205064		d2803166		MOVD $395, R6					
  arithmetic.go:268		0x100205068		cb0300c3		SUB R3, R6, R3					
  arithmetic.go:268		0x10020506c		f100487f		CMP $18, R3					
  arithmetic.go:268		0x100205070		540002c8		BHI 22(PC)					
  arithmetic.go:268		0x100205074		9240d0a1		AND $9007199254740991, R5, R1			
  arithmetic.go:268		0x100205078		924100a2		AND $-9223372036854775808, R5, R2		
  arithmetic.go:268		0x10020507c		b0000645		ADRP 823296(PC), R5				
  arithmetic.go:268		0x100205080		912688a5		ADD $2466, R5, R5				
  arithmetic.go:268		0x100205084		f86378a3		MOVD (R5)(R3<<3), R3				
  arithmetic.go:268		0x100205088		9ac30825		UDIV R3, R1, R5					
  arithmetic.go:268		0x10020508c		9b058461		MSUB R5, R1, R3, R1				
  arithmetic.go:268		0x100205090		d2e63006		MOVD $3566850904877432832, R6			
  arithmetic.go:268		0x100205094		aa060042		ORR R6, R2, R2					
  arithmetic.go:268		0x100205098		ca040042		EOR R4, R2, R2					
  arithmetic.go:268		0x10020509c		eb43043f		CMP R3>>1, R1					
  arithmetic.go:268		0x1002050a0		9a9f97e1		CSET HI, R1					
  arithmetic.go:268		0x1002050a4		9a9f17e3		CSET EQ, R3					
  arithmetic.go:268		0x1002050a8		f24000bf		TST $1, R5					
  arithmetic.go:268		0x1002050ac		9a9f07e4		CSET NE, R4					
  arithmetic.go:268		0x1002050b0		8a040063		AND R4, R3, R3					
  arithmetic.go:268		0x1002050b4		aa030021		ORR R3, R1, R1					
  arithmetic.go:268		0x1002050b8		d3401c21		UBFX $0, R1, $8, R1				
  arithmetic.go:268		0x1002050bc		8b050021		ADD R5, R1, R1					
  arithmetic.go:268		0x1002050c0		aa020020		ORR R2, R1, R0					
  arithmetic.go:268		0x1002050c4		14000005		JMP 5(PC)					
  arithmetic.go:268		0x1002050c8		d2800021		MOVD $1, R1					
  arithmetic.go:268		0x1002050cc		f2e00801		MOVK $(64<<48), R1				
  arithmetic.go:268		0x1002050d0		aa1f03e2		MOVD ZR, R2					
  arithmetic.go:268		0x1002050d4		97faef8b		CALL internal/decimal.quantize64(SB)		
  compiler_round_test.go:30	0x1002050d8		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:30	0x1002050dc		f84407fe		MOVD.P 64(RSP), R30				
  compiler_round_test.go:30	0x1002050e0		d65f03c0		RET						
  compiler_round_test.go:30	0x1002050e4		f90007e0		MOVD R0, 8(RSP)					
  compiler_round_test.go:30	0x1002050e8		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:30	0x1002050ec		97fa34c5		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:30	0x1002050f0		f94007e0		MOVD 8(RSP), R0					
  compiler_round_test.go:30	0x1002050f4		17ffffcb		JMP internal/bid_test.compiledCent64(SB)	
  compiler_round_test.go:30	0x1002050f8		00000000		?						
  compiler_round_test.go:30	0x1002050fc		00000000		?						

TEXT internal/bid_test.compiledCent128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:33	0x100205100		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:33	0x100205104		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:33	0x100205108		54000609		BLS 48(PC)					
  compiler_round_test.go:33	0x10020510c		f81b0ffe		MOVD.W R30, -80(RSP)				
  compiler_round_test.go:33	0x100205110		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:33	0x100205114		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:33	0x100205118		92430425		AND $6917529027641081856, R1, R5		
  decimal.go:159		0x10020511c		d503201f		NOOP						
  arithmetic.go:262		0x100205120		d503201f		NOOP						
  arithmetic.go:270		0x100205124		d2e60806		MOVD $3476778912330022912, R6			
  arithmetic.go:270		0x100205128		ca060027		EOR R6, R1, R7					
  arithmetic.go:270		0x10020512c		d2e80008		MOVD $4611686018427387904, R8			
  arithmetic.go:270		0x100205130		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x100205134		540003c0		BEQ 30(PC)					
  arithmetic.go:270		0x100205138		f240c0ff		TST $562949953421311, R7			
  arithmetic.go:270		0x10020513c		54000381		BNE 28(PC)					
  arithmetic.go:270		0x100205140		d371f8e5		UBFX $49, R7, $14, R5				
  arithmetic.go:270		0x100205144		d28303c8		MOVD $6174, R8					
  arithmetic.go:270		0x100205148		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x10020514c		54000380		BEQ 28(PC)					
  arithmetic.go:270		0x100205150		d28303a8		MOVD $6173, R8					
  arithmetic.go:270		0x100205154		cb050105		SUB R5, R8, R5					
  arithmetic.go:270		0x100205158		f10048bf		CMP $18, R5					
  arithmetic.go:270		0x10020515c		54000288		BHI 20(PC)					
  arithmetic.go:270		0x100205160		b0000642		ADRP 823296(PC), R2				
  arithmetic.go:270		0x100205164		91268842		ADD $2466, R2, R2				
  arithmetic.go:270		0x100205168		f8657842		MOVD (R2)(R5<<3), R2				
  arithmetic.go:270		0x10020516c		9ac20803		UDIV R2, R0, R3					
  arithmetic.go:270		0x100205170		9b038044		MSUB R3, R0, R2, R4				
  arithmetic.go:270		0x100205174		924100e5		AND $-9223372036854775808, R7, R5		
  arithmetic.go:270		0x100205178		d2e60787		MOVD $3475653012423180288, R7			
  arithmetic.go:270		0x10020517c		aa0700a5		ORR R7, R5, R5					
  arithmetic.go:270		0x100205180		ca0600a1		EOR R6, R5, R1					
  arithmetic.go:270		0x100205184		eb42049f		CMP R2>>1, R4					
  arithmetic.go:270		0x100205188		9a9f97e2		CSET HI, R2					
  arithmetic.go:270		0x10020518c		9a9f17e4		CSET EQ, R4					
  arithmetic.go:270		0x100205190		f240007f		TST $1, R3					
  arithmetic.go:270		0x100205194		9a9f07e5		CSET NE, R5					
  arithmetic.go:270		0x100205198		8a050084		AND R5, R4, R4					
  arithmetic.go:270		0x10020519c		aa040042		ORR R4, R2, R2					
  arithmetic.go:270		0x1002051a0		d3401c42		UBFX $0, R2, $8, R2				
  arithmetic.go:270		0x1002051a4		8b030040		ADD R3, R2, R0					
  arithmetic.go:270		0x1002051a8		14000005		JMP 5(PC)					
  arithmetic.go:270		0x1002051ac		b24003e2		ORR $1, ZR, R2					
  arithmetic.go:270		0x1002051b0		d2e00f83		MOVD $34902897112121344, R3			
  arithmetic.go:270		0x1002051b4		aa1f03e4		MOVD ZR, R4					
  arithmetic.go:270		0x1002051b8		97faef86		CALL internal/decimal.quantize128(SB)		
  compiler_round_test.go:33	0x1002051bc		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:33	0x1002051c0		f84507fe		MOVD.P 80(RSP), R30				
  compiler_round_test.go:33	0x1002051c4		d65f03c0		RET						
  compiler_round_test.go:33	0x1002051c8		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:33	0x1002051cc		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:33	0x1002051d0		97fa348c		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:33	0x1002051d4		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:33	0x1002051d8		17ffffca		JMP internal/bid_test.compiledCent128(SB)	
  compiler_round_test.go:33	0x1002051dc		00000000		?						

TEXT internal/bid_test.compiledAway64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:39	0x1002051e0		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:39	0x1002051e4		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:39	0x1002051e8		54000569		BLS 43(PC)					
  compiler_round_test.go:39	0x1002051ec		f81c0ffe		MOVD.W R30, -64(RSP)				
  compiler_round_test.go:39	0x1002051f0		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:39	0x1002051f4		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:40	0x1002051f8		92430403		AND $6917529027641081856, R0, R3		
  decimal.go:164		0x1002051fc		d503201f		NOOP						
  arithmetic.go:268		0x100205200		d2e63804		MOVD $3584865303386914816, R4			
  arithmetic.go:268		0x100205204		ca040005		EOR R4, R0, R5					
  arithmetic.go:268		0x100205208		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:268		0x10020520c		eb06007f		CMP R6, R3					
  arithmetic.go:268		0x100205210		54000340		BEQ 26(PC)					
  arithmetic.go:268		0x100205214		d375f8a3		UBFX $53, R5, $10, R3				
  arithmetic.go:268		0x100205218		f106307f		CMP $396, R3					
  arithmetic.go:268		0x10020521c		54000360		BEQ 27(PC)					
  arithmetic.go:268		0x100205220		d2803166		MOVD $395, R6					
  arithmetic.go:268		0x100205224		cb0300c3		SUB R3, R6, R3					
  arithmetic.go:268		0x100205228		f100487f		CMP $18, R3					
  arithmetic.go:268		0x10020522c		54000268		BHI 19(PC)					
  arithmetic.go:268		0x100205230		9240d0a1		AND $9007199254740991, R5, R1			
  arithmetic.go:268		0x100205234		924100a2		AND $-9223372036854775808, R5, R2		
  arithmetic.go:268		0x100205238		b0000645		ADRP 823296(PC), R5				
  arithmetic.go:268		0x10020523c		912688a5		ADD $2466, R5, R5				
  arithmetic.go:268		0x100205240		f86378a3		MOVD (R5)(R3<<3), R3				
  arithmetic.go:268		0x100205244		9ac30825		UDIV R3, R1, R5					
  arithmetic.go:268		0x100205248		9b058461		MSUB R5, R1, R3, R1				
  arithmetic.go:268		0x10020524c		d2e63006		MOVD $3566850904877432832, R6			
  arithmetic.go:268		0x100205250		aa060042		ORR R6, R2, R2					
  arithmetic.go:268		0x100205254		ca040042		EOR R4, R2, R2					
  arithmetic.go:268		0x100205258		eb43043f		CMP R3>>1, R1					
  arithmetic.go:268		0x10020525c		9a9f97e1		CSET HI, R1					
  arithmetic.go:268		0x100205260		9a9f17e3		CSET EQ, R3					
  arithmetic.go:268		0x100205264		aa030021		ORR R3, R1, R1					
  arithmetic.go:268		0x100205268		d3401c21		UBFX $0, R1, $8, R1				
  arithmetic.go:268		0x10020526c		8b050021		ADD R5, R1, R1					
  arithmetic.go:268		0x100205270		aa020020		ORR R2, R1, R0					
  arithmetic.go:268		0x100205274		14000005		JMP 5(PC)					
  arithmetic.go:268		0x100205278		d2800021		MOVD $1, R1					
  arithmetic.go:268		0x10020527c		f2e00801		MOVK $(64<<48), R1				
  arithmetic.go:268		0x100205280		b24003e2		ORR $1, ZR, R2					
  arithmetic.go:268		0x100205284		97faef1f		CALL internal/decimal.quantize64(SB)		
  compiler_round_test.go:40	0x100205288		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:40	0x10020528c		f84407fe		MOVD.P 64(RSP), R30				
  compiler_round_test.go:40	0x100205290		d65f03c0		RET						
  compiler_round_test.go:39	0x100205294		f90007e0		MOVD R0, 8(RSP)					
  compiler_round_test.go:39	0x100205298		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:39	0x10020529c		97fa3459		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:39	0x1002052a0		f94007e0		MOVD 8(RSP), R0					
  compiler_round_test.go:39	0x1002052a4		17ffffcf		JMP internal/bid_test.compiledAway64(SB)	
  compiler_round_test.go:39	0x1002052a8		00000000		?						
  compiler_round_test.go:39	0x1002052ac		00000000		?						

TEXT internal/bid_test.compiledAway128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:44	0x1002052b0		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:44	0x1002052b4		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:44	0x1002052b8		54000589		BLS 44(PC)					
  compiler_round_test.go:44	0x1002052bc		f81b0ffe		MOVD.W R30, -80(RSP)				
  compiler_round_test.go:44	0x1002052c0		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:44	0x1002052c4		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:45	0x1002052c8		92430425		AND $6917529027641081856, R1, R5		
  decimal.go:164		0x1002052cc		d503201f		NOOP						
  arithmetic.go:270		0x1002052d0		d2e60806		MOVD $3476778912330022912, R6			
  arithmetic.go:270		0x1002052d4		ca060027		EOR R6, R1, R7					
  arithmetic.go:270		0x1002052d8		d2e80008		MOVD $4611686018427387904, R8			
  arithmetic.go:270		0x1002052dc		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x1002052e0		54000360		BEQ 27(PC)					
  arithmetic.go:270		0x1002052e4		f240c0ff		TST $562949953421311, R7			
  arithmetic.go:270		0x1002052e8		54000321		BNE 25(PC)					
  arithmetic.go:270		0x1002052ec		d371f8e5		UBFX $49, R7, $14, R5				
  arithmetic.go:270		0x1002052f0		d28303c8		MOVD $6174, R8					
  arithmetic.go:270		0x1002052f4		eb0800bf		CMP R8, R5					
  arithmetic.go:270		0x1002052f8		54000320		BEQ 25(PC)					
  arithmetic.go:270		0x1002052fc		d28303a8		MOVD $6173, R8					
  arithmetic.go:270		0x100205300		cb050105		SUB R5, R8, R5					
  arithmetic.go:270		0x100205304		f10048bf		CMP $18, R5					
  arithmetic.go:270		0x100205308		54000228		BHI 17(PC)					
  arithmetic.go:270		0x10020530c		b0000642		ADRP 823296(PC), R2				
  arithmetic.go:270		0x100205310		91268842		ADD $2466, R2, R2				
  arithmetic.go:270		0x100205314		f8657842		MOVD (R2)(R5<<3), R2				
  arithmetic.go:270		0x100205318		9ac20803		UDIV R2, R0, R3					
  arithmetic.go:270		0x10020531c		9b038044		MSUB R3, R0, R2, R4				
  arithmetic.go:270		0x100205320		924100e5		AND $-9223372036854775808, R7, R5		
  arithmetic.go:270		0x100205324		d2e60787		MOVD $3475653012423180288, R7			
  arithmetic.go:270		0x100205328		aa0700a5		ORR R7, R5, R5					
  arithmetic.go:270		0x10020532c		ca0600a1		EOR R6, R5, R1					
  arithmetic.go:270		0x100205330		eb42049f		CMP R2>>1, R4					
  arithmetic.go:270		0x100205334		9a9f97e2		CSET HI, R2					
  arithmetic.go:270		0x100205338		9a9f17e4		CSET EQ, R4					
  arithmetic.go:270		0x10020533c		aa040042		ORR R4, R2, R2					
  arithmetic.go:270		0x100205340		d3401c42		UBFX $0, R2, $8, R2				
  arithmetic.go:270		0x100205344		8b030040		ADD R3, R2, R0					
  arithmetic.go:270		0x100205348		14000005		JMP 5(PC)					
  arithmetic.go:270		0x10020534c		b24003e2		ORR $1, ZR, R2					
  arithmetic.go:270		0x100205350		d2e00f83		MOVD $34902897112121344, R3			
  arithmetic.go:270		0x100205354		b24003e4		ORR $1, ZR, R4					
  arithmetic.go:270		0x100205358		97faef1e		CALL internal/decimal.quantize128(SB)		
  compiler_round_test.go:45	0x10020535c		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:45	0x100205360		f84507fe		MOVD.P 80(RSP), R30				
  compiler_round_test.go:45	0x100205364		d65f03c0		RET						
  compiler_round_test.go:44	0x100205368		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:44	0x10020536c		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:44	0x100205370		97fa3424		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:44	0x100205374		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:44	0x100205378		17ffffce		JMP internal/bid_test.compiledAway128(SB)	
  compiler_round_test.go:44	0x10020537c		00000000		?						

TEXT internal/bid_test.compiledIntegral64(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:49	0x100205380		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:49	0x100205384		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:49	0x100205388		54001c69		BLS 227(PC)					
  compiler_round_test.go:49	0x10020538c		f81a0ffe		MOVD.W R30, -96(RSP)				
  compiler_round_test.go:49	0x100205390		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:49	0x100205394		d10023fd		SUB $8, RSP, R29				
  arithmetic.go:212		0x100205398		f9004be0		MOVD R0, 144(RSP)				
  compiler_round_test.go:49	0x10020539c		9101a3e2		ADD $104, RSP, R2				
  compiler_round_test.go:49	0x1002053a0		a9007c5f		STP (ZR, ZR), (R2)				
  compiler_round_test.go:49	0x1002053a4		a9017c5f		STP (ZR, ZR), 16(R2)				
  compiler_round_test.go:49	0x1002053a8		f900105f		MOVD ZR, 32(R2)					
  arithmetic.go:212		0x1002053ac		92430402		AND $6917529027641081856, R0, R2		
  arithmetic.go:212		0x1002053b0		f9002be2		MOVD R2, 80(RSP)				
  arithmetic.go:212		0x1002053b4		d2e63803		MOVD $3584865303386914816, R3			
  arithmetic.go:212		0x1002053b8		ca030004		EOR R3, R0, R4					
  arithmetic.go:212		0x1002053bc		f90027e4		MOVD R4, 72(RSP)				
  decimal.go:117		0x1002053c0		d503201f		NOOP						
  arithmetic.go:212		0x1002053c4		9240d085		AND $9007199254740991, R4, R5			
  arithmetic.go:212		0x1002053c8		f90023e5		MOVD R5, 64(RSP)				
  arithmetic.go:212		0x1002053cc		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:212		0x1002053d0		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x1002053d4		54000420		BEQ 33(PC)					
  arithmetic.go:212		0x1002053d8		d375f887		UBFX $53, R4, $10, R7				
  arithmetic.go:212		0x1002053dc		f10638ff		CMP $398, R7					
  arithmetic.go:212		0x1002053e0		54000083		BCC 4(PC)					
  arithmetic.go:212		0x1002053e4		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x1002053e8		aa0003e1		MOVD R0, R1					
  arithmetic.go:212		0x1002053ec		14000024		JMP 36(PC)					
  arithmetic.go:212		0x1002053f0		d28031a8		MOVD $397, R8					
  arithmetic.go:212		0x1002053f4		cb070107		SUB R7, R8, R7					
  arithmetic.go:212		0x1002053f8		f10048ff		CMP $18, R7					
  arithmetic.go:212		0x1002053fc		540002e8		BHI 23(PC)					
  arithmetic.go:212		0x100205400		92410089		AND $-9223372036854775808, R4, R9		
  arithmetic.go:212		0x100205404		aa030129		ORR R3, R9, R9					
  arithmetic.go:212		0x100205408		ca090069		EOR R9, R3, R9					
  arithmetic.go:212		0x10020540c		b000064a		ADRP 823296(PC), R10				
  arithmetic.go:212		0x100205410		9126894a		ADD $2466, R10, R10				
  arithmetic.go:212		0x100205414		f8677947		MOVD (R10)(R7<<3), R7				
  arithmetic.go:212		0x100205418		9ac708aa		UDIV R7, R5, R10				
  arithmetic.go:212		0x10020541c		9b0a94eb		MSUB R10, R5, R7, R11				
  arithmetic.go:212		0x100205420		eb47057f		CMP R7>>1, R11					
  arithmetic.go:212		0x100205424		9a9f97e7		CSET HI, R7					
  arithmetic.go:212		0x100205428		9a9f17eb		CSET EQ, R11					
  arithmetic.go:212		0x10020542c		f240015f		TST $1, R10					
  arithmetic.go:212		0x100205430		9a9f07ec		CSET NE, R12					
  arithmetic.go:212		0x100205434		8a0c016b		AND R12, R11, R11				
  arithmetic.go:212		0x100205438		aa070167		ORR R7, R11, R7					
  arithmetic.go:212		0x10020543c		d3401ce7		UBFX $0, R7, $8, R7				
  arithmetic.go:212		0x100205440		8b0a00e7		ADD R10, R7, R7					
  arithmetic.go:212		0x100205444		aa0900e7		ORR R9, R7, R7					
  arithmetic.go:212		0x100205448		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x10020544c		aa0003e1		MOVD R0, R1					
  arithmetic.go:208		0x100205450		aa0703e0		MOVD R7, R0					
  arithmetic.go:212		0x100205454		1400000a		JMP 10(PC)					
  arithmetic.go:212		0x100205458		aa1f03e1		MOVD ZR, R1					
  arithmetic.go:212		0x10020545c		97faee71		CALL internal/decimal.integral64(SB)		
  arithmetic.go:212		0x100205460		f9402be2		MOVD 80(RSP), R2				
  arithmetic.go:212		0x100205464		d2e80003		MOVD $4611686018427387904, R3			
  arithmetic.go:212		0x100205468		eb03005f		CMP R3, R2					
  arithmetic.go:212		0x10020546c		f9404be1		MOVD 144(RSP), R1				
  arithmetic.go:212		0x100205470		d2e63803		MOVD $3584865303386914816, R3			
  arithmetic.go:212		0x100205474		a94413e5		LDP 64(RSP), (R5, R4)				
  arithmetic.go:212		0x100205478		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:208		0x10020547c		f9001fe0		MOVD R0, 56(RSP)				
  decimal.go:114		0x100205480		d503201f		NOOP						
  arithmetic.go:212		0x100205484		540003c0		BEQ 30(PC)					
  arithmetic.go:212		0x100205488		d375f887		UBFX $53, R4, $10, R7				
  arithmetic.go:212		0x10020548c		f10638ff		CMP $398, R7					
  arithmetic.go:212		0x100205490		54000083		BCC 4(PC)					
  arithmetic.go:212		0x100205494		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x100205498		aa0103e7		MOVD R1, R7					
  arithmetic.go:212		0x10020549c		14000024		JMP 36(PC)					
  arithmetic.go:212		0x1002054a0		d28031a8		MOVD $397, R8					
  arithmetic.go:212		0x1002054a4		cb070107		SUB R7, R8, R7					
  arithmetic.go:212		0x1002054a8		f10048ff		CMP $18, R7					
  arithmetic.go:212		0x1002054ac		54000288		BHI 20(PC)					
  arithmetic.go:212		0x1002054b0		92410089		AND $-9223372036854775808, R4, R9		
  arithmetic.go:212		0x1002054b4		aa030129		ORR R3, R9, R9					
  arithmetic.go:212		0x1002054b8		ca090069		EOR R9, R3, R9					
  arithmetic.go:212		0x1002054bc		b000064a		ADRP 823296(PC), R10				
  arithmetic.go:212		0x1002054c0		9126894a		ADD $2466, R10, R10				
  arithmetic.go:212		0x1002054c4		f8677947		MOVD (R10)(R7<<3), R7				
  arithmetic.go:212		0x1002054c8		9ac708aa		UDIV R7, R5, R10				
  arithmetic.go:212		0x1002054cc		9b0a94eb		MSUB R10, R5, R7, R11				
  arithmetic.go:212		0x1002054d0		eb47057f		CMP R7>>1, R11					
  arithmetic.go:212		0x1002054d4		9a9f97e7		CSET HI, R7					
  arithmetic.go:212		0x1002054d8		9a9f17eb		CSET EQ, R11					
  arithmetic.go:212		0x1002054dc		aa070167		ORR R7, R11, R7					
  arithmetic.go:212		0x1002054e0		d3401ce7		UBFX $0, R7, $8, R7				
  arithmetic.go:212		0x1002054e4		8b0a00e7		ADD R10, R7, R7					
  arithmetic.go:212		0x1002054e8		aa0900e7		ORR R9, R7, R7					
  arithmetic.go:212		0x1002054ec		eb06005f		CMP R6, R2					
  arithmetic.go:205		0x1002054f0		aa0703e1		MOVD R7, R1					
  arithmetic.go:212		0x1002054f4		f9404be7		MOVD 144(RSP), R7				
  arithmetic.go:212		0x1002054f8		1400000d		JMP 13(PC)					
  arithmetic.go:212		0x1002054fc		aa0103e0		MOVD R1, R0					
  arithmetic.go:212		0x100205500		b24003e1		ORR $1, ZR, R1					
  arithmetic.go:212		0x100205504		97faee47		CALL internal/decimal.integral64(SB)		
  arithmetic.go:212		0x100205508		f9402be2		MOVD 80(RSP), R2				
  arithmetic.go:212		0x10020550c		d2e80003		MOVD $4611686018427387904, R3			
  arithmetic.go:212		0x100205510		eb03005f		CMP R3, R2					
  arithmetic.go:212		0x100205514		d2e63803		MOVD $3584865303386914816, R3			
  arithmetic.go:212		0x100205518		a94413e5		LDP 64(RSP), (R5, R4)				
  arithmetic.go:212		0x10020551c		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:212		0x100205520		f9404be7		MOVD 144(RSP), R7				
  arithmetic.go:205		0x100205524		aa0003e1		MOVD R0, R1					
  compiler_round_test.go:50	0x100205528		f9401fe0		MOVD 56(RSP), R0				
  arithmetic.go:205		0x10020552c		f9001be1		MOVD R1, 48(RSP)				
  decimal.go:105		0x100205530		d503201f		NOOP						
  arithmetic.go:212		0x100205534		540002e0		BEQ 23(PC)					
  arithmetic.go:212		0x100205538		d375f888		UBFX $53, R4, $10, R8				
  arithmetic.go:212		0x10020553c		f106391f		CMP $398, R8					
  arithmetic.go:212		0x100205540		54000083		BCC 4(PC)					
  arithmetic.go:212		0x100205544		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x100205548		aa0703e8		MOVD R7, R8					
  arithmetic.go:212		0x10020554c		1400001e		JMP 30(PC)					
  arithmetic.go:212		0x100205550		d28031a9		MOVD $397, R9					
  arithmetic.go:212		0x100205554		cb080128		SUB R8, R9, R8					
  arithmetic.go:212		0x100205558		f100491f		CMP $18, R8					
  arithmetic.go:212		0x10020555c		540001a8		BHI 13(PC)					
  arithmetic.go:212		0x100205560		9241008a		AND $-9223372036854775808, R4, R10		
  arithmetic.go:212		0x100205564		aa03014a		ORR R3, R10, R10				
  arithmetic.go:212		0x100205568		ca0a006a		EOR R10, R3, R10				
  arithmetic.go:212		0x10020556c		b000064b		ADRP 823296(PC), R11				
  arithmetic.go:212		0x100205570		9126896b		ADD $2466, R11, R11				
  arithmetic.go:212		0x100205574		f8687968		MOVD (R11)(R8<<3), R8				
  arithmetic.go:212		0x100205578		9ac808a8		UDIV R8, R5, R8					
  arithmetic.go:212		0x10020557c		aa0a0108		ORR R10, R8, R8					
  arithmetic.go:212		0x100205580		eb06005f		CMP R6, R2					
  arithmetic.go:196		0x100205584		aa0803e7		MOVD R8, R7					
  arithmetic.go:212		0x100205588		f9404be8		MOVD 144(RSP), R8				
  arithmetic.go:212		0x10020558c		1400000e		JMP 14(PC)					
  arithmetic.go:212		0x100205590		aa0703e0		MOVD R7, R0					
  arithmetic.go:212		0x100205594		b27f03e1		ORR $2, ZR, R1					
  arithmetic.go:212		0x100205598		97faee22		CALL internal/decimal.integral64(SB)		
  arithmetic.go:212		0x10020559c		f9402be2		MOVD 80(RSP), R2				
  arithmetic.go:212		0x1002055a0		d2e80003		MOVD $4611686018427387904, R3			
  arithmetic.go:212		0x1002055a4		eb03005f		CMP R3, R2					
  compiler_round_test.go:50	0x1002055a8		f9401be1		MOVD 48(RSP), R1				
  arithmetic.go:212		0x1002055ac		d2e63803		MOVD $3584865303386914816, R3			
  arithmetic.go:212		0x1002055b0		a94413e5		LDP 64(RSP), (R5, R4)				
  arithmetic.go:212		0x1002055b4		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:212		0x1002055b8		f9404be8		MOVD 144(RSP), R8				
  arithmetic.go:196		0x1002055bc		aa0003e7		MOVD R0, R7					
  compiler_round_test.go:50	0x1002055c0		f9401fe0		MOVD 56(RSP), R0				
  arithmetic.go:196		0x1002055c4		f90017e7		MOVD R7, 40(RSP)				
  decimal.go:111		0x1002055c8		d503201f		NOOP						
  arithmetic.go:212		0x1002055cc		540003e0		BEQ 31(PC)					
  arithmetic.go:212		0x1002055d0		d375f889		UBFX $53, R4, $10, R9				
  arithmetic.go:212		0x1002055d4		f106393f		CMP $398, R9					
  arithmetic.go:212		0x1002055d8		54000083		BCC 4(PC)					
  arithmetic.go:212		0x1002055dc		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x1002055e0		aa0803e2		MOVD R8, R2					
  arithmetic.go:212		0x1002055e4		14000026		JMP 38(PC)					
  arithmetic.go:212		0x1002055e8		d28031aa		MOVD $397, R10					
  arithmetic.go:212		0x1002055ec		cb090149		SUB R9, R10, R9					
  arithmetic.go:212		0x1002055f0		f100493f		CMP $18, R9					
  arithmetic.go:212		0x1002055f4		540002a8		BHI 21(PC)					
  arithmetic.go:212		0x1002055f8		d37ffc8b		LSR $63, R4, R11				
  arithmetic.go:212		0x1002055fc		b000064c		ADRP 823296(PC), R12				
  arithmetic.go:212		0x100205600		9126898c		ADD $2466, R12, R12				
  arithmetic.go:212		0x100205604		f8697989		MOVD (R12)(R9<<3), R9				
  arithmetic.go:212		0x100205608		9ac908ac		UDIV R9, R5, R12				
  arithmetic.go:212		0x10020560c		9b0c7d29		MUL R12, R9, R9					
  arithmetic.go:212		0x100205610		d240016b		EOR $1, R11, R11				
  arithmetic.go:212		0x100205614		9241008d		AND $-9223372036854775808, R4, R13		
  arithmetic.go:212		0x100205618		aa0301ad		ORR R3, R13, R13				
  arithmetic.go:212		0x10020561c		ca0d006d		EOR R13, R3, R13				
  arithmetic.go:212		0x100205620		eb0900bf		CMP R9, R5					
  arithmetic.go:212		0x100205624		9a9f07e9		CSET NE, R9					
  arithmetic.go:212		0x100205628		8a090169		AND R9, R11, R9					
  arithmetic.go:212		0x10020562c		d3401d29		UBFX $0, R9, $8, R9				
  arithmetic.go:212		0x100205630		8b0c0129		ADD R12, R9, R9					
  arithmetic.go:212		0x100205634		aa0d0129		ORR R13, R9, R9					
  arithmetic.go:212		0x100205638		eb06005f		CMP R6, R2					
  arithmetic.go:212		0x10020563c		aa0803e2		MOVD R8, R2					
  arithmetic.go:202		0x100205640		aa0903e8		MOVD R9, R8					
  arithmetic.go:212		0x100205644		1400000e		JMP 14(PC)					
  arithmetic.go:212		0x100205648		aa0803e0		MOVD R8, R0					
  arithmetic.go:212		0x10020564c		b24007e1		ORR $3, ZR, R1					
  arithmetic.go:212		0x100205650		97faedf4		CALL internal/decimal.integral64(SB)		
  arithmetic.go:212		0x100205654		f9402be2		MOVD 80(RSP), R2				
  arithmetic.go:212		0x100205658		d2e80003		MOVD $4611686018427387904, R3			
  arithmetic.go:212		0x10020565c		eb03005f		CMP R3, R2					
  compiler_round_test.go:50	0x100205660		f9401be1		MOVD 48(RSP), R1				
  arithmetic.go:212		0x100205664		f9404be2		MOVD 144(RSP), R2				
  arithmetic.go:212		0x100205668		d2e63803		MOVD $3584865303386914816, R3			
  arithmetic.go:212		0x10020566c		a94413e5		LDP 64(RSP), (R5, R4)				
  compiler_round_test.go:50	0x100205670		f94017e7		MOVD 40(RSP), R7				
  arithmetic.go:202		0x100205674		aa0003e8		MOVD R0, R8					
  compiler_round_test.go:50	0x100205678		f9401fe0		MOVD 56(RSP), R0				
  arithmetic.go:202		0x10020567c		f9002be8		MOVD R8, 80(RSP)				
  decimal.go:108		0x100205680		d503201f		NOOP						
  arithmetic.go:212		0x100205684		540002e0		BEQ 23(PC)					
  arithmetic.go:212		0x100205688		d375f886		UBFX $53, R4, $10, R6				
  arithmetic.go:212		0x10020568c		f10638df		CMP $398, R6					
  arithmetic.go:212		0x100205690		54000362		BCS 27(PC)					
  arithmetic.go:212		0x100205694		d28031a9		MOVD $397, R9					
  arithmetic.go:212		0x100205698		cb060126		SUB R6, R9, R6					
  arithmetic.go:212		0x10020569c		f10048df		CMP $18, R6					
  arithmetic.go:212		0x1002056a0		54000208		BHI 16(PC)					
  arithmetic.go:212		0x1002056a4		92410082		AND $-9223372036854775808, R4, R2		
  arithmetic.go:212		0x1002056a8		aa030042		ORR R3, R2, R2					
  arithmetic.go:212		0x1002056ac		ca020062		EOR R2, R3, R2					
  arithmetic.go:212		0x1002056b0		b0000643		ADRP 823296(PC), R3				
  arithmetic.go:212		0x1002056b4		91268863		ADD $2466, R3, R3				
  arithmetic.go:212		0x1002056b8		f8667863		MOVD (R3)(R6<<3), R3				
  arithmetic.go:212		0x1002056bc		9ac308a6		UDIV R3, R5, R6					
  arithmetic.go:212		0x1002056c0		9b067c63		MUL R6, R3, R3					
  arithmetic.go:212		0x1002056c4		eb0300bf		CMP R3, R5					
  arithmetic.go:212		0x1002056c8		9a9f07e3		CSET NE, R3					
  arithmetic.go:212		0x1002056cc		8a44fc63		AND R4>>63, R3, R3				
  arithmetic.go:212		0x1002056d0		d3401c63		UBFX $0, R3, $8, R3				
  arithmetic.go:212		0x1002056d4		8b060063		ADD R6, R3, R3					
  arithmetic.go:212		0x1002056d8		aa020062		ORR R2, R3, R2					
  arithmetic.go:212		0x1002056dc		14000008		JMP 8(PC)					
  arithmetic.go:212		0x1002056e0		aa0203e0		MOVD R2, R0					
  arithmetic.go:212		0x1002056e4		b27e03e1		ORR $4, ZR, R1					
  arithmetic.go:212		0x1002056e8		97faedce		CALL internal/decimal.integral64(SB)		
  compiler_round_test.go:50	0x1002056ec		a94287e7		LDP 40(RSP), (R7, R1)				
  compiler_round_test.go:50	0x1002056f0		f9402be8		MOVD 80(RSP), R8				
  arithmetic.go:199		0x1002056f4		aa0003e2		MOVD R0, R2					
  compiler_round_test.go:50	0x1002056f8		f9401fe0		MOVD 56(RSP), R0				
  compiler_round_test.go:50	0x1002056fc		a90687e0		STP (R0, R1), 104(RSP)				
  compiler_round_test.go:50	0x100205700		a907a3e7		STP (R7, R8), 120(RSP)				
  compiler_round_test.go:50	0x100205704		f90047e2		MOVD R2, 136(RSP)				
  compiler_round_test.go:50	0x100205708		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:50	0x10020570c		f84607fe		MOVD.P 96(RSP), R30				
  compiler_round_test.go:50	0x100205710		d65f03c0		RET						
  compiler_round_test.go:49	0x100205714		f9001be0		MOVD R0, 48(RSP)				
  compiler_round_test.go:49	0x100205718		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:49	0x10020571c		97fa3339		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:49	0x100205720		f9401be0		MOVD 48(RSP), R0				
  compiler_round_test.go:49	0x100205724		17ffff17		JMP internal/bid_test.compiledIntegral64(SB)	
  compiler_round_test.go:49	0x100205728		00000000		?						
  compiler_round_test.go:49	0x10020572c		00000000		?						

TEXT internal/bid_test.compiledIntegral128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:54	0x100205730		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:54	0x100205734		d10083f1		SUB $32, RSP, R17				
  compiler_round_test.go:54	0x100205738		eb10023f		CMP R16, R17					
  compiler_round_test.go:54	0x10020573c		54002249		BLS 274(PC)					
  compiler_round_test.go:54	0x100205740		f8160ffe		MOVD.W R30, -160(RSP)				
  compiler_round_test.go:54	0x100205744		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:54	0x100205748		d10023fd		SUB $8, RSP, R29				
  arithmetic.go:214		0x10020574c		a90f87e0		STP (R0, R1), 248(RSP)				
  compiler_round_test.go:54	0x100205750		9102a3e3		ADD $168, RSP, R3				
  compiler_round_test.go:54	0x100205754		a9007c7f		STP (ZR, ZR), (R3)				
  compiler_round_test.go:54	0x100205758		a9017c7f		STP (ZR, ZR), 16(R3)				
  compiler_round_test.go:54	0x10020575c		a9027c7f		STP (ZR, ZR), 32(R3)				
  compiler_round_test.go:54	0x100205760		a9037c7f		STP (ZR, ZR), 48(R3)				
  compiler_round_test.go:54	0x100205764		a9047c7f		STP (ZR, ZR), 64(R3)				
  arithmetic.go:214		0x100205768		92430423		AND $6917529027641081856, R1, R3		
  arithmetic.go:214		0x10020576c		f9004be3		MOVD R3, 144(RSP)				
  arithmetic.go:214		0x100205770		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x100205774		ca040025		EOR R4, R1, R5					
  arithmetic.go:214		0x100205778		f90047e5		MOVD R5, 136(RSP)				
  decimal.go:117		0x10020577c		d503201f		NOOP						
  arithmetic.go:214		0x100205780		9240c0a6		AND $562949953421311, R5, R6			
  arithmetic.go:214		0x100205784		f90043e6		MOVD R6, 128(RSP)				
  arithmetic.go:214		0x100205788		d2e80007		MOVD $4611686018427387904, R7			
  arithmetic.go:214		0x10020578c		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205790		540004a0		BEQ 37(PC)					
  arithmetic.go:214		0x100205794		b5000486		CBNZ R6, 36(PC)					
  arithmetic.go:214		0x100205798		d371f8a8		UBFX $49, R5, $14, R8				
  arithmetic.go:214		0x10020579c		d2830409		MOVD $6176, R9					
  arithmetic.go:214		0x1002057a0		eb09011f		CMP R9, R8					
  arithmetic.go:214		0x1002057a4		540000a3		BCC 5(PC)					
  arithmetic.go:214		0x1002057a8		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x1002057ac		aa0103e2		MOVD R1, R2					
  arithmetic.go:214		0x1002057b0		aa0003e8		MOVD R0, R8					
  arithmetic.go:214		0x1002057b4		14000026		JMP 38(PC)					
  arithmetic.go:214		0x1002057b8		d28303e9		MOVD $6175, R9					
  arithmetic.go:214		0x1002057bc		cb080128		SUB R8, R9, R8					
  arithmetic.go:214		0x1002057c0		f100491f		CMP $18, R8					
  arithmetic.go:214		0x1002057c4		54000308		BHI 24(PC)					
  arithmetic.go:214		0x1002057c8		924100aa		AND $-9223372036854775808, R5, R10		
  arithmetic.go:214		0x1002057cc		aa04014a		ORR R4, R10, R10				
  arithmetic.go:214		0x1002057d0		b000064b		ADRP 823296(PC), R11				
  arithmetic.go:214		0x1002057d4		9126896b		ADD $2466, R11, R11				
  arithmetic.go:214		0x1002057d8		f8687968		MOVD (R11)(R8<<3), R8				
  arithmetic.go:214		0x1002057dc		9ac8080b		UDIV R8, R0, R11				
  arithmetic.go:214		0x1002057e0		9b0b810c		MSUB R11, R0, R8, R12				
  arithmetic.go:214		0x1002057e4		ca04014a		EOR R4, R10, R10				
  arithmetic.go:214		0x1002057e8		eb48059f		CMP R8>>1, R12					
  arithmetic.go:214		0x1002057ec		9a9f97e8		CSET HI, R8					
  arithmetic.go:214		0x1002057f0		9a9f17ec		CSET EQ, R12					
  arithmetic.go:214		0x1002057f4		f240017f		TST $1, R11					
  arithmetic.go:214		0x1002057f8		9a9f07ed		CSET NE, R13					
  arithmetic.go:214		0x1002057fc		8a0d018c		AND R13, R12, R12				
  arithmetic.go:214		0x100205800		aa080188		ORR R8, R12, R8					
  arithmetic.go:214		0x100205804		d3401d08		UBFX $0, R8, $8, R8				
  arithmetic.go:214		0x100205808		8b0b0108		ADD R11, R8, R8					
  arithmetic.go:214		0x10020580c		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205810		aa0103e2		MOVD R1, R2					
  arithmetic.go:208		0x100205814		aa0a03e1		MOVD R10, R1					
  arithmetic.go:208		0x100205818		aa0803e0		MOVD R8, R0					
  arithmetic.go:214		0x10020581c		f9407fe8		MOVD 248(RSP), R8				
  arithmetic.go:214		0x100205820		1400000b		JMP 11(PC)					
  arithmetic.go:214		0x100205824		aa1f03e2		MOVD ZR, R2					
  arithmetic.go:214		0x100205828		97faed9a		CALL internal/decimal.integral128(SB)		
  arithmetic.go:214		0x10020582c		f9404be3		MOVD 144(RSP), R3				
  arithmetic.go:214		0x100205830		d2e80004		MOVD $4611686018427387904, R4			
  arithmetic.go:214		0x100205834		eb04007f		CMP R4, R3					
  arithmetic.go:214		0x100205838		f94083e2		MOVD 256(RSP), R2				
  arithmetic.go:214		0x10020583c		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x100205840		a94817e6		LDP 128(RSP), (R6, R5)				
  arithmetic.go:214		0x100205844		d2e80007		MOVD $4611686018427387904, R7			
  arithmetic.go:214		0x100205848		f9407fe8		MOVD 248(RSP), R8				
  arithmetic.go:208		0x10020584c		f9003fe1		MOVD R1, 120(RSP)				
  arithmetic.go:208		0x100205850		f9002fe0		MOVD R0, 88(RSP)				
  decimal.go:114		0x100205854		d503201f		NOOP						
  arithmetic.go:214		0x100205858		54000440		BEQ 34(PC)					
  arithmetic.go:214		0x10020585c		b5000426		CBNZ R6, 33(PC)					
  arithmetic.go:214		0x100205860		d371f8a9		UBFX $49, R5, $14, R9				
  arithmetic.go:214		0x100205864		d283040a		MOVD $6176, R10					
  arithmetic.go:214		0x100205868		eb0a013f		CMP R10, R9					
  arithmetic.go:214		0x10020586c		540000a3		BCC 5(PC)					
  arithmetic.go:214		0x100205870		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205874		aa0203e9		MOVD R2, R9					
  arithmetic.go:214		0x100205878		aa0803ea		MOVD R8, R10					
  arithmetic.go:214		0x10020587c		14000028		JMP 40(PC)					
  arithmetic.go:214		0x100205880		d28303ea		MOVD $6175, R10					
  arithmetic.go:214		0x100205884		cb090149		SUB R9, R10, R9					
  arithmetic.go:214		0x100205888		f100493f		CMP $18, R9					
  arithmetic.go:214		0x10020588c		540002a8		BHI 21(PC)					
  arithmetic.go:214		0x100205890		924100ab		AND $-9223372036854775808, R5, R11		
  arithmetic.go:214		0x100205894		aa04016b		ORR R4, R11, R11				
  arithmetic.go:214		0x100205898		b000064c		ADRP 823296(PC), R12				
  arithmetic.go:214		0x10020589c		9126898c		ADD $2466, R12, R12				
  arithmetic.go:214		0x1002058a0		f8697989		MOVD (R12)(R9<<3), R9				
  arithmetic.go:214		0x1002058a4		9ac9090c		UDIV R9, R8, R12				
  arithmetic.go:214		0x1002058a8		9b0ca12d		MSUB R12, R8, R9, R13				
  arithmetic.go:214		0x1002058ac		ca04016b		EOR R4, R11, R11				
  arithmetic.go:214		0x1002058b0		eb4905bf		CMP R9>>1, R13					
  arithmetic.go:214		0x1002058b4		9a9f97e9		CSET HI, R9					
  arithmetic.go:214		0x1002058b8		9a9f17ed		CSET EQ, R13					
  arithmetic.go:214		0x1002058bc		aa0901a9		ORR R9, R13, R9					
  arithmetic.go:214		0x1002058c0		d3401d29		UBFX $0, R9, $8, R9				
  arithmetic.go:214		0x1002058c4		8b0c0129		ADD R12, R9, R9					
  arithmetic.go:214		0x1002058c8		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x1002058cc		aa0803ea		MOVD R8, R10					
  arithmetic.go:205		0x1002058d0		aa0b03e2		MOVD R11, R2					
  arithmetic.go:205		0x1002058d4		aa0903e8		MOVD R9, R8					
  arithmetic.go:214		0x1002058d8		f94083e9		MOVD 256(RSP), R9				
  arithmetic.go:214		0x1002058dc		14000010		JMP 16(PC)					
  arithmetic.go:214		0x1002058e0		aa0803e0		MOVD R8, R0					
  arithmetic.go:214		0x1002058e4		aa0203e1		MOVD R2, R1					
  arithmetic.go:214		0x1002058e8		b24003e2		ORR $1, ZR, R2					
  arithmetic.go:214		0x1002058ec		97faed69		CALL internal/decimal.integral128(SB)		
  arithmetic.go:214		0x1002058f0		f9404be3		MOVD 144(RSP), R3				
  arithmetic.go:214		0x1002058f4		d2e80004		MOVD $4611686018427387904, R4			
  arithmetic.go:214		0x1002058f8		eb04007f		CMP R4, R3					
  arithmetic.go:214		0x1002058fc		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x100205900		a94817e6		LDP 128(RSP), (R6, R5)				
  arithmetic.go:214		0x100205904		d2e80007		MOVD $4611686018427387904, R7			
  arithmetic.go:214		0x100205908		a94fa7ea		LDP 248(RSP), (R10, R9)				
  arithmetic.go:205		0x10020590c		aa0103e2		MOVD R1, R2					
  arithmetic.go:205		0x100205910		aa0003e8		MOVD R0, R8					
  compiler_round_test.go:55	0x100205914		f9402fe0		MOVD 88(RSP), R0				
  compiler_round_test.go:55	0x100205918		f9403fe1		MOVD 120(RSP), R1				
  arithmetic.go:205		0x10020591c		f9003be2		MOVD R2, 112(RSP)				
  arithmetic.go:205		0x100205920		f9002be8		MOVD R8, 80(RSP)				
  decimal.go:105		0x100205924		d503201f		NOOP						
  arithmetic.go:214		0x100205928		54000360		BEQ 27(PC)					
  arithmetic.go:214		0x10020592c		b5000346		CBNZ R6, 26(PC)					
  arithmetic.go:214		0x100205930		d371f8ab		UBFX $49, R5, $14, R11				
  arithmetic.go:214		0x100205934		d283040c		MOVD $6176, R12					
  arithmetic.go:214		0x100205938		eb0c017f		CMP R12, R11					
  arithmetic.go:214		0x10020593c		540000a3		BCC 5(PC)					
  arithmetic.go:214		0x100205940		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205944		aa0903eb		MOVD R9, R11					
  arithmetic.go:214		0x100205948		aa0a03ec		MOVD R10, R12					
  arithmetic.go:214		0x10020594c		14000023		JMP 35(PC)					
  arithmetic.go:214		0x100205950		d28303ec		MOVD $6175, R12					
  arithmetic.go:214		0x100205954		cb0b018b		SUB R11, R12, R11				
  arithmetic.go:214		0x100205958		f100497f		CMP $18, R11					
  arithmetic.go:214		0x10020595c		540001c8		BHI 14(PC)					
  arithmetic.go:214		0x100205960		924100ad		AND $-9223372036854775808, R5, R13		
  arithmetic.go:214		0x100205964		aa0401ad		ORR R4, R13, R13				
  arithmetic.go:214		0x100205968		b000064e		ADRP 823296(PC), R14				
  arithmetic.go:214		0x10020596c		912689ce		ADD $2466, R14, R14				
  arithmetic.go:214		0x100205970		f86b79cb		MOVD (R14)(R11<<3), R11				
  arithmetic.go:214		0x100205974		9acb094b		UDIV R11, R10, R11				
  arithmetic.go:214		0x100205978		ca0401ad		EOR R4, R13, R13				
  arithmetic.go:214		0x10020597c		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205980		aa0a03ec		MOVD R10, R12					
  arithmetic.go:196		0x100205984		aa0d03e9		MOVD R13, R9					
  arithmetic.go:196		0x100205988		aa0b03ea		MOVD R11, R10					
  arithmetic.go:214		0x10020598c		f94083eb		MOVD 256(RSP), R11				
  arithmetic.go:214		0x100205990		14000012		JMP 18(PC)					
  arithmetic.go:214		0x100205994		aa0a03e0		MOVD R10, R0					
  arithmetic.go:214		0x100205998		aa0903e1		MOVD R9, R1					
  arithmetic.go:214		0x10020599c		b27f03e2		ORR $2, ZR, R2					
  arithmetic.go:214		0x1002059a0		97faed3c		CALL internal/decimal.integral128(SB)		
  arithmetic.go:214		0x1002059a4		f9404be3		MOVD 144(RSP), R3				
  arithmetic.go:214		0x1002059a8		d2e80004		MOVD $4611686018427387904, R4			
  arithmetic.go:214		0x1002059ac		eb04007f		CMP R4, R3					
  compiler_round_test.go:55	0x1002059b0		f9403be2		MOVD 112(RSP), R2				
  arithmetic.go:214		0x1002059b4		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x1002059b8		a94817e6		LDP 128(RSP), (R6, R5)				
  arithmetic.go:214		0x1002059bc		d2e80007		MOVD $4611686018427387904, R7			
  compiler_round_test.go:55	0x1002059c0		f9402be8		MOVD 80(RSP), R8				
  arithmetic.go:214		0x1002059c4		a94fafec		LDP 248(RSP), (R12, R11)			
  arithmetic.go:196		0x1002059c8		aa0103e9		MOVD R1, R9					
  arithmetic.go:196		0x1002059cc		aa0003ea		MOVD R0, R10					
  compiler_round_test.go:55	0x1002059d0		f9402fe0		MOVD 88(RSP), R0				
  compiler_round_test.go:55	0x1002059d4		f9403fe1		MOVD 120(RSP), R1				
  arithmetic.go:196		0x1002059d8		f90037e9		MOVD R9, 104(RSP)				
  arithmetic.go:196		0x1002059dc		f90027ea		MOVD R10, 72(RSP)				
  decimal.go:111		0x1002059e0		d503201f		NOOP						
  arithmetic.go:214		0x1002059e4		54000460		BEQ 35(PC)					
  arithmetic.go:214		0x1002059e8		b5000446		CBNZ R6, 34(PC)					
  arithmetic.go:214		0x1002059ec		d371f8ad		UBFX $49, R5, $14, R13				
  arithmetic.go:214		0x1002059f0		d283040e		MOVD $6176, R14					
  arithmetic.go:214		0x1002059f4		eb0e01bf		CMP R14, R13					
  arithmetic.go:214		0x1002059f8		540000a3		BCC 5(PC)					
  arithmetic.go:214		0x1002059fc		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205a00		aa0b03e3		MOVD R11, R3					
  arithmetic.go:214		0x100205a04		aa0c03e7		MOVD R12, R7					
  arithmetic.go:214		0x100205a08		1400002d		JMP 45(PC)					
  arithmetic.go:214		0x100205a0c		d28303ee		MOVD $6175, R14					
  arithmetic.go:214		0x100205a10		cb0d01cd		SUB R13, R14, R13				
  arithmetic.go:214		0x100205a14		f10049bf		CMP $18, R13					
  arithmetic.go:214		0x100205a18		540002c8		BHI 22(PC)					
  arithmetic.go:214		0x100205a1c		d37ffcaf		LSR $63, R5, R15				
  arithmetic.go:214		0x100205a20		b0000650		ADRP 823296(PC), R16				
  arithmetic.go:214		0x100205a24		91268a10		ADD $2466, R16, R16				
  arithmetic.go:214		0x100205a28		f86d7a0d		MOVD (R16)(R13<<3), R13				
  arithmetic.go:214		0x100205a2c		9acd0990		UDIV R13, R12, R16				
  arithmetic.go:214		0x100205a30		9b107dad		MUL R16, R13, R13				
  arithmetic.go:214		0x100205a34		d24001ef		EOR $1, R15, R15				
  arithmetic.go:214		0x100205a38		924100b1		AND $-9223372036854775808, R5, R17		
  arithmetic.go:214		0x100205a3c		aa040231		ORR R4, R17, R17				
  arithmetic.go:214		0x100205a40		ca040231		EOR R4, R17, R17				
  arithmetic.go:214		0x100205a44		eb0d019f		CMP R13, R12					
  arithmetic.go:214		0x100205a48		9a9f07ed		CSET NE, R13					
  arithmetic.go:214		0x100205a4c		8a0d01ed		AND R13, R15, R13				
  arithmetic.go:214		0x100205a50		d3401dad		UBFX $0, R13, $8, R13				
  arithmetic.go:214		0x100205a54		8b1001ad		ADD R16, R13, R13				
  arithmetic.go:214		0x100205a58		eb07007f		CMP R7, R3					
  arithmetic.go:214		0x100205a5c		aa0b03e3		MOVD R11, R3					
  arithmetic.go:214		0x100205a60		aa0c03e7		MOVD R12, R7					
  arithmetic.go:202		0x100205a64		aa1103eb		MOVD R17, R11					
  arithmetic.go:202		0x100205a68		aa0d03ec		MOVD R13, R12					
  arithmetic.go:214		0x100205a6c		14000014		JMP 20(PC)					
  arithmetic.go:214		0x100205a70		aa0c03e0		MOVD R12, R0					
  arithmetic.go:214		0x100205a74		aa0b03e1		MOVD R11, R1					
  arithmetic.go:214		0x100205a78		b24007e2		ORR $3, ZR, R2					
  arithmetic.go:214		0x100205a7c		97faed05		CALL internal/decimal.integral128(SB)		
  arithmetic.go:214		0x100205a80		f9404be3		MOVD 144(RSP), R3				
  arithmetic.go:214		0x100205a84		d2e80004		MOVD $4611686018427387904, R4			
  arithmetic.go:214		0x100205a88		eb04007f		CMP R4, R3					
  compiler_round_test.go:55	0x100205a8c		f9403be2		MOVD 112(RSP), R2				
  arithmetic.go:214		0x100205a90		f94083e3		MOVD 256(RSP), R3				
  arithmetic.go:214		0x100205a94		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x100205a98		a94817e6		LDP 128(RSP), (R6, R5)				
  arithmetic.go:214		0x100205a9c		f9407fe7		MOVD 248(RSP), R7				
  compiler_round_test.go:55	0x100205aa0		f9402be8		MOVD 80(RSP), R8				
  compiler_round_test.go:55	0x100205aa4		f94037e9		MOVD 104(RSP), R9				
  compiler_round_test.go:55	0x100205aa8		f94027ea		MOVD 72(RSP), R10				
  arithmetic.go:202		0x100205aac		aa0103eb		MOVD R1, R11					
  arithmetic.go:202		0x100205ab0		aa0003ec		MOVD R0, R12					
  compiler_round_test.go:55	0x100205ab4		f9402fe0		MOVD 88(RSP), R0				
  compiler_round_test.go:55	0x100205ab8		f9403fe1		MOVD 120(RSP), R1				
  arithmetic.go:202		0x100205abc		f90033eb		MOVD R11, 96(RSP)				
  arithmetic.go:202		0x100205ac0		f90023ec		MOVD R12, 64(RSP)				
  decimal.go:108		0x100205ac4		d503201f		NOOP						
  arithmetic.go:214		0x100205ac8		54000320		BEQ 25(PC)					
  arithmetic.go:214		0x100205acc		b5000306		CBNZ R6, 24(PC)					
  arithmetic.go:214		0x100205ad0		d371f8a6		UBFX $49, R5, $14, R6				
  arithmetic.go:214		0x100205ad4		d283040d		MOVD $6176, R13					
  arithmetic.go:214		0x100205ad8		eb0d00df		CMP R13, R6					
  arithmetic.go:214		0x100205adc		54000442		BCS 34(PC)					
  arithmetic.go:214		0x100205ae0		d28303ed		MOVD $6175, R13					
  arithmetic.go:214		0x100205ae4		cb0601a6		SUB R6, R13, R6					
  arithmetic.go:214		0x100205ae8		f10048df		CMP $18, R6					
  arithmetic.go:214		0x100205aec		54000208		BHI 16(PC)					
  arithmetic.go:214		0x100205af0		924100a3		AND $-9223372036854775808, R5, R3		
  arithmetic.go:214		0x100205af4		aa040063		ORR R4, R3, R3					
  arithmetic.go:214		0x100205af8		b000064d		ADRP 823296(PC), R13				
  arithmetic.go:214		0x100205afc		912689ad		ADD $2466, R13, R13				
  arithmetic.go:214		0x100205b00		f86679a6		MOVD (R13)(R6<<3), R6				
  arithmetic.go:214		0x100205b04		9ac608ed		UDIV R6, R7, R13				
  arithmetic.go:214		0x100205b08		9b0d7cc6		MUL R13, R6, R6					
  arithmetic.go:214		0x100205b0c		ca040063		EOR R4, R3, R3					
  arithmetic.go:214		0x100205b10		eb0600ff		CMP R6, R7					
  arithmetic.go:214		0x100205b14		9a9f07e4		CSET NE, R4					
  arithmetic.go:214		0x100205b18		8a45fc84		AND R5>>63, R4, R4				
  arithmetic.go:214		0x100205b1c		d3401c84		UBFX $0, R4, $8, R4				
  arithmetic.go:214		0x100205b20		8b0d0084		ADD R13, R4, R4					
  arithmetic.go:199		0x100205b24		aa0403e7		MOVD R4, R7					
  arithmetic.go:214		0x100205b28		1400000f		JMP 15(PC)					
  arithmetic.go:214		0x100205b2c		aa0703e0		MOVD R7, R0					
  arithmetic.go:214		0x100205b30		aa0303e1		MOVD R3, R1					
  arithmetic.go:214		0x100205b34		b27e03e2		ORR $4, ZR, R2					
  arithmetic.go:214		0x100205b38		97faecd6		CALL internal/decimal.integral128(SB)		
  compiler_round_test.go:55	0x100205b3c		f9403be2		MOVD 112(RSP), R2				
  compiler_round_test.go:55	0x100205b40		f9402be8		MOVD 80(RSP), R8				
  compiler_round_test.go:55	0x100205b44		f94037e9		MOVD 104(RSP), R9				
  compiler_round_test.go:55	0x100205b48		f94027ea		MOVD 72(RSP), R10				
  compiler_round_test.go:55	0x100205b4c		f94033eb		MOVD 96(RSP), R11				
  compiler_round_test.go:55	0x100205b50		f94023ec		MOVD 64(RSP), R12				
  arithmetic.go:199		0x100205b54		aa0103e3		MOVD R1, R3					
  arithmetic.go:199		0x100205b58		aa0003e7		MOVD R0, R7					
  compiler_round_test.go:55	0x100205b5c		f9402fe0		MOVD 88(RSP), R0				
  compiler_round_test.go:55	0x100205b60		f9403fe1		MOVD 120(RSP), R1				
  compiler_round_test.go:55	0x100205b64		a90a87e0		STP (R0, R1), 168(RSP)				
  compiler_round_test.go:55	0x100205b68		a90b8be8		STP (R8, R2), 184(RSP)				
  compiler_round_test.go:55	0x100205b6c		a90ca7ea		STP (R10, R9), 200(RSP)				
  compiler_round_test.go:55	0x100205b70		a90dafec		STP (R12, R11), 216(RSP)			
  compiler_round_test.go:55	0x100205b74		a90e8fe7		STP (R7, R3), 232(RSP)				
  compiler_round_test.go:55	0x100205b78		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:55	0x100205b7c		f84a07fe		MOVD.P 160(RSP), R30				
  compiler_round_test.go:55	0x100205b80		d65f03c0		RET						
  compiler_round_test.go:54	0x100205b84		a90587e0		STP (R0, R1), 88(RSP)				
  compiler_round_test.go:54	0x100205b88		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:54	0x100205b8c		97fa321d		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:54	0x100205b90		a94587e0		LDP 88(RSP), (R0, R1)				
  compiler_round_test.go:54	0x100205b94		17fffee7		JMP internal/bid_test.compiledIntegral128(SB)	
  compiler_round_test.go:54	0x100205b98		00000000		?						
  compiler_round_test.go:54	0x100205b9c		00000000		?						

TEXT internal/bid_test.compiledTrunc128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:200	0x100206150		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:200	0x100206154		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:200	0x100206158		54000469		BLS 35(PC)					
  compiler_round_test.go:200	0x10020615c		f81c0ffe		MOVD.W R30, -64(RSP)				
  compiler_round_test.go:200	0x100206160		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:200	0x100206164		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:200	0x100206168		92430423		AND $6917529027641081856, R1, R3		
  decimal.go:105		0x10020616c		d503201f		NOOP						
  arithmetic.go:196		0x100206170		d503201f		NOOP						
  arithmetic.go:214		0x100206174		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x100206178		ca040025		EOR R4, R1, R5					
  arithmetic.go:214		0x10020617c		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:214		0x100206180		eb06007f		CMP R6, R3					
  arithmetic.go:214		0x100206184		54000260		BEQ 19(PC)					
  arithmetic.go:214		0x100206188		f240c0bf		TST $562949953421311, R5			
  arithmetic.go:214		0x10020618c		54000221		BNE 17(PC)					
  arithmetic.go:214		0x100206190		d371f8a3		UBFX $49, R5, $14, R3				
  arithmetic.go:214		0x100206194		d2830406		MOVD $6176, R6					
  arithmetic.go:214		0x100206198		eb06007f		CMP R6, R3					
  arithmetic.go:214		0x10020619c		540001e2		BCS 15(PC)					
  arithmetic.go:214		0x1002061a0		d28303e6		MOVD $6175, R6					
  arithmetic.go:214		0x1002061a4		cb0300c3		SUB R3, R6, R3					
  arithmetic.go:214		0x1002061a8		f100487f		CMP $18, R3					
  arithmetic.go:214		0x1002061ac		54000128		BHI 9(PC)					
  arithmetic.go:214		0x1002061b0		90000642		ADRP 819200(PC), R2				
  arithmetic.go:214		0x1002061b4		91268842		ADD $2466, R2, R2				
  arithmetic.go:214		0x1002061b8		f8637842		MOVD (R2)(R3<<3), R2				
  arithmetic.go:214		0x1002061bc		924100a3		AND $-9223372036854775808, R5, R3		
  arithmetic.go:214		0x1002061c0		aa040063		ORR R4, R3, R3					
  arithmetic.go:214		0x1002061c4		9ac20800		UDIV R2, R0, R0					
  arithmetic.go:214		0x1002061c8		ca040061		EOR R4, R3, R1					
  arithmetic.go:214		0x1002061cc		14000003		JMP 3(PC)					
  arithmetic.go:214		0x1002061d0		b27f03e2		ORR $2, ZR, R2					
  arithmetic.go:214		0x1002061d4		97faeb2f		CALL internal/decimal.integral128(SB)		
  compiler_round_test.go:200	0x1002061d8		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:200	0x1002061dc		f84407fe		MOVD.P 64(RSP), R30				
  compiler_round_test.go:200	0x1002061e0		d65f03c0		RET						
  compiler_round_test.go:200	0x1002061e4		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:200	0x1002061e8		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:200	0x1002061ec		97fa3085		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:200	0x1002061f0		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:200	0x1002061f4		17ffffd7		JMP internal/bid_test.compiledTrunc128(SB)	
  compiler_round_test.go:200	0x1002061f8		00000000		?						
  compiler_round_test.go:200	0x1002061fc		00000000		?						

TEXT internal/bid_test.compiledEven128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/compiler_round_test.go
  compiler_round_test.go:203	0x100206200		f9400b90		MOVD 16(R28), R16				
  compiler_round_test.go:203	0x100206204		eb3063ff		CMP R16, RSP					
  compiler_round_test.go:203	0x100206208		540005a9		BLS 45(PC)					
  compiler_round_test.go:203	0x10020620c		f81c0ffe		MOVD.W R30, -64(RSP)				
  compiler_round_test.go:203	0x100206210		f81f83fd		MOVD R29, -8(RSP)				
  compiler_round_test.go:203	0x100206214		d10023fd		SUB $8, RSP, R29				
  compiler_round_test.go:203	0x100206218		92430423		AND $6917529027641081856, R1, R3		
  decimal.go:117		0x10020621c		d503201f		NOOP						
  arithmetic.go:208		0x100206220		d503201f		NOOP						
  arithmetic.go:214		0x100206224		d2e60804		MOVD $3476778912330022912, R4			
  arithmetic.go:214		0x100206228		ca040025		EOR R4, R1, R5					
  arithmetic.go:214		0x10020622c		d2e80006		MOVD $4611686018427387904, R6			
  arithmetic.go:214		0x100206230		eb06007f		CMP R6, R3					
  arithmetic.go:214		0x100206234		540003a0		BEQ 29(PC)					
  arithmetic.go:214		0x100206238		f240c0bf		TST $562949953421311, R5			
  arithmetic.go:214		0x10020623c		54000361		BNE 27(PC)					
  arithmetic.go:214		0x100206240		d371f8a3		UBFX $49, R5, $14, R3				
  arithmetic.go:214		0x100206244		d2830406		MOVD $6176, R6					
  arithmetic.go:214		0x100206248		eb06007f		CMP R6, R3					
  arithmetic.go:214		0x10020624c		54000322		BCS 25(PC)					
  arithmetic.go:214		0x100206250		d28303e6		MOVD $6175, R6					
  arithmetic.go:214		0x100206254		cb0300c3		SUB R3, R6, R3					
  arithmetic.go:214		0x100206258		f100487f		CMP $18, R3					
  arithmetic.go:214		0x10020625c		54000268		BHI 19(PC)					
  arithmetic.go:214		0x100206260		90000642		ADRP 819200(PC), R2				
  arithmetic.go:214		0x100206264		91268842		ADD $2466, R2, R2				
  arithmetic.go:214		0x100206268		f8637842		MOVD (R2)(R3<<3), R2				
  arithmetic.go:214		0x10020626c		9ac20803		UDIV R2, R0, R3					
  arithmetic.go:214		0x100206270		9b038046		MSUB R3, R0, R2, R6				
  arithmetic.go:214		0x100206274		924100a5		AND $-9223372036854775808, R5, R5		
  arithmetic.go:214		0x100206278		aa0400a5		ORR R4, R5, R5					
  arithmetic.go:214		0x10020627c		ca0400a1		EOR R4, R5, R1					
  arithmetic.go:214		0x100206280		eb4204df		CMP R2>>1, R6					
  arithmetic.go:214		0x100206284		9a9f97e2		CSET HI, R2					
  arithmetic.go:214		0x100206288		9a9f17e4		CSET EQ, R4					
  arithmetic.go:214		0x10020628c		f240007f		TST $1, R3					
  arithmetic.go:214		0x100206290		9a9f07e5		CSET NE, R5					
  arithmetic.go:214		0x100206294		8a050084		AND R5, R4, R4					
  arithmetic.go:214		0x100206298		aa040042		ORR R4, R2, R2					
  arithmetic.go:214		0x10020629c		d3401c42		UBFX $0, R2, $8, R2				
  arithmetic.go:214		0x1002062a0		8b020060		ADD R2, R3, R0					
  arithmetic.go:214		0x1002062a4		14000003		JMP 3(PC)					
  arithmetic.go:214		0x1002062a8		aa1f03e2		MOVD ZR, R2					
  arithmetic.go:214		0x1002062ac		97faeaf9		CALL internal/decimal.integral128(SB)		
  compiler_round_test.go:203	0x1002062b0		f85f83fd		MOVD -8(RSP), R29				
  compiler_round_test.go:203	0x1002062b4		f84407fe		MOVD.P 64(RSP), R30				
  compiler_round_test.go:203	0x1002062b8		d65f03c0		RET						
  compiler_round_test.go:203	0x1002062bc		a90087e0		STP (R0, R1), 8(RSP)				
  compiler_round_test.go:203	0x1002062c0		aa1e03e3		MOVD R30, R3					
  compiler_round_test.go:203	0x1002062c4		97fa304f		CALL runtime.morestack_noctxt.abi0(SB)		
  compiler_round_test.go:203	0x1002062c8		a94087e0		LDP 8(RSP), (R0, R1)				
  compiler_round_test.go:203	0x1002062cc		17ffffcd		JMP internal/bid_test.compiledEven128(SB)	
