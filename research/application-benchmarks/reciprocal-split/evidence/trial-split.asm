TEXT internal/bid.cSplit128(SB) /Users/marcelo/work/wt/gd-survey/src/internal/bid/coef128.go
  coef128.go:368	0x10000aa40		b5000160		CBNZ R0, 11(PC)		
  coef128.go:369	0x10000aa44		d2aec302		MOVD $1981284352, R2	
  coef128.go:369	0x10000aa48		f2db9f62		MOVK $(56571<<32), R2	
  coef128.go:369	0x10000aa4c		f2eea702		MOVK $(30008<<48), R2	
  coef128.go:369	0x10000aa50		ab02003f		CMN R2, R1		
  coef128.go:369	0x10000aa54		54000062		BCS 3(PC)		
  coef128.go:370	0x10000aa58		aa1f03e0		MOVD ZR, R0		
  coef128.go:370	0x10000aa5c		d65f03c0		RET			
  coef128.go:373	0x10000aa60		8b020021		ADD R2, R1, R1		
  coef128.go:373	0x10000aa64		b24003e0		ORR $1, ZR, R0		
  coef128.go:373	0x10000aa68		d65f03c0		RET			
  coef128.go:380	0x10000aa6c		d2986942		MOVD $49994, R2		
  coef128.go:380	0x10000aa70		f2ada542		MOVK $(27946<<16), R2	
  coef128.go:380	0x10000aa74		f2d29f62		MOVK $(38139<<32), R2	
  coef128.go:380	0x10000aa78		f2fb0782		MOVK $(55356<<48), R2	
  coef128.go:380	0x10000aa7c		9bc27c23		UMULH R2, R1, R3	
  coef128.go:381	0x10000aa80		9b007c44		MUL R0, R2, R4		
  coef128.go:381	0x10000aa84		9bc27c02		UMULH R2, R0, R2	
  coef128.go:384	0x10000aa88		8b020002		ADD R2, R0, R2		
  coef128.go:382	0x10000aa8c		ab030023		ADDS R3, R1, R3		
  coef128.go:382	0x10000aa90		9a1f03e5		ADC ZR, ZR, R5		
  coef128.go:384	0x10000aa94		8b050042		ADD R5, R2, R2		
  coef128.go:383	0x10000aa98		ab040063		ADDS R4, R3, R3		
  coef128.go:383	0x10000aa9c		9a1f03e3		ADC ZR, ZR, R3		
  coef128.go:384	0x10000aaa0		8b020062		ADD R2, R3, R2		
  coef128.go:388	0x10000aaa4		d2b13d03		MOVD $2313682944, R3	
  coef128.go:388	0x10000aaa8		f2c46083		MOVK $(8964<<32), R3	
  coef128.go:388	0x10000aaac		f2f158e3		MOVK $(35527<<48), R3	
  coef128.go:388	0x10000aab0		9b028463		MSUB R2, R1, R3, R3	
  coef128.go:391	0x10000aab4		d2aec304		MOVD $1981284352, R4	
  coef128.go:391	0x10000aab8		f2db9f64		MOVK $(56571<<32), R4	
  coef128.go:391	0x10000aabc		f2eea704		MOVK $(30008<<48), R4	
  coef128.go:391	0x10000aac0		8b040065		ADD R4, R3, R5		
  coef128.go:389	0x10000aac4		ab04007f		CMN R4, R3		
  coef128.go:393	0x10000aac8		9a823440		CINC HS, R2, R0		
  coef128.go:393	0x10000aacc		9a8320a1		CSEL HS, R5, R3, R1	
  coef128.go:389	0x10000aad0		d65f03c0		RET			
  coef128.go:389	0x10000aad4		00000000		?			
  coef128.go:389	0x10000aad8		00000000		?			
  coef128.go:389	0x10000aadc		00000000		?			
