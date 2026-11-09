TEXT strconv.appendDecimal(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:48	0x1000b0fa0		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:48	0x1000b0fa4		d100c3f1		SUB $48, RSP, R17			
  decimal_bid.go:48	0x1000b0fa8		eb10023f		CMP R16, R17				
  decimal_bid.go:48	0x1000b0fac		540014e9		BLS 167(PC)				
  decimal_bid.go:48	0x1000b0fb0		f8150ffe		MOVD.W R30, -176(RSP)			
  decimal_bid.go:48	0x1000b0fb4		f81f83fd		MOVD R29, -8(RSP)			
  decimal_bid.go:48	0x1000b0fb8		d10023fd		SUB $8, RSP, R29			
  decimal_bid.go:62	0x1000b0fbc		390383e5		MOVB R5, 224(RSP)			
  decimal_bid.go:62	0x1000b0fc0		f90077e6		MOVD R6, 232(RSP)			
  decimal_bid.go:62	0x1000b0fc4		a90c8fe2		STP (R2, R3), 200(RSP)			
  decimal_bid.go:62	0x1000b0fc8		a90b87e0		STP (R0, R1), 184(RSP)			
  encoding.go:50	0x1000b0fcc		d2e60805		MOVD $3476778912330022912, R5		
  encoding.go:50	0x1000b0fd0		ca050081		EOR R5, R4, R1				
  encoding.go:50	0x1000b0fd4		f90033e1		MOVD R1, 96(RSP)			
  decimal_bid.go:53	0x1000b0fd8		d503201f		NOOP					
  decimal_bid.go:56	0x1000b0fdc		9101a3e4		ADD $104, RSP, R4			
  decimal_bid.go:56	0x1000b0fe0		a9007c9f		STP (ZR, ZR), (R4)			
  decimal_bid.go:56	0x1000b0fe4		a9017c9f		STP (ZR, ZR), 16(R4)			
  decimal_bid.go:56	0x1000b0fe8		a9027c9f		STP (ZR, ZR), 32(R4)			
  decimal_bid.go:56	0x1000b0fec		a9037c9f		STP (ZR, ZR), 48(R4)			
  decimal_bid.go:57	0x1000b0ff0		910203e0		ADD $128, RSP, R0			
  decimal_bid.go:57	0x1000b0ff4		aa0303e2		MOVD R3, R2				
  decimal_bid.go:57	0x1000b0ff8		97fd6cd2		CALL internal/bid.UnpackDigits128(SB)	
  decimal_bid.go:58	0x1000b0ffc		3901a3e1		MOVB R1, 104(RSP)			
  decimal_bid.go:58	0x1000b1000		a9070fe2		STP (R2, R3), 112(RSP)			
  decimal_bid.go:62	0x1000b1004		d3401c03		UBFX $0, R0, $8, R3			
  decimal_bid.go:62	0x1000b1008		7100047f		CMPW $1, R3				
  decimal_bid.go:62	0x1000b100c		54000501		BNE 40(PC)				
  decimal_bid.go:63	0x1000b1010		36000281		TBZ $0, R1, 20(PC)			
  decimal_bid.go:64	0x1000b1014		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:64	0x1000b1018		910010a1		ADD $4, R5, R1				
  decimal_bid.go:64	0x1000b101c		f94067e2		MOVD 200(RSP), R2			
  decimal_bid.go:64	0x1000b1020		eb01005f		CMP R1, R2				
  decimal_bid.go:64	0x1000b1024		54000063		BCC 3(PC)				
  decimal_bid.go:64	0x1000b1028		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:64	0x1000b102c		14000007		JMP 7(PC)				
  decimal_bid.go:64	0x1000b1030		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:64	0x1000b1034		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:64	0x1000b1038		f0001204		ADRP 2371584(PC), R4			
  decimal_bid.go:64	0x1000b103c		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:64	0x1000b1040		97ff4a24		CALL runtime.growslice(SB)		
  decimal_bid.go:64	0x1000b1044		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:64	0x1000b1048		d28925a3		MOVD $18733, R3				
  decimal_bid.go:64	0x1000b104c		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:64	0x1000b1050		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:64	0x1000b1054		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:64	0x1000b1058		f84b07fe		MOVD.P 176(RSP), R30			
  decimal_bid.go:64	0x1000b105c		d65f03c0		RET					
  decimal_bid.go:66	0x1000b1060		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:66	0x1000b1064		910010a1		ADD $4, R5, R1				
  decimal_bid.go:66	0x1000b1068		f94067e2		MOVD 200(RSP), R2			
  decimal_bid.go:66	0x1000b106c		eb01005f		CMP R1, R2				
  decimal_bid.go:66	0x1000b1070		54000063		BCC 3(PC)				
  decimal_bid.go:66	0x1000b1074		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:66	0x1000b1078		14000007		JMP 7(PC)				
  decimal_bid.go:66	0x1000b107c		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:66	0x1000b1080		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:66	0x1000b1084		f0001204		ADRP 2371584(PC), R4			
  decimal_bid.go:66	0x1000b1088		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:66	0x1000b108c		97ff4a11		CALL runtime.growslice(SB)		
  decimal_bid.go:66	0x1000b1090		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:66	0x1000b1094		d2892563		MOVD $18731, R3				
  decimal_bid.go:66	0x1000b1098		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:66	0x1000b109c		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:66	0x1000b10a0		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:66	0x1000b10a4		f84b07fe		MOVD.P 176(RSP), R30			
  decimal_bid.go:66	0x1000b10a8		d65f03c0		RET					
  decimal_bid.go:60	0x1000b10ac		7100087f		CMPW $2, R3				
  decimal_bid.go:60	0x1000b10b0		540002c1		BNE 22(PC)				
  decimal_bid.go:61	0x1000b10b4		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:61	0x1000b10b8		91000ca1		ADD $3, R5, R1				
  decimal_bid.go:61	0x1000b10bc		f94067e2		MOVD 200(RSP), R2			
  decimal_bid.go:61	0x1000b10c0		eb01005f		CMP R1, R2				
  decimal_bid.go:61	0x1000b10c4		54000063		BCC 3(PC)				
  decimal_bid.go:61	0x1000b10c8		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:61	0x1000b10cc		14000007		JMP 7(PC)				
  decimal_bid.go:61	0x1000b10d0		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:61	0x1000b10d4		b24007e3		ORR $3, ZR, R3				
  decimal_bid.go:61	0x1000b10d8		f0001204		ADRP 2371584(PC), R4			
  decimal_bid.go:61	0x1000b10dc		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:61	0x1000b10e0		97ff49fc		CALL runtime.growslice(SB)		
  decimal_bid.go:61	0x1000b10e4		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:61	0x1000b10e8		8b0000a3		ADD R0, R5, R3				
  decimal_bid.go:61	0x1000b10ec		d28c29c4		MOVD $24910, R4				
  decimal_bid.go:61	0x1000b10f0		78256804		MOVH R4, (R0)(R5)			
  decimal_bid.go:61	0x1000b10f4		d28009c4		MOVD $78, R4				
  decimal_bid.go:61	0x1000b10f8		39000864		MOVB R4, 2(R3)				
  decimal_bid.go:61	0x1000b10fc		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:61	0x1000b1100		f84b07fe		MOVD.P 176(RSP), R30			
  decimal_bid.go:61	0x1000b1104		d65f03c0		RET					
  decimal_bid.go:69	0x1000b1108		f94077e0		MOVD 232(RSP), R0			
  decimal_bid.go:69	0x1000b110c		b6f80260		TBZ $63, R0, 19(PC)			
  decimal_bid.go:191	0x1000b1110		394383e4		MOVBU 224(RSP), R4			
  decimal_bid.go:191	0x1000b1114		aa0403e5		MOVD R4, R5				
  decimal_bid.go:191	0x1000b1118		710114bf		CMPW $69, R5				
  decimal_bid.go:191	0x1000b111c		54000100		BEQ 8(PC)				
  decimal_bid.go:191	0x1000b1120		71011cbf		CMPW $71, R5				
  decimal_bid.go:191	0x1000b1124		540000c0		BEQ 6(PC)				
  decimal_bid.go:191	0x1000b1128		d1019485		SUB $101, R4, R5			
  decimal_bid.go:191	0x1000b112c		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:191	0x1000b1130		710008bf		CMPW $2, R5				
  decimal_bid.go:191	0x1000b1134		54000049		BLS 2(PC)				
  decimal_bid.go:191	0x1000b1138		d2800ce4		MOVD $103, R4				
  decimal_bid.go:70	0x1000b113c		a94b87e0		LDP 184(RSP), (R0, R1)			
  decimal_bid.go:70	0x1000b1140		f94067e2		MOVD 200(RSP), R2			
  decimal_bid.go:70	0x1000b1144		9101a3e3		ADD $104, RSP, R3			
  decimal_bid.go:70	0x1000b1148		97fff172		CALL strconv.appendCanonical(SB)	
  decimal_bid.go:70	0x1000b114c		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:70	0x1000b1150		f84b07fe		MOVD.P 176(RSP), R30			
  decimal_bid.go:70	0x1000b1154		d65f03c0		RET					
  decimal_bid.go:72	0x1000b1158		f100005f		CMP $0, R2				
  decimal_bid.go:72	0x1000b115c		5400024d		BLE 18(PC)				
  decimal_bid.go:191	0x1000b1160		394383e3		MOVBU 224(RSP), R3			
  decimal_bid.go:191	0x1000b1164		aa0303e5		MOVD R3, R5				
  decimal_bid.go:191	0x1000b1168		710114bf		CMPW $69, R5				
  decimal_bid.go:191	0x1000b116c		54000100		BEQ 8(PC)				
  decimal_bid.go:191	0x1000b1170		71011cbf		CMPW $71, R5				
  decimal_bid.go:191	0x1000b1174		540000c0		BEQ 6(PC)				
  decimal_bid.go:191	0x1000b1178		d1019465		SUB $101, R3, R5			
  decimal_bid.go:191	0x1000b117c		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:191	0x1000b1180		710008bf		CMPW $2, R5				
  decimal_bid.go:191	0x1000b1184		54000049		BLS 2(PC)				
  decimal_bid.go:191	0x1000b1188		d2800ce3		MOVD $103, R3				
  decimal_bid.go:73	0x1000b118c		f94033e1		MOVD 96(RSP), R1			
  decimal_bid.go:73	0x1000b1190		f9406be2		MOVD 208(RSP), R2			
  decimal_bid.go:73	0x1000b1194		aa0003e4		MOVD R0, R4				
  decimal_bid.go:73	0x1000b1198		9101a3e0		ADD $104, RSP, R0			
  decimal_bid.go:73	0x1000b119c		97ffeff1		CALL strconv.(*finite).round(SB)	
  decimal_bid.go:78	0x1000b11a0		f94077e0		MOVD 232(RSP), R0			
  decimal_bid.go:75	0x1000b11a4		f9403be7		MOVD 112(RSP), R7			
  decimal_bid.go:75	0x1000b11a8		b4000387		CBZ R7, 28(PC)				
  decimal_bid.go:78	0x1000b11ac		d280044a		MOVD $34, R10				
  decimal_bid.go:78	0x1000b11b0		cb07014a		SUB R7, R10, R10			
  decimal_bid.go:78	0x1000b11b4		f100895f		CMP $34, R10				
  decimal_bid.go:78	0x1000b11b8		54000428		BHI 33(PC)				
  decimal_bid.go:191	0x1000b11bc		394383e8		MOVBU 224(RSP), R8			
  decimal_bid.go:191	0x1000b11c0		aa0803eb		MOVD R8, R11				
  decimal_bid.go:78	0x1000b11c4		910203ec		ADD $128, RSP, R12			
  decimal_bid.go:78	0x1000b11c8		8b0c0145		ADD R12, R10, R5			
  decimal_bid.go:191	0x1000b11cc		7101157f		CMPW $69, R11				
  decimal_bid.go:191	0x1000b11d0		54000100		BEQ 8(PC)				
  decimal_bid.go:191	0x1000b11d4		71011d7f		CMPW $71, R11				
  decimal_bid.go:191	0x1000b11d8		540000c0		BEQ 6(PC)				
  decimal_bid.go:191	0x1000b11dc		d101950a		SUB $101, R8, R10			
  decimal_bid.go:191	0x1000b11e0		d3401d4a		UBFX $0, R10, $8, R10			
  decimal_bid.go:191	0x1000b11e4		7100095f		CMPW $2, R10				
  decimal_bid.go:191	0x1000b11e8		54000049		BLS 2(PC)				
  decimal_bid.go:191	0x1000b11ec		d2800ce8		MOVD $103, R8				
  decimal_bid.go:78	0x1000b11f0		3941a3e3		MOVBU 104(RSP), R3			
  decimal_bid.go:78	0x1000b11f4		f9403fe4		MOVD 120(RSP), R4			
  decimal_bid.go:78	0x1000b11f8		a94c0be1		LDP 192(RSP), (R1, R2)			
  decimal_bid.go:78	0x1000b11fc		aa0703e6		MOVD R7, R6				
  decimal_bid.go:78	0x1000b1200		aa0003e9		MOVD R0, R9				
  decimal_bid.go:78	0x1000b1204		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:78	0x1000b1208		97fff20e		CALL strconv.formatDigits(SB)		
  decimal_bid.go:78	0x1000b120c		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:78	0x1000b1210		f84b07fe		MOVD.P 176(RSP), R30			
  decimal_bid.go:78	0x1000b1214		d65f03c0		RET					
  decimal_bid.go:76	0x1000b1218		3941a3e3		MOVBU 104(RSP), R3			
  decimal_bid.go:76	0x1000b121c		a94c0be1		LDP 192(RSP), (R1, R2)			
  decimal_bid.go:76	0x1000b1220		394383e4		MOVBU 224(RSP), R4			
  decimal_bid.go:76	0x1000b1224		aa0003e5		MOVD R0, R5				
  decimal_bid.go:76	0x1000b1228		f9405fe0		MOVD 184(RSP), R0			
  decimal_bid.go:76	0x1000b122c		97fff065		CALL strconv.appendZero(SB)		
  decimal_bid.go:76	0x1000b1230		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:76	0x1000b1234		f84b07fe		MOVD.P 176(RSP), R30			
  decimal_bid.go:76	0x1000b1238		d65f03c0		RET					
  decimal_bid.go:78	0x1000b123c		d2800440		MOVD $34, R0				
  decimal_bid.go:78	0x1000b1240		97ff5d14		CALL runtime.panicBounds(SB)		
  decimal_bid.go:78	0x1000b1244		d503201f		NOOP					
  decimal_bid.go:48	0x1000b1248		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:48	0x1000b124c		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:48	0x1000b1250		f90017e4		MOVD R4, 40(RSP)			
  decimal_bid.go:48	0x1000b1254		3900c3e5		MOVB R5, 48(RSP)			
  decimal_bid.go:48	0x1000b1258		a9039fe6		STP (R6, R7), 56(RSP)			
  decimal_bid.go:48	0x1000b125c		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:48	0x1000b1260		97ff54c8		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:48	0x1000b1264		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:48	0x1000b1268		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:48	0x1000b126c		f94017e4		MOVD 40(RSP), R4			
  decimal_bid.go:48	0x1000b1270		3940c3e5		MOVBU 48(RSP), R5			
  decimal_bid.go:48	0x1000b1274		a9439fe6		LDP 56(RSP), (R6, R7)			
  decimal_bid.go:48	0x1000b1278		17ffff4a		JMP strconv.appendDecimal(SB)		
  decimal_bid.go:48	0x1000b127c		00000000		?					
