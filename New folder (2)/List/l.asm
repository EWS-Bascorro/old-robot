
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega2560
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 2048 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega2560
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8703
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x200

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x74
	.EQU XMCRB=0x75
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0200
	.EQU __SRAM_END=0x21FF
	.EQU __DSTACK_SIZE=0x0800
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _countRxProtokol=R4
	.DEF _robot=R5
	.DEF _delay=R7
	.DEF _tango=R9
	.DEF _tangi=R11
	.DEF _countTick=R13
	.DEF _Timeslot=R3

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int3_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_compa_isr
	JMP  _timer3_compb_isr
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart2_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart3_rx_isr
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
_0x4:
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
	.DB  0xDC,0x5,0xDC,0x5,0xDC,0x5,0xDC,0x5
_0x5:
	.DB  0x1
_0x6:
	.DB  0xE8,0x3
_0x7:
	.DB  0x0,0x0,0x44,0x43
_0x8:
	.DB  0x0,0x0,0xA8,0x41
_0x9:
	.DB  0x0,0x0,0xA8,0x42
_0xA:
	.DB  0x0,0x0,0xB2,0x42
_0xB:
	.DB  0x0,0x0,0xA8,0x41
_0xC:
	.DB  0x1
_0xD:
	.DB  0xE8,0x3
_0xE:
	.DB  0xE8,0x3
_0xF:
	.DB  0x45,0x6
_0x10:
	.DB  0x45,0x6
_0x11:
	.DB  0x58,0x2
_0x12:
	.DB  0xA0
_0x13:
	.DB  0x78
_0x28D:
	.DB  0x0
_0x0:
	.DB  0x52,0x61,0x73,0x70,0x69,0x20,0x59,0x20
	.DB  0x20,0x25,0x64,0xD,0xA,0x0,0x70,0x69
	.DB  0x64,0x20,0x73,0x65,0x72,0x76,0x6F,0xD
	.DB  0xA,0x0,0x41,0x6D,0x62,0x72,0x75,0x6B
	.DB  0x20,0x64,0x65,0x70,0x61,0x6E,0x20,0x20
	.DB  0x25,0x64,0xD,0xA,0x0,0x41,0x6D,0x62
	.DB  0x72,0x75,0x6B,0x20,0x62,0x65,0x6C,0x61
	.DB  0x6B,0x61,0x6E,0x67,0x20,0x20,0x25,0x64
	.DB  0xD,0xA,0x0,0x63,0x65,0x6B,0x20,0x41
	.DB  0x6D,0x62,0x72,0x75,0x6B,0x20,0x64,0x65
	.DB  0x70,0x61,0x6E,0x20,0x25,0x64,0xD,0xA
	.DB  0x0,0x63,0x65,0x6B,0x20,0x41,0x6D,0x62
	.DB  0x72,0x75,0x6B,0x20,0x62,0x65,0x6C,0x61
	.DB  0x6B,0x61,0x6E,0x67,0x20,0x25,0x64,0xD
	.DB  0xA,0x0,0x70,0x72,0x6F,0x73,0x65,0x73
	.DB  0x20,0x62,0x61,0x6E,0x67,0x75,0x6E,0x20
	.DB  0x64,0x65,0x70,0x61,0x6E,0x20,0x25,0x64
	.DB  0xD,0xA,0x0,0x77,0x65,0x73,0xD,0xA
	.DB  0x0,0x70,0x72,0x6F,0x73,0x65,0x73,0x20
	.DB  0x62,0x61,0x6E,0x67,0x75,0x6E,0x20,0x62
	.DB  0x65,0x6C,0x61,0x6B,0x61,0x6E,0x67,0x20
	.DB  0x25,0x64,0xD,0xA,0x0,0x57,0x65,0x73
	.DB  0x20,0x63,0x6F,0x6B,0xD,0xA,0x0,0x25
	.DB  0x64,0x20,0x73,0x65,0x72,0x6F,0x6E,0x67
	.DB  0x20,0x6B,0x69,0x72,0x69,0x20,0x62,0x6F
	.DB  0x73,0xD,0xA,0x0,0x25,0x64,0x20,0x6D
	.DB  0x61,0x6A,0x75,0x20,0x6A,0x61,0x6C,0x61
	.DB  0x6E,0xD,0xA,0x0,0x25,0x64,0x20,0x73
	.DB  0x65,0x72,0x6F,0x6E,0x67,0x20,0x6B,0x61
	.DB  0x6E,0x61,0x6E,0xD,0xA,0x0,0x63,0x61
	.DB  0x72,0x69,0x20,0x62,0x6F,0x6C,0x61,0x20
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x3D,0x3D
	.DB  0x20,0x25,0x64,0x20,0xD,0xA,0x0,0x63
	.DB  0x61,0x72,0x69,0x20,0x62,0x6F,0x6C,0x61
	.DB  0x20,0x25,0x64,0x20,0x25,0x64,0x20,0x3D
	.DB  0x3D,0x20,0x25,0x64,0xD,0xA,0x0,0x41
	.DB  0x6B,0x75,0x20,0x4E,0x67,0x61,0x77,0x75
	.DB  0x72,0x20,0x25,0x64,0x20,0x2D,0x20,0x25
	.DB  0x64,0xD,0xA,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x28
	.DW  _servo
	.DW  _0x3*2

	.DW  0x28
	.DW  _servoSet
	.DW  _0x4*2

	.DW  0x01
	.DW  _langkahMax
	.DW  _0x5*2

	.DW  0x04
	.DW  _initPositionZ
	.DW  _0x7*2

	.DW  0x04
	.DW  _L1
	.DW  _0x8*2

	.DW  0x04
	.DW  _L2
	.DW  _0x9*2

	.DW  0x04
	.DW  _L3
	.DW  _0xA*2

	.DW  0x04
	.DW  _L4
	.DW  _0xB*2

	.DW  0x01
	.DW  _state
	.DW  _0xC*2

	.DW  0x02
	.DW  _hitungNgawur
	.DW  _0xD*2

	.DW  0x02
	.DW  _delayNgawur
	.DW  _0xE*2

	.DW  0x02
	.DW  _hitungWaras
	.DW  _0xF*2

	.DW  0x02
	.DW  _delayWaras
	.DW  _0x10*2

	.DW  0x02
	.DW  _hitungTendang
	.DW  _0x11*2

	.DW  0x01
	.DW  _spx
	.DW  _0x12*2

	.DW  0x01
	.DW  _spy
	.DW  _0x13*2

	.DW  0x01
	.DW  0x04
	.DW  _0x28D*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

	OUT  EIND,R24

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xA00

	.CSEG
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <math.h>
;#include <delay.h>
;void taskGerakan();
;void inversKinematic();
;void InputXYZ();
;void maju();
;void rotasi_kanan();
;void rotasi_kiri();
;void bangun_telentang();
;void bangun_tengkurap();
;void bangkit();
;void siap();
;void serong_kanan();
;void serong_kiri();
;void geser_kanan();
;void geser_kiri();
;void tendang();
;void dor();
;void konversi_ardu();
;
;
;int servoInitError[20]={
;0,0,0,0,0,0,
;0,0,0,0,0,0,
;0,0,0,
;0,0,0,
;0,0
;};
;
;eeprom int eServoInitError[20]={
;-35,23,-11,-23,-45,0,      //-35,23,-11,-23,-45,0,
;47,-16,25,-71,50,0,       //47,-16,25,-71,30,0,
;0,0,0,
;0,0,0,
;0,0
;};
;
;int servo[20]={
;1500,1500,1500,1500,1500,1500,
;1500,1500,1500,1500,1500,1500,
;1500,1500,1500,
;1500,1500,1500,
;1500,1500
;};

	.DSEG
;int servoSet[20]={
;1500,1500,1500,1500,1500,1500,
;1500,1500,1500,1500,1500,1500,
;1500,1500,1500,
;1500,1500,1500,
;1500,1500
;};
;
;int
;dataInt[4]={0,0,0,0}, data[4]={0,0,0,0};
;unsigned char
;countRxProtokol = 0,
;dataMasuk[8]
; 0000 003D ;
;
;
;int
;robot,
;delay,
;tango,
;tangi,
;countTick,
;counterTG,
;counterDelay,
;countGerakan,
;I,
;index,
;langkah,
;langkahMax=1,  //15
;jumlahGerak,
;speed,
;delay_gait = 1000,
;countNo
; 0000 0051 ;
;
;double
;VX,VY,VZ,W,
;initPositionX=0,
;initPositionY=0,
;initPositionZ=196,             //196 216
;L1=21,
;L2=84,
;L3=89,
;L4=21,
;X[2],Y[2],Z[2],
;Xin=0,Yin=0,Zin=0,
;Xset[2],Yset[2],Zset[2],
;Xlast[2],Ylast[2],Zlast[2],
;Xerror[2],Yerror[2],Zerror[2],
;L1Kuadrat,L2Kuadrat,L3Kuadrat,L4Kuadrat,
;XiKuadrat,YiKuadrat,ZiKuadrat,
;bi,biKuadrat,ai,aiKuadrat,ci,gamai,betai,alphai[2],
;A1[2],A2[2],A3[2],A4[2],A5[2],
;rad,
;sudutSet[20]
; 0000 0067 ;
;// ---------------- Variabel case case an ----------------//
;int state = 1;
;int cariBola = 0;
;int jalan;
;int de;
;int ndingkluk = 0;
;int kondisiAmbrukDepan,kondisiAmbrukBelakang;
;int hitungNgawur = 1000;
;int delayNgawur = 1000;
;int hitungWaras = 1605;
;int delayWaras = 1605;
;int hitungTendang = 600;
;
;// ---------------- End of variabel case -----------------//
;
;int spx = 160,spy = 120,errorx,errory,px,py,mvx,mvy;
;int sudah = 0;
;void cari_bola();
;void pid_servo();
;void berjalan();
;void pid_servo_mon();
;void nek_ambruk();
;void cek_ambruk();
;void ngawur();
;
;void bangun_depan();
;void bangun_belakang();
;#include <lib.c>
;
;#define timer3ms 59536
;#define timer2ms 63536
;unsigned char Timeslot;
;unsigned char Timeslot2;
;
;#define kaka1_1   PORTL |= (1 << 2) //PORTL.2 logika 1(HIGH)
;#define kaka2_1   PORTL |= (1 << 3) //PORTL.3 logika 1(HIGH)
;#define kaka3_1   PORTL |= (1 << 4)
;#define kaka4_1   PORTL |= (1 << 5)
;#define kaka5_1   PORTL |= (1 << 6)
;#define kaka6_1   PORTL |= (1 << 7)
;#define buzzon    PORTG |= (1 << 7)
;
;#define kaka1_0   PORTL &= ~(1 << 2) //PORTL.2 logika 0(LOW)
;#define kaka2_0   PORTL &= ~(1 << 3) //PORTL.3 logika 0(LOW)
;#define kaka3_0   PORTL &= ~(1 << 4)
;#define kaka4_0   PORTL &= ~(1 << 5)
;#define kaka5_0   PORTL &= ~(1 << 6)
;#define kaka6_0   PORTL &= ~(1 << 7)
;#define buzzoff   PORTG &= ~(1 << 7)
;
;#define taka1   PORTF.0
;#define taka2   PORTF.1
;#define taka3   PORTF.2
;#define pala1   PORTF.3
;
;#define taki1   PORTF.7
;#define taki2   PORTF.6
;#define taki3   PORTF.5
;#define pala2   PORTF.4
;
;#define kaki1   PORTC.7
;#define kaki2   PORTC.6
;#define kaki3   PORTA.6
;#define kaki4   PORTA.7
;#define kaki5   PORTA.4
;#define kaki6   PORTA.5
;
;//==================VARIABEL SERIAL=================//
;int miringDepan,miringSamping,kompas;
;
;int pos_x,pos_y;
;unsigned char DataMasuk[10],DataRx,CountRx;
;unsigned char DataMasukR[10],DataRxR,CountRxR;
;//----------------END VARIABEL SERIAL-----------------//
;
;//==================Variabel mbuh=================//
;int
;count,hitung,
;countBall,nilai,
;countGawang,Gawang,
;Ball
; 0000 0083 ;
;//----------------END VARIABEL mbuh-----------------//
;
;#define kaki servo[19]
;#define aba  servo[18]
;//==================VARIABEL SERIAL=================//
;int mx,my,kompas;
;char Data1[4],Data2[4],Data3[4];
;unsigned char Count2,Count1,Count0,DataRx,CountRx = 0;
;
;int xx,yy;
;char DataR1[4],DataR2[4],DataR3[4];
;unsigned char CountR2,CountR1,CountR0,DataRRx;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void);
;interrupt [TIM1_COMPA] void timer1_compa_isr(void);
;interrupt [TIM1_COMPB] void timer1_compb_isr(void);
;interrupt [TIM3_OVF] void timer3_ovf_isr(void);
;interrupt [TIM3_COMPA] void timer3_compa_isr(void);
;interrupt [TIM3_COMPB] void timer3_compb_isr(void);
;interrupt [USART0_RXC] void usart0_rx_isr(void);
;interrupt [USART2_RXC] void usart2_rx_isr(void);
;interrupt [USART3_RXC] void usart3_rx_isr(void);
;interrupt [TIM2_OVF] void timer2_ovf_isr(void);
;void init();
;void konversi_raspi();
;void konversi_ardu();
;
;
;
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;{

	.CSEG
_timer2_ovf_isr:
	CALL SUBOPT_0x0
;    TCNT2=240;
	LDI  R30,LOW(240)
	STS  178,R30
;    counterTG++;
	LDI  R26,LOW(_counterTG)
	LDI  R27,HIGH(_counterTG)
	CALL SUBOPT_0x1
;    if(counterDelay>0)
	CALL SUBOPT_0x2
	BRGE _0x14
;        counterDelay--;
	LDI  R26,LOW(_counterDelay)
	LDI  R27,HIGH(_counterDelay)
	CALL SUBOPT_0x3
;}
_0x14:
	CALL SUBOPT_0x4
	RETI
;
;void init()
;{
_init:
;    PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
;    DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1,R30
;
;    PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x5,R30
;    DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x4,R30
;
;    PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
;    DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x7,R30
;
;    PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;    DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0xA,R30
;
;    PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
;    DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0xD,R30
;
;    PORTF=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
;    DDRF=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x10,R30
;
;    PORTG=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;    DDRG=0xFF;
	LDI  R30,LOW(255)
	OUT  0x13,R30
;
;    PORTH=0x00;
	LDI  R30,LOW(0)
	STS  258,R30
;    DDRH=0xFF;
	LDI  R30,LOW(255)
	STS  257,R30
;
;    PORTJ=0x00;
	LDI  R30,LOW(0)
	STS  261,R30
;    DDRJ=0xFF;
	LDI  R30,LOW(255)
	STS  260,R30
;
;    PORTK=0x00;
	LDI  R30,LOW(0)
	STS  264,R30
;    DDRK=0xFF;
	LDI  R30,LOW(255)
	STS  263,R30
;
;    PORTL=0x00;
	LDI  R30,LOW(0)
	STS  267,R30
;    DDRL=0b11111111;
	LDI  R30,LOW(255)
	STS  266,R30
;
;    EICRA=0xC0;
	LDI  R30,LOW(192)
	STS  105,R30
;    EICRB=0x00;
	LDI  R30,LOW(0)
	STS  106,R30
;    EIMSK=0x08;
	LDI  R30,LOW(8)
	OUT  0x1D,R30
;    EIFR=0x08;
	OUT  0x1C,R30
;
;    TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
;    TCCR1B=0x02;
	LDI  R30,LOW(2)
	STS  129,R30
;    TCCR2A=0x00;
	LDI  R30,LOW(0)
	STS  176,R30
;    TCCR2B=0x07;
	LDI  R30,LOW(7)
	STS  177,R30
;    TCCR3A=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;    TCCR3B=0x02;
	LDI  R30,LOW(2)
	STS  145,R30
;
;
;    UCSR0A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
;    UCSR0B=0x08;
	LDI  R30,LOW(8)
	STS  193,R30
;    UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
;    UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
;    UBRR0L=0x08;
	LDI  R30,LOW(8)
	STS  196,R30
;    /*
;    UCSR2A=0x00;
;    UCSR2B=0x90;
;    UCSR2C=0x06;
;    UBRR2H=0x00;
;    UBRR2L=0x08;
;    */
;    // USART2 initialization
;// Communication Parameters: 8 Data, 1 Stop, No Parity
;// USART2 Receiver: On
;// USART2 Transmitter: On
;// USART2 Mode: Asynchronous
;// USART2 Baud Rate: 9600
;UCSR2A=0x00;
	LDI  R30,LOW(0)
	STS  208,R30
;UCSR2B=0x18;
	LDI  R30,LOW(24)
	STS  209,R30
;UCSR2C=0x06;
	LDI  R30,LOW(6)
	STS  210,R30
;UBRR2H=0x00;
	LDI  R30,LOW(0)
	STS  213,R30
;UBRR2L=0x67;
	LDI  R30,LOW(103)
	STS  212,R30
;
;    UCSR3A=0x00;
	LDI  R30,LOW(0)
	STS  304,R30
;    UCSR3B=0x90;
	LDI  R30,LOW(144)
	STS  305,R30
;    UCSR3C=0x06;
	LDI  R30,LOW(6)
	STS  306,R30
;    UBRR3H=0x00;
	LDI  R30,LOW(0)
	STS  309,R30
;    UBRR3L=0x08;
	LDI  R30,LOW(8)
	STS  308,R30
;
;    ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
;    ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
;    DIDR1=0x00;
	STS  127,R30
;
;    TIMSK1=0x07;
	LDI  R30,LOW(7)
	STS  111,R30
;    TIMSK2=0x01;
	LDI  R30,LOW(1)
	STS  112,R30
;    TIMSK3=0x07;
	LDI  R30,LOW(7)
	STS  113,R30
;
;    rad=57.272727;
	__GETD1N 0x42651746
	STS  _rad,R30
	STS  _rad+1,R31
	STS  _rad+2,R22
	STS  _rad+3,R23
;    L1Kuadrat = L1 * L1;
	LDS  R30,_L1
	LDS  R31,_L1+1
	LDS  R22,_L1+2
	LDS  R23,_L1+3
	CALL SUBOPT_0x5
	CALL __MULF12
	STS  _L1Kuadrat,R30
	STS  _L1Kuadrat+1,R31
	STS  _L1Kuadrat+2,R22
	STS  _L1Kuadrat+3,R23
;    L2Kuadrat = L2 * L2;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL __MULF12
	STS  _L2Kuadrat,R30
	STS  _L2Kuadrat+1,R31
	STS  _L2Kuadrat+2,R22
	STS  _L2Kuadrat+3,R23
;    L3Kuadrat = L3 * L3;
	LDS  R30,_L3
	LDS  R31,_L3+1
	LDS  R22,_L3+2
	LDS  R23,_L3+3
	CALL SUBOPT_0x8
	STS  _L3Kuadrat,R30
	STS  _L3Kuadrat+1,R31
	STS  _L3Kuadrat+2,R22
	STS  _L3Kuadrat+3,R23
;    L4Kuadrat = L4 * L4;
	LDS  R30,_L4
	LDS  R31,_L4+1
	LDS  R22,_L4+2
	LDS  R23,_L4+3
	CALL SUBOPT_0x9
	CALL __MULF12
	STS  _L4Kuadrat,R30
	STS  _L4Kuadrat+1,R31
	STS  _L4Kuadrat+2,R22
	STS  _L4Kuadrat+3,R23
;
;    for (countNo = 0; countNo < 2; countNo++) {
	CALL SUBOPT_0xA
_0x16:
	CALL SUBOPT_0xB
	BRGE _0x17
;      Xset[countNo] = initPositionX; Yset[countNo] = initPositionY; Zset[countNo] = initPositionZ;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x11
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
;    }
	CALL SUBOPT_0x15
	RJMP _0x16
_0x17:
;
;    X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x16
;    X[1]=0; Y[1]=0; Z[1]=0;
;
;    for(index=0;index<20;index++)
	LDI  R30,LOW(0)
	STS  _index,R30
	STS  _index+1,R30
_0x19:
	LDS  R26,_index
	LDS  R27,_index+1
	SBIW R26,20
	BRGE _0x1A
;    {
;        servoInitError[index]=eServoInitError[index];
	LDS  R30,_index
	LDS  R31,_index+1
	LDI  R26,LOW(_servoInitError)
	LDI  R27,HIGH(_servoInitError)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDS  R30,_index
	LDS  R31,_index+1
	LDI  R26,LOW(_eServoInitError)
	LDI  R27,HIGH(_eServoInitError)
	CALL SUBOPT_0x17
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
;//        printf("A%d\n",index);
;//        printf("B%d\n",servoInitError[index]);
;        delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
;    }
	LDI  R26,LOW(_index)
	LDI  R27,HIGH(_index)
	CALL SUBOPT_0x1
	RJMP _0x19
_0x1A:
;
;}
	RET
;
;interrupt [EXT_INT3] void ext_int3_isr(void)
;{
_ext_int3_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    countBall++;
	LDI  R26,LOW(_countBall)
	LDI  R27,HIGH(_countBall)
	CALL SUBOPT_0x1
;
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)
;{
_usart0_rx_isr:
;}
	RETI
;
;// Terima data dari Raspi
;interrupt [USART2_RXC] void usart2_rx_isr(void) //TERIMA DATA DARI RASPI
;{
_usart2_rx_isr:
	CALL SUBOPT_0x18
;char data;
;data=UDR2;
	ST   -Y,R17
;	data -> R17
	LDS  R17,214
;switch(DataRRx)
	LDS  R30,_DataRRx
	CALL SUBOPT_0x19
;{
;    case 0:
	BRNE _0x1E
;                if(data=='!'){DataRRx=1; CountR0=0;DataR1[0]=NULL;DataR1[1]=NULL;DataR1[2]=NULL;DataR1[3]=NULL;}
	CPI  R17,33
	BRNE _0x1F
	LDI  R30,LOW(1)
	STS  _DataRRx,R30
	LDI  R30,LOW(0)
	STS  _CountR0,R30
	STS  _DataR1,R30
	__PUTB1MN _DataR1,1
	__PUTB1MN _DataR1,2
	__PUTB1MN _DataR1,3
;                if(data=='@'){DataRRx=2; CountR1=0;DataR2[0]=NULL;DataR2[1]=NULL;DataR2[2]=NULL;DataR2[3]=NULL;}
_0x1F:
	CPI  R17,64
	BRNE _0x20
	LDI  R30,LOW(2)
	STS  _DataRRx,R30
	LDI  R30,LOW(0)
	STS  _CountR1,R30
	STS  _DataR2,R30
	__PUTB1MN _DataR2,1
	__PUTB1MN _DataR2,2
	__PUTB1MN _DataR2,3
;
;    break;
_0x20:
	RJMP _0x1D
;
;    case 1:
_0x1E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x21
;        if(data=='|'){DataRRx=0; CountR0=0;}
	CPI  R17,124
	BRNE _0x22
	LDI  R30,LOW(0)
	STS  _DataRRx,R30
	RJMP _0x258
;        else {
_0x22:
;        DataR1[CountR0] = data; CountR0++;}
	LDS  R30,_CountR0
	LDI  R31,0
	SUBI R30,LOW(-_DataR1)
	SBCI R31,HIGH(-_DataR1)
	ST   Z,R17
	LDS  R30,_CountR0
	SUBI R30,-LOW(1)
_0x258:
	STS  _CountR0,R30
;    break;
	RJMP _0x1D
;
;    case 2:
_0x21:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1D
;        if(data=='|'){DataRRx=0; CountR1=0;}
	CPI  R17,124
	BRNE _0x25
	LDI  R30,LOW(0)
	STS  _DataRRx,R30
	RJMP _0x259
;        else{
_0x25:
;        DataR2[CountR1] = data; CountR1++;
	LDS  R30,_CountR1
	LDI  R31,0
	SUBI R30,LOW(-_DataR2)
	SBCI R31,HIGH(-_DataR2)
	ST   Z,R17
	LDS  R30,_CountR1
	SUBI R30,-LOW(1)
_0x259:
	STS  _CountR1,R30
;        }
;    break;
;  }
_0x1D:
;}
	LD   R17,Y+
	RJMP _0x28C
;
;// Terima data IMU Arduino
;interrupt [USART3_RXC] void usart3_rx_isr(void)
;{
_usart3_rx_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;DataRx=UDR3;
	LDS  R30,310
	STS  _DataRx,R30
;switch (CountRx){
	LDS  R30,_CountRx
	CALL SUBOPT_0x19
;case 0:
	BRNE _0x2A
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x2B
	LDI  R30,LOW(1)
	STS  _CountRx,R30
;break;
_0x2B:
	RJMP _0x29
;case 1:
_0x2A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x2D
	LDI  R30,LOW(1)
	RJMP _0x25A
;else {DataMasuk[0]=DataRx; miringDepan = (int) -1 *((DataMasuk[0]*2)-180); CountRx=2;}
_0x2D:
	LDS  R30,_DataRx
	STS  _DataMasuk,R30
	LDS  R26,_DataMasuk
	CALL SUBOPT_0x1A
	STS  _miringDepan,R30
	STS  _miringDepan+1,R31
	LDI  R30,LOW(2)
_0x25A:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 2:
_0x2C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2F
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x30
	LDI  R30,LOW(1)
	RJMP _0x25B
;else {DataMasuk[1]=DataRx; miringSamping = (int) -1*((DataMasuk[1]*2)-180); CountRx=3;}
_0x30:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,1
	__GETB2MN _DataMasuk,1
	CALL SUBOPT_0x1A
	STS  _miringSamping,R30
	STS  _miringSamping+1,R31
	LDI  R30,LOW(3)
_0x25B:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 3:
_0x2F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x32
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x33
	LDI  R30,LOW(1)
	RJMP _0x25C
;else {DataMasuk[2]=DataRx; kompas = (int) (DataMasuk[2]*2); CountRx=4;}
_0x33:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,2
	__GETB2MN _DataMasuk,2
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	STS  _kompas,R30
	STS  _kompas+1,R31
	LDI  R30,LOW(4)
_0x25C:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 4:
_0x32:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x35
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x36
	LDI  R30,LOW(1)
	RJMP _0x25D
;else {DataMasuk[3]=DataRx; CountRx=5;}
_0x36:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,3
	LDI  R30,LOW(5)
_0x25D:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 5:
_0x35:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x38
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x39
	LDI  R30,LOW(1)
	RJMP _0x25E
;else {DataMasuk[4]=DataRx; CountRx=6;}
_0x39:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,4
	LDI  R30,LOW(6)
_0x25E:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 6:
_0x38:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x3B
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x3C
	LDI  R30,LOW(1)
	RJMP _0x25F
;else {DataMasuk[5]=DataRx; CountRx=7;}
_0x3C:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,5
	LDI  R30,LOW(7)
_0x25F:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 7:
_0x3B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3E
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x3F
	LDI  R30,LOW(1)
	RJMP _0x260
;else {DataMasuk[6]=DataRx; CountRx=8;}
_0x3F:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,6
	LDI  R30,LOW(8)
_0x260:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 8:
_0x3E:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x41
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x42
	LDI  R30,LOW(1)
	RJMP _0x261
;else {DataMasuk[7]=DataRx; CountRx=9;}
_0x42:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,7
	LDI  R30,LOW(9)
_0x261:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 9:
_0x41:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x44
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x45
	LDI  R30,LOW(1)
	RJMP _0x262
;else {DataMasuk[8]=DataRx; CountRx=10;}
_0x45:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,8
	LDI  R30,LOW(10)
_0x262:
	STS  _CountRx,R30
;break;
	RJMP _0x29
;case 10:
_0x44:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x29
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x48
	LDI  R30,LOW(1)
	RJMP _0x263
;else {DataMasuk[9]=DataRx; CountRx=0;}
_0x48:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,9
	LDI  R30,LOW(0)
_0x263:
	STS  _CountRx,R30
;break;
;}
_0x29:
;
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void konversi_ardu(){
;    miringDepan = (int) -1 *((DataMasuk[0]*2)-180);
;    miringSamping = (int) -1*((DataMasuk[1]*2)-180);
;    kompas = (int) (DataMasuk[2]*2);
;}
;
;void konversi_raspi(){
_konversi_raspi:
;    xx = atoi(DataR1);
	LDI  R26,LOW(_DataR1)
	LDI  R27,HIGH(_DataR1)
	CALL _atoi
	STS  _xx,R30
	STS  _xx+1,R31
;    yy = atoi(DataR2);
	LDI  R26,LOW(_DataR2)
	LDI  R27,HIGH(_DataR2)
	CALL _atoi
	STS  _yy,R30
	STS  _yy+1,R31
;}
	RET
;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;{
_timer1_ovf_isr:
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;  switch (Timeslot)
	MOV  R30,R3
	CALL SUBOPT_0x19
;  {
;    case 0:
	BRNE _0x4D
;      kaka1_1;
	LDS  R30,267
	ORI  R30,4
	STS  267,R30
;      kaki1 = 1;
	SBI  0x8,7
;      OCR1AH = ((2 * (servoInitError[0] + servo[0])) + timer3ms) >> 8;
	LDS  R30,_servo
	LDS  R31,_servo+1
	LDS  R26,_servoInitError
	LDS  R27,_servoInitError+1
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[0] + servo[0])) + timer3ms) & 0xff;
	LDS  R30,_servo
	LDS  R26,_servoInitError
	CALL SUBOPT_0x1D
