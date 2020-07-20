
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
	.DEF _dataRx=R4
	.DEF _countRx=R3
	.DEF _countRxProtokol=R6
	.DEF _delay=R7
	.DEF _countTick=R9
	.DEF _counterTG=R11
	.DEF _counterDelay=R13
	.DEF _Timeslot=R5

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
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
	.DB  0xF
_0x6:
	.DB  0xE8,0x3
_0x7:
	.DB  0x0,0x0,0x44,0x43
_0x8:
	.DB  0x0,0x0,0xA8,0x41
_0x9:
	.DB  0x0,0x0,0xB0,0x42
_0xA:
	.DB  0x0,0x0,0xAC,0x42
_0xB:
	.DB  0x0,0x0,0xA8,0x41
_0xFB:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x41,0x25,0x64,0xA,0x0,0x42,0x25,0x64
	.DB  0xA,0x0,0x3D,0x3D,0x3D,0x58,0x59,0x5A
	.DB  0x20,0x25,0x30,0x2E,0x32,0x66,0x20,0x25
	.DB  0x30,0x2E,0x32,0x66,0x20,0x25,0x30,0x2E
	.DB  0x32,0x66,0x20,0x7C,0x7C,0x20,0x0,0x3D
	.DB  0x3D,0x3D,0x58,0x59,0x5A,0x20,0x25,0x30
	.DB  0x2E,0x32,0x66,0x20,0x25,0x30,0x2E,0x32
	.DB  0x66,0x20,0x25,0x30,0x2E,0x32,0x66,0x20
	.DB  0xA,0x0,0x58,0x59,0x5A,0x73,0x65,0x74
	.DB  0x20,0x25,0x30,0x2E,0x32,0x66,0x20,0x25
	.DB  0x30,0x2E,0x32,0x66,0x20,0x25,0x30,0x2E
	.DB  0x32,0x66,0x20,0x7C,0x7C,0x20,0x0,0x58
	.DB  0x59,0x5A,0x73,0x65,0x74,0x20,0x25,0x30
	.DB  0x2E,0x32,0x66,0x20,0x25,0x30,0x2E,0x32
	.DB  0x66,0x20,0x25,0x30,0x2E,0x32,0x66,0x20
	.DB  0xA,0x0,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x5A,0x69,0x6E,0x20,0x25
	.DB  0x30,0x2E,0x66,0x20,0xA,0x0
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

	.DW  0x04
	.DW  0x03
	.DW  _0xFB*2

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
;void mlayu();
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
;dataRx = 0,
;countRx = 0,
;countRxProtokol = 0,
;dataMasuk[8]
; 0000 0031 ;
;
;// Declare your global variables here
;int
;delay,
;countTick,
;counterTG,
;counterDelay,
;countGerakan,
;I,
;index,
;langkah,
;langkahMax=15,  //15
;jumlahGerak,
;speed,
;delay_gait = 1000,
;countNo
; 0000 0042 ;
;
;double
;VX,VY,W,
;initPositionX=0,
;initPositionY=0,
;initPositionZ=196,             //196 216
;L1=21,
;L2=88,
;L3=86,
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
; 0000 0058 ;
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
;
;#define kaka1_0   PORTL &= ~(1 << 2) //PORTL.2 logika 0(LOW)
;#define kaka2_0   PORTL &= ~(1 << 3) //PORTL.3 logika 0(LOW)
;#define kaka3_0   PORTL &= ~(1 << 4)
;#define kaka4_0   PORTL &= ~(1 << 5)
;#define kaka5_0   PORTL &= ~(1 << 6)
;#define kaka6_0   PORTL &= ~(1 << 7)
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
;interrupt [TIM1_OVF] void timer1_ovf_isr(void);
;interrupt [TIM1_COMPA] void timer1_compa_isr(void);
;interrupt [TIM1_COMPB] void timer1_compb_isr(void);
;interrupt [TIM3_OVF] void timer3_ovf_isr(void);
;interrupt [TIM3_COMPA] void timer3_compa_isr(void);
;interrupt [TIM3_COMPB] void timer3_compb_isr(void);
;interrupt [USART0_RXC] void usart0_rx_isr(void);
;interrupt [TIM2_OVF] void timer2_ovf_isr(void);
;void init();
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0059 {

	.CSEG
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    TCNT2=240;
	LDI  R30,LOW(240)
	STS  178,R30
;    counterTG++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;    if(counterDelay>0)
	CLR  R0
	CP   R0,R13
	CPC  R0,R14
	BRGE _0xC
;        counterDelay--;
	__GETW1R 13,14
	SBIW R30,1
	__PUTW1R 13,14
;}
_0xC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
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
;    UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
;    UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
;    UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
;    UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
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
	CALL SUBOPT_0x0
	CALL __MULF12
	STS  _L1Kuadrat,R30
	STS  _L1Kuadrat+1,R31
	STS  _L1Kuadrat+2,R22
	STS  _L1Kuadrat+3,R23
;    L2Kuadrat = L2 * L2;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
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
	CALL SUBOPT_0x3
	STS  _L3Kuadrat,R30
	STS  _L3Kuadrat+1,R31
	STS  _L3Kuadrat+2,R22
	STS  _L3Kuadrat+3,R23
;    L4Kuadrat = L4 * L4;
	LDS  R30,_L4
	LDS  R31,_L4+1
	LDS  R22,_L4+2
	LDS  R23,_L4+3
	CALL SUBOPT_0x4
	CALL __MULF12
	STS  _L4Kuadrat,R30
	STS  _L4Kuadrat+1,R31
	STS  _L4Kuadrat+2,R22
	STS  _L4Kuadrat+3,R23
;
;    for (countNo = 0; countNo < 2; countNo++) {
	CALL SUBOPT_0x5
_0xE:
	CALL SUBOPT_0x6
	BRGE _0xF
;      Xset[countNo] = initPositionX; Yset[countNo] = initPositionY; Zset[countNo] = initPositionZ;
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;    }
	CALL SUBOPT_0x10
	RJMP _0xE
_0xF:
;
;    X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x11
;    X[1]=0; Y[1]=0; Z[1]=0;
;
;    for(index=0;index<20;index++)
	LDI  R30,LOW(0)
	STS  _index,R30
	STS  _index+1,R30
_0x11:
	LDS  R26,_index
	LDS  R27,_index+1
	SBIW R26,20
	BRGE _0x12
;    {
;        servoInitError[index]=eServoInitError[index];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x12
	LDI  R26,LOW(_eServoInitError)
	LDI  R27,HIGH(_eServoInitError)
	CALL SUBOPT_0x14
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
;        printf("A%d\n",index);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
;        printf("B%d\n",servoInitError[index]);
	__POINTW1FN _0x0,5
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CALL SUBOPT_0x15
;        delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
;    }
	LDI  R26,LOW(_index)
	LDI  R27,HIGH(_index)
	CALL SUBOPT_0x16
	RJMP _0x11
