TEXT strconv.appendDecimal(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:48	0x1000bb170		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:48	0x1000bb174		d101c3f1		SUB $112, RSP, R17			
  decimal_bid.go:48	0x1000bb178		eb10023f		CMP R16, R17				
  decimal_bid.go:48	0x1000bb17c		54003a89		BLS 468(PC)				
  decimal_bid.go:48	0x1000bb180		f8110ffe		MOVD.W R30, -240(RSP)			
  decimal_bid.go:48	0x1000bb184		f81f83fd		MOVD R29, -8(RSP)			
  decimal_bid.go:48	0x1000bb188		d10023fd		SUB $8, RSP, R29			
  decimal_bid.go:61	0x1000bb18c		390483e5		MOVB R5, 288(RSP)			
  decimal_bid.go:61	0x1000bb190		f90097e6		MOVD R6, 296(RSP)			
  decimal_bid.go:61	0x1000bb194		a9100be1		STP (R1, R2), 256(RSP)			
  decimal_bid.go:61	0x1000bb198		f9007fe0		MOVD R0, 248(RSP)			
  decimal_bid.go:61	0x1000bb19c		f9008be3		MOVD R3, 272(RSP)			
  encoding.go:50	0x1000bb1a0		d2e60805		MOVD $3476778912330022912, R5		
  encoding.go:50	0x1000bb1a4		ca050081		EOR R5, R4, R1				
  encoding.go:50	0x1000bb1a8		f90047e1		MOVD R1, 136(RSP)			
  decimal_bid.go:53	0x1000bb1ac		d503201f		NOOP					
  decimal_bid.go:56	0x1000bb1b0		910197e0		ADD $101, RSP, R0			
  decimal_bid.go:56	0x1000bb1b4		a9007c1f		STP (ZR, ZR), (R0)			
  decimal_bid.go:56	0x1000bb1b8		a9017c1f		STP (ZR, ZR), 16(R0)			
  decimal_bid.go:56	0x1000bb1bc		f801a01f		MOVD ZR, 26(R0)				
  decimal_bid.go:57	0x1000bb1c0		aa0303e2		MOVD R3, R2				
  decimal_bid.go:57	0x1000bb1c4		97fd4c63		CALL internal/bid.UnpackDigits128(SB)	
  decimal_bid.go:61	0x1000bb1c8		d3401c04		UBFX $0, R0, $8, R4			
  decimal_bid.go:61	0x1000bb1cc		7100049f		CMPW $1, R4				
  decimal_bid.go:61	0x1000bb1d0		54002160		BEQ 267(PC)				
  decimal_bid.go:59	0x1000bb1d4		7100089f		CMPW $2, R4				
  decimal_bid.go:59	0x1000bb1d8		54001e80		BEQ 244(PC)				
  decimal_bid.go:68	0x1000bb1dc		f94097e0		MOVD 296(RSP), R0			
  decimal_bid.go:68	0x1000bb1e0		b6f81680		TBZ $63, R0, 180(PC)			
  decimal_bid.go:262	0x1000bb1e4		394483e7		MOVBU 288(RSP), R7			
  decimal_bid.go:262	0x1000bb1e8		aa0703e9		MOVD R7, R9				
  decimal_bid.go:262	0x1000bb1ec		7101153f		CMPW $69, R9				
  decimal_bid.go:262	0x1000bb1f0		54000100		BEQ 8(PC)				
  decimal_bid.go:262	0x1000bb1f4		71011d3f		CMPW $71, R9				
  decimal_bid.go:262	0x1000bb1f8		540000c0		BEQ 6(PC)				
  decimal_bid.go:262	0x1000bb1fc		d10194e9		SUB $101, R7, R9			
  decimal_bid.go:262	0x1000bb200		d3401d29		UBFX $0, R9, $8, R9			
  decimal_bid.go:262	0x1000bb204		7100093f		CMPW $2, R9				
  decimal_bid.go:262	0x1000bb208		54000049		BLS 2(PC)				
  decimal_bid.go:262	0x1000bb20c		d2800ce7		MOVD $103, R7				
  decimal_bid.go:72	0x1000bb210		d2800449		MOVD $34, R9				
  decimal_bid.go:72	0x1000bb214		cb020129		SUB R2, R9, R9				
  decimal_bid.go:72	0x1000bb218		f100893f		CMP $34, R9				
  decimal_bid.go:72	0x1000bb21c		54003528		BHI 425(PC)				
  decimal_bid.go:72	0x1000bb220		cb0203ea		NEG R2, R10				
  decimal_bid.go:72	0x1000bb224		8a8afd29		AND R10->63, R9, R9			
  decimal_bid.go:72	0x1000bb228		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:72	0x1000bb22c		8b090149		ADD R9, R10, R9				
  decimal_bid.go:73	0x1000bb230		b50000c2		CBNZ R2, 6(PC)				
  decimal_bid.go:74	0x1000bb234		b27c07ea		ORR $48, ZR, R10			
  decimal_bid.go:74	0x1000bb238		39021fea		MOVB R10, 135(RSP)			
  decimal_bid.go:74	0x1000bb23c		b24003e0		ORR $1, ZR, R0				
  decimal_bid.go:74	0x1000bb240		91021fe9		ADD $135, RSP, R9			
  decimal_bid.go:74	0x1000bb244		14000002		JMP 2(PC)				
  decimal_bid.go:76	0x1000bb248		aa0203e0		MOVD R2, R0				
  decimal_bid.go:76	0x1000bb24c		f9006fe9		MOVD R9, 216(RSP)			
  decimal_bid.go:76	0x1000bb250		f90053e0		MOVD R0, 160(RSP)			
  decimal_bid.go:76	0x1000bb254		36000361		TBZ $0, R1, 27(PC)			
  decimal_bid.go:77	0x1000bb258		f94083ea		MOVD 256(RSP), R10			
  decimal_bid.go:77	0x1000bb25c		91000541		ADD $1, R10, R1				
  decimal_bid.go:77	0x1000bb260		f94087ea		MOVD 264(RSP), R10			
  decimal_bid.go:77	0x1000bb264		eb01015f		CMP R1, R10				
  decimal_bid.go:77	0x1000bb268		54000063		BCC 3(PC)				
  decimal_bid.go:77	0x1000bb26c		f9407fe4		MOVD 248(RSP), R4			
  decimal_bid.go:77	0x1000bb270		14000010		JMP 16(PC)				
  decimal_bid.go:57	0x1000bb274		a9090fe2		STP (R2, R3), 144(RSP)			
  decimal_bid.go:71	0x1000bb278		390193e7		MOVB R7, 100(RSP)			
  decimal_bid.go:77	0x1000bb27c		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:77	0x1000bb280		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:77	0x1000bb284		b24003e3		ORR $1, ZR, R3				
  decimal_bid.go:77	0x1000bb288		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:77	0x1000bb28c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:77	0x1000bb290		97ff2e70		CALL runtime.growslice(SB)		
  decimal_bid.go:88	0x1000bb294		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:80	0x1000bb298		394193e7		MOVBU 100(RSP), R7			
  decimal_bid.go:112	0x1000bb29c		f9406fe9		MOVD 216(RSP), R9			
  decimal_bid.go:77	0x1000bb2a0		aa0003e4		MOVD R0, R4				
  decimal_bid.go:77	0x1000bb2a4		aa0203ea		MOVD R2, R10				
  decimal_bid.go:88	0x1000bb2a8		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:73	0x1000bb2ac		f9404be2		MOVD 144(RSP), R2			
  decimal_bid.go:77	0x1000bb2b0		d100042b		SUB $1, R1, R11				
  decimal_bid.go:77	0x1000bb2b4		d28005ac		MOVD $45, R12				
  decimal_bid.go:77	0x1000bb2b8		382b688c		MOVB R12, (R4)(R11)			
  decimal_bid.go:77	0x1000bb2bc		14000003		JMP 3(PC)				
  decimal_bid.go:79	0x1000bb2c0		a9502be1		LDP 256(RSP), (R1, R10)			
  decimal_bid.go:79	0x1000bb2c4		f9407fe4		MOVD 248(RSP), R4			
  decimal_bid.go:80	0x1000bb2c8		d3401ceb		UBFX $0, R7, $8, R11			
  decimal_bid.go:80	0x1000bb2cc		7101157f		CMPW $69, R11				
  decimal_bid.go:80	0x1000bb2d0		54000da0		BEQ 109(PC)				
  decimal_bid.go:80	0x1000bb2d4		7101957f		CMPW $101, R11				
  decimal_bid.go:80	0x1000bb2d8		54000d60		BEQ 107(PC)				
  decimal_bid.go:82	0x1000bb2dc		7101997f		CMPW $102, R11				
  decimal_bid.go:82	0x1000bb2e0		54000b40		BEQ 90(PC)				
  decimal_bid.go:88	0x1000bb2e4		8b00006c		ADD R0, R3, R12				
  decimal_bid.go:89	0x1000bb2e8		9100158d		ADD $5, R12, R13			
  decimal_bid.go:89	0x1000bb2ec		f1006dbf		CMP $27, R13				
  decimal_bid.go:89	0x1000bb2f0		540008e2		BCS 71(PC)				
  decimal_bid.go:89	0x1000bb2f4		f100007f		CMP $0, R3				
  decimal_bid.go:89	0x1000bb2f8		540008ac		BGT 69(PC)				
  decimal_bid.go:96	0x1000bb2fc		b40004e3		CBZ R3, 39(PC)				
  decimal_bid.go:103	0x1000bb300		f100019f		CMP $0, R12				
  decimal_bid.go:103	0x1000bb304		5400034d		BLE 26(PC)				
  decimal_bid.go:103	0x1000bb308		cb010148		SUB R1, R10, R8				
  decimal_bid.go:103	0x1000bb30c		9100040b		ADD $1, R0, R11				
  decimal_bid.go:103	0x1000bb310		eb0b011f		CMP R11, R8				
  decimal_bid.go:103	0x1000bb314		540002cb		BLT 22(PC)				
  decimal_bid.go:105	0x1000bb318		8b000025		ADD R0, R1, R5				
  decimal_bid.go:105	0x1000bb31c		910004a5		ADD $1, R5, R5				
  decimal_bid.go:105	0x1000bb320		eb05015f		CMP R5, R10				
  decimal_bid.go:105	0x1000bb324		54002cc3		BCC 358(PC)				
  decimal_bid.go:110	0x1000bb328		f100241f		CMP $9, R0				
  decimal_bid.go:110	0x1000bb32c		5400006c		BGT 3(PC)				
  decimal_bid.go:110	0x1000bb330		aa1f03e3		MOVD ZR, R3				
  decimal_bid.go:110	0x1000bb334		14000146		JMP 326(PC)				
  decimal_bid.go:119	0x1000bb338		eb05003f		CMP R5, R1				
  decimal_bid.go:119	0x1000bb33c		54002828		BHI 321(PC)				
  decimal_bid.go:119	0x1000bb340		cb0a0026		SUB R10, R1, R6				
  decimal_bid.go:119	0x1000bb344		8a86fc26		AND R6->63, R1, R6			
  decimal_bid.go:119	0x1000bb348		8b060086		ADD R6, R4, R6				
  decimal_bid.go:119	0x1000bb34c		eb0c001f		CMP R12, R0				
  decimal_bid.go:119	0x1000bb350		54002763		BCC 315(PC)				
  decimal_bid.go:140	0x1000bb354		eb0c011f		CMP R12, R8				
  decimal_bid.go:140	0x1000bb358		54002703		BCC 312(PC)				
  decimal_bid.go:88	0x1000bb35c		aa0c03e2		MOVD R12, R2				
  decimal_bid.go:76	0x1000bb360		aa0903e7		MOVD R9, R7				
  decimal_bid.go:76	0x1000bb364		aa0003eb		MOVD R0, R11				
  decimal_bid.go:142	0x1000bb368		140000d9		JMP 217(PC)				
  decimal_bid.go:125	0x1000bb36c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:125	0x1000bb370		aa0003e5		MOVD R0, R5				
  decimal_bid.go:125	0x1000bb374		aa0303e6		MOVD R3, R6				
  decimal_bid.go:125	0x1000bb378		92800007		MOVD $-1, R7				
  decimal_bid.go:125	0x1000bb37c		aa0403e0		MOVD R4, R0				
  decimal_bid.go:125	0x1000bb380		aa0903e3		MOVD R9, R3				
  decimal_bid.go:125	0x1000bb384		aa0503e4		MOVD R5, R4				
  decimal_bid.go:125	0x1000bb388		97fff18a		CALL strconv.appendFixed(SB)		
  decimal_bid.go:125	0x1000bb38c		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:125	0x1000bb390		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:125	0x1000bb394		d65f03c0		RET					
  decimal_bid.go:97	0x1000bb398		8b000025		ADD R0, R1, R5				
  decimal_bid.go:97	0x1000bb39c		eb05015f		CMP R5, R10				
  decimal_bid.go:97	0x1000bb3a0		540001e2		BCS 15(PC)				
  decimal_bid.go:79	0x1000bb3a4		f9005be1		MOVD R1, 176(RSP)			
  decimal_bid.go:97	0x1000bb3a8		aa0503e1		MOVD R5, R1				
  decimal_bid.go:97	0x1000bb3ac		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:97	0x1000bb3b0		aa0003e3		MOVD R0, R3				
  decimal_bid.go:97	0x1000bb3b4		aa0403e0		MOVD R4, R0				
  decimal_bid.go:97	0x1000bb3b8		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:97	0x1000bb3bc		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:97	0x1000bb3c0		97ff2e24		CALL runtime.growslice(SB)		
  decimal_bid.go:97	0x1000bb3c4		f9406fe9		MOVD 216(RSP), R9			
  decimal_bid.go:97	0x1000bb3c8		aa0003e4		MOVD R0, R4				
  decimal_bid.go:97	0x1000bb3cc		aa0203ea		MOVD R2, R10				
  decimal_bid.go:97	0x1000bb3d0		aa0103e5		MOVD R1, R5				
  decimal_bid.go:97	0x1000bb3d4		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:97	0x1000bb3d8		f9405be1		MOVD 176(RSP), R1			
  decimal_bid.go:97	0x1000bb3dc		f90073e4		MOVD R4, 224(RSP)			
  decimal_bid.go:97	0x1000bb3e0		a90aabe5		STP (R5, R10), 168(RSP)			
  decimal_bid.go:97	0x1000bb3e4		8b010083		ADD R1, R4, R3				
  decimal_bid.go:97	0x1000bb3e8		aa0903e1		MOVD R9, R1				
  decimal_bid.go:97	0x1000bb3ec		aa0003e2		MOVD R0, R2				
  decimal_bid.go:97	0x1000bb3f0		aa0303e0		MOVD R3, R0				
  decimal_bid.go:97	0x1000bb3f4		97ff426f		CALL runtime.memmove(SB)		
  decimal_bid.go:97	0x1000bb3f8		f94073e0		MOVD 224(RSP), R0			
  decimal_bid.go:97	0x1000bb3fc		a94a8be1		LDP 168(RSP), (R1, R2)			
  decimal_bid.go:97	0x1000bb400		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:97	0x1000bb404		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:97	0x1000bb408		d65f03c0		RET					
  decimal_bid.go:91	0x1000bb40c		71011d7f		CMPW $71, R11				
  decimal_bid.go:94	0x1000bb410		d28008ab		MOVD $69, R11				
  decimal_bid.go:94	0x1000bb414		d2800cac		MOVD $101, R12				
  decimal_bid.go:94	0x1000bb418		9a8c0167		CSEL EQ, R11, R12, R7			
  decimal_bid.go:94	0x1000bb41c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:94	0x1000bb420		aa0003e5		MOVD R0, R5				
  decimal_bid.go:94	0x1000bb424		aa0303e6		MOVD R3, R6				
  decimal_bid.go:94	0x1000bb428		92800008		MOVD $-1, R8				
  decimal_bid.go:94	0x1000bb42c		aa0403e0		MOVD R4, R0				
  decimal_bid.go:94	0x1000bb430		aa0903e3		MOVD R9, R3				
  decimal_bid.go:94	0x1000bb434		aa0503e4		MOVD R5, R4				
  decimal_bid.go:94	0x1000bb438		97fff2c6		CALL strconv.appendExp(SB)		
  decimal_bid.go:91	0x1000bb43c		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:91	0x1000bb440		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:91	0x1000bb444		d65f03c0		RET					
  decimal_bid.go:73	0x1000bb448		f100005f		CMP $0, R2				
  decimal_bid.go:84	0x1000bb44c		f100007f		CMP $0, R3				
  decimal_bid.go:84	0x1000bb450		9a9fd068		CSEL LE, R3, ZR, R8			
  decimal_bid.go:73	0x1000bb454		f100005f		CMP $0, R2				
  decimal_bid.go:86	0x1000bb458		9a830106		CSEL EQ, R8, R3, R6			
  decimal_bid.go:86	0x1000bb45c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:86	0x1000bb460		aa0903e3		MOVD R9, R3				
  decimal_bid.go:86	0x1000bb464		aa0003e5		MOVD R0, R5				
  decimal_bid.go:86	0x1000bb468		92800007		MOVD $-1, R7				
  decimal_bid.go:86	0x1000bb46c		aa0403e0		MOVD R4, R0				
  decimal_bid.go:86	0x1000bb470		aa0503e4		MOVD R5, R4				
  decimal_bid.go:86	0x1000bb474		97fff14f		CALL strconv.appendFixed(SB)		
  decimal_bid.go:83	0x1000bb478		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:83	0x1000bb47c		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:83	0x1000bb480		d65f03c0		RET					
  decimal_bid.go:81	0x1000bb484		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:81	0x1000bb488		aa0003e5		MOVD R0, R5				
  decimal_bid.go:81	0x1000bb48c		aa0303e6		MOVD R3, R6				
  decimal_bid.go:81	0x1000bb490		92800008		MOVD $-1, R8				
  decimal_bid.go:81	0x1000bb494		aa0403e0		MOVD R4, R0				
  decimal_bid.go:81	0x1000bb498		aa0903e3		MOVD R9, R3				
  decimal_bid.go:81	0x1000bb49c		aa0503e4		MOVD R5, R4				
  decimal_bid.go:81	0x1000bb4a0		97fff2ac		CALL strconv.appendExp(SB)		
  decimal_bid.go:81	0x1000bb4a4		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:81	0x1000bb4a8		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:81	0x1000bb4ac		d65f03c0		RET					
  decimal_bid.go:127	0x1000bb4b0		3902e3e1		MOVB R1, 184(RSP)			
  decimal_bid.go:127	0x1000bb4b4		a90c0fe2		STP (R2, R3), 192(RSP)			
  decimal_bid.go:127	0x1000bb4b8		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:127	0x1000bb4bc		f9006bea		MOVD R10, 208(RSP)			
  decimal_bid.go:128	0x1000bb4c0		f100005f		CMP $0, R2				
  decimal_bid.go:128	0x1000bb4c4		5400024d		BLE 18(PC)				
  decimal_bid.go:262	0x1000bb4c8		394483e3		MOVBU 288(RSP), R3			
  decimal_bid.go:262	0x1000bb4cc		aa0303e5		MOVD R3, R5				
  decimal_bid.go:262	0x1000bb4d0		710114bf		CMPW $69, R5				
  decimal_bid.go:262	0x1000bb4d4		54000100		BEQ 8(PC)				
  decimal_bid.go:262	0x1000bb4d8		71011cbf		CMPW $71, R5				
  decimal_bid.go:262	0x1000bb4dc		540000c0		BEQ 6(PC)				
  decimal_bid.go:262	0x1000bb4e0		d1019465		SUB $101, R3, R5			
  decimal_bid.go:262	0x1000bb4e4		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:262	0x1000bb4e8		710008bf		CMPW $2, R5				
  decimal_bid.go:262	0x1000bb4ec		54000049		BLS 2(PC)				
  decimal_bid.go:262	0x1000bb4f0		d2800ce3		MOVD $103, R3				
  decimal_bid.go:129	0x1000bb4f4		f94047e1		MOVD 136(RSP), R1			
  decimal_bid.go:129	0x1000bb4f8		f9408be2		MOVD 272(RSP), R2			
  decimal_bid.go:129	0x1000bb4fc		aa0003e4		MOVD R0, R4				
  decimal_bid.go:129	0x1000bb500		9102e3e0		ADD $184, RSP, R0			
  decimal_bid.go:129	0x1000bb504		97ffef4f		CALL strconv.(*finite).round(SB)	
  decimal_bid.go:134	0x1000bb508		f94097e0		MOVD 296(RSP), R0			
  decimal_bid.go:131	0x1000bb50c		f94063e7		MOVD 192(RSP), R7			
  decimal_bid.go:131	0x1000bb510		b40003a7		CBZ R7, 29(PC)				
  decimal_bid.go:134	0x1000bb514		f9406bea		MOVD 208(RSP), R10			
  decimal_bid.go:134	0x1000bb518		3980015b		MOVB (R10), R27				
  decimal_bid.go:134	0x1000bb51c		d280044b		MOVD $34, R11				
  decimal_bid.go:134	0x1000bb520		cb07016b		SUB R7, R11, R11			
  decimal_bid.go:134	0x1000bb524		f100897f		CMP $34, R11				
  decimal_bid.go:134	0x1000bb528		54000b88		BHI 92(PC)				
  decimal_bid.go:262	0x1000bb52c		394483e8		MOVBU 288(RSP), R8			
  decimal_bid.go:262	0x1000bb530		aa0803ec		MOVD R8, R12				
  decimal_bid.go:134	0x1000bb534		8b0b0145		ADD R11, R10, R5			
  decimal_bid.go:262	0x1000bb538		7101159f		CMPW $69, R12				
  decimal_bid.go:262	0x1000bb53c		54000100		BEQ 8(PC)				
  decimal_bid.go:262	0x1000bb540		71011d9f		CMPW $71, R12				
  decimal_bid.go:262	0x1000bb544		540000c0		BEQ 6(PC)				
  decimal_bid.go:262	0x1000bb548		d101950a		SUB $101, R8, R10			
  decimal_bid.go:262	0x1000bb54c		d3401d4a		UBFX $0, R10, $8, R10			
  decimal_bid.go:262	0x1000bb550		7100095f		CMPW $2, R10				
  decimal_bid.go:262	0x1000bb554		54000049		BLS 2(PC)				
  decimal_bid.go:262	0x1000bb558		d2800ce8		MOVD $103, R8				
  decimal_bid.go:134	0x1000bb55c		3942e3e3		MOVBU 184(RSP), R3			
  decimal_bid.go:134	0x1000bb560		f94067e4		MOVD 200(RSP), R4			
  decimal_bid.go:134	0x1000bb564		a9500be1		LDP 256(RSP), (R1, R2)			
  decimal_bid.go:134	0x1000bb568		aa0703e6		MOVD R7, R6				
  decimal_bid.go:134	0x1000bb56c		aa0003e9		MOVD R0, R9				
  decimal_bid.go:134	0x1000bb570		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:134	0x1000bb574		97fff09f		CALL strconv.formatDigits(SB)		
  decimal_bid.go:134	0x1000bb578		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:134	0x1000bb57c		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:134	0x1000bb580		d65f03c0		RET					
  decimal_bid.go:132	0x1000bb584		3942e3e3		MOVBU 184(RSP), R3			
  decimal_bid.go:132	0x1000bb588		a9500be1		LDP 256(RSP), (R1, R2)			
  decimal_bid.go:132	0x1000bb58c		394483e4		MOVBU 288(RSP), R4			
  decimal_bid.go:132	0x1000bb590		aa0003e5		MOVD R0, R5				
  decimal_bid.go:132	0x1000bb594		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:132	0x1000bb598		97ffefc2		CALL strconv.appendZero(SB)		
  decimal_bid.go:132	0x1000bb59c		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:132	0x1000bb5a0		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:132	0x1000bb5a4		d65f03c0		RET					
  decimal_bid.go:60	0x1000bb5a8		f94083e5		MOVD 256(RSP), R5			
  decimal_bid.go:60	0x1000bb5ac		91000ca1		ADD $3, R5, R1				
  decimal_bid.go:60	0x1000bb5b0		f94087e2		MOVD 264(RSP), R2			
  decimal_bid.go:60	0x1000bb5b4		eb01005f		CMP R1, R2				
  decimal_bid.go:60	0x1000bb5b8		54000063		BCC 3(PC)				
  decimal_bid.go:60	0x1000bb5bc		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:60	0x1000bb5c0		14000007		JMP 7(PC)				
  decimal_bid.go:60	0x1000bb5c4		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:60	0x1000bb5c8		b24007e3		ORR $3, ZR, R3				
  decimal_bid.go:60	0x1000bb5cc		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:60	0x1000bb5d0		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:60	0x1000bb5d4		97ff2d9f		CALL runtime.growslice(SB)		
  decimal_bid.go:60	0x1000bb5d8		f94083e5		MOVD 256(RSP), R5			
  decimal_bid.go:60	0x1000bb5dc		8b0000a3		ADD R0, R5, R3				
  decimal_bid.go:60	0x1000bb5e0		d28c29c4		MOVD $24910, R4				
  decimal_bid.go:60	0x1000bb5e4		78256804		MOVH R4, (R0)(R5)			
  decimal_bid.go:60	0x1000bb5e8		d28009c4		MOVD $78, R4				
  decimal_bid.go:60	0x1000bb5ec		39000864		MOVB R4, 2(R3)				
  decimal_bid.go:60	0x1000bb5f0		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:60	0x1000bb5f4		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:60	0x1000bb5f8		d65f03c0		RET					
  decimal_bid.go:62	0x1000bb5fc		36000281		TBZ $0, R1, 20(PC)			
  decimal_bid.go:63	0x1000bb600		f94083e5		MOVD 256(RSP), R5			
  decimal_bid.go:63	0x1000bb604		910010a1		ADD $4, R5, R1				
  decimal_bid.go:63	0x1000bb608		f94087e2		MOVD 264(RSP), R2			
  decimal_bid.go:63	0x1000bb60c		eb01005f		CMP R1, R2				
  decimal_bid.go:63	0x1000bb610		54000063		BCC 3(PC)				
  decimal_bid.go:63	0x1000bb614		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:63	0x1000bb618		14000007		JMP 7(PC)				
  decimal_bid.go:63	0x1000bb61c		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:63	0x1000bb620		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:63	0x1000bb624		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:63	0x1000bb628		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:63	0x1000bb62c		97ff2d89		CALL runtime.growslice(SB)		
  decimal_bid.go:63	0x1000bb630		f94083e5		MOVD 256(RSP), R5			
  decimal_bid.go:63	0x1000bb634		d28925a3		MOVD $18733, R3				
  decimal_bid.go:63	0x1000bb638		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:63	0x1000bb63c		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:63	0x1000bb640		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:63	0x1000bb644		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:63	0x1000bb648		d65f03c0		RET					
  decimal_bid.go:65	0x1000bb64c		f94083e5		MOVD 256(RSP), R5			
  decimal_bid.go:65	0x1000bb650		910010a1		ADD $4, R5, R1				
  decimal_bid.go:65	0x1000bb654		f94087e2		MOVD 264(RSP), R2			
  decimal_bid.go:65	0x1000bb658		eb01005f		CMP R1, R2				
  decimal_bid.go:65	0x1000bb65c		54000063		BCC 3(PC)				
  decimal_bid.go:65	0x1000bb660		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:65	0x1000bb664		14000007		JMP 7(PC)				
  decimal_bid.go:65	0x1000bb668		f9407fe0		MOVD 248(RSP), R0			
  decimal_bid.go:65	0x1000bb66c		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:65	0x1000bb670		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:65	0x1000bb674		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:65	0x1000bb678		97ff2d76		CALL runtime.growslice(SB)		
  decimal_bid.go:65	0x1000bb67c		f94083e5		MOVD 256(RSP), R5			
  decimal_bid.go:65	0x1000bb680		d2892563		MOVD $18731, R3				
  decimal_bid.go:65	0x1000bb684		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:65	0x1000bb688		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:65	0x1000bb68c		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:65	0x1000bb690		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:65	0x1000bb694		d65f03c0		RET					
  decimal_bid.go:134	0x1000bb698		d2800440		MOVD $34, R0				
  decimal_bid.go:134	0x1000bb69c		97ff4141		CALL runtime.panicBounds(SB)		
  decimal_bid.go:145	0x1000bb6a0		d1001000		SUB $4, R0, R0				
  decimal_bid.go:145	0x1000bb6a4		cb0003ed		NEG R0, R13				
  decimal_bid.go:145	0x1000bb6a8		937ffdad		ASR $63, R13, R13			
  decimal_bid.go:145	0x1000bb6ac		927e01ad		AND $4, R13, R13			
  decimal_bid.go:145	0x1000bb6b0		8b0d0129		ADD R13, R9, R9				
  decimal_bid.go:144	0x1000bb6b4		d1001108		SUB $4, R8, R8				
  decimal_bid.go:144	0x1000bb6b8		cb0803ed		NEG R8, R13				
  decimal_bid.go:144	0x1000bb6bc		937ffdad		ASR $63, R13, R13			
  decimal_bid.go:144	0x1000bb6c0		927e01ad		AND $4, R13, R13			
  decimal_bid.go:144	0x1000bb6c4		8b0d00c6		ADD R13, R6, R6				
  decimal_bid.go:145	0x1000bb6c8		d100118c		SUB $4, R12, R12			
  decimal_bid.go:142	0x1000bb6cc		f100119f		CMP $4, R12				
  decimal_bid.go:142	0x1000bb6d0		5400018b		BLT 12(PC)				
  decimal_bid.go:143	0x1000bb6d4		f100111f		CMP $4, R8				
  decimal_bid.go:143	0x1000bb6d8		54000ae3		BCC 87(PC)				
  decimal_bid.go:143	0x1000bb6dc		eb06013f		CMP R6, R9				
  decimal_bid.go:143	0x1000bb6e0		540000a0		BEQ 5(PC)				
  decimal_bid.go:143	0x1000bb6e4		b940012d		MOVWU (R9), R13				
  decimal_bid.go:143	0x1000bb6e8		b90000cd		MOVW R13, (R6)				
  decimal_bid.go:142	0x1000bb6ec		f100119f		CMP $4, R12				
  decimal_bid.go:143	0x1000bb6f0		14000002		JMP 2(PC)				
  decimal_bid.go:142	0x1000bb6f4		f100119f		CMP $4, R12				
  decimal_bid.go:144	0x1000bb6f8		54fffd42		BCS -22(PC)				
  decimal_bid.go:144	0x1000bb6fc		1400004d		JMP 77(PC)				
  decimal_bid.go:147	0x1000bb700		aa1f03e8		MOVD ZR, R8				
  decimal_bid.go:147	0x1000bb704		14000003		JMP 3(PC)				
  decimal_bid.go:148	0x1000bb708		382868cd		MOVB R13, (R6)(R8)			
  decimal_bid.go:147	0x1000bb70c		91000508		ADD $1, R8, R8				
  decimal_bid.go:147	0x1000bb710		eb0c011f		CMP R12, R8				
  decimal_bid.go:147	0x1000bb714		5400008a		BGE 4(PC)				
  decimal_bid.go:147	0x1000bb718		3868692d		MOVBU (R9)(R8), R13			
  decimal_bid.go:148	0x1000bb71c		54ffff63		BCC -5(PC)				
  decimal_bid.go:148	0x1000bb720		14000043		JMP 67(PC)				
  decimal_bid.go:120	0x1000bb724		8b020026		ADD R2, R1, R6				
  decimal_bid.go:120	0x1000bb728		eb0600bf		CMP R6, R5				
  decimal_bid.go:120	0x1000bb72c		540007e9		BLS 63(PC)				
  decimal_bid.go:120	0x1000bb730		d28005c8		MOVD $46, R8				
  decimal_bid.go:120	0x1000bb734		38266888		MOVB R8, (R4)(R6)			
  decimal_bid.go:121	0x1000bb738		cb060148		SUB R6, R10, R8				
  decimal_bid.go:121	0x1000bb73c		d1000508		SUB $1, R8, R8				
  decimal_bid.go:121	0x1000bb740		cb0803e9		NEG R8, R9				
  decimal_bid.go:121	0x1000bb744		910004c6		ADD $1, R6, R6				
  decimal_bid.go:121	0x1000bb748		8a89fcc6		AND R9->63, R6, R6			
  decimal_bid.go:121	0x1000bb74c		8b0400c6		ADD R4, R6, R6				
  decimal_bid.go:119	0x1000bb750		eb02017f		CMP R2, R11				
  decimal_bid.go:121	0x1000bb754		54000683		BCC 52(PC)				
  decimal_bid.go:121	0x1000bb758		cb0b0049		SUB R11, R2, R9				
  decimal_bid.go:121	0x1000bb75c		8a89fc49		AND R9->63, R2, R9			
  decimal_bid.go:121	0x1000bb760		cb0303e3		NEG R3, R3				
  decimal_bid.go:121	0x1000bb764		cb02016b		SUB R2, R11, R11			
  decimal_bid.go:121	0x1000bb768		8b0900e7		ADD R9, R7, R7				
  decimal_bid.go:140	0x1000bb76c		eb08007f		CMP R8, R3				
  decimal_bid.go:140	0x1000bb770		540001a9		BLS 13(PC)				
  decimal_bid.go:140	0x1000bb774		1400002b		JMP 43(PC)				
  decimal_bid.go:145	0x1000bb778		d100116b		SUB $4, R11, R11			
  decimal_bid.go:145	0x1000bb77c		cb0b03e9		NEG R11, R9				
  decimal_bid.go:145	0x1000bb780		937ffd29		ASR $63, R9, R9				
  decimal_bid.go:145	0x1000bb784		927e0129		AND $4, R9, R9				
  decimal_bid.go:145	0x1000bb788		8b0900e7		ADD R9, R7, R7				
  decimal_bid.go:144	0x1000bb78c		d1001108		SUB $4, R8, R8				
  decimal_bid.go:144	0x1000bb790		cb0803e9		NEG R8, R9				
  decimal_bid.go:144	0x1000bb794		937ffd29		ASR $63, R9, R9				
  decimal_bid.go:144	0x1000bb798		927e0129		AND $4, R9, R9				
  decimal_bid.go:144	0x1000bb79c		8b0900c6		ADD R9, R6, R6				
  decimal_bid.go:145	0x1000bb7a0		d1001063		SUB $4, R3, R3				
  decimal_bid.go:142	0x1000bb7a4		f100107f		CMP $4, R3				
  decimal_bid.go:142	0x1000bb7a8		5400018b		BLT 12(PC)				
  decimal_bid.go:143	0x1000bb7ac		f100111f		CMP $4, R8				
  decimal_bid.go:143	0x1000bb7b0		54000363		BCC 27(PC)				
  decimal_bid.go:143	0x1000bb7b4		eb0600ff		CMP R6, R7				
  decimal_bid.go:143	0x1000bb7b8		540000a0		BEQ 5(PC)				
  decimal_bid.go:143	0x1000bb7bc		b94000e9		MOVWU (R7), R9				
  decimal_bid.go:143	0x1000bb7c0		b90000c9		MOVW R9, (R6)				
  decimal_bid.go:142	0x1000bb7c4		f100107f		CMP $4, R3				
  decimal_bid.go:143	0x1000bb7c8		14000002		JMP 2(PC)				
  decimal_bid.go:142	0x1000bb7cc		f100107f		CMP $4, R3				
  decimal_bid.go:144	0x1000bb7d0		54fffd42		BCS -22(PC)				
  decimal_bid.go:144	0x1000bb7d4		14000011		JMP 17(PC)				
  decimal_bid.go:147	0x1000bb7d8		aa1f03e8		MOVD ZR, R8				
  decimal_bid.go:147	0x1000bb7dc		14000003		JMP 3(PC)				
  decimal_bid.go:148	0x1000bb7e0		382868c9		MOVB R9, (R6)(R8)			
  decimal_bid.go:147	0x1000bb7e4		91000508		ADD $1, R8, R8				
  decimal_bid.go:147	0x1000bb7e8		eb03011f		CMP R3, R8				
  decimal_bid.go:147	0x1000bb7ec		5400008a		BGE 4(PC)				
  decimal_bid.go:147	0x1000bb7f0		386868e9		MOVBU (R7)(R8), R9			
  decimal_bid.go:148	0x1000bb7f4		54ffff63		BCC -5(PC)				
  decimal_bid.go:148	0x1000bb7f8		14000007		JMP 7(PC)				
  decimal_bid.go:123	0x1000bb7fc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:123	0x1000bb800		aa0503e1		MOVD R5, R1				
  decimal_bid.go:123	0x1000bb804		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:123	0x1000bb808		f85f83fd		MOVD -8(RSP), R29			
  decimal_bid.go:123	0x1000bb80c		f84f07fe		MOVD.P 240(RSP), R30			
  decimal_bid.go:123	0x1000bb810		d65f03c0		RET					
  decimal_bid.go:148	0x1000bb814		97ff40e3		CALL runtime.panicBounds(SB)		
  decimal_bid.go:144	0x1000bb818		97ff40e2		CALL runtime.panicBounds(SB)		
  decimal_bid.go:143	0x1000bb81c		97ff40e1		CALL runtime.panicBounds(SB)		
  decimal_bid.go:140	0x1000bb820		97ff40e0		CALL runtime.panicBounds(SB)		
  decimal_bid.go:121	0x1000bb824		97ff40df		CALL runtime.panicBounds(SB)		
  decimal_bid.go:120	0x1000bb828		97ff40de		CALL runtime.panicBounds(SB)		
  decimal_bid.go:148	0x1000bb82c		97ff40dd		CALL runtime.panicBounds(SB)		
  decimal_bid.go:144	0x1000bb830		97ff40dc		CALL runtime.panicBounds(SB)		
  decimal_bid.go:143	0x1000bb834		97ff40db		CALL runtime.panicBounds(SB)		
  decimal_bid.go:140	0x1000bb838		97ff40da		CALL runtime.panicBounds(SB)		
  decimal_bid.go:119	0x1000bb83c		97ff40d9		CALL runtime.panicBounds(SB)		
  decimal_bid.go:119	0x1000bb840		97ff40d8		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb844		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:111	0x1000bb848		91000463		ADD $1, R3, R3				
  decimal_bid.go:111	0x1000bb84c		eb0c007f		CMP R12, R3				
  decimal_bid.go:111	0x1000bb850		5400010a		BGE 8(PC)				
  decimal_bid.go:112	0x1000bb854		8b010066		ADD R1, R3, R6				
  decimal_bid.go:112	0x1000bb858		eb00007f		CMP R0, R3				
  decimal_bid.go:112	0x1000bb85c		540002e2		BCS 23(PC)				
  decimal_bid.go:112	0x1000bb860		38636927		MOVBU (R9)(R3), R7			
  decimal_bid.go:112	0x1000bb864		eb0600bf		CMP R6, R5				
  decimal_bid.go:112	0x1000bb868		54fffee8		BHI -9(PC)				
  decimal_bid.go:112	0x1000bb86c		14000012		JMP 18(PC)				
  decimal_bid.go:114	0x1000bb870		8b0c0023		ADD R12, R1, R3				
  decimal_bid.go:114	0x1000bb874		eb0300bf		CMP R3, R5				
  decimal_bid.go:114	0x1000bb878		540001c9		BLS 14(PC)				
  decimal_bid.go:114	0x1000bb87c		d28005c6		MOVD $46, R6				
  decimal_bid.go:114	0x1000bb880		38236886		MOVB R6, (R4)(R3)			
  decimal_bid.go:115	0x1000bb884		14000003		JMP 3(PC)				
  decimal_bid.go:116	0x1000bb888		38236886		MOVB R6, (R4)(R3)			
  decimal_bid.go:115	0x1000bb88c		9100058c		ADD $1, R12, R12			
  decimal_bid.go:115	0x1000bb890		eb00019f		CMP R0, R12				
  decimal_bid.go:115	0x1000bb894		54fffb4a		BGE -38(PC)				
  decimal_bid.go:116	0x1000bb898		8b010183		ADD R1, R12, R3				
  decimal_bid.go:116	0x1000bb89c		91000463		ADD $1, R3, R3				
  decimal_bid.go:116	0x1000bb8a0		386c6926		MOVBU (R9)(R12), R6			
  decimal_bid.go:116	0x1000bb8a4		eb05007f		CMP R5, R3				
  decimal_bid.go:116	0x1000bb8a8		54ffff03		BCC -8(PC)				
  decimal_bid.go:116	0x1000bb8ac		97ff40bd		CALL runtime.panicBounds(SB)		
  decimal_bid.go:114	0x1000bb8b0		97ff40bc		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb8b4		97ff40bb		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb8b8		97ff40ba		CALL runtime.panicBounds(SB)		
  decimal_bid.go:105	0x1000bb8bc		97ff40b9		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb8c0		d2800440		MOVD $34, R0				
  decimal_bid.go:72	0x1000bb8c4		97ff40b7		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb8c8		d503201f		NOOP					
  decimal_bid.go:48	0x1000bb8cc		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:48	0x1000bb8d0		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:48	0x1000bb8d4		f90017e4		MOVD R4, 40(RSP)			
  decimal_bid.go:48	0x1000bb8d8		3900c3e5		MOVB R5, 48(RSP)			
  decimal_bid.go:48	0x1000bb8dc		a9039fe6		STP (R6, R7), 56(RSP)			
  decimal_bid.go:48	0x1000bb8e0		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:48	0x1000bb8e4		97ff386b		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:48	0x1000bb8e8		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:48	0x1000bb8ec		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:48	0x1000bb8f0		f94017e4		MOVD 40(RSP), R4			
  decimal_bid.go:48	0x1000bb8f4		3940c3e5		MOVBU 48(RSP), R5			
  decimal_bid.go:48	0x1000bb8f8		a9439fe6		LDP 56(RSP), (R6, R7)			
  decimal_bid.go:48	0x1000bb8fc		17fffe1d		JMP strconv.appendDecimal(SB)		
