TEXT strconv.appendDecimal(SB) /Users/marcelo/work/wt/gd-survey/src/strconv/decimal_bid.go
  decimal_bid.go:48	0x1000bb170		f9400b90		MOVD 16(R28), R16			
  decimal_bid.go:48	0x1000bb174		d10203f1		SUB $128, RSP, R17			
  decimal_bid.go:48	0x1000bb178		eb10023f		CMP R16, R17				
  decimal_bid.go:48	0x1000bb17c		54002f09		BLS 376(PC)				
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
  decimal_bid.go:61	0x1000bb1d0		54000501		BNE 40(PC)				
  decimal_bid.go:62	0x1000bb1d4		36000281		TBZ $0, R1, 20(PC)			
  decimal_bid.go:63	0x1000bb1d8		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000bb1dc		910010a1		ADD $4, R5, R1				
  decimal_bid.go:63	0x1000bb1e0		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:63	0x1000bb1e4		eb01005f		CMP R1, R2				
  decimal_bid.go:63	0x1000bb1e8		54000063		BCC 3(PC)				
  decimal_bid.go:63	0x1000bb1ec		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000bb1f0		14000007		JMP 7(PC)				
  decimal_bid.go:63	0x1000bb1f4		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:63	0x1000bb1f8		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:63	0x1000bb1fc		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:63	0x1000bb200		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:63	0x1000bb204		97ff2e93		CALL runtime.growslice(SB)		
  decimal_bid.go:63	0x1000bb208		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:63	0x1000bb20c		d28925a3		MOVD $18733, R3				
  decimal_bid.go:63	0x1000bb210		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:63	0x1000bb214		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:63	0x1000bb218		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:63	0x1000bb21c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:63	0x1000bb220		d65f03c0		RET					
  decimal_bid.go:65	0x1000bb224		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000bb228		910010a1		ADD $4, R5, R1				
  decimal_bid.go:65	0x1000bb22c		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:65	0x1000bb230		eb01005f		CMP R1, R2				
  decimal_bid.go:65	0x1000bb234		54000063		BCC 3(PC)				
  decimal_bid.go:65	0x1000bb238		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000bb23c		14000007		JMP 7(PC)				
  decimal_bid.go:65	0x1000bb240		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:65	0x1000bb244		b27e03e3		ORR $4, ZR, R3				
  decimal_bid.go:65	0x1000bb248		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:65	0x1000bb24c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:65	0x1000bb250		97ff2e80		CALL runtime.growslice(SB)		
  decimal_bid.go:65	0x1000bb254		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:65	0x1000bb258		d2892563		MOVD $18731, R3				
  decimal_bid.go:65	0x1000bb25c		f2accdc3		MOVK $(26222<<16), R3			
  decimal_bid.go:65	0x1000bb260		b8256803		MOVW R3, (R0)(R5)			
  decimal_bid.go:65	0x1000bb264		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:65	0x1000bb268		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:65	0x1000bb26c		d65f03c0		RET					
  decimal_bid.go:59	0x1000bb270		7100089f		CMPW $2, R4				
  decimal_bid.go:59	0x1000bb274		540002c1		BNE 22(PC)				
  decimal_bid.go:60	0x1000bb278		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000bb27c		91000ca1		ADD $3, R5, R1				
  decimal_bid.go:60	0x1000bb280		f9408fe2		MOVD 280(RSP), R2			
  decimal_bid.go:60	0x1000bb284		eb01005f		CMP R1, R2				
  decimal_bid.go:60	0x1000bb288		54000063		BCC 3(PC)				
  decimal_bid.go:60	0x1000bb28c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000bb290		14000007		JMP 7(PC)				
  decimal_bid.go:60	0x1000bb294		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:60	0x1000bb298		b24007e3		ORR $3, ZR, R3				
  decimal_bid.go:60	0x1000bb29c		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:60	0x1000bb2a0		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:60	0x1000bb2a4		97ff2e6b		CALL runtime.growslice(SB)		
  decimal_bid.go:60	0x1000bb2a8		f9408be5		MOVD 272(RSP), R5			
  decimal_bid.go:60	0x1000bb2ac		8b0000a3		ADD R0, R5, R3				
  decimal_bid.go:60	0x1000bb2b0		d28c29c4		MOVD $24910, R4				
  decimal_bid.go:60	0x1000bb2b4		78256804		MOVH R4, (R0)(R5)			
  decimal_bid.go:60	0x1000bb2b8		d28009c4		MOVD $78, R4				
  decimal_bid.go:60	0x1000bb2bc		39000864		MOVB R4, 2(R3)				
  decimal_bid.go:60	0x1000bb2c0		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:60	0x1000bb2c4		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:60	0x1000bb2c8		d65f03c0		RET					
  decimal_bid.go:68	0x1000bb2cc		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:68	0x1000bb2d0		b6f81b60		TBZ $63, R0, 219(PC)			
  decimal_bid.go:233	0x1000bb2d4		3944c3e7		MOVBU 304(RSP), R7			
  decimal_bid.go:233	0x1000bb2d8		aa0703e9		MOVD R7, R9				
  decimal_bid.go:233	0x1000bb2dc		7101153f		CMPW $69, R9				
  decimal_bid.go:233	0x1000bb2e0		54000100		BEQ 8(PC)				
  decimal_bid.go:233	0x1000bb2e4		71011d3f		CMPW $71, R9				
  decimal_bid.go:233	0x1000bb2e8		540000c0		BEQ 6(PC)				
  decimal_bid.go:233	0x1000bb2ec		d10194e9		SUB $101, R7, R9			
  decimal_bid.go:233	0x1000bb2f0		d3401d29		UBFX $0, R9, $8, R9			
  decimal_bid.go:233	0x1000bb2f4		7100093f		CMPW $2, R9				
  decimal_bid.go:233	0x1000bb2f8		54000049		BLS 2(PC)				
  decimal_bid.go:233	0x1000bb2fc		d2800ce7		MOVD $103, R7				
  decimal_bid.go:72	0x1000bb300		d2800449		MOVD $34, R9				
  decimal_bid.go:72	0x1000bb304		cb020129		SUB R2, R9, R9				
  decimal_bid.go:72	0x1000bb308		f100893f		CMP $34, R9				
  decimal_bid.go:72	0x1000bb30c		54002228		BHI 273(PC)				
  decimal_bid.go:72	0x1000bb310		cb0203ea		NEG R2, R10				
  decimal_bid.go:72	0x1000bb314		8a8afd29		AND R10->63, R9, R9			
  decimal_bid.go:72	0x1000bb318		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:72	0x1000bb31c		8b090149		ADD R9, R10, R9				
  decimal_bid.go:73	0x1000bb320		b50000c2		CBNZ R2, 6(PC)				
  decimal_bid.go:74	0x1000bb324		b27c07ea		ORR $48, ZR, R10			
  decimal_bid.go:74	0x1000bb328		39021fea		MOVB R10, 135(RSP)			
  decimal_bid.go:74	0x1000bb32c		b24003e0		ORR $1, ZR, R0				
  decimal_bid.go:74	0x1000bb330		91021fe9		ADD $135, RSP, R9			
  decimal_bid.go:74	0x1000bb334		14000002		JMP 2(PC)				
  decimal_bid.go:76	0x1000bb338		aa0203e0		MOVD R2, R0				
  decimal_bid.go:57	0x1000bb33c		a90983e3		STP (R3, R0), 152(RSP)			
  decimal_bid.go:76	0x1000bb340		f90077e9		MOVD R9, 232(RSP)			
  decimal_bid.go:76	0x1000bb344		36000361		TBZ $0, R1, 27(PC)			
  decimal_bid.go:77	0x1000bb348		f9408bea		MOVD 272(RSP), R10			
  decimal_bid.go:77	0x1000bb34c		91000541		ADD $1, R10, R1				
  decimal_bid.go:77	0x1000bb350		f9408fea		MOVD 280(RSP), R10			
  decimal_bid.go:77	0x1000bb354		eb01015f		CMP R1, R10				
  decimal_bid.go:77	0x1000bb358		54000063		BCC 3(PC)				
  decimal_bid.go:77	0x1000bb35c		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:77	0x1000bb360		14000010		JMP 16(PC)				
  decimal_bid.go:57	0x1000bb364		f9004be2		MOVD R2, 144(RSP)			
  decimal_bid.go:71	0x1000bb368		390193e7		MOVB R7, 100(RSP)			
  decimal_bid.go:77	0x1000bb36c		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:77	0x1000bb370		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:77	0x1000bb374		b24003e3		ORR $1, ZR, R3				
  decimal_bid.go:77	0x1000bb378		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:77	0x1000bb37c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:77	0x1000bb380		97ff2e34		CALL runtime.growslice(SB)		
  decimal_bid.go:81	0x1000bb384		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:80	0x1000bb388		394193e7		MOVBU 100(RSP), R7			
  decimal_bid.go:81	0x1000bb38c		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:77	0x1000bb390		aa0003e4		MOVD R0, R4				
  decimal_bid.go:77	0x1000bb394		aa0203ea		MOVD R2, R10				
  decimal_bid.go:81	0x1000bb398		f94053e0		MOVD 160(RSP), R0			
  decimal_bid.go:73	0x1000bb39c		f9404be2		MOVD 144(RSP), R2			
  decimal_bid.go:77	0x1000bb3a0		d100042b		SUB $1, R1, R11				
  decimal_bid.go:77	0x1000bb3a4		d28005ac		MOVD $45, R12				
  decimal_bid.go:77	0x1000bb3a8		382b688c		MOVB R12, (R4)(R11)			
  decimal_bid.go:77	0x1000bb3ac		14000003		JMP 3(PC)				
  decimal_bid.go:79	0x1000bb3b0		a9512be1		LDP 272(RSP), (R1, R10)			
  decimal_bid.go:79	0x1000bb3b4		f94087e4		MOVD 264(RSP), R4			
  decimal_bid.go:80	0x1000bb3b8		d3401ceb		UBFX $0, R7, $8, R11			
  decimal_bid.go:80	0x1000bb3bc		7101157f		CMPW $69, R11				
  decimal_bid.go:80	0x1000bb3c0		54000060		BEQ 3(PC)				
  decimal_bid.go:80	0x1000bb3c4		7101957f		CMPW $101, R11				
  decimal_bid.go:80	0x1000bb3c8		54000181		BNE 12(PC)				
  decimal_bid.go:81	0x1000bb3cc		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:81	0x1000bb3d0		aa0003e5		MOVD R0, R5				
  decimal_bid.go:81	0x1000bb3d4		aa0303e6		MOVD R3, R6				
  decimal_bid.go:81	0x1000bb3d8		92800008		MOVD $-1, R8				
  decimal_bid.go:81	0x1000bb3dc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:81	0x1000bb3e0		aa0903e3		MOVD R9, R3				
  decimal_bid.go:81	0x1000bb3e4		aa0503e4		MOVD R5, R4				
  decimal_bid.go:81	0x1000bb3e8		97fff2da		CALL strconv.appendExp(SB)		
  decimal_bid.go:81	0x1000bb3ec		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:81	0x1000bb3f0		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:81	0x1000bb3f4		d65f03c0		RET					
  decimal_bid.go:82	0x1000bb3f8		7101997f		CMPW $102, R11				
  decimal_bid.go:82	0x1000bb3fc		54001020		BEQ 129(PC)				
  decimal_bid.go:88	0x1000bb400		8b00006c		ADD R0, R3, R12				
  decimal_bid.go:89	0x1000bb404		9100158d		ADD $5, R12, R13			
  decimal_bid.go:89	0x1000bb408		f1006dbf		CMP $27, R13				
  decimal_bid.go:89	0x1000bb40c		54000062		BCS 3(PC)				
  decimal_bid.go:89	0x1000bb410		f100007f		CMP $0, R3				
  decimal_bid.go:89	0x1000bb414		5400020d		BLE 16(PC)				
  decimal_bid.go:91	0x1000bb418		71011d7f		CMPW $71, R11				
  decimal_bid.go:94	0x1000bb41c		d28008ab		MOVD $69, R11				
  decimal_bid.go:94	0x1000bb420		d2800cac		MOVD $101, R12				
  decimal_bid.go:94	0x1000bb424		9a8c0167		CSEL EQ, R11, R12, R7			
  decimal_bid.go:94	0x1000bb428		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:94	0x1000bb42c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:94	0x1000bb430		aa0303e6		MOVD R3, R6				
  decimal_bid.go:94	0x1000bb434		92800008		MOVD $-1, R8				
  decimal_bid.go:94	0x1000bb438		aa0403e0		MOVD R4, R0				
  decimal_bid.go:94	0x1000bb43c		aa0903e3		MOVD R9, R3				
  decimal_bid.go:94	0x1000bb440		aa0503e4		MOVD R5, R4				
  decimal_bid.go:94	0x1000bb444		97fff2c3		CALL strconv.appendExp(SB)		
  decimal_bid.go:91	0x1000bb448		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:91	0x1000bb44c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:91	0x1000bb450		d65f03c0		RET					
  decimal_bid.go:79	0x1000bb454		f90057e1		MOVD R1, 168(RSP)			
  decimal_bid.go:96	0x1000bb458		b50003c3		CBNZ R3, 30(PC)				
  decimal_bid.go:97	0x1000bb45c		8b000025		ADD R0, R1, R5				
  decimal_bid.go:97	0x1000bb460		eb05015f		CMP R5, R10				
  decimal_bid.go:97	0x1000bb464		540001a2		BCS 13(PC)				
  decimal_bid.go:97	0x1000bb468		aa0503e1		MOVD R5, R1				
  decimal_bid.go:97	0x1000bb46c		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:97	0x1000bb470		aa0003e3		MOVD R0, R3				
  decimal_bid.go:97	0x1000bb474		aa0403e0		MOVD R4, R0				
  decimal_bid.go:97	0x1000bb478		90001804		ADRP 3145728(PC), R4			
  decimal_bid.go:97	0x1000bb47c		913e8084		ADD $4000, R4, R4			
  decimal_bid.go:97	0x1000bb480		97ff2df4		CALL runtime.growslice(SB)		
  decimal_bid.go:97	0x1000bb484		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:97	0x1000bb488		aa0003e4		MOVD R0, R4				
  decimal_bid.go:97	0x1000bb48c		aa0203ea		MOVD R2, R10				
  decimal_bid.go:97	0x1000bb490		aa0103e5		MOVD R1, R5				
  decimal_bid.go:97	0x1000bb494		a94a07e0		LDP 160(RSP), (R0, R1)			
  decimal_bid.go:97	0x1000bb498		f90057ea		MOVD R10, 168(RSP)			
  decimal_bid.go:97	0x1000bb49c		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:97	0x1000bb4a0		f90063e5		MOVD R5, 192(RSP)			
  decimal_bid.go:97	0x1000bb4a4		8b010083		ADD R1, R4, R3				
  decimal_bid.go:97	0x1000bb4a8		aa0903e1		MOVD R9, R1				
  decimal_bid.go:97	0x1000bb4ac		aa0003e2		MOVD R0, R2				
  decimal_bid.go:97	0x1000bb4b0		aa0303e0		MOVD R3, R0				
  decimal_bid.go:97	0x1000bb4b4		97ff423f		CALL runtime.memmove(SB)		
  decimal_bid.go:97	0x1000bb4b8		f9407be0		MOVD 240(RSP), R0			
  decimal_bid.go:97	0x1000bb4bc		f94063e1		MOVD 192(RSP), R1			
  decimal_bid.go:97	0x1000bb4c0		f94057e2		MOVD 168(RSP), R2			
  decimal_bid.go:97	0x1000bb4c4		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:97	0x1000bb4c8		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:97	0x1000bb4cc		d65f03c0		RET					
  decimal_bid.go:103	0x1000bb4d0		f100019f		CMP $0, R12				
  decimal_bid.go:103	0x1000bb4d4		5400080d		BLE 64(PC)				
  decimal_bid.go:103	0x1000bb4d8		cb010148		SUB R1, R10, R8				
  decimal_bid.go:103	0x1000bb4dc		9100040b		ADD $1, R0, R11				
  decimal_bid.go:103	0x1000bb4e0		eb0b011f		CMP R11, R8				
  decimal_bid.go:103	0x1000bb4e4		5400078b		BLT 60(PC)				
  decimal_bid.go:105	0x1000bb4e8		8b000025		ADD R0, R1, R5				
  decimal_bid.go:105	0x1000bb4ec		910004a5		ADD $1, R5, R5				
  decimal_bid.go:105	0x1000bb4f0		eb05015f		CMP R5, R10				
  decimal_bid.go:105	0x1000bb4f4		540012c3		BCC 150(PC)				
  decimal_bid.go:106	0x1000bb4f8		eb05003f		CMP R5, R1				
  decimal_bid.go:106	0x1000bb4fc		54001268		BHI 147(PC)				
  decimal_bid.go:106	0x1000bb500		cb0a0026		SUB R10, R1, R6				
  decimal_bid.go:106	0x1000bb504		8a86fc26		AND R6->63, R1, R6			
  decimal_bid.go:106	0x1000bb508		8b060086		ADD R6, R4, R6				
  decimal_bid.go:106	0x1000bb50c		eb0c001f		CMP R12, R0				
  decimal_bid.go:106	0x1000bb510		540011a3		BCC 141(PC)				
  decimal_bid.go:105	0x1000bb514		f90063e5		MOVD R5, 192(RSP)			
  decimal_bid.go:79	0x1000bb518		f9007be4		MOVD R4, 240(RSP)			
  decimal_bid.go:79	0x1000bb51c		f9005fea		MOVD R10, 184(RSP)			
  decimal_bid.go:106	0x1000bb520		eb0c017f		CMP R12, R11				
  decimal_bid.go:106	0x1000bb524		9a80c582		CSINC GT, R12, R0, R2			
  decimal_bid.go:106	0x1000bb528		eb06013f		CMP R6, R9				
  decimal_bid.go:106	0x1000bb52c		54000160		BEQ 11(PC)				
  decimal_bid.go:88	0x1000bb530		f9005bec		MOVD R12, 176(RSP)			
  decimal_bid.go:106	0x1000bb534		aa0603e0		MOVD R6, R0				
  decimal_bid.go:106	0x1000bb538		aa0903e1		MOVD R9, R1				
  decimal_bid.go:106	0x1000bb53c		97ff421d		CALL runtime.memmove(SB)		
  decimal_bid.go:106	0x1000bb540		a94a07e0		LDP 160(RSP), (R0, R1)			
  decimal_bid.go:108	0x1000bb544		f9404fe3		MOVD 152(RSP), R3			
  decimal_bid.go:107	0x1000bb548		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:107	0x1000bb54c		f94063e5		MOVD 192(RSP), R5			
  decimal_bid.go:108	0x1000bb550		f94077e9		MOVD 232(RSP), R9			
  decimal_bid.go:108	0x1000bb554		a94b2bec		LDP 176(RSP), (R12, R10)		
  decimal_bid.go:107	0x1000bb558		8b010186		ADD R1, R12, R6				
  decimal_bid.go:107	0x1000bb55c		eb0600bf		CMP R6, R5				
  decimal_bid.go:107	0x1000bb560		54000f09		BLS 120(PC)				
  decimal_bid.go:107	0x1000bb564		d28005c7		MOVD $46, R7				
  decimal_bid.go:107	0x1000bb568		38266887		MOVB R7, (R4)(R6)			
  decimal_bid.go:108	0x1000bb56c		cb060147		SUB R6, R10, R7				
  decimal_bid.go:108	0x1000bb570		d10004e7		SUB $1, R7, R7				
  decimal_bid.go:108	0x1000bb574		cb0703e7		NEG R7, R7				
  decimal_bid.go:108	0x1000bb578		910004c6		ADD $1, R6, R6				
  decimal_bid.go:108	0x1000bb57c		8a87fcc6		AND R7->63, R6, R6			
  decimal_bid.go:108	0x1000bb580		8b0400c6		ADD R4, R6, R6				
  decimal_bid.go:106	0x1000bb584		eb0c001f		CMP R12, R0				
  decimal_bid.go:108	0x1000bb588		54000da3		BCC 109(PC)				
  decimal_bid.go:108	0x1000bb58c		cb0303e7		NEG R3, R7				
  decimal_bid.go:108	0x1000bb590		cb000188		SUB R0, R12, R8				
  decimal_bid.go:108	0x1000bb594		8a88fd88		AND R8->63, R12, R8			
  decimal_bid.go:108	0x1000bb598		8b080121		ADD R8, R9, R1				
  decimal_bid.go:108	0x1000bb59c		eb0700ff		CMP R7, R7				
  decimal_bid.go:108	0x1000bb5a0		da83b4e2		CSNEG LT, R7, R3, R2			
  decimal_bid.go:108	0x1000bb5a4		eb06003f		CMP R6, R1				
  decimal_bid.go:108	0x1000bb5a8		540000a0		BEQ 5(PC)				
  decimal_bid.go:108	0x1000bb5ac		aa0603e0		MOVD R6, R0				
  decimal_bid.go:108	0x1000bb5b0		97ff4200		CALL runtime.memmove(SB)		
  decimal_bid.go:109	0x1000bb5b4		f9407be4		MOVD 240(RSP), R4			
  decimal_bid.go:109	0x1000bb5b8		a94b97ea		LDP 184(RSP), (R10, R5)			
  decimal_bid.go:109	0x1000bb5bc		aa0403e0		MOVD R4, R0				
  decimal_bid.go:109	0x1000bb5c0		aa0503e1		MOVD R5, R1				
  decimal_bid.go:109	0x1000bb5c4		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:109	0x1000bb5c8		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:109	0x1000bb5cc		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:109	0x1000bb5d0		d65f03c0		RET					
  decimal_bid.go:111	0x1000bb5d4		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:111	0x1000bb5d8		aa0003e5		MOVD R0, R5				
  decimal_bid.go:111	0x1000bb5dc		aa0303e6		MOVD R3, R6				
  decimal_bid.go:111	0x1000bb5e0		92800007		MOVD $-1, R7				
  decimal_bid.go:111	0x1000bb5e4		aa0403e0		MOVD R4, R0				
  decimal_bid.go:111	0x1000bb5e8		aa0903e3		MOVD R9, R3				
  decimal_bid.go:111	0x1000bb5ec		aa0503e4		MOVD R5, R4				
  decimal_bid.go:111	0x1000bb5f0		97fff0f0		CALL strconv.appendFixed(SB)		
  decimal_bid.go:111	0x1000bb5f4		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:111	0x1000bb5f8		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:111	0x1000bb5fc		d65f03c0		RET					
  decimal_bid.go:73	0x1000bb600		f100005f		CMP $0, R2				
  decimal_bid.go:84	0x1000bb604		f100007f		CMP $0, R3				
  decimal_bid.go:84	0x1000bb608		9a9fd068		CSEL LE, R3, ZR, R8			
  decimal_bid.go:73	0x1000bb60c		f100005f		CMP $0, R2				
  decimal_bid.go:86	0x1000bb610		9a830106		CSEL EQ, R8, R3, R6			
  decimal_bid.go:86	0x1000bb614		aa0a03e2		MOVD R10, R2				
  decimal_bid.go:86	0x1000bb618		aa0903e3		MOVD R9, R3				
  decimal_bid.go:86	0x1000bb61c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:86	0x1000bb620		92800007		MOVD $-1, R7				
  decimal_bid.go:86	0x1000bb624		aa0403e0		MOVD R4, R0				
  decimal_bid.go:86	0x1000bb628		aa0503e4		MOVD R5, R4				
  decimal_bid.go:86	0x1000bb62c		97fff0e1		CALL strconv.appendFixed(SB)		
  decimal_bid.go:83	0x1000bb630		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:83	0x1000bb634		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:83	0x1000bb638		d65f03c0		RET					
  decimal_bid.go:113	0x1000bb63c		390323e1		MOVB R1, 200(RSP)			
  decimal_bid.go:113	0x1000bb640		a90d0fe2		STP (R2, R3), 208(RSP)			
  decimal_bid.go:113	0x1000bb644		910197ea		ADD $101, RSP, R10			
  decimal_bid.go:113	0x1000bb648		f90073ea		MOVD R10, 224(RSP)			
  decimal_bid.go:114	0x1000bb64c		f100005f		CMP $0, R2				
  decimal_bid.go:114	0x1000bb650		5400024d		BLE 18(PC)				
  decimal_bid.go:233	0x1000bb654		3944c3e3		MOVBU 304(RSP), R3			
  decimal_bid.go:233	0x1000bb658		aa0303e5		MOVD R3, R5				
  decimal_bid.go:233	0x1000bb65c		710114bf		CMPW $69, R5				
  decimal_bid.go:233	0x1000bb660		54000100		BEQ 8(PC)				
  decimal_bid.go:233	0x1000bb664		71011cbf		CMPW $71, R5				
  decimal_bid.go:233	0x1000bb668		540000c0		BEQ 6(PC)				
  decimal_bid.go:233	0x1000bb66c		d1019465		SUB $101, R3, R5			
  decimal_bid.go:233	0x1000bb670		d3401ca5		UBFX $0, R5, $8, R5			
  decimal_bid.go:233	0x1000bb674		710008bf		CMPW $2, R5				
  decimal_bid.go:233	0x1000bb678		54000049		BLS 2(PC)				
  decimal_bid.go:233	0x1000bb67c		d2800ce3		MOVD $103, R3				
  decimal_bid.go:115	0x1000bb680		f94047e1		MOVD 136(RSP), R1			
  decimal_bid.go:115	0x1000bb684		f94093e2		MOVD 288(RSP), R2			
  decimal_bid.go:115	0x1000bb688		aa0003e4		MOVD R0, R4				
  decimal_bid.go:115	0x1000bb68c		910323e0		ADD $200, RSP, R0			
  decimal_bid.go:115	0x1000bb690		97ffeeec		CALL strconv.(*finite).round(SB)	
  decimal_bid.go:120	0x1000bb694		f9409fe0		MOVD 312(RSP), R0			
  decimal_bid.go:117	0x1000bb698		f9406be7		MOVD 208(RSP), R7			
  decimal_bid.go:117	0x1000bb69c		b40003a7		CBZ R7, 29(PC)				
  decimal_bid.go:120	0x1000bb6a0		f94073ea		MOVD 224(RSP), R10			
  decimal_bid.go:120	0x1000bb6a4		3980015b		MOVB (R10), R27				
  decimal_bid.go:120	0x1000bb6a8		d280044b		MOVD $34, R11				
  decimal_bid.go:120	0x1000bb6ac		cb07016b		SUB R7, R11, R11			
  decimal_bid.go:120	0x1000bb6b0		f100897f		CMP $34, R11				
  decimal_bid.go:120	0x1000bb6b4		54000408		BHI 32(PC)				
  decimal_bid.go:233	0x1000bb6b8		3944c3e8		MOVBU 304(RSP), R8			
  decimal_bid.go:233	0x1000bb6bc		aa0803ec		MOVD R8, R12				
  decimal_bid.go:120	0x1000bb6c0		8b0b0145		ADD R11, R10, R5			
  decimal_bid.go:233	0x1000bb6c4		7101159f		CMPW $69, R12				
  decimal_bid.go:233	0x1000bb6c8		54000100		BEQ 8(PC)				
  decimal_bid.go:233	0x1000bb6cc		71011d9f		CMPW $71, R12				
  decimal_bid.go:233	0x1000bb6d0		540000c0		BEQ 6(PC)				
  decimal_bid.go:233	0x1000bb6d4		d101950a		SUB $101, R8, R10			
  decimal_bid.go:233	0x1000bb6d8		d3401d4a		UBFX $0, R10, $8, R10			
  decimal_bid.go:233	0x1000bb6dc		7100095f		CMPW $2, R10				
  decimal_bid.go:233	0x1000bb6e0		54000049		BLS 2(PC)				
  decimal_bid.go:233	0x1000bb6e4		d2800ce8		MOVD $103, R8				
  decimal_bid.go:120	0x1000bb6e8		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:120	0x1000bb6ec		f9406fe4		MOVD 216(RSP), R4			
  decimal_bid.go:120	0x1000bb6f0		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:120	0x1000bb6f4		aa0703e6		MOVD R7, R6				
  decimal_bid.go:120	0x1000bb6f8		aa0003e9		MOVD R0, R9				
  decimal_bid.go:120	0x1000bb6fc		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:120	0x1000bb700		97fff03c		CALL strconv.formatDigits(SB)		
  decimal_bid.go:120	0x1000bb704		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:120	0x1000bb708		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:120	0x1000bb70c		d65f03c0		RET					
  decimal_bid.go:118	0x1000bb710		394323e3		MOVBU 200(RSP), R3			
  decimal_bid.go:118	0x1000bb714		a9510be1		LDP 272(RSP), (R1, R2)			
  decimal_bid.go:118	0x1000bb718		3944c3e4		MOVBU 304(RSP), R4			
  decimal_bid.go:118	0x1000bb71c		aa0003e5		MOVD R0, R5				
  decimal_bid.go:118	0x1000bb720		f94087e0		MOVD 264(RSP), R0			
  decimal_bid.go:118	0x1000bb724		97ffef5f		CALL strconv.appendZero(SB)		
  decimal_bid.go:118	0x1000bb728		a97ffbfd		LDP -8(RSP), (R29, R30)			
  decimal_bid.go:118	0x1000bb72c		910403ff		ADD $256, RSP, RSP			
  decimal_bid.go:118	0x1000bb730		d65f03c0		RET					
  decimal_bid.go:120	0x1000bb734		d2800440		MOVD $34, R0				
  decimal_bid.go:120	0x1000bb738		97ff411a		CALL runtime.panicBounds(SB)		
  decimal_bid.go:108	0x1000bb73c		97ff4119		CALL runtime.panicBounds(SB)		
  decimal_bid.go:107	0x1000bb740		97ff4118		CALL runtime.panicBounds(SB)		
  decimal_bid.go:106	0x1000bb744		97ff4117		CALL runtime.panicBounds(SB)		
  decimal_bid.go:106	0x1000bb748		97ff4116		CALL runtime.panicBounds(SB)		
  decimal_bid.go:105	0x1000bb74c		97ff4115		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb750		d2800440		MOVD $34, R0				
  decimal_bid.go:72	0x1000bb754		97ff4113		CALL runtime.panicBounds(SB)		
  decimal_bid.go:72	0x1000bb758		d503201f		NOOP					
  decimal_bid.go:48	0x1000bb75c		a90087e0		STP (R0, R1), 8(RSP)			
  decimal_bid.go:48	0x1000bb760		a9018fe2		STP (R2, R3), 24(RSP)			
  decimal_bid.go:48	0x1000bb764		f90017e4		MOVD R4, 40(RSP)			
  decimal_bid.go:48	0x1000bb768		3900c3e5		MOVB R5, 48(RSP)			
  decimal_bid.go:48	0x1000bb76c		a9039fe6		STP (R6, R7), 56(RSP)			
  decimal_bid.go:48	0x1000bb770		aa1e03e3		MOVD R30, R3				
  decimal_bid.go:48	0x1000bb774		97ff38c7		CALL runtime.morestack_noctxt.abi0(SB)	
  decimal_bid.go:48	0x1000bb778		a94087e0		LDP 8(RSP), (R0, R1)			
  decimal_bid.go:48	0x1000bb77c		a9418fe2		LDP 24(RSP), (R2, R3)			
  decimal_bid.go:48	0x1000bb780		f94017e4		MOVD 40(RSP), R4			
  decimal_bid.go:48	0x1000bb784		3940c3e5		MOVBU 48(RSP), R5			
  decimal_bid.go:48	0x1000bb788		a9439fe6		LDP 56(RSP), (R6, R7)			
  decimal_bid.go:48	0x1000bb78c		17fffe79		JMP strconv.appendDecimal(SB)		
