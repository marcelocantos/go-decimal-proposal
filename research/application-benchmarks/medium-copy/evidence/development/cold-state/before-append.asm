TEXT strconv.appendDecimal(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:48	0x1000bb170		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:48	0x1000bb174		d10203f1		SUB $128, RSP, R17			
  decimal_bid.go:48	0x1000bb178		eb10023f		CMP R16, R17				
  decimal_bid.go:48	0x1000bb17c		54003349		BLS 410(PC)				
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
  decimal_bid.go:61	0x1000bb1d0		54002600		BEQ 304(PC)				
  decimal_bid.go:59	0x1000bb1d4		7100089f		CMPW $2, R4				
  decimal_bid.go:59	0x1000bb1d8		54002320		BEQ 281(PC)				
  decimal_bid.go:68	0x1000bb1dc		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:68	0x1000bb1e0		b6f81b20		TBZ $63, R0, 217(PC)			
  decimal_bid.go:247	0x1000bb1e4		3944c3e7		MOVBU 304(RSP), R7			
  decimal_bid.go:247	0x1000bb1e8		aa0703e9		MOVD R7, R9				
  decimal_bid.go:247	0x1000bb1ec		7101153f		CMPW $69, R9				
  decimal_bid.go:247	0x1000bb1f0		54000100		BEQ 8(PC)				
  decimal_bid.go:247	0x1000bb1f4		71011d3f		CMPW $71, R9				
  decimal_bid.go:247	0x1000bb1f8		540000c0		BEQ 6(PC)				
  decimal_bid.go:247	0x1000bb1fc		d10194e9		SUB $101, R7, R9			
  decimal_bid.go:247	0x1000bb200		d3401d29		UBFX $0, R9, $8, R9			
  decimal_bid.go:247	0x1000bb204		7100093f		CMPW $2, R9				
  decimal_bid.go:247	0x1000bb208		54000049		BLS 2(PC)				
  decimal_bid.go:247	0x1000bb20c		d2800ce7		MOVD $103, R7				
  decimal_bid.go:72	0x1000bb210		d2800449		MOVD $34, R9				
  decimal_bid.go:72	0x1000bb214		cb020129		SUB R2, R9, R9				
  decimal_bid.go:72	0x1000bb218		f100893f		CMP $34, R9				
  decimal_bid.go:72	0x1000bb21c		54002de8		BHI 367(PC)				
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
  decimal_bid.go:57	0x1000bb24c		a90983e3		STP (R3, R0), 152(RSP)			
  decimal_bid.go:76	0x1000bb250		f90077e9		MOVD R9, 232(RSP)			
  decimal_bid.go:76	0x1000bb254		36000361		TBZ $0, R1, 27(PC)			
  decimal_bid.go:77	0x1000bb258		f9408bea		MOVD 272(RSP), R10			
  decimal_bid.go:77	0x1000bb25c		91000541		ADD $1, R10, R1				
  decimal_bid.go:77	0x1000bb260		f9408fea		MOVD 280(RSP), R10			
  decimal_bid.go:77	0x1000bb264		eb01015f		CMP R1, R10				
  decimal_bid.go:77	0x1000bb268		54000063		BCC 3(PC)				
  decimal_bid.go:77	0x1000bb26c		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:77	0x1000bb270		14000010		JMP 16(PC)				
  decimal_bid.go:57	0x1000bb274		f9004be2		MOVD R2, 144(RSP)			
  decimal_bid.go:71	0x1000bb278		390193e7		MOVB R7, 100(RSP)			
  decimal_bid.go:77	0x1000bb27c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:77	0x1000bb280		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:77	0x1000bb284		b24003e3		ORR $1, ZR, R3				
  decimal_bid.go:77	0x1000bb288		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:77	0x1000bb28c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:77	0x1000bb290		97ff2e70		CALL runtime.growslice(SB)		
  decimal_bid.go:88	0x1000bb294		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:80	0x1000bb298		394193e7		MOVBU 100(RSP), R7			
  decimal_bid.go:112	0x1000bb29c		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:77	0x1000bb2a0		aa0003e4		MOVD R0, R4				
  decimal_bid.go:77	0x1000bb2a4		aa0203ea		MOVD R2, R10				
  decimal_bid.go:88	0x1000bb2a8		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:73	0x1000bb2ac		f9404be2		MOVD 144(RSP), R2			
  decimal_bid.go:77	0x1000bb2b0		d100042b		SUB $1, R1, R11				
  decimal_bid.go:77	0x1000bb2b4		d28005ac		MOVD $45, R12				
  decimal_bid.go:77	0x1000bb2b8		382b688c		MOVB R12, (R4)(R11)			
  decimal_bid.go:77	0x1000bb2bc		14000003		JMP 3(PC)				
  decimal_bid.go:79	0x1000bb2c0		a9512be1		LDP 272(RSP), (R1, R10)			
  decimal_bid.go:79	0x1000bb2c4		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:80	0x1000bb2c8		d3401ceb		UBFX $0, R7, $8, R11			
  decimal_bid.go:80	0x1000bb2cc		7101157f		CMPW $69, R11				
  decimal_bid.go:80	0x1000bb2d0		54001240		BEQ 146(PC)				
  decimal_bid.go:80	0x1000bb2d4		7101957f		CMPW $101, R11				
  decimal_bid.go:80	0x1000bb2d8		54001200		BEQ 144(PC)				
  decimal_bid.go:82	0x1000bb2dc		7101997f		CMPW $102, R11				
  decimal_bid.go:82	0x1000bb2e0		54000fe0		BEQ 127(PC)				
  decimal_bid.go:88	0x1000bb2e4		8b00006c		ADD R0, R3, R12				
  decimal_bid.go:89	0x1000bb2e8		9100158d		ADD $5, R12, R13			
  decimal_bid.go:89	0x1000bb2ec		f1006dbf		CMP $27, R13				
  decimal_bid.go:89	0x1000bb2f0		54000d82		BCS 108(PC)				
  decimal_bid.go:89	0x1000bb2f4		f100007f		CMP $0, R3				
  decimal_bid.go:89	0x1000bb2f8		54000d4c		BGT 106(PC)				
  decimal_bid.go:79	0x1000bb2fc		f90063e1		MOVD R1, 192(RSP)			
  decimal_bid.go:96	0x1000bb300		b4000983		CBZ R3, 76(PC)				
  decimal_bid.go:103	0x1000bb304		f100019f		CMP $0, R12				
  decimal_bid.go:103	0x1000bb308		540007ed		BLE 63(PC)				
  decimal_bid.go:103	0x1000bb30c		cb010148		SUB R1, R10, R8				
  decimal_bid.go:103	0x1000bb310		9100040b		ADD $1, R0, R11				
  decimal_bid.go:103	0x1000bb314		eb0b011f		CMP R11, R8				
  decimal_bid.go:103	0x1000bb318		5400076b		BLT 59(PC)				
  decimal_bid.go:105	0x1000bb31c		8b000025		ADD R0, R1, R5				
  decimal_bid.go:105	0x1000bb320		910004a5		ADD $1, R5, R5				
  decimal_bid.go:105	0x1000bb324		eb05015f		CMP R5, R10				
  decimal_bid.go:105	0x1000bb328		54002563		BCC 299(PC)				
  decimal_bid.go:110	0x1000bb32c		f100241f		CMP $9, R0				
  decimal_bid.go:110	0x1000bb330		5400006c		BGT 3(PC)				
  decimal_bid.go:110	0x1000bb334		aa1f03e3		MOVD ZR, R3				
  decimal_bid.go:110	0x1000bb338		1400010b		JMP 267(PC)				
  decimal_bid.go:119	0x1000bb33c		eb05003f		CMP R5, R1				
  decimal_bid.go:119	0x1000bb340		540020c8		BHI 262(PC)				
  decimal_bid.go:119	0x1000bb344		cb0a0026		SUB R10, R1, R6				
  decimal_bid.go:119	0x1000bb348		8a86fc26		AND R6->63, R1, R6			
  decimal_bid.go:119	0x1000bb34c		8b060086		ADD R6, R4, R6				
  decimal_bid.go:119	0x1000bb350		eb0c001f		CMP R12, R0				
  decimal_bid.go:119	0x1000bb354		54002003		BCC 256(PC)				
  decimal_bid.go:105	0x1000bb358		a90b17ea		STP (R10, R5), 176(RSP)			
  decimal_bid.go:79	0x1000bb35c		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:119	0x1000bb360		eb0c017f		CMP R12, R11				
  decimal_bid.go:119	0x1000bb364		9a80c582		CSINC GT, R12, R0, R2			
  decimal_bid.go:119	0x1000bb368		eb06013f		CMP R6, R9				
  decimal_bid.go:119	0x1000bb36c		54000180		BEQ 12(PC)				
  decimal_bid.go:88	0x1000bb370		f90057ec		MOVD R12, 168(RSP)			
  decimal_bid.go:119	0x1000bb374		aa0603e0		MOVD R6, R0				
  decimal_bid.go:119	0x1000bb378		aa0903e1		MOVD R9, R1				
  decimal_bid.go:119	0x1000bb37c		97ff428d		CALL runtime.memmove(SB)		
  decimal_bid.go:119	0x1000bb380		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:120	0x1000bb384		f94063e1		MOVD 192(RSP), R1			
  decimal_bid.go:121	0x1000bb388		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:120	0x1000bb38c		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:120	0x1000bb390		f9405fe5		MOVD 184(RSP), R5			
  decimal_bid.go:121	0x1000bb394		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:121	0x1000bb398		a94aabec		LDP 168(RSP), (R12, R10)		
  decimal_bid.go:120	0x1000bb39c		8b0c0026		ADD R12, R1, R6				
  decimal_bid.go:120	0x1000bb3a0		eb0600bf		CMP R6, R5				
  decimal_bid.go:120	0x1000bb3a4		54001d69		BLS 235(PC)				
  decimal_bid.go:120	0x1000bb3a8		d28005c7		MOVD $46, R7				
  decimal_bid.go:120	0x1000bb3ac		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:121	0x1000bb3b0		cb060147		SUB R6, R10, R7				
  decimal_bid.go:121	0x1000bb3b4		d10004e7		SUB $1, R7, R7				
  decimal_bid.go:121	0x1000bb3b8		cb0703e7		NEG R7, R7				
  decimal_bid.go:121	0x1000bb3bc		910004c6		ADD $1, R6, R6				
  decimal_bid.go:121	0x1000bb3c0		8a87fcc6		AND R7->63, R6, R6			
  decimal_bid.go:121	0x1000bb3c4		8b060086		ADD R6, R4, R6				
  decimal_bid.go:119	0x1000bb3c8		eb0c001f		CMP R12, R0				
  decimal_bid.go:121	0x1000bb3cc		54001c03		BCC 224(PC)				
  decimal_bid.go:121	0x1000bb3d0		cb0303e7		NEG R3, R7				
  decimal_bid.go:121	0x1000bb3d4		cb000188		SUB R0, R12, R8				
  decimal_bid.go:121	0x1000bb3d8		8a88fd88		AND R8->63, R12, R8			
  decimal_bid.go:121	0x1000bb3dc		8b080121		ADD R8, R9, R1				
  decimal_bid.go:121	0x1000bb3e0		eb0700ff		CMP R7, R7				
  decimal_bid.go:121	0x1000bb3e4		da83b4e2		CSNEG LT, R7, R3, R2			
  decimal_bid.go:121	0x1000bb3e8		eb06003f		CMP R6, R1				
  decimal_bid.go:121	0x1000bb3ec		54001a40		BEQ 210(PC)				
  decimal_bid.go:121	0x1000bb3f0		aa0603e0		MOVD R6, R0				
  decimal_bid.go:121	0x1000bb3f4		97ff426f		CALL runtime.memmove(SB)		
  decimal_bid.go:123	0x1000bb3f8		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:123	0x1000bb3fc		a94b17ea		LDP 176(RSP), (R10, R5)			
  decimal_bid.go:121	0x1000bb400		140000cd		JMP 205(PC)				
  decimal_bid.go:125	0x1000bb404		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:125	0x1000bb408		aa0003e5		MOVD R0, R5				
  decimal_bid.go:125	0x1000bb40c		aa0303e6		MOVD R3, R6				
  decimal_bid.go:125	0x1000bb410		92800007		MOVD $-1, R7				
  decimal_bid.go:125	0x1000bb414		aa0403e0		MOVD R4, R0				
  decimal_bid.go:125	0x1000bb418		aa0903e3		MOVD R9, R3				
  decimal_bid.go:125	0x1000bb41c		aa0503e4		MOVD R5, R4				
  decimal_bid.go:125	0x1000bb420		97fff164		CALL strconv.appendFixed(SB)		
  decimal_bid.go:125	0x1000bb424		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:125	0x1000bb428		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:125	0x1000bb42c		d65f03c0		RET					
  decimal_bid.go:97	0x1000bb430		8b000025		ADD R0, R1, R5				
  decimal_bid.go:97	0x1000bb434		eb05015f		CMP R5, R10				
  decimal_bid.go:97	0x1000bb438		540001c2		BCS 14(PC)				
  decimal_bid.go:97	0x1000bb43c		aa0503e1		MOVD R5, R1				
  decimal_bid.go:97	0x1000bb440		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:97	0x1000bb444		aa0003e3		MOVD R0, R3				
  decimal_bid.go:97	0x1000bb448		aa0403e0		MOVD R4, R0				
  decimal_bid.go:97	0x1000bb44c		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:97	0x1000bb450		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:97	0x1000bb454		97ff2dff		CALL runtime.growslice(SB)		
  decimal_bid.go:97	0x1000bb458		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:97	0x1000bb45c		aa0003e4		MOVD R0, R4				
  decimal_bid.go:97	0x1000bb460		aa0203ea		MOVD R2, R10				
  decimal_bid.go:97	0x1000bb464		aa0103e5		MOVD R1, R5				
  decimal_bid.go:97	0x1000bb468		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:97	0x1000bb46c		f94063e1		MOVD 192(RSP), R1			
  decimal_bid.go:97	0x1000bb470		a90babe5		STP (R5, R10), 184(RSP)			
  decimal_bid.go:97	0x1000bb474		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:97	0x1000bb478		8b010083		ADD R1, R4, R3				
  decimal_bid.go:97	0x1000bb47c		aa0903e1		MOVD R9, R1				
  decimal_bid.go:97	0x1000bb480		aa0003e2		MOVD R0, R2				
  decimal_bid.go:97	0x1000bb484		aa0303e0		MOVD R3, R0				
  decimal_bid.go:97	0x1000bb488		97ff424a		CALL runtime.memmove(SB)		
  decimal_bid.go:97	0x1000bb48c		f9407be0		MOVD 240(RSP), R0			
  decimal_bid.go:97	0x1000bb490		a94b8be1		LDP 184(RSP), (R1, R2)			
  decimal_bid.go:97	0x1000bb494		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:97	0x1000bb498		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:97	0x1000bb49c		d65f03c0		RET					
  decimal_bid.go:91	0x1000bb4a0		71011d7f		CMPW $71, R11				
  decimal_bid.go:94	0x1000bb4a4		d28008ab		MOVD $69, R11				
  decimal_bid.go:94	0x1000bb4a8		d2800cac		MOVD $101, R12				
  decimal_bid.go:94	0x1000bb4ac		9a8c0167		CSEL EQ, R11, R12, R7			
  decimal_bid.go:94	0x1000bb4b0		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:94	0x1000bb4b4		aa0003e5		MOVD R0, R5				
  decimal_bid.go:94	0x1000bb4b8		aa0303e6		MOVD R3, R6				
  decimal_bid.go:94	0x1000bb4bc		92800008		MOVD $-1, R8				
  decimal_bid.go:94	0x1000bb4c0		aa0403e0		MOVD R4, R0				
  decimal_bid.go:94	0x1000bb4c4		aa0903e3		MOVD R9, R3				
  decimal_bid.go:94	0x1000bb4c8		aa0503e4		MOVD R5, R4				
  decimal_bid.go:94	0x1000bb4cc		97fff2a1		CALL strconv.appendExp(SB)		
  decimal_bid.go:91	0x1000bb4d0		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:91	0x1000bb4d4		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:91	0x1000bb4d8		d65f03c0		RET					
  decimal_bid.go:73	0x1000bb4dc		f100005f		CMP $0, R2				
  decimal_bid.go:84	0x1000bb4e0		f100007f		CMP $0, R3				
  decimal_bid.go:84	0x1000bb4e4		9a9fd068		CSEL LE, R3, ZR, R8			
  decimal_bid.go:73	0x1000bb4e8		f100005f		CMP $0, R2				
  decimal_bid.go:86	0x1000bb4ec		9a830106		CSEL EQ, R8, R3, R6			
  decimal_bid.go:86	0x1000bb4f0		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:86	0x1000bb4f4		aa0903e3		MOVD R9, R3				
  decimal_bid.go:86	0x1000bb4f8		aa0003e5		MOVD R0, R5				
  decimal_bid.go:86	0x1000bb4fc		92800007		MOVD $-1, R7				
  decimal_bid.go:86	0x1000bb500		aa0403e0		MOVD R4, R0				
  decimal_bid.go:86	0x1000bb504		aa0503e4		MOVD R5, R4				
  decimal_bid.go:86	0x1000bb508		97fff12a		CALL strconv.appendFixed(SB)		
  decimal_bid.go:83	0x1000bb50c		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:83	0x1000bb510		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:83	0x1000bb514		d65f03c0		RET					
  decimal_bid.go:81	0x1000bb518		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:81	0x1000bb51c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:81	0x1000bb520		aa0303e6		MOVD R3, R6				
  decimal_bid.go:81	0x1000bb524		92800008		MOVD $-1, R8				
  decimal_bid.go:81	0x1000bb528		aa0403e0		MOVD R4, R0				
  decimal_bid.go:81	0x1000bb52c		aa0903e3		MOVD R9, R3				
  decimal_bid.go:81	0x1000bb530		aa0503e4		MOVD R5, R4				
  decimal_bid.go:81	0x1000bb534		97fff287		CALL strconv.appendExp(SB)		
  decimal_bid.go:81	0x1000bb538		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:81	0x1000bb53c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:81	0x1000bb540		d65f03c0		RET					
  decimal_bid.go:127	0x1000bb544		390323e1		MOVB R1, 200(RSP)			
  decimal_bid.go:127	0x1000bb548		a90d0fe2		STP (R2, R3), 208(RSP)			
  decimal_bid.go:127	0x1000bb54c		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:127	0x1000bb550		f90073ea		MOVD R10, 224(RSP)			
  decimal_bid.go:128	0x1000bb554		f100005f		CMP $0, R2				
  decimal_bid.go:128	0x1000bb558		5400024d		BLE 18(PC)				
  decimal_bid.go:247	0x1000bb55c		3944c3e3		MOVBU 304(RSP), R3			
  decimal_bid.go:247	0x1000bb560		aa0303e5		MOVD R3, R5				
  decimal_bid.go:247	0x1000bb564		710114bf		CMPW $69, R5				
  decimal_bid.go:247	0x1000bb568		54000100		BEQ 8(PC)				
  decimal_bid.go:247	0x1000bb56c		71011cbf		CMPW $71, R5				
  decimal_bid.go:247	0x1000bb570		540000c0		BEQ 6(PC)				
  decimal_bid.go:247	0x1000bb574		d1019465		SUB $101, R3, R5			
  decimal_bid.go:247	0x1000bb578		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:247	0x1000bb57c		710008bf		CMPW $2, R5				
  decimal_bid.go:247	0x1000bb580		54000049		BLS 2(PC)				
  decimal_bid.go:247	0x1000bb584		d2800ce3		MOVD $103, R3				
  decimal_bid.go:129	0x1000bb588		f94047e1		MOVD 136(RSP), R1			
  decimal_bid.go:129	0x1000bb58c		f94093e2		MOVD 288(RSP), R2			
  decimal_bid.go:129	0x1000bb590		aa0003e4		MOVD R0, R4				
  decimal_bid.go:129	0x1000bb594		910323e0		ADD $200, RSP, R0			
  decimal_bid.go:129	0x1000bb598		97ffef2a		CALL strconv.(*finite).round(SB)	
  decimal_bid.go:134	0x1000bb59c		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:131	0x1000bb5a0		f9406be7		MOVD 208(RSP), R7			
  decimal_bid.go:131	0x1000bb5a4		b40003a7		CBZ R7, 29(PC)				
  decimal_bid.go:134	0x1000bb5a8		f94073ea		MOVD 224(RSP), R10			
  decimal_bid.go:134	0x1000bb5ac		3980015b		MOVB (R10), R27				
  decimal_bid.go:134	0x1000bb5b0		d280044b		MOVD $34, R11				
  decimal_bid.go:134	0x1000bb5b4		cb07016b		SUB R7, R11, R11			
  decimal_bid.go:134	0x1000bb5b8		f100897f		CMP $34, R11				
  decimal_bid.go:134	0x1000bb5bc		54000b88		BHI 92(PC)				
  decimal_bid.go:247	0x1000bb5c0		3944c3e8		MOVBU 304(RSP), R8			
  decimal_bid.go:247	0x1000bb5c4		aa0803ec		MOVD R8, R12				
  decimal_bid.go:134	0x1000bb5c8		8b0b0145		ADD R11, R10, R5			
  decimal_bid.go:247	0x1000bb5cc		7101159f		CMPW $69, R12				
  decimal_bid.go:247	0x1000bb5d0		54000100		BEQ 8(PC)				
  decimal_bid.go:247	0x1000bb5d4		71011d9f		CMPW $71, R12				
  decimal_bid.go:247	0x1000bb5d8		540000c0		BEQ 6(PC)				
  decimal_bid.go:247	0x1000bb5dc		d101950a		SUB $101, R8, R10			
  decimal_bid.go:247	0x1000bb5e0		d3401d4a		UBFX $0, R10, $8, R10			
  decimal_bid.go:247	0x1000bb5e4		7100095f		CMPW $2, R10				
  decimal_bid.go:247	0x1000bb5e8		54000049		BLS 2(PC)				
  decimal_bid.go:247	0x1000bb5ec		d2800ce8		MOVD $103, R8				
  decimal_bid.go:134	0x1000bb5f0		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:134	0x1000bb5f4		f9406fe4		MOVD 216(RSP), R4			
  decimal_bid.go:134	0x1000bb5f8		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:134	0x1000bb5fc		aa0703e6		MOVD R7, R6				
  decimal_bid.go:134	0x1000bb600		aa0003e9		MOVD R0, R9				
  decimal_bid.go:134	0x1000bb604		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:134	0x1000bb608		97fff07a		CALL strconv.formatDigits(SB)		
  decimal_bid.go:134	0x1000bb60c		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:134	0x1000bb610		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:134	0x1000bb614		d65f03c0		RET					
  decimal_bid.go:132	0x1000bb618		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:132	0x1000bb61c		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:132	0x1000bb620		3944c3e4		MOVBU 304(RSP), R4			
  decimal_bid.go:132	0x1000bb624		aa0003e5		MOVD R0, R5				
  decimal_bid.go:132	0x1000bb628		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:132	0x1000bb62c		97ffef9d		CALL strconv.appendZero(SB)		
  decimal_bid.go:132	0x1000bb630		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:132	0x1000bb634		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:132	0x1000bb638		d65f03c0		RET					
  decimal_bid.go:60	0x1000bb63c		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000bb640		91000ca1		ADD $3, R5, R1				
  decimal_bid.go:60	0x1000bb644		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:60	0x1000bb648		eb01005f		CMP R1, R2				
  decimal_bid.go:60	0x1000bb64c		54000063		BCC 3(PC)				
  decimal_bid.go:60	0x1000bb650		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000bb654		14000007		JMP 7(PC)				
  decimal_bid.go:60	0x1000bb658		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000bb65c		b24007e3		ORR $3, ZR, R3				
  decimal_bid.go:60	0x1000bb660		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:60	0x1000bb664		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:60	0x1000bb668		97ff2d7a		CALL runtime.growslice(SB)		
  decimal_bid.go:60	0x1000bb66c		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000bb670		8b0000a3		ADD R0, R5, R3				
  decimal_bid.go:60	0x1000bb674		d28c29c4		MOVD $24910, R4				
  decimal_bid.go:60	0x1000bb678		78256804		MOVH R4, (R0)(R5)			
  decimal_bid.go:60	0x1000bb67c		d28009c4		MOVD $78, R4				
  decimal_bid.go:60	0x1000bb680		39000864		MOVB R4, 2(R3)				
  decimal_bid.go:60	0x1000bb684		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:60	0x1000bb688		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:60	0x1000bb68c		d65f03c0		RET					
  decimal_bid.go:62	0x1000bb690		36000281		TBZ $0, R1, 20(PC)			
  decimal_bid.go:63	0x1000bb694		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000bb698		910010a1		ADD $4, R5, R1				
  decimal_bid.go:63	0x1000bb69c		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:63	0x1000bb6a0		eb01005f		CMP R1, R2				
  decimal_bid.go:63	0x1000bb6a4		54000063		BCC 3(PC)				
  decimal_bid.go:63	0x1000bb6a8		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000bb6ac		14000007		JMP 7(PC)				
  decimal_bid.go:63	0x1000bb6b0		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000bb6b4		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:63	0x1000bb6b8		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:63	0x1000bb6bc		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:63	0x1000bb6c0		97ff2d64		CALL runtime.growslice(SB)		
  decimal_bid.go:63	0x1000bb6c4		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000bb6c8		d28925a3		MOVD $18733, R3				
  decimal_bid.go:63	0x1000bb6cc		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:63	0x1000bb6d0		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:63	0x1000bb6d4		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:63	0x1000bb6d8		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:63	0x1000bb6dc		d65f03c0		RET					
  decimal_bid.go:65	0x1000bb6e0		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000bb6e4		910010a1		ADD $4, R5, R1				
  decimal_bid.go:65	0x1000bb6e8		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:65	0x1000bb6ec		eb01005f		CMP R1, R2				
  decimal_bid.go:65	0x1000bb6f0		54000063		BCC 3(PC)				
  decimal_bid.go:65	0x1000bb6f4		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000bb6f8		14000007		JMP 7(PC)				
  decimal_bid.go:65	0x1000bb6fc		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000bb700		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:65	0x1000bb704		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:65	0x1000bb708		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:65	0x1000bb70c		97ff2d51		CALL runtime.growslice(SB)		
  decimal_bid.go:65	0x1000bb710		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000bb714		d2892563		MOVD $18731, R3				
  decimal_bid.go:65	0x1000bb718		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:65	0x1000bb71c		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:65	0x1000bb720		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:65	0x1000bb724		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:65	0x1000bb728		d65f03c0		RET					
  decimal_bid.go:134	0x1000bb72c		d2800440		MOVD $34, R0				
  decimal_bid.go:134	0x1000bb730		97ff411c		CALL runtime.panicBounds(SB)		
  decimal_bid.go:123	0x1000bb734		aa0403e0		MOVD R4, R0				
  decimal_bid.go:123	0x1000bb738		aa0503e1		MOVD R5, R1				
  decimal_bid.go:123	0x1000bb73c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:123	0x1000bb740		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:123	0x1000bb744		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:123	0x1000bb748		d65f03c0		RET					
  decimal_bid.go:121	0x1000bb74c		97ff4115		CALL runtime.panicBounds(SB)		
  decimal_bid.go:120	0x1000bb750		97ff4114		CALL runtime.panicBounds(SB)		
  decimal_bid.go:119	0x1000bb754		97ff4113		CALL runtime.panicBounds(SB)		
  decimal_bid.go:119	0x1000bb758		97ff4112		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb75c		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:111	0x1000bb760		91000463		ADD $1, R3, R3				
  decimal_bid.go:111	0x1000bb764		eb0c007f		CMP R12, R3				
  decimal_bid.go:111	0x1000bb768		5400010a		BGE 8(PC)				
  decimal_bid.go:112	0x1000bb76c		8b010066		ADD R1, R3, R6				
  decimal_bid.go:112	0x1000bb770		eb00007f		CMP R0, R3				
  decimal_bid.go:112	0x1000bb774		540002e2		BCS 23(PC)				
  decimal_bid.go:112	0x1000bb778		38636927		MOVBU (R9)(R3), R7			
  decimal_bid.go:112	0x1000bb77c		eb0600bf		CMP R6, R5				
  decimal_bid.go:112	0x1000bb780		54fffee8		BHI -9(PC)				
  decimal_bid.go:112	0x1000bb784		14000012		JMP 18(PC)				
  decimal_bid.go:114	0x1000bb788		8b0c0023		ADD R12, R1, R3				
  decimal_bid.go:114	0x1000bb78c		eb0300bf		CMP R3, R5				
  decimal_bid.go:114	0x1000bb790		540001c9		BLS 14(PC)				
  decimal_bid.go:114	0x1000bb794		d28005c6		MOVD $46, R6				
  decimal_bid.go:114	0x1000bb798		38236886		MOVB R6, (R4)(R3)			
  decimal_bid.go:115	0x1000bb79c		14000003		JMP 3(PC)				
  decimal_bid.go:116	0x1000bb7a0		38236886		MOVB R6, (R4)(R3)			
  decimal_bid.go:115	0x1000bb7a4		9100058c		ADD $1, R12, R12			
  decimal_bid.go:115	0x1000bb7a8		eb00019f		CMP R0, R12				
  decimal_bid.go:115	0x1000bb7ac		54fffc4a		BGE -30(PC)				
  decimal_bid.go:116	0x1000bb7b0		8b010183		ADD R1, R12, R3				
  decimal_bid.go:116	0x1000bb7b4		91000463		ADD $1, R3, R3				
  decimal_bid.go:116	0x1000bb7b8		386c6926		MOVBU (R9)(R12), R6			
  decimal_bid.go:116	0x1000bb7bc		eb05007f		CMP R5, R3				
  decimal_bid.go:116	0x1000bb7c0		54ffff03		BCC -8(PC)				
  decimal_bid.go:116	0x1000bb7c4		97ff40f7		CALL runtime.panicBounds(SB)		
  decimal_bid.go:114	0x1000bb7c8		97ff40f6		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb7cc		97ff40f5		CALL runtime.panicBounds(SB)		
  decimal_bid.go:112	0x1000bb7d0		97ff40f4		CALL runtime.panicBounds(SB)		
  decimal_bid.go:105	0x1000bb7d4		97ff40f3		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb7d8		d2800440		MOVD $34, R0				
  decimal_bid.go:72	0x1000bb7dc		97ff40f1		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb7e0		d503201f		NOOP					
  decimal_bid.go:48	0x1000bb7e4		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:48	0x1000bb7e8		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:48	0x1000bb7ec		f90017e4		MOVD R4, 40(RSP)			
  decimal_bid.go:48	0x1000bb7f0		3900c3e5		MOVB R5, 48(RSP)			
  decimal_bid.go:48	0x1000bb7f4		a9039fe6		STP (R6, R7), 56(RSP)			
  decimal_bid.go:48	0x1000bb7f8		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:48	0x1000bb7fc		97ff38a5		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:48	0x1000bb800		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:48	0x1000bb804		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:48	0x1000bb808		f94017e4		MOVD 40(RSP), R4			
  decimal_bid.go:48	0x1000bb80c		3940c3e5		MOVBU 48(RSP), R5			
  decimal_bid.go:48	0x1000bb810		a9439fe6		LDP 56(RSP), (R6, R7)			
  decimal_bid.go:48	0x1000bb814		17fffe57		JMP strconv.appendDecimal(SB)		
  decimal_bid.go:48	0x1000bb818		00000000		?					
  decimal_bid.go:48	0x1000bb81c		00000000		?					
