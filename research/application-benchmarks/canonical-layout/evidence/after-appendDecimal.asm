TEXT strconv.appendDecimal(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:48	0x1000b0c70		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:48	0x1000b0c74		d10203f1		SUB $128, RSP, R17			
  decimal_bid.go:48	0x1000b0c78		eb10023f		CMP R16, R17				
  decimal_bid.go:48	0x1000b0c7c		54002f09		BLS 376(PC)				
  decimal_bid.go:48	0x1000b0c80		d10403f4		SUB $256, RSP, R20			
  decimal_bid.go:48	0x1000b0c84		a93ffa9d		STP (R29, R30), -8(R20)			
  decimal_bid.go:48	0x1000b0c88		9100029f		MOVD R20, RSP				
  decimal_bid.go:48	0x1000b0c8c		d10023fd		SUB $8, RSP, R29			
  decimal_bid.go:61	0x1000b0c90		3904c3e5		MOVB R5, 304(RSP)			
  decimal_bid.go:61	0x1000b0c94		f9009fe6		MOVD R6, 312(RSP)			
  decimal_bid.go:61	0x1000b0c98		a9118fe2		STP (R2, R3), 280(RSP)			
  decimal_bid.go:61	0x1000b0c9c		a91087e0		STP (R0, R1), 264(RSP)			
  encoding.go:50	0x1000b0ca0		d2e60805		MOVD $3476778912330022912, R5		
  encoding.go:50	0x1000b0ca4		ca050081		EOR R5, R4, R1				
  encoding.go:50	0x1000b0ca8		f90047e1		MOVD R1, 136(RSP)			
  decimal_bid.go:53	0x1000b0cac		d503201f		NOOP					
  decimal_bid.go:56	0x1000b0cb0		910197e0		ADD $101, RSP, R0			
  decimal_bid.go:56	0x1000b0cb4		a9007c1f		STP (ZR, ZR), (R0)			
  decimal_bid.go:56	0x1000b0cb8		a9017c1f		STP (ZR, ZR), 16(R0)			
  decimal_bid.go:56	0x1000b0cbc		f801a01f		MOVD ZR, 26(R0)				
  decimal_bid.go:57	0x1000b0cc0		aa0303e2		MOVD R3, R2				
  decimal_bid.go:57	0x1000b0cc4		97fd6d9f		CALL internal/bid.UnpackDigits128(SB)	
  decimal_bid.go:61	0x1000b0cc8		d3401c04		UBFX $0, R0, $8, R4			
  decimal_bid.go:61	0x1000b0ccc		7100049f		CMPW $1, R4				
  decimal_bid.go:61	0x1000b0cd0		54000501		BNE 40(PC)				
  decimal_bid.go:62	0x1000b0cd4		36000281		TBZ $0, R1, 20(PC)			
  decimal_bid.go:63	0x1000b0cd8		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000b0cdc		910010a1		ADD $4, R5, R1				
  decimal_bid.go:63	0x1000b0ce0		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:63	0x1000b0ce4		eb01005f		CMP R1, R2				
  decimal_bid.go:63	0x1000b0ce8		54000063		BCC 3(PC)				
  decimal_bid.go:63	0x1000b0cec		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000b0cf0		14000007		JMP 7(PC)				
  decimal_bid.go:63	0x1000b0cf4		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000b0cf8		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:63	0x1000b0cfc		90001224		ADRP 2375680(PC), R4			
  decimal_bid.go:63	0x1000b0d00		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:63	0x1000b0d04		97ff4af3		CALL runtime.growslice(SB)		
  decimal_bid.go:63	0x1000b0d08		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000b0d0c		d28925a3		MOVD $18733, R3				
  decimal_bid.go:63	0x1000b0d10		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:63	0x1000b0d14		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:63	0x1000b0d18		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:63	0x1000b0d1c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:63	0x1000b0d20		d65f03c0		RET					
  decimal_bid.go:65	0x1000b0d24		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000b0d28		910010a1		ADD $4, R5, R1				
  decimal_bid.go:65	0x1000b0d2c		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:65	0x1000b0d30		eb01005f		CMP R1, R2				
  decimal_bid.go:65	0x1000b0d34		54000063		BCC 3(PC)				
  decimal_bid.go:65	0x1000b0d38		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000b0d3c		14000007		JMP 7(PC)				
  decimal_bid.go:65	0x1000b0d40		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000b0d44		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:65	0x1000b0d48		90001224		ADRP 2375680(PC), R4			
  decimal_bid.go:65	0x1000b0d4c		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:65	0x1000b0d50		97ff4ae0		CALL runtime.growslice(SB)		
  decimal_bid.go:65	0x1000b0d54		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000b0d58		d2892563		MOVD $18731, R3				
  decimal_bid.go:65	0x1000b0d5c		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:65	0x1000b0d60		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:65	0x1000b0d64		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:65	0x1000b0d68		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:65	0x1000b0d6c		d65f03c0		RET					
  decimal_bid.go:59	0x1000b0d70		7100089f		CMPW $2, R4				
  decimal_bid.go:59	0x1000b0d74		540002c1		BNE 22(PC)				
  decimal_bid.go:60	0x1000b0d78		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000b0d7c		91000ca1		ADD $3, R5, R1				
  decimal_bid.go:60	0x1000b0d80		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:60	0x1000b0d84		eb01005f		CMP R1, R2				
  decimal_bid.go:60	0x1000b0d88		54000063		BCC 3(PC)				
  decimal_bid.go:60	0x1000b0d8c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000b0d90		14000007		JMP 7(PC)				
  decimal_bid.go:60	0x1000b0d94		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000b0d98		b24007e3		ORR $3, ZR, R3				
  decimal_bid.go:60	0x1000b0d9c		90001224		ADRP 2375680(PC), R4			
  decimal_bid.go:60	0x1000b0da0		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:60	0x1000b0da4		97ff4acb		CALL runtime.growslice(SB)		
  decimal_bid.go:60	0x1000b0da8		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000b0dac		8b0000a3		ADD R0, R5, R3				
  decimal_bid.go:60	0x1000b0db0		d28c29c4		MOVD $24910, R4				
  decimal_bid.go:60	0x1000b0db4		78256804		MOVH R4, (R0)(R5)			
  decimal_bid.go:60	0x1000b0db8		d28009c4		MOVD $78, R4				
  decimal_bid.go:60	0x1000b0dbc		39000864		MOVB R4, 2(R3)				
  decimal_bid.go:60	0x1000b0dc0		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:60	0x1000b0dc4		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:60	0x1000b0dc8		d65f03c0		RET					
  decimal_bid.go:68	0x1000b0dcc		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:68	0x1000b0dd0		b6f81b60		TBZ $63, R0, 219(PC)			
  decimal_bid.go:233	0x1000b0dd4		3944c3e7		MOVBU 304(RSP), R7			
  decimal_bid.go:233	0x1000b0dd8		aa0703e9		MOVD R7, R9				
  decimal_bid.go:233	0x1000b0ddc		7101153f		CMPW $69, R9				
  decimal_bid.go:233	0x1000b0de0		54000100		BEQ 8(PC)				
  decimal_bid.go:233	0x1000b0de4		71011d3f		CMPW $71, R9				
  decimal_bid.go:233	0x1000b0de8		540000c0		BEQ 6(PC)				
  decimal_bid.go:233	0x1000b0dec		d10194e9		SUB $101, R7, R9			
  decimal_bid.go:233	0x1000b0df0		d3401d29		UBFX $0, R9, $8, R9			
  decimal_bid.go:233	0x1000b0df4		7100093f		CMPW $2, R9				
  decimal_bid.go:233	0x1000b0df8		54000049		BLS 2(PC)				
  decimal_bid.go:233	0x1000b0dfc		d2800ce7		MOVD $103, R7				
  decimal_bid.go:72	0x1000b0e00		d2800449		MOVD $34, R9				
  decimal_bid.go:72	0x1000b0e04		cb020129		SUB R2, R9, R9				
  decimal_bid.go:72	0x1000b0e08		f100893f		CMP $34, R9				
  decimal_bid.go:72	0x1000b0e0c		54002228		BHI 273(PC)				
  decimal_bid.go:72	0x1000b0e10		cb0203ea		NEG R2, R10				
  decimal_bid.go:72	0x1000b0e14		8a8afd29		AND R10->63, R9, R9			
  decimal_bid.go:72	0x1000b0e18		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:72	0x1000b0e1c		8b090149		ADD R9, R10, R9				
  decimal_bid.go:73	0x1000b0e20		b50000c2		CBNZ R2, 6(PC)				
  decimal_bid.go:74	0x1000b0e24		b27c07ea		ORR $48, ZR, R10			
  decimal_bid.go:74	0x1000b0e28		39021fea		MOVB R10, 135(RSP)			
  decimal_bid.go:74	0x1000b0e2c		b24003e0		ORR $1, ZR, R0				
  decimal_bid.go:74	0x1000b0e30		91021fe9		ADD $135, RSP, R9			
  decimal_bid.go:74	0x1000b0e34		14000002		JMP 2(PC)				
  decimal_bid.go:76	0x1000b0e38		aa0203e0		MOVD R2, R0				
  decimal_bid.go:57	0x1000b0e3c		a90983e3		STP (R3, R0), 152(RSP)			
  decimal_bid.go:76	0x1000b0e40		f90077e9		MOVD R9, 232(RSP)			
  decimal_bid.go:76	0x1000b0e44		36000361		TBZ $0, R1, 27(PC)			
  decimal_bid.go:77	0x1000b0e48		f9408bea		MOVD 272(RSP), R10			
  decimal_bid.go:77	0x1000b0e4c		91000541		ADD $1, R10, R1				
  decimal_bid.go:77	0x1000b0e50		f9408fea		MOVD 280(RSP), R10			
  decimal_bid.go:77	0x1000b0e54		eb01015f		CMP R1, R10				
  decimal_bid.go:77	0x1000b0e58		54000063		BCC 3(PC)				
  decimal_bid.go:77	0x1000b0e5c		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:77	0x1000b0e60		14000010		JMP 16(PC)				
  decimal_bid.go:57	0x1000b0e64		f9004be2		MOVD R2, 144(RSP)			
  decimal_bid.go:71	0x1000b0e68		390193e7		MOVB R7, 100(RSP)			
  decimal_bid.go:77	0x1000b0e6c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:77	0x1000b0e70		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:77	0x1000b0e74		b24003e3		ORR $1, ZR, R3				
  decimal_bid.go:77	0x1000b0e78		90001224		ADRP 2375680(PC), R4			
  decimal_bid.go:77	0x1000b0e7c		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:77	0x1000b0e80		97ff4a94		CALL runtime.growslice(SB)		
  decimal_bid.go:81	0x1000b0e84		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:80	0x1000b0e88		394193e7		MOVBU 100(RSP), R7			
  decimal_bid.go:81	0x1000b0e8c		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:77	0x1000b0e90		aa0003e4		MOVD R0, R4				
  decimal_bid.go:77	0x1000b0e94		aa0203ea		MOVD R2, R10				
  decimal_bid.go:81	0x1000b0e98		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:73	0x1000b0e9c		f9404be2		MOVD 144(RSP), R2			
  decimal_bid.go:77	0x1000b0ea0		d100042b		SUB $1, R1, R11				
  decimal_bid.go:77	0x1000b0ea4		d28005ac		MOVD $45, R12				
  decimal_bid.go:77	0x1000b0ea8		382b688c		MOVB R12, (R4)(R11)			
  decimal_bid.go:77	0x1000b0eac		14000003		JMP 3(PC)				
  decimal_bid.go:79	0x1000b0eb0		a9512be1		LDP 272(RSP), (R1, R10)			
  decimal_bid.go:79	0x1000b0eb4		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:80	0x1000b0eb8		d3401ceb		UBFX $0, R7, $8, R11			
  decimal_bid.go:80	0x1000b0ebc		7101157f		CMPW $69, R11				
  decimal_bid.go:80	0x1000b0ec0		54000060		BEQ 3(PC)				
  decimal_bid.go:80	0x1000b0ec4		7101957f		CMPW $101, R11				
  decimal_bid.go:80	0x1000b0ec8		54000181		BNE 12(PC)				
  decimal_bid.go:81	0x1000b0ecc		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:81	0x1000b0ed0		aa0003e5		MOVD R0, R5				
  decimal_bid.go:81	0x1000b0ed4		aa0303e6		MOVD R3, R6				
  decimal_bid.go:81	0x1000b0ed8		92800008		MOVD $-1, R8				
  decimal_bid.go:81	0x1000b0edc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:81	0x1000b0ee0		aa0903e3		MOVD R9, R3				
  decimal_bid.go:81	0x1000b0ee4		aa0503e4		MOVD R5, R4				
  decimal_bid.go:81	0x1000b0ee8		97fff3e2		CALL strconv.appendExp(SB)		
  decimal_bid.go:81	0x1000b0eec		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:81	0x1000b0ef0		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:81	0x1000b0ef4		d65f03c0		RET					
  decimal_bid.go:82	0x1000b0ef8		7101997f		CMPW $102, R11				
  decimal_bid.go:82	0x1000b0efc		54001020		BEQ 129(PC)				
  decimal_bid.go:88	0x1000b0f00		8b00006c		ADD R0, R3, R12				
  decimal_bid.go:89	0x1000b0f04		9100158d		ADD $5, R12, R13			
  decimal_bid.go:89	0x1000b0f08		f1006dbf		CMP $27, R13				
  decimal_bid.go:89	0x1000b0f0c		54000062		BCS 3(PC)				
  decimal_bid.go:89	0x1000b0f10		f100007f		CMP $0, R3				
  decimal_bid.go:89	0x1000b0f14		5400020d		BLE 16(PC)				
  decimal_bid.go:91	0x1000b0f18		71011d7f		CMPW $71, R11				
  decimal_bid.go:94	0x1000b0f1c		d28008ab		MOVD $69, R11				
  decimal_bid.go:94	0x1000b0f20		d2800cac		MOVD $101, R12				
  decimal_bid.go:94	0x1000b0f24		9a8c0167		CSEL EQ, R11, R12, R7			
  decimal_bid.go:94	0x1000b0f28		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:94	0x1000b0f2c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:94	0x1000b0f30		aa0303e6		MOVD R3, R6				
  decimal_bid.go:94	0x1000b0f34		92800008		MOVD $-1, R8				
  decimal_bid.go:94	0x1000b0f38		aa0403e0		MOVD R4, R0				
  decimal_bid.go:94	0x1000b0f3c		aa0903e3		MOVD R9, R3				
  decimal_bid.go:94	0x1000b0f40		aa0503e4		MOVD R5, R4				
  decimal_bid.go:94	0x1000b0f44		97fff3cb		CALL strconv.appendExp(SB)		
  decimal_bid.go:91	0x1000b0f48		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:91	0x1000b0f4c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:91	0x1000b0f50		d65f03c0		RET					
  decimal_bid.go:79	0x1000b0f54		f90057e1		MOVD R1, 168(RSP)			
  decimal_bid.go:96	0x1000b0f58		b50003c3		CBNZ R3, 30(PC)				
  decimal_bid.go:97	0x1000b0f5c		8b000025		ADD R0, R1, R5				
  decimal_bid.go:97	0x1000b0f60		eb05015f		CMP R5, R10				
  decimal_bid.go:97	0x1000b0f64		540001a2		BCS 13(PC)				
  decimal_bid.go:97	0x1000b0f68		aa0503e1		MOVD R5, R1				
  decimal_bid.go:97	0x1000b0f6c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:97	0x1000b0f70		aa0003e3		MOVD R0, R3				
  decimal_bid.go:97	0x1000b0f74		aa0403e0		MOVD R4, R0				
  decimal_bid.go:97	0x1000b0f78		90001224		ADRP 2375680(PC), R4			
  decimal_bid.go:97	0x1000b0f7c		911f8084		ADD $2016, R4, R4			
  decimal_bid.go:97	0x1000b0f80		97ff4a54		CALL runtime.growslice(SB)		
  decimal_bid.go:97	0x1000b0f84		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:97	0x1000b0f88		aa0003e4		MOVD R0, R4				
  decimal_bid.go:97	0x1000b0f8c		aa0203ea		MOVD R2, R10				
  decimal_bid.go:97	0x1000b0f90		aa0103e5		MOVD R1, R5				
  decimal_bid.go:97	0x1000b0f94		a94a07e0		LDP 160(RSP), (R0, R1)			
  decimal_bid.go:97	0x1000b0f98		f90057ea		MOVD R10, 168(RSP)			
  decimal_bid.go:97	0x1000b0f9c		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:97	0x1000b0fa0		f90063e5		MOVD R5, 192(RSP)			
  decimal_bid.go:97	0x1000b0fa4		8b010083		ADD R1, R4, R3				
  decimal_bid.go:97	0x1000b0fa8		aa0903e1		MOVD R9, R1				
  decimal_bid.go:97	0x1000b0fac		aa0003e2		MOVD R0, R2				
  decimal_bid.go:97	0x1000b0fb0		aa0303e0		MOVD R3, R0				
  decimal_bid.go:97	0x1000b0fb4		97ff5e3b		CALL runtime.memmove(SB)		
  decimal_bid.go:97	0x1000b0fb8		f9407be0		MOVD 240(RSP), R0			
  decimal_bid.go:97	0x1000b0fbc		f94063e1		MOVD 192(RSP), R1			
  decimal_bid.go:97	0x1000b0fc0		f94057e2		MOVD 168(RSP), R2			
  decimal_bid.go:97	0x1000b0fc4		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:97	0x1000b0fc8		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:97	0x1000b0fcc		d65f03c0		RET					
  decimal_bid.go:103	0x1000b0fd0		f100019f		CMP $0, R12				
  decimal_bid.go:103	0x1000b0fd4		5400080d		BLE 64(PC)				
  decimal_bid.go:103	0x1000b0fd8		cb010148		SUB R1, R10, R8				
  decimal_bid.go:103	0x1000b0fdc		9100040b		ADD $1, R0, R11				
  decimal_bid.go:103	0x1000b0fe0		eb0b011f		CMP R11, R8				
  decimal_bid.go:103	0x1000b0fe4		5400078b		BLT 60(PC)				
  decimal_bid.go:105	0x1000b0fe8		8b000025		ADD R0, R1, R5				
  decimal_bid.go:105	0x1000b0fec		910004a5		ADD $1, R5, R5				
  decimal_bid.go:105	0x1000b0ff0		eb05015f		CMP R5, R10				
  decimal_bid.go:105	0x1000b0ff4		540012c3		BCC 150(PC)				
  decimal_bid.go:106	0x1000b0ff8		eb05003f		CMP R5, R1				
  decimal_bid.go:106	0x1000b0ffc		54001268		BHI 147(PC)				
  decimal_bid.go:106	0x1000b1000		cb0a0026		SUB R10, R1, R6				
  decimal_bid.go:106	0x1000b1004		8a86fc26		AND R6->63, R1, R6			
  decimal_bid.go:106	0x1000b1008		8b060086		ADD R6, R4, R6				
  decimal_bid.go:106	0x1000b100c		eb0c001f		CMP R12, R0				
  decimal_bid.go:106	0x1000b1010		540011a3		BCC 141(PC)				
  decimal_bid.go:105	0x1000b1014		f90063e5		MOVD R5, 192(RSP)			
  decimal_bid.go:79	0x1000b1018		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:79	0x1000b101c		f9005fea		MOVD R10, 184(RSP)			
  decimal_bid.go:106	0x1000b1020		eb0c017f		CMP R12, R11				
  decimal_bid.go:106	0x1000b1024		9a80c582		CSINC GT, R12, R0, R2			
  decimal_bid.go:106	0x1000b1028		eb06013f		CMP R6, R9				
  decimal_bid.go:106	0x1000b102c		54000160		BEQ 11(PC)				
  decimal_bid.go:88	0x1000b1030		f9005bec		MOVD R12, 176(RSP)			
  decimal_bid.go:106	0x1000b1034		aa0603e0		MOVD R6, R0				
  decimal_bid.go:106	0x1000b1038		aa0903e1		MOVD R9, R1				
  decimal_bid.go:106	0x1000b103c		97ff5e19		CALL runtime.memmove(SB)		
  decimal_bid.go:106	0x1000b1040		a94a07e0		LDP 160(RSP), (R0, R1)			
  decimal_bid.go:108	0x1000b1044		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:107	0x1000b1048		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:107	0x1000b104c		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:108	0x1000b1050		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:108	0x1000b1054		a94b2bec		LDP 176(RSP), (R12, R10)		
  decimal_bid.go:107	0x1000b1058		8b010186		ADD R1, R12, R6				
  decimal_bid.go:107	0x1000b105c		eb0600bf		CMP R6, R5				
  decimal_bid.go:107	0x1000b1060		54000f09		BLS 120(PC)				
  decimal_bid.go:107	0x1000b1064		d28005c7		MOVD $46, R7				
  decimal_bid.go:107	0x1000b1068		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:108	0x1000b106c		cb060147		SUB R6, R10, R7				
  decimal_bid.go:108	0x1000b1070		d10004e7		SUB $1, R7, R7				
  decimal_bid.go:108	0x1000b1074		cb0703e7		NEG R7, R7				
  decimal_bid.go:108	0x1000b1078		910004c6		ADD $1, R6, R6				
  decimal_bid.go:108	0x1000b107c		8a87fcc6		AND R7->63, R6, R6			
  decimal_bid.go:108	0x1000b1080		8b0400c6		ADD R4, R6, R6				
  decimal_bid.go:106	0x1000b1084		eb0c001f		CMP R12, R0				
  decimal_bid.go:108	0x1000b1088		54000da3		BCC 109(PC)				
  decimal_bid.go:108	0x1000b108c		cb0303e7		NEG R3, R7				
  decimal_bid.go:108	0x1000b1090		cb000188		SUB R0, R12, R8				
  decimal_bid.go:108	0x1000b1094		8a88fd88		AND R8->63, R12, R8			
  decimal_bid.go:108	0x1000b1098		8b080121		ADD R8, R9, R1				
  decimal_bid.go:108	0x1000b109c		eb0700ff		CMP R7, R7				
  decimal_bid.go:108	0x1000b10a0		da83b4e2		CSNEG LT, R7, R3, R2			
  decimal_bid.go:108	0x1000b10a4		eb06003f		CMP R6, R1				
  decimal_bid.go:108	0x1000b10a8		540000a0		BEQ 5(PC)				
  decimal_bid.go:108	0x1000b10ac		aa0603e0		MOVD R6, R0				
  decimal_bid.go:108	0x1000b10b0		97ff5dfc		CALL runtime.memmove(SB)		
  decimal_bid.go:109	0x1000b10b4		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:109	0x1000b10b8		a94b97ea		LDP 184(RSP), (R10, R5)			
  decimal_bid.go:109	0x1000b10bc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:109	0x1000b10c0		aa0503e1		MOVD R5, R1				
  decimal_bid.go:109	0x1000b10c4		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:109	0x1000b10c8		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:109	0x1000b10cc		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:109	0x1000b10d0		d65f03c0		RET					
  decimal_bid.go:111	0x1000b10d4		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:111	0x1000b10d8		aa0003e5		MOVD R0, R5				
  decimal_bid.go:111	0x1000b10dc		aa0303e6		MOVD R3, R6				
  decimal_bid.go:111	0x1000b10e0		92800007		MOVD $-1, R7				
  decimal_bid.go:111	0x1000b10e4		aa0403e0		MOVD R4, R0				
  decimal_bid.go:111	0x1000b10e8		aa0903e3		MOVD R9, R3				
  decimal_bid.go:111	0x1000b10ec		aa0503e4		MOVD R5, R4				
  decimal_bid.go:111	0x1000b10f0		97fff1f8		CALL strconv.appendFixed(SB)		
  decimal_bid.go:111	0x1000b10f4		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:111	0x1000b10f8		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:111	0x1000b10fc		d65f03c0		RET					
  decimal_bid.go:73	0x1000b1100		f100005f		CMP $0, R2				
  decimal_bid.go:84	0x1000b1104		f100007f		CMP $0, R3				
  decimal_bid.go:84	0x1000b1108		9a9fd068		CSEL LE, R3, ZR, R8			
  decimal_bid.go:73	0x1000b110c		f100005f		CMP $0, R2				
  decimal_bid.go:86	0x1000b1110		9a830106		CSEL EQ, R8, R3, R6			
  decimal_bid.go:86	0x1000b1114		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:86	0x1000b1118		aa0903e3		MOVD R9, R3				
  decimal_bid.go:86	0x1000b111c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:86	0x1000b1120		92800007		MOVD $-1, R7				
  decimal_bid.go:86	0x1000b1124		aa0403e0		MOVD R4, R0				
  decimal_bid.go:86	0x1000b1128		aa0503e4		MOVD R5, R4				
  decimal_bid.go:86	0x1000b112c		97fff1e9		CALL strconv.appendFixed(SB)		
  decimal_bid.go:83	0x1000b1130		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:83	0x1000b1134		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:83	0x1000b1138		d65f03c0		RET					
  decimal_bid.go:113	0x1000b113c		390323e1		MOVB R1, 200(RSP)			
  decimal_bid.go:113	0x1000b1140		a90d0fe2		STP (R2, R3), 208(RSP)			
  decimal_bid.go:113	0x1000b1144		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:113	0x1000b1148		f90073ea		MOVD R10, 224(RSP)			
  decimal_bid.go:114	0x1000b114c		f100005f		CMP $0, R2				
  decimal_bid.go:114	0x1000b1150		5400024d		BLE 18(PC)				
  decimal_bid.go:233	0x1000b1154		3944c3e3		MOVBU 304(RSP), R3			
  decimal_bid.go:233	0x1000b1158		aa0303e5		MOVD R3, R5				
  decimal_bid.go:233	0x1000b115c		710114bf		CMPW $69, R5				
  decimal_bid.go:233	0x1000b1160		54000100		BEQ 8(PC)				
  decimal_bid.go:233	0x1000b1164		71011cbf		CMPW $71, R5				
  decimal_bid.go:233	0x1000b1168		540000c0		BEQ 6(PC)				
  decimal_bid.go:233	0x1000b116c		d1019465		SUB $101, R3, R5			
  decimal_bid.go:233	0x1000b1170		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:233	0x1000b1174		710008bf		CMPW $2, R5				
  decimal_bid.go:233	0x1000b1178		54000049		BLS 2(PC)				
  decimal_bid.go:233	0x1000b117c		d2800ce3		MOVD $103, R3				
  decimal_bid.go:115	0x1000b1180		f94047e1		MOVD 136(RSP), R1			
  decimal_bid.go:115	0x1000b1184		f94093e2		MOVD 288(RSP), R2			
  decimal_bid.go:115	0x1000b1188		aa0003e4		MOVD R0, R4				
  decimal_bid.go:115	0x1000b118c		910323e0		ADD $200, RSP, R0			
  decimal_bid.go:115	0x1000b1190		97ffeff4		CALL strconv.(*finite).round(SB)	
  decimal_bid.go:120	0x1000b1194		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:117	0x1000b1198		f9406be7		MOVD 208(RSP), R7			
  decimal_bid.go:117	0x1000b119c		b40003a7		CBZ R7, 29(PC)				
  decimal_bid.go:120	0x1000b11a0		f94073ea		MOVD 224(RSP), R10			
  decimal_bid.go:120	0x1000b11a4		3980015b		MOVB (R10), R27				
  decimal_bid.go:120	0x1000b11a8		d280044b		MOVD $34, R11				
  decimal_bid.go:120	0x1000b11ac		cb07016b		SUB R7, R11, R11			
  decimal_bid.go:120	0x1000b11b0		f100897f		CMP $34, R11				
  decimal_bid.go:120	0x1000b11b4		54000408		BHI 32(PC)				
  decimal_bid.go:233	0x1000b11b8		3944c3e8		MOVBU 304(RSP), R8			
  decimal_bid.go:233	0x1000b11bc		aa0803ec		MOVD R8, R12				
  decimal_bid.go:120	0x1000b11c0		8b0b0145		ADD R11, R10, R5			
  decimal_bid.go:233	0x1000b11c4		7101159f		CMPW $69, R12				
  decimal_bid.go:233	0x1000b11c8		54000100		BEQ 8(PC)				
  decimal_bid.go:233	0x1000b11cc		71011d9f		CMPW $71, R12				
  decimal_bid.go:233	0x1000b11d0		540000c0		BEQ 6(PC)				
  decimal_bid.go:233	0x1000b11d4		d101950a		SUB $101, R8, R10			
  decimal_bid.go:233	0x1000b11d8		d3401d4a		UBFX $0, R10, $8, R10			
  decimal_bid.go:233	0x1000b11dc		7100095f		CMPW $2, R10				
  decimal_bid.go:233	0x1000b11e0		54000049		BLS 2(PC)				
  decimal_bid.go:233	0x1000b11e4		d2800ce8		MOVD $103, R8				
  decimal_bid.go:120	0x1000b11e8		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:120	0x1000b11ec		f9406fe4		MOVD 216(RSP), R4			
  decimal_bid.go:120	0x1000b11f0		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:120	0x1000b11f4		aa0703e6		MOVD R7, R6				
  decimal_bid.go:120	0x1000b11f8		aa0003e9		MOVD R0, R9				
  decimal_bid.go:120	0x1000b11fc		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:120	0x1000b1200		97fff144		CALL strconv.formatDigits(SB)		
  decimal_bid.go:120	0x1000b1204		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:120	0x1000b1208		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:120	0x1000b120c		d65f03c0		RET					
  decimal_bid.go:118	0x1000b1210		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:118	0x1000b1214		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:118	0x1000b1218		3944c3e4		MOVBU 304(RSP), R4			
  decimal_bid.go:118	0x1000b121c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:118	0x1000b1220		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:118	0x1000b1224		97fff067		CALL strconv.appendZero(SB)		
  decimal_bid.go:118	0x1000b1228		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:118	0x1000b122c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:118	0x1000b1230		d65f03c0		RET					
  decimal_bid.go:120	0x1000b1234		d2800440		MOVD $34, R0				
  decimal_bid.go:120	0x1000b1238		97ff5d16		CALL runtime.panicBounds(SB)		
  decimal_bid.go:108	0x1000b123c		97ff5d15		CALL runtime.panicBounds(SB)		
  decimal_bid.go:107	0x1000b1240		97ff5d14		CALL runtime.panicBounds(SB)		
  decimal_bid.go:106	0x1000b1244		97ff5d13		CALL runtime.panicBounds(SB)		
  decimal_bid.go:106	0x1000b1248		97ff5d12		CALL runtime.panicBounds(SB)		
  decimal_bid.go:105	0x1000b124c		97ff5d11		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000b1250		d2800440		MOVD $34, R0				
  decimal_bid.go:72	0x1000b1254		97ff5d0f		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000b1258		d503201f		NOOP					
  decimal_bid.go:48	0x1000b125c		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:48	0x1000b1260		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:48	0x1000b1264		f90017e4		MOVD R4, 40(RSP)			
  decimal_bid.go:48	0x1000b1268		3900c3e5		MOVB R5, 48(RSP)			
  decimal_bid.go:48	0x1000b126c		a9039fe6		STP (R6, R7), 56(RSP)			
  decimal_bid.go:48	0x1000b1270		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:48	0x1000b1274		97ff54c3		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:48	0x1000b1278		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:48	0x1000b127c		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:48	0x1000b1280		f94017e4		MOVD 40(RSP), R4			
  decimal_bid.go:48	0x1000b1284		3940c3e5		MOVBU 48(RSP), R5			
  decimal_bid.go:48	0x1000b1288		a9439fe6		LDP 56(RSP), (R6, R7)			
  decimal_bid.go:48	0x1000b128c		17fffe79		JMP strconv.appendDecimal(SB)		
