TEXT strconv.appendDecimal(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:48	0x1000bb170		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:48	0x1000bb174		d10203f1		SUB $128, RSP, R17			
  decimal_bid.go:48	0x1000bb178		eb10023f		CMP R16, R17				
  decimal_bid.go:48	0x1000bb17c		54003b69		BLS 475(PC)				
  decimal_bid.go:48	0x1000bb180		d10403f4		SUB $256, RSP, R20			
  decimal_bid.go:48	0x1000bb184		a93ffa9d		STP (R29, R30), -8(R20)			
  decimal_bid.go:48	0x1000bb188		9100029f		MOVD R20, RSP				
  decimal_bid.go:48	0x1000bb18c		d10023fd		SUB $8, RSP, R29			
  decimal_bid.go:61	0x1000bb190		3904c3e5		MOVB R5, 304(RSP)			
  decimal_bid.go:61	0x1000bb194		f9009fe6		MOVD R6, 312(RSP)			
  decimal_bid.go:61	0x1000bb198		a9118fe2		STP (R2, R3), 280(RSP)			
  decimal_bid.go:61	0x1000bb19c		a91087e0		STP (R0, R1), 264(RSP)			
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
  decimal_bid.go:61	0x1000bb1d0		54002de0		BEQ 367(PC)				
  decimal_bid.go:59	0x1000bb1d4		7100089f		CMPW $2, R4				
  decimal_bid.go:59	0x1000bb1d8		54002b00		BEQ 344(PC)				
  decimal_bid.go:68	0x1000bb1dc		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:68	0x1000bb1e0		b6f82300		TBZ $63, R0, 280(PC)			
  decimal_bid.go:269	0x1000bb1e4		3944c3e7		MOVBU 304(RSP), R7			
  decimal_bid.go:269	0x1000bb1e8		aa0703e9		MOVD R7, R9				
  decimal_bid.go:269	0x1000bb1ec		7101153f		CMPW $69, R9				
  decimal_bid.go:269	0x1000bb1f0		54000100		BEQ 8(PC)				
  decimal_bid.go:269	0x1000bb1f4		71011d3f		CMPW $71, R9				
  decimal_bid.go:269	0x1000bb1f8		540000c0		BEQ 6(PC)				
  decimal_bid.go:269	0x1000bb1fc		d10194e9		SUB $101, R7, R9			
  decimal_bid.go:269	0x1000bb200		d3401d29		UBFX $0, R9, $8, R9			
  decimal_bid.go:269	0x1000bb204		7100093f		CMPW $2, R9				
  decimal_bid.go:269	0x1000bb208		54000049		BLS 2(PC)				
  decimal_bid.go:269	0x1000bb20c		d2800ce7		MOVD $103, R7				
  decimal_bid.go:72	0x1000bb210		d2800449		MOVD $34, R9				
  decimal_bid.go:72	0x1000bb214		cb020129		SUB R2, R9, R9				
  decimal_bid.go:72	0x1000bb218		f100893f		CMP $34, R9				
  decimal_bid.go:72	0x1000bb21c		54003608		BHI 432(PC)				
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
  decimal_bid.go:57	0x1000bb24c		a90a03e3		STP (R3, R0), 160(RSP)			
  decimal_bid.go:76	0x1000bb250		f90077e9		MOVD R9, 232(RSP)			
  decimal_bid.go:76	0x1000bb254		36000361		TBZ $0, R1, 27(PC)			
  decimal_bid.go:77	0x1000bb258		f9408bea		MOVD 272(RSP), R10			
  decimal_bid.go:77	0x1000bb25c		91000541		ADD $1, R10, R1				
  decimal_bid.go:77	0x1000bb260		f9408fea		MOVD 280(RSP), R10			
  decimal_bid.go:77	0x1000bb264		eb01015f		CMP R1, R10				
  decimal_bid.go:77	0x1000bb268		54000063		BCC 3(PC)				
  decimal_bid.go:77	0x1000bb26c		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:77	0x1000bb270		14000010		JMP 16(PC)				
  decimal_bid.go:57	0x1000bb274		f9004fe2		MOVD R2, 152(RSP)			
  decimal_bid.go:71	0x1000bb278		390193e7		MOVB R7, 100(RSP)			
  decimal_bid.go:77	0x1000bb27c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:77	0x1000bb280		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:77	0x1000bb284		b24003e3		ORR $1, ZR, R3				
  decimal_bid.go:77	0x1000bb288		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:77	0x1000bb28c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:77	0x1000bb290		97ff2e70		CALL runtime.growslice(SB)		
  decimal_bid.go:88	0x1000bb294		f94053e3		MOVD 160(RSP), R3			
  decimal_bid.go:80	0x1000bb298		394193e7		MOVBU 100(RSP), R7			
  decimal_bid.go:112	0x1000bb29c		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:77	0x1000bb2a0		aa0003e4		MOVD R0, R4				
  decimal_bid.go:77	0x1000bb2a4		aa0203ea		MOVD R2, R10				
  decimal_bid.go:88	0x1000bb2a8		f94057e0		MOVD 168(RSP), R0			
  decimal_bid.go:73	0x1000bb2ac		f9404fe2		MOVD 152(RSP), R2			
  decimal_bid.go:77	0x1000bb2b0		d100042b		SUB $1, R1, R11				
  decimal_bid.go:77	0x1000bb2b4		d28005ac		MOVD $45, R12				
  decimal_bid.go:77	0x1000bb2b8		382b688c		MOVB R12, (R4)(R11)			
  decimal_bid.go:77	0x1000bb2bc		14000003		JMP 3(PC)				
  decimal_bid.go:79	0x1000bb2c0		a95087e4		LDP 264(RSP), (R4, R1)			
  decimal_bid.go:79	0x1000bb2c4		f9408fea		MOVD 280(RSP), R10			
  decimal_bid.go:80	0x1000bb2c8		d3401ceb		UBFX $0, R7, $8, R11			
  decimal_bid.go:80	0x1000bb2cc		7101157f		CMPW $69, R11				
  decimal_bid.go:80	0x1000bb2d0		54001a20		BEQ 209(PC)				
  decimal_bid.go:80	0x1000bb2d4		7101957f		CMPW $101, R11				
  decimal_bid.go:80	0x1000bb2d8		540019e0		BEQ 207(PC)				
  decimal_bid.go:82	0x1000bb2dc		7101997f		CMPW $102, R11				
  decimal_bid.go:82	0x1000bb2e0		540017c0		BEQ 190(PC)				
  decimal_bid.go:88	0x1000bb2e4		8b00006c		ADD R0, R3, R12				
  decimal_bid.go:89	0x1000bb2e8		9100158d		ADD $5, R12, R13			
  decimal_bid.go:89	0x1000bb2ec		f1006dbf		CMP $27, R13				
  decimal_bid.go:89	0x1000bb2f0		54001562		BCS 171(PC)				
  decimal_bid.go:89	0x1000bb2f4		f100007f		CMP $0, R3				
  decimal_bid.go:89	0x1000bb2f8		5400152c		BGT 169(PC)				
  decimal_bid.go:79	0x1000bb2fc		f90063e1		MOVD R1, 192(RSP)			
  decimal_bid.go:96	0x1000bb300		b4001163		CBZ R3, 139(PC)				
  decimal_bid.go:103	0x1000bb304		f100019f		CMP $0, R12				
  decimal_bid.go:103	0x1000bb308		54000fcd		BLE 126(PC)				
  decimal_bid.go:103	0x1000bb30c		cb010148		SUB R1, R10, R8				
  decimal_bid.go:103	0x1000bb310		9100040b		ADD $1, R0, R11				
  decimal_bid.go:103	0x1000bb314		eb0b011f		CMP R11, R8				
  decimal_bid.go:103	0x1000bb318		54000f4b		BLT 122(PC)				
  decimal_bid.go:105	0x1000bb31c		8b000025		ADD R0, R1, R5				
  decimal_bid.go:105	0x1000bb320		910004a5		ADD $1, R5, R5				
  decimal_bid.go:105	0x1000bb324		eb05015f		CMP R5, R10				
  decimal_bid.go:105	0x1000bb328		54002d83		BCC 364(PC)				
  decimal_bid.go:110	0x1000bb32c		f100241f		CMP $9, R0				
  decimal_bid.go:110	0x1000bb330		5400006c		BGT 3(PC)				
  decimal_bid.go:110	0x1000bb334		aa1f03e3		MOVD ZR, R3				
  decimal_bid.go:110	0x1000bb338		1400014c		JMP 332(PC)				
  decimal_bid.go:119	0x1000bb33c		eb05003f		CMP R5, R1				
  decimal_bid.go:119	0x1000bb340		540028e8		BHI 327(PC)				
  decimal_bid.go:119	0x1000bb344		cb0a0026		SUB R10, R1, R6				
  decimal_bid.go:119	0x1000bb348		8a86fc26		AND R6->63, R1, R6			
  decimal_bid.go:119	0x1000bb34c		8b0400c7		ADD R4, R6, R7				
  decimal_bid.go:119	0x1000bb350		eb0c001f		CMP R12, R0				
  decimal_bid.go:119	0x1000bb354		54002823		BCC 321(PC)				
  decimal_bid.go:105	0x1000bb358		a90b17ea		STP (R10, R5), 176(RSP)			
  decimal_bid.go:79	0x1000bb35c		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:145	0x1000bb360		f100219f		CMP $8, R12				
  decimal_bid.go:145	0x1000bb364		540003ab		BLT 29(PC)				
  decimal_bid.go:146	0x1000bb368		eb0c011f		CMP R12, R8				
  decimal_bid.go:146	0x1000bb36c		54002743		BCC 314(PC)				
  decimal_bid.go:147	0x1000bb370		f100419f		CMP $16, R12				
  decimal_bid.go:147	0x1000bb374		540001ac		BGT 13(PC)				
  decimal_bid.go:148	0x1000bb378		eb07013f		CMP R7, R9				
  decimal_bid.go:148	0x1000bb37c		54000060		BEQ 3(PC)				
  decimal_bid.go:148	0x1000bb380		f9400128		MOVD (R9), R8				
  decimal_bid.go:148	0x1000bb384		f8266888		MOVD R8, (R4)(R6)			
  decimal_bid.go:149	0x1000bb388		d1002186		SUB $8, R12, R6				
  decimal_bid.go:149	0x1000bb38c		8b0700c8		ADD R7, R6, R8				
  decimal_bid.go:149	0x1000bb390		8b06012b		ADD R6, R9, R11				
  decimal_bid.go:149	0x1000bb394		eb0b011f		CMP R11, R8				
  decimal_bid.go:149	0x1000bb398		54000400		BEQ 32(PC)				
  decimal_bid.go:149	0x1000bb39c		f8666928		MOVD (R9)(R6), R8			
  decimal_bid.go:149	0x1000bb3a0		f82668e8		MOVD R8, (R7)(R6)			
  decimal_bid.go:149	0x1000bb3a4		1400001d		JMP 29(PC)				
  decimal_bid.go:151	0x1000bb3a8		eb07013f		CMP R7, R9				
  decimal_bid.go:151	0x1000bb3ac		54000060		BEQ 3(PC)				
  decimal_bid.go:151	0x1000bb3b0		3dc00120		FMOVQ (R9), F0				
  decimal_bid.go:151	0x1000bb3b4		3d8000e0		FMOVQ F0, (R7)				
  decimal_bid.go:152	0x1000bb3b8		d1004186		SUB $16, R12, R6			
  decimal_bid.go:152	0x1000bb3bc		8b0700c7		ADD R7, R6, R7				
  decimal_bid.go:152	0x1000bb3c0		8b0900c6		ADD R9, R6, R6				
  decimal_bid.go:152	0x1000bb3c4		eb0700df		CMP R7, R6				
  decimal_bid.go:152	0x1000bb3c8		54000280		BEQ 20(PC)				
  decimal_bid.go:152	0x1000bb3cc		3dc000c0		FMOVQ (R6), F0				
  decimal_bid.go:152	0x1000bb3d0		3d8000e0		FMOVQ F0, (R7)				
  decimal_bid.go:152	0x1000bb3d4		14000011		JMP 17(PC)				
  decimal_bid.go:156	0x1000bb3d8		eb0c017f		CMP R12, R11				
  decimal_bid.go:156	0x1000bb3dc		9a80c582		CSINC GT, R12, R0, R2			
  decimal_bid.go:156	0x1000bb3e0		eb07013f		CMP R7, R9				
  decimal_bid.go:156	0x1000bb3e4		540001a0		BEQ 13(PC)				
  decimal_bid.go:88	0x1000bb3e8		f9004bec		MOVD R12, 144(RSP)			
  decimal_bid.go:156	0x1000bb3ec		aa0703e0		MOVD R7, R0				
  decimal_bid.go:156	0x1000bb3f0		aa0903e1		MOVD R9, R1				
  decimal_bid.go:156	0x1000bb3f4		97ff426f		CALL runtime.memmove(SB)		
  decimal_bid.go:119	0x1000bb3f8		f94057e0		MOVD 168(RSP), R0			
  decimal_bid.go:120	0x1000bb3fc		f94063e1		MOVD 192(RSP), R1			
  decimal_bid.go:145	0x1000bb400		f94053e3		MOVD 160(RSP), R3			
  decimal_bid.go:120	0x1000bb404		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:120	0x1000bb408		f9405fe5		MOVD 184(RSP), R5			
  decimal_bid.go:121	0x1000bb40c		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:121	0x1000bb410		f9405bea		MOVD 176(RSP), R10			
  decimal_bid.go:120	0x1000bb414		f9404bec		MOVD 144(RSP), R12			
  decimal_bid.go:120	0x1000bb418		8b0c0026		ADD R12, R1, R6				
  decimal_bid.go:120	0x1000bb41c		eb0600bf		CMP R6, R5				
  decimal_bid.go:120	0x1000bb420		54002189		BLS 268(PC)				
  decimal_bid.go:120	0x1000bb424		d28005c7		MOVD $46, R7				
  decimal_bid.go:120	0x1000bb428		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:121	0x1000bb42c		cb060147		SUB R6, R10, R7				
  decimal_bid.go:121	0x1000bb430		d10004e7		SUB $1, R7, R7				
  decimal_bid.go:121	0x1000bb434		cb0703e8		NEG R7, R8				
  decimal_bid.go:121	0x1000bb438		910004c6		ADD $1, R6, R6				
  decimal_bid.go:121	0x1000bb43c		8a88fcc6		AND R8->63, R6, R6			
  decimal_bid.go:121	0x1000bb440		8b0400c8		ADD R4, R6, R8				
  decimal_bid.go:119	0x1000bb444		eb0c001f		CMP R12, R0				
  decimal_bid.go:121	0x1000bb448		54002023		BCC 257(PC)				
  decimal_bid.go:121	0x1000bb44c		cb00018b		SUB R0, R12, R11			
  decimal_bid.go:121	0x1000bb450		8a8bfd8b		AND R11->63, R12, R11			
  decimal_bid.go:145	0x1000bb454		928000ec		MOVD $-8, R12				
  decimal_bid.go:145	0x1000bb458		cb03018c		SUB R3, R12, R12			
  decimal_bid.go:121	0x1000bb45c		cb0303ed		NEG R3, R13				
  decimal_bid.go:121	0x1000bb460		8b0b0121		ADD R11, R9, R1				
  decimal_bid.go:145	0x1000bb464		f100619f		CMP $24, R12				
  decimal_bid.go:145	0x1000bb468		540003a8		BHI 29(PC)				
  decimal_bid.go:146	0x1000bb46c		eb0701bf		CMP R7, R13				
  decimal_bid.go:146	0x1000bb470		54001ec8		BHI 246(PC)				
  decimal_bid.go:147	0x1000bb474		f10041bf		CMP $16, R13				
  decimal_bid.go:147	0x1000bb478		5400018c		BGT 12(PC)				
  decimal_bid.go:148	0x1000bb47c		eb08003f		CMP R8, R1				
  decimal_bid.go:148	0x1000bb480		54000060		BEQ 3(PC)				
  decimal_bid.go:148	0x1000bb484		f86b6923		MOVD (R9)(R11), R3			
  decimal_bid.go:148	0x1000bb488		f8266883		MOVD R3, (R4)(R6)			
  decimal_bid.go:149	0x1000bb48c		8b0c0103		ADD R12, R8, R3				
  decimal_bid.go:149	0x1000bb490		8b0c0026		ADD R12, R1, R6				
  decimal_bid.go:149	0x1000bb494		eb0300df		CMP R3, R6				
  decimal_bid.go:149	0x1000bb498		54001cc0		BEQ 230(PC)				
  decimal_bid.go:149	0x1000bb49c		f86c6823		MOVD (R1)(R12), R3			
  decimal_bid.go:149	0x1000bb4a0		f82c6903		MOVD R3, (R8)(R12)			
  decimal_bid.go:149	0x1000bb4a4		140000e3		JMP 227(PC)				
  decimal_bid.go:151	0x1000bb4a8		eb08003f		CMP R8, R1				
  decimal_bid.go:151	0x1000bb4ac		54000060		BEQ 3(PC)				
  decimal_bid.go:151	0x1000bb4b0		3dc00020		FMOVQ (R1), F0				
  decimal_bid.go:151	0x1000bb4b4		3d800100		FMOVQ F0, (R8)				
  decimal_bid.go:152	0x1000bb4b8		928001e6		MOVD $-16, R6				
  decimal_bid.go:152	0x1000bb4bc		cb0300c3		SUB R3, R6, R3				
  decimal_bid.go:152	0x1000bb4c0		8b080066		ADD R8, R3, R6				
  decimal_bid.go:152	0x1000bb4c4		8b010063		ADD R1, R3, R3				
  decimal_bid.go:152	0x1000bb4c8		eb0300df		CMP R3, R6				
  decimal_bid.go:152	0x1000bb4cc		54001b20		BEQ 217(PC)				
  decimal_bid.go:152	0x1000bb4d0		3dc00060		FMOVQ (R3), F0				
  decimal_bid.go:152	0x1000bb4d4		3d8000c0		FMOVQ F0, (R6)				
  decimal_bid.go:152	0x1000bb4d8		140000d6		JMP 214(PC)				
  decimal_bid.go:156	0x1000bb4dc		eb0d01bf		CMP R13, R13				
  decimal_bid.go:156	0x1000bb4e0		da83c5a2		CSNEG GT, R13, R3, R2			
  decimal_bid.go:156	0x1000bb4e4		eb08003f		CMP R8, R1				
  decimal_bid.go:156	0x1000bb4e8		54001a40		BEQ 210(PC)				
  decimal_bid.go:156	0x1000bb4ec		aa0803e0		MOVD R8, R0				
  decimal_bid.go:156	0x1000bb4f0		97ff4230		CALL runtime.memmove(SB)		
  decimal_bid.go:123	0x1000bb4f4		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:123	0x1000bb4f8		a94b17ea		LDP 176(RSP), (R10, R5)			
  decimal_bid.go:156	0x1000bb4fc		140000cd		JMP 205(PC)				
  decimal_bid.go:125	0x1000bb500		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:125	0x1000bb504		aa0003e5		MOVD R0, R5				
  decimal_bid.go:125	0x1000bb508		aa0303e6		MOVD R3, R6				
  decimal_bid.go:125	0x1000bb50c		92800007		MOVD $-1, R7				
  decimal_bid.go:125	0x1000bb510		aa0403e0		MOVD R4, R0				
  decimal_bid.go:125	0x1000bb514		aa0903e3		MOVD R9, R3				
  decimal_bid.go:125	0x1000bb518		aa0503e4		MOVD R5, R4				
  decimal_bid.go:125	0x1000bb51c		97fff125		CALL strconv.appendFixed(SB)		
  decimal_bid.go:125	0x1000bb520		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:125	0x1000bb524		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:125	0x1000bb528		d65f03c0		RET					
  decimal_bid.go:97	0x1000bb52c		8b000025		ADD R0, R1, R5				
  decimal_bid.go:97	0x1000bb530		eb05015f		CMP R5, R10				
  decimal_bid.go:97	0x1000bb534		540001c2		BCS 14(PC)				
  decimal_bid.go:97	0x1000bb538		aa0503e1		MOVD R5, R1				
  decimal_bid.go:97	0x1000bb53c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:97	0x1000bb540		aa0003e3		MOVD R0, R3				
  decimal_bid.go:97	0x1000bb544		aa0403e0		MOVD R4, R0				
  decimal_bid.go:97	0x1000bb548		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:97	0x1000bb54c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:97	0x1000bb550		97ff2dc0		CALL runtime.growslice(SB)		
  decimal_bid.go:97	0x1000bb554		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:97	0x1000bb558		aa0003e4		MOVD R0, R4				
  decimal_bid.go:97	0x1000bb55c		aa0203ea		MOVD R2, R10				
  decimal_bid.go:97	0x1000bb560		aa0103e5		MOVD R1, R5				
  decimal_bid.go:97	0x1000bb564		f94057e0		MOVD 168(RSP), R0			
  decimal_bid.go:97	0x1000bb568		f94063e1		MOVD 192(RSP), R1			
  decimal_bid.go:97	0x1000bb56c		a90babe5		STP (R5, R10), 184(RSP)			
  decimal_bid.go:97	0x1000bb570		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:97	0x1000bb574		8b010083		ADD R1, R4, R3				
  decimal_bid.go:97	0x1000bb578		aa0903e1		MOVD R9, R1				
  decimal_bid.go:97	0x1000bb57c		aa0003e2		MOVD R0, R2				
  decimal_bid.go:97	0x1000bb580		aa0303e0		MOVD R3, R0				
  decimal_bid.go:97	0x1000bb584		97ff420b		CALL runtime.memmove(SB)		
  decimal_bid.go:97	0x1000bb588		f9407be0		MOVD 240(RSP), R0			
  decimal_bid.go:97	0x1000bb58c		a94b8be1		LDP 184(RSP), (R1, R2)			
  decimal_bid.go:97	0x1000bb590		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:97	0x1000bb594		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:97	0x1000bb598		d65f03c0		RET					
  decimal_bid.go:91	0x1000bb59c		71011d7f		CMPW $71, R11				
  decimal_bid.go:94	0x1000bb5a0		d28008ab		MOVD $69, R11				
  decimal_bid.go:94	0x1000bb5a4		d2800cac		MOVD $101, R12				
  decimal_bid.go:94	0x1000bb5a8		9a8c0167		CSEL EQ, R11, R12, R7			
  decimal_bid.go:94	0x1000bb5ac		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:94	0x1000bb5b0		aa0003e5		MOVD R0, R5				
  decimal_bid.go:94	0x1000bb5b4		aa0303e6		MOVD R3, R6				
  decimal_bid.go:94	0x1000bb5b8		92800008		MOVD $-1, R8				
  decimal_bid.go:94	0x1000bb5bc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:94	0x1000bb5c0		aa0903e3		MOVD R9, R3				
  decimal_bid.go:94	0x1000bb5c4		aa0503e4		MOVD R5, R4				
  decimal_bid.go:94	0x1000bb5c8		97fff262		CALL strconv.appendExp(SB)		
  decimal_bid.go:91	0x1000bb5cc		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:91	0x1000bb5d0		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:91	0x1000bb5d4		d65f03c0		RET					
  decimal_bid.go:73	0x1000bb5d8		f100005f		CMP $0, R2				
  decimal_bid.go:84	0x1000bb5dc		f100007f		CMP $0, R3				
  decimal_bid.go:84	0x1000bb5e0		9a9fd068		CSEL LE, R3, ZR, R8			
  decimal_bid.go:73	0x1000bb5e4		f100005f		CMP $0, R2				
  decimal_bid.go:86	0x1000bb5e8		9a830106		CSEL EQ, R8, R3, R6			
  decimal_bid.go:86	0x1000bb5ec		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:86	0x1000bb5f0		aa0903e3		MOVD R9, R3				
  decimal_bid.go:86	0x1000bb5f4		aa0003e5		MOVD R0, R5				
  decimal_bid.go:86	0x1000bb5f8		92800007		MOVD $-1, R7				
  decimal_bid.go:86	0x1000bb5fc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:86	0x1000bb600		aa0503e4		MOVD R5, R4				
  decimal_bid.go:86	0x1000bb604		97fff0eb		CALL strconv.appendFixed(SB)		
  decimal_bid.go:83	0x1000bb608		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:83	0x1000bb60c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:83	0x1000bb610		d65f03c0		RET					
  decimal_bid.go:81	0x1000bb614		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:81	0x1000bb618		aa0003e5		MOVD R0, R5				
  decimal_bid.go:81	0x1000bb61c		aa0303e6		MOVD R3, R6				
  decimal_bid.go:81	0x1000bb620		92800008		MOVD $-1, R8				
  decimal_bid.go:81	0x1000bb624		aa0403e0		MOVD R4, R0				
  decimal_bid.go:81	0x1000bb628		aa0903e3		MOVD R9, R3				
  decimal_bid.go:81	0x1000bb62c		aa0503e4		MOVD R5, R4				
  decimal_bid.go:81	0x1000bb630		97fff248		CALL strconv.appendExp(SB)		
  decimal_bid.go:81	0x1000bb634		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:81	0x1000bb638		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:81	0x1000bb63c		d65f03c0		RET					
  decimal_bid.go:127	0x1000bb640		390323e1		MOVB R1, 200(RSP)			
  decimal_bid.go:127	0x1000bb644		a90d0fe2		STP (R2, R3), 208(RSP)			
  decimal_bid.go:127	0x1000bb648		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:127	0x1000bb64c		f90073ea		MOVD R10, 224(RSP)			
  decimal_bid.go:128	0x1000bb650		f100005f		CMP $0, R2				
  decimal_bid.go:128	0x1000bb654		5400024d		BLE 18(PC)				
  decimal_bid.go:269	0x1000bb658		3944c3e3		MOVBU 304(RSP), R3			
  decimal_bid.go:269	0x1000bb65c		aa0303e5		MOVD R3, R5				
  decimal_bid.go:269	0x1000bb660		710114bf		CMPW $69, R5				
  decimal_bid.go:269	0x1000bb664		54000100		BEQ 8(PC)				
  decimal_bid.go:269	0x1000bb668		71011cbf		CMPW $71, R5				
  decimal_bid.go:269	0x1000bb66c		540000c0		BEQ 6(PC)				
  decimal_bid.go:269	0x1000bb670		d1019465		SUB $101, R3, R5			
  decimal_bid.go:269	0x1000bb674		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:269	0x1000bb678		710008bf		CMPW $2, R5				
  decimal_bid.go:269	0x1000bb67c		54000049		BLS 2(PC)				
  decimal_bid.go:269	0x1000bb680		d2800ce3		MOVD $103, R3				
  decimal_bid.go:129	0x1000bb684		f94047e1		MOVD 136(RSP), R1			
  decimal_bid.go:129	0x1000bb688		f94093e2		MOVD 288(RSP), R2			
  decimal_bid.go:129	0x1000bb68c		aa0003e4		MOVD R0, R4				
  decimal_bid.go:129	0x1000bb690		910323e0		ADD $200, RSP, R0			
  decimal_bid.go:129	0x1000bb694		97ffeeeb		CALL strconv.(*finite).round(SB)	
  decimal_bid.go:134	0x1000bb698		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:131	0x1000bb69c		f9406be7		MOVD 208(RSP), R7			
  decimal_bid.go:131	0x1000bb6a0		b40003a7		CBZ R7, 29(PC)				
  decimal_bid.go:134	0x1000bb6a4		f94073ea		MOVD 224(RSP), R10			
  decimal_bid.go:134	0x1000bb6a8		3980015b		MOVB (R10), R27				
  decimal_bid.go:134	0x1000bb6ac		d280044b		MOVD $34, R11				
  decimal_bid.go:134	0x1000bb6b0		cb07016b		SUB R7, R11, R11			
  decimal_bid.go:134	0x1000bb6b4		f100897f		CMP $34, R11				
  decimal_bid.go:134	0x1000bb6b8		54000b88		BHI 92(PC)				
  decimal_bid.go:269	0x1000bb6bc		3944c3e8		MOVBU 304(RSP), R8			
  decimal_bid.go:269	0x1000bb6c0		aa0803ec		MOVD R8, R12				
  decimal_bid.go:134	0x1000bb6c4		8b0b0145		ADD R11, R10, R5			
  decimal_bid.go:269	0x1000bb6c8		7101159f		CMPW $69, R12				
  decimal_bid.go:269	0x1000bb6cc		54000100		BEQ 8(PC)				
  decimal_bid.go:269	0x1000bb6d0		71011d9f		CMPW $71, R12				
  decimal_bid.go:269	0x1000bb6d4		540000c0		BEQ 6(PC)				
  decimal_bid.go:269	0x1000bb6d8		d101950a		SUB $101, R8, R10			
  decimal_bid.go:269	0x1000bb6dc		d3401d4a		UBFX $0, R10, $8, R10			
  decimal_bid.go:269	0x1000bb6e0		7100095f		CMPW $2, R10				
  decimal_bid.go:269	0x1000bb6e4		54000049		BLS 2(PC)				
  decimal_bid.go:269	0x1000bb6e8		d2800ce8		MOVD $103, R8				
  decimal_bid.go:134	0x1000bb6ec		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:134	0x1000bb6f0		f9406fe4		MOVD 216(RSP), R4			
  decimal_bid.go:134	0x1000bb6f4		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:134	0x1000bb6f8		aa0703e6		MOVD R7, R6				
  decimal_bid.go:134	0x1000bb6fc		aa0003e9		MOVD R0, R9				
  decimal_bid.go:134	0x1000bb700		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:134	0x1000bb704		97fff03b		CALL strconv.formatDigits(SB)		
  decimal_bid.go:134	0x1000bb708		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:134	0x1000bb70c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:134	0x1000bb710		d65f03c0		RET					
  decimal_bid.go:132	0x1000bb714		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:132	0x1000bb718		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:132	0x1000bb71c		3944c3e4		MOVBU 304(RSP), R4			
  decimal_bid.go:132	0x1000bb720		aa0003e5		MOVD R0, R5				
  decimal_bid.go:132	0x1000bb724		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:132	0x1000bb728		97ffef5e		CALL strconv.appendZero(SB)		
  decimal_bid.go:132	0x1000bb72c		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:132	0x1000bb730		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:132	0x1000bb734		d65f03c0		RET					
  decimal_bid.go:60	0x1000bb738		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000bb73c		91000ca1		ADD $3, R5, R1				
  decimal_bid.go:60	0x1000bb740		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:60	0x1000bb744		eb01005f		CMP R1, R2				
  decimal_bid.go:60	0x1000bb748		54000063		BCC 3(PC)				
  decimal_bid.go:60	0x1000bb74c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000bb750		14000007		JMP 7(PC)				
  decimal_bid.go:60	0x1000bb754		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000bb758		b24007e3		ORR $3, ZR, R3				
  decimal_bid.go:60	0x1000bb75c		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:60	0x1000bb760		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:60	0x1000bb764		97ff2d3b		CALL runtime.growslice(SB)		
  decimal_bid.go:60	0x1000bb768		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000bb76c		8b0000a3		ADD R0, R5, R3				
  decimal_bid.go:60	0x1000bb770		d28c29c4		MOVD $24910, R4				
  decimal_bid.go:60	0x1000bb774		78256804		MOVH R4, (R0)(R5)			
  decimal_bid.go:60	0x1000bb778		d28009c4		MOVD $78, R4				
  decimal_bid.go:60	0x1000bb77c		39000864		MOVB R4, 2(R3)				
  decimal_bid.go:60	0x1000bb780		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:60	0x1000bb784		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:60	0x1000bb788		d65f03c0		RET					
  decimal_bid.go:62	0x1000bb78c		36000281		TBZ $0, R1, 20(PC)			
  decimal_bid.go:63	0x1000bb790		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000bb794		910010a1		ADD $4, R5, R1				
  decimal_bid.go:63	0x1000bb798		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:63	0x1000bb79c		eb01005f		CMP R1, R2				
  decimal_bid.go:63	0x1000bb7a0		54000063		BCC 3(PC)				
  decimal_bid.go:63	0x1000bb7a4		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000bb7a8		14000007		JMP 7(PC)				
  decimal_bid.go:63	0x1000bb7ac		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000bb7b0		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:63	0x1000bb7b4		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:63	0x1000bb7b8		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:63	0x1000bb7bc		97ff2d25		CALL runtime.growslice(SB)		
  decimal_bid.go:63	0x1000bb7c0		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000bb7c4		d28925a3		MOVD $18733, R3				
  decimal_bid.go:63	0x1000bb7c8		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:63	0x1000bb7cc		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:63	0x1000bb7d0		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:63	0x1000bb7d4		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:63	0x1000bb7d8		d65f03c0		RET					
  decimal_bid.go:65	0x1000bb7dc		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000bb7e0		910010a1		ADD $4, R5, R1				
  decimal_bid.go:65	0x1000bb7e4		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:65	0x1000bb7e8		eb01005f		CMP R1, R2				
  decimal_bid.go:65	0x1000bb7ec		54000063		BCC 3(PC)				
  decimal_bid.go:65	0x1000bb7f0		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000bb7f4		14000007		JMP 7(PC)				
  decimal_bid.go:65	0x1000bb7f8		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000bb7fc		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:65	0x1000bb800		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:65	0x1000bb804		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:65	0x1000bb808		97ff2d12		CALL runtime.growslice(SB)		
  decimal_bid.go:65	0x1000bb80c		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000bb810		d2892563		MOVD $18731, R3				
  decimal_bid.go:65	0x1000bb814		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:65	0x1000bb818		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:65	0x1000bb81c		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:65	0x1000bb820		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:65	0x1000bb824		d65f03c0		RET					
  decimal_bid.go:134	0x1000bb828		d2800440		MOVD $34, R0				
  decimal_bid.go:134	0x1000bb82c		97ff40dd		CALL runtime.panicBounds(SB)		
  decimal_bid.go:123	0x1000bb830		aa0403e0		MOVD R4, R0				
  decimal_bid.go:123	0x1000bb834		aa0503e1		MOVD R5, R1				
  decimal_bid.go:123	0x1000bb838		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:123	0x1000bb83c		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:123	0x1000bb840		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:123	0x1000bb844		d65f03c0		RET					
  decimal_bid.go:146	0x1000bb848		97ff40d6		CALL runtime.panicBounds(SB)		
  decimal_bid.go:121	0x1000bb84c		97ff40d5		CALL runtime.panicBounds(SB)		
  decimal_bid.go:120	0x1000bb850		97ff40d4		CALL runtime.panicBounds(SB)		
  decimal_bid.go:146	0x1000bb854		97ff40d3		CALL runtime.panicBounds(SB)		
  decimal_bid.go:119	0x1000bb858		97ff40d2		CALL runtime.panicBounds(SB)		
  decimal_bid.go:119	0x1000bb85c		97ff40d1		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb860		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:111	0x1000bb864		91000463		ADD $1, R3, R3				
  decimal_bid.go:111	0x1000bb868		eb0c007f		CMP R12, R3				
  decimal_bid.go:111	0x1000bb86c		5400010a		BGE 8(PC)				
  decimal_bid.go:112	0x1000bb870		8b010066		ADD R1, R3, R6				
  decimal_bid.go:112	0x1000bb874		eb00007f		CMP R0, R3				
  decimal_bid.go:112	0x1000bb878		540002e2		BCS 23(PC)				
  decimal_bid.go:112	0x1000bb87c		38636927		MOVBU (R9)(R3), R7			
  decimal_bid.go:112	0x1000bb880		eb0600bf		CMP R6, R5				
  decimal_bid.go:112	0x1000bb884		54fffee8		BHI -9(PC)				
  decimal_bid.go:112	0x1000bb888		14000012		JMP 18(PC)				
  decimal_bid.go:114	0x1000bb88c		8b0c0023		ADD R12, R1, R3				
  decimal_bid.go:114	0x1000bb890		eb0300bf		CMP R3, R5				
  decimal_bid.go:114	0x1000bb894		540001c9		BLS 14(PC)				
  decimal_bid.go:114	0x1000bb898		d28005c6		MOVD $46, R6				
  decimal_bid.go:114	0x1000bb89c		38236886		MOVB R6, (R4)(R3)			
  decimal_bid.go:115	0x1000bb8a0		14000003		JMP 3(PC)				
  decimal_bid.go:116	0x1000bb8a4		38236886		MOVB R6, (R4)(R3)			
  decimal_bid.go:115	0x1000bb8a8		9100058c		ADD $1, R12, R12			
  decimal_bid.go:115	0x1000bb8ac		eb00019f		CMP R0, R12				
  decimal_bid.go:115	0x1000bb8b0		54fffc0a		BGE -32(PC)				
  decimal_bid.go:116	0x1000bb8b4		8b010183		ADD R1, R12, R3				
  decimal_bid.go:116	0x1000bb8b8		91000463		ADD $1, R3, R3				
  decimal_bid.go:116	0x1000bb8bc		386c6926		MOVBU (R9)(R12), R6			
  decimal_bid.go:116	0x1000bb8c0		eb05007f		CMP R5, R3				
  decimal_bid.go:116	0x1000bb8c4		54ffff03		BCC -8(PC)				
  decimal_bid.go:116	0x1000bb8c8		97ff40b6		CALL runtime.panicBounds(SB)		
  decimal_bid.go:114	0x1000bb8cc		97ff40b5		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb8d0		97ff40b4		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb8d4		97ff40b3		CALL runtime.panicBounds(SB)		
  decimal_bid.go:105	0x1000bb8d8		97ff40b2		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb8dc		d2800440		MOVD $34, R0				
  decimal_bid.go:72	0x1000bb8e0		97ff40b0		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb8e4		d503201f		NOOP					
  decimal_bid.go:48	0x1000bb8e8		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:48	0x1000bb8ec		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:48	0x1000bb8f0		f90017e4		MOVD R4, 40(RSP)			
  decimal_bid.go:48	0x1000bb8f4		3900c3e5		MOVB R5, 48(RSP)			
  decimal_bid.go:48	0x1000bb8f8		a9039fe6		STP (R6, R7), 56(RSP)			
  decimal_bid.go:48	0x1000bb8fc		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:48	0x1000bb900		97ff3864		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:48	0x1000bb904		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:48	0x1000bb908		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:48	0x1000bb90c		f94017e4		MOVD 40(RSP), R4			
  decimal_bid.go:48	0x1000bb910		3940c3e5		MOVBU 48(RSP), R5			
  decimal_bid.go:48	0x1000bb914		a9439fe6		LDP 56(RSP), (R6, R7)			
  decimal_bid.go:48	0x1000bb918		17fffe16		JMP strconv.appendDecimal(SB)		
  decimal_bid.go:48	0x1000bb91c		00000000		?					
