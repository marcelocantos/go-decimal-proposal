TEXT strconv.appendCanonical(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:239	0x1000ad710		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:239	0x1000ad714		d10083f1		SUB $32, RSP, R17			
  decimal_bid.go:239	0x1000ad718		eb10023f		CMP R16, R17				
  decimal_bid.go:239	0x1000ad71c		540017c9		BLS 190(PC)				
  decimal_bid.go:239	0x1000ad720		f8160ffe		MOVD.W R30, -160(RSP)			
  decimal_bid.go:239	0x1000ad724		f81f83fd		MOVD R29, -8(RSP)			
  decimal_bid.go:239	0x1000ad728		d10023fd		SUB $8, RSP, R29			
  decimal_bid.go:239	0x1000ad72c		f90057e0		MOVD R0, 168(RSP)			
  decimal_bid.go:240	0x1000ad730		a9409865		LDP 8(R3), (R5, R6)			
  decimal_bid.go:240	0x1000ad734		d2800449		MOVD $34, R9				
  decimal_bid.go:240	0x1000ad738		cb050129		SUB R5, R9, R9				
  decimal_bid.go:240	0x1000ad73c		f100893f		CMP $34, R9				
  decimal_bid.go:240	0x1000ad740		54001648		BHI 178(PC)				
  decimal_bid.go:240	0x1000ad744		9100606a		ADD $24, R3, R10			
  decimal_bid.go:240	0x1000ad748		cb0503eb		NEG R5, R11				
  decimal_bid.go:240	0x1000ad74c		8a8bfd29		AND R11->63, R9, R9			
  decimal_bid.go:240	0x1000ad750		8b090149		ADD R9, R10, R9				
  decimal_bid.go:241	0x1000ad754		b50000a5		CBNZ R5, 5(PC)				
  decimal_bid.go:242	0x1000ad758		b27c07ea		ORR $48, ZR, R10			
  decimal_bid.go:242	0x1000ad75c		39015fea		MOVB R10, 87(RSP)			
  decimal_bid.go:242	0x1000ad760		b24003e5		ORR $1, ZR, R5				
  decimal_bid.go:242	0x1000ad764		91015fe9		ADD $87, RSP, R9			
  decimal_bid.go:244	0x1000ad768		f90033e5		MOVD R5, 96(RSP)			
  decimal_bid.go:244	0x1000ad76c		f90047e9		MOVD R9, 136(RSP)			
  decimal_bid.go:240	0x1000ad770		f9002fe6		MOVD R6, 88(RSP)			
  decimal_bid.go:244	0x1000ad774		3940006a		MOVBU (R3), R10				
  decimal_bid.go:244	0x1000ad778		3600022a		TBZ $0, R10, 17(PC)			
  decimal_bid.go:245	0x1000ad77c		91000421		ADD $1, R1, R1				
  decimal_bid.go:245	0x1000ad780		eb01005f		CMP R1, R2				
  decimal_bid.go:245	0x1000ad784		54000162		BCS 11(PC)				
  decimal_bid.go:240	0x1000ad788		f90063e3		MOVD R3, 192(RSP)			
  decimal_bid.go:240	0x1000ad78c		390323e4		MOVB R4, 200(RSP)			
  decimal_bid.go:245	0x1000ad790		b24003e3		ORR $1, ZR, R3				
  decimal_bid.go:245	0x1000ad794		f0001224		ADRP 2387968(PC), R4			
  decimal_bid.go:245	0x1000ad798		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:245	0x1000ad79c		97ff584d		CALL runtime.growslice(SB)		
  decimal_bid.go:251	0x1000ad7a0		f94063e3		MOVD 192(RSP), R3			
  decimal_bid.go:248	0x1000ad7a4		394323e4		MOVBU 200(RSP), R4			
  decimal_bid.go:249	0x1000ad7a8		a94597e6		LDP 88(RSP), (R6, R5)			
  decimal_bid.go:249	0x1000ad7ac		f94047e9		MOVD 136(RSP), R9			
  decimal_bid.go:245	0x1000ad7b0		d100042a		SUB $1, R1, R10				
  decimal_bid.go:245	0x1000ad7b4		d28005ab		MOVD $45, R11				
  decimal_bid.go:245	0x1000ad7b8		382a680b		MOVB R11, (R0)(R10)			
  decimal_bid.go:248	0x1000ad7bc		d3401c8a		UBFX $0, R4, $8, R10			
  decimal_bid.go:248	0x1000ad7c0		7101155f		CMPW $69, R10				
  decimal_bid.go:248	0x1000ad7c4		54000060		BEQ 3(PC)				
  decimal_bid.go:248	0x1000ad7c8		7101955f		CMPW $101, R10				
  decimal_bid.go:248	0x1000ad7cc		54000121		BNE 9(PC)				
  decimal_bid.go:249	0x1000ad7d0		aa0903e3		MOVD R9, R3				
  decimal_bid.go:249	0x1000ad7d4		aa0403e7		MOVD R4, R7				
  decimal_bid.go:249	0x1000ad7d8		92800008		MOVD $-1, R8				
  decimal_bid.go:249	0x1000ad7dc		aa0503e4		MOVD R5, R4				
  decimal_bid.go:249	0x1000ad7e0		94000270		CALL strconv.appendExp(SB)		
  decimal_bid.go:249	0x1000ad7e4		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:249	0x1000ad7e8		f84a07fe		MOVD.P 160(RSP), R30			
  decimal_bid.go:249	0x1000ad7ec		d65f03c0		RET					
  decimal_bid.go:250	0x1000ad7f0		7101995f		CMPW $102, R10				
  decimal_bid.go:250	0x1000ad7f4		54000e60		BEQ 115(PC)				
  decimal_bid.go:256	0x1000ad7f8		8b0500cb		ADD R5, R6, R11				
  decimal_bid.go:257	0x1000ad7fc		9100156c		ADD $5, R11, R12			
  decimal_bid.go:257	0x1000ad800		f1006d9f		CMP $27, R12				
  decimal_bid.go:257	0x1000ad804		54000062		BCS 3(PC)				
  decimal_bid.go:257	0x1000ad808		f10000df		CMP $0, R6				
  decimal_bid.go:257	0x1000ad80c		5400018d		BLE 12(PC)				
  decimal_bid.go:259	0x1000ad810		71011d5f		CMPW $71, R10				
  decimal_bid.go:262	0x1000ad814		d28008aa		MOVD $69, R10				
  decimal_bid.go:262	0x1000ad818		d2800cab		MOVD $101, R11				
  decimal_bid.go:262	0x1000ad81c		9a8b0147		CSEL EQ, R10, R11, R7			
  decimal_bid.go:262	0x1000ad820		aa0903e3		MOVD R9, R3				
  decimal_bid.go:262	0x1000ad824		aa0503e4		MOVD R5, R4				
  decimal_bid.go:262	0x1000ad828		92800008		MOVD $-1, R8				
  decimal_bid.go:262	0x1000ad82c		9400025d		CALL strconv.appendExp(SB)		
  decimal_bid.go:259	0x1000ad830		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:259	0x1000ad834		f84a07fe		MOVD.P 160(RSP), R30			
  decimal_bid.go:259	0x1000ad838		d65f03c0		RET					
  decimal_bid.go:247	0x1000ad83c		f90043e1		MOVD R1, 128(RSP)			
  decimal_bid.go:264	0x1000ad840		b5000326		CBNZ R6, 25(PC)				
  decimal_bid.go:265	0x1000ad844		8b050026		ADD R5, R1, R6				
  decimal_bid.go:265	0x1000ad848		eb06005f		CMP R6, R2				
  decimal_bid.go:265	0x1000ad84c		54000142		BCS 10(PC)				
  decimal_bid.go:265	0x1000ad850		aa0603e1		MOVD R6, R1				
  decimal_bid.go:265	0x1000ad854		aa0503e3		MOVD R5, R3				
  decimal_bid.go:265	0x1000ad858		f0001224		ADRP 2387968(PC), R4			
  decimal_bid.go:265	0x1000ad85c		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:265	0x1000ad860		97ff581c		CALL runtime.growslice(SB)		
  decimal_bid.go:265	0x1000ad864		f94033e5		MOVD 96(RSP), R5			
  decimal_bid.go:265	0x1000ad868		f94047e9		MOVD 136(RSP), R9			
  decimal_bid.go:265	0x1000ad86c		aa0103e6		MOVD R1, R6				
  decimal_bid.go:265	0x1000ad870		f94043e1		MOVD 128(RSP), R1			
  decimal_bid.go:265	0x1000ad874		f90043e6		MOVD R6, 128(RSP)			
  decimal_bid.go:265	0x1000ad878		f9004be0		MOVD R0, 144(RSP)			
  decimal_bid.go:265	0x1000ad87c		f9003fe2		MOVD R2, 120(RSP)			
  decimal_bid.go:265	0x1000ad880		8b010000		ADD R1, R0, R0				
  decimal_bid.go:265	0x1000ad884		aa0903e1		MOVD R9, R1				
  decimal_bid.go:265	0x1000ad888		aa0503e2		MOVD R5, R2				
  decimal_bid.go:265	0x1000ad88c		97ff6c05		CALL runtime.memmove(SB)		
  decimal_bid.go:265	0x1000ad890		f9404be0		MOVD 144(RSP), R0			
  decimal_bid.go:265	0x1000ad894		a94787e2		LDP 120(RSP), (R2, R1)			
  decimal_bid.go:265	0x1000ad898		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:265	0x1000ad89c		f84a07fe		MOVD.P 160(RSP), R30			
  decimal_bid.go:265	0x1000ad8a0		d65f03c0		RET					
  decimal_bid.go:271	0x1000ad8a4		f100017f		CMP $0, R11				
  decimal_bid.go:271	0x1000ad8a8		540007ed		BLE 63(PC)				
  decimal_bid.go:271	0x1000ad8ac		cb010048		SUB R1, R2, R8				
  decimal_bid.go:271	0x1000ad8b0		910004aa		ADD $1, R5, R10				
  decimal_bid.go:271	0x1000ad8b4		eb0a011f		CMP R10, R8				
  decimal_bid.go:271	0x1000ad8b8		5400076b		BLT 59(PC)				
  decimal_bid.go:273	0x1000ad8bc		8b050023		ADD R5, R1, R3				
  decimal_bid.go:273	0x1000ad8c0		91000463		ADD $1, R3, R3				
  decimal_bid.go:273	0x1000ad8c4		eb03005f		CMP R3, R2				
  decimal_bid.go:273	0x1000ad8c8		540009e3		BCC 79(PC)				
  decimal_bid.go:274	0x1000ad8cc		eb03003f		CMP R3, R1				
  decimal_bid.go:274	0x1000ad8d0		54000988		BHI 76(PC)				
  decimal_bid.go:274	0x1000ad8d4		cb020024		SUB R2, R1, R4				
  decimal_bid.go:274	0x1000ad8d8		8a84fc24		AND R4->63, R1, R4			
  decimal_bid.go:274	0x1000ad8dc		8b040004		ADD R4, R0, R4				
  decimal_bid.go:274	0x1000ad8e0		eb0b00bf		CMP R11, R5				
  decimal_bid.go:274	0x1000ad8e4		540008c3		BCC 70(PC)				
  decimal_bid.go:247	0x1000ad8e8		a9070be3		STP (R3, R2), 112(RSP)			
  decimal_bid.go:247	0x1000ad8ec		f9004be0		MOVD R0, 144(RSP)			
  decimal_bid.go:274	0x1000ad8f0		eb0b015f		CMP R11, R10				
  decimal_bid.go:274	0x1000ad8f4		9a85c567		CSINC GT, R11, R5, R7			
  decimal_bid.go:274	0x1000ad8f8		eb04013f		CMP R4, R9				
  decimal_bid.go:274	0x1000ad8fc		54000180		BEQ 12(PC)				
  decimal_bid.go:256	0x1000ad900		f90037eb		MOVD R11, 104(RSP)			
  decimal_bid.go:274	0x1000ad904		aa0403e0		MOVD R4, R0				
  decimal_bid.go:274	0x1000ad908		aa0903e1		MOVD R9, R1				
  decimal_bid.go:274	0x1000ad90c		aa0703e2		MOVD R7, R2				
  decimal_bid.go:274	0x1000ad910		97ff6be4		CALL runtime.memmove(SB)		
  decimal_bid.go:275	0x1000ad914		f9404be0		MOVD 144(RSP), R0			
  decimal_bid.go:275	0x1000ad918		a94787e2		LDP 120(RSP), (R2, R1)			
  decimal_bid.go:275	0x1000ad91c		f9403be3		MOVD 112(RSP), R3			
  decimal_bid.go:274	0x1000ad920		a94597e6		LDP 88(RSP), (R6, R5)			
  decimal_bid.go:276	0x1000ad924		f94047e9		MOVD 136(RSP), R9			
  decimal_bid.go:275	0x1000ad928		f94037eb		MOVD 104(RSP), R11			
  decimal_bid.go:275	0x1000ad92c		8b010164		ADD R1, R11, R4				
  decimal_bid.go:275	0x1000ad930		eb04007f		CMP R4, R3				
  decimal_bid.go:275	0x1000ad934		54000629		BLS 49(PC)				
  decimal_bid.go:275	0x1000ad938		d28005c7		MOVD $46, R7				
  decimal_bid.go:275	0x1000ad93c		38246807		MOVB R7, (R0)(R4)			
  decimal_bid.go:276	0x1000ad940		cb040047		SUB R4, R2, R7				
  decimal_bid.go:276	0x1000ad944		d10004e7		SUB $1, R7, R7				
  decimal_bid.go:276	0x1000ad948		cb0703e7		NEG R7, R7				
  decimal_bid.go:276	0x1000ad94c		91000484		ADD $1, R4, R4				
  decimal_bid.go:276	0x1000ad950		8a87fc84		AND R7->63, R4, R4			
  decimal_bid.go:276	0x1000ad954		8b040004		ADD R4, R0, R4				
  decimal_bid.go:274	0x1000ad958		eb0b00bf		CMP R11, R5				
  decimal_bid.go:276	0x1000ad95c		540004c3		BCC 38(PC)				
  decimal_bid.go:276	0x1000ad960		cb0603e7		NEG R6, R7				
  decimal_bid.go:276	0x1000ad964		cb050165		SUB R5, R11, R5				
  decimal_bid.go:276	0x1000ad968		8a85fd65		AND R5->63, R11, R5			
  decimal_bid.go:276	0x1000ad96c		8b050121		ADD R5, R9, R1				
  decimal_bid.go:276	0x1000ad970		eb0700ff		CMP R7, R7				
  decimal_bid.go:276	0x1000ad974		da86c4e5		CSNEG GT, R7, R6, R5			
  decimal_bid.go:276	0x1000ad978		eb04003f		CMP R4, R1				
  decimal_bid.go:276	0x1000ad97c		540000c0		BEQ 6(PC)				
  decimal_bid.go:276	0x1000ad980		aa0403e0		MOVD R4, R0				
  decimal_bid.go:276	0x1000ad984		aa0503e2		MOVD R5, R2				
  decimal_bid.go:276	0x1000ad988		97ff6bc6		CALL runtime.memmove(SB)		
  decimal_bid.go:277	0x1000ad98c		f9404be0		MOVD 144(RSP), R0			
  decimal_bid.go:277	0x1000ad990		a9470be3		LDP 112(RSP), (R3, R2)			
  decimal_bid.go:277	0x1000ad994		aa0303e1		MOVD R3, R1				
  decimal_bid.go:277	0x1000ad998		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:277	0x1000ad99c		f84a07fe		MOVD.P 160(RSP), R30			
  decimal_bid.go:277	0x1000ad9a0		d65f03c0		RET					
  decimal_bid.go:279	0x1000ad9a4		aa0903e3		MOVD R9, R3				
  decimal_bid.go:279	0x1000ad9a8		aa0503e4		MOVD R5, R4				
  decimal_bid.go:279	0x1000ad9ac		92800007		MOVD $-1, R7				
  decimal_bid.go:279	0x1000ad9b0		94000094		CALL strconv.appendFixed(SB)		
  decimal_bid.go:279	0x1000ad9b4		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:279	0x1000ad9b8		f84a07fe		MOVD.P 160(RSP), R30			
  decimal_bid.go:279	0x1000ad9bc		d65f03c0		RET					
  decimal_bid.go:251	0x1000ad9c0		f9400468		MOVD 8(R3), R8				
  decimal_bid.go:251	0x1000ad9c4		f100011f		CMP $0, R8				
  decimal_bid.go:252	0x1000ad9c8		f10000df		CMP $0, R6				
  decimal_bid.go:252	0x1000ad9cc		9a9fd0ca		CSEL LE, R6, ZR, R10			
  decimal_bid.go:251	0x1000ad9d0		f100011f		CMP $0, R8				
  decimal_bid.go:254	0x1000ad9d4		9a860146		CSEL EQ, R10, R6, R6			
  decimal_bid.go:254	0x1000ad9d8		aa0903e3		MOVD R9, R3				
  decimal_bid.go:254	0x1000ad9dc		aa0503e4		MOVD R5, R4				
  decimal_bid.go:254	0x1000ad9e0		92800007		MOVD $-1, R7				
  decimal_bid.go:254	0x1000ad9e4		94000087		CALL strconv.appendFixed(SB)		
  decimal_bid.go:251	0x1000ad9e8		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:251	0x1000ad9ec		f84a07fe		MOVD.P 160(RSP), R30			
  decimal_bid.go:251	0x1000ad9f0		d65f03c0		RET					
  decimal_bid.go:276	0x1000ad9f4		97ff6b27		CALL runtime.panicBounds(SB)		
  decimal_bid.go:275	0x1000ad9f8		97ff6b26		CALL runtime.panicBounds(SB)		
  decimal_bid.go:274	0x1000ad9fc		97ff6b25		CALL runtime.panicBounds(SB)		
  decimal_bid.go:274	0x1000ada00		97ff6b24		CALL runtime.panicBounds(SB)		
  decimal_bid.go:273	0x1000ada04		97ff6b23		CALL runtime.panicBounds(SB)		
  decimal_bid.go:240	0x1000ada08		d2800440		MOVD $34, R0				
  decimal_bid.go:240	0x1000ada0c		97ff6b21		CALL runtime.panicBounds(SB)		
  decimal_bid.go:240	0x1000ada10		d503201f		NOOP					
  decimal_bid.go:239	0x1000ada14		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:239	0x1000ada18		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:239	0x1000ada1c		3900a3e4		MOVB R4, 40(RSP)			
  decimal_bid.go:239	0x1000ada20		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:239	0x1000ada24		97ff62d7		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:239	0x1000ada28		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:239	0x1000ada2c		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:239	0x1000ada30		3940a3e4		MOVBU 40(RSP), R4			
  decimal_bid.go:239	0x1000ada34		17ffff37		JMP strconv.appendCanonical(SB)		
  decimal_bid.go:239	0x1000ada38		00000000		?					
  decimal_bid.go:239	0x1000ada3c		00000000		?					