_0x12:
;
;}
	RET
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)
;{
_usart0_rx_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;  dataRx = UDR0;
	LDS  R4,198
;  if (countRxProtokol == 2)
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x13
;  {
;    countRxProtokol = 0;
	CLR  R6
;    countRx = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
;  }
;  switch (countRx)
_0x13:
	MOV  R30,R3
	CALL SUBOPT_0x17
;  {
;    case 0 :
	BRNE _0x17
;      if (dataRx == 255)
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x18
;      {
;        countRxProtokol++;
	INC  R6
;      }
;      break;
_0x18:
	RJMP _0x16
;
;    case 1 :
_0x17:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x19
;      if (dataRx == 255)
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x1A
;        countRxProtokol++;
	INC  R6
;      else
	RJMP _0x1B
_0x1A:
;        countRxProtokol = 0;
	CLR  R6
;      dataMasuk[0] = dataRx;
_0x1B:
	STS  _dataMasuk,R4
;      countRx++;
	INC  R3
;      break;
	RJMP _0x16
;
;    case 2 :
_0x19:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1C
;      if (dataRx == 255)
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x1D
;        countRxProtokol++;
	INC  R6
;      else
	RJMP _0x1E
_0x1D:
;        countRxProtokol = 0;
	CLR  R6
;      dataMasuk[1] = dataRx;
_0x1E:
	__PUTBMRN _dataMasuk,1,4
;      dataInt[0] = ((dataMasuk[0] & 0b00000011) << 8) + dataMasuk[1] ;
	LDS  R30,_dataMasuk
	LDI  R31,0
	ANDI R30,LOW(0x3)
	ANDI R31,HIGH(0x3)
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R30
	__GETB1MN _dataMasuk,1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _dataInt,R30
	STS  _dataInt+1,R31
;      if ((dataMasuk[0] & 0b00010000) >> 4)
	LDS  R30,_dataMasuk
	ANDI R30,LOW(0x10)
	LDI  R31,0
	CALL __ASRW4
	SBIW R30,0
	BREQ _0x1F
;        dataInt[0] *= -1;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	STS  _dataInt,R30
	STS  _dataInt+1,R31
;      countRx++;
_0x1F:
	INC  R3
;      break;
	RJMP _0x16
;
;    case 3 :
_0x1C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20
;      if (dataRx == 255)
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x21
;        countRxProtokol++;
	INC  R6
;      else
	RJMP _0x22
_0x21:
;        countRxProtokol = 0;
	CLR  R6
;      dataMasuk[2] = dataRx;
_0x22:
	__PUTBMRN _dataMasuk,2,4
;      data[0] = dataMasuk[2] ;
	__GETB1MN _dataMasuk,2
	LDI  R31,0
	STS  _data,R30
	STS  _data+1,R31
;      if ((dataMasuk[0] & 0b01000000) >> 6)
	LDS  R30,_dataMasuk
	ANDI R30,LOW(0x40)
	LDI  R31,0
	CALL __ASRW2
	CALL __ASRW4
	SBIW R30,0
	BREQ _0x23
;        data[0] *= -1;
	LDS  R30,_data
	LDS  R31,_data+1
	CALL SUBOPT_0x19
	STS  _data,R30
	STS  _data+1,R31
;      countRx++;
_0x23:
	INC  R3
;      break;
	RJMP _0x16
;    case 4 :
_0x20:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x24
;      if (dataRx == 255)
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x25
;        countRxProtokol++;
	INC  R6
;      else
	RJMP _0x26
_0x25:
;        countRxProtokol = 0;
	CLR  R6
;      dataMasuk[3] = dataRx;
_0x26:
	__PUTBMRN _dataMasuk,3,4
;      dataInt[1] = ((dataMasuk[0] & 0b00001100) << 6) + dataMasuk[3] ;
	LDS  R30,_dataMasuk
	LDI  R31,0
	ANDI R30,LOW(0xC)
	ANDI R31,HIGH(0xC)
	LSL  R30
	LSL  R30
	CALL __LSLW4
	MOVW R26,R30
	__GETB1MN _dataMasuk,3
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _dataInt,2
;      if ((dataMasuk[0] & 0b00100000) >> 5)
	LDS  R30,_dataMasuk
	ANDI R30,LOW(0x20)
	LDI  R31,0
	ASR  R31
	ROR  R30
	CALL __ASRW4
	SBIW R30,0
	BREQ _0x27
;        dataInt[1] *= -1;
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	__PUTW1MN _dataInt,2
;      countRx ++;
_0x27:
	INC  R3
;      break;
	RJMP _0x16
;    case 5 :
_0x24:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x16
;      if (dataRx == 255)
	LDI  R30,LOW(255)
	CP   R30,R4
	BRNE _0x29
;        countRxProtokol++;
	INC  R6
;      else
	RJMP _0x2A
_0x29:
;        countRxProtokol = 0;
	CLR  R6
;      countRx = 0;
_0x2A:
	CLR  R3
;      break;
;  }
_0x16:
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
	MOV  R30,R5
	CALL SUBOPT_0x17
;  {
;    case 0:
	BRNE _0x2E
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
	MOV  R5,R30
;      break;
	RJMP _0x2D
;
;    case 1:
_0x2E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x31
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
	MOV  R5,R30
;      break;
	RJMP _0x2D
;
;    case 2:
_0x31:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
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
	MOV  R5,R30
;      break;
	RJMP _0x2D
;
;    case 3:
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x37
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
	MOV  R5,R30
;      break;
	RJMP _0x2D
;
;    case 4:
_0x37:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3A
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
	MOV  R5,R30
;      break;
	RJMP _0x2D
;
;    case 5:
_0x3A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3D
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
	MOV  R5,R30
;      break;
	RJMP _0x2D
;
;    case 6:
_0x3D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2D
;      TCNT1H = timer2ms >> 8;
	LDI  R30,LOW(248)
	STS  133,R30
;      TCNT1L = timer2ms & 0xff;
	LDI  R30,LOW(48)
	STS  132,R30
;      Timeslot = 0;
	CLR  R5
;  }
_0x2D:
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
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;{
_timer1_compa_isr:
	CALL SUBOPT_0x22
;switch (Timeslot)
;    {
;    case 0:
	BREQ _0x43
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x45
;            kaka1_0;
	LDS  R30,267
	ANDI R30,0xFB
	RJMP _0xF0
;    break;
;
;    case 2:
_0x45:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x46
;            kaka2_0;
	LDS  R30,267
	ANDI R30,0XF7
	RJMP _0xF0
;    break;
;
;    case 3:
_0x46:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x47
;            kaka3_0;
	LDS  R30,267
	ANDI R30,0xEF
	RJMP _0xF0
;    break;
;
;    case 4:
_0x47:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x48
;            kaka4_0;
	LDS  R30,267
	ANDI R30,0xDF
	RJMP _0xF0
;    break;
;
;    case 5:
_0x48:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x49
;            kaka5_0;
	LDS  R30,267
	ANDI R30,0xBF
	RJMP _0xF0
;    break;
;
;    case 6:
_0x49:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x43
;            kaka6_0;
	LDS  R30,267
	ANDI R30,0x7F
_0xF0:
	STS  267,R30
;    break;
;    }
_0x43:
;
;}
	RJMP _0xFA
;
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
;{
_timer1_compb_isr:
	CALL SUBOPT_0x22
;switch (Timeslot)
;    {
;    case 0:
	BREQ _0x4D
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4F
;            kaki1 = 0;
	CBI  0x8,7
;    break;
	RJMP _0x4D
;
;    case 2:
_0x4F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x52
;            kaki2 = 0;
	CBI  0x8,6
;    break;
	RJMP _0x4D
;
;    case 3:
_0x52:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x55
;            kaki3 = 0;
	CBI  0x2,6
;    break;
	RJMP _0x4D
;
;    case 4:
_0x55:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x58
;            kaki4 = 0;
	CBI  0x2,7
;    break;
	RJMP _0x4D
;
;    case 5:
_0x58:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5B
;            kaki5 = 0;
	CBI  0x2,4
;    break;
	RJMP _0x4D
;
;    case 6:
_0x5B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4D
;            kaki6 = 0;
	CBI  0x2,5
;    break;
;    }
_0x4D:
;
;
;}
	RJMP _0xFA
;
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
;{
_timer3_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;  switch (Timeslot2)
	CALL SUBOPT_0x23
;  {
;    case 0:
	BRNE _0x64
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
	CALL SUBOPT_0x24
;      OCR3BH = ((2 * (servoInitError[15] + servo[15])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,30
	__GETW1MN _servo,30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[15] + servo[15])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,30
	__GETB1MN _servo,30
	CALL SUBOPT_0x25
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 1;
	LDI  R30,LOW(1)
	RJMP _0xF1
;      break;
;
;    case 1:
_0x64:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x69
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
	CALL SUBOPT_0x24
;      OCR3BH = ((2 * (servoInitError[16] + servo[16])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,32
	__GETW1MN _servo,32
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[16] + servo[16])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,32
	__GETB1MN _servo,32
	CALL SUBOPT_0x25
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 2;
	LDI  R30,LOW(2)
	RJMP _0xF1
;      break;
;
;    case 2:
_0x69:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6E
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
	CALL SUBOPT_0x24
;      OCR3BH = ((2 * (servoInitError[17] + servo[17])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,34
	__GETW1MN _servo,34
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[17] + servo[17])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,34
	__GETB1MN _servo,34
	CALL SUBOPT_0x25
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 3;
	LDI  R30,LOW(3)
	RJMP _0xF1
;      break;
;
;    case 3:
_0x6E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x73
;      pala1 = 1;
	SBI  0x11,3
;      pala2 = 1;
	SBI  0x11,4
;      OCR3AH = ((2 * (servoInitError[18] + servo[18])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,36
	__GETW1MN _servo,36
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[18] + servo[18])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,36
	__GETB1MN _servo,36
	CALL SUBOPT_0x24
;      OCR3BH = ((2 * (servoInitError[19] + servo[19])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,38
	__GETW1MN _servo,38
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[19] + servo[19])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,38
	__GETB1MN _servo,38
	CALL SUBOPT_0x25
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 4;
	LDI  R30,LOW(4)
	RJMP _0xF1
;      break;
;
;    case 4:
_0x73:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x78
;
;      TCNT3H = timer3ms >> 8;
	CALL SUBOPT_0x26
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 5;
	LDI  R30,LOW(5)
	RJMP _0xF1
;      break;
;
;    case 5:
_0x78:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x79
;
;      TCNT3H = timer3ms >> 8;
	CALL SUBOPT_0x26
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 6;
	LDI  R30,LOW(6)
	RJMP _0xF1
;      break;
;
;    case 6:
_0x79:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x63
;      TCNT3H = timer3ms >> 8;
	CALL SUBOPT_0x26
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 0;
	LDI  R30,LOW(0)
_0xF1:
	STS  _Timeslot2,R30
;  }
_0x63:
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
;// Timer3 output compare A interrupt service routine
;interrupt [TIM3_COMPA] void timer3_compa_isr(void)
;{
_timer3_compa_isr:
	CALL SUBOPT_0x27
;switch (Timeslot2)
;    {
;    case 0:
	BREQ _0x7D
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7F
;            taka1 = 0;
	CBI  0x11,0
;    break;
	RJMP _0x7D
;
;    case 2:
_0x7F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x82
;            taka2 = 0;
	CBI  0x11,1
;    break;
	RJMP _0x7D
;
;    case 3:
_0x82:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x85
;            taka3 = 0;
	CBI  0x11,2
;    break;
	RJMP _0x7D
;
;    case 4:
_0x85:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x88
;            pala1 = 0;
	CBI  0x11,3
;    break;
;
;    case 5:
_0x88:
;
;    break;
;
;    case 6:
;
;    break;
;    }
_0x7D:
;
;}
	RJMP _0xFA
;
;// Timer3 output compare B interrupt service routine
;interrupt [TIM3_COMPB] void timer3_compb_isr(void)
;{
_timer3_compb_isr:
	CALL SUBOPT_0x27
;switch (Timeslot2)
;    {
;    case 0:
	BREQ _0x8F
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x91
;            taki1 = 0;
	CBI  0x11,7
;    break;
	RJMP _0x8F
;
;    case 2:
_0x91:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x94
;            taki2 = 0;
	CBI  0x11,6
;    break;
	RJMP _0x8F
;
;    case 3:
_0x94:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x97
;            taki3 = 0;
	CBI  0x11,5
;    break;
	RJMP _0x8F
;
;    case 4:
_0x97:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x9A
;            pala2 = 0;
	CBI  0x11,4
;    break;
;
;    case 5:
_0x9A:
;
;    break;
;
;    case 6:
;
;    break;
;    }
_0x8F:
;}
_0xFA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;void taskGerakan()
; 0000 005C {
_taskGerakan:
; 0000 005D     if (langkah <= 0)
	LDS  R26,_langkah
	LDS  R27,_langkah+1
	CALL __CPW02
	BRGE PC+3
	JMP _0x9F
; 0000 005E     {
; 0000 005F         printf("===XYZ %0.2f %0.2f %0.2f || ",X[0],Y[0],Z[0]);
	__POINTW1FN _0x0,10
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_X
	LDS  R31,_X+1
	LDS  R22,_X+2
	LDS  R23,_X+3
	CALL __PUTPARD1
	LDS  R30,_Y
	LDS  R31,_Y+1
	LDS  R22,_Y+2
	LDS  R23,_Y+3
	CALL __PUTPARD1
	LDS  R30,_Z
	LDS  R31,_Z+1
	LDS  R22,_Z+2
	LDS  R23,_Z+3
	CALL SUBOPT_0x28
; 0000 0060         printf("===XYZ %0.2f %0.2f %0.2f \n",X[1],Y[1],Z[1]);
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	__GETD1MN _X,4
	CALL __PUTPARD1
	__GETD1MN _Y,4
	CALL __PUTPARD1
	__GETD1MN _Z,4
	CALL SUBOPT_0x28
; 0000 0061 
; 0000 0062         if (VX != 0 || VY != 0 || W != 0)
	CALL SUBOPT_0x29
	BRNE _0xA1
	CALL SUBOPT_0x2A
	BRNE _0xA1
	CALL SUBOPT_0x2B
	BREQ _0xA0
_0xA1:
; 0000 0063         {
; 0000 0064           countGerakan++;
	LDI  R26,LOW(_countGerakan)
	LDI  R27,HIGH(_countGerakan)
	CALL SUBOPT_0x16
; 0000 0065         }
; 0000 0066         else
	RJMP _0xA3
_0xA0:
; 0000 0067         {
; 0000 0068           countGerakan = 0;
	LDI  R30,LOW(0)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R30
; 0000 0069         }
_0xA3:
; 0000 006A 
; 0000 006B         if (countGerakan > jumlahGerak)
	LDS  R30,_jumlahGerak
	LDS  R31,_jumlahGerak+1
	LDS  R26,_countGerakan
	LDS  R27,_countGerakan+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xA4
; 0000 006C         {
; 0000 006D           if (VX != 0 || VY != 0 || W != 0 )
	CALL SUBOPT_0x29
	BRNE _0xA6
	CALL SUBOPT_0x2A
	BRNE _0xA6
	CALL SUBOPT_0x2B
	BREQ _0xA5
_0xA6:
; 0000 006E             countGerakan = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R31
; 0000 006F           else
	RJMP _0xA8
_0xA5:
; 0000 0070             countGerakan = 0;
	LDI  R30,LOW(0)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R30
; 0000 0071         }
_0xA8:
; 0000 0072 
; 0000 0073         langkah = langkahMax;
_0xA4:
	CALL SUBOPT_0x2C
	STS  _langkah,R30
	STS  _langkah+1,R31
; 0000 0074         for (countNo = 0; countNo < 2; countNo++)
	CALL SUBOPT_0x5
_0xAA:
	CALL SUBOPT_0x6
	BRLT PC+3
	JMP _0xAB
; 0000 0075         {
; 0000 0076             Xerror[countNo] = (X[countNo] - Xset[countNo]) / langkahMax;
	CALL SUBOPT_0x2D
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x30
	POP  R26
	POP  R27
	CALL SUBOPT_0x31
; 0000 0077             Yerror[countNo] = (Y[countNo] - Yset[countNo]) / langkahMax;
	LDI  R26,LOW(_Yerror)
	LDI  R27,HIGH(_Yerror)
	CALL SUBOPT_0x32
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	LDI  R26,LOW(_Y)
	LDI  R27,HIGH(_Y)
	CALL SUBOPT_0x33
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x30
	POP  R26
	POP  R27
	CALL SUBOPT_0x31
; 0000 0078             Zerror[countNo] = (Z[countNo] - Zset[countNo]) / langkahMax;
	LDI  R26,LOW(_Zerror)
	LDI  R27,HIGH(_Zerror)
	CALL SUBOPT_0x32
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	LDI  R26,LOW(_Z)
	LDI  R27,HIGH(_Z)
	CALL SUBOPT_0x33
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x30
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0079         }
	CALL SUBOPT_0x10
	RJMP _0xAA
_0xAB:
; 0000 007A     }
; 0000 007B     else
	RJMP _0xAC
_0x9F:
; 0000 007C     {
; 0000 007D         for (countNo = 0; countNo < 2; countNo++)
	CALL SUBOPT_0x5
_0xAE:
	CALL SUBOPT_0x6
	BRLT PC+3
	JMP _0xAF
; 0000 007E         {
; 0000 007F             Xset[countNo] += Xerror[countNo]; Yset[countNo] += Yerror[countNo]; Zset[countNo] += Zerror[countNo];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
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
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x31
	CALL SUBOPT_0xB
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
	CALL SUBOPT_0x7
	LDI  R26,LOW(_Yerror)
	LDI  R27,HIGH(_Yerror)
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x7
	LDI  R26,LOW(_Zerror)
	LDI  R27,HIGH(_Zerror)
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0080         }
	CALL SUBOPT_0x10
	RJMP _0xAE
_0xAF:
; 0000 0081         printf("XYZset %0.2f %0.2f %0.2f || ",Xset[0],Yset[0],Zset[0]);
	__POINTW1FN _0x0,66
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Xset
	LDS  R31,_Xset+1
	LDS  R22,_Xset+2
	LDS  R23,_Xset+3
	CALL __PUTPARD1
	LDS  R30,_Yset
	LDS  R31,_Yset+1
	LDS  R22,_Yset+2
	LDS  R23,_Yset+3
	CALL __PUTPARD1
	LDS  R30,_Zset
	LDS  R31,_Zset+1
	LDS  R22,_Zset+2
	LDS  R23,_Zset+3
	CALL SUBOPT_0x28
; 0000 0082         printf("XYZset %0.2f %0.2f %0.2f \n",Xset[1],Yset[1],Zset[1]);
	__POINTW1FN _0x0,95
	ST   -Y,R31
	ST   -Y,R30
	__GETD1MN _Xset,4
	CALL __PUTPARD1
	__GETD1MN _Yset,4
	CALL __PUTPARD1
	__GETD1MN _Zset,4
	CALL SUBOPT_0x28
; 0000 0083         inversKinematic();
	RCALL _inversKinematic
; 0000 0084         for (countNo = 0; countNo < 12; countNo++)
	CALL SUBOPT_0x5
_0xB1:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,12
	BRGE _0xB2
; 0000 0085         {
; 0000 0086           if (servoSet[countNo] >= 2500)
	CALL SUBOPT_0x34
	CALL __GETW1P
	CPI  R30,LOW(0x9C4)
	LDI  R26,HIGH(0x9C4)
	CPC  R31,R26
	BRLT _0xB3
; 0000 0087             servoSet[countNo] = 2500;
	CALL SUBOPT_0x34
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	RJMP _0xF2
; 0000 0088           else if (servoSet[countNo] <= 500)
_0xB3:
	CALL SUBOPT_0x34
	CALL __GETW1P
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRGE _0xB5
; 0000 0089             servoSet[countNo] = 500;
	CALL SUBOPT_0x34
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
_0xF2:
	ST   X+,R30
	ST   X,R31
; 0000 008A           servo[countNo] = (int)(servoSet[countNo]);
_0xB5:
	CALL SUBOPT_0x7
	LDI  R26,LOW(_servo)
	LDI  R27,HIGH(_servo)
	CALL SUBOPT_0x35
	MOVW R0,R30
	CALL SUBOPT_0x34
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 008B         }
	CALL SUBOPT_0x10
	RJMP _0xB1
_0xB2:
; 0000 008C         langkah--;
	LDI  R26,LOW(_langkah)
	LDI  R27,HIGH(_langkah)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 008D     }
_0xAC:
; 0000 008E }
	RET
;
;void inversKinematic()
; 0000 0091 {
_inversKinematic:
; 0000 0092     for(I=0;I<2;I++)
	LDI  R30,LOW(0)
	STS  _I,R30
	STS  _I+1,R30
_0xB7:
	LDS  R26,_I
	LDS  R27,_I+1
	SBIW R26,2
	BRLT PC+3
	JMP _0xB8
; 0000 0093     {
; 0000 0094       XiKuadrat = Xset[I] * Xset[I];
	CALL SUBOPT_0x36
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x37
	STS  _XiKuadrat,R30
	STS  _XiKuadrat+1,R31
	STS  _XiKuadrat+2,R22
	STS  _XiKuadrat+3,R23
; 0000 0095       YiKuadrat = Yset[I] * Yset[I];
	CALL SUBOPT_0x36
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x37
	STS  _YiKuadrat,R30
	STS  _YiKuadrat+1,R31
	STS  _YiKuadrat+2,R22
	STS  _YiKuadrat+3,R23
; 0000 0096       ZiKuadrat = Zset[I] * Zset[I];
	CALL SUBOPT_0x36
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x37
	STS  _ZiKuadrat,R30
	STS  _ZiKuadrat+1,R31
	STS  _ZiKuadrat+2,R22
	STS  _ZiKuadrat+3,R23
; 0000 0097 
; 0000 0098       bi = sqrt(XiKuadrat + ZiKuadrat) - L1 - L4;
	LDS  R26,_XiKuadrat
	LDS  R27,_XiKuadrat+1
	LDS  R24,_XiKuadrat+2
	LDS  R25,_XiKuadrat+3
	CALL SUBOPT_0x38
	CALL SUBOPT_0x0
	CALL __SUBF12
	CALL SUBOPT_0x4
	CALL __SUBF12
	STS  _bi,R30
	STS  _bi+1,R31
	STS  _bi+2,R22
	STS  _bi+3,R23
; 0000 0099       biKuadrat = bi * bi;
	CALL SUBOPT_0x39
	CALL __MULF12
	STS  _biKuadrat,R30
	STS  _biKuadrat+1,R31
	STS  _biKuadrat+2,R22
	STS  _biKuadrat+3,R23
; 0000 009A       ai = sqrt(biKuadrat + YiKuadrat);
	LDS  R30,_YiKuadrat
	LDS  R31,_YiKuadrat+1
	LDS  R22,_YiKuadrat+2
	LDS  R23,_YiKuadrat+3
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x38
	STS  _ai,R30
	STS  _ai+1,R31
	STS  _ai+2,R22
	STS  _ai+3,R23
; 0000 009B       aiKuadrat = ai * ai;
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
; 0000 009C       gamai = atan2(Yset[I],bi);
	CALL SUBOPT_0x36
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2F
	CALL __PUTPARD1
	CALL SUBOPT_0x39
	CALL _atan2
	STS  _gamai,R30
	STS  _gamai+1,R31
	STS  _gamai+2,R22
	STS  _gamai+3,R23
; 0000 009D       A1[I] = atan2(Xset[I],Zset[I]);
	CALL SUBOPT_0x36
	LDI  R26,LOW(_A1)
	LDI  R27,HIGH(_A1)
	CALL SUBOPT_0x32
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x36
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2F
	CALL __PUTPARD1
	CALL SUBOPT_0x36
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2F
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan2
	POP  R26
	POP  R27
	CALL SUBOPT_0x3C
; 0000 009E       A3[I] = acos((aiKuadrat - L2Kuadrat - L3Kuadrat) / (2 * L2 * L3));
	CALL SUBOPT_0x32
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
; 0000 009F       ci = L3 * cos(A3[I]);
	CALL SUBOPT_0x33
	MOVW R26,R30
	MOVW R24,R22
	CALL _cos
	CALL SUBOPT_0x3
	STS  _ci,R30
	STS  _ci+1,R31
	STS  _ci+2,R22
	STS  _ci+3,R23
; 0000 00A0       betai = acos((L2 + ci) / ai);
	CALL SUBOPT_0x2
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3F
	STS  _betai,R30
	STS  _betai+1,R31
	STS  _betai+2,R22
	STS  _betai+3,R23
; 0000 00A1       A2[I] = -(gamai + betai);
	CALL SUBOPT_0x36
	LDI  R26,LOW(_A2)
	LDI  R27,HIGH(_A2)
	CALL SUBOPT_0x32
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
; 0000 00A2       alphai[I] = acos((L2Kuadrat + L3Kuadrat - biKuadrat) / (2 * L2 * L3));
	CALL SUBOPT_0x36
	LDI  R26,LOW(_alphai)
	LDI  R27,HIGH(_alphai)
	CALL SUBOPT_0x32
	PUSH R31
	PUSH R30
	LDS  R30,_L3Kuadrat
	LDS  R31,_L3Kuadrat+1
	LDS  R22,_L3Kuadrat+2
	LDS  R23,_L3Kuadrat+3
	CALL SUBOPT_0x3D
	CALL __ADDF12
	CALL SUBOPT_0x3A
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
; 0000 00A3       A5[I] = A1[I];
	CALL SUBOPT_0x36
	LDI  R26,LOW(_A5)
	LDI  R27,HIGH(_A5)
	CALL SUBOPT_0x32
	MOVW R0,R30
	CALL SUBOPT_0x36
	LDI  R26,LOW(_A1)
	LDI  R27,HIGH(_A1)
	CALL SUBOPT_0x33
	MOVW R26,R0
	CALL __PUTDP1
; 0000 00A4     }
	LDI  R26,LOW(_I)
	LDI  R27,HIGH(_I)
	CALL SUBOPT_0x16
	RJMP _0xB7
_0xB8:
; 0000 00A5 
; 0000 00A6     //kaki kanan
; 0000 00A7     sudutSet[5]  = 90; //pinggul
	__POINTW1MN _sudutSet,20
	CALL SUBOPT_0x41
	CALL SUBOPT_0xF
; 0000 00A8     sudutSet[4]  = (A1[0] * (rad))+90;
	CALL SUBOPT_0x42
	LDS  R26,_A1
	LDS  R27,_A1+1
	LDS  R24,_A1+2
	LDS  R25,_A1+3
	CALL SUBOPT_0x43
	__PUTD1MN _sudutSet,16
; 0000 00A9     sudutSet[3]  = (A2[0] * (rad));
	CALL SUBOPT_0x42
	LDS  R26,_A2
	LDS  R27,_A2+1
	LDS  R24,_A2+2
	LDS  R25,_A2+3
	CALL __MULF12
	CALL SUBOPT_0x44
; 0000 00AA     sudutSet[2]  = (A3[0] * (rad))+90;
	CALL SUBOPT_0x42
	LDS  R26,_A3
	LDS  R27,_A3+1
	LDS  R24,_A3+2
	LDS  R25,_A3+3
	CALL SUBOPT_0x43
	__PUTD1MN _sudutSet,8
; 0000 00AB     sudutSet[1]  = (-(180 - (alphai[0] * (rad)) + (sudutSet[3])))+90;
	CALL SUBOPT_0x42
	LDS  R26,_alphai
	LDS  R27,_alphai+1
	LDS  R24,_alphai+2
	LDS  R25,_alphai+3
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL __ADDF12
	__PUTD1MN _sudutSet,4
; 0000 00AC     sudutSet[0]  = (A5[0] * (rad))+90; //kaki
	CALL SUBOPT_0x42
	LDS  R26,_A5
	LDS  R27,_A5+1
	LDS  R24,_A5+2
	LDS  R25,_A5+3
	CALL SUBOPT_0x43
	STS  _sudutSet,R30
	STS  _sudutSet+1,R31
	STS  _sudutSet+2,R22
	STS  _sudutSet+3,R23
; 0000 00AD     sudutSet[3]  += 70; //90      edt
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x44
; 0000 00AE 
; 0000 00AF     //kaki kiri
; 0000 00B0     sudutSet[11] = 90; //pinggul
	__POINTW1MN _sudutSet,44
	CALL SUBOPT_0x41
	CALL SUBOPT_0xF
; 0000 00B1     sudutSet[10] = (A1[1] * (rad))+93; //90 edit
	__GETD1MN _A1,4
	CALL SUBOPT_0x48
	__GETD2N 0x42BA0000
	CALL __ADDF12
	__PUTD1MN _sudutSet,40
; 0000 00B2     sudutSet[9]  = (A2[1] * (rad))+5;       //0  edit
	__GETD1MN _A2,4
	CALL SUBOPT_0x48
	__GETD2N 0x40A00000
	CALL __ADDF12
	CALL SUBOPT_0x49
; 0000 00B3     sudutSet[8]  = (A3[1] * (rad))+90;
	__GETD1MN _A3,4
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x43
	__PUTD1MN _sudutSet,32
; 0000 00B4     sudutSet[7]  = (-(180 - (alphai[1] * (rad)) + (sudutSet[9])))+90+3;       //90
	__GETD1MN _alphai,4
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x45
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL __ADDF12
	__GETD2N 0x40400000
	CALL __ADDF12
	__PUTD1MN _sudutSet,28
; 0000 00B5     sudutSet[6]  = (A5[1] * (rad))+90; //kaki //90
	__GETD1MN _A5,4
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x43
	__PUTD1MN _sudutSet,24
; 0000 00B6     sudutSet[9]  += 70;   //90             edit
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x47
	CALL SUBOPT_0x49
; 0000 00B7 
; 0000 00B8     //printf("R %0.2f %0.2f %0.2f %0.2f %0.2f || ",sudutSet[4],sudutSet[3],sudutSet[2],sudutSet[1],sudutSet[0]);
; 0000 00B9     //printf("L %0.2f %0.2f %0.2f %0.2f %0.2f \n",sudutSet[10],sudutSet[9],sudutSet[8],sudutSet[7],sudutSet[6]);
; 0000 00BA     for (countNo = 0; countNo < 12; countNo++)
	CALL SUBOPT_0x5
_0xBA:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,12
	BRGE _0xBB
; 0000 00BB     {
; 0000 00BC         servoSet[countNo] = 800 + (7.7777* sudutSet[countNo]);
	CALL SUBOPT_0x7
	LDI  R26,LOW(_servoSet)
	LDI  R27,HIGH(_servoSet)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	LDI  R26,LOW(_sudutSet)
	LDI  R27,HIGH(_sudutSet)
	CALL SUBOPT_0x33
	__GETD2N 0x40F8E2EB
	CALL __MULF12
	__GETD2N 0x44480000
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00BD     }
	CALL SUBOPT_0x10
	RJMP _0xBA
_0xBB:
; 0000 00BE 
; 0000 00BF     //printf("SR %d %d %d %d %d || ",servoSet[4],servoSet[3],servoSet[2],servoSet[1],servoSet[0]);
; 0000 00C0     //printf("SL %d %d %d %d %d \n ",servoSet[10],servoSet[9],servoSet[8],servoSet[7],servoSet[6]);
; 0000 00C1 
; 0000 00C2 }
	RET
;void InputXYZ()
; 0000 00C4 {
_InputXYZ:
; 0000 00C5     for (countNo = 0; countNo < 2; countNo++){
	CALL SUBOPT_0x5
_0xBD:
	CALL SUBOPT_0x6
	BRGE _0xBE
; 0000 00C6         X[countNo] += initPositionX; Y[countNo] += initPositionY; Z[countNo] += initPositionZ;
	CALL SUBOPT_0x2E
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x9
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x31
	LDI  R26,LOW(_Y)
	LDI  R27,HIGH(_Y)
	CALL SUBOPT_0x32
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0xC
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x31
	LDI  R26,LOW(_Z)
	LDI  R27,HIGH(_Z)
	CALL SUBOPT_0x32
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0xE
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00C7     }
	CALL SUBOPT_0x10
	RJMP _0xBD
_0xBE:
; 0000 00C8     langkah=0;
	LDI  R30,LOW(0)
	STS  _langkah,R30
	STS  _langkah+1,R30
; 0000 00C9 }
	RET
;
;void main(void)
; 0000 00CC {
_main:
; 0000 00CD init();
	CALL _init
; 0000 00CE X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x11
; 0000 00CF X[1]=0; Y[1]=0; Z[1]=0;
; 0000 00D0 InputXYZ();
	RCALL _InputXYZ
; 0000 00D1 #asm("sei")
	sei
; 0000 00D2 while (1)
_0xBF:
; 0000 00D3     {
; 0000 00D4     //langkah;
; 0000 00D5     //mlayu();
; 0000 00D6        switch(4)
	LDI  R30,LOW(4)
; 0000 00D7         {
; 0000 00D8             case 0 :     //diam
	CPI  R30,0
	BRNE _0xC5
; 0000 00D9                 X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x11
; 0000 00DA                 X[1]=0; Y[1]=0; Z[1]=0;
; 0000 00DB                 InputXYZ();
	RCALL _InputXYZ
; 0000 00DC             break;
	RJMP _0xC4
; 0000 00DD 
; 0000 00DE             case 1 :      //init
_0xC5:
	CPI  R30,LOW(0x1)
	BRNE _0xC6
; 0000 00DF                 X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x11
; 0000 00E0                 X[1]=0; Y[1]=0; Z[1]=0;
; 0000 00E1                 InputXYZ();
	RCALL _InputXYZ
; 0000 00E2                 servoInitError[dataInt[0]]=dataInt[1];
	CALL SUBOPT_0x18
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x1A
	ST   X+,R30
	ST   X,R31
; 0000 00E3                 eServoInitError[dataInt[0]]=servoInitError[dataInt[0]];
	CALL SUBOPT_0x18
	LDI  R26,LOW(_eServoInitError)
	LDI  R27,HIGH(_eServoInitError)
	CALL SUBOPT_0x35
	MOVW R0,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	CALL __EEPROMWRW
; 0000 00E4             break;
	RJMP _0xC4
; 0000 00E5 
; 0000 00E6             case 2 :    //variasi XYZ
_0xC6:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0xC7
; 0000 00E7                 switch(dataInt[0])     //init
	CALL SUBOPT_0x18
; 0000 00E8                 {
; 0000 00E9                     case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xCB
; 0000 00EA                        Yin=dataInt[1];
	CALL SUBOPT_0x1A
	LDI  R26,LOW(_Yin)
	LDI  R27,HIGH(_Yin)
	RJMP _0xF3
; 0000 00EB                     break;
; 0000 00EC                     case 2:
_0xCB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCC
; 0000 00ED                        Xin=dataInt[1];
	CALL SUBOPT_0x1A
	LDI  R26,LOW(_Xin)
	LDI  R27,HIGH(_Xin)
	RJMP _0xF3
; 0000 00EE                     break;
; 0000 00EF                     case 3:
_0xCC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xCA
; 0000 00F0                        Zin=dataInt[1];
	CALL SUBOPT_0x1A
	LDI  R26,LOW(_Zin)
	LDI  R27,HIGH(_Zin)
_0xF3:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
; 0000 00F1                     break;
; 0000 00F2                 }
_0xCA:
; 0000 00F3                 X[0]=Xin; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
; 0000 00F4                 X[1]=Xin; Y[1]=Yin; Z[1]=Zin;
	CALL SUBOPT_0x4C
	__PUTD1MN _X,4
	LDS  R30,_Yin
	LDS  R31,_Yin+1
	LDS  R22,_Yin+2
	LDS  R23,_Yin+3
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 0000 00F5                 InputXYZ();
; 0000 00F6             break;
	RJMP _0xC4
; 0000 00F7 
; 0000 00F8             case 3 :     //delay
_0xC7:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0xCE
; 0000 00F9                 if(counterDelay<=0)
	CLR  R0
	CP   R0,R13
	CPC  R0,R14
	BRGE PC+3
	JMP _0xCF
; 0000 00FA                 {
; 0000 00FB                     switch(countTick)
	__GETW1R 9,10
; 0000 00FC                     {
; 0000 00FD                         case 0:
	SBIW R30,0
	BRNE _0xD3
; 0000 00FE                             Zin = 0;
	LDI  R30,LOW(0)
	STS  _Zin,R30
	STS  _Zin+1,R30
	STS  _Zin+2,R30
	STS  _Zin+3,R30
; 0000 00FF                             X[0]=0; Y[0]=0; Z[0]=Zin;
	RJMP _0xF4
; 0000 0100                             X[1]=0; Y[1]=0; Z[1]=Zin;
; 0000 0101                             InputXYZ();
; 0000 0102                             langkah=0;
; 0000 0103                             printf("-------------------------------------------------Zin %0.f \n",Zin);
; 0000 0104                         break;
; 0000 0105                         case 1:
_0xD3:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0106                             Zin = -20;
	__GETD1N 0xC1A00000
	STS  _Zin,R30
	STS  _Zin+1,R31
	STS  _Zin+2,R22
	STS  _Zin+3,R23
; 0000 0107                             X[0]=0; Y[0]=0; Z[0]=Zin;
_0xF4:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x51
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x52
; 0000 0108                             X[1]=0; Y[1]=0; Z[1]=Zin;
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 0000 0109                             InputXYZ();
; 0000 010A                             langkah=0;
	LDI  R30,LOW(0)
	STS  _langkah,R30
	STS  _langkah+1,R30
; 0000 010B                             printf("-------------------------------------------------Zin %0.f \n",Zin);
	__POINTW1FN _0x0,122
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4F
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 010C                         break;
; 0000 010D                     }
_0xD2:
; 0000 010E                      countTick++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 010F                     if(countTick>1)
	CP   R30,R9
	CPC  R31,R10
	BRGE _0xD5
; 0000 0110                         countTick=0;
	CLR  R9
	CLR  R10
; 0000 0111 
; 0000 0112                     counterDelay=500; //3000
_0xD5:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	__PUTW1R 13,14
; 0000 0113                 }
; 0000 0114             break;
_0xCF:
	RJMP _0xC4
; 0000 0115 
; 0000 0116             case 4 :     //gait
_0xCE:
	CPI  R30,LOW(0x4)
	BREQ PC+3
	JMP _0xC4
; 0000 0117                 VY=20;
	__GETD1N 0x41A00000
	STS  _VY,R30
	STS  _VY+1,R31
	STS  _VY+2,R22
	STS  _VY+3,R23
; 0000 0118                 if(counterDelay<=0)
	CLR  R0
	CP   R0,R13
	CPC  R0,R14
	BRGE PC+3
	JMP _0xD7
; 0000 0119                 {
; 0000 011A                     switch(countTick)
	__GETW1R 9,10
; 0000 011B                     {
; 0000 011C                         case 0:
	SBIW R30,0
	BRNE _0xDB
; 0000 011D                             X[0]=0; Y[0]=0; Z[0]=0;     //siap
	LDI  R30,LOW(0)
	CALL SUBOPT_0x51
	CALL SUBOPT_0x55
; 0000 011E                             X[1]=0; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	RJMP _0xF5
; 0000 011F                             InputXYZ();
; 0000 0120                         break;
; 0000 0121                         case 1:
_0xDB:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xDC
; 0000 0122                             X[0]=70; Y[0]=0; Z[0]=0;    //doyong kiwo
	__GETD1N 0x428C0000
	CALL SUBOPT_0x4D
; 0000 0123                             X[1]=-70; Y[1]=0; Z[1]=0;
	__POINTW1MN _X,4
	CALL SUBOPT_0x56
	RJMP _0xF5
; 0000 0124                             InputXYZ();
; 0000 0125                         break;
; 0000 0126                         case 2:
_0xDC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0127                             X[0]=110; Y[0]=0; Z[0]=-60;  //angkat sikil tengen terus guwak
	CALL SUBOPT_0x57
	LDI  R30,LOW(0)
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	CALL SUBOPT_0x58
; 0000 0128                             X[1]=-70; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x56
	RJMP _0xF5
; 0000 0129                             InputXYZ();
; 0000 012A                         break;
; 0000 012B                         case 3:
_0xDD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xDE
; 0000 012C                             X[0]=110; Y[0]=VY; Z[0]=-60;  //maju tengen
	CALL SUBOPT_0x57
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x58
; 0000 012D                             X[1]=-70; Y[1]=-VY; Z[1]=0;
	CALL SUBOPT_0x5B
	RJMP _0xF6
; 0000 012E                             InputXYZ();
; 0000 012F                         break;
; 0000 0130                         case 4:
_0xDE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0131                             X[0]=70; Y[0]=VY; Z[0]=0;     //otw siap
	__GETD1N 0x428C0000
	CALL SUBOPT_0x5C
; 0000 0132                             X[1]=-70; Y[1]=-VY; Z[1]=0;
	CALL SUBOPT_0x5B
	RJMP _0xF6
; 0000 0133                             InputXYZ();
; 0000 0134                         break;
; 0000 0135                         case 5:
_0xDF:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0136                             X[0]=0; Y[0]=VY; Z[0]=0;      //siap
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5E
; 0000 0137                             X[1]=0; Y[1]=-VY; Z[1]=0;
	CALL SUBOPT_0x53
	CALL SUBOPT_0x5F
	RJMP _0xF6
; 0000 0138                             InputXYZ();
; 0000 0139                         break;
; 0000 013A                         case 6:
_0xE0:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xE1
; 0000 013B                             X[0]=-65; Y[0]=VY; Z[0]=0;    //doyong tengen
	CALL SUBOPT_0x60
; 0000 013C                             X[1]=65; Y[1]=-VY; Z[1]=0;
	__GETD2N 0x42820000
	CALL SUBOPT_0xF
	CALL SUBOPT_0x5F
	RJMP _0xF6
; 0000 013D                             InputXYZ();
; 0000 013E                         break;
; 0000 013F                         case 7:
_0xE1:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0140                             X[0]=-65; Y[0]=VY; Z[0]=0;     //angkat sikil kiwo guwak
	CALL SUBOPT_0x60
; 0000 0141                             X[1]=100; Y[1]=-VY; Z[1]=-55;
	CALL SUBOPT_0x61
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x62
	RJMP _0xF7
; 0000 0142                             InputXYZ();
; 0000 0143                         break;
; 0000 0144                         case 8:
_0xE2:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0145                             X[0]=-65; Y[0]=-VY; Z[0]=0;      //maju kiwo
	CALL SUBOPT_0x63
	CALL SUBOPT_0x5E
; 0000 0146                             X[1]=100; Y[1]=VY; Z[1]=-55;
	CALL SUBOPT_0x61
	CALL SUBOPT_0x59
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x62
	RJMP _0xF7
; 0000 0147                             InputXYZ();
; 0000 0148                         break;
; 0000 0149                         case 9:
_0xE3:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xE4
; 0000 014A                             X[0]=-65; Y[0]=-VY; Z[0]=0;      //otw siap
	CALL SUBOPT_0x63
	CALL SUBOPT_0x5E
; 0000 014B                             X[1]=100; Y[1]=VY+VY; Z[1]=-55;
	CALL SUBOPT_0x61
	CALL SUBOPT_0x64
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x62
	RJMP _0xF7
; 0000 014C                             InputXYZ();
; 0000 014D                         break;
; 0000 014E                         case 10:
_0xE4:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xE5
; 0000 014F                             X[0]=-65; Y[0]=-VY; Z[0]=0;     // siap langsung doyong tengen
	CALL SUBOPT_0x63
	CALL SUBOPT_0x5E
; 0000 0150                             X[1]=65; Y[1]=VY+VY; Z[1]=0;
	__GETD2N 0x42820000
	RJMP _0xF8
; 0000 0151                             InputXYZ();
; 0000 0152                         break;
; 0000 0153                         case 11:
_0xE5:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0154                             X[0]=0; Y[0]=-VY; Z[0]=0;
	CALL SUBOPT_0x5D
	CALL __ANEGF1
	CALL SUBOPT_0x5E
; 0000 0155                             X[1]=0; Y[1]=VY+VY; Z[1]=0;
	__GETD2N 0x0
	RJMP _0xF8
; 0000 0156                             InputXYZ();
; 0000 0157                         break;
; 0000 0158                         case 12:
_0xE6:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0159                             X[0]=65; Y[0]=-VY; Z[0]=0;
	__GETD1N 0x42820000
	CALL SUBOPT_0x65
	CALL SUBOPT_0x5A
	LDI  R30,LOW(0)
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
; 0000 015A                             X[1]=-65; Y[1]=VY+VY; Z[1]=0;
	RJMP _0xF9
; 0000 015B                             InputXYZ();
; 0000 015C                         break;
; 0000 015D                         case 13:
_0xE7:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xDA
; 0000 015E                             X[0]=100; Y[0]=-VY; Z[0]=-55;
	__GETD1N 0x42C80000
	CALL SUBOPT_0x65
	CALL SUBOPT_0x5A
	__GETD1N 0xC25C0000
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
; 0000 015F                             X[1]=-65; Y[1]=VY+VY; Z[1]=0;
_0xF9:
	__POINTW1MN _X,4
	__GETD2N 0xC2820000
_0xF8:
	CALL __PUTDZ20
	CALL SUBOPT_0x64
_0xF6:
	__PUTD1MN _Y,4
_0xF5:
	__POINTW1MN _Z,4
	__GETD2N 0x0
_0xF7:
	CALL __PUTDZ20
; 0000 0160                             InputXYZ();
	RCALL _InputXYZ
; 0000 0161                         break;
; 0000 0162 
; 0000 0163                     }
_0xDA:
; 0000 0164                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x29
	BRNE _0xEA
	LDS  R26,_VY
	LDS  R27,_VY+1
	LDS  R24,_VY+2
	LDS  R25,_VY+3
	CALL SUBOPT_0x66
	MOV  R0,R30
	LDS  R26,_W
	LDS  R27,_W+1
	LDS  R24,_W+2
	LDS  R25,_W+3
	CALL SUBOPT_0x66
	OR   R30,R0
	BREQ _0xE9
_0xEA:
; 0000 0165                     {
; 0000 0166                         countTick++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 0167                         if(countTick>13)
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R9
	CPC  R31,R10
	BRGE _0xEC
; 0000 0168                             countTick=2;     //2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 9,10
; 0000 0169                     }
_0xEC:
; 0000 016A                     else
	RJMP _0xED
_0xE9:
; 0000 016B                     {
; 0000 016C                         countTick=0;
	CLR  R9
	CLR  R10
; 0000 016D                     }
_0xED:
; 0000 016E 
; 0000 016F                     counterDelay=500; //3000
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	__PUTW1R 13,14
; 0000 0170                 }
; 0000 0171             break;
_0xD7:
; 0000 0172         }
_0xC4:
; 0000 0173 
; 0000 0174         speed=10; //10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _speed,R30
	STS  _speed+1,R31
; 0000 0175         if(counterTG>speed)
	CP   R30,R11
	CPC  R31,R12
	BRGE _0xEE
; 0000 0176         {
; 0000 0177             counterTG=0;
	CLR  R11
	CLR  R12
; 0000 0178             taskGerakan();
	RCALL _taskGerakan
; 0000 0179         }
; 0000 017A     }
_0xEE:
	RJMP _0xBF
; 0000 017B }
_0xEF:
	RJMP _0xEF
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
	CALL SUBOPT_0x16
	ADIW R28,3
	RET
__ftoe_G100:
	CALL SUBOPT_0x67
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
	CALL SUBOPT_0x68
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	CALL SUBOPT_0x68
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	CALL SUBOPT_0x69
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000027
	CALL SUBOPT_0x68
_0x2000028:
	CALL SUBOPT_0x69
	BRLO _0x200002A
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0x69
	BRSH _0x200002E
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0x68
_0x200002B:
	__GETD1S 12
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x69
	BRLO _0x200002F
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2000032
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
	CALL SUBOPT_0x6E
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x71
	CALL SUBOPT_0x6A
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x74
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x75
	CALL SUBOPT_0x6D
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0x72
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0x76
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
	CALL SUBOPT_0x76
	CALL SUBOPT_0x76
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x76
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
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x77
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	CALL SUBOPT_0x77
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
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
	CALL SUBOPT_0x78
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x7A
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
	CALL SUBOPT_0x7B
	CALL __GETD1P
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7D
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	RJMP _0x2000064
_0x2000061:
	CALL SUBOPT_0x7E
	CALL __ANEGF1
	CALL SUBOPT_0x7C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000065
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x7A
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
	CALL SUBOPT_0x7E
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000069
_0x2000068:
	CALL SUBOPT_0x7E
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000069:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x7F
	RJMP _0x200006A
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006C
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x80
	CALL SUBOPT_0x7F
	RJMP _0x200006D
_0x200006C:
	CPI  R30,LOW(0x70)
	BRNE _0x200006F
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x80
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
	CALL SUBOPT_0x81
	LDI  R17,LOW(10)
	RJMP _0x200007B
_0x200007A:
	__GETD1N 0x2710
	CALL SUBOPT_0x81
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
	CALL SUBOPT_0x81
	LDI  R17,LOW(8)
	RJMP _0x200007B
_0x2000080:
	__GETD1N 0x1000
	CALL SUBOPT_0x81
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
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7B
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000116
_0x2000083:
	SBRS R16,2
	RJMP _0x2000085
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x80
	CALL __CWD1
	RJMP _0x2000116
_0x2000085:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x80
	CLR  R22
	CLR  R23
_0x2000116:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000087
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000088
	CALL SUBOPT_0x7E
	CALL __ANEGD1
	CALL SUBOPT_0x7C
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
	CALL SUBOPT_0x77
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
	CALL SUBOPT_0x82
	BREQ _0x2000099
	SUBI R21,LOW(1)
_0x2000099:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000098:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x7A
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
	CALL SUBOPT_0x77
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
	CALL SUBOPT_0x83
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
	CALL SUBOPT_0x82
	BREQ _0x20000B6
	SUBI R21,LOW(1)
_0x20000B6:
_0x20000B5:
_0x20000B4:
_0x20000AB:
	CALL SUBOPT_0x77
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
_0x20000B7:
_0x20000B1:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x83
	CALL __MODD21U
	CALL SUBOPT_0x7C
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x81
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
	CALL SUBOPT_0x7A
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
_ftoa:
	CALL SUBOPT_0x67
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
	CALL SUBOPT_0x84
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20A0007
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0x84
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20A0007
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x85
	CALL SUBOPT_0x86
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
	CALL SUBOPT_0x87
	CALL SUBOPT_0x70
	CALL SUBOPT_0x88
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0x89
	CALL __ADDF12
	CALL SUBOPT_0x85
	LDI  R17,LOW(0)
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x88
_0x2020014:
	CALL SUBOPT_0x89
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0x87
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x88
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0x84
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x20A0007
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0x86
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0x87
	CALL SUBOPT_0x70
	CALL SUBOPT_0x6E
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x88
	CALL SUBOPT_0x89
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x86
	CALL SUBOPT_0x73
	LDI  R31,0
	CALL SUBOPT_0x87
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x75
	CALL SUBOPT_0x85
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0006
	CALL SUBOPT_0x86
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x85
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x86
	CALL SUBOPT_0x73
	LDI  R31,0
	CALL SUBOPT_0x8B
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x75
	CALL SUBOPT_0x85
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
	CALL SUBOPT_0x8C
	CALL _ftrunc
	CALL SUBOPT_0x8D
    brne __floor1
__floor0:
	CALL SUBOPT_0x8E
	RJMP _0x20A0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0x8F
	RJMP _0x20A0004
_sin:
	CALL SUBOPT_0x90
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x91
	RCALL _floor
	CALL SUBOPT_0x92
	CALL SUBOPT_0x75
	CALL SUBOPT_0x91
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0x93
	__GETD2N 0x3F000000
	CALL SUBOPT_0x94
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0x92
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0x92
	__GETD1N 0x3F000000
	CALL SUBOPT_0x94
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0x95
_0x2040019:
	CALL SUBOPT_0x96
	__PUTD1S 1
	CALL SUBOPT_0x97
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x75
	CALL SUBOPT_0x98
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x92
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x97
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x98
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20A0005
_cos:
	CALL SUBOPT_0x8C
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	RJMP _0x20A0002
_xatan:
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x71
	CALL SUBOPT_0x74
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x99
	CALL SUBOPT_0x74
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8E
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x99
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x8C
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x9A
	RCALL _xatan
	RJMP _0x20A0002
_0x2040020:
	CALL SUBOPT_0x9A
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x9B
	RJMP _0x20A0003
_0x2040021:
	CALL SUBOPT_0x8F
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8F
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x9B
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20A0002
_asin:
	CALL SUBOPT_0x90
	CALL SUBOPT_0x9C
	BRLO _0x2040023
	CALL SUBOPT_0x92
	CALL SUBOPT_0x8A
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2040023
	RJMP _0x2040022
_0x2040023:
	CALL SUBOPT_0x9D
	RJMP _0x20A0005
_0x2040022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2040025
	CALL SUBOPT_0x95
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0x96
	__GETD2N 0x3F800000
	CALL SUBOPT_0x75
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0x92
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0x93
	__GETD2S 1
	CALL SUBOPT_0x9E
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x75
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0x97
	CALL SUBOPT_0x92
	CALL SUBOPT_0x9E
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0x97
	CALL __ANEGF1
	RJMP _0x20A0005
_0x2040028:
	CALL SUBOPT_0x97
_0x20A0005:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_acos:
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x9C
	BRLO _0x204002A
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x8A
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x204002A
	RJMP _0x2040029
_0x204002A:
	CALL SUBOPT_0x9D
	RJMP _0x20A0002
_0x2040029:
	CALL SUBOPT_0x9A
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
	CALL SUBOPT_0x71
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	CALL SUBOPT_0x9D
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
	CALL SUBOPT_0x71
	__GETD2S 8
	CALL __DIVF21
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x6F
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0x9A
	RCALL _yatan
	RJMP _0x20A0001
_0x2040031:
	CALL SUBOPT_0x9F
	CALL __ANEGF1
	RJMP _0x20A0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0x9F
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x75
	RJMP _0x20A0001
_0x2040032:
	CALL SUBOPT_0x9A
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20A0001:
	ADIW R28,12
	RET

	.CSEG

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
_dataInt:
	.BYTE 0x8
_data:
	.BYTE 0x8
_dataMasuk:
	.BYTE 0x8
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
_Xin:
	.BYTE 0x4
_Yin:
	.BYTE 0x4
_Zin:
	.BYTE 0x4
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
_Timeslot2:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R26,_L1
	LDS  R27,_L1+1
	LDS  R24,_L1+2
	LDS  R25,_L1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R30,_L2
	LDS  R31,_L2+1
	LDS  R22,_L2+2
	LDS  R23,_L2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_L2
	LDS  R27,_L2+1
	LDS  R24,_L2+2
	LDS  R25,_L2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	LDS  R26,_L3
	LDS  R27,_L3+1
	LDS  R24,_L3+2
	LDS  R25,_L3+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_L4
	LDS  R27,_L4+1
	LDS  R24,_L4+2
	LDS  R25,_L4+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _countNo,R30
	STS  _countNo+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x7:
	LDS  R30,_countNo
	LDS  R31,_countNo+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_Xset)
	LDI  R27,HIGH(_Xset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_initPositionX
	LDS  R27,_initPositionX+1
	LDS  R24,_initPositionX+2
	LDS  R25,_initPositionX+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL __PUTDZ20
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_Yset)
	LDI  R27,HIGH(_Yset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R26,_initPositionY
	LDS  R27,_initPositionY+1
	LDS  R24,_initPositionY+2
	LDS  R25,_initPositionY+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_Zset)
	LDI  R27,HIGH(_Zset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R26,_initPositionZ
	LDS  R27,_initPositionZ+1
	LDS  R24,_initPositionZ+2
	LDS  R25,_initPositionZ+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0xF:
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_countNo)
	LDI  R27,HIGH(_countNo)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:144 WORDS
SUBOPT_0x11:
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
	RCALL SUBOPT_0xF
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0xF
	__POINTW1MN _Z,4
	__GETD2N 0x0
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDS  R30,_index
	LDS  R31,_index+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_servoInitError)
	LDI  R27,HIGH(_servoInitError)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDS  R30,_dataInt
	LDS  R31,_dataInt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	__GETW1MN _dataInt,2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	MOV  R30,R5
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDS  R30,_Timeslot2
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  152,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x25:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  154,R30
	LDI  R30,LOW(232)
	STS  149,R30
	LDI  R30,LOW(144)
	STS  148,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(232)
	STS  149,R30
	LDI  R30,LOW(144)
	STS  148,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	CALL __PUTPARD1
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x29:
	LDS  R26,_VX
	LDS  R27,_VX+1
	LDS  R24,_VX+2
	LDS  R25,_VX+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	LDS  R26,_VY
	LDS  R27,_VY+1
	LDS  R24,_VY+2
	LDS  R25,_VY+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	LDS  R26,_W
	LDS  R27,_W+1
	LDS  R24,_W+2
	LDS  R25,_W+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDS  R30,_langkahMax
	LDS  R31,_langkahMax+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x7
	LDI  R26,LOW(_Xerror)
	LDI  R27,HIGH(_Xerror)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0x7
	LDI  R26,LOW(_X)
	LDI  R27,HIGH(_X)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2F:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x30:
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x2C
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	CALL __PUTDP1
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x32:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	CALL __LSLW2
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0x7
	LDI  R26,LOW(_servoSet)
	LDI  R27,HIGH(_servoSet)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x36:
	LDS  R30,_I
	LDS  R31,_I+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	MOVW R26,R30
	MOVW R24,R22
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDS  R26,_bi
	LDS  R27,_bi+1
	LDS  R24,_bi+2
	LDS  R25,_bi+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDS  R26,_biKuadrat
	LDS  R27,_biKuadrat+1
	LDS  R24,_biKuadrat+2
	LDS  R25,_biKuadrat+3
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
	RCALL SUBOPT_0x36
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
	RCALL SUBOPT_0x1
	__GETD2N 0x40000000
	CALL __MULF12
	RJMP SUBOPT_0x3

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x41:
	__GETD2N 0x42B40000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	LDS  R30,_rad
	LDS  R31,_rad+1
	LDS  R22,_rad+2
	LDS  R23,_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x43:
	CALL __MULF12
	RCALL SUBOPT_0x41
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	__PUTD1MN _sudutSet,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x45:
	CALL __MULF12
	__GETD2N 0x43340000
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	__GETD1MN _sudutSet,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	__GETD2N 0x428C0000
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	LDS  R30,_Xin
	LDS  R31,_Xin+1
	LDS  R22,_Xin+2
	LDS  R23,_Xin+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4D:
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	LDI  R30,LOW(0)
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4E:
	__PUTD1MN _Y,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4F:
	LDS  R30,_Zin
	LDS  R31,_Zin+1
	LDS  R22,_Zin+2
	LDS  R23,_Zin+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x50:
	__PUTD1MN _Z,4
	JMP  _InputXYZ

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x51:
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	LDI  R30,LOW(0)
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x52:
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
	__POINTW1MN _X,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x53:
	__GETD2N 0x0
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	__POINTW1MN _Y,4
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(0)
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
	__POINTW1MN _X,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	__GETD2N 0xC28C0000
	RCALL SUBOPT_0xF
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x57:
	__GETD1N 0x42DC0000
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	__GETD1N 0xC2700000
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x59:
	LDS  R30,_VY
	LDS  R31,_VY+1
	LDS  R22,_VY+2
	LDS  R23,_VY+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x5A:
	STS  _Y,R30
	STS  _Y+1,R31
	STS  _Y+2,R22
	STS  _Y+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5B:
	__GETD2N 0xC28C0000
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x59
	CALL __ANEGF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5C:
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x5A
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5D:
	LDI  R30,LOW(0)
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	RJMP SUBOPT_0x59

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5E:
	RCALL SUBOPT_0x5A
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5F:
	RCALL SUBOPT_0x59
	CALL __ANEGF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	__GETD1N 0xC2820000
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x61:
	__GETD2N 0x42C80000
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x62:
	__POINTW1MN _Z,4
	__GETD2N 0xC25C0000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x63:
	__GETD1N 0xC2820000
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x59
	LDS  R26,_VY
	LDS  R27,_VY+1
	LDS  R24,_VY+2
	LDS  R25,_VY+3
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x65:
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	__GETD1N 0x0
	CALL __NED12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x67:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x68:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x69:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6A:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6B:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6C:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6E:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	RCALL SUBOPT_0x6F
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x75:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x76:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x77:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x78:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x79:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7A:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7B:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7C:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7D:
	RCALL SUBOPT_0x78
	RJMP SUBOPT_0x79

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7E:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7F:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x80:
	RCALL SUBOPT_0x7B
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x81:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x82:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x83:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x84:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x85:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x86:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x87:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x89:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8B:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8C:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8E:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x8E
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x90:
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x91:
	__PUTD1S 5
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x92:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x93:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x94:
	CALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x95:
	RCALL SUBOPT_0x93
	CALL __ANEGF1
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x96:
	RCALL SUBOPT_0x93
	RCALL SUBOPT_0x92
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x97:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x98:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x99:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9A:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9B:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9C:
	__GETD1N 0xBF800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	__GETD1N 0x7F7FFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9F:
	RCALL SUBOPT_0x8E
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

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
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

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
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