;      OCR1BH = ((6000-2 * (servoInitError[6] + servo[6])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,12
	__GETW1MN _servo,12
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	STS  139,R30
;      OCR1BL = ((6000-2 * (servoInitError[6] + servo[6])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,12
	__GETB1MN _servo,12
	CALL SUBOPT_0x1F
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
;      break;
	RJMP _0x4C
;
;    case 1:
_0x4D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x50
;      kaka2_1;
	LDS  R30,267
	ORI  R30,8
	STS  267,R30
;      kaki2 = 1;
	SBI  0x8,6
;      OCR1AH = ((2 * (servoInitError[1] + servo[1])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,2
	__GETW1MN _servo,2
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[1] + servo[1])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,2
	__GETB1MN _servo,2
	CALL SUBOPT_0x1D
;      OCR1BH = ((6000-2 * (servoInitError[7] + servo[7])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,14
	__GETW1MN _servo,14
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	STS  139,R30
;      OCR1BL = ((6000-2 * (servoInitError[7] + servo[7])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,14
	__GETB1MN _servo,14
	CALL SUBOPT_0x1F
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 2;
	LDI  R30,LOW(2)
	MOV  R3,R30
;      break;
	RJMP _0x4C
;
;    case 2:
_0x50:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x53
;      kaka3_1;
	LDS  R30,267
	ORI  R30,0x10
	STS  267,R30
;      kaki3 = 1;
	SBI  0x2,6
;      OCR1AH = ((6000-2 * (servoInitError[2] + servo[2])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,4
	__GETW1MN _servo,4
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	STS  137,R30
;      OCR1AL = ((6000-2 * (servoInitError[2] + servo[2])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,4
	__GETB1MN _servo,4
	CALL SUBOPT_0x20
;      OCR1BH = ((2 * (servoInitError[8] + servo[8])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,16
	__GETW1MN _servo,16
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  139,R30
;      OCR1BL = ((2 * (servoInitError[8] + servo[8])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,16
	__GETB1MN _servo,16
	CALL SUBOPT_0x21
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 3;
	LDI  R30,LOW(3)
	MOV  R3,R30
;      break;
	RJMP _0x4C
;
;    case 3:
_0x53:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x56
;      kaka4_1;
	LDS  R30,267
	ORI  R30,0x20
	STS  267,R30
;      kaki4 = 1;
	SBI  0x2,7
;      OCR1AH = ((6000-2 * (servoInitError[3] + servo[3])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,6
	__GETW1MN _servo,6
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	STS  137,R30
;      OCR1AL = ((6000-2 * (servoInitError[3] + servo[3])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,6
	__GETB1MN _servo,6
	CALL SUBOPT_0x20
;      OCR1BH = ((2 * (servoInitError[9] + servo[9])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,18
	__GETW1MN _servo,18
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  139,R30
;      OCR1BL = ((2 * (servoInitError[9] + servo[9])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,18
	__GETB1MN _servo,18
	CALL SUBOPT_0x21
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 4;
	LDI  R30,LOW(4)
	MOV  R3,R30
;      break;
	RJMP _0x4C
;
;    case 4:
_0x56:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x59
;      kaka5_1;
	LDS  R30,267
	ORI  R30,0x40
	STS  267,R30
;      kaki5 = 1;
	SBI  0x2,4
;      OCR1AH = ((2 * (servoInitError[4] + servo[4])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,8
	__GETW1MN _servo,8
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[4] + servo[4])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,8
	__GETB1MN _servo,8
	CALL SUBOPT_0x1D
;      OCR1BH = ((6000-2 * (servoInitError[10] + servo[10])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,20
	__GETW1MN _servo,20
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	STS  139,R30
;      OCR1BL = ((6000-2 * (servoInitError[10] + servo[10])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,20
	__GETB1MN _servo,20
	CALL SUBOPT_0x1F
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 5;
	LDI  R30,LOW(5)
	MOV  R3,R30
;      break;
	RJMP _0x4C
;
;    case 5:
_0x59:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5C
;      kaka6_1;
	LDS  R30,267
	ORI  R30,0x80
	STS  267,R30
;      kaki6 = 1;
	SBI  0x2,5
;      OCR1AH = ((2 * (servoInitError[5] + servo[5])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,10
	__GETW1MN _servo,10
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[5] + servo[5])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,10
	__GETB1MN _servo,10
	CALL SUBOPT_0x1D
;      OCR1BH = ((2 * (servoInitError[11] + servo[11])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,22
	__GETW1MN _servo,22
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  139,R30
;      OCR1BL = ((2 * (servoInitError[11] + servo[11])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,22
	__GETB1MN _servo,22
	CALL SUBOPT_0x21
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 6;
	LDI  R30,LOW(6)
	MOV  R3,R30
;      break;
	RJMP _0x4C
;
;    case 6:
_0x5C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4C
;
;      TCNT1H = timer2ms >> 8;
	LDI  R30,LOW(248)
	STS  133,R30
;      TCNT1L = timer2ms & 0xff;
	LDI  R30,LOW(48)
	STS  132,R30
;      Timeslot = 0;
	CLR  R3
;  }
_0x4C:
;
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	RETI
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;{
_timer1_compa_isr:
	CALL SUBOPT_0x18
;switch (Timeslot)
	MOV  R30,R3
	CALL SUBOPT_0x19
;    {
;    case 0:
	BREQ _0x62
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x64
;            kaka1_0;
	LDS  R30,267
	ANDI R30,0xFB
	RJMP _0x264
;    break;
;
;    case 2:
_0x64:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x65
;            kaka2_0;
	LDS  R30,267
	ANDI R30,0XF7
	RJMP _0x264
;    break;
;
;    case 3:
_0x65:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x66
;            kaka3_0;
	LDS  R30,267
	ANDI R30,0xEF
	RJMP _0x264
;    break;
;
;    case 4:
_0x66:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x67
;            kaka4_0;
	LDS  R30,267
	ANDI R30,0xDF
	RJMP _0x264
;    break;
;
;    case 5:
_0x67:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x68
;            kaka5_0;
	LDS  R30,267
	ANDI R30,0xBF
	RJMP _0x264
;    break;
;
;    case 6:
_0x68:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x62
;            kaka6_0;
	LDS  R30,267
	ANDI R30,0x7F
_0x264:
	STS  267,R30
;    break;
;    }
_0x62:
;
;}
	RJMP _0x28C
;
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
;{
_timer1_compb_isr:
	CALL SUBOPT_0x18
;switch (Timeslot)
	MOV  R30,R3
	CALL SUBOPT_0x19
;    {
;    case 0:
	BREQ _0x6C
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6E
;            kaki1 = 0;
	CBI  0x8,7
;    break;
	RJMP _0x6C
;
;    case 2:
_0x6E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x71
;            kaki2 = 0;
	CBI  0x8,6
;    break;
	RJMP _0x6C
;
;    case 3:
_0x71:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x74
;            kaki3 = 0;
	CBI  0x2,6
;    break;
	RJMP _0x6C
;
;    case 4:
_0x74:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x77
;            kaki4 = 0;
	CBI  0x2,7
;    break;
	RJMP _0x6C
;
;    case 5:
_0x77:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x7A
;            kaki5 = 0;
	CBI  0x2,4
;    break;
	RJMP _0x6C
;
;    case 6:
_0x7A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x6C
;            kaki6 = 0;
	CBI  0x2,5
;    break;
;    }
_0x6C:
;
;
;}
	RJMP _0x28C
;
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
;{
_timer3_ovf_isr:
	CALL SUBOPT_0x0
;  switch (Timeslot2)
	CALL SUBOPT_0x22
;  {
;    case 0:
	BRNE _0x83
;      taka1 = 1;
	SBI  0x11,0
;      taki1 = 1;
	SBI  0x11,7
;      OCR3AH = ((2 * (servoInitError[12] + servo[12])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,24
	__GETW1MN _servo,24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[12] + servo[12])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,24
	__GETB1MN _servo,24
	CALL SUBOPT_0x23
;      OCR3BH = ((2 * (servoInitError[15] + servo[15])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,30
	__GETW1MN _servo,30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[15] + servo[15])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,30
	__GETB1MN _servo,30
	CALL SUBOPT_0x24
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 1;
	LDI  R30,LOW(1)
	RJMP _0x265
;      break;
;
;    case 1:
_0x83:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x88
;      taka2 = 1;
	SBI  0x11,1
;      taki2 = 1;
	SBI  0x11,6
;      OCR3AH = ((2 * (servoInitError[13] + servo[13])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,26
	__GETW1MN _servo,26
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[13] + servo[13])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,26
	__GETB1MN _servo,26
	CALL SUBOPT_0x23
;      OCR3BH = ((2 * (servoInitError[16] + servo[16])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,32
	__GETW1MN _servo,32
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[16] + servo[16])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,32
	__GETB1MN _servo,32
	CALL SUBOPT_0x24
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 2;
	LDI  R30,LOW(2)
	RJMP _0x265
;      break;
;
;    case 2:
_0x88:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8D
;      taka3 = 1;
	SBI  0x11,2
;      taki3 = 1;
	SBI  0x11,5
;      OCR3AH = ((2 * (servoInitError[14] + servo[14])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,28
	__GETW1MN _servo,28
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[14] + servo[14])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,28
	__GETB1MN _servo,28
	CALL SUBOPT_0x23
;      OCR3BH = ((2 * (servoInitError[17] + servo[17])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,34
	__GETW1MN _servo,34
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[17] + servo[17])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,34
	__GETB1MN _servo,34
	CALL SUBOPT_0x24
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 3;
	LDI  R30,LOW(3)
	RJMP _0x265
;      break;
;
;    case 3:
_0x8D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x92
;      pala1 = 1;
	SBI  0x11,3
;      pala2 = 1;
	SBI  0x11,4
;      OCR3AH = ((2 * (servoInitError[18] + servo[18])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,36
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[18] + servo[18])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,36
	__GETB1MN _servo,36
	CALL SUBOPT_0x23
;      OCR3BH = ((2 * (servoInitError[19] + servo[19])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,38
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[19] + servo[19])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,38
	__GETB1MN _servo,38
	CALL SUBOPT_0x24
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 4;
	LDI  R30,LOW(4)
	RJMP _0x265
;      break;
;
;    case 4:
_0x92:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x97
;
;        if(hitungTendang > 0){
	LDS  R26,_hitungTendang
	LDS  R27,_hitungTendang+1
	CALL __CPW02
	BRGE _0x98
;            hitungTendang--;
	LDI  R26,LOW(_hitungTendang)
	LDI  R27,HIGH(_hitungTendang)
	CALL SUBOPT_0x3
;        }
;
;        if(hitung > 0){
_0x98:
	LDS  R26,_hitung
	LDS  R27,_hitung+1
	CALL __CPW02
	BRGE _0x99
;         hitung--;
	LDI  R26,LOW(_hitung)
	LDI  R27,HIGH(_hitung)
	CALL SUBOPT_0x3
;        }
;
;        if(hitungNgawur > 0){
_0x99:
	CALL SUBOPT_0x27
	BRGE _0x9A
;         hitungNgawur--;
	LDI  R26,LOW(_hitungNgawur)
	LDI  R27,HIGH(_hitungNgawur)
	CALL SUBOPT_0x3
;        }
;
;        if(hitungWaras > 0){
_0x9A:
	CALL SUBOPT_0x28
	BRGE _0x9B
;         hitungWaras--;
	LDI  R26,LOW(_hitungWaras)
	LDI  R27,HIGH(_hitungWaras)
	CALL SUBOPT_0x3
;        }
;
;      TCNT3H = timer3ms >> 8;
_0x9B:
	CALL SUBOPT_0x29
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 5;
	LDI  R30,LOW(5)
	RJMP _0x265
;      break;
;
;    case 5:
_0x97:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x9C
;//        miringDepan = (int) -1 *((DataMasuk[0]*2)-180);
;//        miringSamping = (int) -1*((DataMasuk[1]*2)-180);
;//        kompas = (int) (DataMasuk[2]*2);
;//
;//        pos_x = (int)DataMasukR[0]*2;
;//        pos_y = (int)DataMasukR[1];
;//
;
;      TCNT3H = timer3ms >> 8;
	CALL SUBOPT_0x29
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 6;
	LDI  R30,LOW(6)
	RJMP _0x265
;      break;
;
;    case 6:
_0x9C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x82
;        count++;
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	CALL SUBOPT_0x1
;        if(count>=30){
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,30
	BRLT _0x9E
;         count=0;
	LDI  R30,LOW(0)
	STS  _count,R30
	STS  _count+1,R30
;         Ball=countBall;
	LDS  R30,_countBall
	LDS  R31,_countBall+1
	STS  _Ball,R30
	STS  _Ball+1,R31
;         countBall=0;
	LDI  R30,LOW(0)
	STS  _countBall,R30
	STS  _countBall+1,R30
;        }
;
;        if(Ball >= 5) buzzon;
_0x9E:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x9F
	SBI  0x14,7
;        else if (Ball <= 5) buzzoff;
	RJMP _0xA0
_0x9F:
	CALL SUBOPT_0x2A
	SBIW R26,6
	BRGE _0xA1
	CBI  0x14,7
;
;
;      TCNT3H = timer3ms >> 8;
_0xA1:
_0xA0:
	CALL SUBOPT_0x29
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 0;
	LDI  R30,LOW(0)
_0x265:
	STS  _Timeslot2,R30
;  }
_0x82:
;
;}
	CALL SUBOPT_0x4
	RETI
;
;interrupt [TIM3_COMPA] void timer3_compa_isr(void)
;{
_timer3_compa_isr:
	CALL SUBOPT_0x18
;switch (Timeslot2)
	CALL SUBOPT_0x22
;    {
;    case 0:
	BREQ _0xA4
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA6
;            taka1 = 0;
	CBI  0x11,0
;    break;
	RJMP _0xA4
;
;    case 2:
_0xA6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA9
;            taka2 = 0;
	CBI  0x11,1
;    break;
	RJMP _0xA4
;
;    case 3:
_0xA9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xAC
;            taka3 = 0;
	CBI  0x11,2
;    break;
	RJMP _0xA4
;
;    case 4:
_0xAC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xAF
;            pala1 = 0;
	CBI  0x11,3
;    break;
;
;    case 5:
_0xAF:
;
;    break;
;
;    case 6:
;
;    break;
;    }
_0xA4:
;
;}
	RJMP _0x28C
;
;interrupt [TIM3_COMPB] void timer3_compb_isr(void)
;{
_timer3_compb_isr:
	CALL SUBOPT_0x18
;switch (Timeslot2)
	CALL SUBOPT_0x22
;    {
;    case 0:
	BREQ _0xB6
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB8
;            taki1 = 0;
	CBI  0x11,7
;    break;
	RJMP _0xB6
;
;    case 2:
_0xB8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBB
;            taki2 = 0;
	CBI  0x11,6
;    break;
	RJMP _0xB6
;
;    case 3:
_0xBB:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xBE
;            taki3 = 0;
	CBI  0x11,5
;    break;
	RJMP _0xB6
;
;    case 4:
_0xBE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC1
;            pala2 = 0;
	CBI  0x11,4
;    break;
;
;    case 5:
_0xC1:
;
;    break;
;
;    case 6:
;
;    break;
;    }
_0xB6:
;}
_0x28C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;void taskGerakan()
; 0000 0086 {
_taskGerakan:
; 0000 0087     if (langkah <= 0)
	LDS  R26,_langkah
	LDS  R27,_langkah+1
	CALL __CPW02
	BRGE PC+3
	JMP _0xC6
; 0000 0088     {
; 0000 0089 //        printf("===XYZ %0.2f %0.2f %0.2f || ",X[0],Y[0],Z[0]);
; 0000 008A //        printf("===XYZ %0.2f %0.2f %0.2f \n",X[1],Y[1],Z[1]);
; 0000 008B 
; 0000 008C         if (VX != 0 || VY != 0 || W != 0)
	CALL SUBOPT_0x2B
	BRNE _0xC8
	CALL SUBOPT_0x2C
	BRNE _0xC8
	CALL SUBOPT_0x2D
	BREQ _0xC7
_0xC8:
; 0000 008D         {
; 0000 008E           countGerakan++;
	LDI  R26,LOW(_countGerakan)
	LDI  R27,HIGH(_countGerakan)
	CALL SUBOPT_0x1
; 0000 008F         }
; 0000 0090         else
	RJMP _0xCA
_0xC7:
; 0000 0091         {
; 0000 0092           countGerakan = 0;
	LDI  R30,LOW(0)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R30
; 0000 0093         }
_0xCA:
; 0000 0094 
; 0000 0095         if (countGerakan > jumlahGerak)
	LDS  R30,_jumlahGerak
	LDS  R31,_jumlahGerak+1
	LDS  R26,_countGerakan
	LDS  R27,_countGerakan+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xCB
; 0000 0096         {
; 0000 0097           if (VX != 0 || VY != 0 || W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0xCD
	CALL SUBOPT_0x2C
	BRNE _0xCD
	CALL SUBOPT_0x2D
	BREQ _0xCC
_0xCD:
; 0000 0098             countGerakan = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R31
; 0000 0099           else
	RJMP _0xCF
_0xCC:
; 0000 009A             countGerakan = 0;
	LDI  R30,LOW(0)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R30
; 0000 009B         }
_0xCF:
; 0000 009C 
; 0000 009D         langkah = langkahMax;
_0xCB:
	CALL SUBOPT_0x2E
	STS  _langkah,R30
	STS  _langkah+1,R31
; 0000 009E         for (countNo = 0; countNo < 2; countNo++)
	CALL SUBOPT_0xA
_0xD1:
	CALL SUBOPT_0xB
	BRLT PC+3
	JMP _0xD2
; 0000 009F         {
; 0000 00A0             Xerror[countNo] = (X[countNo] - Xset[countNo]) / langkahMax;
	CALL SUBOPT_0x2F
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0x31
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	CALL SUBOPT_0x33
; 0000 00A1             Yerror[countNo] = (Y[countNo] - Yset[countNo]) / langkahMax;
	LDI  R26,LOW(_Yerror)
	LDI  R27,HIGH(_Yerror)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	LDI  R26,LOW(_Y)
	LDI  R27,HIGH(_Y)
	CALL SUBOPT_0x35
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0x10
	CALL SUBOPT_0x31
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	CALL SUBOPT_0x33
; 0000 00A2             Zerror[countNo] = (Z[countNo] - Zset[countNo]) / langkahMax;
	LDI  R26,LOW(_Zerror)
	LDI  R27,HIGH(_Zerror)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	LDI  R26,LOW(_Z)
	LDI  R27,HIGH(_Z)
	CALL SUBOPT_0x35
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	CALL SUBOPT_0x31
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00A3         }
	CALL SUBOPT_0x15
	RJMP _0xD1
_0xD2:
; 0000 00A4     }
; 0000 00A5     else
	RJMP _0xD3
_0xC6:
; 0000 00A6     {
; 0000 00A7         for (countNo = 0; countNo < 2; countNo++)
	CALL SUBOPT_0xA
_0xD5:
	CALL SUBOPT_0xB
	BRLT PC+3
	JMP _0xD6
; 0000 00A8         {
; 0000 00A9             Xset[countNo] += Xerror[countNo]; Yset[countNo] += Yerror[countNo]; Zset[countNo] += Zerror[countNo];
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x33
	CALL SUBOPT_0x10
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	LDI  R26,LOW(_Yerror)
	LDI  R27,HIGH(_Yerror)
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x33
	CALL SUBOPT_0x12
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	LDI  R26,LOW(_Zerror)
	LDI  R27,HIGH(_Zerror)
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00AA         }
	CALL SUBOPT_0x15
	RJMP _0xD5
_0xD6:
; 0000 00AB //        printf("XYZset %0.2f %0.2f %0.2f || ",Xset[0],Yset[0],Zset[0]);
; 0000 00AC //        printf("XYZset %0.2f %0.2f %0.2f \n",Xset[1],Yset[1],Zset[1]);
; 0000 00AD         inversKinematic();
	RCALL _inversKinematic
; 0000 00AE         for (countNo = 0; countNo < 12; countNo++)
	CALL SUBOPT_0xA
_0xD8:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,12
	BRGE _0xD9
; 0000 00AF         {
; 0000 00B0           if (servoSet[countNo] >= 2500)
	CALL SUBOPT_0x36
	CALL __GETW1P
	CPI  R30,LOW(0x9C4)
	LDI  R26,HIGH(0x9C4)
	CPC  R31,R26
	BRLT _0xDA
; 0000 00B1             servoSet[countNo] = 2500;
	CALL SUBOPT_0x36
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	RJMP _0x266
; 0000 00B2           else if (servoSet[countNo] <= 500)
_0xDA:
	CALL SUBOPT_0x36
	CALL __GETW1P
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRGE _0xDC
; 0000 00B3             servoSet[countNo] = 500;
	CALL SUBOPT_0x36
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
_0x266:
	ST   X+,R30
	ST   X,R31
; 0000 00B4           servo[countNo] = (int)(servoSet[countNo]);
_0xDC:
	CALL SUBOPT_0xC
	LDI  R26,LOW(_servo)
	LDI  R27,HIGH(_servo)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x36
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 00B5         }
	CALL SUBOPT_0x15
	RJMP _0xD8
_0xD9:
; 0000 00B6         langkah--;
	LDI  R26,LOW(_langkah)
	LDI  R27,HIGH(_langkah)
	CALL SUBOPT_0x3
; 0000 00B7     }
_0xD3:
; 0000 00B8 }
	RET
;
;void inversKinematic()
; 0000 00BB {
_inversKinematic:
; 0000 00BC     for(I=0;I<2;I++)
	LDI  R30,LOW(0)
	STS  _I,R30
	STS  _I+1,R30
_0xDE:
	LDS  R26,_I
	LDS  R27,_I+1
	SBIW R26,2
	BRLT PC+3
	JMP _0xDF
; 0000 00BD     {
; 0000 00BE       XiKuadrat = Xset[I] * Xset[I];
	CALL SUBOPT_0x37
	CALL SUBOPT_0xD
	CALL SUBOPT_0x31
	CALL SUBOPT_0x38
	STS  _XiKuadrat,R30
	STS  _XiKuadrat+1,R31
	STS  _XiKuadrat+2,R22
	STS  _XiKuadrat+3,R23
; 0000 00BF       YiKuadrat = Yset[I] * Yset[I];
	CALL SUBOPT_0x37
	CALL SUBOPT_0x10
	CALL SUBOPT_0x31
	CALL SUBOPT_0x38
	STS  _YiKuadrat,R30
	STS  _YiKuadrat+1,R31
	STS  _YiKuadrat+2,R22
	STS  _YiKuadrat+3,R23
; 0000 00C0       ZiKuadrat = Zset[I] * Zset[I];
	CALL SUBOPT_0x37
	CALL SUBOPT_0x12
	CALL SUBOPT_0x31
	CALL SUBOPT_0x38
	STS  _ZiKuadrat,R30
	STS  _ZiKuadrat+1,R31
	STS  _ZiKuadrat+2,R22
	STS  _ZiKuadrat+3,R23
; 0000 00C1 
; 0000 00C2       bi = sqrt(XiKuadrat + ZiKuadrat) - L1 - L4;
	LDS  R26,_XiKuadrat
	LDS  R27,_XiKuadrat+1
	LDS  R24,_XiKuadrat+2
	LDS  R25,_XiKuadrat+3
	CALL SUBOPT_0x39
	CALL SUBOPT_0x5
	CALL __SUBF12
	CALL SUBOPT_0x9
	CALL __SUBF12
	STS  _bi,R30
	STS  _bi+1,R31
	STS  _bi+2,R22
	STS  _bi+3,R23
; 0000 00C3       biKuadrat = bi * bi;
	CALL SUBOPT_0x3A
	CALL __MULF12
	STS  _biKuadrat,R30
	STS  _biKuadrat+1,R31
	STS  _biKuadrat+2,R22
	STS  _biKuadrat+3,R23
; 0000 00C4       ai = sqrt(biKuadrat + YiKuadrat);
	LDS  R30,_YiKuadrat
	LDS  R31,_YiKuadrat+1
	LDS  R22,_YiKuadrat+2
	LDS  R23,_YiKuadrat+3
	LDS  R26,_biKuadrat
	LDS  R27,_biKuadrat+1
	LDS  R24,_biKuadrat+2
	LDS  R25,_biKuadrat+3
	CALL SUBOPT_0x39
	STS  _ai,R30
	STS  _ai+1,R31
	STS  _ai+2,R22
	STS  _ai+3,R23
; 0000 00C5       aiKuadrat = ai * ai;
	CALL SUBOPT_0x3B
	LDS  R26,_ai
	LDS  R27,_ai+1
	LDS  R24,_ai+2
	LDS  R25,_ai+3
	CALL __MULF12
	STS  _aiKuadrat,R30
	STS  _aiKuadrat+1,R31
	STS  _aiKuadrat+2,R22
	STS  _aiKuadrat+3,R23
; 0000 00C6       gamai = atan2(Yset[I],bi);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x10
	CALL SUBOPT_0x31
	CALL __PUTPARD1
	CALL SUBOPT_0x3A
	CALL _atan2
	STS  _gamai,R30
	STS  _gamai+1,R31
	STS  _gamai+2,R22
	STS  _gamai+3,R23
; 0000 00C7       A1[I] = atan2(Xset[I],Zset[I]);
	CALL SUBOPT_0x37
	LDI  R26,LOW(_A1)
	LDI  R27,HIGH(_A1)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	CALL SUBOPT_0xD
	CALL SUBOPT_0x31
	CALL __PUTPARD1
	CALL SUBOPT_0x37
	CALL SUBOPT_0x12
	CALL SUBOPT_0x31
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan2
	POP  R26
	POP  R27
	CALL SUBOPT_0x3C
; 0000 00C8       A3[I] = acos((aiKuadrat - L2Kuadrat - L3Kuadrat) / (2 * L2 * L3));
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3D
	LDS  R30,_aiKuadrat
	LDS  R31,_aiKuadrat+1
	LDS  R22,_aiKuadrat+2
	LDS  R23,_aiKuadrat+3
	CALL __SUBF12
	LDS  R26,_L3Kuadrat
	LDS  R27,_L3Kuadrat+1
	LDS  R24,_L3Kuadrat+2
	LDS  R25,_L3Kuadrat+3
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3E
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3F
	POP  R26
	POP  R27
	CALL SUBOPT_0x3C
; 0000 00C9       ci = L3 * cos(A3[I]);
	CALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	CALL _cos
	CALL SUBOPT_0x8
	STS  _ci,R30
	STS  _ci+1,R31
	STS  _ci+2,R22
	STS  _ci+3,R23
; 0000 00CA       betai = acos((L2 + ci) / ai);
	CALL SUBOPT_0x7
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3F
	STS  _betai,R30
	STS  _betai+1,R31
	STS  _betai+2,R22
	STS  _betai+3,R23
; 0000 00CB       A2[I] = -(gamai + betai);
	CALL SUBOPT_0x37
	LDI  R26,LOW(_A2)
	LDI  R27,HIGH(_A2)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	LDS  R30,_betai
	LDS  R31,_betai+1
	LDS  R22,_betai+2
	LDS  R23,_betai+3
	LDS  R26,_gamai
	LDS  R27,_gamai+1
	LDS  R24,_gamai+2
	LDS  R25,_gamai+3
	CALL SUBOPT_0x40
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00CC       alphai[I] = acos((L2Kuadrat + L3Kuadrat - aiKuadrat) / (2 * L2 * L3));
	CALL SUBOPT_0x37
	LDI  R26,LOW(_alphai)
	LDI  R27,HIGH(_alphai)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	LDS  R30,_L3Kuadrat
	LDS  R31,_L3Kuadrat+1
	LDS  R22,_L3Kuadrat+2
	LDS  R23,_L3Kuadrat+3
	CALL SUBOPT_0x3D
	CALL __ADDF12
	LDS  R26,_aiKuadrat
	LDS  R27,_aiKuadrat+1
	LDS  R24,_aiKuadrat+2
	LDS  R25,_aiKuadrat+3
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3E
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3F
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00CD       A5[I] = A1[I];
	CALL SUBOPT_0x37
	LDI  R26,LOW(_A5)
	LDI  R27,HIGH(_A5)
	CALL SUBOPT_0x34
	MOVW R0,R30
	CALL SUBOPT_0x37
	LDI  R26,LOW(_A1)
	LDI  R27,HIGH(_A1)
	CALL SUBOPT_0x35
	MOVW R26,R0
	CALL __PUTDP1
; 0000 00CE     }
	LDI  R26,LOW(_I)
	LDI  R27,HIGH(_I)
	CALL SUBOPT_0x1
	RJMP _0xDE
_0xDF:
; 0000 00CF 
; 0000 00D0     //kaki kanan
; 0000 00D1     sudutSet[5]  = 90+10; //pinggul
	__POINTW1MN _sudutSet,20
	__GETD2N 0x42C80000
	CALL SUBOPT_0x14
; 0000 00D2     sudutSet[4]  = (A1[0] * (rad))+90;
	CALL SUBOPT_0x41
	LDS  R26,_A1
	LDS  R27,_A1+1
	LDS  R24,_A1+2
	LDS  R25,_A1+3
	CALL SUBOPT_0x42
	__PUTD1MN _sudutSet,16
; 0000 00D3     sudutSet[3]  = (A2[0] * (rad));
	CALL SUBOPT_0x41
	LDS  R26,_A2
	LDS  R27,_A2+1
	LDS  R24,_A2+2
	LDS  R25,_A2+3
	CALL __MULF12
	CALL SUBOPT_0x43
; 0000 00D4     sudutSet[2]  = (A3[0] * (rad))+90;
	CALL SUBOPT_0x41
	LDS  R26,_A3
	LDS  R27,_A3+1
	LDS  R24,_A3+2
	LDS  R25,_A3+3
	CALL SUBOPT_0x42
	__PUTD1MN _sudutSet,8
; 0000 00D5     sudutSet[1]  = (-(180 - (alphai[0] * (rad)) + (sudutSet[3])))+95;
	CALL SUBOPT_0x41
	LDS  R26,_alphai
	LDS  R27,_alphai+1
	LDS  R24,_alphai+2
	LDS  R25,_alphai+3
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	CALL SUBOPT_0x40
	__GETD2N 0x42BE0000
	CALL __ADDF12
	__PUTD1MN _sudutSet,4
; 0000 00D6     sudutSet[0]  = (A5[0] * (rad))+90-5+5; //kaki
	CALL SUBOPT_0x41
	LDS  R26,_A5
	LDS  R27,_A5+1
	LDS  R24,_A5+2
	LDS  R25,_A5+3
	CALL SUBOPT_0x42
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40A00000
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	STS  _sudutSet,R30
	STS  _sudutSet+1,R31
	STS  _sudutSet+2,R22
	STS  _sudutSet+3,R23
; 0000 00D7     sudutSet[3]  += 73+6-5-20; //90      edt
	CALL SUBOPT_0x45
	__GETD2N 0x42580000
	CALL __ADDF12
	CALL SUBOPT_0x43
; 0000 00D8 
; 0000 00D9     //kaki kiri
; 0000 00DA     sudutSet[11] = 90; //pinggul
	__POINTW1MN _sudutSet,44
	__GETD2N 0x42B40000
	CALL SUBOPT_0x14
; 0000 00DB     sudutSet[10] = (A1[1] * (rad))+98; //90 edit
	__GETD1MN _A1,4
	CALL SUBOPT_0x48
	__GETD2N 0x42C40000
	CALL __ADDF12
	__PUTD1MN _sudutSet,40
; 0000 00DC     sudutSet[9]  = (A2[1] * (rad))+5;       //0  edit
	__GETD1MN _A2,4
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
	CALL SUBOPT_0x49
; 0000 00DD     sudutSet[8]  = (A3[1] * (rad))+90;
	__GETD1MN _A3,4
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x42
	__PUTD1MN _sudutSet,32
; 0000 00DE     sudutSet[7]  = (-(180 - (alphai[1] * (rad)) + (sudutSet[9])))+90+3;       //90
	__GETD1MN _alphai,4
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x44
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x40
	__GETD2N 0x42B40000
	CALL __ADDF12
	__GETD2N 0x40400000
	CALL __ADDF12
	__PUTD1MN _sudutSet,28
; 0000 00DF     sudutSet[6]  = (A5[1] * (rad))+90+5; //kaki //90
	__GETD1MN _A5,4
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x42
	CALL SUBOPT_0x47
	__PUTD1MN _sudutSet,24
; 0000 00E0     sudutSet[9]  += 69+6-5-20;   //90             edit
	CALL SUBOPT_0x4B
	__GETD2N 0x42480000
	CALL __ADDF12
	CALL SUBOPT_0x49
; 0000 00E1 
; 0000 00E2 //    printf("R %0.2f %0.2f %0.2f %0.2f %0.2f || ",sudutSet[4],sudutSet[3],sudutSet[2],sudutSet[1],sudutSet[0]);
; 0000 00E3 //    printf("L %0.2f %0.2f %0.2f %0.2f %0.2f \n",sudutSet[10],sudutSet[9],sudutSet[8],sudutSet[7],sudutSet[6]);
; 0000 00E4     for (countNo = 0; countNo < 12; countNo++)
	CALL SUBOPT_0xA
_0xE1:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,12
	BRGE _0xE2
; 0000 00E5     {
; 0000 00E6         servoSet[countNo] = 800 + (7.7777* sudutSet[countNo]);
	CALL SUBOPT_0xC
	LDI  R26,LOW(_servoSet)
	LDI  R27,HIGH(_servoSet)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	LDI  R26,LOW(_sudutSet)
	LDI  R27,HIGH(_sudutSet)
	CALL SUBOPT_0x35
	__GETD2N 0x40F8E2EB
	CALL __MULF12
	__GETD2N 0x44480000
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00E7     }
	CALL SUBOPT_0x15
	RJMP _0xE1
_0xE2:
; 0000 00E8 
; 0000 00E9     //printf("SR %d %d %d %d %d || ",servoSet[4],servoSet[3],servoSet[2],servoSet[1],servoSet[0]);
; 0000 00EA     //printf("SL %d %d %d %d %d \n ",servoSet[10],servoSet[9],servoSet[8],servoSet[7],servoSet[6]);
; 0000 00EB 
; 0000 00EC }
	RET
;
;void InputXYZ()
; 0000 00EF {
_InputXYZ:
; 0000 00F0     for (countNo = 0; countNo < 2; countNo++){
	CALL SUBOPT_0xA
_0xE4:
	CALL SUBOPT_0xB
	BRGE _0xE5
; 0000 00F1         X[countNo] += initPositionX; Y[countNo] += initPositionY; Z[countNo] += initPositionZ;
	CALL SUBOPT_0x30
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0xE
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x33
	LDI  R26,LOW(_Y)
	LDI  R27,HIGH(_Y)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x11
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x33
	LDI  R26,LOW(_Z)
	LDI  R27,HIGH(_Z)
	CALL SUBOPT_0x34
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x13
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00F2     }
	CALL SUBOPT_0x15
	RJMP _0xE4
_0xE5:
; 0000 00F3     langkah=0;
	LDI  R30,LOW(0)
	STS  _langkah,R30
	STS  _langkah+1,R30
; 0000 00F4 }
	RET
;
;void main(void)
; 0000 00F7 {
_main:
; 0000 00F8 init();
	CALL _init
; 0000 00F9 X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x16
; 0000 00FA X[1]=0; Y[1]=0; Z[1]=0;
; 0000 00FB InputXYZ();
	RCALL _InputXYZ
; 0000 00FC #asm("sei")
	sei
; 0000 00FD hitung = 90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _hitung,R30
	STS  _hitung+1,R31
; 0000 00FE robot=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 5,6
; 0000 00FF state = 1;
	CALL SUBOPT_0x4C
; 0000 0100 while (1)
_0xE6:
; 0000 0101     {
; 0000 0102        //maju();
; 0000 0103        siap();
	RCALL _siap
; 0000 0104        switch(state){
	LDS  R30,_state
	LDS  R31,_state+1
; 0000 0105         case 0:
	SBIW R30,0
	BRNE _0xEC
; 0000 0106             siap();
	RCALL _siap
; 0000 0107             konversi_raspi();
	RCALL _konversi_raspi
; 0000 0108             printf("Raspi Y  %d\r\n",xx);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_xx
	LDS  R31,_xx+1
	CALL SUBOPT_0x4D
; 0000 0109          break;
	RJMP _0xEB
; 0000 010A 
; 0000 010B          case 1:
_0xEC:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xED
; 0000 010C             cari_bola();
	RCALL _cari_bola
; 0000 010D          break;
	RJMP _0xEB
; 0000 010E 
; 0000 010F          case 2:
_0xED:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0110             pid_servo();
	RCALL _pid_servo
; 0000 0111          break;
	RJMP _0xEB
; 0000 0112 
; 0000 0113          case 3:
_0xEE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0114             berjalan();
	RCALL _berjalan
; 0000 0115          break;
	RJMP _0xEB
; 0000 0116 
; 0000 0117 
; 0000 0118          case 10:
_0xEF:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0119             bangun_depan();
	RCALL _bangun_depan
; 0000 011A          break;
	RJMP _0xEB
; 0000 011B 
; 0000 011C          case 11:
_0xF0:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xF1
; 0000 011D             bangun_belakang();
	RCALL _bangun_belakang
; 0000 011E          break;
	RJMP _0xEB
; 0000 011F 
; 0000 0120          case 12:
_0xF1:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0121             nek_ambruk();
	RCALL _nek_ambruk
; 0000 0122          break;
	RJMP _0xEB
; 0000 0123 
; 0000 0124          case 13:
_0xF2:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0125             cek_ambruk();
	RCALL _cek_ambruk
; 0000 0126          break;
	RJMP _0xEB
; 0000 0127 
; 0000 0128          case 101:
_0xF3:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0129             ngawur();
	RCALL _ngawur
; 0000 012A          break;
; 0000 012B         }
_0xEB:
; 0000 012C 
; 0000 012D     }
	RJMP _0xE6
; 0000 012E }
_0xF5:
	RJMP _0xF5
;
;void pid_servo(){ //        state = 2
; 0000 0130 void pid_servo(){
_pid_servo:
; 0000 0131     nek_ambruk();
	RCALL _nek_ambruk
; 0000 0132     errorx = spx - pos_x;
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
; 0000 0133     px = errorx/47;
; 0000 0134     mvx += px;
; 0000 0135     servo[19] = mvx;
; 0000 0136     if(mvx >= 2300)mvx = 2300;
	BRLT _0xF6
	LDI  R30,LOW(2300)
	LDI  R31,HIGH(2300)
	RJMP _0x267
; 0000 0137     else if (mvx <= 700)mvx = 700;
_0xF6:
	CALL SUBOPT_0x50
	BRGE _0xF8
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
_0x267:
	STS  _mvx,R30
	STS  _mvx+1,R31
; 0000 0138 
; 0000 0139 //-----------------------------------------//
; 0000 013A     errory = spy - pos_y;
_0xF8:
	CALL SUBOPT_0x51
; 0000 013B     py = errory/47;
; 0000 013C     mvy -= py;
; 0000 013D     servo[18] = mvy;
; 0000 013E     if(mvy >= 2300)mvy = 2300;
	CPI  R26,LOW(0x8FC)
	LDI  R30,HIGH(0x8FC)
	CPC  R27,R30
	BRLT _0xF9
	LDI  R30,LOW(2300)
	LDI  R31,HIGH(2300)
	RJMP _0x268
; 0000 013F     else if (mvy <= 1500)mvy = 1500;
_0xF9:
	LDS  R26,_mvy
	LDS  R27,_mvy+1
	CPI  R26,LOW(0x5DD)
	LDI  R30,HIGH(0x5DD)
	CPC  R27,R30
	BRGE _0xFB
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
_0x268:
	STS  _mvy,R30
	STS  _mvy+1,R31
; 0000 0140 
; 0000 0141     printf("pid servo\r\n");
_0xFB:
	__POINTW1FN _0x0,14
	CALL SUBOPT_0x52
; 0000 0142     if (Ball == 0 && pos_x <= 160) {hitungNgawur = delayNgawur; cariBola = 0; state = 1;}
	CALL SUBOPT_0x2A
	SBIW R26,0
	BRNE _0xFD
	CALL SUBOPT_0x4E
	CPI  R26,LOW(0xA1)
	LDI  R30,HIGH(0xA1)
	CPC  R27,R30
	BRLT _0xFE
_0xFD:
	RJMP _0xFC
_0xFE:
	CALL SUBOPT_0x53
	LDI  R30,LOW(0)
	STS  _cariBola,R30
	STS  _cariBola+1,R30
	CALL SUBOPT_0x4C
; 0000 0143     if (Ball == 0 && pos_x >= 160) {hitungNgawur = delayNgawur; cariBola = 1; state = 1;}
_0xFC:
	CALL SUBOPT_0x2A
	SBIW R26,0
	BRNE _0x100
	CALL SUBOPT_0x4E
	CPI  R26,LOW(0xA0)
	LDI  R30,HIGH(0xA0)
	CPC  R27,R30
	BRGE _0x101
_0x100:
	RJMP _0xFF
_0x101:
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x4C
; 0000 0144     if (Ball >= 5 && pos_x >= 50 && pos_x <= 280) {jalan = 1;  state = 3;}
_0xFF:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x103
	CALL SUBOPT_0x4E
	SBIW R26,50
	BRLT _0x103
	CALL SUBOPT_0x55
	BRLT _0x104
_0x103:
	RJMP _0x102
_0x104:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
; 0000 0145     if (Ball >= 5 && pos_x <= 25 ) {jalan = 0; state = 3;}
_0x102:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x106
	CALL SUBOPT_0x4E
	SBIW R26,26
	BRLT _0x107
_0x106:
	RJMP _0x105
_0x107:
	LDI  R30,LOW(0)
	STS  _jalan,R30
	STS  _jalan+1,R30
	CALL SUBOPT_0x57
; 0000 0146     if (Ball >= 5 && pos_x >= 280) {jalan = 2; state = 3;}
_0x105:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x109
	CALL SUBOPT_0x4E
	CPI  R26,LOW(0x118)
	LDI  R30,HIGH(0x118)
	CPC  R27,R30
	BRGE _0x10A
_0x109:
	RJMP _0x108
_0x10A:
	CALL SUBOPT_0x58
	CALL SUBOPT_0x57
; 0000 0147 
; 0000 0148 }
_0x108:
	RET
;
;void nek_ambruk(){
; 0000 014A void nek_ambruk(){
_nek_ambruk:
; 0000 014B 
; 0000 014C     if(miringDepan <= -40){ printf("Ambruk depan  %d\r\n",miringDepan); state = 13;}            // bangun tengkurap
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5A
	BRLT _0x10B
	__POINTW1FN _0x0,26
	RJMP _0x269
; 0000 014D     else if(miringDepan >= 40){ printf("Ambruk belakang  %d\r\n",miringDepan); state = 13;}   // bangun terlentang
_0x10B:
	CALL SUBOPT_0x59
	SBIW R26,40
	BRLT _0x10D
	__POINTW1FN _0x0,45
_0x269:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5B
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CALL SUBOPT_0x5C
; 0000 014E 
; 0000 014F }
_0x10D:
	RET
;
;void cek_ambruk(){
; 0000 0151 void cek_ambruk(){
_cek_ambruk:
; 0000 0152 
; 0000 0153     if(miringDepan <= -40 ){sudah = 0; printf("cek Ambruk depan %d\r\n",miringDepan); TIMSK1=0x07; state = 10;}         // bangun tengkurap
	CALL SUBOPT_0x5D
	BRLT _0x10E
	CALL SUBOPT_0x5E
	__POINTW1FN _0x0,67
	CALL SUBOPT_0x5F
	LDI  R30,LOW(7)
	STS  111,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x5C
; 0000 0154     if(miringDepan >= 40){ sudah = 0; printf("cek Ambruk belakang %d\r\n",miringDepan); TIMSK1=0x07; state = 11;}   // bangun terlentang
_0x10E:
	CALL SUBOPT_0x59
	SBIW R26,40
	BRLT _0x10F
	CALL SUBOPT_0x5E
	__POINTW1FN _0x0,89
	CALL SUBOPT_0x5F
	LDI  R30,LOW(7)
	STS  111,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x5C
; 0000 0155 }
_0x10F:
	RET
;
;void bangun_depan(){
; 0000 0157 void bangun_depan(){
_bangun_depan:
; 0000 0158     durung:
_0x110:
; 0000 0159 
; 0000 015A         printf("proses bangun depan %d\r\n",miringDepan);
	__POINTW1FN _0x0,114
	CALL SUBOPT_0x5F
; 0000 015B         bangun_tengkurap();
	RCALL _bangun_tengkurap
; 0000 015C         if(sudah == 1 && miringDepan <= 30) {kondisiAmbrukDepan = 1; goto wes;}
	CALL SUBOPT_0x60
	BRNE _0x112
	CALL SUBOPT_0x59
	SBIW R26,31
	BRLT _0x113
_0x112:
	RJMP _0x111
_0x113:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _kondisiAmbrukDepan,R30
	STS  _kondisiAmbrukDepan+1,R31
	RJMP _0x114
; 0000 015D         if((sudah == 1 && miringDepan >= 30) || (sudah == 1 && miringDepan <= -40 )) {kondisiAmbrukDepan = 0; goto wes;}
_0x111:
	CALL SUBOPT_0x60
	BRNE _0x116
	CALL SUBOPT_0x59
	SBIW R26,30
	BRGE _0x118
_0x116:
	CALL SUBOPT_0x60
	BRNE _0x119
	CALL SUBOPT_0x5D
	BRGE _0x118
_0x119:
	RJMP _0x115
_0x118:
	LDI  R30,LOW(0)
	STS  _kondisiAmbrukDepan,R30
	STS  _kondisiAmbrukDepan+1,R30
	RJMP _0x114
; 0000 015E     goto durung;
_0x115:
	RJMP _0x110
; 0000 015F 
; 0000 0160     wes:
_0x114:
; 0000 0161         printf("wes\r\n");
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x52
; 0000 0162         tango = 0;
	CLR  R9
	CLR  R10
; 0000 0163         if(kondisiAmbrukDepan == 1){hitungNgawur = delayNgawur; state = 1;}
	LDS  R26,_kondisiAmbrukDepan
	LDS  R27,_kondisiAmbrukDepan+1
	SBIW R26,1
	BRNE _0x11C
	CALL SUBOPT_0x53
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x26A
; 0000 0164         else {sudah = 0; state = 12;}
_0x11C:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
_0x26A:
	STS  _state,R30
	STS  _state+1,R31
; 0000 0165 }
	RET
;
;void bangun_belakang(){
; 0000 0167 void bangun_belakang(){
_bangun_belakang:
; 0000 0168     durung:
_0x11E:
; 0000 0169 
; 0000 016A         printf("proses bangun belakang %d\r\n",miringDepan);
	__POINTW1FN _0x0,145
	CALL SUBOPT_0x5F
; 0000 016B         bangun_telentang();
	RCALL _bangun_telentang
; 0000 016C         if(sudah == 1 && miringDepan <= 30) {kondisiAmbrukBelakang = 1; goto wes;}
	CALL SUBOPT_0x60
	BRNE _0x120
	CALL SUBOPT_0x59
	SBIW R26,31
	BRLT _0x121
_0x120:
	RJMP _0x11F
_0x121:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _kondisiAmbrukBelakang,R30
	STS  _kondisiAmbrukBelakang+1,R31
	RJMP _0x122
; 0000 016D         if((sudah == 1 && miringDepan >= 30) || (sudah == 1 && miringDepan <= -40)) {kondisiAmbrukBelakang = 0; goto wes;}
_0x11F:
	CALL SUBOPT_0x60
	BRNE _0x124
	CALL SUBOPT_0x59
	SBIW R26,30
	BRGE _0x126
_0x124:
	CALL SUBOPT_0x60
	BRNE _0x127
	CALL SUBOPT_0x5D
	BRGE _0x126
_0x127:
	RJMP _0x123
_0x126:
	LDI  R30,LOW(0)
	STS  _kondisiAmbrukBelakang,R30
	STS  _kondisiAmbrukBelakang+1,R30
	RJMP _0x122
; 0000 016E     goto durung;
_0x123:
	RJMP _0x11E
; 0000 016F 
; 0000 0170     wes:
_0x122:
; 0000 0171         printf("Wes cok\r\n");
	__POINTW1FN _0x0,173
	CALL SUBOPT_0x52
; 0000 0172         tangi = 0;
	CLR  R11
	CLR  R12
; 0000 0173         if(kondisiAmbrukBelakang == 1){hitungNgawur = delayNgawur; state = 1;}
	LDS  R26,_kondisiAmbrukBelakang
	LDS  R27,_kondisiAmbrukBelakang+1
	SBIW R26,1
	BRNE _0x12A
	CALL SUBOPT_0x53
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x26B
; 0000 0174         else {sudah = 0; state = 12;}
_0x12A:
	CALL SUBOPT_0x5E
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
_0x26B:
	STS  _state,R30
	STS  _state+1,R31
; 0000 0175 
; 0000 0176 
; 0000 0177 }
	RET
;
;void berjalan(){    //state = 3
; 0000 0179 void berjalan(){
_berjalan:
; 0000 017A     switch(jalan){
	LDS  R30,_jalan
	LDS  R31,_jalan+1
; 0000 017B      case 0:  //diam
	SBIW R30,0
	BRNE _0x12F
; 0000 017C         nek_ambruk();
	RCALL _nek_ambruk
; 0000 017D         serong_kiri();
	RCALL _serong_kiri
; 0000 017E         pid_servo();
	CALL SUBOPT_0x61
; 0000 017F         if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] <= 1700) {jalan = 1; servo[19] = 1500;} // nek wes neng ngarep
	BRLT _0x131
	CALL SUBOPT_0x4E
	SBIW R26,50
	BRLT _0x131
	CALL SUBOPT_0x55
	BRGE _0x131
	CALL SUBOPT_0x62
	CPI  R26,LOW(0x6A5)
	LDI  R30,HIGH(0x6A5)
	CPC  R27,R30
	BRLT _0x132
_0x131:
	RJMP _0x130
_0x132:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x63
; 0000 0180         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;} // nek ra ndetek neng cari bola
_0x130:
	CALL SUBOPT_0x64
	BRNE _0x133
	CALL SUBOPT_0x53
	CALL SUBOPT_0x4C
	RJMP _0x12E
; 0000 0181         printf("%d serong kiri bos\r\n",servo[18]);
_0x133:
	__POINTW1FN _0x0,183
	RJMP _0x26C
; 0000 0182      break;
; 0000 0183 
; 0000 0184      case 1:   //maju
_0x12F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x134
; 0000 0185         nek_ambruk();
	RCALL _nek_ambruk
; 0000 0186         maju();
	RCALL _maju
; 0000 0187         pid_servo_mon();
	RCALL _pid_servo_mon
; 0000 0188         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
	CALL SUBOPT_0x64
	BRNE _0x135
	CALL SUBOPT_0x53
	CALL SUBOPT_0x4C
	RJMP _0x12E
; 0000 0189         if(servo[19] >= 1800){jalan = 0;}
_0x135:
	CALL SUBOPT_0x62
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	BRLT _0x136
	LDI  R30,LOW(0)
	STS  _jalan,R30
	STS  _jalan+1,R30
; 0000 018A         if(servo[19] <= 1200){jalan = 2;}
_0x136:
	CALL SUBOPT_0x62
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRGE _0x137
	CALL SUBOPT_0x58
; 0000 018B         printf("%d maju jalan\r\n",servo[18]);
_0x137:
	__POINTW1FN _0x0,204
	RJMP _0x26C
; 0000 018C      break;
; 0000 018D 
; 0000 018E      case 2:    //rotasi kanan
_0x134:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x138
; 0000 018F         nek_ambruk();
	RCALL _nek_ambruk
; 0000 0190         rotasi_kanan();
	RCALL _rotasi_kanan
; 0000 0191         pid_servo();
	CALL SUBOPT_0x61
; 0000 0192         if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] >= 1300) {jalan = 1; servo[19] = 1500;}
	BRLT _0x13A
	CALL SUBOPT_0x4E
	SBIW R26,50
	BRLT _0x13A
	CALL SUBOPT_0x55
	BRGE _0x13A
	CALL SUBOPT_0x62
	CPI  R26,LOW(0x514)
	LDI  R30,HIGH(0x514)
	CPC  R27,R30
	BRGE _0x13B
_0x13A:
	RJMP _0x139
_0x13B:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x63
; 0000 0193         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
_0x139:
	CALL SUBOPT_0x64
	BRNE _0x13C
	CALL SUBOPT_0x53
	CALL SUBOPT_0x4C
	RJMP _0x12E
; 0000 0194         printf("%d serong kanan\r\n",servo[18]);
_0x13C:
	RJMP _0x26D
; 0000 0195      break;
; 0000 0196 
; 0000 0197      case 3:   //rotasi kiri
_0x138:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0198         nek_ambruk();
	RCALL _nek_ambruk
; 0000 0199         rotasi_kiri();
	RCALL _rotasi_kiri
; 0000 019A         pid_servo();
	CALL SUBOPT_0x61
; 0000 019B         if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] >= 1300) {jalan = 1; servo[19] = 1500;}
	BRLT _0x13F
	CALL SUBOPT_0x4E
	SBIW R26,50
	BRLT _0x13F
	CALL SUBOPT_0x55
	BRGE _0x13F
	CALL SUBOPT_0x62
	CPI  R26,LOW(0x514)
	LDI  R30,HIGH(0x514)
	CPC  R27,R30
	BRGE _0x140
_0x13F:
	RJMP _0x13E
_0x140:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x63
; 0000 019C         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
_0x13E:
	CALL SUBOPT_0x64
	BRNE _0x141
	CALL SUBOPT_0x53
	CALL SUBOPT_0x4C
	RJMP _0x12E
; 0000 019D         printf("%d serong kanan\r\n",servo[18]);
_0x141:
_0x26D:
	__POINTW1FN _0x0,220
_0x26C:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x4D
; 0000 019E      break;
; 0000 019F 
; 0000 01A0 
; 0000 01A1 
; 0000 01A2     }
_0x12E:
; 0000 01A3 
; 0000 01A4 }
	RET
;
;void cari_bola(){//         state = 1
; 0000 01A6 void cari_bola(){
_cari_bola:
; 0000 01A7     switch(cariBola){
	LDS  R30,_cariBola
	LDS  R31,_cariBola+1
; 0000 01A8     case 0:
	SBIW R30,0
	BRNE _0x145
; 0000 01A9         nek_ambruk();
	CALL SUBOPT_0x65
; 0000 01AA         if(servo[18] >= 1800) servo[18] = 1500;
	BRLT _0x146
	CALL SUBOPT_0x66
; 0000 01AB         printf("cari bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);
_0x146:
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
; 0000 01AC         servo[19]+=1;
	ADIW R30,1
	CALL SUBOPT_0x6B
; 0000 01AD         if(servo[19] >= 2300) cariBola = 1;
	CPI  R26,LOW(0x8FC)
	LDI  R30,HIGH(0x8FC)
	CPC  R27,R30
	BRLT _0x147
	CALL SUBOPT_0x54
; 0000 01AE         if(Ball >= 5 ) {mvx = servo[19]; mvy = servo[18]; state = 2;}
_0x147:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x148
	CALL SUBOPT_0x26
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 01AF         if(hitungNgawur <= 0){hitungWaras = delayWaras; state = 101;}
_0x148:
	CALL SUBOPT_0x27
	BRLT _0x149
	CALL SUBOPT_0x6E
; 0000 01B0 
; 0000 01B1 
; 0000 01B2      break;
_0x149:
	RJMP _0x144
; 0000 01B3 
; 0000 01B4      case 1:
_0x145:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x144
; 0000 01B5         nek_ambruk();
	CALL SUBOPT_0x65
; 0000 01B6         if(servo[18] < 1800) servo[18] = 1800;
	BRGE _0x14B
	__POINTW1MN _servo,36
	CALL SUBOPT_0x6F
; 0000 01B7         printf("cari bola %d %d == %d\r\n",miringDepan, servo[19], hitungNgawur);
_0x14B:
	__POINTW1FN _0x0,263
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
; 0000 01B8         servo[19]-=1;
	SBIW R30,1
	CALL SUBOPT_0x6B
; 0000 01B9         if(servo[19] <= 700)cariBola = 0;
	CPI  R26,LOW(0x2BD)
	LDI  R30,HIGH(0x2BD)
	CPC  R27,R30
	BRGE _0x14C
	LDI  R30,LOW(0)
	STS  _cariBola,R30
	STS  _cariBola+1,R30
; 0000 01BA         if(Ball >= 5 ) {mvx = servo[19]; mvy = servo[18]; state = 2;}
_0x14C:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x14D
	CALL SUBOPT_0x26
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 01BB         if(hitungNgawur <= 0){hitungWaras = delayWaras; state = 101;}
_0x14D:
	CALL SUBOPT_0x27
	BRLT _0x14E
	CALL SUBOPT_0x6E
; 0000 01BC 
; 0000 01BD 
; 0000 01BE      break;
_0x14E:
; 0000 01BF     }
_0x144:
; 0000 01C0     siap();
	RCALL _siap
; 0000 01C1 
; 0000 01C2 }
	RET
;
;void ngitung(){
; 0000 01C4 void ngitung(){
; 0000 01C5     hitung = 600;
; 0000 01C6     jalan = 1;
; 0000 01C7     state = 3;
; 0000 01C8 }
;
;void ngawur(){
; 0000 01CA void ngawur(){
_ngawur:
; 0000 01CB     nek_ambruk();
	RCALL _nek_ambruk
; 0000 01CC     maju();
	RCALL _maju
; 0000 01CD     servo[18] = 1500;
	CALL SUBOPT_0x66
; 0000 01CE     servo[19] = 1500;
	CALL SUBOPT_0x63
; 0000 01CF     if(hitungWaras <= 0) {hitungNgawur = delayNgawur; state = 1;}
	CALL SUBOPT_0x28
	BRLT _0x14F
	CALL SUBOPT_0x53
	CALL SUBOPT_0x4C
; 0000 01D0     if(Ball >= 5){mvx = servo[19]; mvy = servo[18]; state = 2;}
_0x14F:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x150
	CALL SUBOPT_0x26
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 01D1     printf("Aku Ngawur %d - %d\r\n",miringDepan, hitungWaras);
_0x150:
	__POINTW1FN _0x0,287
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	CALL SUBOPT_0x68
	LDS  R30,_hitungWaras
	LDS  R31,_hitungWaras+1
	CALL SUBOPT_0x68
	LDI  R24,8
	CALL _printf
	ADIW R28,10
; 0000 01D2 }
	RET
;
;void pid_servo_mon(){ //
; 0000 01D4 void pid_servo_mon(){
_pid_servo_mon:
; 0000 01D5 
; 0000 01D6     errorx = spx - pos_x;
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
; 0000 01D7     px = errorx/47;
; 0000 01D8     mvx += px;
; 0000 01D9     servo[19] = mvx;
; 0000 01DA     if(mvx >= 2300)mvx = 2300;
	BRLT _0x151
	LDI  R30,LOW(2300)
	LDI  R31,HIGH(2300)
	RJMP _0x26E
; 0000 01DB     else if (mvx <= 700)mvx = 700;
_0x151:
	CALL SUBOPT_0x50
	BRGE _0x153
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
_0x26E:
	STS  _mvx,R30
	STS  _mvx+1,R31
; 0000 01DC 
; 0000 01DD     errory = spy - pos_y;
_0x153:
	CALL SUBOPT_0x51
; 0000 01DE     py = errory/47;
; 0000 01DF     mvy -= py;
; 0000 01E0     servo[18] = mvy;
; 0000 01E1     if(mvy <= 1000)mvy = 1000;
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRGE _0x154
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP _0x26F
; 0000 01E2     else if (mvy >= 2300)mvy = 2300;
_0x154:
	LDS  R26,_mvy
	LDS  R27,_mvy+1
	CPI  R26,LOW(0x8FC)
	LDI  R30,HIGH(0x8FC)
	CPC  R27,R30
	BRLT _0x156
	LDI  R30,LOW(2300)
	LDI  R31,HIGH(2300)
_0x26F:
	STS  _mvy,R30
	STS  _mvy+1,R31
; 0000 01E3 
; 0000 01E4 }
_0x156:
	RET
;
;void siap()
; 0000 01E7   {
_siap:
; 0000 01E8 
; 0000 01E9    //tangan kanan
; 0000 01EA     servo[14] = 1350; //R3 - CW
	__POINTW1MN _servo,28
	LDI  R26,LOW(1350)
	LDI  R27,HIGH(1350)
	CALL SUBOPT_0x70
; 0000 01EB     servo[13] = 900; //R2 - turun
; 0000 01EC     servo[12] = 1900; //R1 - mundur
; 0000 01ED     //tangan kiri
; 0000 01EE     servo[17]  = 1650; //L3 - CW
	LDI  R26,LOW(1650)
	LDI  R27,HIGH(1650)
	CALL SUBOPT_0x71
; 0000 01EF     servo[16]  = 2050; //L2 - naik
; 0000 01F0     servo[15]  = 1100; //L1 - maju
; 0000 01F1     switch(0)
; 0000 01F2         {
; 0000 01F3            case 0 :     //gait  mlaku
	BRNE _0x159
; 0000 01F4                 VY=10;
	CALL SUBOPT_0x72
; 0000 01F5                 if(counterDelay<=0)
	BRLT _0x15B
; 0000 01F6                 {
; 0000 01F7                     switch(countTick)
	__GETW1R 13,14
; 0000 01F8                     {
; 0000 01F9                        case 0:
	SBIW R30,0
	BRNE _0x15E
; 0000 01FA                        servoInitError[7]=40;
	__POINTW1MN _servoInitError,14
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 01FB                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x16
; 0000 01FC                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 01FD                             InputXYZ();
	RCALL _InputXYZ
; 0000 01FE                         break;
; 0000 01FF                     }
_0x15E:
; 0000 0200                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0x161
	CALL SUBOPT_0x73
	BREQ _0x160
_0x161:
; 0000 0201                     {
; 0000 0202                         countTick++;
	CALL SUBOPT_0x74
; 0000 0203                         if(countTick>0)
	CLR  R0
	CP   R0,R13
	CPC  R0,R14
	BRGE _0x163
; 0000 0204                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 0205                     }
_0x163:
; 0000 0206                     else
	RJMP _0x164
_0x160:
; 0000 0207                     {
; 0000 0208                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0209                     }
_0x164:
; 0000 020A 
; 0000 020B                     counterDelay=75; //3000
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	CALL SUBOPT_0x75
; 0000 020C                 }
; 0000 020D             break;
_0x15B:
; 0000 020E         }
_0x159:
; 0000 020F 
; 0000 0210         speed=1; //10
	CALL SUBOPT_0x76
; 0000 0211         if(counterTG>speed)
	BRGE _0x165
; 0000 0212         {
; 0000 0213             counterTG=0;
	CALL SUBOPT_0x77
; 0000 0214             taskGerakan();
; 0000 0215         }
; 0000 0216   }
_0x165:
	RET
;
;
;void goal()
; 0000 021A  {
; 0000 021B       de = 100;
; 0000 021C       switch(tangi)
; 0000 021D       {
; 0000 021E        case 0:
; 0000 021F             servo[14] = 1800; //R3 - CW
; 0000 0220             servo[13] = 900; //R2 - turun
; 0000 0221             servo[12] = 1900; //R1 - mundur
; 0000 0222             //tangan kiri
; 0000 0223             servo[17]  = 1200; //L3 - CW
; 0000 0224             servo[16]  = 2050; //L2 - naik
; 0000 0225             servo[15]  = 1100; //L1 - maju
; 0000 0226             //kaki kanan
; 0000 0227             servo[5] = 800 + (7.7777* 90); //pinggul ra enek
; 0000 0228             servo[4] = 1520; //R5 - kiri
; 0000 0229             servo[3] = 1136; //R4 - maju
; 0000 022A             servo[2] = 1931; //R3 - maju
; 0000 022B             servo[1] = 1289; //R2 - maju
; 0000 022C             servo[0] = 1500; //R1 - kiri
; 0000 022D             //kaki kiri
; 0000 022E             servo[11] = 1500 + (7.7777* 90); //pinggul  ra enek
; 0000 022F             servo[10] = 1500; //L5 - kanan
; 0000 0230             servo[9]  = 1136; //L4 - maju    984
; 0000 0231             servo[8]  = 1931; //L3 - maju
; 0000 0232             servo[7]  = 1289; //L2 - maju
; 0000 0233             servo[6]  = 1500; //L1 - kanan
; 0000 0234             tangi=1;
; 0000 0235             delay_ms(3000);
; 0000 0236        break;
; 0000 0237 
; 0000 0238        case 1:
; 0000 0239             servo[14] = 1800; //R3 - CW
; 0000 023A             servo[13] = 900; //R2 - turun
; 0000 023B             servo[12] = 1900; //R1 - mundur
; 0000 023C             //tangan kiri
; 0000 023D             servo[17]  = 1200; //L3 - CW
; 0000 023E             servo[16]  = 2050; //L2 - naik
; 0000 023F             servo[15]  = 1100; //L1 - maju
; 0000 0240             //kaki kanan
; 0000 0241             servo[5] = 800 + (7.7777* 90); //pinggul ra enek
; 0000 0242             servo[4] = 1587; //R5 - kiri
; 0000 0243             servo[3] = 1136; //R4 - maju
; 0000 0244             servo[2] = 1931; //R3 - maju
; 0000 0245             servo[1] = 1289; //R2 - maju
; 0000 0246             servo[0] = 1567; //R1 - kiri
; 0000 0247             //kaki kiri
; 0000 0248             servo[11] = 1500 + (7.7777* 90); //pinggul  ra enek
; 0000 0249             servo[10] = 1453; //L5 - kanan
; 0000 024A             servo[9]  = 1136; //L4 - maju    984
; 0000 024B             servo[8]  = 1931; //L3 - maju
; 0000 024C             servo[7]  = 1289; //L2 - maju
; 0000 024D             servo[6]  = 1453; //L1 - kanan
; 0000 024E             tangi=2;
; 0000 024F             delay_ms(de);
; 0000 0250        break;
; 0000 0251 
; 0000 0252        case 2:
; 0000 0253             //tangan kanan
; 0000 0254             servo[14] = 1800; //R3 - CW
; 0000 0255             servo[13] = 900; //R2 - turun
; 0000 0256             servo[12] = 1900; //R1 - mundur
; 0000 0257             //tangan kiri
; 0000 0258             servo[17]  = 1200; //L3 - CW
; 0000 0259             servo[16]  = 1500; //L2 - naik
; 0000 025A             servo[15]  = 1100; //L1 - maju
; 0000 025B             //kaki kanan
; 0000 025C             servo[5] = 800 + (7.7777* 90); //pinggul ra enek
; 0000 025D             servo[4] = 1587; //R5 - kiri
; 0000 025E             servo[3] = 1138; //R4 - maju
; 0000 025F             servo[2] = 1842; //R3 - maju
; 0000 0260             servo[1] = 1219; //R2 - maju
; 0000 0261             servo[0] = 1567; //R1 - kiri
; 0000 0262             //kaki kiri
; 0000 0263             servo[11] = 1500 + (7.7777* 90); //pinggul  ra enek
; 0000 0264             servo[10] = 1453; //L5 - kanan
; 0000 0265             servo[9]  = 1381; //L4 - maju    984
; 0000 0266             servo[8]  = 1802; //L3 - maju
; 0000 0267             servo[7]  = 1212; //L2 - maju
; 0000 0268             servo[6]  = 1453; //L1 - kanan
; 0000 0269             tangi=2;
; 0000 026A             delay_ms(de);
; 0000 026B        break;
; 0000 026C       }
; 0000 026D  }
;
;void dor(){
; 0000 026F void dor(){
; 0000 0270     langkahMax=1;
; 0000 0271     //tangan kanan
; 0000 0272     servo[14] = 1800; //R3 - CW
; 0000 0273     servo[13] = 900; //R2 - turun
; 0000 0274     servo[12] = 1900; //R1 - mundur
; 0000 0275     //tangan kiri
; 0000 0276     servo[17]  = 1200; //L3 - CW
; 0000 0277     servo[16]  = 2050; //L2 - naik
; 0000 0278     servo[15]  = 1100; //L1 - maju
; 0000 0279     switch(0)
; 0000 027A         {
; 0000 027B            case 0 :     //gait  mlaku
; 0000 027C                 VY=10;
; 0000 027D                 if(counterDelay<=0)
; 0000 027E                 {
; 0000 027F                     switch(countTick)
; 0000 0280                     {
; 0000 0281                        case 0:
; 0000 0282                        langkahMax=1;
; 0000 0283                             X[0]=-90; Y[0]=0; Z[0]=-20;
; 0000 0284                             X[1]=70; Y[1]=-40; Z[1]=-50;
; 0000 0285                             InputXYZ();
; 0000 0286                         break;
; 0000 0287                         case 1:
; 0000 0288                         langkahMax=1;
; 0000 0289                             X[0]=-90; Y[0]=0; Z[0]=-20;
; 0000 028A                             X[1]=70; Y[1]=40; Z[1]=-50;
; 0000 028B                             InputXYZ();
; 0000 028C                         break;
; 0000 028D                         case 2:
; 0000 028E                         langkahMax=1;
; 0000 028F                             X[0]=0; Y[0]=0; Z[0]=-20;
; 0000 0290                             X[1]=0; Y[1]=0; Z[1]=-20;
; 0000 0291                             InputXYZ();
; 0000 0292                         break;
; 0000 0293                     }
; 0000 0294                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 0295                     {
; 0000 0296                         countTick++;
; 0000 0297                         if(countTick>2)
; 0000 0298                            countTick=2;     //2
; 0000 0299                     }
; 0000 029A                     else
; 0000 029B                     {
; 0000 029C                         countTick=0;
; 0000 029D                     }
; 0000 029E 
; 0000 029F                     counterDelay=120; //65 80
; 0000 02A0                 }
; 0000 02A1             break;
; 0000 02A2         }
; 0000 02A3 
; 0000 02A4         speed=1; //10
; 0000 02A5         if(counterTG>speed)
; 0000 02A6         {
; 0000 02A7             counterTG=0;
; 0000 02A8             taskGerakan();
; 0000 02A9         }
; 0000 02AA }
;
;void tendang(){
; 0000 02AC void tendang(){
; 0000 02AD     langkahMax=40;
; 0000 02AE     //tangan kanan
; 0000 02AF     servo[14] = 1800; //R3 - CW
; 0000 02B0     servo[13] = 900; //R2 - turun
; 0000 02B1     servo[12] = 1900; //R1 - mundur
; 0000 02B2     //tangan kiri
; 0000 02B3     servo[17]  = 1300; //L3 - CW
; 0000 02B4     servo[16]  = 2100; //L2 - naik
; 0000 02B5     servo[15]  = 1100; //L1 - maju
; 0000 02B6     switch(0)
; 0000 02B7         {
; 0000 02B8            case 0 :     //gait  mlaku
; 0000 02B9                 VY=45;   //40 42
; 0000 02BA                 VZ=30;   //25
; 0000 02BB                 if(counterDelay<=0)
; 0000 02BC                 {
; 0000 02BD                     switch(countTick)
; 0000 02BE                     {
; 0000 02BF                        case 0:
; 0000 02C0                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 02C1                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 02C2                             InputXYZ();
; 0000 02C3                         break;
; 0000 02C4 //                        case 1:
; 0000 02C5 //                        servoInitError[6]=250;
; 0000 02C6 //                            X[0]=-VY; Y[0]=0; Z[0]=0;
; 0000 02C7 //                            X[1]=VY; Y[1]=0; Z[1]=-VZ;
; 0000 02C8 //                            InputXYZ();
; 0000 02C9 //                        break;
; 0000 02CA                         case 1:
; 0000 02CB                         servoInitError[6]=300;      //250
; 0000 02CC                         servoInitError[14]=-600;
; 0000 02CD                         servoInitError[13]=600;
; 0000 02CE                         //servoInitError[17]=600;
; 0000 02CF                             X[0]=-VY-5; Y[0]=0; Z[0]=0;
; 0000 02D0                             X[1]=VY; Y[1]=0; Z[1]=-VZ;
; 0000 02D1                             InputXYZ();
; 0000 02D2                         break;
; 0000 02D3                         case 2:
; 0000 02D4                         servoInitError[6]=300;
; 0000 02D5                         servoInitError[9]=-250;
; 0000 02D6                         servoInitError[8]=-250;
; 0000 02D7                         servoInitError[7]=500;
; 0000 02D8                             X[0]=-VY-5; Y[0]=0; Z[0]=0;
; 0000 02D9                             X[1]=VY; Y[1]=0; Z[1]=-VZ-20;
; 0000 02DA                             InputXYZ();
; 0000 02DB                         break;
; 0000 02DC                         case 3:
; 0000 02DD                         servoInitError[6]=0;
; 0000 02DE                         servoInitError[9]=0;
; 0000 02DF                         servoInitError[8]=0;
; 0000 02E0                         servoInitError[7]=0;
; 0000 02E1                         servoInitError[14]=0;
; 0000 02E2                         servoInitError[13]=0;
; 0000 02E3                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 02E4                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 02E5                             InputXYZ();
; 0000 02E6                         break;
; 0000 02E7                         case 5:
; 0000 02E8                         langkahMax=1;
; 0000 02E9                             X[0]=0; Y[0]=0; Z[0]=-20;
; 0000 02EA                             X[1]=0; Y[1]=0; Z[1]=-20;
; 0000 02EB                             InputXYZ();
; 0000 02EC                         break;
; 0000 02ED                     }
; 0000 02EE                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 02EF                     {
; 0000 02F0                         countTick++;
; 0000 02F1                         if(countTick>3)
; 0000 02F2                            countTick=3;     //2
; 0000 02F3                     }
; 0000 02F4                     else
; 0000 02F5                     {
; 0000 02F6                         countTick=0;
; 0000 02F7                     }
; 0000 02F8 
; 0000 02F9                     counterDelay=500; //500
; 0000 02FA                 }
; 0000 02FB             break;
; 0000 02FC         }
; 0000 02FD 
; 0000 02FE         speed=1; //10
; 0000 02FF         if(counterTG>speed)
; 0000 0300         {
; 0000 0301             counterTG=0;
; 0000 0302             taskGerakan();
; 0000 0303         }
; 0000 0304 }
;
;void geser_kiri(){
; 0000 0306 void geser_kiri(){
; 0000 0307     //tangan kanan
; 0000 0308     servo[14] = 1800; //R3 - CW
; 0000 0309     servo[13] = 900; //R2 - turun
; 0000 030A     servo[12] = 1900; //R1 - mundur
; 0000 030B     //tangan kiri
; 0000 030C     servo[17]  = 1200; //L3 - CW
; 0000 030D     servo[16]  = 2050; //L2 - naik
; 0000 030E     servo[15]  = 1100; //L1 - maju
; 0000 030F     switch(0)
; 0000 0310         {
; 0000 0311            case 0 :     //gait  mlaku
; 0000 0312                 VY=10;
; 0000 0313                 if(counterDelay<=0)
; 0000 0314                 {
; 0000 0315                     switch(countTick)
; 0000 0316                     {
; 0000 0317                        case 0:
; 0000 0318                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0319                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 031A                             InputXYZ();
; 0000 031B                         break;
; 0000 031C                         case 1:
; 0000 031D                             X[0]=-10; Y[0]=0; Z[0]=0;
; 0000 031E                             X[1]=10; Y[1]=0; Z[1]=0;
; 0000 031F                             InputXYZ();
; 0000 0320                         break;
; 0000 0321                         case 2:
; 0000 0322                             X[0]=-10; Y[0]=0; Z[0]=0;
; 0000 0323                             X[1]=15; Y[1]=0; Z[1]=-40;
; 0000 0324                             InputXYZ();
; 0000 0325                         break;
; 0000 0326                         case 3:
; 0000 0327                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0328                             X[1]=15; Y[1]=0; Z[1]=0;
; 0000 0329                             InputXYZ();
; 0000 032A                         break;
; 0000 032B                         case 4:
; 0000 032C                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 032D                             X[1]=-15; Y[1]=0; Z[1]=0;
; 0000 032E                             InputXYZ();
; 0000 032F                         break;
; 0000 0330                         case 5:
; 0000 0331                             X[0]=0; Y[0]=-0; Z[0]=-40;
; 0000 0332                             X[1]=-15; Y[1]=0; Z[1]=0;
; 0000 0333                             InputXYZ();
; 0000 0334                         break;
; 0000 0335                         case 6:
; 0000 0336                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0337                             X[1]=-15; Y[1]=0; Z[1]=0;
; 0000 0338                             InputXYZ();
; 0000 0339                         break;
; 0000 033A                     }
; 0000 033B                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 033C                     {
; 0000 033D                         countTick++;
; 0000 033E                         if(countTick>6)
; 0000 033F                            countTick=0;     //2
; 0000 0340                     }
; 0000 0341                     else
; 0000 0342                     {
; 0000 0343                         countTick=0;
; 0000 0344                     }
; 0000 0345 
; 0000 0346                     counterDelay=80; //65 80
; 0000 0347                 }
; 0000 0348             break;
; 0000 0349         }
; 0000 034A 
; 0000 034B         speed=1; //10
; 0000 034C         if(counterTG>speed)
; 0000 034D         {
; 0000 034E             counterTG=0;
; 0000 034F             taskGerakan();
; 0000 0350         }
; 0000 0351 }
;
;void geser_kanan(){
; 0000 0353 void geser_kanan(){
; 0000 0354     //tangan kanan
; 0000 0355     servo[14] = 1600; //R3 - CW
; 0000 0356     servo[13] = 900; //R2 - turun
; 0000 0357     servo[12] = 1900; //R1 - mundur
; 0000 0358     //tangan kiri
; 0000 0359     servo[17]  = 1400; //L3 - CW
; 0000 035A     servo[16]  = 2050; //L2 - naik
; 0000 035B     servo[15]  = 1100; //L1 - maju
; 0000 035C     switch(0)
; 0000 035D         {
; 0000 035E            case 0 :     //gait  mlaku
; 0000 035F                 VY=10;
; 0000 0360                 if(counterDelay<=0)
; 0000 0361                 {
; 0000 0362                     switch(countTick)
; 0000 0363                     {
; 0000 0364                        case 0:
; 0000 0365                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0366                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0367                             InputXYZ();
; 0000 0368                         break;
; 0000 0369                         case 1:
; 0000 036A                             X[0]=10; Y[0]=0; Z[0]=0;
; 0000 036B                             X[1]=-10; Y[1]=0; Z[1]=0;
; 0000 036C                             InputXYZ();
; 0000 036D                         break;
; 0000 036E                         case 2:
; 0000 036F                             X[0]=15; Y[0]=-20; Z[0]=-30;
; 0000 0370                             X[1]=-10; Y[1]=0; Z[1]=0;
; 0000 0371                             InputXYZ();
; 0000 0372                         break;
; 0000 0373                         case 3:
; 0000 0374                             X[0]=15; Y[0]=-20; Z[0]=0;
; 0000 0375                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0376                             InputXYZ();
; 0000 0377                         break;
; 0000 0378                         case 4:
; 0000 0379                             X[0]=-15; Y[0]=-20; Z[0]=0;
; 0000 037A                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 037B                             InputXYZ();
; 0000 037C                         break;
; 0000 037D                         case 5:
; 0000 037E                             X[0]=-15; Y[0]=-20; Z[0]=0;
; 0000 037F                             X[1]=0; Y[1]=-15; Z[1]=-30;
; 0000 0380                             InputXYZ();
; 0000 0381                         break;
; 0000 0382                         case 6:
; 0000 0383                             X[0]=-15; Y[0]=-20; Z[0]=0;
; 0000 0384                             X[1]=0; Y[1]=-15; Z[1]=0;
; 0000 0385                             InputXYZ();
; 0000 0386                         break;
; 0000 0387                     }
; 0000 0388                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 0389                     {
; 0000 038A                         countTick++;
; 0000 038B                         if(countTick>6)
; 0000 038C                            countTick=0;     //2
; 0000 038D                     }
; 0000 038E                     else
; 0000 038F                     {
; 0000 0390                         countTick=0;
; 0000 0391                     }
; 0000 0392 
; 0000 0393                     counterDelay=80; //65 80
; 0000 0394                 }
; 0000 0395             break;
; 0000 0396         }
; 0000 0397 
; 0000 0398         speed=1; //10
; 0000 0399         if(counterTG>speed)
; 0000 039A         {
; 0000 039B             counterTG=0;
; 0000 039C             taskGerakan();
; 0000 039D         }
; 0000 039E }
;
;void serong_kiri(){
; 0000 03A0 void serong_kiri(){
_serong_kiri:
; 0000 03A1     //tangan kanan
; 0000 03A2     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x78
	CALL SUBOPT_0x70
; 0000 03A3     servo[13] = 900; //R2 - turun
; 0000 03A4     servo[12] = 1900; //R1 - mundur
; 0000 03A5     //tangan kiri
; 0000 03A6     servo[17]  = 1500; //L3 - CW
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL SUBOPT_0x71
; 0000 03A7     servo[16]  = 2050; //L2 - naik
; 0000 03A8     servo[15]  = 1100; //L1 - maju
; 0000 03A9     switch(0)
; 0000 03AA         {
; 0000 03AB            case 0 :     //gait  mlaku
	BREQ PC+3
	JMP _0x1BC
; 0000 03AC                 VY=10;
	CALL SUBOPT_0x72
; 0000 03AD                 if(counterDelay<=0)
	BRGE PC+3
	JMP _0x1BE
; 0000 03AE                 {
; 0000 03AF                     switch(countTick)
	__GETW1R 13,14
; 0000 03B0                     {
; 0000 03B1                        case 0:
	SBIW R30,0
	BRNE _0x1C2
; 0000 03B2                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x79
; 0000 03B3                             X[1]=0; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
	RJMP _0x27B
; 0000 03B4                             InputXYZ();
; 0000 03B5                         break;
; 0000 03B6                         case 1:
_0x1C2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1C3
; 0000 03B7                             X[0]=-10; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7C
; 0000 03B8                             X[1]=10; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7B
	RJMP _0x27B
; 0000 03B9                             InputXYZ();
; 0000 03BA                         break;
; 0000 03BB                         case 2:
_0x1C3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1C4
; 0000 03BC                             X[0]=-10; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7C
; 0000 03BD                             X[1]=15; Y[1]=-10; Z[1]=-40;
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x14
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
	RJMP _0x27C
; 0000 03BE                             InputXYZ();
; 0000 03BF                         break;
; 0000 03C0                         case 3:
_0x1C4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1C5
; 0000 03C1                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x79
; 0000 03C2                             X[1]=15; Y[1]=-10; Z[1]=0;
	CALL SUBOPT_0x7E
	RJMP _0x27D
; 0000 03C3                             InputXYZ();
; 0000 03C4                         break;
; 0000 03C5                         case 4:
_0x1C5:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C6
; 0000 03C6                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	RJMP _0x27E
; 0000 03C7                             X[1]=-15; Y[1]=-10; Z[1]=0;
; 0000 03C8                             InputXYZ();
; 0000 03C9                         break;
; 0000 03CA                         case 5:
_0x1C6:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1C7
; 0000 03CB                             X[0]=0; Y[0]=20; Z[0]=-40;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x84
	CALL SUBOPT_0x85
; 0000 03CC                             X[1]=-15; Y[1]=-10; Z[1]=0;
	RJMP _0x27F
; 0000 03CD                             InputXYZ();
; 0000 03CE                         break;
; 0000 03CF                         case 6:
_0x1C7:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1C1
; 0000 03D0                             X[0]=0; Y[0]=20; Z[0]=0;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x84
_0x27E:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x86
; 0000 03D1                             X[1]=-15; Y[1]=-10; Z[1]=0;
_0x27F:
	__POINTW1MN _X,4
	__GETD2N 0xC1700000
_0x27D:
	CALL __PUTDZ20
	CALL SUBOPT_0x7F
_0x27B:
	CALL __PUTDZ20
	__POINTW1MN _Z,4
	CALL SUBOPT_0x7A
_0x27C:
	CALL __PUTDZ20
; 0000 03D2                             InputXYZ();
	RCALL _InputXYZ
; 0000 03D3                         break;
; 0000 03D4                     }
_0x1C1:
; 0000 03D5                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0x1CA
	CALL SUBOPT_0x73
	BREQ _0x1C9
_0x1CA:
; 0000 03D6                     {
; 0000 03D7                         countTick++;
	CALL SUBOPT_0x74
; 0000 03D8                         if(countTick>6)
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x1CC
; 0000 03D9                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 03DA                     }
_0x1CC:
; 0000 03DB                     else
	RJMP _0x1CD
_0x1C9:
; 0000 03DC                     {
; 0000 03DD                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 03DE                     }
_0x1CD:
; 0000 03DF 
; 0000 03E0                     counterDelay=85; //65 80
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	CALL SUBOPT_0x75
; 0000 03E1                 }
; 0000 03E2             break;
_0x1BE:
; 0000 03E3         }
_0x1BC:
; 0000 03E4 
; 0000 03E5         speed=1; //10
	CALL SUBOPT_0x76
; 0000 03E6         if(counterTG>speed)
	BRGE _0x1CE
; 0000 03E7         {
; 0000 03E8             counterTG=0;
	CALL SUBOPT_0x77
; 0000 03E9             taskGerakan();
; 0000 03EA         }
; 0000 03EB }
_0x1CE:
	RET
;
;void serong_kanan(){
; 0000 03ED void serong_kanan(){
; 0000 03EE     //tangan kanan
; 0000 03EF     servo[14] = 1600; //R3 - CW
; 0000 03F0     servo[13] = 900; //R2 - turun
; 0000 03F1     servo[12] = 1900; //R1 - mundur
; 0000 03F2     //tangan kiri
; 0000 03F3     servo[17]  = 1500; //L3 - CW
; 0000 03F4     servo[16]  = 2050; //L2 - naik
; 0000 03F5     servo[15]  = 1100; //L1 - maju
; 0000 03F6     switch(0)
; 0000 03F7         {
; 0000 03F8            case 0 :     //gait  mlaku
; 0000 03F9                 VY=15;
; 0000 03FA                 if(counterDelay<=0)
; 0000 03FB                 {
; 0000 03FC                     switch(countTick)
; 0000 03FD                     {
; 0000 03FE                        case 0:
; 0000 03FF                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0400                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0401                             InputXYZ();
; 0000 0402                         break;
; 0000 0403                         case 1:
; 0000 0404                             X[0]=10; Y[0]=0; Z[0]=0;
; 0000 0405                             X[1]=-10; Y[1]=0; Z[1]=0;
; 0000 0406                             InputXYZ();
; 0000 0407                         break;
; 0000 0408                         case 2:
; 0000 0409                             X[0]=10; Y[0]=-10; Z[0]=-40;
; 0000 040A                             X[1]=-15; Y[1]=0; Z[1]=0;
; 0000 040B                             InputXYZ();
; 0000 040C                         break;
; 0000 040D                         case 3:
; 0000 040E                             X[0]=15; Y[0]=-10; Z[0]=0;
; 0000 040F                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0410                             InputXYZ();
; 0000 0411                         break;
; 0000 0412                         case 4:
; 0000 0413                             X[0]=-15; Y[0]=-10; Z[0]=0;
; 0000 0414                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0415                             InputXYZ();
; 0000 0416                         break;
; 0000 0417                         case 5:
; 0000 0418                             X[0]=-15; Y[0]=-10; Z[0]=0;
; 0000 0419                             X[1]=0; Y[1]=20; Z[1]=-40;
; 0000 041A                             InputXYZ();
; 0000 041B                         break;
; 0000 041C                         case 6:
; 0000 041D                             X[0]=-15; Y[0]=-10; Z[0]=0;
; 0000 041E                             X[1]=0; Y[1]=20; Z[1]=0;
; 0000 041F                             InputXYZ();
; 0000 0420                         break;
; 0000 0421                     }
; 0000 0422                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 0423                     {
; 0000 0424                         countTick++;
; 0000 0425                         if(countTick>6)
; 0000 0426                            countTick=0;     //2
; 0000 0427                     }
; 0000 0428                     else
; 0000 0429                     {
; 0000 042A                         countTick=0;
; 0000 042B                     }
; 0000 042C 
; 0000 042D                     counterDelay=80; //65 80
; 0000 042E                 }
; 0000 042F             break;
; 0000 0430         }
; 0000 0431 
; 0000 0432         speed=1; //10
; 0000 0433         if(counterTG>speed)
; 0000 0434         {
; 0000 0435             counterTG=0;
; 0000 0436             taskGerakan();
; 0000 0437         }
; 0000 0438 }
;
;void bangun_telentang()
; 0000 043B     {
_bangun_telentang:
; 0000 043C      int de  = 1000;
; 0000 043D      int lay = 50;
; 0000 043E      //tangi = 8;
; 0000 043F           switch(tangi)
	CALL SUBOPT_0x87
;	de -> R16,R17
;	lay -> R18,R19
	__GETW1R 11,12
; 0000 0440           {
; 0000 0441 
; 0000 0442            case 0:
	SBIW R30,0
	BRNE _0x1E7
; 0000 0443                     //ndas
; 0000 0444                     servo[18]  = 500; //L1 - maju
	CALL SUBOPT_0x88
; 0000 0445                     servo[19]  = 2000; //L2 - naik
; 0000 0446                     //kaki kanan
; 0000 0447                     servo[5] = 1500;
; 0000 0448                     servo[4] = 1500; //R5 - kiri
; 0000 0449                     servo[3] = 1500; //R4 - maju
; 0000 044A                     servo[2] = 1500; //R3 - maju
; 0000 044B                     servo[1] = 1500; //R2 - maju
; 0000 044C                     servo[0] = 1500; //R1 - kiri
; 0000 044D                     //kaki kiri
; 0000 044E                     servo[11] = 1500;
; 0000 044F                     servo[10] = 1500; //L5 - kanan
; 0000 0450                     servo[9]  = 1500; //L4 - maju    984
; 0000 0451                     servo[8]  = 1500; //L3 - maju
; 0000 0452                     servo[7]  = 1500; //L2 - maju
; 0000 0453                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x89
; 0000 0454                     //tangan kanan
; 0000 0455                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 0456                     servo[13] = 1500; //R2 - turun
	CALL SUBOPT_0x8B
; 0000 0457                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 0458                     //tangan kiri
; 0000 0459                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 045A                     servo[16]  = 1500; //L2 - naik
	CALL SUBOPT_0x8E
; 0000 045B                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 045C                     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 045D 
; 0000 045E                     tangi=0;
	CLR  R11
	CLR  R12
; 0000 045F            break;
	RJMP _0x1E6
; 0000 0460 
; 0000 0461            case 1:
_0x1E7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E8
; 0000 0462                     //kaki kanan
; 0000 0463                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0464                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0465                     servo[3] = 1500; //R4 - maju
	CALL SUBOPT_0x92
; 0000 0466                     servo[2] = 1500; //R3 - maju
	CALL SUBOPT_0x93
; 0000 0467                     servo[1] = 1500; //R2 - maju
	CALL SUBOPT_0x94
; 0000 0468                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 0469                     //kaki kiri
; 0000 046A                     servo[11] = 1500;
; 0000 046B                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 046C                     servo[9]  = 1500; //L4 - maju    984
	CALL SUBOPT_0x97
; 0000 046D                     servo[8]  = 1500; //L3 - maju
	CALL SUBOPT_0x98
; 0000 046E                     servo[7]  = 1500; //L2 - maju
	CALL SUBOPT_0x99
; 0000 046F                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x89
; 0000 0470                     //tangan kanan
; 0000 0471                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 0472                     servo[13] = 800; //R2 - turun
	CALL SUBOPT_0x9A
; 0000 0473                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 0474                     //tangan kiri
; 0000 0475                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 0476                     servo[16]  = 2100; //L2 - naik
	CALL SUBOPT_0x9B
; 0000 0477                     servo[17]  = 1500; //L3 - CW
; 0000 0478                     delay_ms(de);
	MOVW R26,R16
	CALL _delay_ms
; 0000 0479 
; 0000 047A                     tangi=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 11,12
; 0000 047B            break;
	RJMP _0x1E6
; 0000 047C 
; 0000 047D 
; 0000 047E            case 2:
_0x1E8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E9
; 0000 047F                     //kaki kanan
; 0000 0480                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0481                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0482                     servo[3] = 800; //R4 - maju
	CALL SUBOPT_0x9C
; 0000 0483                     servo[2] = 1500; //R3 - maju
	CALL SUBOPT_0x93
; 0000 0484                     servo[1] = 1500; //R2 - maju
	CALL SUBOPT_0x94
; 0000 0485                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 0486                     //kaki kiri
; 0000 0487                     servo[11] = 1500;
; 0000 0488                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0489                     servo[9]  = 2100; //L4 - maju    984
	__POINTW1MN _servo,18
	CALL SUBOPT_0x9D
; 0000 048A                     servo[8]  = 1500; //L3 - maju
	CALL SUBOPT_0x98
; 0000 048B                     servo[7]  = 1500; //L2 - maju
	CALL SUBOPT_0x99
; 0000 048C                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 048D                     //tangan kanan
; 0000 048E                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 048F                     servo[13] = 800; //R2 - turun
	CALL SUBOPT_0x9A
; 0000 0490                     servo[12] = 1000; //R1 - mundur
	__POINTW1MN _servo,24
	CALL SUBOPT_0xA0
; 0000 0491                     //tangan kiri
; 0000 0492                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 0493                     servo[16]  = 2100; //L2 - naik
	CALL SUBOPT_0x9B
; 0000 0494                     servo[17]  = 1500; //L3 - CW
; 0000 0495                     delay_ms(de);
	MOVW R26,R16
	CALL _delay_ms
; 0000 0496 
; 0000 0497                     tangi=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	__PUTW1R 11,12
; 0000 0498            break;
	RJMP _0x1E6
; 0000 0499 
; 0000 049A            case 3:
_0x1E9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1EA
; 0000 049B                     //kaki kanan
; 0000 049C                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 049D                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 049E                     servo[3] = 1500; //R4 - maju
	CALL SUBOPT_0x92
; 0000 049F                     servo[2] = 1500; //R3 - maju
	CALL SUBOPT_0x93
; 0000 04A0                     servo[1] = 1500; //R2 - maju
	CALL SUBOPT_0x94
; 0000 04A1                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 04A2                     //kaki kiri
; 0000 04A3                     servo[11] = 1500;
; 0000 04A4                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 04A5                     servo[9]  = 1500; //L4 - maju    984
	CALL SUBOPT_0x97
; 0000 04A6                     servo[8]  = 1500; //L3 - maju
	CALL SUBOPT_0x98
; 0000 04A7                     servo[7]  = 1500; //L2 - maju
	CALL SUBOPT_0x99
; 0000 04A8                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 04A9                     //tangan kanan
; 0000 04AA                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 04AB                     servo[13] = 800; //R2 - turun
	CALL SUBOPT_0x9A
; 0000 04AC                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 04AD                     //tangan kiri
; 0000 04AE                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 04AF                     servo[16]  = 2100; //L2 - naik
	CALL SUBOPT_0x9B
; 0000 04B0                     servo[17]  = 1500; //L3 - CW
; 0000 04B1                     delay_ms(de);
	MOVW R26,R16
	CALL _delay_ms
; 0000 04B2 
; 0000 04B3                     tangi=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	__PUTW1R 11,12
; 0000 04B4            break;
	RJMP _0x1E6
; 0000 04B5 
; 0000 04B6            case 4:
_0x1EA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1EB
; 0000 04B7                     //kaki kanan
; 0000 04B8                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 04B9                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 04BA                     servo[3] = 1500; //R4 - maju
	CALL SUBOPT_0x92
; 0000 04BB                     servo[2] = 1500; //R3 - maju
	CALL SUBOPT_0x93
; 0000 04BC                     servo[1] = 1500; //R2 - maju
	CALL SUBOPT_0x94
; 0000 04BD                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 04BE                     //kaki kiri
; 0000 04BF                     servo[11] = 1500;
; 0000 04C0                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 04C1                     servo[9]  = 1500; //L4 - maju    984
	CALL SUBOPT_0x97
; 0000 04C2                     servo[8]  = 1500; //L3 - maju
	CALL SUBOPT_0x98
; 0000 04C3                     servo[7]  = 1500; //L2 - maju
	CALL SUBOPT_0x99
; 0000 04C4                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x89
; 0000 04C5                     //tangan kanan
; 0000 04C6                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 04C7                     servo[13] = 1500; //R2 - turun
	CALL SUBOPT_0x8B
; 0000 04C8                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 04C9                     //tangan kiri
; 0000 04CA                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 04CB                     servo[16]  = 1500; //L2 - naik
	CALL SUBOPT_0x8E
; 0000 04CC                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 04CD                     delay_ms(de);
	MOVW R26,R16
	CALL _delay_ms
; 0000 04CE 
; 0000 04CF                     tangi=5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	__PUTW1R 11,12
; 0000 04D0            break;
	RJMP _0x1E6
; 0000 04D1 
; 0000 04D2            case 5:
_0x1EB:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1EC
; 0000 04D3                     //kaki kanan
; 0000 04D4                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 04D5                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 04D6                     servo[3] = 984;  //R4 - maju
	CALL SUBOPT_0xA1
; 0000 04D7                     servo[2] = 2508; //R3 - maju
; 0000 04D8                     servo[1] = 1006; //R2 - maju
; 0000 04D9                     servo[0] = 1500; //R1 - kiri
; 0000 04DA                     //kaki kiri
; 0000 04DB                     servo[11] = 1500;
; 0000 04DC                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 04DD                     servo[9]  = 984;  //L4 - maju    984
	CALL SUBOPT_0xA2
; 0000 04DE                     servo[8]  = 2508; //L3 - maju
; 0000 04DF                     servo[7]  = 1006; //L2 - maju
; 0000 04E0                     servo[6]  = 1500; //L1 - kanan
; 0000 04E1                     //tangan kanan
; 0000 04E2                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 04E3                     servo[13] = 1500; //R2 - turun
	CALL SUBOPT_0x8B
; 0000 04E4                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 04E5                     //tangan kiri
; 0000 04E6                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 04E7                     servo[16]  = 1500; //L2 - naik
	CALL SUBOPT_0x8E
; 0000 04E8                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 04E9                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 04EA 
; 0000 04EB                     tangi=6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	__PUTW1R 11,12
; 0000 04EC            break;
	RJMP _0x1E6
; 0000 04ED 
; 0000 04EE 
; 0000 04EF            case 6:
_0x1EC:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1ED
; 0000 04F0                     //kaki kanan
; 0000 04F1                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 04F2                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 04F3                     servo[3] = 984;  //R4 - maju
	CALL SUBOPT_0xA1
; 0000 04F4                     servo[2] = 2508; //R3 - maju
; 0000 04F5                     servo[1] = 1006; //R2 - maju
; 0000 04F6                     servo[0] = 1500; //R1 - kiri
; 0000 04F7                     //kaki kiri
; 0000 04F8                     servo[11] = 1500;
; 0000 04F9                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 04FA                     servo[9]  = 984;  //L4 - maju    984
	CALL SUBOPT_0xA2
; 0000 04FB                     servo[8]  = 2508; //L3 - maju
; 0000 04FC                     servo[7]  = 1006; //L2 - maju
; 0000 04FD                     servo[6]  = 1500; //L1 - kanan
; 0000 04FE                     //tangan kanan
; 0000 04FF                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 0500                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 0501                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 0502                     //tangan kiri
; 0000 0503                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 0504                     servo[16]  = 900; //L2 - naik
	CALL SUBOPT_0xA3
; 0000 0505                     servo[15]  = 1500; //L1 - maju
; 0000 0506                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 0507 
; 0000 0508                     tangi=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	__PUTW1R 11,12
; 0000 0509            break;
	RJMP _0x1E6
; 0000 050A 
; 0000 050B            case 7:
_0x1ED:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1EE
; 0000 050C                     //kaki kanan
; 0000 050D                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 050E                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 050F                     servo[3] = 984;  //R4 - maju
	CALL SUBOPT_0xA1
; 0000 0510                     servo[2] = 2508; //R3 - maju
; 0000 0511                     servo[1] = 1006; //R2 - maju
; 0000 0512                     servo[0] = 1500; //R1 - kiri
; 0000 0513                     //kaki kiri
; 0000 0514                     servo[11] = 1500;
; 0000 0515                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0516                     servo[9]  = 984;  //L4 - maju    984
	CALL SUBOPT_0xA4
; 0000 0517                     servo[8]  = 2508; //L3 - maju
; 0000 0518                     servo[7]  = 1006; //L2 - maju
; 0000 0519                     servo[6]  = 1500; //L1 - kanan
; 0000 051A                     //tangan kanan
; 0000 051B                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 051C                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 051D                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 051E                     //tangan kiri
; 0000 051F                     servo[17]  = 2500; //L3 - CW
	CALL SUBOPT_0xA5
; 0000 0520                     servo[16]  = 900; //L2 - naik
	CALL SUBOPT_0xA3
; 0000 0521                     servo[15]  = 1500; //L1 - maju
; 0000 0522                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 0523 
; 0000 0524                     tangi=8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	__PUTW1R 11,12
; 0000 0525            break;
	RJMP _0x1E6
; 0000 0526 
; 0000 0527            case 8:
_0x1EE:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x1EF
; 0000 0528                     //kaki kanan
; 0000 0529                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 052A                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 052B                     servo[3] = 500;  //R4 - maju
	CALL SUBOPT_0xA6
; 0000 052C                     servo[2] = 2508; //R3 - maju
; 0000 052D                     servo[1] = 1006; //R2 - maju
	CALL SUBOPT_0xA7
; 0000 052E                     servo[0] = 1460; //R1 - kiri
	CALL SUBOPT_0xA8
; 0000 052F                     //kaki kiri
; 0000 0530                     servo[11] = 1500;
; 0000 0531                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0532                     servo[9]  = 470;  //L4 - maju    984
	CALL SUBOPT_0xA9
; 0000 0533                     servo[8]  = 2508; //L3 - maju
; 0000 0534                     servo[7]  = 1006; //L2 - maju
; 0000 0535                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 0536                     //tangan kanan
; 0000 0537                     servo[14] = 460; //R3 - CW
	CALL SUBOPT_0xAA
; 0000 0538                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 0539                     servo[12] = 1600; //R1 - mundur
	CALL SUBOPT_0xAB
; 0000 053A                     //tangan kiri
; 0000 053B                     servo[17]  = 2500; //L3 - CW
; 0000 053C                     servo[16]  = 850; //L2 - naik
	CALL SUBOPT_0xAC
; 0000 053D                     servo[15]  = 1500; //L1 - maju
; 0000 053E                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 053F 
; 0000 0540                     tangi=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	__PUTW1R 11,12
; 0000 0541            break;
	RJMP _0x1E6
; 0000 0542 
; 0000 0543            case 9:
_0x1EF:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x1F0
; 0000 0544                     //kaki kanan
; 0000 0545                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0546                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0547                     servo[3] = 480;  //R4 - maju
	CALL SUBOPT_0xAD
; 0000 0548                     servo[2] = 2508; //R3 - maju
; 0000 0549                     servo[1] = 1006; //R2 - maju
; 0000 054A                     servo[0] = 1460; //R1 - kiri
	CALL SUBOPT_0xA8
; 0000 054B                     //kaki kiri
; 0000 054C                     servo[11] = 1500;
; 0000 054D                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 054E                     servo[9]  = 500;  //L4 - maju    984
	CALL SUBOPT_0xAE
; 0000 054F                     servo[8]  = 2508; //L3 - maju
; 0000 0550                     servo[7]  = 1006; //L2 - maju
	CALL SUBOPT_0xA7
; 0000 0551                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 0552                     //tangan kanan
; 0000 0553                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 0554                     servo[13] = 2150; //R2 - turun
	CALL SUBOPT_0xAF
; 0000 0555                     servo[12] = 1700; //R1 - mundur
; 0000 0556                     //tangan kiri
; 0000 0557                     servo[17]  = 2500; //L3 - CW
; 0000 0558                     servo[16]  = 800; //L2 - naik
	__POINTW1MN _servo,32
	CALL SUBOPT_0x9A
; 0000 0559                     servo[15]  = 1400; //L1 - maju
	CALL SUBOPT_0xB0
; 0000 055A                     delay_ms(de);
; 0000 055B 
; 0000 055C                     tangi=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	__PUTW1R 11,12
; 0000 055D            break;
	RJMP _0x1E6
; 0000 055E 
; 0000 055F            case 10:
_0x1F0:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x1F1
; 0000 0560                     //kaki kanan
; 0000 0561                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0562                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0563                     servo[3] = 500;  //R4 - maju
	CALL SUBOPT_0xA6
; 0000 0564                     servo[2] = 2508; //R3 - maju
; 0000 0565                     servo[1] = 1306; //R2 - maju
	CALL SUBOPT_0xB1
; 0000 0566                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 0567                     //kaki kiri
; 0000 0568                     servo[11] = 1500;
; 0000 0569                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 056A                     servo[9]  = 500;  //L4 - maju    984
	CALL SUBOPT_0xAE
; 0000 056B                     servo[8]  = 2508; //L3 - maju
; 0000 056C                     servo[7]  = 1306; //L2 - maju
	CALL SUBOPT_0xB1
; 0000 056D                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 056E                     //tangan kanan
; 0000 056F                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 0570                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 0571                     servo[12] = 1800; //R1 - mundur
	CALL SUBOPT_0xB2
; 0000 0572                     //tangan kiri
; 0000 0573                     servo[17]  = 2500; //L3 - CW
	CALL SUBOPT_0xA5
; 0000 0574                     servo[16]  = 900; //L2 - naik
	CALL SUBOPT_0xB3
; 0000 0575                     servo[15]  = 1200; //L1 - maju
; 0000 0576                     delay_ms(de);
; 0000 0577 
; 0000 0578                     tangi=11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	__PUTW1R 11,12
; 0000 0579            break;
	RJMP _0x1E6
; 0000 057A 
; 0000 057B            case 11:
_0x1F1:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x1F2
; 0000 057C                     //kaki kanan
; 0000 057D                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 057E                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 057F                     servo[3] = 500;  //R4 - maju
	CALL SUBOPT_0xA6
; 0000 0580                     servo[2] = 2508; //R3 - maju
; 0000 0581                     servo[1] = 1306; //R2 - maju
	CALL SUBOPT_0xB1
; 0000 0582                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 0583                     //kaki kiri
; 0000 0584                     servo[11] = 1500;
; 0000 0585                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0586                     servo[9]  = 500;  //L4 - maju    984
	CALL SUBOPT_0xAE
; 0000 0587                     servo[8]  = 2508; //L3 - maju
; 0000 0588                     servo[7]  = 1306; //L2 - maju
	CALL SUBOPT_0xB1
; 0000 0589                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 058A                     //tangan kanan
; 0000 058B                     servo[14] = 1600; //R3 - CW
	CALL SUBOPT_0xB4
; 0000 058C                     servo[13] = 1000; //R2 - turun
	CALL SUBOPT_0xA0
; 0000 058D                     servo[12] = 1800; //R1 - mundur
	CALL SUBOPT_0xB2
; 0000 058E                     //tangan kiri
; 0000 058F                     servo[17]  = 1400; //L3 - CW
	CALL SUBOPT_0xB5
; 0000 0590                     servo[16]  = 2000; //L2 - naik
; 0000 0591                     servo[15]  = 1200; //L1 - maju
; 0000 0592                     delay_ms(de);
; 0000 0593 
; 0000 0594                     tangi=12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	__PUTW1R 11,12
; 0000 0595            break;
	RJMP _0x1E6
; 0000 0596 
; 0000 0597            case 12:
_0x1F2:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x1F3
; 0000 0598                     //kaki kanan
; 0000 0599                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 059A                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 059B                     servo[3] = 800;  //R4 - maju
	CALL SUBOPT_0x9C
; 0000 059C                     servo[2] = 2508; //R3 - maju
	CALL SUBOPT_0xB6
; 0000 059D                     servo[1] = 1056; //R2 - maju
; 0000 059E                     servo[0] = 1500; //R1 - kiri
; 0000 059F                     //kaki kiri
; 0000 05A0                     servo[11] = 1500;
; 0000 05A1                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 05A2                     servo[9]  = 800;  //L4 - maju    984
	__POINTW1MN _servo,18
	CALL SUBOPT_0x9A
; 0000 05A3                     servo[8]  = 2508; //L3 - maju
	CALL SUBOPT_0xB7
; 0000 05A4                     servo[7]  = 1056; //L2 - maju
; 0000 05A5                     servo[6]  = 1500; //L1 - kanan
; 0000 05A6                     //tangan kanan
; 0000 05A7                     servo[14] = 1200; //R3 - CW
	CALL SUBOPT_0xB8
; 0000 05A8                     servo[13] = 1000; //R2 - turun
	CALL SUBOPT_0xA0
; 0000 05A9                     servo[12] = 1800; //R1 - mundur
	CALL SUBOPT_0xB2
; 0000 05AA                     //tangan kiri
; 0000 05AB                     servo[17]  = 1800; //L3 - CW
	__POINTW1MN _servo,34
	CALL SUBOPT_0x6F
; 0000 05AC                     servo[16]  = 2000; //L2 - naik
	CALL SUBOPT_0xB9
; 0000 05AD                     servo[15]  = 1200; //L1 - maju
; 0000 05AE                     delay_ms(de);
; 0000 05AF 
; 0000 05B0                     countTick=0;
; 0000 05B1                     tangi=13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	__PUTW1R 11,12
; 0000 05B2            break;
	RJMP _0x1E6
; 0000 05B3 
; 0000 05B4            case 13:
_0x1F3:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x1E6
; 0000 05B5                     bangkit();
	RCALL _bangkit
; 0000 05B6            break;
; 0000 05B7           }
_0x1E6:
; 0000 05B8     }
	RJMP _0x20A0009
;
;void bangun_tengkurap()
; 0000 05BB    {
_bangun_tengkurap:
; 0000 05BC     int de  = 1000;
; 0000 05BD     int lay = 50;
; 0000 05BE     //tango = 6;
; 0000 05BF           switch(tango)
	CALL SUBOPT_0x87
;	de -> R16,R17
;	lay -> R18,R19
	__GETW1R 9,10
; 0000 05C0           {
; 0000 05C1            case 0:
	SBIW R30,0
	BRNE _0x1F8
; 0000 05C2                      //ndas
; 0000 05C3                     servo[18]  = 500; //L1 - maju
	CALL SUBOPT_0x88
; 0000 05C4                     servo[19]  = 2000; //L2 - naik
; 0000 05C5                     //kaki kanan
; 0000 05C6                     servo[5] = 1500;
; 0000 05C7                     servo[4] = 1500; //R5 - kiri
; 0000 05C8                     servo[3] = 1500; //R4 - maju
; 0000 05C9                     servo[2] = 1500; //R3 - maju
; 0000 05CA                     servo[1] = 1500; //R2 - maju
; 0000 05CB                     servo[0] = 1500; //R1 - kiri
; 0000 05CC                     //kaki kiri
; 0000 05CD                     servo[11] = 1500;
; 0000 05CE                     servo[10] = 1500; //L5 - kanan
; 0000 05CF                     servo[9]  = 1500; //L4 - maju    984
; 0000 05D0                     servo[8]  = 1500; //L3 - maju
; 0000 05D1                     servo[7]  = 1500; //L2 - maju
; 0000 05D2                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x89
; 0000 05D3                     //tangan kanan
; 0000 05D4                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 05D5                     servo[13] = 1500; //R2 - turun
	CALL SUBOPT_0x8B
; 0000 05D6                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 05D7                     //tangan kiri
; 0000 05D8                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 05D9                     servo[16]  = 1500; //L2 - naik
	CALL SUBOPT_0x8E
; 0000 05DA                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 05DB                     delay_ms(de);
	MOVW R26,R16
	CALL _delay_ms
; 0000 05DC 
; 0000 05DD                     tango=0;
	CLR  R9
	CLR  R10
; 0000 05DE            break;
	RJMP _0x1F7
; 0000 05DF 
; 0000 05E0            case 1:
_0x1F8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F9
; 0000 05E1                     //kaki kanan
; 0000 05E2                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 05E3                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 05E4                     servo[3] = 984;  //R4 - maju
	CALL SUBOPT_0xA1
; 0000 05E5                     servo[2] = 2508; //R3 - maju
; 0000 05E6                     servo[1] = 1006; //R2 - maju
; 0000 05E7                     servo[0] = 1500; //R1 - kiri
; 0000 05E8                     //kaki kiri
; 0000 05E9                     servo[11] = 1500;
; 0000 05EA                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 05EB                     servo[9]  = 984;  //L4 - maju    984
	CALL SUBOPT_0xA2
; 0000 05EC                     servo[8]  = 2508; //L3 - maju
; 0000 05ED                     servo[7]  = 1006; //L2 - maju
; 0000 05EE                     servo[6]  = 1500; //L1 - kanan
; 0000 05EF                     //tangan kanan
; 0000 05F0                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 05F1                     servo[13] = 1500; //R2 - turun
	CALL SUBOPT_0x8B
; 0000 05F2                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 05F3                     //tangan kiri
; 0000 05F4                     servo[15]  = 1500; //L1 - maju
	CALL SUBOPT_0x8D
; 0000 05F5                     servo[16]  = 1500; //L2 - naik
	CALL SUBOPT_0x8E
; 0000 05F6                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 05F7                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 05F8 
; 0000 05F9                     tango=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 9,10
; 0000 05FA            break;
	RJMP _0x1F7
; 0000 05FB 
; 0000 05FC 
; 0000 05FD            case 2:
_0x1F9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1FA
; 0000 05FE                     //kaki kanan
; 0000 05FF                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0600                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0601                     servo[3] = 984;  //R4 - maju
	CALL SUBOPT_0xA1
; 0000 0602                     servo[2] = 2508; //R3 - maju
; 0000 0603                     servo[1] = 1006; //R2 - maju
; 0000 0604                     servo[0] = 1500; //R1 - kiri
; 0000 0605                     //kaki kiri
; 0000 0606                     servo[11] = 1500;
; 0000 0607                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0608                     servo[9]  = 984;  //L4 - maju    984
	CALL SUBOPT_0xA2
; 0000 0609                     servo[8]  = 2508; //L3 - maju
; 0000 060A                     servo[7]  = 1006; //L2 - maju
; 0000 060B                     servo[6]  = 1500; //L1 - kanan
; 0000 060C                     //tangan kanan
; 0000 060D                     servo[14] = 1500; //R3 - CW
	CALL SUBOPT_0x8A
; 0000 060E                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 060F                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 0610                     //tangan kiri
; 0000 0611                     servo[17]  = 1500; //L3 - CW
	CALL SUBOPT_0x8F
; 0000 0612                     servo[16]  = 900; //L2 - naik
	CALL SUBOPT_0xA3
; 0000 0613                     servo[15]  = 1500; //L1 - maju
; 0000 0614                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 0615 
; 0000 0616                     tango=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	__PUTW1R 9,10
; 0000 0617            break;
	RJMP _0x1F7
; 0000 0618 
; 0000 0619            case 3:
_0x1FA:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1FB
; 0000 061A                     //kaki kanan
; 0000 061B                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 061C                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 061D                     servo[3] = 984;  //R4 - maju
	CALL SUBOPT_0xA1
; 0000 061E                     servo[2] = 2508; //R3 - maju
; 0000 061F                     servo[1] = 1006; //R2 - maju
; 0000 0620                     servo[0] = 1500; //R1 - kiri
; 0000 0621                     //kaki kiri
; 0000 0622                     servo[11] = 1500;
; 0000 0623                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0624                     servo[9]  = 984;  //L4 - maju    984
	CALL SUBOPT_0xA4
; 0000 0625                     servo[8]  = 2508; //L3 - maju
; 0000 0626                     servo[7]  = 1006; //L2 - maju
; 0000 0627                     servo[6]  = 1500; //L1 - kanan
; 0000 0628                     //tangan kanan
; 0000 0629                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 062A                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 062B                     servo[12] = 1500; //R1 - mundur
	CALL SUBOPT_0x8C
; 0000 062C                     //tangan kiri
; 0000 062D                     servo[17]  = 2500; //L3 - CW
	CALL SUBOPT_0xA5
; 0000 062E                     servo[16]  = 900; //L2 - naik
	CALL SUBOPT_0xA3
; 0000 062F                     servo[15]  = 1500; //L1 - maju
; 0000 0630                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 0631 
; 0000 0632                     tango=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	__PUTW1R 9,10
; 0000 0633            break;
	RJMP _0x1F7
; 0000 0634 
; 0000 0635            case 4:
_0x1FB:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1FC
; 0000 0636                     //kaki kanan
; 0000 0637                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0638                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0639                     servo[3] = 500;  //R4 - maju
	CALL SUBOPT_0xA6
; 0000 063A                     servo[2] = 2508; //R3 - maju
; 0000 063B                     servo[1] = 1006; //R2 - maju
	CALL SUBOPT_0xA7
; 0000 063C                     servo[0] = 1460; //R1 - kiri
	CALL SUBOPT_0xA8
; 0000 063D                     //kaki kiri
; 0000 063E                     servo[11] = 1500;
; 0000 063F                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0640                     servo[9]  = 470;  //L4 - maju    984
	CALL SUBOPT_0xA9
; 0000 0641                     servo[8]  = 2508; //L3 - maju
; 0000 0642                     servo[7]  = 1006; //L2 - maju
; 0000 0643                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 0644                     //tangan kanan
; 0000 0645                     servo[14] = 460; //R3 - CW
	CALL SUBOPT_0xAA
; 0000 0646                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 0647                     servo[12] = 1600; //R1 - mundur
	CALL SUBOPT_0xAB
; 0000 0648                     //tangan kiri
; 0000 0649                     servo[17]  = 2500; //L3 - CW
; 0000 064A                     servo[16]  = 850; //L2 - naik
	CALL SUBOPT_0xAC
; 0000 064B                     servo[15]  = 1500; //L1 - maju
; 0000 064C                     delay_ms(lay);
	MOVW R26,R18
	CALL _delay_ms
; 0000 064D 
; 0000 064E                     tango=5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	__PUTW1R 9,10
; 0000 064F            break;
	RJMP _0x1F7
; 0000 0650 
; 0000 0651            case 5:
_0x1FC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1FD
; 0000 0652                     //kaki kanan
; 0000 0653                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0654                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0655                     servo[3] = 480;  //R4 - maju
	CALL SUBOPT_0xAD
; 0000 0656                     servo[2] = 2508; //R3 - maju
; 0000 0657                     servo[1] = 1006; //R2 - maju
; 0000 0658                     servo[0] = 1460; //R1 - kiri
	CALL SUBOPT_0xA8
; 0000 0659                     //kaki kiri
; 0000 065A                     servo[11] = 1500;
; 0000 065B                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 065C                     servo[9]  = 500;  //L4 - maju    984
	CALL SUBOPT_0xAE
; 0000 065D                     servo[8]  = 2508; //L3 - maju
; 0000 065E                     servo[7]  = 1006; //L2 - maju
	CALL SUBOPT_0xA7
; 0000 065F                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 0660                     //tangan kanan
; 0000 0661                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 0662                     servo[13] = 2150; //R2 - turun
	CALL SUBOPT_0xAF
; 0000 0663                     servo[12] = 1700; //R1 - mundur
; 0000 0664                     //tangan kiri
; 0000 0665                     servo[17]  = 2500; //L3 - CW
; 0000 0666                     servo[16]  = 800; //L2 - naik
	__POINTW1MN _servo,32
	CALL SUBOPT_0x9A
; 0000 0667                     servo[15]  = 1400; //L1 - maju
	CALL SUBOPT_0xB0
; 0000 0668                     delay_ms(de);
; 0000 0669 
; 0000 066A                     tango=6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	__PUTW1R 9,10
; 0000 066B            break;
	RJMP _0x1F7
; 0000 066C 
; 0000 066D            case 6:
_0x1FD:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1FE
; 0000 066E                     //kaki kanan
; 0000 066F                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 0670                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 0671                     servo[3] = 500;  //R4 - maju
	CALL SUBOPT_0xA6
; 0000 0672                     servo[2] = 2508; //R3 - maju
; 0000 0673                     servo[1] = 1306; //R2 - maju
	CALL SUBOPT_0xB1
; 0000 0674                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 0675                     //kaki kiri
; 0000 0676                     servo[11] = 1500;
; 0000 0677                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0678                     servo[9]  = 500;  //L4 - maju    984
	CALL SUBOPT_0xAE
; 0000 0679                     servo[8]  = 2508; //L3 - maju
; 0000 067A                     servo[7]  = 1306; //L2 - maju
	CALL SUBOPT_0xB1
; 0000 067B                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 067C                     //tangan kanan
; 0000 067D                     servo[14] = 500; //R3 - CW
	CALL SUBOPT_0x9F
; 0000 067E                     servo[13] = 2100; //R2 - turun
	CALL SUBOPT_0x9D
; 0000 067F                     servo[12] = 1800; //R1 - mundur
	CALL SUBOPT_0xB2
; 0000 0680                     //tangan kiri
; 0000 0681                     servo[17]  = 2500; //L3 - CW
	CALL SUBOPT_0xA5
; 0000 0682                     servo[16]  = 900; //L2 - naik
	CALL SUBOPT_0xB3
; 0000 0683                     servo[15]  = 1200; //L1 - maju
; 0000 0684                     delay_ms(de);
; 0000 0685 
; 0000 0686                     tango=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	__PUTW1R 9,10
; 0000 0687            break;
	RJMP _0x1F7
; 0000 0688 
; 0000 0689            case 7:
_0x1FE:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1FF
; 0000 068A                     //kaki kanan
; 0000 068B                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 068C                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 068D                     servo[3] = 500;  //R4 - maju
	CALL SUBOPT_0xA6
; 0000 068E                     servo[2] = 2508; //R3 - maju
; 0000 068F                     servo[1] = 1306; //R2 - maju
	CALL SUBOPT_0xB1
; 0000 0690                     servo[0] = 1500; //R1 - kiri
	CALL SUBOPT_0x95
; 0000 0691                     //kaki kiri
; 0000 0692                     servo[11] = 1500;
; 0000 0693                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 0694                     servo[9]  = 500;  //L4 - maju    984
	CALL SUBOPT_0xAE
; 0000 0695                     servo[8]  = 2508; //L3 - maju
; 0000 0696                     servo[7]  = 1306; //L2 - maju
	CALL SUBOPT_0xB1
; 0000 0697                     servo[6]  = 1500; //L1 - kanan
	CALL SUBOPT_0x9E
; 0000 0698                     //tangan kanan
; 0000 0699                     servo[14] = 1600; //R3 - CW
	CALL SUBOPT_0xB4
; 0000 069A                     servo[13] = 1000; //R2 - turun
	CALL SUBOPT_0xA0
; 0000 069B                     servo[12] = 1800; //R1 - mundur
	CALL SUBOPT_0xB2
; 0000 069C                     //tangan kiri
; 0000 069D                     servo[17]  = 1400; //L3 - CW
	CALL SUBOPT_0xB5
; 0000 069E                     servo[16]  = 2000; //L2 - naik
; 0000 069F                     servo[15]  = 1200; //L1 - maju
; 0000 06A0                     delay_ms(de);
; 0000 06A1 
; 0000 06A2                     tango=8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	__PUTW1R 9,10
; 0000 06A3            break;
	RJMP _0x1F7
; 0000 06A4 
; 0000 06A5            case 8:
_0x1FF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x200
; 0000 06A6                     //kaki kanan
; 0000 06A7                     servo[5] = 1500;
	CALL SUBOPT_0x90
; 0000 06A8                     servo[4] = 1500; //R5 - kiri
	CALL SUBOPT_0x91
; 0000 06A9                     servo[3] = 800;  //R4 - maju
	CALL SUBOPT_0x9C
; 0000 06AA                     servo[2] = 2508; //R3 - maju
	CALL SUBOPT_0xB6
; 0000 06AB                     servo[1] = 1056; //R2 - maju
; 0000 06AC                     servo[0] = 1500; //R1 - kiri
; 0000 06AD                     //kaki kiri
; 0000 06AE                     servo[11] = 1500;
; 0000 06AF                     servo[10] = 1500; //L5 - kanan
	CALL SUBOPT_0x96
; 0000 06B0                     servo[9]  = 800;  //L4 - maju    984
	__POINTW1MN _servo,18
	CALL SUBOPT_0x9A
; 0000 06B1                     servo[8]  = 2508; //L3 - maju
	CALL SUBOPT_0xB7
; 0000 06B2                     servo[7]  = 1056; //L2 - maju
; 0000 06B3                     servo[6]  = 1500; //L1 - kanan
; 0000 06B4                     //tangan kanan
; 0000 06B5                     servo[14] = 1200; //R3 - CW
	CALL SUBOPT_0xB8
; 0000 06B6                     servo[13] = 1000; //R2 - turun
	CALL SUBOPT_0xA0
; 0000 06B7                     servo[12] = 1800; //R1 - mundur
	CALL SUBOPT_0xB2
; 0000 06B8                     //tangan kiri
; 0000 06B9                     servo[17]  = 1800; //L3 - CW
	__POINTW1MN _servo,34
	CALL SUBOPT_0x6F
; 0000 06BA                     servo[16]  = 2000; //L2 - naik
	CALL SUBOPT_0xB9
; 0000 06BB                     servo[15]  = 1200; //L1 - maju
; 0000 06BC                     delay_ms(de);
; 0000 06BD 
; 0000 06BE                     countTick=0;
; 0000 06BF                     tango=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	__PUTW1R 9,10
; 0000 06C0            break;
	RJMP _0x1F7
; 0000 06C1 
; 0000 06C2            case 9:
_0x200:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x1F7
; 0000 06C3                     bangkit();
	RCALL _bangkit
; 0000 06C4            break;
; 0000 06C5           }
_0x1F7:
; 0000 06C6    }
_0x20A0009:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void bangkit()
; 0000 06C9  {
_bangkit:
; 0000 06CA   langkahMax=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _langkahMax,R30
	STS  _langkahMax+1,R31
; 0000 06CB   switch(0)
	LDI  R30,LOW(0)
; 0000 06CC         {
; 0000 06CD            case 0 :     //gait  mlaku
	CPI  R30,0
	BREQ PC+3
	JMP _0x204
; 0000 06CE                 VY=10;
	CALL SUBOPT_0x72
; 0000 06CF                 if(counterDelay<=0)
	BRGE PC+3
	JMP _0x206
; 0000 06D0                 {
; 0000 06D1                     switch(countTick)
	__GETW1R 13,14
; 0000 06D2                     {
; 0000 06D3                        case 0:
	SBIW R30,0
	BRNE _0x20A
; 0000 06D4                             X[0]=0; Y[0]=0; Z[0]=-80;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	__GETD1N 0xC2A00000
	CALL SUBOPT_0xBA
; 0000 06D5                             X[1]=0; Y[1]=0; Z[1]=-80;
	CALL SUBOPT_0x80
	__GETD2N 0xC2A00000
	CALL SUBOPT_0xBB
; 0000 06D6                             InputXYZ();
; 0000 06D7                        break;
	RJMP _0x209
; 0000 06D8                         case 1:
_0x20A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20B
; 0000 06D9                             X[0]=0; Y[0]=0; Z[0]=-70;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	__GETD1N 0xC28C0000
	CALL SUBOPT_0xBA
; 0000 06DA                             X[1]=0; Y[1]=0; Z[1]=-70;
	CALL SUBOPT_0x80
	__GETD2N 0xC28C0000
	CALL SUBOPT_0xBB
; 0000 06DB                             InputXYZ();
; 0000 06DC 
; 0000 06DD                         break;
	RJMP _0x209
; 0000 06DE                         case 2:
_0x20B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20C
; 0000 06DF                             X[0]=0; Y[0]=0; Z[0]=-60;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	__GETD1N 0xC2700000
	CALL SUBOPT_0xBA
; 0000 06E0                             X[1]=0; Y[1]=0; Z[1]=-60;
	CALL SUBOPT_0x80
	__GETD2N 0xC2700000
	CALL SUBOPT_0xBB
; 0000 06E1                             InputXYZ();
; 0000 06E2 
; 0000 06E3                         break;
	RJMP _0x209
; 0000 06E4                         case 4:
_0x20C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20D
; 0000 06E5                             X[0]=0; Y[0]=0; Z[0]=-50;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	__GETD1N 0xC2480000
	CALL SUBOPT_0xBA
; 0000 06E6                             X[1]=0; Y[1]=0; Z[1]=-50;
	CALL SUBOPT_0x80
	__GETD2N 0xC2480000
	CALL SUBOPT_0xBB
; 0000 06E7                             InputXYZ();
; 0000 06E8                         break;
	RJMP _0x209
; 0000 06E9                         case 5:
_0x20D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20E
; 0000 06EA                             X[0]=0 ; Y[0]=0; Z[0]=-40;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	CALL SUBOPT_0x85
; 0000 06EB                             X[1]=0 ; Y[1]=0; Z[1]=-40;
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
	CALL SUBOPT_0xBB
; 0000 06EC                             InputXYZ();
; 0000 06ED 
; 0000 06EE                         break;
	RJMP _0x209
; 0000 06EF                         case 6:
_0x20E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20F
; 0000 06F0                             X[0]=0; Y[0]=0; Z[0]=-30;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	__GETD1N 0xC1F00000
	CALL SUBOPT_0xBA
; 0000 06F1                             X[1]=0; Y[1]=0; Z[1]=-30;
	CALL SUBOPT_0x80
	__GETD2N 0xC1F00000
	CALL SUBOPT_0xBB
; 0000 06F2                             InputXYZ();
; 0000 06F3 
; 0000 06F4                         break;
	RJMP _0x209
; 0000 06F5                         case 7:
_0x20F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x210
; 0000 06F6                             X[0]=0; Y[0]=0; Z[0]=-20;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	__GETD1N 0xC1A00000
	CALL SUBOPT_0xBA
; 0000 06F7                             X[1]=0; Y[1]=0; Z[1]=-20;
	CALL SUBOPT_0x80
	__GETD2N 0xC1A00000
	CALL SUBOPT_0xBB
; 0000 06F8                             InputXYZ();
; 0000 06F9 
; 0000 06FA                         break;
	RJMP _0x209
; 0000 06FB                         case 8:
_0x210:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x211
; 0000 06FC                             X[0]=0; Y[0]=0; Z[0]=-10;
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	CALL SUBOPT_0xBD
	CALL SUBOPT_0xBA
; 0000 06FD                             X[1]=0; Y[1]=0; Z[1]=-10;
	CALL SUBOPT_0x80
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xBB
; 0000 06FE                             InputXYZ();
; 0000 06FF 
; 0000 0700                         break;
	RJMP _0x209
; 0000 0701                         case 9:
_0x211:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x209
; 0000 0702                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x16
; 0000 0703                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0704                             InputXYZ();
	CALL _InputXYZ
; 0000 0705 
; 0000 0706                             sudah = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _sudah,R30
	STS  _sudah+1,R31
; 0000 0707                         break;
; 0000 0708                     }
_0x209:
; 0000 0709                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0x214
	CALL SUBOPT_0x73
	BREQ _0x213
_0x214:
; 0000 070A                     {
; 0000 070B                         countTick++;
	CALL SUBOPT_0x74
; 0000 070C                         if(countTick>9)
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x216
; 0000 070D                            countTick=9;     //2
	__PUTW1R 13,14
; 0000 070E                     }
_0x216:
; 0000 070F                     else
	RJMP _0x217
_0x213:
; 0000 0710                     {
; 0000 0711                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0712                     }
_0x217:
; 0000 0713 
; 0000 0714                     counterDelay=1000; //3000
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x75
; 0000 0715                 }
; 0000 0716             break;
_0x206:
; 0000 0717         }
_0x204:
; 0000 0718 
; 0000 0719         speed=10; //10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _speed,R30
	STS  _speed+1,R31
; 0000 071A         if(counterTG>speed)
	LDS  R26,_counterTG
	LDS  R27,_counterTG+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x218
; 0000 071B         {
; 0000 071C             counterTG=0;
	CALL SUBOPT_0x77
; 0000 071D             taskGerakan();
; 0000 071E         }
; 0000 071F  }
_0x218:
	RET
;
;void maju(){
; 0000 0721 void maju(){
_maju:
; 0000 0722     //servoInitError[7]=30;
; 0000 0723     //tangan kanan
; 0000 0724     servo[14] = 1600; //R3 - CW
	CALL SUBOPT_0xBF
; 0000 0725     servo[13] = 900; //R2 - turun
; 0000 0726     servo[12] = 1900; //R1 - mundur
; 0000 0727     //tangan kiri
; 0000 0728     servo[17]  = 1400; //L3 - CW
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	CALL SUBOPT_0x71
; 0000 0729     servo[16]  = 2050; //L2 - naik
; 0000 072A     servo[15]  = 1100; //L1 - maju
; 0000 072B     switch(0)
; 0000 072C         {
; 0000 072D            case 0 :     //gait  mlaku
	BREQ PC+3
	JMP _0x21B
; 0000 072E                 VY=20;
	__GETD1N 0x41A00000
	CALL SUBOPT_0xC0
; 0000 072F                 if(counterDelay<=0)
	CALL SUBOPT_0x2
	BRGE PC+3
	JMP _0x21D
; 0000 0730                 {
; 0000 0731                     switch(countTick)
	__GETW1R 13,14
; 0000 0732                     {
; 0000 0733                        case 0:
	SBIW R30,0
	BRNE _0x221
; 0000 0734                             X[0]=0; Y[0]=0; Z[0]=0;
	RJMP _0x282
; 0000 0735                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0736                             InputXYZ();
; 0000 0737                         break;
; 0000 0738                         case 1:
_0x221:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x222
; 0000 0739                             X[0]=10; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0xC1
	CALL SUBOPT_0x83
	CALL SUBOPT_0xC2
; 0000 073A                             X[1]=-10; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0xBE
	RJMP _0x283
; 0000 073B                             InputXYZ();
; 0000 073C                         break;
; 0000 073D                         case 2:
_0x222:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x223
; 0000 073E                             X[0]=10; Y[0]=VY; Z[0]=-40;
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x85
; 0000 073F                             X[1]=-10; Y[1]=0; Z[1]=0;
	__POINTW1MN _X,4
	CALL SUBOPT_0xBE
	RJMP _0x283
; 0000 0740                             InputXYZ();
; 0000 0741                         break;
; 0000 0742                         case 3:
_0x223:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ _0x282
; 0000 0743                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0744                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0745                             InputXYZ();
; 0000 0746                         break;
; 0000 0747                         case 4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x225
; 0000 0748                             X[0]=-10; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7C
; 0000 0749                             X[1]=10; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7D
	RJMP _0x283
; 0000 074A                             InputXYZ();
; 0000 074B                         break;
; 0000 074C                         case 5:
_0x225:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x226
; 0000 074D                             X[0]=-10; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7C
; 0000 074E                             X[1]=10; Y[1]=VY; Z[1]=-40;
	CALL SUBOPT_0xC5
	__PUTD1MN _Y,4
	__POINTW1MN _Z,4
	CALL SUBOPT_0x81
	RJMP _0x284
; 0000 074F                             InputXYZ();
; 0000 0750                         break;
; 0000 0751                         case 6:
_0x226:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x220
; 0000 0752                             X[0]=0; Y[0]=0; Z[0]=0;
_0x282:
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC7
; 0000 0753                             X[1]=0; Y[1]=0; Z[1]=0;
_0x283:
	CALL __PUTDZ20
	CALL SUBOPT_0xC8
	CALL SUBOPT_0x80
	CALL SUBOPT_0x7A
_0x284:
	CALL __PUTDZ20
; 0000 0754                             InputXYZ();
	CALL _InputXYZ
; 0000 0755                         break;
; 0000 0756                     }
_0x220:
; 0000 0757                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0x229
	CALL SUBOPT_0x73
	BREQ _0x228
_0x229:
; 0000 0758                     {
; 0000 0759                         countTick++;
	CALL SUBOPT_0x74
; 0000 075A                         if(countTick>5)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x22B
; 0000 075B                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 075C                     }
_0x22B:
; 0000 075D                     else
	RJMP _0x22C
_0x228:
; 0000 075E                     {
; 0000 075F                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0760                     }
_0x22C:
; 0000 0761 
; 0000 0762                     counterDelay=85; //65 80   85
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	CALL SUBOPT_0x75
; 0000 0763                 }
; 0000 0764             break;
_0x21D:
; 0000 0765         }
_0x21B:
; 0000 0766 
; 0000 0767         speed=1; //10
	CALL SUBOPT_0x76
; 0000 0768         if(counterTG>speed)
	BRGE _0x22D
; 0000 0769         {
; 0000 076A             counterTG=0;
	CALL SUBOPT_0x77
; 0000 076B             taskGerakan();
; 0000 076C         }
; 0000 076D }
_0x22D:
	RET
;
;void rotasi_kiri()
; 0000 0770  {
_rotasi_kiri:
; 0000 0771     //tangan kanan
; 0000 0772     servo[14] = 1600; //R3 - CW
	CALL SUBOPT_0xBF
; 0000 0773     servo[13] = 900; //R2 - turun
; 0000 0774     servo[12] = 1900; //R1 - mundur
; 0000 0775     //tangan kiri
; 0000 0776     servo[17]  = 1400; //L3 - CW
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	CALL SUBOPT_0x71
; 0000 0777     servo[16]  = 2050; //L2 - naik
; 0000 0778     servo[15]  = 1100; //L1 - maju
; 0000 0779     switch(0)
; 0000 077A         {
; 0000 077B            case 0 :     //gait  mlaku
	BREQ PC+3
	JMP _0x230
; 0000 077C                 VY=30;
	__GETD1N 0x41F00000
	CALL SUBOPT_0xC0
; 0000 077D                 VX=35;
	__GETD1N 0x420C0000
	STS  _VX,R30
	STS  _VX+1,R31
	STS  _VX+2,R22
	STS  _VX+3,R23
; 0000 077E                 VZ=40;
	__GETD1N 0x42200000
	STS  _VZ,R30
	STS  _VZ+1,R31
	STS  _VZ+2,R22
	STS  _VZ+3,R23
; 0000 077F                 if(counterDelay<=0)
	CALL SUBOPT_0x2
	BRGE PC+3
	JMP _0x232
; 0000 0780                 {
; 0000 0781                     switch(countTick)
	__GETW1R 13,14
; 0000 0782                     {
; 0000 0783                        case 0:
	SBIW R30,0
	BRNE _0x236
; 0000 0784                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x79
; 0000 0785                             X[1]=0; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x14
	RJMP _0x285
; 0000 0786                             InputXYZ();
; 0000 0787                         break;
; 0000 0788                         case 1:
_0x236:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x237
; 0000 0789                             X[0]=VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0xC9
	CALL SUBOPT_0xCA
	CALL SUBOPT_0x83
	LDI  R30,LOW(0)
	CALL SUBOPT_0x86
; 0000 078A                             X[1]=-VX; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0xCB
	CALL SUBOPT_0x14
	RJMP _0x285
; 0000 078B                             InputXYZ();
; 0000 078C                         break;
; 0000 078D                         case 2:
_0x237:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x238
; 0000 078E                             X[0]=VX; Y[0]=VY; Z[0]=-VZ;
	CALL SUBOPT_0xC9
	CALL SUBOPT_0xCC
	LDS  R30,_VZ
	LDS  R31,_VZ+1
	LDS  R22,_VZ+2
	LDS  R23,_VZ+3
	CALL __ANEGF1
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
; 0000 078F                             X[1]=-VX; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0xCB
	CALL SUBOPT_0x14
	RJMP _0x285
; 0000 0790                             InputXYZ();
; 0000 0791                         break;
; 0000 0792                         case 3:
_0x238:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x239
; 0000 0793                             X[0]=0; Y[0]=VY; Z[0]=0;
	CALL SUBOPT_0x82
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC7
; 0000 0794                             X[1]=0; Y[1]=VY; Z[1]=0;
	CALL SUBOPT_0x14
	CALL SUBOPT_0xC3
	RJMP _0x286
; 0000 0795                             InputXYZ();
; 0000 0796                         break;
; 0000 0797                         case 4:
_0x239:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x23A
; 0000 0798                             X[0]=-10; Y[0]=VY; Z[0]=0;
	CALL SUBOPT_0xBD
	CALL SUBOPT_0xCC
	CALL SUBOPT_0xC2
; 0000 0799                             X[1]=10; Y[1]=VY; Z[1]=0;
	CALL SUBOPT_0xC5
	RJMP _0x286
; 0000 079A                             InputXYZ();
; 0000 079B                         break;
; 0000 079C                         case 5:
_0x23A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x23B
; 0000 079D                             X[0]=-10; Y[0]=VY; Z[0]=0;
	CALL SUBOPT_0xBD
	CALL SUBOPT_0xCC
	CALL SUBOPT_0xC2
; 0000 079E                             X[1]=10; Y[1]=0; Z[1]=-40;
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
	RJMP _0x287
; 0000 079F                             InputXYZ();
; 0000 07A0                         break;
; 0000 07A1                         case 6:
_0x23B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x235
; 0000 07A2                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x79
; 0000 07A3                             X[1]=0; Y[1]=-VY; Z[1]=0;
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x14
	CALL SUBOPT_0xC3
	CALL __ANEGF1
_0x286:
	__PUTD1MN _Y,4
_0x285:
	__POINTW1MN _Z,4
	CALL SUBOPT_0x7A
_0x287:
	CALL __PUTDZ20
; 0000 07A4                             InputXYZ();
	CALL _InputXYZ
; 0000 07A5                         break;
; 0000 07A6                     }
_0x235:
; 0000 07A7                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0x23E
	CALL SUBOPT_0x73
	BREQ _0x23D
_0x23E:
; 0000 07A8                     {
; 0000 07A9                         countTick++;
	CALL SUBOPT_0x74
; 0000 07AA                         if(countTick>2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x240
; 0000 07AB                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 07AC                     }
_0x240:
; 0000 07AD                     else
	RJMP _0x241
_0x23D:
; 0000 07AE                     {
; 0000 07AF                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 07B0                     }
_0x241:
; 0000 07B1 
; 0000 07B2                     counterDelay=130; //65 80
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x75
; 0000 07B3                 }
; 0000 07B4             break;
_0x232:
; 0000 07B5         }
_0x230:
; 0000 07B6 
; 0000 07B7         speed=1; //10
	CALL SUBOPT_0x76
; 0000 07B8         if(counterTG>speed)
	BRGE _0x242
; 0000 07B9         {
; 0000 07BA             counterTG=0;
	CALL SUBOPT_0x77
; 0000 07BB             taskGerakan();
; 0000 07BC         }
; 0000 07BD  }
_0x242:
	RET
;
;void rotasi_kanan()
; 0000 07C0  {
_rotasi_kanan:
; 0000 07C1   //tangan kanan
; 0000 07C2     servo[14] = 1800; //R3 - CW
	__POINTW1MN _servo,28
	CALL SUBOPT_0x6F
; 0000 07C3     servo[13] = 900; //R2 - turun
	__POINTW1MN _servo,26
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07C4     servo[12] = 1900; //R1 - mundur
	__POINTW1MN _servo,24
	LDI  R26,LOW(1900)
	LDI  R27,HIGH(1900)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07C5     //tangan kiri
; 0000 07C6     servo[17]  = 1200; //L3 - CW
	__POINTW1MN _servo,34
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	CALL SUBOPT_0x71
; 0000 07C7     servo[16]  = 2050; //L2 - naik
; 0000 07C8     servo[15]  = 1100; //L1 - maju
; 0000 07C9     switch(0)
; 0000 07CA         {
; 0000 07CB            case 0 :     //gait  mlaku
	BREQ PC+3
	JMP _0x245
; 0000 07CC                 VY=10;
	CALL SUBOPT_0x72
; 0000 07CD                 if(counterDelay<=0)
	BRGE PC+3
	JMP _0x247
; 0000 07CE                 {
; 0000 07CF                     switch(countTick)
	__GETW1R 13,14
; 0000 07D0                     {
; 0000 07D1                        case 0:
	SBIW R30,0
	BRNE _0x24B
; 0000 07D2                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x79
; 0000 07D3                             X[1]=0; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
	RJMP _0x288
; 0000 07D4                             InputXYZ();
; 0000 07D5                         break;
; 0000 07D6                         case 1:
_0x24B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x24C
; 0000 07D7                             X[0]=-15; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xC2
; 0000 07D8                             X[1]=15; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7B
	RJMP _0x288
; 0000 07D9                             InputXYZ();
; 0000 07DA                         break;
; 0000 07DB                         case 2:
_0x24C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x24D
; 0000 07DC                             X[0]=-15; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xC2
; 0000 07DD                             X[1]=15; Y[1]=25; Z[1]=-50;
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x14
	CALL SUBOPT_0xCE
	CALL SUBOPT_0x80
	__GETD2N 0xC2480000
	RJMP _0x289
; 0000 07DE                             InputXYZ();
; 0000 07DF                         break;
; 0000 07E0                         case 3:
_0x24D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ _0x28A
; 0000 07E1                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 07E2                             X[1]=0; Y[1]=25; Z[1]=0;
; 0000 07E3                             InputXYZ();
; 0000 07E4                         break;
; 0000 07E5                         case 4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x24F
; 0000 07E6                             X[0]=10; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0xC1
	CALL SUBOPT_0x83
	CALL SUBOPT_0xC2
; 0000 07E7                             X[1]=-10; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0xBE
	CALL SUBOPT_0x7B
	RJMP _0x288
; 0000 07E8                             InputXYZ();
; 0000 07E9                         break;
; 0000 07EA                         case 5:
_0x24F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x250
; 0000 07EB                             X[0]=10; Y[0]=0; Z[0]=-40;
	CALL SUBOPT_0xC1
	CALL SUBOPT_0x83
	CALL SUBOPT_0x85
; 0000 07EC                             X[1]=-10; Y[1]=25; Z[1]=0;
	__POINTW1MN _X,4
	CALL SUBOPT_0xBE
	RJMP _0x28B
; 0000 07ED                             InputXYZ();
; 0000 07EE                         break;
; 0000 07EF                         case 6:
_0x250:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x24A
; 0000 07F0                             X[0]=0; Y[0]=0; Z[0]=0;
_0x28A:
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC7
; 0000 07F1                             X[1]=0; Y[1]=25; Z[1]=0;
_0x28B:
	CALL __PUTDZ20
	CALL SUBOPT_0xCE
_0x288:
	CALL __PUTDZ20
	__POINTW1MN _Z,4
	CALL SUBOPT_0x7A
_0x289:
	CALL __PUTDZ20
; 0000 07F2                             InputXYZ();
	CALL _InputXYZ
; 0000 07F3                         break;
; 0000 07F4                     }
_0x24A:
; 0000 07F5                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2B
	BRNE _0x253
	CALL SUBOPT_0x73
	BREQ _0x252
_0x253:
; 0000 07F6                     {
; 0000 07F7                         countTick++;
	CALL SUBOPT_0x74
; 0000 07F8                         if(countTick>6)
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x255
; 0000 07F9                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 07FA                     }
_0x255:
; 0000 07FB                     else
	RJMP _0x256
_0x252:
; 0000 07FC                     {
; 0000 07FD                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 07FE                     }
_0x256:
; 0000 07FF 
; 0000 0800                     counterDelay=60; //65 80
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x75
; 0000 0801                 }
; 0000 0802             break;
_0x247:
; 0000 0803         }
_0x245:
; 0000 0804 
; 0000 0805         speed=1; //10
	CALL SUBOPT_0x76
; 0000 0806         if(counterTG>speed)
	BRGE _0x257
; 0000 0807         {
; 0000 0808             counterTG=0;
	CALL SUBOPT_0x77
; 0000 0809             taskGerakan();
; 0000 080A         }
; 0000 080B  }
_0x257:
	RET
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
	ST   -Y,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
_put_usart_G100:
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1
	ADIW R28,3
	RET
__ftoe_G100:
	CALL SUBOPT_0xCF
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200001F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20A0008
_0x200001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200001E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20A0008
_0x200001E:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x2000021
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x2000021:
	LDD  R17,Y+11
_0x2000022:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000024
	CALL SUBOPT_0xD0
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	CALL SUBOPT_0xD0
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	CALL SUBOPT_0xD1
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000027
	CALL SUBOPT_0xD0
_0x2000028:
	CALL SUBOPT_0xD1
	BRLO _0x200002A
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD3
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0xD1
	BRSH _0x200002E
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD4
	CALL SUBOPT_0xD5
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0xD0
_0x200002B:
	__GETD1S 12
	CALL SUBOPT_0xD6
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xD1
	BRLO _0x200002F
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD3
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2000032
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xD6
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0xD9
	CALL SUBOPT_0xD2
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xDA
	CALL SUBOPT_0xDB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x46
	CALL SUBOPT_0xD5
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0xDA
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0xDD
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2000034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000114
_0x2000034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000114:
	ST   X,R30
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xDD
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0xDD
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0008:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x1
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200003C
	CPI  R18,37
	BRNE _0x200003D
	LDI  R17,LOW(1)
	RJMP _0x200003E
_0x200003D:
	CALL SUBOPT_0xDE
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	CALL SUBOPT_0xDE
	RJMP _0x2000115
_0x2000040:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000041
	LDI  R16,LOW(1)
	RJMP _0x200003B
_0x2000041:
	CPI  R18,43
	BRNE _0x2000042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000042:
	CPI  R18,32
	BRNE _0x2000043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000043:
	RJMP _0x2000044
_0x200003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000045
_0x2000044:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000046
	ORI  R16,LOW(128)
	RJMP _0x200003B
_0x2000046:
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x3)
	BRNE _0x2000048
_0x2000047:
	CPI  R18,48
	BRLO _0x200004A
	CPI  R18,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200003B
_0x2000049:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200004C
	LDI  R17,LOW(4)
	RJMP _0x200003B
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x4)
	BRNE _0x200004F
	CPI  R18,48
	BRLO _0x2000051
	CPI  R18,58
	BRLO _0x2000052
_0x2000051:
	RJMP _0x2000050
_0x2000052:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200003B
_0x2000050:
_0x200004D:
	CPI  R18,108
	BRNE _0x2000053
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200003B
_0x2000053:
	RJMP _0x2000054
_0x200004F:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x200003B
_0x2000054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	CALL SUBOPT_0xDF
	CALL SUBOPT_0xE0
	CALL SUBOPT_0xDF
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xE1
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0x45)
	BREQ _0x200005D
	CPI  R30,LOW(0x65)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0xE2
	CALL __GETD1P
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE4
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	RJMP _0x2000064
_0x2000061:
	CALL SUBOPT_0xE5
	CALL __ANEGF1
	CALL SUBOPT_0xE3
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000065
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0xE1
	RJMP _0x2000066
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000066:
_0x2000064:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000068
	CALL SUBOPT_0xE5
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000069
_0x2000068:
	CALL SUBOPT_0xE5
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000069:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0xE6
	RJMP _0x200006A
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006C
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xE6
	RJMP _0x200006D
_0x200006C:
	CPI  R30,LOW(0x70)
	BRNE _0x200006F
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE7
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200006D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000071
	CP   R20,R17
	BRLO _0x2000072
_0x2000071:
	RJMP _0x2000070
_0x2000072:
	MOV  R17,R20
_0x2000070:
_0x200006A:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2000073
_0x200006F:
	CPI  R30,LOW(0x64)
	BREQ _0x2000076
	CPI  R30,LOW(0x69)
	BRNE _0x2000077
_0x2000076:
	ORI  R16,LOW(4)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x75)
	BRNE _0x2000079
_0x2000078:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0xE8
	LDI  R17,LOW(10)
	RJMP _0x200007B
_0x200007A:
	__GETD1N 0x2710
	CALL SUBOPT_0xE8
	LDI  R17,LOW(5)
	RJMP _0x200007B
_0x2000079:
	CPI  R30,LOW(0x58)
	BRNE _0x200007D
	ORI  R16,LOW(8)
	RJMP _0x200007E
_0x200007D:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000BC
_0x200007E:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000080
	__GETD1N 0x10000000
	CALL SUBOPT_0xE8
	LDI  R17,LOW(8)
	RJMP _0x200007B
_0x2000080:
	__GETD1N 0x1000
	CALL SUBOPT_0xE8
	LDI  R17,LOW(4)
_0x200007B:
	CPI  R20,0
	BREQ _0x2000081
	ANDI R16,LOW(127)
	RJMP _0x2000082
_0x2000081:
	LDI  R20,LOW(1)
_0x2000082:
	SBRS R16,1
	RJMP _0x2000083
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE2
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000116
_0x2000083:
	SBRS R16,2
	RJMP _0x2000085
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE7
	CALL __CWD1
	RJMP _0x2000116
_0x2000085:
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE7
	CLR  R22
	CLR  R23
_0x2000116:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000087
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000088
	CALL SUBOPT_0xE5
	CALL __ANEGD1
	CALL SUBOPT_0xE3
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000088:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000089
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200008A
_0x2000089:
	ANDI R16,LOW(251)
_0x200008A:
_0x2000087:
	MOV  R19,R20
_0x2000073:
	SBRC R16,0
	RJMP _0x200008B
_0x200008C:
	CP   R17,R21
	BRSH _0x200008F
	CP   R19,R21
	BRLO _0x2000090
_0x200008F:
	RJMP _0x200008E
_0x2000090:
	SBRS R16,7
	RJMP _0x2000091
	SBRS R16,2
	RJMP _0x2000092
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2000093
_0x2000092:
	LDI  R18,LOW(48)
_0x2000093:
	RJMP _0x2000094
_0x2000091:
	LDI  R18,LOW(32)
_0x2000094:
	CALL SUBOPT_0xDE
	SUBI R21,LOW(1)
	RJMP _0x200008C
_0x200008E:
_0x200008B:
_0x2000095:
	CP   R17,R20
	BRSH _0x2000097
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000098
	CALL SUBOPT_0xE9
	BREQ _0x2000099
	SUBI R21,LOW(1)
_0x2000099:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000098:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0xE1
	CPI  R21,0
	BREQ _0x200009A
	SUBI R21,LOW(1)
_0x200009A:
	SUBI R20,LOW(1)
	RJMP _0x2000095
_0x2000097:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009B
_0x200009C:
	CPI  R19,0
	BREQ _0x200009E
	SBRS R16,3
	RJMP _0x200009F
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A0
_0x200009F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A0:
	CALL SUBOPT_0xDE
	CPI  R21,0
	BREQ _0x20000A1
	SUBI R21,LOW(1)
_0x20000A1:
	SUBI R19,LOW(1)
	RJMP _0x200009C
_0x200009E:
	RJMP _0x20000A2
_0x200009B:
_0x20000A4:
	CALL SUBOPT_0xEA
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A6
	SBRS R16,3
	RJMP _0x20000A7
	SUBI R18,-LOW(55)
	RJMP _0x20000A8
_0x20000A7:
	SUBI R18,-LOW(87)
_0x20000A8:
	RJMP _0x20000A9
_0x20000A6:
	SUBI R18,-LOW(48)
_0x20000A9:
	SBRC R16,4
	RJMP _0x20000AB
	CPI  R18,49
	BRSH _0x20000AD
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AC
_0x20000AD:
	RJMP _0x20000AF
_0x20000AC:
	CP   R20,R19
	BRSH _0x2000117
	CP   R21,R19
	BRLO _0x20000B2
	SBRS R16,0
	RJMP _0x20000B3
_0x20000B2:
	RJMP _0x20000B1
_0x20000B3:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B4
_0x2000117:
	LDI  R18,LOW(48)
_0x20000AF:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B5
	CALL SUBOPT_0xE9
	BREQ _0x20000B6
	SUBI R21,LOW(1)
_0x20000B6:
_0x20000B5:
_0x20000B4:
_0x20000AB:
	CALL SUBOPT_0xDE
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
_0x20000B7:
_0x20000B1:
	SUBI R19,LOW(1)
	CALL SUBOPT_0xEA
	CALL __MODD21U
	CALL SUBOPT_0xE3
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0xE8
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A5
	RJMP _0x20000A4
_0x20000A5:
_0x20000A2:
	SBRS R16,0
	RJMP _0x20000B8
_0x20000B9:
	CPI  R21,0
	BREQ _0x20000BB
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xE1
	RJMP _0x20000B9
_0x20000BB:
_0x20000B8:
_0x20000BC:
_0x200005A:
_0x2000115:
	LDI  R17,LOW(0)
_0x200003B:
	RJMP _0x2000036
_0x2000038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_atoi:
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
_ftoa:
	CALL SUBOPT_0xCF
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	CALL SUBOPT_0xEB
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20A0007
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0xEB
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20A0007
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xED
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xEF
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0xF0
	CALL __ADDF12
	CALL SUBOPT_0xEC
	LDI  R17,LOW(0)
	CALL SUBOPT_0xF1
	CALL SUBOPT_0xEF
_0x2020014:
	CALL SUBOPT_0xF0
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xD4
	CALL SUBOPT_0xEF
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0xEB
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x20A0007
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0xED
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xD6
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0xEF
	CALL SUBOPT_0xF0
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xED
	CALL SUBOPT_0xDB
	LDI  R31,0
	CALL SUBOPT_0xEE
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x46
	CALL SUBOPT_0xEC
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0006
	CALL SUBOPT_0xED
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xD4
	CALL SUBOPT_0xEC
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xED
	CALL SUBOPT_0xDB
	LDI  R31,0
	CALL SUBOPT_0xF2
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x46
	CALL SUBOPT_0xEC
	RJMP _0x202001E
_0x2020020:
_0x20A0006:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG
_ftrunc:
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0xF3
	CALL _ftrunc
	CALL SUBOPT_0xF4
    brne __floor1
__floor0:
	CALL SUBOPT_0xF5
	RJMP _0x20A0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0xF6
	RJMP _0x20A0004
_sin:
	CALL SUBOPT_0xF7
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0xF8
	RCALL _floor
	CALL SUBOPT_0xF9
	CALL SUBOPT_0x46
	CALL SUBOPT_0xF8
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0xFA
	__GETD2N 0x3F000000
	CALL SUBOPT_0xFB
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0xF9
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0xF9
	__GETD1N 0x3F000000
	CALL SUBOPT_0xFB
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0xFC
_0x2040019:
	CALL SUBOPT_0xFD
	__PUTD1S 1
	CALL SUBOPT_0xFE
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x46
	CALL SUBOPT_0xFF
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0xF9
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xFE
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0xFF
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20A0005
_cos:
	CALL SUBOPT_0xF3
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	RJMP _0x20A0002
_xatan:
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0xD9
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xF4
	CALL SUBOPT_0xF5
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x100
	CALL SUBOPT_0xDC
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF5
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x101
	CALL SUBOPT_0x100
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0xF3
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x101
	RCALL _xatan
	RJMP _0x20A0002
_0x2040020:
	CALL SUBOPT_0x101
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0xF6
	CALL SUBOPT_0x102
	RJMP _0x20A0003
_0x2040021:
	CALL SUBOPT_0xF6
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF6
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x102
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20A0002
_asin:
	CALL SUBOPT_0xF7
	CALL SUBOPT_0x103
	BRLO _0x2040023
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xF1
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2040023
	RJMP _0x2040022
_0x2040023:
	CALL SUBOPT_0x104
	RJMP _0x20A0005
_0x2040022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2040025
	CALL SUBOPT_0xFC
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0xFD
	__GETD2N 0x3F800000
	CALL SUBOPT_0x46
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0xF9
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0xFA
	__GETD2S 1
	CALL SUBOPT_0x105
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x46
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0xFE
	CALL SUBOPT_0xF9
	CALL SUBOPT_0x105
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0xFE
	CALL __ANEGF1
	RJMP _0x20A0005
_0x2040028:
	CALL SUBOPT_0xFE
_0x20A0005:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_acos:
	CALL SUBOPT_0xF3
	CALL SUBOPT_0x103
	BRLO _0x204002A
	CALL SUBOPT_0x101
	CALL SUBOPT_0xF1
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x204002A
	RJMP _0x2040029
_0x204002A:
	CALL SUBOPT_0x104
	RJMP _0x20A0002
_0x2040029:
	CALL SUBOPT_0x101
	RCALL _asin
_0x20A0003:
	__GETD2N 0x3FC90FDB
	CALL __SWAPD12
_0x20A0004:
	CALL __SUBF12
_0x20A0002:
	ADIW R28,4
	RET
_atan2:
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0xD9
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	CALL SUBOPT_0x104
	RJMP _0x20A0001
_0x204002E:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x204002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20A0001
_0x204002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20A0001
_0x204002D:
	CALL SUBOPT_0xD9
	__GETD2S 8
	CALL __DIVF21
	CALL SUBOPT_0xF4
	CALL SUBOPT_0xD7
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0x101
	RCALL _yatan
	RJMP _0x20A0001
_0x2040031:
	CALL SUBOPT_0x106
	CALL __ANEGF1
	RJMP _0x20A0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0x106
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x46
	RJMP _0x20A0001
_0x2040032:
	CALL SUBOPT_0x101
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20A0001:
	ADIW R28,12
	RET

	.CSEG
_isdigit:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret

	.CSEG
_strcpyf:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_servoInitError:
	.BYTE 0x28

	.ESEG
_eServoInitError:
	.DB  0xDD,0xFF,0x17,0x0
	.DB  0xF5,0xFF,0xE9,0xFF
	.DB  0xD3,0xFF,0x0,0x0
	.DB  0x2F,0x0,0xF0,0xFF
	.DB  0x19,0x0,0xB9,0xFF
	.DB  0x32,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

	.DSEG
_servo:
	.BYTE 0x28
_servoSet:
	.BYTE 0x28
_counterTG:
	.BYTE 0x2
_counterDelay:
	.BYTE 0x2
_countGerakan:
	.BYTE 0x2
_I:
	.BYTE 0x2
_index:
	.BYTE 0x2
_langkah:
	.BYTE 0x2
_langkahMax:
	.BYTE 0x2
_jumlahGerak:
	.BYTE 0x2
_speed:
	.BYTE 0x2
_countNo:
	.BYTE 0x2
_VX:
	.BYTE 0x4
_VY:
	.BYTE 0x4
_VZ:
	.BYTE 0x4
_W:
	.BYTE 0x4
_initPositionX:
	.BYTE 0x4
_initPositionY:
	.BYTE 0x4
_initPositionZ:
	.BYTE 0x4
_L1:
	.BYTE 0x4
_L2:
	.BYTE 0x4
_L3:
	.BYTE 0x4
_L4:
	.BYTE 0x4
_X:
	.BYTE 0x8
_Y:
	.BYTE 0x8
_Z:
	.BYTE 0x8
_Xset:
	.BYTE 0x8
_Yset:
	.BYTE 0x8
_Zset:
	.BYTE 0x8
_Xerror:
	.BYTE 0x8
_Yerror:
	.BYTE 0x8
_Zerror:
	.BYTE 0x8
_L1Kuadrat:
	.BYTE 0x4
_L2Kuadrat:
	.BYTE 0x4
_L3Kuadrat:
	.BYTE 0x4
_L4Kuadrat:
	.BYTE 0x4
_XiKuadrat:
	.BYTE 0x4
_YiKuadrat:
	.BYTE 0x4
_ZiKuadrat:
	.BYTE 0x4
_bi:
	.BYTE 0x4
_biKuadrat:
	.BYTE 0x4
_ai:
	.BYTE 0x4
_aiKuadrat:
	.BYTE 0x4
_ci:
	.BYTE 0x4
_gamai:
	.BYTE 0x4
_betai:
	.BYTE 0x4
_alphai:
	.BYTE 0x8
_A1:
	.BYTE 0x8
_A2:
	.BYTE 0x8
_A3:
	.BYTE 0x8
_A5:
	.BYTE 0x8
_rad:
	.BYTE 0x4
_sudutSet:
	.BYTE 0x50
_state:
	.BYTE 0x2
_cariBola:
	.BYTE 0x2
_jalan:
	.BYTE 0x2
_de:
	.BYTE 0x2
_kondisiAmbrukDepan:
	.BYTE 0x2
_kondisiAmbrukBelakang:
	.BYTE 0x2
_hitungNgawur:
	.BYTE 0x2
_delayNgawur:
	.BYTE 0x2
_hitungWaras:
	.BYTE 0x2
_delayWaras:
	.BYTE 0x2
_hitungTendang:
	.BYTE 0x2
_spx:
	.BYTE 0x2
_spy:
	.BYTE 0x2
_errorx:
	.BYTE 0x2
_errory:
	.BYTE 0x2
_px:
	.BYTE 0x2
_py:
	.BYTE 0x2
_mvx:
	.BYTE 0x2
_mvy:
	.BYTE 0x2
_sudah:
	.BYTE 0x2
_Timeslot2:
	.BYTE 0x1
_miringDepan:
	.BYTE 0x2
_miringSamping:
	.BYTE 0x2
_kompas:
	.BYTE 0x2
_pos_x:
	.BYTE 0x2
_pos_y:
	.BYTE 0x2
_DataMasuk:
	.BYTE 0xA
_DataRx:
	.BYTE 0x1
_CountRx:
	.BYTE 0x1
_count:
	.BYTE 0x2
_hitung:
	.BYTE 0x2
_countBall:
	.BYTE 0x2
_Ball:
	.BYTE 0x2
_xx:
	.BYTE 0x2
_yy:
	.BYTE 0x2
_DataR1:
	.BYTE 0x4
_DataR2:
	.BYTE 0x4
_CountR1:
	.BYTE 0x1
_CountR0:
	.BYTE 0x1
_DataRRx:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	LDS  R26,_counterDelay
	LDS  R27,_counterDelay+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R26,_L1
	LDS  R27,_L1+1
	LDS  R24,_L1+2
	LDS  R25,_L1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R30,_L2
	LDS  R31,_L2+1
	LDS  R22,_L2+2
	LDS  R23,_L2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R26,_L2
	LDS  R27,_L2+1
	LDS  R24,_L2+2
	LDS  R25,_L2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8:
	LDS  R26,_L3
	LDS  R27,_L3+1
	LDS  R24,_L3+2
	LDS  R25,_L3+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_L4
	LDS  R27,_L4+1
	LDS  R24,_L4+2
	LDS  R25,_L4+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _countNo,R30
	STS  _countNo+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0xC:
	LDS  R30,_countNo
	LDS  R31,_countNo+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_Xset)
	LDI  R27,HIGH(_Xset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R26,_initPositionX
	LDS  R27,_initPositionX+1
	LDS  R24,_initPositionX+2
	LDS  R25,_initPositionX+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __PUTDZ20
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_Yset)
	LDI  R27,HIGH(_Yset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R26,_initPositionY
	LDS  R27,_initPositionY+1
	LDS  R24,_initPositionY+2
	LDS  R25,_initPositionY+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_Zset)
	LDI  R27,HIGH(_Zset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R26,_initPositionZ
	LDS  R27,_initPositionZ+1
	LDS  R24,_initPositionZ+2
	LDS  R25,_initPositionZ+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0x14:
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_countNo)
	LDI  R27,HIGH(_countNo)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:144 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
	__POINTW1MN _X,4
	__GETD2N 0x0
	RCALL SUBOPT_0x14
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0x14
	__POINTW1MN _Z,4
	__GETD2N 0x0
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x19:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(180)
	SBCI R31,HIGH(180)
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x1B:
	ADD  R30,R26
	ADC  R31,R27
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x1C:
	SUBI R30,LOW(-59536)
	SBCI R31,HIGH(-59536)
	MOV  R30,R31
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(6000)
	LDI  R27,HIGH(6000)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1F:
	ADD  R30,R26
	LSL  R30
	LDI  R26,LOW(112)
	CALL __SWAPB12
	SUB  R30,R26
	SUBI R30,-LOW(144)
	STS  138,R30
	LDI  R30,LOW(232)
	STS  133,R30
	LDI  R30,LOW(144)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	ADD  R30,R26
	LSL  R30
	LDI  R26,LOW(112)
	CALL __SWAPB12
	SUB  R30,R26
	SUBI R30,-LOW(144)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x21:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  138,R30
	LDI  R30,LOW(232)
	STS  133,R30
	LDI  R30,LOW(144)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDS  R30,_Timeslot2
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  152,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x24:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  154,R30
	LDI  R30,LOW(232)
	STS  149,R30
	LDI  R30,LOW(144)
	STS  148,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__GETW1MN _servo,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x26:
	__GETW1MN _servo,38
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDS  R26,_hitungNgawur
	LDS  R27,_hitungNgawur+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDS  R26,_hitungWaras
	LDS  R27,_hitungWaras+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(232)
	STS  149,R30
	LDI  R30,LOW(144)
	STS  148,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	LDS  R26,_Ball
	LDS  R27,_Ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x2B:
	LDS  R26,_VX
	LDS  R27,_VX+1
	LDS  R24,_VX+2
	LDS  R25,_VX+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDS  R26,_VY
	LDS  R27,_VY+1
	LDS  R24,_VY+2
	LDS  R25,_VY+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDS  R26,_W
	LDS  R27,_W+1
	LDS  R24,_W+2
	LDS  R25,_W+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDS  R30,_langkahMax
	LDS  R31,_langkahMax+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0xC
	LDI  R26,LOW(_Xerror)
	LDI  R27,HIGH(_Xerror)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0xC
	LDI  R26,LOW(_X)
	LDI  R27,HIGH(_X)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x31:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x32:
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x2E
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	CALL __PUTDP1
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x34:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	CALL __LSLW2
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0xC
	LDI  R26,LOW(_servoSet)
	LDI  R27,HIGH(_servoSet)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x37:
	LDS  R30,_I
	LDS  R31,_I+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	MOVW R26,R30
	MOVW R24,R22
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDS  R26,_bi
	LDS  R27,_bi+1
	LDS  R24,_bi+2
	LDS  R25,_bi+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDS  R30,_ai
	LDS  R31,_ai+1
	LDS  R22,_ai+2
	LDS  R23,_ai+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	CALL __PUTDP1
	RCALL SUBOPT_0x37
	LDI  R26,LOW(_A3)
	LDI  R27,HIGH(_A3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDS  R26,_L2Kuadrat
	LDS  R27,_L2Kuadrat+1
	LDS  R24,_L2Kuadrat+2
	LDS  R25,_L2Kuadrat+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0x6
	__GETD2N 0x40000000
	CALL __MULF12
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _acos

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	CALL __ADDF12
	CALL __ANEGF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x41:
	LDS  R30,_rad
	LDS  R31,_rad+1
	LDS  R22,_rad+2
	LDS  R23,_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	CALL __MULF12
	__GETD2N 0x42B40000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	__PUTD1MN _sudutSet,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	CALL __MULF12
	__GETD2N 0x43340000
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__GETD1MN _sudutSet,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x46:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	__GETD2N 0x40A00000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	LDS  R26,_rad
	LDS  R27,_rad+1
	LDS  R24,_rad+2
	LDS  R25,_rad+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	__PUTD1MN _sudutSet,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4A:
	LDS  R26,_rad
	LDS  R27,_rad+1
	LDS  R24,_rad+2
	LDS  R25,_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	__GETD1MN _sudutSet,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _state,R30
	STS  _state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4D:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x4E:
	LDS  R26,_pos_x
	LDS  R27,_pos_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x4F:
	LDS  R30,_spx
	LDS  R31,_spx+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _errorx,R30
	STS  _errorx+1,R31
	LDS  R26,_errorx
	LDS  R27,_errorx+1
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	CALL __DIVW21
	STS  _px,R30
	STS  _px+1,R31
	LDS  R26,_mvx
	LDS  R27,_mvx+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _mvx,R30
	STS  _mvx+1,R31
	__PUTW1MN _servo,38
	LDS  R26,_mvx
	LDS  R27,_mvx+1
	CPI  R26,LOW(0x8FC)
	LDI  R30,HIGH(0x8FC)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x50:
	LDS  R26,_mvx
	LDS  R27,_mvx+1
	CPI  R26,LOW(0x2BD)
	LDI  R30,HIGH(0x2BD)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x51:
	LDS  R26,_pos_y
	LDS  R27,_pos_y+1
	LDS  R30,_spy
	LDS  R31,_spy+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _errory,R30
	STS  _errory+1,R31
	LDS  R26,_errory
	LDS  R27,_errory+1
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	CALL __DIVW21
	STS  _py,R30
	STS  _py+1,R31
	LDS  R26,_py
	LDS  R27,_py+1
	LDS  R30,_mvy
	LDS  R31,_mvy+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _mvy,R30
	STS  _mvy+1,R31
	__PUTW1MN _servo,36
	LDS  R26,_mvy
	LDS  R27,_mvy+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x53:
	LDS  R30,_delayNgawur
	LDS  R31,_delayNgawur+1
	STS  _hitungNgawur,R30
	STS  _hitungNgawur+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cariBola,R30
	STS  _cariBola+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x55:
	RCALL SUBOPT_0x4E
	CPI  R26,LOW(0x119)
	LDI  R30,HIGH(0x119)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jalan,R30
	STS  _jalan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _state,R30
	STS  _state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _jalan,R30
	STS  _jalan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x59:
	LDS  R26,_miringDepan
	LDS  R27,_miringDepan+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(65496)
	LDI  R31,HIGH(65496)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5B:
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5C:
	STS  _state,R30
	STS  _state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	RCALL SUBOPT_0x59
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5E:
	LDI  R30,LOW(0)
	STS  _sudah,R30
	STS  _sudah+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x60:
	LDS  R26,_sudah
	LDS  R27,_sudah+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	CALL _pid_servo
	RCALL SUBOPT_0x2A
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x62:
	__GETW2MN _servo,38
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x63:
	__POINTW1MN _servo,38
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x64:
	LDS  R30,_Ball
	LDS  R31,_Ball+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x65:
	CALL _nek_ambruk
	__GETW2MN _servo,36
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	__POINTW1MN _servo,36
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x67:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	CALL __CWD1
	CALL __PUTPARD1
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x68:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	LDS  R30,_hitungNgawur
	LDS  R31,_hitungNgawur+1
	RJMP SUBOPT_0x68

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	__PUTW1MN _servo,38
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6C:
	STS  _mvx,R30
	STS  _mvx+1,R31
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	STS  _mvy,R30
	STS  _mvy+1,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6E:
	LDS  R30,_delayWaras
	LDS  R31,_delayWaras+1
	STS  _hitungWaras,R30
	STS  _hitungWaras+1,R31
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(1800)
	LDI  R27,HIGH(1800)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x70:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,26
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,24
	LDI  R26,LOW(1900)
	LDI  R27,HIGH(1900)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x71:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,32
	LDI  R26,LOW(2050)
	LDI  R27,HIGH(2050)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,30
	LDI  R26,LOW(1100)
	LDI  R27,HIGH(1100)
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R30,LOW(0)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x72:
	__GETD1N 0x41200000
	STS  _VY,R30
	STS  _VY+1,R31
	STS  _VY+2,R22
	STS  _VY+3,R23
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:137 WORDS
SUBOPT_0x73:
	LDS  R26,_VY
	LDS  R27,_VY+1
	LDS  R24,_VY+2
	LDS  R25,_VY+3
	__GETD1N 0x0
	CALL __NED12
	MOV  R0,R30
	LDS  R26,_W
	LDS  R27,_W+1
	LDS  R24,_W+2
	LDS  R25,_W+3
	__GETD1N 0x0
	CALL __NED12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x75:
	STS  _counterDelay,R30
	STS  _counterDelay+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x76:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _speed,R30
	STS  _speed+1,R31
	LDS  R26,_counterTG
	LDS  R27,_counterTG+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(0)
	STS  _counterTG,R30
	STS  _counterTG+1,R30
	JMP  _taskGerakan

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x78:
	__POINTW1MN _servo,28
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x79:
	LDI  R30,LOW(0)
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
	__POINTW1MN _X,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x7A:
	__GETD2N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x7B:
	RCALL SUBOPT_0x14
	__POINTW1MN _Y,4
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x7C:
	__GETD1N 0xC1200000
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
	__POINTW1MN _X,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7D:
	__GETD2N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7E:
	__GETD2N 0x41700000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	__POINTW1MN _Y,4
	__GETD2N 0xC1200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x80:
	RCALL SUBOPT_0x14
	__POINTW1MN _Z,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	__GETD2N 0xC2200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x82:
	LDI  R30,LOW(0)
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:109 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(0)
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x84:
	__GETD1N 0x41A00000
	STS  _Y,R30
	STS  _Y+1,R31
	STS  _Y+2,R22
	STS  _Y+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x85:
	__GETD1N 0xC2200000
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x86:
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x87:
	CALL __SAVELOCR4
	__GETWRN 16,17,1000
	__GETWRN 18,19,50
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x88:
	__POINTW1MN _servo,36
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,38
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,10
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,8
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,6
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,4
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,2
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	STS  _servo,R30
	STS  _servo+1,R31
	__POINTW1MN _servo,22
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,20
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,18
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,16
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,14
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x89:
	__POINTW1MN _servo,12
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x78

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x8A:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 161 TIMES, CODE SIZE REDUCTION:317 WORDS
SUBOPT_0x8B:
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x8C:
	__POINTW1MN _servo,24
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x8D:
	__POINTW1MN _servo,30
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8E:
	__POINTW1MN _servo,32
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8F:
	__POINTW1MN _servo,34
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x90:
	__POINTW1MN _servo,10
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x91:
	__POINTW1MN _servo,8
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x92:
	__POINTW1MN _servo,6
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x93:
	__POINTW1MN _servo,4
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x94:
	__POINTW1MN _servo,2
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x95:
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	STS  _servo,R30
	STS  _servo+1,R31
	__POINTW1MN _servo,22
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x96:
	__POINTW1MN _servo,20
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x97:
	__POINTW1MN _servo,18
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x98:
	__POINTW1MN _servo,16
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x99:
	__POINTW1MN _servo,14
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9A:
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9B:
	__POINTW1MN _servo,32
	LDI  R26,LOW(2100)
	LDI  R27,HIGH(2100)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x8F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9C:
	__POINTW1MN _servo,6
	RJMP SUBOPT_0x9A

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9D:
	LDI  R26,LOW(2100)
	LDI  R27,HIGH(2100)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x9E:
	__POINTW1MN _servo,12
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x9F:
	__POINTW1MN _servo,28
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP SUBOPT_0x8A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA0:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0xA1:
	__POINTW1MN _servo,6
	LDI  R26,LOW(984)
	LDI  R27,HIGH(984)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,4
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,2
	LDI  R26,LOW(1006)
	LDI  R27,HIGH(1006)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x95

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xA2:
	__POINTW1MN _servo,18
	LDI  R26,LOW(984)
	LDI  R27,HIGH(984)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,16
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,14
	LDI  R26,LOW(1006)
	LDI  R27,HIGH(1006)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x89

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA3:
	__POINTW1MN _servo,32
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x8D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA4:
	__POINTW1MN _servo,18
	LDI  R26,LOW(984)
	LDI  R27,HIGH(984)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,16
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,14
	LDI  R26,LOW(1006)
	LDI  R27,HIGH(1006)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x9E

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA5:
	__POINTW1MN _servo,34
	LDI  R26,LOW(2500)
	LDI  R27,HIGH(2500)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xA6:
	__POINTW1MN _servo,6
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,4
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA7:
	LDI  R26,LOW(1006)
	LDI  R27,HIGH(1006)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA8:
	LDI  R30,LOW(1460)
	LDI  R31,HIGH(1460)
	STS  _servo,R30
	STS  _servo+1,R31
	__POINTW1MN _servo,22
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA9:
	__POINTW1MN _servo,18
	LDI  R26,LOW(470)
	LDI  R27,HIGH(470)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,16
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,14
	RJMP SUBOPT_0xA7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAA:
	__POINTW1MN _servo,28
	LDI  R26,LOW(460)
	LDI  R27,HIGH(460)
	RJMP SUBOPT_0x8A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAB:
	__POINTW1MN _servo,24
	LDI  R26,LOW(1600)
	LDI  R27,HIGH(1600)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0xA5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAC:
	__POINTW1MN _servo,32
	LDI  R26,LOW(850)
	LDI  R27,HIGH(850)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x8D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xAD:
	__POINTW1MN _servo,6
	LDI  R26,LOW(480)
	LDI  R27,HIGH(480)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,4
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,2
	RJMP SUBOPT_0xA7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xAE:
	__POINTW1MN _servo,18
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,16
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xAF:
	LDI  R26,LOW(2150)
	LDI  R27,HIGH(2150)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,24
	LDI  R26,LOW(1700)
	LDI  R27,HIGH(1700)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0xA5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB0:
	__POINTW1MN _servo,30
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R26,R16
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB1:
	LDI  R26,LOW(1306)
	LDI  R27,HIGH(1306)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB2:
	__POINTW1MN _servo,24
	RJMP SUBOPT_0x6F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB3:
	__POINTW1MN _servo,32
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,30
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R26,R16
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB4:
	__POINTW1MN _servo,28
	LDI  R26,LOW(1600)
	LDI  R27,HIGH(1600)
	RJMP SUBOPT_0x8A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xB5:
	__POINTW1MN _servo,34
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,32
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,30
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R26,R16
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB6:
	__POINTW1MN _servo,4
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,2
	LDI  R26,LOW(1056)
	LDI  R27,HIGH(1056)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x95

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB7:
	__POINTW1MN _servo,16
	LDI  R26,LOW(2508)
	LDI  R27,HIGH(2508)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,14
	LDI  R26,LOW(1056)
	LDI  R27,HIGH(1056)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x9E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB8:
	__POINTW1MN _servo,28
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	RJMP SUBOPT_0x8A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB9:
	__POINTW1MN _servo,32
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,30
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R26,R16
	CALL _delay_ms
	CLR  R13
	CLR  R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xBA:
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
	__POINTW1MN _X,4
	RCALL SUBOPT_0x7A
	RJMP SUBOPT_0x7B

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xBB:
	RCALL SUBOPT_0x14
	JMP  _InputXYZ

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBC:
	__POINTW1MN _X,4
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBD:
	__GETD1N 0xC1200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBE:
	__GETD2N 0xC1200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBF:
	__POINTW1MN _servo,28
	LDI  R26,LOW(1600)
	LDI  R27,HIGH(1600)
	RJMP SUBOPT_0x70

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC0:
	STS  _VY,R30
	STS  _VY+1,R31
	STS  _VY+2,R22
	STS  _VY+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC1:
	__GETD1N 0x41200000
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC2:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x86
	__POINTW1MN _X,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xC3:
	LDS  R30,_VY
	LDS  R31,_VY+1
	LDS  R22,_VY+2
	LDS  R23,_VY+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xC4:
	STS  _Y,R30
	STS  _Y+1,R31
	STS  _Y+2,R22
	STS  _Y+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC5:
	RCALL SUBOPT_0x7D
	RCALL SUBOPT_0x14
	RJMP SUBOPT_0xC3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC6:
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC7:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x86
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC8:
	__POINTW1MN _Y,4
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xC9:
	LDS  R30,_VX
	LDS  R31,_VX+1
	LDS  R22,_VX+2
	LDS  R23,_VX+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xCA:
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xCB:
	RCALL SUBOPT_0xC9
	CALL __ANEGF1
	__PUTD1MN _X,4
	RJMP SUBOPT_0xC8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xCC:
	RCALL SUBOPT_0xCA
	RCALL SUBOPT_0xC3
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCD:
	__GETD1N 0xC1700000
	RCALL SUBOPT_0xCA
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCE:
	__POINTW1MN _Y,4
	__GETD2N 0x41C80000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xCF:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xD0:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD1:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD2:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD3:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD4:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD5:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD6:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD7:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD8:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD9:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDA:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDB:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDC:
	RCALL SUBOPT_0xD7
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xDD:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xDE:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xDF:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE0:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE1:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xE2:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE3:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE4:
	RCALL SUBOPT_0xDF
	RJMP SUBOPT_0xE0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE5:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE6:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE7:
	RCALL SUBOPT_0xE2
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE8:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE9:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xEA:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEB:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xEC:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xED:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xEE:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xEF:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF0:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF1:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF2:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF3:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF4:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF5:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF6:
	RCALL SUBOPT_0xF5
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF7:
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF8:
	__PUTD1S 5
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF9:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xFA:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xFB:
	CALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xFC:
	RCALL SUBOPT_0xFA
	CALL __ANEGF1
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xFD:
	RCALL SUBOPT_0xFA
	RCALL SUBOPT_0xF9
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xFE:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xFF:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x100:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x101:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x102:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x103:
	__GETD1N 0xBF800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x104:
	__GETD1N 0x7F7FFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x105:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x106:
	RCALL SUBOPT_0xF5
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	JMP  _yatan


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	rcall __PUTPARD2
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__NED12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRNE __NED12T
	CLR  R30
__NED12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
