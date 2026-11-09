TEXT internal/bid.cSplit128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/coef128.go
  coef128.go:366	0x10000aa40		f9400b90		MOVD 16(R28), R16			
  coef128.go:366	0x10000aa44		eb3063ff		CMP R16, RSP				
  coef128.go:366	0x10000aa48		54000269		BLS 19(PC)				
  coef128.go:366	0x10000aa4c		f81d0ffe		MOVD.W R30, -48(RSP)			
  coef128.go:366	0x10000aa50		f81f83fd		MOVD R29, -8(RSP)			
  coef128.go:366	0x10000aa54		d10023fd		SUB $8, RSP, R29			
  coef128.go:367	0x10000aa58		b5000120		CBNZ R0, 9(PC)				
  coef128.go:367	0x10000aa5c		b0002cfb		ADRP 5885952(PC), R27			
  coef128.go:367	0x10000aa60		f940bf63		MOVD 376(R27), R3			
  coef128.go:367	0x10000aa64		eb03003f		CMP R3, R1				
  coef128.go:367	0x10000aa68		540000a2		BCS 5(PC)				
  coef128.go:368	0x10000aa6c		aa1f03e0		MOVD ZR, R0				
  coef128.go:368	0x10000aa70		f85f83fd		MOVD -8(RSP), R29			
  coef128.go:368	0x10000aa74		f84307fe		MOVD.P 48(RSP), R30			
  coef128.go:368	0x10000aa78		d65f03c0		RET					
  coef128.go:372	0x10000aa7c		b0002cfb		ADRP 5885952(PC), R27			
  coef128.go:372	0x10000aa80		f940bf62		MOVD 376(R27), R2			
  coef128.go:372	0x10000aa84		94022f6f		CALL math/bits.Div64(SB)		
  coef128.go:372	0x10000aa88		f85f83fd		MOVD -8(RSP), R29			
  coef128.go:372	0x10000aa8c		f84307fe		MOVD.P 48(RSP), R30			
  coef128.go:372	0x10000aa90		d65f03c0		RET					
  coef128.go:366	0x10000aa94		a90087e0		STP (R0, R1), 8(RSP)			
  coef128.go:366	0x10000aa98		aa1e03e3		MOVD R30, R3				
  coef128.go:366	0x10000aa9c		94021e4d		CALL runtime.morestack_noctxt.abi0(SB)	
  coef128.go:366	0x10000aaa0		a94087e0		LDP 8(RSP), (R0, R1)			
  coef128.go:366	0x10000aaa4		17ffffe7		JMP internal/bid.cSplit128(SB)		
  coef128.go:366	0x10000aaa8		00000000		?					
  coef128.go:366	0x10000aaac		00000000		?					
