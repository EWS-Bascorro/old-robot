
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega2560
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 2048 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega2560
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8192
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _robot_msb=R6
	.DEF _delay=R7
	.DEF _delay_msb=R8
	.DEF _tango=R9
	.DEF _tango_msb=R10
	.DEF _tangi=R11
	.DEF _tangi_msb=R12
	.DEF _countTick=R13
	.DEF _countTick_msb=R14
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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

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
	.DB  0x2C,0x1
_0xE:
	.DB  0x2C,0x1
_0xF:
	.DB  0x2C,0x1
_0x10:
	.DB  0x2C,0x1
_0x11:
	.DB  0x58,0x2
_0x12:
	.DB  0x57
_0x13:
	.DB  0x48
_0x0:
	.DB  0x63,0x61,0x72,0x69,0x20,0x62,0x6F,0x6C
	.DB  0x61,0x20,0x25,0x64,0x20,0x25,0x64,0x20
	.DB  0x3D,0x3D,0x20,0x25,0x64,0x20,0xD,0xA
	.DB  0x0,0x63,0x61,0x72,0x69,0x20,0x62,0x6F
	.DB  0x6C,0x61,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x3D,0x3D,0x20,0x25,0x64,0xD,0xA
	.DB  0x0,0x68,0x61,0x6C,0x61,0x75,0x20,0x62
	.DB  0x6F,0x6C,0x61,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x3D,0x3D,0x20,0x25,0x64,0x20
	.DB  0xD,0xA,0x0,0x68,0x61,0x6C,0x61,0x75
	.DB  0x20,0x62,0x6F,0x6C,0x61,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x3D,0x3D,0x20,0x25
	.DB  0x64,0xD,0xA,0x0,0x50,0x49,0x44,0x20
	.DB  0x53,0x65,0x72,0x76,0x6F,0x20,0x2D,0x2D
	.DB  0x20,0x26,0x64,0x20,0x2D,0x2D,0x20,0x25
	.DB  0x64,0x20,0x2D,0x2D,0x20,0x25,0x64,0x20
	.DB  0x2D,0x2D,0x20,0x25,0x64,0xD,0xA,0x0
	.DB  0x25,0x64,0x20,0x73,0x65,0x72,0x6F,0x6E
	.DB  0x67,0x20,0x6B,0x69,0x72,0x69,0x20,0x62
	.DB  0x6F,0x73,0xD,0xA,0x0,0x25,0x64,0x20
	.DB  0x6D,0x61,0x6A,0x75,0x20,0x6A,0x61,0x6C
	.DB  0x61,0x6E,0xD,0xA,0x0,0x25,0x64,0x20
	.DB  0x73,0x65,0x72,0x6F,0x6E,0x67,0x20,0x6B
	.DB  0x61,0x6E,0x61,0x6E,0xD,0xA,0x0,0x25
	.DB  0x64,0x20,0x54,0x65,0x6E,0x64,0x61,0x6E
	.DB  0x67,0xD,0xA,0x0,0x41,0x6D,0x62,0x72
	.DB  0x75,0x6B,0x20,0x64,0x65,0x70,0x61,0x6E
	.DB  0x20,0x20,0x25,0x64,0xD,0xA,0x0,0x41
	.DB  0x6D,0x62,0x72,0x75,0x6B,0x20,0x62,0x65
	.DB  0x6C,0x61,0x6B,0x61,0x6E,0x67,0x20,0x20
	.DB  0x25,0x64,0xD,0xA,0x0,0x63,0x65,0x6B
	.DB  0x20,0x41,0x6D,0x62,0x72,0x75,0x6B,0x20
	.DB  0x64,0x65,0x70,0x61,0x6E,0x20,0x25,0x64
	.DB  0xD,0xA,0x0,0x63,0x65,0x6B,0x20,0x41
	.DB  0x6D,0x62,0x72,0x75,0x6B,0x20,0x62,0x65
	.DB  0x6C,0x61,0x6B,0x61,0x6E,0x67,0x20,0x25
	.DB  0x64,0xD,0xA,0x0,0x70,0x72,0x6F,0x73
	.DB  0x65,0x73,0x20,0x62,0x61,0x6E,0x67,0x75
	.DB  0x6E,0x20,0x64,0x65,0x70,0x61,0x6E,0x20
	.DB  0x25,0x64,0xD,0xA,0x0,0x77,0x65,0x73
	.DB  0xD,0xA,0x0,0x70,0x72,0x6F,0x73,0x65
	.DB  0x73,0x20,0x62,0x61,0x6E,0x67,0x75,0x6E
	.DB  0x20,0x62,0x65,0x6C,0x61,0x6B,0x61,0x6E
	.DB  0x67,0x20,0x25,0x64,0xD,0xA,0x0,0x57
	.DB  0x65,0x73,0x20,0x63,0x6F,0x6B,0xD,0xA
	.DB  0x0,0x43,0x61,0x72,0x69,0x20,0x42,0x6F
	.DB  0x6C,0x61,0x20,0x4C,0x61,0x67,0x69,0x20
	.DB  0x25,0x64,0x20,0x2D,0x20,0x25,0x64,0xD
	.DB  0xA,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
	.DW  __REG_VARS*2

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
	.DW  _hitungTendang
	.DW  _0x11*2

	.DW  0x01
	.DW  _spx
	.DW  _0x12*2

	.DW  0x01
	.DW  _spy
	.DW  _0x13*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
;//Bismillah KRI Nasional 2019 UDINUS Semarang
;//EWS Bascorro v3
;//Authors: Mas Ambon, Mas Hanif, Krismon
;//Penyerang 1
;//Last Modified 20 Juni 2019
;
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
;void tendang_dik();
;void taskGerakan();
;void inversKinematic();
;void InputXYZ();
;void maju();
;void mundur();
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
; 0000 0044 ;
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
; 0000 0058 ;
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
; 0000 006E ;
;// ---------------- Variabel case case an ----------------//
;int state = 1;
;int kiper = 0;
;int cariBola = 0;
;int jalan;
;int de;
;int ndingkluk = 0;
;int kondisiAmbrukDepan,kondisiAmbrukBelakang;
;int hitungNgawur = 300;//1000
;int delayNgawur = 300; //1000
;int hitungWaras = 300;//1605;
;int delayWaras = 300;//1605;
;int hitungTendang = 600;
;
;// ---------------- End of variabel case -----------------//
;
;int spx = 87,spy = 72,errorx,errory,px,py,mvx,mvy;
;int sudah = 0;
;void kiper_kucing();
;void siap_kanan();
;void siap_kiri();
;void cari_bola();
;void pid_servo();
;void halau_kanan();
;void halau_kiri()   ;
;void berjalan();
;void nek_ambruk();
;void cek_ambruk();
;void cari_lagi();
;void tes_1500();
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
; 0000 008F ;
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
;unsigned char DataMasukR[10],DataRxR,CountRxR;
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
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    TCNT2=240;
	LDI  R30,LOW(240)
	STS  178,R30
;    counterTG++;
	LDI  R26,LOW(_counterTG)
	LDI  R27,HIGH(_counterTG)
	CALL SUBOPT_0x0
;    if(counterDelay>0)
	CALL SUBOPT_0x1
	BRGE _0x14
;        counterDelay--;
	LDI  R26,LOW(_counterDelay)
	LDI  R27,HIGH(_counterDelay)
	CALL SUBOPT_0x2
;}
_0x14:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void init()
;{
_init:
; .FSTART _init
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
;// USART0 initialization
;// Communication Parameters: 8 Data, 1 Stop, No Parity
;// USART0 Receiver: Off
;// USART0 Transmitter: On
;// USART0 Mode: Asynchronous
;// USART0 Baud Rate: 9600
;UCSR0A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
;UCSR0B=0x08;
	LDI  R30,LOW(8)
	STS  193,R30
;UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
;UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
;UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
;    /*
;    UCSR2A=0x00;
;    UCSR2B=0x90;
;    UCSR2C=0x06;
;    UBRR2H=0x00;
;    UBRR2L=0x08;
;    */
;// USART2 initialization
;// Communication Parameters: 8 Data, 1 Stop, No Parity
;// USART2 Receiver: On
;// USART2 Transmitter: Off
;// USART2 Mode: Asynchronous
;// USART2 Baud Rate: 9600
;UCSR2A=0x00;
	LDI  R30,LOW(0)
	STS  208,R30
;UCSR2B=0x90;
	LDI  R30,LOW(144)
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
	CALL SUBOPT_0x3
	CALL __MULF12
	STS  _L1Kuadrat,R30
	STS  _L1Kuadrat+1,R31
	STS  _L1Kuadrat+2,R22
	STS  _L1Kuadrat+3,R23
;    L2Kuadrat = L2 * L2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
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
	CALL SUBOPT_0x6
	STS  _L3Kuadrat,R30
	STS  _L3Kuadrat+1,R31
	STS  _L3Kuadrat+2,R22
	STS  _L3Kuadrat+3,R23
;    L4Kuadrat = L4 * L4;
	LDS  R30,_L4
	LDS  R31,_L4+1
	LDS  R22,_L4+2
	LDS  R23,_L4+3
	CALL SUBOPT_0x7
	CALL __MULF12
	STS  _L4Kuadrat,R30
	STS  _L4Kuadrat+1,R31
	STS  _L4Kuadrat+2,R22
	STS  _L4Kuadrat+3,R23
;
;    for (countNo = 0; countNo < 2; countNo++) {
	CALL SUBOPT_0x8
_0x16:
	CALL SUBOPT_0x9
	BRGE _0x17
;      Xset[countNo] = initPositionX; Yset[countNo] = initPositionY; Zset[countNo] = initPositionZ;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	CALL SUBOPT_0x10
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
;    }
	CALL SUBOPT_0x13
	RJMP _0x16
_0x17:
;
;    X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x14
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
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x0
	RJMP _0x19
_0x1A:
;
;}
	RET
; .FEND
;
;interrupt [EXT_INT3] void ext_int3_isr(void)
;{
_ext_int3_isr:
; .FSTART _ext_int3_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    countBall++;
	LDI  R26,LOW(_countBall)
	LDI  R27,HIGH(_countBall)
	CALL SUBOPT_0x0
;
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)
;{
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
;}
	RETI
; .FEND
;
;
;// Terima data dari Raspi
;interrupt [USART2_RXC] void usart2_rx_isr(void) //TERIMA DATA DARI RASPI
;{
_usart2_rx_isr:
; .FSTART _usart2_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;char DataRxR;
;DataRxR=UDR2;
	ST   -Y,R17
;	DataRxR -> R17
	LDS  R17,214
;switch (CountRxR){
	LDS  R30,_CountRxR
	LDI  R31,0
;case 0:
	SBIW R30,0
	BRNE _0x1E
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x1F
	LDI  R30,LOW(1)
	STS  _CountRxR,R30
;break;
_0x1F:
	RJMP _0x1D
;case 1:
_0x1E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x21
	LDI  R30,LOW(1)
	RJMP _0x273
;else {DataMasukR[0]=DataRxR; pos_x = (int)DataMasukR[0]*2; CountRxR=2;}
_0x21:
	STS  _DataMasukR,R17
	LDS  R26,_DataMasukR
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	STS  _pos_x,R30
	STS  _pos_x+1,R31
	LDI  R30,LOW(2)
_0x273:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 2:
_0x20:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x23
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x24
	LDI  R30,LOW(1)
	RJMP _0x274
;else {DataMasukR[1]=DataRxR; pos_y = (int)DataMasukR[1]; CountRxR=3;}
_0x24:
	__PUTBMRN _DataMasukR,1,17
	__GETB1MN _DataMasukR,1
	LDI  R31,0
	STS  _pos_y,R30
	STS  _pos_y+1,R31
	LDI  R30,LOW(3)
_0x274:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 3:
_0x23:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x26
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x27
	LDI  R30,LOW(1)
	RJMP _0x275
;else {DataMasukR[2]=DataRxR; CountRxR=4;}
_0x27:
	__PUTBMRN _DataMasukR,2,17
	LDI  R30,LOW(4)
_0x275:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 4:
_0x26:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x29
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x2A
	LDI  R30,LOW(1)
	RJMP _0x276
;else {DataMasukR[3]=DataRxR; CountRxR=5;}
_0x2A:
	__PUTBMRN _DataMasukR,3,17
	LDI  R30,LOW(5)
_0x276:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 5:
_0x29:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2C
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x2D
	LDI  R30,LOW(1)
	RJMP _0x277
;else {DataMasukR[4]=DataRxR; CountRxR=6;}
_0x2D:
	__PUTBMRN _DataMasukR,4,17
	LDI  R30,LOW(6)
_0x277:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 6:
_0x2C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2F
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x30
	LDI  R30,LOW(1)
	RJMP _0x278
;else {DataMasukR[5]=DataRxR; CountRxR=7;}
_0x30:
	__PUTBMRN _DataMasukR,5,17
	LDI  R30,LOW(7)
_0x278:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 7:
_0x2F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x32
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x33
	LDI  R30,LOW(1)
	RJMP _0x279
;else {DataMasukR[6]=DataRxR; CountRxR=8;}
_0x33:
	__PUTBMRN _DataMasukR,6,17
	LDI  R30,LOW(8)
_0x279:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 8:
_0x32:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x35
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x36
	LDI  R30,LOW(1)
	RJMP _0x27A
;else {DataMasukR[7]=DataRxR; CountRxR=9;}
_0x36:
	__PUTBMRN _DataMasukR,7,17
	LDI  R30,LOW(9)
_0x27A:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 9:
_0x35:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x38
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x39
	LDI  R30,LOW(1)
	RJMP _0x27B
;else {DataMasukR[8]=DataRxR; CountRxR=10;}
_0x39:
	__PUTBMRN _DataMasukR,8,17
	LDI  R30,LOW(10)
_0x27B:
	STS  _CountRxR,R30
;break;
	RJMP _0x1D
;case 10:
_0x38:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x1D
;if(DataRxR==0xFF) {CountRxR=1;}
	CPI  R17,255
	BRNE _0x3C
	LDI  R30,LOW(1)
	RJMP _0x27C
;else {DataMasukR[9]=DataRxR; CountRxR=0;}
_0x3C:
	__PUTBMRN _DataMasukR,9,17
	LDI  R30,LOW(0)
_0x27C:
	STS  _CountRxR,R30
;break;
;}
_0x1D:
;
;
;}
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;
;// Terima data IMU Arduino
;interrupt [USART3_RXC] void usart3_rx_isr(void)
;{
_usart3_rx_isr:
; .FSTART _usart3_rx_isr
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
	LDI  R31,0
;case 0:
	SBIW R30,0
	BRNE _0x41
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x42
	LDI  R30,LOW(1)
	STS  _CountRx,R30
;break;
_0x42:
	RJMP _0x40
;case 1:
_0x41:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x43
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x44
	LDI  R30,LOW(1)
	RJMP _0x27D
;else {DataMasuk[0]=DataRx; miringDepan = (int) -1 *((DataMasuk[0]*2)-180); CountRx=2;}
_0x44:
	LDS  R30,_DataRx
	STS  _DataMasuk,R30
	CALL SUBOPT_0x16
	LDI  R30,LOW(2)
_0x27D:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 2:
_0x43:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x46
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x47
	LDI  R30,LOW(1)
	RJMP _0x27E
;else {DataMasuk[1]=DataRx; miringSamping = (int) -1*((DataMasuk[1]*2)-180); CountRx=3;}
_0x47:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,1
	CALL SUBOPT_0x17
	LDI  R30,LOW(3)
_0x27E:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 3:
_0x46:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x49
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x4A
	LDI  R30,LOW(1)
	RJMP _0x27F
;else {DataMasuk[2]=DataRx; kompas = (int) (DataMasuk[2]*2); CountRx=4;}
_0x4A:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,2
	CALL SUBOPT_0x18
	LDI  R30,LOW(4)
_0x27F:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 4:
_0x49:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4C
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x4D
	LDI  R30,LOW(1)
	RJMP _0x280
;else {DataMasuk[3]=DataRx; CountRx=5;}
_0x4D:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,3
	LDI  R30,LOW(5)
_0x280:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 5:
_0x4C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4F
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x50
	LDI  R30,LOW(1)
	RJMP _0x281
;else {DataMasuk[4]=DataRx; CountRx=6;}
_0x50:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,4
	LDI  R30,LOW(6)
_0x281:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 6:
_0x4F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x52
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x53
	LDI  R30,LOW(1)
	RJMP _0x282
;else {DataMasuk[5]=DataRx; CountRx=7;}
_0x53:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,5
	LDI  R30,LOW(7)
_0x282:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 7:
_0x52:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x55
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x56
	LDI  R30,LOW(1)
	RJMP _0x283
;else {DataMasuk[6]=DataRx; CountRx=8;}
_0x56:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,6
	LDI  R30,LOW(8)
_0x283:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 8:
_0x55:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x58
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x59
	LDI  R30,LOW(1)
	RJMP _0x284
;else {DataMasuk[7]=DataRx; CountRx=9;}
_0x59:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,7
	LDI  R30,LOW(9)
_0x284:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 9:
_0x58:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x5B
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x5C
	LDI  R30,LOW(1)
	RJMP _0x285
;else {DataMasuk[8]=DataRx; CountRx=10;}
_0x5C:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,8
	LDI  R30,LOW(10)
_0x285:
	STS  _CountRx,R30
;break;
	RJMP _0x40
;case 10:
_0x5B:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x40
;if(DataRx==0xFF) {CountRx=1;}
	LDS  R26,_DataRx
	CPI  R26,LOW(0xFF)
	BRNE _0x5F
	LDI  R30,LOW(1)
	RJMP _0x286
;else {DataMasuk[9]=DataRx; CountRx=0;}
_0x5F:
	LDS  R30,_DataRx
	__PUTB1MN _DataMasuk,9
	LDI  R30,LOW(0)
_0x286:
	STS  _CountRx,R30
;break;
;}
_0x40:
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
; .FEND
;
;void konversi_ardu(){
_konversi_ardu:
; .FSTART _konversi_ardu
;    miringDepan = (int) -1 *((DataMasuk[0]*2)-180);
	CALL SUBOPT_0x16
;    miringSamping = (int) -1*((DataMasuk[1]*2)-180);
	CALL SUBOPT_0x17
;    kompas = (int) (DataMasuk[2]*2);
	CALL SUBOPT_0x18
;}
	RET
; .FEND
;
;void konversi_raspi(){
_konversi_raspi:
; .FSTART _konversi_raspi
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
; .FEND
;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;{
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;  switch (Timeslot)
	MOV  R30,R3
	LDI  R31,0
;  {
;    case 0:
	SBIW R30,0
	BRNE _0x64
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
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[0] + servo[0])) + timer3ms) & 0xff;
	LDS  R30,_servo
	LDS  R26,_servoInitError
	CALL SUBOPT_0x1B
;      OCR1BH = ((6000-2 * (servoInitError[6] + servo[6])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,12
	__GETW1MN _servo,12
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	STS  139,R30
;      OCR1BL = ((6000-2 * (servoInitError[6] + servo[6])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,12
	__GETB1MN _servo,12
	CALL SUBOPT_0x1D
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
;      break;
	RJMP _0x63
;
;    case 1:
_0x64:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x67
;      kaka2_1;
	LDS  R30,267
	ORI  R30,8
	STS  267,R30
;      kaki2 = 1;
	SBI  0x8,6
;      OCR1AH = ((2 * (servoInitError[1] + servo[1])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,2
	__GETW1MN _servo,2
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[1] + servo[1])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,2
	__GETB1MN _servo,2
	CALL SUBOPT_0x1B
;      OCR1BH = ((6000-2 * (servoInitError[7] + servo[7])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,14
	__GETW1MN _servo,14
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	STS  139,R30
;      OCR1BL = ((6000-2 * (servoInitError[7] + servo[7])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,14
	__GETB1MN _servo,14
	CALL SUBOPT_0x1D
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 2;
	LDI  R30,LOW(2)
	MOV  R3,R30
;      break;
	RJMP _0x63
;
;    case 2:
_0x67:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6A
;      kaka3_1;
	LDS  R30,267
	ORI  R30,0x10
	STS  267,R30
;      kaki3 = 1;
	SBI  0x2,6
;      OCR1AH = ((6000-2 * (servoInitError[2] + servo[2])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,4
	__GETW1MN _servo,4
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	STS  137,R30
;      OCR1AL = ((6000-2 * (servoInitError[2] + servo[2])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,4
	__GETB1MN _servo,4
	CALL SUBOPT_0x1E
;      OCR1BH = ((2 * (servoInitError[8] + servo[8])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,16
	__GETW1MN _servo,16
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  139,R30
;      OCR1BL = ((2 * (servoInitError[8] + servo[8])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,16
	__GETB1MN _servo,16
	CALL SUBOPT_0x1F
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 3;
	LDI  R30,LOW(3)
	MOV  R3,R30
;      break;
	RJMP _0x63
;
;    case 3:
_0x6A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6D
;      kaka4_1;
	LDS  R30,267
	ORI  R30,0x20
	STS  267,R30
;      kaki4 = 1;
	SBI  0x2,7
;      OCR1AH = ((6000-2 * (servoInitError[3] + servo[3])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,6
	__GETW1MN _servo,6
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	STS  137,R30
;      OCR1AL = ((6000-2 * (servoInitError[3] + servo[3])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,6
	__GETB1MN _servo,6
	CALL SUBOPT_0x1E
;      OCR1BH = ((2 * (servoInitError[9] + servo[9])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,18
	__GETW1MN _servo,18
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  139,R30
;      OCR1BL = ((2 * (servoInitError[9] + servo[9])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,18
	__GETB1MN _servo,18
	CALL SUBOPT_0x1F
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 4;
	LDI  R30,LOW(4)
	MOV  R3,R30
;      break;
	RJMP _0x63
;
;    case 4:
_0x6D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x70
;      kaka5_1;
	LDS  R30,267
	ORI  R30,0x40
	STS  267,R30
;      kaki5 = 1;
	SBI  0x2,4
;      OCR1AH = ((2 * (servoInitError[4] + servo[4])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,8
	__GETW1MN _servo,8
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[4] + servo[4])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,8
	__GETB1MN _servo,8
	CALL SUBOPT_0x1B
;      OCR1BH = ((6000-2 * (servoInitError[10] + servo[10])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,20
	__GETW1MN _servo,20
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	STS  139,R30
;      OCR1BL = ((6000-2 * (servoInitError[10] + servo[10])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,20
	__GETB1MN _servo,20
	CALL SUBOPT_0x1D
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 5;
	LDI  R30,LOW(5)
	MOV  R3,R30
;      break;
	RJMP _0x63
;
;    case 5:
_0x70:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x73
;      kaka6_1;
	LDS  R30,267
	ORI  R30,0x80
	STS  267,R30
;      kaki6 = 1;
	SBI  0x2,5
;      OCR1AH = ((2 * (servoInitError[5] + servo[5])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,10
	__GETW1MN _servo,10
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  137,R30
;      OCR1AL = ((2 * (servoInitError[5] + servo[5])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,10
	__GETB1MN _servo,10
	CALL SUBOPT_0x1B
;      OCR1BH = ((2 * (servoInitError[11] + servo[11])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,22
	__GETW1MN _servo,22
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  139,R30
;      OCR1BL = ((2 * (servoInitError[11] + servo[11])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,22
	__GETB1MN _servo,22
	CALL SUBOPT_0x1F
;      TCNT1H = timer3ms >> 8;
;      TCNT1L = timer3ms & 0xff;
;      Timeslot = 6;
	LDI  R30,LOW(6)
	MOV  R3,R30
;      break;
	RJMP _0x63
;
;    case 6:
_0x73:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x63
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
_0x63:
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
; .FEND
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;{
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	CALL SUBOPT_0x20
;switch (Timeslot)
;    {
;    case 0:
	BREQ _0x79
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7B
;            kaka1_0;
	LDS  R30,267
	ANDI R30,0xFB
	RJMP _0x287
;    break;
;
;    case 2:
_0x7B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7C
;            kaka2_0;
	LDS  R30,267
	ANDI R30,0XF7
	RJMP _0x287
;    break;
;
;    case 3:
_0x7C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7D
;            kaka3_0;
	LDS  R30,267
	ANDI R30,0xEF
	RJMP _0x287
;    break;
;
;    case 4:
_0x7D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x7E
;            kaka4_0;
	LDS  R30,267
	ANDI R30,0xDF
	RJMP _0x287
;    break;
;
;    case 5:
_0x7E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x7F
;            kaka5_0;
	LDS  R30,267
	ANDI R30,0xBF
	RJMP _0x287
;    break;
;
;    case 6:
_0x7F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x79
;            kaka6_0;
	LDS  R30,267
	ANDI R30,0x7F
_0x287:
	STS  267,R30
;    break;
;    }
_0x79:
;
;}
	RJMP _0x29D
; .FEND
;
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
;{
_timer1_compb_isr:
; .FSTART _timer1_compb_isr
	CALL SUBOPT_0x20
;switch (Timeslot)
;    {
;    case 0:
	BREQ _0x83
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x85
;            kaki1 = 0;
	CBI  0x8,7
;    break;
	RJMP _0x83
;
;    case 2:
_0x85:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x88
;            kaki2 = 0;
	CBI  0x8,6
;    break;
	RJMP _0x83
;
;    case 3:
_0x88:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8B
;            kaki3 = 0;
	CBI  0x2,6
;    break;
	RJMP _0x83
;
;    case 4:
_0x8B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8E
;            kaki4 = 0;
	CBI  0x2,7
;    break;
	RJMP _0x83
;
;    case 5:
_0x8E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x91
;            kaki5 = 0;
	CBI  0x2,4
;    break;
	RJMP _0x83
;
;    case 6:
_0x91:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x83
;            kaki6 = 0;
	CBI  0x2,5
;    break;
;    }
_0x83:
;
;
;}
	RJMP _0x29D
; .FEND
;
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
;{
_timer3_ovf_isr:
; .FSTART _timer3_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;  switch (Timeslot2)
	CALL SUBOPT_0x21
;  {
;    case 0:
	BRNE _0x9A
;      taka1 = 1;
	SBI  0x11,0
;      taki1 = 1;
	SBI  0x11,7
;      OCR3AH = ((2 * (servoInitError[12] + servo[12])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,24
	__GETW1MN _servo,24
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[12] + servo[12])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,24
	__GETB1MN _servo,24
	CALL SUBOPT_0x22
;      OCR3BH = ((2 * (servoInitError[15] + servo[15])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,30
	__GETW1MN _servo,30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[15] + servo[15])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,30
	__GETB1MN _servo,30
	CALL SUBOPT_0x23
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 1;
	LDI  R30,LOW(1)
	RJMP _0x288
;      break;
;
;    case 1:
_0x9A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9F
;      taka2 = 1;
	SBI  0x11,1
;      taki2 = 1;
	SBI  0x11,6
;      OCR3AH = ((2 * (servoInitError[13] + servo[13])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,26
	CALL SUBOPT_0x24
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[13] + servo[13])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,26
	__GETB1MN _servo,26
	CALL SUBOPT_0x22
;      OCR3BH = ((2 * (servoInitError[16] + servo[16])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,32
	CALL SUBOPT_0x25
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[16] + servo[16])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,32
	__GETB1MN _servo,32
	CALL SUBOPT_0x23
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 2;
	LDI  R30,LOW(2)
	RJMP _0x288
;      break;
;
;    case 2:
_0x9F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA4
;      taka3 = 1;
	SBI  0x11,2
;      taki3 = 1;
	SBI  0x11,5
;      OCR3AH = ((2 * (servoInitError[14] + servo[14])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,28
	__GETW1MN _servo,28
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[14] + servo[14])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,28
	__GETB1MN _servo,28
	CALL SUBOPT_0x22
;      OCR3BH = ((2 * (servoInitError[17] + servo[17])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,34
	__GETW1MN _servo,34
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[17] + servo[17])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,34
	__GETB1MN _servo,34
	CALL SUBOPT_0x23
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 3;
	LDI  R30,LOW(3)
	RJMP _0x288
;      break;
;
;    case 3:
_0xA4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA9
;      pala1 = 1;
	SBI  0x11,3
;      pala2 = 1;
	SBI  0x11,4
;      OCR3AH = ((2 * (servoInitError[18] + servo[18])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,36
	CALL SUBOPT_0x26
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  153,R30
;      OCR3AL = ((2 * (servoInitError[18] + servo[18])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,36
	__GETB1MN _servo,36
	CALL SUBOPT_0x22
;      OCR3BH = ((2 * (servoInitError[19] + servo[19])) + timer3ms) >> 8;
	__GETW2MN _servoInitError,38
	CALL SUBOPT_0x27
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  155,R30
;      OCR3BL = ((2 * (servoInitError[19] + servo[19])) + timer3ms) & 0xff;
	__GETB2MN _servoInitError,38
	__GETB1MN _servo,38
	CALL SUBOPT_0x23
;      TCNT3H = timer3ms >> 8;
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 4;
	LDI  R30,LOW(4)
	RJMP _0x288
;      break;
;
;    case 4:
_0xA9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xAE
;
;        if(hitungTendang > 0){
	LDS  R26,_hitungTendang
	LDS  R27,_hitungTendang+1
	CALL __CPW02
	BRGE _0xAF
;            hitungTendang--;
	LDI  R26,LOW(_hitungTendang)
	LDI  R27,HIGH(_hitungTendang)
	CALL SUBOPT_0x2
;        }
;
;        if(hitung > 0){
_0xAF:
	LDS  R26,_hitung
	LDS  R27,_hitung+1
	CALL __CPW02
	BRGE _0xB0
;         hitung--;
	LDI  R26,LOW(_hitung)
	LDI  R27,HIGH(_hitung)
	CALL SUBOPT_0x2
;        }
;
;        if(hitungNgawur > 0){
_0xB0:
	LDS  R26,_hitungNgawur
	LDS  R27,_hitungNgawur+1
	CALL __CPW02
	BRGE _0xB1
;         hitungNgawur--;
	LDI  R26,LOW(_hitungNgawur)
	LDI  R27,HIGH(_hitungNgawur)
	CALL SUBOPT_0x2
;        }
;
;        if(hitungWaras > 0){
_0xB1:
	CALL SUBOPT_0x28
	BRGE _0xB2
;         hitungWaras--;
	LDI  R26,LOW(_hitungWaras)
	LDI  R27,HIGH(_hitungWaras)
	CALL SUBOPT_0x2
;        }
;
;      TCNT3H = timer3ms >> 8;
_0xB2:
	CALL SUBOPT_0x29
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 5;
	LDI  R30,LOW(5)
	RJMP _0x288
;      break;
;
;    case 5:
_0xAE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB3
;        //miringDepan = (int) -1 *((DataMasuk[0]*2)-180);
;        //miringSamping = (int) -1*((DataMasuk[1]*2)-180);
;//        kompas = (int) (DataMasuk[2]*2);
;//
;//        pos_x = (int)DataMasukR[0]*2;
;//        pos_y = (int)DataMasukR[1];
;//
;          konversi_raspi();
	RCALL _konversi_raspi
;      TCNT3H = timer3ms >> 8;
	CALL SUBOPT_0x29
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 6;
	LDI  R30,LOW(6)
	RJMP _0x288
;      break;
;
;    case 6:
_0xB3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x99
;        count++;
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	CALL SUBOPT_0x0
;        if(count>=30){
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,30
	BRLT _0xB5
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
_0xB5:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0xB6
	SBI  0x14,7
;        else if (Ball <= 5) buzzoff;
	RJMP _0xB7
_0xB6:
	CALL SUBOPT_0x2A
	SBIW R26,6
	BRGE _0xB8
	CBI  0x14,7
;
;
;      TCNT3H = timer3ms >> 8;
_0xB8:
_0xB7:
	CALL SUBOPT_0x29
;      TCNT3L = timer3ms & 0xff;
;      Timeslot2 = 0;
	LDI  R30,LOW(0)
_0x288:
	STS  _Timeslot2,R30
;  }
_0x99:
;
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM3_COMPA] void timer3_compa_isr(void)
;{
_timer3_compa_isr:
; .FSTART _timer3_compa_isr
	CALL SUBOPT_0x2B
;switch (Timeslot2)
;    {
;    case 0:
	BREQ _0xBB
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBD
;            taka1 = 0;
	CBI  0x11,0
;    break;
	RJMP _0xBB
;
;    case 2:
_0xBD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC0
;            taka2 = 0;
	CBI  0x11,1
;    break;
	RJMP _0xBB
;
;    case 3:
_0xC0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC3
;            taka3 = 0;
	CBI  0x11,2
;    break;
	RJMP _0xBB
;
;    case 4:
_0xC3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC6
;            pala1 = 0;
	CBI  0x11,3
;    break;
;
;    case 5:
_0xC6:
;
;    break;
;
;    case 6:
;
;    break;
;    }
_0xBB:
;
;}
	RJMP _0x29D
; .FEND
;
;interrupt [TIM3_COMPB] void timer3_compb_isr(void)
;{
_timer3_compb_isr:
; .FSTART _timer3_compb_isr
	CALL SUBOPT_0x2B
;switch (Timeslot2)
;    {
;    case 0:
	BREQ _0xCD
;    break;
;
;    case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xCF
;            taki1 = 0;
	CBI  0x11,7
;    break;
	RJMP _0xCD
;
;    case 2:
_0xCF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD2
;            taki2 = 0;
	CBI  0x11,6
;    break;
	RJMP _0xCD
;
;    case 3:
_0xD2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD5
;            taki3 = 0;
	CBI  0x11,5
;    break;
	RJMP _0xCD
;
;    case 4:
_0xD5:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xD8
;            pala2 = 0;
	CBI  0x11,4
;    break;
;
;    case 5:
_0xD8:
;
;    break;
;
;    case 6:
;
;    break;
;    }
_0xCD:
;}
_0x29D:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void taskGerakan()
; 0000 0092 {
_taskGerakan:
; .FSTART _taskGerakan
; 0000 0093     if (langkah <= 0)
	LDS  R26,_langkah
	LDS  R27,_langkah+1
	CALL __CPW02
	BRGE PC+2
	RJMP _0xDD
; 0000 0094     {
; 0000 0095 //        printf("===XYZ %0.2f %0.2f %0.2f || ",X[0],Y[0],Z[0]);
; 0000 0096 //        printf("===XYZ %0.2f %0.2f %0.2f \n",X[1],Y[1],Z[1]);
; 0000 0097 
; 0000 0098         if (VX != 0 || VY != 0 || W != 0)
	CALL SUBOPT_0x2C
	BRNE _0xDF
	CALL SUBOPT_0x2D
	BRNE _0xDF
	CALL SUBOPT_0x2E
	BREQ _0xDE
_0xDF:
; 0000 0099         {
; 0000 009A           countGerakan++;
	LDI  R26,LOW(_countGerakan)
	LDI  R27,HIGH(_countGerakan)
	CALL SUBOPT_0x0
; 0000 009B         }
; 0000 009C         else
	RJMP _0xE1
_0xDE:
; 0000 009D         {
; 0000 009E           countGerakan = 0;
	LDI  R30,LOW(0)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R30
; 0000 009F         }
_0xE1:
; 0000 00A0 
; 0000 00A1         if (countGerakan > jumlahGerak)
	LDS  R30,_jumlahGerak
	LDS  R31,_jumlahGerak+1
	LDS  R26,_countGerakan
	LDS  R27,_countGerakan+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xE2
; 0000 00A2         {
; 0000 00A3           if (VX != 0 || VY != 0 || W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0xE4
	CALL SUBOPT_0x2D
	BRNE _0xE4
	CALL SUBOPT_0x2E
	BREQ _0xE3
_0xE4:
; 0000 00A4             countGerakan = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R31
; 0000 00A5           else
	RJMP _0xE6
_0xE3:
; 0000 00A6             countGerakan = 0;
	LDI  R30,LOW(0)
	STS  _countGerakan,R30
	STS  _countGerakan+1,R30
; 0000 00A7         }
_0xE6:
; 0000 00A8 
; 0000 00A9         langkah = langkahMax;
_0xE2:
	CALL SUBOPT_0x2F
	STS  _langkah,R30
	STS  _langkah+1,R31
; 0000 00AA         for (countNo = 0; countNo < 2; countNo++)
	CALL SUBOPT_0x8
_0xE8:
	CALL SUBOPT_0x9
	BRLT PC+2
	RJMP _0xE9
; 0000 00AB         {
; 0000 00AC             Xerror[countNo] = (X[countNo] - Xset[countNo]) / langkahMax;
	CALL SUBOPT_0x30
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	CALL SUBOPT_0x34
; 0000 00AD             Yerror[countNo] = (Y[countNo] - Yset[countNo]) / langkahMax;
	LDI  R26,LOW(_Yerror)
	LDI  R27,HIGH(_Yerror)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	LDI  R26,LOW(_Y)
	LDI  R27,HIGH(_Y)
	CALL SUBOPT_0x36
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xE
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	CALL SUBOPT_0x34
; 0000 00AE             Zerror[countNo] = (Z[countNo] - Zset[countNo]) / langkahMax;
	LDI  R26,LOW(_Zerror)
	LDI  R27,HIGH(_Zerror)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	LDI  R26,LOW(_Z)
	LDI  R27,HIGH(_Z)
	CALL SUBOPT_0x36
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0x10
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00AF         }
	CALL SUBOPT_0x13
	RJMP _0xE8
_0xE9:
; 0000 00B0     }
; 0000 00B1     else
	RJMP _0xEA
_0xDD:
; 0000 00B2     {
; 0000 00B3         for (countNo = 0; countNo < 2; countNo++)
	CALL SUBOPT_0x8
_0xEC:
	CALL SUBOPT_0x9
	BRLT PC+2
	RJMP _0xED
; 0000 00B4         {
; 0000 00B5             Xset[countNo] += Xerror[countNo]; Yset[countNo] += Yerror[countNo]; Zset[countNo] += Zerror[countNo];
	CALL SUBOPT_0xA
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
	CALL SUBOPT_0x30
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x34
	CALL SUBOPT_0xE
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
	CALL SUBOPT_0xA
	LDI  R26,LOW(_Yerror)
	LDI  R27,HIGH(_Yerror)
	CALL SUBOPT_0x36
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0xA
	LDI  R26,LOW(_Zerror)
	LDI  R27,HIGH(_Zerror)
	CALL SUBOPT_0x36
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00B6         }
	CALL SUBOPT_0x13
	RJMP _0xEC
_0xED:
; 0000 00B7 //        printf("XYZset %0.2f %0.2f %0.2f || ",Xset[0],Yset[0],Zset[0]);
; 0000 00B8 //        printf("XYZset %0.2f %0.2f %0.2f \n",Xset[1],Yset[1],Zset[1]);
; 0000 00B9         inversKinematic();
	RCALL _inversKinematic
; 0000 00BA         for (countNo = 0; countNo < 12; countNo++)
	CALL SUBOPT_0x8
_0xEF:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,12
	BRGE _0xF0
; 0000 00BB         {
; 0000 00BC           if (servoSet[countNo] >= 2500)
	CALL SUBOPT_0x37
	CALL __GETW1P
	CPI  R30,LOW(0x9C4)
	LDI  R26,HIGH(0x9C4)
	CPC  R31,R26
	BRLT _0xF1
; 0000 00BD             servoSet[countNo] = 2500;
	CALL SUBOPT_0x37
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	RJMP _0x289
; 0000 00BE           else if (servoSet[countNo] <= 500)
_0xF1:
	CALL SUBOPT_0x37
	CALL __GETW1P
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRGE _0xF3
; 0000 00BF             servoSet[countNo] = 500;
	CALL SUBOPT_0x37
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
_0x289:
	ST   X+,R30
	ST   X,R31
; 0000 00C0           servo[countNo] = (int)(servoSet[countNo]);
_0xF3:
	CALL SUBOPT_0xA
	LDI  R26,LOW(_servo)
	LDI  R27,HIGH(_servo)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x37
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 00C1         }
	CALL SUBOPT_0x13
	RJMP _0xEF
_0xF0:
; 0000 00C2         langkah--;
	LDI  R26,LOW(_langkah)
	LDI  R27,HIGH(_langkah)
	CALL SUBOPT_0x2
; 0000 00C3     }
_0xEA:
; 0000 00C4 }
	RET
; .FEND
;
;void inversKinematic()
; 0000 00C7 {
_inversKinematic:
; .FSTART _inversKinematic
; 0000 00C8     for(I=0;I<2;I++)
	LDI  R30,LOW(0)
	STS  _I,R30
	STS  _I+1,R30
_0xF5:
	LDS  R26,_I
	LDS  R27,_I+1
	SBIW R26,2
	BRLT PC+2
	RJMP _0xF6
; 0000 00C9     {
; 0000 00CA       XiKuadrat = Xset[I] * Xset[I];
	CALL SUBOPT_0x38
	CALL SUBOPT_0xB
	CALL SUBOPT_0x32
	CALL SUBOPT_0x39
	STS  _XiKuadrat,R30
	STS  _XiKuadrat+1,R31
	STS  _XiKuadrat+2,R22
	STS  _XiKuadrat+3,R23
; 0000 00CB       YiKuadrat = Yset[I] * Yset[I];
	CALL SUBOPT_0x38
	CALL SUBOPT_0xE
	CALL SUBOPT_0x32
	CALL SUBOPT_0x39
	STS  _YiKuadrat,R30
	STS  _YiKuadrat+1,R31
	STS  _YiKuadrat+2,R22
	STS  _YiKuadrat+3,R23
; 0000 00CC       ZiKuadrat = Zset[I] * Zset[I];
	CALL SUBOPT_0x38
	CALL SUBOPT_0x10
	CALL SUBOPT_0x32
	CALL SUBOPT_0x39
	STS  _ZiKuadrat,R30
	STS  _ZiKuadrat+1,R31
	STS  _ZiKuadrat+2,R22
	STS  _ZiKuadrat+3,R23
; 0000 00CD 
; 0000 00CE       bi = sqrt(XiKuadrat + ZiKuadrat) - L1 - L4;
	LDS  R26,_XiKuadrat
	LDS  R27,_XiKuadrat+1
	LDS  R24,_XiKuadrat+2
	LDS  R25,_XiKuadrat+3
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	CALL __SUBF12
	CALL SUBOPT_0x7
	CALL __SUBF12
	STS  _bi,R30
	STS  _bi+1,R31
	STS  _bi+2,R22
	STS  _bi+3,R23
; 0000 00CF       biKuadrat = bi * bi;
	CALL SUBOPT_0x3B
	CALL __MULF12
	STS  _biKuadrat,R30
	STS  _biKuadrat+1,R31
	STS  _biKuadrat+2,R22
	STS  _biKuadrat+3,R23
; 0000 00D0       ai = sqrt(biKuadrat + YiKuadrat);
	LDS  R30,_YiKuadrat
	LDS  R31,_YiKuadrat+1
	LDS  R22,_YiKuadrat+2
	LDS  R23,_YiKuadrat+3
	LDS  R26,_biKuadrat
	LDS  R27,_biKuadrat+1
	LDS  R24,_biKuadrat+2
	LDS  R25,_biKuadrat+3
	CALL SUBOPT_0x3A
	STS  _ai,R30
	STS  _ai+1,R31
	STS  _ai+2,R22
	STS  _ai+3,R23
; 0000 00D1       aiKuadrat = ai * ai;
	CALL SUBOPT_0x3C
	LDS  R26,_ai
	LDS  R27,_ai+1
	LDS  R24,_ai+2
	LDS  R25,_ai+3
	CALL __MULF12
	STS  _aiKuadrat,R30
	STS  _aiKuadrat+1,R31
	STS  _aiKuadrat+2,R22
	STS  _aiKuadrat+3,R23
; 0000 00D2       gamai = atan2(Yset[I],bi);
	CALL SUBOPT_0x38
	CALL SUBOPT_0xE
	CALL SUBOPT_0x32
	CALL __PUTPARD1
	CALL SUBOPT_0x3B
	CALL _atan2
	STS  _gamai,R30
	STS  _gamai+1,R31
	STS  _gamai+2,R22
	STS  _gamai+3,R23
; 0000 00D3       A1[I] = atan2(Xset[I],Zset[I]);
	CALL SUBOPT_0x38
	LDI  R26,LOW(_A1)
	LDI  R27,HIGH(_A1)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x38
	CALL SUBOPT_0xB
	CALL SUBOPT_0x32
	CALL __PUTPARD1
	CALL SUBOPT_0x38
	CALL SUBOPT_0x10
	CALL SUBOPT_0x32
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan2
	POP  R26
	POP  R27
	CALL SUBOPT_0x3D
; 0000 00D4       A3[I] = acos((aiKuadrat - L2Kuadrat - L3Kuadrat) / (2 * L2 * L3));
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3E
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
	CALL SUBOPT_0x3F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x40
	POP  R26
	POP  R27
	CALL SUBOPT_0x3D
; 0000 00D5       ci = L3 * cos(A3[I]);
	CALL SUBOPT_0x36
	MOVW R26,R30
	MOVW R24,R22
	CALL _cos
	CALL SUBOPT_0x6
	STS  _ci,R30
	STS  _ci+1,R31
	STS  _ci+2,R22
	STS  _ci+3,R23
; 0000 00D6       betai = acos((L2 + ci) / ai);
	CALL SUBOPT_0x5
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x40
	STS  _betai,R30
	STS  _betai+1,R31
	STS  _betai+2,R22
	STS  _betai+3,R23
; 0000 00D7       A2[I] = -(gamai + betai);
	CALL SUBOPT_0x38
	LDI  R26,LOW(_A2)
	LDI  R27,HIGH(_A2)
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x41
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00D8       alphai[I] = acos((L2Kuadrat + L3Kuadrat - aiKuadrat) / (2 * L2 * L3));
	CALL SUBOPT_0x38
	LDI  R26,LOW(_alphai)
	LDI  R27,HIGH(_alphai)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	LDS  R30,_L3Kuadrat
	LDS  R31,_L3Kuadrat+1
	LDS  R22,_L3Kuadrat+2
	LDS  R23,_L3Kuadrat+3
	CALL SUBOPT_0x3E
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
	CALL SUBOPT_0x3F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x40
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00D9       A5[I] = A1[I];
	CALL SUBOPT_0x38
	LDI  R26,LOW(_A5)
	LDI  R27,HIGH(_A5)
	CALL SUBOPT_0x35
	MOVW R0,R30
	CALL SUBOPT_0x38
	LDI  R26,LOW(_A1)
	LDI  R27,HIGH(_A1)
	CALL SUBOPT_0x36
	MOVW R26,R0
	CALL __PUTDP1
; 0000 00DA     }
	LDI  R26,LOW(_I)
	LDI  R27,HIGH(_I)
	CALL SUBOPT_0x0
	RJMP _0xF5
_0xF6:
; 0000 00DB 
; 0000 00DC     //kaki kanan
; 0000 00DD     sudutSet[5]  = 90+0; //pinggul
	__POINTW1MN _sudutSet,20
	CALL SUBOPT_0x42
	CALL SUBOPT_0x12
; 0000 00DE     sudutSet[4]  = (A1[0] * (rad))+90;
	CALL SUBOPT_0x43
	LDS  R26,_A1
	LDS  R27,_A1+1
	LDS  R24,_A1+2
	LDS  R25,_A1+3
	CALL SUBOPT_0x44
	__PUTD1MN _sudutSet,16
; 0000 00DF     sudutSet[3]  = (A2[0] * (rad));
	CALL SUBOPT_0x43
	LDS  R26,_A2
	LDS  R27,_A2+1
	LDS  R24,_A2+2
	LDS  R25,_A2+3
	CALL __MULF12
	CALL SUBOPT_0x45
; 0000 00E0     sudutSet[2]  = (A3[0] * (rad))+90+5;
	CALL SUBOPT_0x43
	LDS  R26,_A3
	LDS  R27,_A3+1
	LDS  R24,_A3+2
	LDS  R25,_A3+3
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	__PUTD1MN _sudutSet,8
; 0000 00E1     sudutSet[1]  = (-(180 - (alphai[0] * (rad)) + (sudutSet[3])))+83;
	CALL SUBOPT_0x43
	LDS  R26,_alphai
	LDS  R27,_alphai+1
	LDS  R24,_alphai+2
	LDS  R25,_alphai+3
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	CALL SUBOPT_0x41
	__GETD2N 0x42A60000
	CALL __ADDF12
	__PUTD1MN _sudutSet,4
; 0000 00E2     sudutSet[0]  = (A5[0] * (rad))+90; //kaki
	CALL SUBOPT_0x43
	LDS  R26,_A5
	LDS  R27,_A5+1
	LDS  R24,_A5+2
	LDS  R25,_A5+3
	CALL SUBOPT_0x44
	STS  _sudutSet,R30
	STS  _sudutSet+1,R31
	STS  _sudutSet+2,R22
	STS  _sudutSet+3,R23
; 0000 00E3     sudutSet[3]  += 65; //90      edt
	CALL SUBOPT_0x48
	__GETD2N 0x42820000
	CALL __ADDF12
	CALL SUBOPT_0x45
; 0000 00E4 
; 0000 00E5     //kaki kiri
; 0000 00E6     sudutSet[11] = 100; //pinggul
	__POINTW1MN _sudutSet,44
	__GETD2N 0x42C80000
	CALL SUBOPT_0x12
; 0000 00E7     sudutSet[10] = (A1[1] * (rad))+98-5; //90 edit
	__GETD1MN _A1,4
	CALL SUBOPT_0x49
	__GETD2N 0x42C40000
	CALL SUBOPT_0x4A
	__GETD1N 0x40A00000
	CALL SUBOPT_0x4B
	__PUTD1MN _sudutSet,40
; 0000 00E8     sudutSet[9]  = (A2[1] * (rad))+5;       //0  edit
	__GETD1MN _A2,4
	CALL SUBOPT_0x49
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4C
; 0000 00E9     sudutSet[8]  = (A3[1] * (rad))+90;
	__GETD1MN _A3,4
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x44
	__PUTD1MN _sudutSet,32
; 0000 00EA     sudutSet[7]  = (-(180 - (alphai[1] * (rad)) + (sudutSet[9])))+90;       //90
	__GETD1MN _alphai,4
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	CALL __ADDF12
	__PUTD1MN _sudutSet,28
; 0000 00EB     sudutSet[6]  = (A5[1] * (rad))+90+5; //kaki //90
	__GETD1MN _A5,4
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	__PUTD1MN _sudutSet,24
; 0000 00EC     sudutSet[9]  += 69+6-5-10;   //90             edit
	CALL SUBOPT_0x4E
	__GETD2N 0x42700000
	CALL __ADDF12
	CALL SUBOPT_0x4C
; 0000 00ED 
; 0000 00EE //    printf("R %0.2f %0.2f %0.2f %0.2f %0.2f || ",sudutSet[4],sudutSet[3],sudutSet[2],sudutSet[1],sudutSet[0]);
; 0000 00EF //    printf("L %0.2f %0.2f %0.2f %0.2f %0.2f \n",sudutSet[10],sudutSet[9],sudutSet[8],sudutSet[7],sudutSet[6]);
; 0000 00F0     for (countNo = 0; countNo < 12; countNo++)
	CALL SUBOPT_0x8
_0xF8:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,12
	BRGE _0xF9
; 0000 00F1     {
; 0000 00F2         servoSet[countNo] = 800 + (7.7777* sudutSet[countNo]);
	CALL SUBOPT_0xA
	LDI  R26,LOW(_servoSet)
	LDI  R27,HIGH(_servoSet)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	LDI  R26,LOW(_sudutSet)
	LDI  R27,HIGH(_sudutSet)
	CALL SUBOPT_0x36
	__GETD2N 0x40F8E2EB
	CALL __MULF12
	__GETD2N 0x44480000
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00F3     }
	CALL SUBOPT_0x13
	RJMP _0xF8
_0xF9:
; 0000 00F4 
; 0000 00F5     //printf("SR %d %d %d %d %d || ",servoSet[4],servoSet[3],servoSet[2],servoSet[1],servoSet[0]);
; 0000 00F6     //printf("SL %d %d %d %d %d \n ",servoSet[10],servoSet[9],servoSet[8],servoSet[7],servoSet[6]);
; 0000 00F7 
; 0000 00F8 }
	RET
; .FEND
;
;void InputXYZ()
; 0000 00FB {
_InputXYZ:
; .FSTART _InputXYZ
; 0000 00FC     for (countNo = 0; countNo < 2; countNo++){
	CALL SUBOPT_0x8
_0xFB:
	CALL SUBOPT_0x9
	BRGE _0xFC
; 0000 00FD         X[countNo] += initPositionX; Y[countNo] += initPositionY; Z[countNo] += initPositionZ;
	CALL SUBOPT_0x31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0xC
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x34
	LDI  R26,LOW(_Y)
	LDI  R27,HIGH(_Y)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0xF
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL SUBOPT_0x34
	LDI  R26,LOW(_Z)
	LDI  R27,HIGH(_Z)
	CALL SUBOPT_0x35
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	CALL SUBOPT_0x11
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 00FE     }
	CALL SUBOPT_0x13
	RJMP _0xFB
_0xFC:
; 0000 00FF     langkah=0;
	LDI  R30,LOW(0)
	STS  _langkah,R30
	STS  _langkah+1,R30
; 0000 0100 }
	RET
; .FEND
;
;void main(void)
; 0000 0103 {
_main:
; .FSTART _main
; 0000 0104 init();
	CALL _init
; 0000 0105 X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x14
; 0000 0106 X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0107 InputXYZ();
	RCALL _InputXYZ
; 0000 0108 #asm("sei")
	sei
; 0000 0109 hitung = 90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _hitung,R30
	STS  _hitung+1,R31
; 0000 010A robot=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 5,6
; 0000 010B state = 0;
	LDI  R30,LOW(0)
	STS  _state,R30
	STS  _state+1,R30
; 0000 010C cariBola = 0;
	CALL SUBOPT_0x4F
; 0000 010D while (1)
_0xFD:
; 0000 010E     {
; 0000 010F      switch(state){
	LDS  R30,_state
	LDS  R31,_state+1
; 0000 0110         case 0:    //for trial
	SBIW R30,0
	BREQ _0x102
; 0000 0111 
; 0000 0112         //maju();
; 0000 0113         //siap();
; 0000 0114         //pid_servo();
; 0000 0115         //printf("%d -- %d -- %d\r\n",pos_x,pos_y,Ball);
; 0000 0116          break;
; 0000 0117 
; 0000 0118          case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x104
; 0000 0119             cari_bola();
	RCALL _cari_bola
; 0000 011A          break;
	RJMP _0x102
; 0000 011B 
; 0000 011C          case 2:
_0x104:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x105
; 0000 011D             pid_servo();
	RCALL _pid_servo
; 0000 011E          break;
	RJMP _0x102
; 0000 011F 
; 0000 0120          case 3:
_0x105:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x106
; 0000 0121             berjalan();
	RCALL _berjalan
; 0000 0122          break;
	RJMP _0x102
; 0000 0123 
; 0000 0124          case 4:
_0x106:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x107
; 0000 0125             halau_kiri();
	RCALL _halau_kiri
; 0000 0126          break;
	RJMP _0x102
; 0000 0127 
; 0000 0128          case 5:
_0x107:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x108
; 0000 0129             halau_kanan();
	RCALL _halau_kanan
; 0000 012A          break;
	RJMP _0x102
; 0000 012B 
; 0000 012C          case 101:
_0x108:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x102
; 0000 012D             cari_lagi();
	RCALL _cari_lagi
; 0000 012E          break;
; 0000 012F         }
_0x102:
; 0000 0130     }
	RJMP _0xFD
; 0000 0131 }
_0x10A:
	RJMP _0x10A
; .FEND
;
;void kiper_kucing(){
; 0000 0133 void kiper_kucing(){
; 0000 0134     switch(kiper){
; 0000 0135     case 0:
; 0000 0136         nek_ambruk();
; 0000 0137         if(servo[19] >= 1800) servo[19] = 1500;
; 0000 0138         printf("cari bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);
; 0000 0139         servo[18]+=5;
; 0000 013A         if(servo[18] >= 2300) kiper = 1;
; 0000 013B      break;
; 0000 013C 
; 0000 013D      case 1:
; 0000 013E         nek_ambruk();
; 0000 013F         if(servo[19] < 1800) servo[19] = 1800;
; 0000 0140         printf("cari bola %d %d == %d\r\n",miringDepan, servo[18], hitungNgawur);
; 0000 0141         servo[18]-=5;
; 0000 0142         if(servo[18] <= 700) kiper = 0;
; 0000 0143      break;
; 0000 0144 // 12(19) 14(18)
; 0000 0145 //    case 0:
; 0000 0146 //        nek_ambruk();
; 0000 0147 //        if(servo[12] >= 1800) servo[12] = 1500;
; 0000 0148 //        printf("halau bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);
; 0000 0149 //        servo[13]-=10;
; 0000 014A //        if(servo[13] <= 700) kiper = 1;
; 0000 014B //     break;
; 0000 014C //
; 0000 014D //     case 1:
; 0000 014E //        nek_ambruk();
; 0000 014F //        if(servo[12] < 1800) servo[12] = 2000;
; 0000 0150 //        printf("halau bola %d %d == %d\r\n",miringDepan, servo[18], hitungNgawur);
; 0000 0151 //        servo[13]+=10;
; 0000 0152 //        if(servo[13] >= 1400) kiper = 0;
; 0000 0153 //     break;
; 0000 0154     }
; 0000 0155     siap();
; 0000 0156 }
;
;void halau_kanan(){
; 0000 0158 void halau_kanan(){
_halau_kanan:
; .FSTART _halau_kanan
; 0000 0159     switch(kiper){
	LDS  R30,_kiper
	LDS  R31,_kiper+1
; 0000 015A     case 0:
	SBIW R30,0
	BRNE _0x117
; 0000 015B         nek_ambruk();
	CALL SUBOPT_0x50
; 0000 015C         if(servo[12] >= 1800) servo[12] = 1500;
	BRLT _0x118
	__POINTW1MN _servo,24
	CALL SUBOPT_0x51
; 0000 015D         printf("halau bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);
_0x118:
	CALL SUBOPT_0x52
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 015E         servo[13]-=10;
	SBIW R30,10
	CALL SUBOPT_0x56
; 0000 015F         if(servo[13] <= 700) kiper = 1;
	CPI  R26,LOW(0x2BD)
	LDI  R30,HIGH(0x2BD)
	CPC  R27,R30
	BRGE _0x119
	CALL SUBOPT_0x57
; 0000 0160      break;
_0x119:
	RJMP _0x116
; 0000 0161 
; 0000 0162      case 1:
_0x117:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x116
; 0000 0163         nek_ambruk();
	CALL SUBOPT_0x50
; 0000 0164         if(servo[12] < 1800) servo[12] = 2000;
	BRGE _0x11B
	__POINTW1MN _servo,24
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0165         printf("halau bola %d %d == %d\r\n",miringDepan, servo[18], hitungNgawur);
_0x11B:
	CALL SUBOPT_0x58
	CALL SUBOPT_0x26
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 0166         servo[13]+=10;
	ADIW R30,10
	CALL SUBOPT_0x56
; 0000 0167         if(servo[13] >= 1400) kiper = 0;
	CPI  R26,LOW(0x578)
	LDI  R30,HIGH(0x578)
	CPC  R27,R30
	BRLT _0x11C
	LDI  R30,LOW(0)
	STS  _kiper,R30
	STS  _kiper+1,R30
; 0000 0168      break;
_0x11C:
; 0000 0169     }
_0x116:
; 0000 016A     siap_kanan();
	RCALL _siap_kanan
; 0000 016B }
	RET
; .FEND
;
;void halau_kiri(){
; 0000 016D void halau_kiri(){
_halau_kiri:
; .FSTART _halau_kiri
; 0000 016E     switch(kiper){
	LDS  R30,_kiper
	LDS  R31,_kiper+1
; 0000 016F     case 0:
	SBIW R30,0
	BRNE _0x120
; 0000 0170         nek_ambruk();
	CALL SUBOPT_0x59
; 0000 0171         if(servo[15] > 600) servo[15] = 1500;
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x121
	__POINTW1MN _servo,30
	CALL SUBOPT_0x51
; 0000 0172         printf("halau bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);
_0x121:
	CALL SUBOPT_0x52
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x5A
; 0000 0173         servo[16]+=10;
	ADIW R30,10
	CALL SUBOPT_0x5B
; 0000 0174         if(servo[16] >= 2300) kiper = 1;
	CPI  R26,LOW(0x8FC)
	LDI  R30,HIGH(0x8FC)
	CPC  R27,R30
	BRLT _0x122
	CALL SUBOPT_0x57
; 0000 0175      break;
_0x122:
	RJMP _0x11F
; 0000 0176 
; 0000 0177      case 1:
_0x120:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0178         nek_ambruk();
	CALL SUBOPT_0x59
; 0000 0179         if(servo[15] < 1800) servo[15] = 700;
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	BRGE _0x124
	__POINTW1MN _servo,30
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 017A         printf("halau bola %d %d == %d\r\n",miringDepan, servo[18], hitungNgawur);
_0x124:
	CALL SUBOPT_0x58
	CALL SUBOPT_0x26
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x5A
; 0000 017B         servo[16]-=10;
	SBIW R30,10
	CALL SUBOPT_0x5B
; 0000 017C         if(servo[16] <= 1500) kiper = 0;
	CPI  R26,LOW(0x5DD)
	LDI  R30,HIGH(0x5DD)
	CPC  R27,R30
	BRGE _0x125
	LDI  R30,LOW(0)
	STS  _kiper,R30
	STS  _kiper+1,R30
; 0000 017D      break;
_0x125:
; 0000 017E     }
_0x11F:
; 0000 017F     siap_kiri();
	RCALL _siap_kiri
; 0000 0180 }
	RET
; .FEND
;
;void cari_bola(){
; 0000 0182 void cari_bola(){
_cari_bola:
; .FSTART _cari_bola
; 0000 0183     switch(cariBola){
	LDS  R30,_cariBola
	LDS  R31,_cariBola+1
; 0000 0184     case 0:
	SBIW R30,0
	BRNE _0x129
; 0000 0185         nek_ambruk();
	CALL SUBOPT_0x5C
; 0000 0186         if(servo[19] >= 1800) servo[19] = 1500;
	BRLT _0x12A
	CALL SUBOPT_0x5D
; 0000 0187         printf("cari bola %d %d == %d \r\n",miringDepan, servo[19], hitungNgawur);
_0x12A:
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x27
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x5F
; 0000 0188         servo[18]+=5;
	ADIW R30,5
	CALL SUBOPT_0x60
; 0000 0189         if(servo[18] >= 2300) cariBola = 1;
	CPI  R26,LOW(0x8FC)
	LDI  R30,HIGH(0x8FC)
	CPC  R27,R30
	BRLT _0x12B
	CALL SUBOPT_0x61
; 0000 018A         if(Ball >= 5 ) {mvx = servo[18]; mvy = servo[19]; state = 2;}
_0x12B:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x12C
	CALL SUBOPT_0x26
	CALL SUBOPT_0x62
	CALL SUBOPT_0x63
; 0000 018B         //if(hitungNgawur <= 0){hitungWaras = delayWaras; state = 101;}
; 0000 018C      break;
_0x12C:
	RJMP _0x128
; 0000 018D 
; 0000 018E      case 1:
_0x129:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x128
; 0000 018F         nek_ambruk();
	CALL SUBOPT_0x5C
; 0000 0190         if(servo[19] < 1800) servo[19] = 1800;
	BRGE _0x12E
	__POINTW1MN _servo,38
	LDI  R26,LOW(1800)
	LDI  R27,HIGH(1800)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0191         printf("cari bola %d %d == %d\r\n",miringDepan, servo[18], hitungNgawur);
_0x12E:
	__POINTW1FN _0x0,25
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x26
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x5F
; 0000 0192         servo[18]-=5;
	SBIW R30,5
	CALL SUBOPT_0x60
; 0000 0193         if(servo[18] <= 700)cariBola = 0;
	CPI  R26,LOW(0x2BD)
	LDI  R30,HIGH(0x2BD)
	CPC  R27,R30
	BRGE _0x12F
	CALL SUBOPT_0x4F
; 0000 0194         if(Ball >= 5 ) {mvx = servo[18]; mvy = servo[19]; state = 2;}
_0x12F:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x130
	CALL SUBOPT_0x26
	CALL SUBOPT_0x62
	CALL SUBOPT_0x63
; 0000 0195         //if(hitungNgawur <= 0){hitungWaras = delayWaras; state = 101;}
; 0000 0196      break;
_0x130:
; 0000 0197     }
_0x128:
; 0000 0198     siap();
	RCALL _siap
; 0000 0199 }
	RET
; .FEND
;
;void pid_servo(){ //        state = 2
; 0000 019B void pid_servo(){
_pid_servo:
; .FSTART _pid_servo
; 0000 019C     //horizntal
; 0000 019D     errorx = spx - pos_x;
	CALL SUBOPT_0x64
	LDS  R30,_spx
	LDS  R31,_spx+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _errorx,R30
	STS  _errorx+1,R31
; 0000 019E     px = errorx/5;
	LDS  R26,_errorx
	LDS  R27,_errorx+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __DIVW21
	STS  _px,R30
	STS  _px+1,R31
; 0000 019F     mvx += px;
	CALL SUBOPT_0x65
	ADD  R30,R26
	ADC  R31,R27
	STS  _mvx,R30
	STS  _mvx+1,R31
; 0000 01A0     servo[18] = mvx;
	__PUTW1MN _servo,36
; 0000 01A1     if(mvx >= 2400)mvx = 2400;
	CALL SUBOPT_0x65
	CPI  R26,LOW(0x960)
	LDI  R30,HIGH(0x960)
	CPC  R27,R30
	BRLT _0x131
	LDI  R30,LOW(2400)
	LDI  R31,HIGH(2400)
	RJMP _0x28A
; 0000 01A2     else if (mvx <= 1000)mvx = 1000;
_0x131:
	CALL SUBOPT_0x65
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRGE _0x133
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0x28A:
	STS  _mvx,R30
	STS  _mvx+1,R31
; 0000 01A3 
; 0000 01A4 
; 0000 01A5     //vertikal
; 0000 01A6     errory = spy - pos_y;
_0x133:
	LDS  R26,_pos_y
	LDS  R27,_pos_y+1
	LDS  R30,_spy
	LDS  R31,_spy+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _errory,R30
	STS  _errory+1,R31
; 0000 01A7     py = errory/2;
	LDS  R26,_errory
	LDS  R27,_errory+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	STS  _py,R30
	STS  _py+1,R31
; 0000 01A8     mvy -= py;
	LDS  R26,_py
	LDS  R27,_py+1
	LDS  R30,_mvy
	LDS  R31,_mvy+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _mvy,R30
	STS  _mvy+1,R31
; 0000 01A9     servo[19] = mvy;
	__PUTW1MN _servo,38
; 0000 01AA     if(mvy >= 2000)mvy = 2000;
	LDS  R26,_mvy
	LDS  R27,_mvy+1
	CPI  R26,LOW(0x7D0)
	LDI  R30,HIGH(0x7D0)
	CPC  R27,R30
	BRLT _0x134
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP _0x28B
; 0000 01AB     else if (mvy <= 1500)mvy = 1500;
_0x134:
	LDS  R26,_mvy
	LDS  R27,_mvy+1
	CPI  R26,LOW(0x5DD)
	LDI  R30,HIGH(0x5DD)
	CPC  R27,R30
	BRGE _0x136
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
_0x28B:
	STS  _mvy,R30
	STS  _mvy+1,R31
; 0000 01AC     printf("PID Servo -- &d -- %d -- %d -- %d\r\n",miringDepan,pos_x,pos_y,Ball);
_0x136:
	__POINTW1FN _0x0,100
	CALL SUBOPT_0x5E
	LDS  R30,_pos_x
	LDS  R31,_pos_x+1
	CALL SUBOPT_0x53
	LDS  R30,_pos_y
	LDS  R31,_pos_y+1
	CALL SUBOPT_0x53
	CALL SUBOPT_0x66
	CALL SUBOPT_0x53
	LDI  R24,16
	CALL _printf
	ADIW R28,18
; 0000 01AD 
; 0000 01AE 
; 0000 01AF     if (Ball == 0 && pos_x <= 41) {hitungNgawur = delayNgawur; cariBola = 0; state = 1;}
	CALL SUBOPT_0x2A
	SBIW R26,0
	BRNE _0x138
	CALL SUBOPT_0x64
	SBIW R26,42
	BRLT _0x139
_0x138:
	RJMP _0x137
_0x139:
	CALL SUBOPT_0x67
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x68
; 0000 01B0     if (Ball == 0 && pos_x >= 41) {hitungNgawur = delayNgawur; cariBola = 1; state = 1;}
_0x137:
	CALL SUBOPT_0x2A
	SBIW R26,0
	BRNE _0x13B
	CALL SUBOPT_0x64
	SBIW R26,41
	BRGE _0x13C
_0x13B:
	RJMP _0x13A
_0x13C:
	CALL SUBOPT_0x67
	CALL SUBOPT_0x61
	CALL SUBOPT_0x68
; 0000 01B1     if (Ball >= 5 && pos_x >= 20 && pos_x <= 60) {state = 1;}
_0x13A:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x13E
	CALL SUBOPT_0x64
	SBIW R26,20
	BRLT _0x13E
	CALL SUBOPT_0x64
	SBIW R26,61
	BRLT _0x13F
_0x13E:
	RJMP _0x13D
_0x13F:
	CALL SUBOPT_0x68
; 0000 01B2     if (Ball >= 5 && pos_x <= 19 ) {state = 4;}
_0x13D:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x141
	CALL SUBOPT_0x64
	SBIW R26,20
	BRLT _0x142
_0x141:
	RJMP _0x140
_0x142:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x69
; 0000 01B3     if (Ball >= 5 && pos_x >= 61) {state = 5;}
_0x140:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x144
	CALL SUBOPT_0x64
	SBIW R26,61
	BRGE _0x145
_0x144:
	RJMP _0x143
_0x145:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x69
; 0000 01B4 
; 0000 01B5 }
_0x143:
	RET
; .FEND
;
;void berjalan(){    //state = 3
; 0000 01B7 void berjalan(){
_berjalan:
; .FSTART _berjalan
; 0000 01B8     switch(jalan){
	LDS  R30,_jalan
	LDS  R31,_jalan+1
; 0000 01B9      case 0:  //diam
	SBIW R30,0
	BRNE _0x149
; 0000 01BA         nek_ambruk();
	CALL SUBOPT_0x6A
; 0000 01BB         rotasi_kiri();
; 0000 01BC         pid_servo();
; 0000 01BD         if (Ball >= 5 && pos_x >= 20 && pos_x <= 60 && servo[19] <= 1700) {jalan = 4; servo[19] = 1500;} // nek wes neng ...
	BRLT _0x14B
	CALL SUBOPT_0x64
	SBIW R26,20
	BRLT _0x14B
	CALL SUBOPT_0x64
	SBIW R26,61
	BRGE _0x14B
	CALL SUBOPT_0x6B
	CPI  R26,LOW(0x6A5)
	LDI  R30,HIGH(0x6A5)
	CPC  R27,R30
	BRLT _0x14C
_0x14B:
	RJMP _0x14A
_0x14C:
	CALL SUBOPT_0x6C
; 0000 01BE         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;} // nek ra ndetek neng cari bola
_0x14A:
	CALL SUBOPT_0x66
	SBIW R30,0
	BRNE _0x14D
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	RJMP _0x148
; 0000 01BF         printf("%d serong kiri bos\r\n",servo[18]);
_0x14D:
	__POINTW1FN _0x0,136
	RJMP _0x28C
; 0000 01C0      break;
; 0000 01C1      //rev
; 0000 01C2      case 1:   //maju
_0x149:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14E
; 0000 01C3         nek_ambruk();
	RCALL _nek_ambruk
; 0000 01C4         maju();
	RCALL _maju
; 0000 01C5         pid_servo();
	RCALL _pid_servo
; 0000 01C6         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
	CALL SUBOPT_0x66
	SBIW R30,0
	BRNE _0x14F
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	RJMP _0x148
; 0000 01C7         if(servo[19] >= 1800){jalan = 0;}
_0x14F:
	CALL SUBOPT_0x6B
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	BRLT _0x150
	LDI  R30,LOW(0)
	STS  _jalan,R30
	STS  _jalan+1,R30
; 0000 01C8         if(servo[19] <= 1200){jalan = 2;}
_0x150:
	CALL SUBOPT_0x6B
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRGE _0x151
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x6D
; 0000 01C9         printf("%d maju jalan\r\n",servo[18]);
_0x151:
	__POINTW1FN _0x0,157
	RJMP _0x28C
; 0000 01CA      break;
; 0000 01CB 
; 0000 01CC      case 2:    //rotasi kanan
_0x14E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x152
; 0000 01CD         nek_ambruk();
	RCALL _nek_ambruk
; 0000 01CE         rotasi_kanan();
	RCALL _rotasi_kanan
; 0000 01CF         pid_servo();
	RCALL _pid_servo
; 0000 01D0         if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] >= 1300) {jalan = 1; servo[19] = 1500;}
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x154
	CALL SUBOPT_0x64
	SBIW R26,50
	BRLT _0x154
	CALL SUBOPT_0x64
	CPI  R26,LOW(0x119)
	LDI  R30,HIGH(0x119)
	CPC  R27,R30
	BRGE _0x154
	CALL SUBOPT_0x6B
	CPI  R26,LOW(0x514)
	LDI  R30,HIGH(0x514)
	CPC  R27,R30
	BRGE _0x155
_0x154:
	RJMP _0x153
_0x155:
	CALL SUBOPT_0x6E
; 0000 01D1         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
_0x153:
	CALL SUBOPT_0x66
	SBIW R30,0
	BRNE _0x156
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	RJMP _0x148
; 0000 01D2         printf("%d serong kanan\r\n",servo[18]);
_0x156:
	__POINTW1FN _0x0,173
	RJMP _0x28C
; 0000 01D3      break;
; 0000 01D4 
; 0000 01D5      case 3:   //rotasi kiri
_0x152:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x157
; 0000 01D6         nek_ambruk();
	CALL SUBOPT_0x6A
; 0000 01D7         rotasi_kiri();
; 0000 01D8         pid_servo();
; 0000 01D9         if (Ball >= 5 && pos_x >= 50 && pos_x <= 280 && servo[19] >= 1300) {jalan = 1; servo[19] = 1500;}
	BRLT _0x159
	CALL SUBOPT_0x64
	SBIW R26,50
	BRLT _0x159
	CALL SUBOPT_0x64
	CPI  R26,LOW(0x119)
	LDI  R30,HIGH(0x119)
	CPC  R27,R30
	BRGE _0x159
	CALL SUBOPT_0x6B
	CPI  R26,LOW(0x514)
	LDI  R30,HIGH(0x514)
	CPC  R27,R30
	BRGE _0x15A
_0x159:
	RJMP _0x158
_0x15A:
	CALL SUBOPT_0x6E
; 0000 01DA         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
_0x158:
	CALL SUBOPT_0x66
	SBIW R30,0
	BRNE _0x15B
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	RJMP _0x148
; 0000 01DB         printf("%d serong kanan\r\n",servo[18]);
_0x15B:
	__POINTW1FN _0x0,173
	RJMP _0x28C
; 0000 01DC      break;
; 0000 01DD 
; 0000 01DE      case 4:   //tendang
_0x157:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x148
; 0000 01DF         tendang_dik();
	RCALL _tendang_dik
; 0000 01E0         nek_ambruk();
	RCALL _nek_ambruk
; 0000 01E1         if (Ball >= 5 && pos_x >= 20 && pos_x <= 60 && servo[19] <= 1700) {jalan = 4; servo[19] = 1500;}
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x15E
	CALL SUBOPT_0x64
	SBIW R26,20
	BRLT _0x15E
	CALL SUBOPT_0x64
	SBIW R26,61
	BRGE _0x15E
	CALL SUBOPT_0x6B
	CPI  R26,LOW(0x6A5)
	LDI  R30,HIGH(0x6A5)
	CPC  R27,R30
	BRLT _0x15F
_0x15E:
	RJMP _0x15D
_0x15F:
	CALL SUBOPT_0x6C
; 0000 01E2         if(Ball == 0) {hitungNgawur = delayNgawur; state = 1; break;}
_0x15D:
	CALL SUBOPT_0x66
	SBIW R30,0
	BRNE _0x160
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	RJMP _0x148
; 0000 01E3         printf("%d Tendang\r\n",servo[18]);
_0x160:
	__POINTW1FN _0x0,191
_0x28C:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x53
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 01E4      break;
; 0000 01E5 
; 0000 01E6     }
_0x148:
; 0000 01E7 
; 0000 01E8 }
	RET
; .FEND
;
;void nek_ambruk(){
; 0000 01EA void nek_ambruk(){
_nek_ambruk:
; .FSTART _nek_ambruk
; 0000 01EB     konversi_ardu();
	CALL _konversi_ardu
; 0000 01EC     if(miringDepan <= -40){ printf("Ambruk depan  %d\r\n",miringDepan); state = 13;}            // bangun tengkurap
	LDS  R26,_miringDepan
	LDS  R27,_miringDepan+1
	LDI  R30,LOW(65496)
	LDI  R31,HIGH(65496)
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x161
	__POINTW1FN _0x0,204
	RJMP _0x28D
; 0000 01ED     else if(miringDepan >= 40){ printf("Ambruk belakang  %d\r\n",miringDepan); state = 13;}   // bangun terlentang
_0x161:
	LDS  R26,_miringDepan
	LDS  R27,_miringDepan+1
	SBIW R26,40
	BRLT _0x163
	__POINTW1FN _0x0,223
_0x28D:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	CALL SUBOPT_0x53
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CALL SUBOPT_0x69
; 0000 01EE 
; 0000 01EF }
_0x163:
	RET
; .FEND
;
;void cek_ambruk(){
; 0000 01F1 void cek_ambruk(){
; 0000 01F2 
; 0000 01F3     if(miringDepan <= -40 ){sudah = 0; printf("cek Ambruk depan %d\r\n",miringDepan); TIMSK1=0x07; state = 10;}          ...
; 0000 01F4     if(miringDepan >= 40){ sudah = 0; printf("cek Ambruk belakang %d\r\n",miringDepan); TIMSK1=0x07; state = 11;}   // b ...
; 0000 01F5 }
;
;void bangun_depan(){
; 0000 01F7 void bangun_depan(){
; 0000 01F8     durung:
; 0000 01F9 
; 0000 01FA         printf("proses bangun depan %d\r\n",miringDepan);
; 0000 01FB         bangun_tengkurap();
; 0000 01FC         if(sudah == 1 && miringDepan <= 30) {kondisiAmbrukDepan = 1; goto wes;}
; 0000 01FD         if((sudah == 1 && miringDepan >= 30) || (sudah == 1 && miringDepan <= -40 )) {kondisiAmbrukDepan = 0; goto wes;}
; 0000 01FE     goto durung;
; 0000 01FF 
; 0000 0200     wes:
; 0000 0201         printf("wes\r\n");
; 0000 0202         tango = 0;
; 0000 0203         if(kondisiAmbrukDepan == 1){hitungNgawur = delayNgawur; state = 1;}
; 0000 0204         else {sudah = 0; state = 12;}
; 0000 0205 }
;
;void bangun_belakang(){
; 0000 0207 void bangun_belakang(){
; 0000 0208     durung:
; 0000 0209 
; 0000 020A         printf("proses bangun belakang %d\r\n",miringDepan);
; 0000 020B         bangun_telentang();
; 0000 020C         if(sudah == 1 && miringDepan <= 30) {kondisiAmbrukBelakang = 1; goto wes;}
; 0000 020D         if((sudah == 1 && miringDepan >= 30) || (sudah == 1 && miringDepan <= -40)) {kondisiAmbrukBelakang = 0; goto wes ...
; 0000 020E     goto durung;
; 0000 020F 
; 0000 0210     wes:
; 0000 0211         printf("Wes cok\r\n");
; 0000 0212         tangi = 0;
; 0000 0213         if(kondisiAmbrukBelakang == 1){hitungNgawur = delayNgawur; state = 1;}
; 0000 0214         else {sudah = 0; state = 12;}
; 0000 0215 
; 0000 0216 
; 0000 0217 }
;
;void ngitung(){
; 0000 0219 void ngitung(){
; 0000 021A     hitung = 600;
; 0000 021B     jalan = 1;
; 0000 021C     state = 3;
; 0000 021D }
;
;void cari_lagi(){
; 0000 021F void cari_lagi(){
_cari_lagi:
; .FSTART _cari_lagi
; 0000 0220     nek_ambruk();
	RCALL _nek_ambruk
; 0000 0221     maju();
	RCALL _maju
; 0000 0222     servo[18] = 1500;
	__POINTW1MN _servo,36
	CALL SUBOPT_0x51
; 0000 0223     servo[19] = 1500;
	CALL SUBOPT_0x5D
; 0000 0224     if(hitungWaras <= 0) {hitungNgawur = delayNgawur; state = 1;}
	CALL SUBOPT_0x28
	BRLT _0x182
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
; 0000 0225     if(Ball >= 5){mvx = servo[19]; mvy = servo[18]; state = 2;}
_0x182:
	CALL SUBOPT_0x2A
	SBIW R26,5
	BRLT _0x183
	CALL SUBOPT_0x27
	STS  _mvx,R30
	STS  _mvx+1,R31
	CALL SUBOPT_0x26
	CALL SUBOPT_0x63
; 0000 0226     printf("Cari Bola Lagi %d - %d\r\n",miringDepan, hitungWaras);
_0x183:
	__POINTW1FN _0x0,361
	CALL SUBOPT_0x5E
	LDS  R30,_hitungWaras
	LDS  R31,_hitungWaras+1
	CALL SUBOPT_0x53
	LDI  R24,8
	CALL _printf
	ADIW R28,10
; 0000 0227 }
	RET
; .FEND
;
;void siap()
; 0000 022A   {
_siap:
; .FSTART _siap
; 0000 022B 
; 0000 022C    //tangan kanan
; 0000 022D     servo[14] = 1350+400; //R3 - CW
	CALL SUBOPT_0x6F
; 0000 022E     servo[13] = 900-330; //R2 - turun
; 0000 022F     servo[12] = 1900+600; //R1 - mundur
; 0000 0230     //tangan kiri
; 0000 0231     servo[17]  = 1650-300; //L3 - CW
	CALL SUBOPT_0x70
; 0000 0232     servo[16]  = 2050+440; //L2 - naik
; 0000 0233     servo[15]  = 1100-650; //L1 - maju
; 0000 0234 
; 0000 0235     //servoInitError[2]=+30;
; 0000 0236     //servoInitError[8]=+30;
; 0000 0237     servoInitError[1]=-100;
; 0000 0238     servoInitError[2]=+310;
; 0000 0239     servoInitError[3]= -250;
; 0000 023A     servoInitError[7]=-100;
; 0000 023B     servoInitError[8]=+310;
; 0000 023C     servoInitError[9]= -250;
; 0000 023D     //ndass
; 0000 023E     //servo[18]  = 1500; //tambah ngiri
; 0000 023F     //servo[19]  = 1500; //tambah mudun
; 0000 0240     switch(0)
; 0000 0241         {
; 0000 0242            case 0 :     //gait  mlaku
	BRNE _0x186
; 0000 0243                 VY=10;
	CALL SUBOPT_0x71
; 0000 0244                 if(counterDelay<=0)
	BRLT _0x188
; 0000 0245                 {
; 0000 0246                     switch(countTick)
	__GETW1R 13,14
; 0000 0247                     {
; 0000 0248                        case 0:
	SBIW R30,0
	BRNE _0x18B
; 0000 0249                        //servoInitError[7]=40;
; 0000 024A                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x14
; 0000 024B                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 024C                             InputXYZ();
	RCALL _InputXYZ
; 0000 024D                         break;
; 0000 024E                     }
_0x18B:
; 0000 024F                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x18E
	CALL SUBOPT_0x72
	BREQ _0x18D
_0x18E:
; 0000 0250                     {
; 0000 0251                         countTick++;
	CALL SUBOPT_0x73
; 0000 0252                         if(countTick>0)
	BRGE _0x190
; 0000 0253                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 0254                     }
_0x190:
; 0000 0255                     else
	RJMP _0x191
_0x18D:
; 0000 0256                     {
; 0000 0257                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0258                     }
_0x191:
; 0000 0259 
; 0000 025A                     counterDelay=75; //3000
	CALL SUBOPT_0x74
; 0000 025B                 }
; 0000 025C             break;
_0x188:
; 0000 025D         }
_0x186:
; 0000 025E 
; 0000 025F         speed=1; //10
	CALL SUBOPT_0x75
; 0000 0260         if(counterTG>speed)
	BRGE _0x192
; 0000 0261         {
; 0000 0262             counterTG=0;
	CALL SUBOPT_0x76
; 0000 0263             taskGerakan();
; 0000 0264         }
; 0000 0265   }
_0x192:
	RET
; .FEND
;void siap_kanan()
; 0000 0267   {
_siap_kanan:
; .FSTART _siap_kanan
; 0000 0268 
; 0000 0269    //tangan kanan
; 0000 026A //    servo[14] = 1350+400; //R3 - CW
; 0000 026B //    servo[13] = 900-330; //R2 - turun
; 0000 026C //    servo[12] = 1900+600; //R1 - mundur
; 0000 026D     //tangan kiri
; 0000 026E     servo[17]  = 1650-300; //L3 - CW
	CALL SUBOPT_0x70
; 0000 026F     servo[16]  = 2050+440; //L2 - naik
; 0000 0270     servo[15]  = 1100-650; //L1 - maju
; 0000 0271 
; 0000 0272     //servoInitError[2]=+30;
; 0000 0273     //servoInitError[8]=+30;
; 0000 0274     servoInitError[1]=-100;
; 0000 0275     servoInitError[2]=+310;
; 0000 0276     servoInitError[3]= -250;
; 0000 0277     servoInitError[7]=-100;
; 0000 0278     servoInitError[8]=+310;
; 0000 0279     servoInitError[9]= -250;
; 0000 027A     //ndass
; 0000 027B     //servo[18]  = 1500; //tambah ngiri
; 0000 027C     //servo[19]  = 1500; //tambah mudun
; 0000 027D     switch(0)
; 0000 027E         {
; 0000 027F            case 0 :     //gait  mlaku
	BRNE _0x195
; 0000 0280                 VY=10;
	CALL SUBOPT_0x71
; 0000 0281                 if(counterDelay<=0)
	BRLT _0x197
; 0000 0282                 {
; 0000 0283                     switch(countTick)
	__GETW1R 13,14
; 0000 0284                     {
; 0000 0285                        case 0:
	SBIW R30,0
	BRNE _0x19A
; 0000 0286                        //servoInitError[7]=40;
; 0000 0287                             X[0]=0; Y[0]=0; Z[0]=-30;
	CALL SUBOPT_0x77
; 0000 0288                             X[1]=0; Y[1]=0; Z[1]=-30;
; 0000 0289                             InputXYZ();
; 0000 028A                         break;
; 0000 028B                     }
_0x19A:
; 0000 028C                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x19D
	CALL SUBOPT_0x72
	BREQ _0x19C
_0x19D:
; 0000 028D                     {
; 0000 028E                         countTick++;
	CALL SUBOPT_0x73
; 0000 028F                         if(countTick>0)
	BRGE _0x19F
; 0000 0290                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 0291                     }
_0x19F:
; 0000 0292                     else
	RJMP _0x1A0
_0x19C:
; 0000 0293                     {
; 0000 0294                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0295                     }
_0x1A0:
; 0000 0296 
; 0000 0297                     counterDelay=75; //3000
	CALL SUBOPT_0x74
; 0000 0298                 }
; 0000 0299             break;
_0x197:
; 0000 029A         }
_0x195:
; 0000 029B 
; 0000 029C         speed=1; //10
	CALL SUBOPT_0x75
; 0000 029D         if(counterTG>speed)
	BRGE _0x1A1
; 0000 029E         {
; 0000 029F             counterTG=0;
	CALL SUBOPT_0x76
; 0000 02A0             taskGerakan();
; 0000 02A1         }
; 0000 02A2   }
_0x1A1:
	RET
; .FEND
;
;void siap_kiri()
; 0000 02A5   {
_siap_kiri:
; .FSTART _siap_kiri
; 0000 02A6 
; 0000 02A7    //tangan kanan
; 0000 02A8     servo[14] = 1350+400; //R3 - CW
	CALL SUBOPT_0x6F
; 0000 02A9     servo[13] = 900-330; //R2 - turun
; 0000 02AA     servo[12] = 1900+600; //R1 - mundur
; 0000 02AB     //tangan kiri
; 0000 02AC //    servo[17]  = 1650-300; //L3 - CW
; 0000 02AD //    servo[16]  = 2050+440; //L2 - naik
; 0000 02AE //    servo[15]  = 1100-650; //L1 - maju
; 0000 02AF //
; 0000 02B0     //servoInitError[2]=+30;
; 0000 02B1     //servoInitError[8]=+30;
; 0000 02B2     servoInitError[1]=-100;
	CALL SUBOPT_0x78
; 0000 02B3     servoInitError[2]=+310;
; 0000 02B4     servoInitError[3]= -250;
	CALL SUBOPT_0x79
; 0000 02B5     servoInitError[7]=-100;
	CALL SUBOPT_0x7A
; 0000 02B6     servoInitError[8]=+310;
; 0000 02B7     servoInitError[9]= -250;
	CALL SUBOPT_0x79
; 0000 02B8     //ndass
; 0000 02B9     //servo[18]  = 1500; //tambah ngiri
; 0000 02BA     //servo[19]  = 1500; //tambah mudun
; 0000 02BB     switch(0)
	LDI  R30,LOW(0)
; 0000 02BC         {
; 0000 02BD            case 0 :     //gait  mlaku
	CPI  R30,0
	BRNE _0x1A4
; 0000 02BE                 VY=10;
	CALL SUBOPT_0x71
; 0000 02BF                 if(counterDelay<=0)
	BRLT _0x1A6
; 0000 02C0                 {
; 0000 02C1                     switch(countTick)
	__GETW1R 13,14
; 0000 02C2                     {
; 0000 02C3                        case 0:
	SBIW R30,0
	BRNE _0x1A9
; 0000 02C4                        //servoInitError[7]=40;
; 0000 02C5                             X[0]=0; Y[0]=0; Z[0]=-30;
	CALL SUBOPT_0x77
; 0000 02C6                             X[1]=0; Y[1]=0; Z[1]=-30;
; 0000 02C7                             InputXYZ();
; 0000 02C8                         break;
; 0000 02C9                     }
_0x1A9:
; 0000 02CA                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x1AC
	CALL SUBOPT_0x72
	BREQ _0x1AB
_0x1AC:
; 0000 02CB                     {
; 0000 02CC                         countTick++;
	CALL SUBOPT_0x73
; 0000 02CD                         if(countTick>0)
	BRGE _0x1AE
; 0000 02CE                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 02CF                     }
_0x1AE:
; 0000 02D0                     else
	RJMP _0x1AF
_0x1AB:
; 0000 02D1                     {
; 0000 02D2                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 02D3                     }
_0x1AF:
; 0000 02D4 
; 0000 02D5                     counterDelay=75; //3000
	CALL SUBOPT_0x74
; 0000 02D6                 }
; 0000 02D7             break;
_0x1A6:
; 0000 02D8         }
_0x1A4:
; 0000 02D9 
; 0000 02DA         speed=1; //10
	CALL SUBOPT_0x75
; 0000 02DB         if(counterTG>speed)
	BRGE _0x1B0
; 0000 02DC         {
; 0000 02DD             counterTG=0;
	CALL SUBOPT_0x76
; 0000 02DE             taskGerakan();
; 0000 02DF         }
; 0000 02E0   }
_0x1B0:
	RET
; .FEND
;
;void geser_kiri(){
; 0000 02E2 void geser_kiri(){
; 0000 02E3     //tangan kanan
; 0000 02E4     servo[14] = 1350+400; //R3 - CW
; 0000 02E5     servo[13] = 900-330; //R2 - turun
; 0000 02E6     servo[12] = 1900+600; //R1 - mundur
; 0000 02E7     //tangan kiri
; 0000 02E8     servo[17]  = 1650-300; //L3 - CW
; 0000 02E9     servo[16]  = 2050+440; //L2 - naik
; 0000 02EA     servo[15]  = 1100-650; //L1 - maju
; 0000 02EB 
; 0000 02EC     //ndass
; 0000 02ED     //servo[18]  = 1500; //tambah ngiri
; 0000 02EE     //servo[19]  = 1500; //tambah mudun
; 0000 02EF 
; 0000 02F0     switch(0)
; 0000 02F1         {
; 0000 02F2            case 0 :     //gait  mlaku
; 0000 02F3                 VY=4;
; 0000 02F4                 if(counterDelay<=0)
; 0000 02F5                 {
; 0000 02F6                     switch(countTick)
; 0000 02F7                     {
; 0000 02F8                        case 0:
; 0000 02F9                             servoInitError[1]=-100;
; 0000 02FA                             servoInitError[2]=+310;
; 0000 02FB                             servoInitError[3]= -250;
; 0000 02FC                             servoInitError[7]=-100;
; 0000 02FD                             servoInitError[8]=+310;
; 0000 02FE                             servoInitError[9]= -250;
; 0000 02FF 
; 0000 0300                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0301                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0302                             InputXYZ();
; 0000 0303                         break;
; 0000 0304 
; 0000 0305                         case 1:
; 0000 0306 
; 0000 0307                             X[0]=-17; Y[0]=0; Z[0]=0;
; 0000 0308                             X[1]=25; Y[1]=0; Z[1]=0;
; 0000 0309                             InputXYZ();
; 0000 030A                         break;
; 0000 030B 
; 0000 030C                         case 2:
; 0000 030D                             servoInitError[6]=-30;
; 0000 030E 
; 0000 030F                             X[0]=-17; Y[0]=0; Z[0]=0;
; 0000 0310                             X[1]=50; Y[1]=VY; Z[1]=-30;
; 0000 0311                             InputXYZ();
; 0000 0312                         break;
; 0000 0313 
; 0000 0314                         case 3:
; 0000 0315                             servoInitError[6]=+75;
; 0000 0316 
; 0000 0317                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0318                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0319                             InputXYZ();
; 0000 031A                         break;
; 0000 031B 
; 0000 031C                         case 4:
; 0000 031D                             servoInitError[6]=0;
; 0000 031E 
; 0000 031F                             X[0]=20; Y[0]=VY; Z[0]=-30;
; 0000 0320                             X[1]=-20; Y[1]=0; Z[1]=0;
; 0000 0321                             InputXYZ();
; 0000 0322                         break;
; 0000 0323 
; 0000 0324                     }
; 0000 0325                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 0326                     {
; 0000 0327                         countTick++;
; 0000 0328                         if(countTick>4)
; 0000 0329                         countTick=0;     //2
; 0000 032A                     }
; 0000 032B                     else
; 0000 032C                     {
; 0000 032D                         countTick=0;
; 0000 032E                     }
; 0000 032F 
; 0000 0330                     counterDelay=85; //65 80   85
; 0000 0331                 }
; 0000 0332             break;
; 0000 0333         }
; 0000 0334 
; 0000 0335         speed=1; //10
; 0000 0336         if(counterTG>speed)
; 0000 0337         {
; 0000 0338             counterTG=0;
; 0000 0339             taskGerakan();
; 0000 033A         }
; 0000 033B }
;
;void geser_kanan(){
; 0000 033D void geser_kanan(){
; 0000 033E     //tangan kanan
; 0000 033F     servo[14] = 1350+400; //R3 - CW
; 0000 0340     servo[13] = 900-330; //R2 - turun
; 0000 0341     servo[12] = 1900+600; //R1 - mundur
; 0000 0342     //tangan kiri
; 0000 0343     servo[17]  = 1650-300; //L3 - CW
; 0000 0344     servo[16]  = 2050+440; //L2 - naik
; 0000 0345     servo[15]  = 1100-650; //L1 - maju
; 0000 0346 
; 0000 0347     //ndass
; 0000 0348     //servo[18]  = 1500; //tambah ngiri
; 0000 0349     //servo[19]  = 1500; //tambah mudun
; 0000 034A 
; 0000 034B     switch(0)
; 0000 034C         {
; 0000 034D            case 0 :     //gait  mlaku
; 0000 034E                 VY=4;
; 0000 034F                 if(counterDelay<=0)
; 0000 0350                 {
; 0000 0351                     switch(countTick)
; 0000 0352                     {
; 0000 0353                        case 0:
; 0000 0354                             servoInitError[1]=-100;
; 0000 0355                             servoInitError[2]=+310;
; 0000 0356                             servoInitError[3]= -250; //-270
; 0000 0357                             servoInitError[7]=-100;
; 0000 0358                             servoInitError[8]=+310;
; 0000 0359                             servoInitError[9]= -250;
; 0000 035A 
; 0000 035B                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 035C                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 035D                             InputXYZ();
; 0000 035E                         break;
; 0000 035F 
; 0000 0360                         case 1:
; 0000 0361 
; 0000 0362                             X[0]=25; Y[0]=0; Z[0]=0;
; 0000 0363                             X[1]=-17; Y[1]=0; Z[1]=0;
; 0000 0364                             InputXYZ();
; 0000 0365                         break;
; 0000 0366 
; 0000 0367                         case 2:
; 0000 0368                             servoInitError[0]=-30;
; 0000 0369 
; 0000 036A                             X[0]=50; Y[0]=VY; Z[0]=-30;
; 0000 036B                             X[1]=-17; Y[1]=0; Z[1]=0;
; 0000 036C                             InputXYZ();
; 0000 036D                         break;
; 0000 036E 
; 0000 036F                         case 3:
; 0000 0370                             servoInitError[0]=+75;
; 0000 0371 
; 0000 0372                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0373                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0374                             InputXYZ();
; 0000 0375                         break;
; 0000 0376 
; 0000 0377                         case 4:
; 0000 0378                             servoInitError[0]=0;
; 0000 0379 
; 0000 037A                             X[0]=-20; Y[0]=0; Z[0]=0;
; 0000 037B                             X[1]=20; Y[1]=VY; Z[1]=-30;
; 0000 037C                             InputXYZ();
; 0000 037D                         break;
; 0000 037E 
; 0000 037F                     }
; 0000 0380                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 0381                     {
; 0000 0382                         countTick++;
; 0000 0383                         if(countTick>4)
; 0000 0384                         countTick=0;     //2
; 0000 0385                     }
; 0000 0386                     else
; 0000 0387                     {
; 0000 0388                         countTick=0;
; 0000 0389                     }
; 0000 038A 
; 0000 038B                     counterDelay=90; //65 80   85
; 0000 038C                 }
; 0000 038D             break;
; 0000 038E         }
; 0000 038F 
; 0000 0390         speed=1; //10
; 0000 0391         if(counterTG>speed)
; 0000 0392         {
; 0000 0393             counterTG=0;
; 0000 0394             taskGerakan();
; 0000 0395         }
; 0000 0396 }
;
;void bangun_telentang()
; 0000 0399     {
; 0000 039A      int de  = 1000;
; 0000 039B      int lay = 50;
; 0000 039C      //tangi = 8;
; 0000 039D           switch(tangi)
;	de -> R16,R17
;	lay -> R18,R19
; 0000 039E           {
; 0000 039F 
; 0000 03A0            case 0:
; 0000 03A1                     //ndas
; 0000 03A2                     servo[18]  = 500; //L1 - maju
; 0000 03A3                     servo[19]  = 2000; //L2 - naik
; 0000 03A4                     //kaki kanan
; 0000 03A5                     servo[5] = 1500;
; 0000 03A6                     servo[4] = 1500; //R5 - kiri
; 0000 03A7                     servo[3] = 1500; //R4 - maju
; 0000 03A8                     servo[2] = 1500; //R3 - maju
; 0000 03A9                     servo[1] = 1500; //R2 - maju
; 0000 03AA                     servo[0] = 1500; //R1 - kiri
; 0000 03AB                     //kaki kiri
; 0000 03AC                     servo[11] = 1500;
; 0000 03AD                     servo[10] = 1500; //L5 - kanan
; 0000 03AE                     servo[9]  = 1500; //L4 - maju    984
; 0000 03AF                     servo[8]  = 1500; //L3 - maju
; 0000 03B0                     servo[7]  = 1500; //L2 - maju
; 0000 03B1                     servo[6]  = 1500; //L1 - kanan
; 0000 03B2                     //tangan kanan
; 0000 03B3                     servo[14] = 1500; //R3 - CW
; 0000 03B4                     servo[13] = 1500; //R2 - turun
; 0000 03B5                     servo[12] = 1500; //R1 - mundur
; 0000 03B6                     //tangan kiri
; 0000 03B7                     servo[15]  = 1500; //L1 - maju
; 0000 03B8                     servo[16]  = 1500; //L2 - naik
; 0000 03B9                     servo[17]  = 1500; //L3 - CW
; 0000 03BA                     delay_ms(3000);
; 0000 03BB 
; 0000 03BC                     tangi=0;
; 0000 03BD            break;
; 0000 03BE 
; 0000 03BF            case 1:
; 0000 03C0                     //kaki kanan
; 0000 03C1                     servo[5] = 1500;
; 0000 03C2                     servo[4] = 1500; //R5 - kiri
; 0000 03C3                     servo[3] = 1500; //R4 - maju
; 0000 03C4                     servo[2] = 1500; //R3 - maju
; 0000 03C5                     servo[1] = 1500; //R2 - maju
; 0000 03C6                     servo[0] = 1500; //R1 - kiri
; 0000 03C7                     //kaki kiri
; 0000 03C8                     servo[11] = 1500;
; 0000 03C9                     servo[10] = 1500; //L5 - kanan
; 0000 03CA                     servo[9]  = 1500; //L4 - maju    984
; 0000 03CB                     servo[8]  = 1500; //L3 - maju
; 0000 03CC                     servo[7]  = 1500; //L2 - maju
; 0000 03CD                     servo[6]  = 1500; //L1 - kanan
; 0000 03CE                     //tangan kanan
; 0000 03CF                     servo[14] = 1500; //R3 - CW
; 0000 03D0                     servo[13] = 800; //R2 - turun
; 0000 03D1                     servo[12] = 1500; //R1 - mundur
; 0000 03D2                     //tangan kiri
; 0000 03D3                     servo[15]  = 1500; //L1 - maju
; 0000 03D4                     servo[16]  = 2100; //L2 - naik
; 0000 03D5                     servo[17]  = 1500; //L3 - CW
; 0000 03D6                     delay_ms(de);
; 0000 03D7 
; 0000 03D8                     tangi=2;
; 0000 03D9            break;
; 0000 03DA 
; 0000 03DB 
; 0000 03DC            case 2:
; 0000 03DD                     //kaki kanan
; 0000 03DE                     servo[5] = 1500;
; 0000 03DF                     servo[4] = 1500; //R5 - kiri
; 0000 03E0                     servo[3] = 800; //R4 - maju
; 0000 03E1                     servo[2] = 1500; //R3 - maju
; 0000 03E2                     servo[1] = 1500; //R2 - maju
; 0000 03E3                     servo[0] = 1500; //R1 - kiri
; 0000 03E4                     //kaki kiri
; 0000 03E5                     servo[11] = 1500;
; 0000 03E6                     servo[10] = 1500; //L5 - kanan
; 0000 03E7                     servo[9]  = 2100; //L4 - maju    984
; 0000 03E8                     servo[8]  = 1500; //L3 - maju
; 0000 03E9                     servo[7]  = 1500; //L2 - maju
; 0000 03EA                     servo[6]  = 1500; //L1 - kanan
; 0000 03EB                     //tangan kanan
; 0000 03EC                     servo[14] = 500; //R3 - CW
; 0000 03ED                     servo[13] = 800; //R2 - turun
; 0000 03EE                     servo[12] = 1000; //R1 - mundur
; 0000 03EF                     //tangan kiri
; 0000 03F0                     servo[15]  = 1500; //L1 - maju
; 0000 03F1                     servo[16]  = 2100; //L2 - naik
; 0000 03F2                     servo[17]  = 1500; //L3 - CW
; 0000 03F3                     delay_ms(de);
; 0000 03F4 
; 0000 03F5                     tangi=3;
; 0000 03F6            break;
; 0000 03F7 
; 0000 03F8            case 3:
; 0000 03F9                     //kaki kanan
; 0000 03FA                     servo[5] = 1500;
; 0000 03FB                     servo[4] = 1500; //R5 - kiri
; 0000 03FC                     servo[3] = 1500; //R4 - maju
; 0000 03FD                     servo[2] = 1500; //R3 - maju
; 0000 03FE                     servo[1] = 1500; //R2 - maju
; 0000 03FF                     servo[0] = 1500; //R1 - kiri
; 0000 0400                     //kaki kiri
; 0000 0401                     servo[11] = 1500;
; 0000 0402                     servo[10] = 1500; //L5 - kanan
; 0000 0403                     servo[9]  = 1500; //L4 - maju    984
; 0000 0404                     servo[8]  = 1500; //L3 - maju
; 0000 0405                     servo[7]  = 1500; //L2 - maju
; 0000 0406                     servo[6]  = 1500; //L1 - kanan
; 0000 0407                     //tangan kanan
; 0000 0408                     servo[14] = 500; //R3 - CW
; 0000 0409                     servo[13] = 800; //R2 - turun
; 0000 040A                     servo[12] = 1500; //R1 - mundur
; 0000 040B                     //tangan kiri
; 0000 040C                     servo[15]  = 1500; //L1 - maju
; 0000 040D                     servo[16]  = 2100; //L2 - naik
; 0000 040E                     servo[17]  = 1500; //L3 - CW
; 0000 040F                     delay_ms(de);
; 0000 0410 
; 0000 0411                     tangi=4;
; 0000 0412            break;
; 0000 0413 
; 0000 0414            case 4:
; 0000 0415                     //kaki kanan
; 0000 0416                     servo[5] = 1500;
; 0000 0417                     servo[4] = 1500; //R5 - kiri
; 0000 0418                     servo[3] = 1500; //R4 - maju
; 0000 0419                     servo[2] = 1500; //R3 - maju
; 0000 041A                     servo[1] = 1500; //R2 - maju
; 0000 041B                     servo[0] = 1500; //R1 - kiri
; 0000 041C                     //kaki kiri
; 0000 041D                     servo[11] = 1500;
; 0000 041E                     servo[10] = 1500; //L5 - kanan
; 0000 041F                     servo[9]  = 1500; //L4 - maju    984
; 0000 0420                     servo[8]  = 1500; //L3 - maju
; 0000 0421                     servo[7]  = 1500; //L2 - maju
; 0000 0422                     servo[6]  = 1500; //L1 - kanan
; 0000 0423                     //tangan kanan
; 0000 0424                     servo[14] = 1500; //R3 - CW
; 0000 0425                     servo[13] = 1500; //R2 - turun
; 0000 0426                     servo[12] = 1500; //R1 - mundur
; 0000 0427                     //tangan kiri
; 0000 0428                     servo[15]  = 1500; //L1 - maju
; 0000 0429                     servo[16]  = 1500; //L2 - naik
; 0000 042A                     servo[17]  = 1500; //L3 - CW
; 0000 042B                     delay_ms(de);
; 0000 042C 
; 0000 042D                     tangi=5;
; 0000 042E            break;
; 0000 042F 
; 0000 0430            case 5:
; 0000 0431                     //kaki kanan
; 0000 0432                     servo[5] = 1500;
; 0000 0433                     servo[4] = 1500; //R5 - kiri
; 0000 0434                     servo[3] = 984;  //R4 - maju
; 0000 0435                     servo[2] = 2508; //R3 - maju
; 0000 0436                     servo[1] = 1006; //R2 - maju
; 0000 0437                     servo[0] = 1500; //R1 - kiri
; 0000 0438                     //kaki kiri
; 0000 0439                     servo[11] = 1500;
; 0000 043A                     servo[10] = 1500; //L5 - kanan
; 0000 043B                     servo[9]  = 984;  //L4 - maju    984
; 0000 043C                     servo[8]  = 2508; //L3 - maju
; 0000 043D                     servo[7]  = 1006; //L2 - maju
; 0000 043E                     servo[6]  = 1500; //L1 - kanan
; 0000 043F                     //tangan kanan
; 0000 0440                     servo[14] = 1500; //R3 - CW
; 0000 0441                     servo[13] = 1500; //R2 - turun
; 0000 0442                     servo[12] = 1500; //R1 - mundur
; 0000 0443                     //tangan kiri
; 0000 0444                     servo[15]  = 1500; //L1 - maju
; 0000 0445                     servo[16]  = 1500; //L2 - naik
; 0000 0446                     servo[17]  = 1500; //L3 - CW
; 0000 0447                     delay_ms(lay);
; 0000 0448 
; 0000 0449                     tangi=6;
; 0000 044A            break;
; 0000 044B 
; 0000 044C 
; 0000 044D            case 6:
; 0000 044E                     //kaki kanan
; 0000 044F                     servo[5] = 1500;
; 0000 0450                     servo[4] = 1500; //R5 - kiri
; 0000 0451                     servo[3] = 984;  //R4 - maju
; 0000 0452                     servo[2] = 2508; //R3 - maju
; 0000 0453                     servo[1] = 1006; //R2 - maju
; 0000 0454                     servo[0] = 1500; //R1 - kiri
; 0000 0455                     //kaki kiri
; 0000 0456                     servo[11] = 1500;
; 0000 0457                     servo[10] = 1500; //L5 - kanan
; 0000 0458                     servo[9]  = 984;  //L4 - maju    984
; 0000 0459                     servo[8]  = 2508; //L3 - maju
; 0000 045A                     servo[7]  = 1006; //L2 - maju
; 0000 045B                     servo[6]  = 1500; //L1 - kanan
; 0000 045C                     //tangan kanan
; 0000 045D                     servo[14] = 1500; //R3 - CW
; 0000 045E                     servo[13] = 2100; //R2 - turun
; 0000 045F                     servo[12] = 1500; //R1 - mundur
; 0000 0460                     //tangan kiri
; 0000 0461                     servo[17]  = 1500; //L3 - CW
; 0000 0462                     servo[16]  = 900; //L2 - naik
; 0000 0463                     servo[15]  = 1500; //L1 - maju
; 0000 0464                     delay_ms(lay);
; 0000 0465 
; 0000 0466                     tangi=7;
; 0000 0467            break;
; 0000 0468 
; 0000 0469            case 7:
; 0000 046A                     //kaki kanan
; 0000 046B                     servo[5] = 1500;
; 0000 046C                     servo[4] = 1500; //R5 - kiri
; 0000 046D                     servo[3] = 984;  //R4 - maju
; 0000 046E                     servo[2] = 2508; //R3 - maju
; 0000 046F                     servo[1] = 1006; //R2 - maju
; 0000 0470                     servo[0] = 1500; //R1 - kiri
; 0000 0471                     //kaki kiri
; 0000 0472                     servo[11] = 1500;
; 0000 0473                     servo[10] = 1500; //L5 - kanan
; 0000 0474                     servo[9]  = 984;  //L4 - maju    984
; 0000 0475                     servo[8]  = 2508; //L3 - maju
; 0000 0476                     servo[7]  = 1006; //L2 - maju
; 0000 0477                     servo[6]  = 1500; //L1 - kanan
; 0000 0478                     //tangan kanan
; 0000 0479                     servo[14] = 500; //R3 - CW
; 0000 047A                     servo[13] = 2100; //R2 - turun
; 0000 047B                     servo[12] = 1500; //R1 - mundur
; 0000 047C                     //tangan kiri
; 0000 047D                     servo[17]  = 2500; //L3 - CW
; 0000 047E                     servo[16]  = 900; //L2 - naik
; 0000 047F                     servo[15]  = 1500; //L1 - maju
; 0000 0480                     delay_ms(lay);
; 0000 0481 
; 0000 0482                     tangi=8;
; 0000 0483            break;
; 0000 0484 
; 0000 0485            case 8:
; 0000 0486                     //kaki kanan
; 0000 0487                     servo[5] = 1500;
; 0000 0488                     servo[4] = 1500; //R5 - kiri
; 0000 0489                     servo[3] = 500;  //R4 - maju
; 0000 048A                     servo[2] = 2508; //R3 - maju
; 0000 048B                     servo[1] = 1006; //R2 - maju
; 0000 048C                     servo[0] = 1460; //R1 - kiri
; 0000 048D                     //kaki kiri
; 0000 048E                     servo[11] = 1500;
; 0000 048F                     servo[10] = 1500; //L5 - kanan
; 0000 0490                     servo[9]  = 470;  //L4 - maju    984
; 0000 0491                     servo[8]  = 2508; //L3 - maju
; 0000 0492                     servo[7]  = 1006; //L2 - maju
; 0000 0493                     servo[6]  = 1500; //L1 - kanan
; 0000 0494                     //tangan kanan
; 0000 0495                     servo[14] = 460; //R3 - CW
; 0000 0496                     servo[13] = 2100; //R2 - turun
; 0000 0497                     servo[12] = 1600; //R1 - mundur
; 0000 0498                     //tangan kiri
; 0000 0499                     servo[17]  = 2500; //L3 - CW
; 0000 049A                     servo[16]  = 850; //L2 - naik
; 0000 049B                     servo[15]  = 1500; //L1 - maju
; 0000 049C                     delay_ms(lay);
; 0000 049D 
; 0000 049E                     tangi=9;
; 0000 049F            break;
; 0000 04A0 
; 0000 04A1            case 9:
; 0000 04A2                     //kaki kanan
; 0000 04A3                     servo[5] = 1500;
; 0000 04A4                     servo[4] = 1500; //R5 - kiri
; 0000 04A5                     servo[3] = 480;  //R4 - maju
; 0000 04A6                     servo[2] = 2508; //R3 - maju
; 0000 04A7                     servo[1] = 1006; //R2 - maju
; 0000 04A8                     servo[0] = 1460; //R1 - kiri
; 0000 04A9                     //kaki kiri
; 0000 04AA                     servo[11] = 1500;
; 0000 04AB                     servo[10] = 1500; //L5 - kanan
; 0000 04AC                     servo[9]  = 500;  //L4 - maju    984
; 0000 04AD                     servo[8]  = 2508; //L3 - maju
; 0000 04AE                     servo[7]  = 1006; //L2 - maju
; 0000 04AF                     servo[6]  = 1500; //L1 - kanan
; 0000 04B0                     //tangan kanan
; 0000 04B1                     servo[14] = 500; //R3 - CW
; 0000 04B2                     servo[13] = 2150; //R2 - turun
; 0000 04B3                     servo[12] = 1700; //R1 - mundur
; 0000 04B4                     //tangan kiri
; 0000 04B5                     servo[17]  = 2500; //L3 - CW
; 0000 04B6                     servo[16]  = 800; //L2 - naik
; 0000 04B7                     servo[15]  = 1400; //L1 - maju
; 0000 04B8                     delay_ms(de);
; 0000 04B9 
; 0000 04BA                     tangi=10;
; 0000 04BB            break;
; 0000 04BC 
; 0000 04BD            case 10:
; 0000 04BE                     //kaki kanan
; 0000 04BF                     servo[5] = 1500;
; 0000 04C0                     servo[4] = 1500; //R5 - kiri
; 0000 04C1                     servo[3] = 500;  //R4 - maju
; 0000 04C2                     servo[2] = 2508; //R3 - maju
; 0000 04C3                     servo[1] = 1306; //R2 - maju
; 0000 04C4                     servo[0] = 1500; //R1 - kiri
; 0000 04C5                     //kaki kiri
; 0000 04C6                     servo[11] = 1500;
; 0000 04C7                     servo[10] = 1500; //L5 - kanan
; 0000 04C8                     servo[9]  = 500;  //L4 - maju    984
; 0000 04C9                     servo[8]  = 2508; //L3 - maju
; 0000 04CA                     servo[7]  = 1306; //L2 - maju
; 0000 04CB                     servo[6]  = 1500; //L1 - kanan
; 0000 04CC                     //tangan kanan
; 0000 04CD                     servo[14] = 500; //R3 - CW
; 0000 04CE                     servo[13] = 2100; //R2 - turun
; 0000 04CF                     servo[12] = 1800; //R1 - mundur
; 0000 04D0                     //tangan kiri
; 0000 04D1                     servo[17]  = 2500; //L3 - CW
; 0000 04D2                     servo[16]  = 900; //L2 - naik
; 0000 04D3                     servo[15]  = 1200; //L1 - maju
; 0000 04D4                     delay_ms(de);
; 0000 04D5 
; 0000 04D6                     tangi=11;
; 0000 04D7            break;
; 0000 04D8 
; 0000 04D9            case 11:
; 0000 04DA                     //kaki kanan
; 0000 04DB                     servo[5] = 1500;
; 0000 04DC                     servo[4] = 1500; //R5 - kiri
; 0000 04DD                     servo[3] = 500;  //R4 - maju
; 0000 04DE                     servo[2] = 2508; //R3 - maju
; 0000 04DF                     servo[1] = 1306; //R2 - maju
; 0000 04E0                     servo[0] = 1500; //R1 - kiri
; 0000 04E1                     //kaki kiri
; 0000 04E2                     servo[11] = 1500;
; 0000 04E3                     servo[10] = 1500; //L5 - kanan
; 0000 04E4                     servo[9]  = 500;  //L4 - maju    984
; 0000 04E5                     servo[8]  = 2508; //L3 - maju
; 0000 04E6                     servo[7]  = 1306; //L2 - maju
; 0000 04E7                     servo[6]  = 1500; //L1 - kanan
; 0000 04E8                     //tangan kanan
; 0000 04E9                     servo[14] = 1600; //R3 - CW
; 0000 04EA                     servo[13] = 1000; //R2 - turun
; 0000 04EB                     servo[12] = 1800; //R1 - mundur
; 0000 04EC                     //tangan kiri
; 0000 04ED                     servo[17]  = 1400; //L3 - CW
; 0000 04EE                     servo[16]  = 2000; //L2 - naik
; 0000 04EF                     servo[15]  = 1200; //L1 - maju
; 0000 04F0                     delay_ms(de);
; 0000 04F1 
; 0000 04F2                     tangi=12;
; 0000 04F3            break;
; 0000 04F4 
; 0000 04F5            case 12:
; 0000 04F6                     //kaki kanan
; 0000 04F7                     servo[5] = 1500;
; 0000 04F8                     servo[4] = 1500; //R5 - kiri
; 0000 04F9                     servo[3] = 800;  //R4 - maju
; 0000 04FA                     servo[2] = 2508; //R3 - maju
; 0000 04FB                     servo[1] = 1056; //R2 - maju
; 0000 04FC                     servo[0] = 1500; //R1 - kiri
; 0000 04FD                     //kaki kiri
; 0000 04FE                     servo[11] = 1500;
; 0000 04FF                     servo[10] = 1500; //L5 - kanan
; 0000 0500                     servo[9]  = 800;  //L4 - maju    984
; 0000 0501                     servo[8]  = 2508; //L3 - maju
; 0000 0502                     servo[7]  = 1056; //L2 - maju
; 0000 0503                     servo[6]  = 1500; //L1 - kanan
; 0000 0504                     //tangan kanan
; 0000 0505                     servo[14] = 1200; //R3 - CW
; 0000 0506                     servo[13] = 1000; //R2 - turun
; 0000 0507                     servo[12] = 1800; //R1 - mundur
; 0000 0508                     //tangan kiri
; 0000 0509                     servo[17]  = 1800; //L3 - CW
; 0000 050A                     servo[16]  = 2000; //L2 - naik
; 0000 050B                     servo[15]  = 1200; //L1 - maju
; 0000 050C                     delay_ms(de);
; 0000 050D 
; 0000 050E                     countTick=0;
; 0000 050F                     tangi=13;
; 0000 0510            break;
; 0000 0511 
; 0000 0512            case 13:
; 0000 0513                     bangkit();
; 0000 0514            break;
; 0000 0515           }
; 0000 0516     }
;
;void bangun_tengkurap()
; 0000 0519    {
; 0000 051A     int de  = 1000;
; 0000 051B     int lay = 50;
; 0000 051C     //tango = 6;
; 0000 051D           switch(tango)
;	de -> R16,R17
;	lay -> R18,R19
; 0000 051E           {
; 0000 051F            case 0:
; 0000 0520                      //ndas
; 0000 0521                     servo[18]  = 500; //L1 - maju
; 0000 0522                     servo[19]  = 2000; //L2 - naik
; 0000 0523                     //kaki kanan
; 0000 0524                     servo[5] = 1500;
; 0000 0525                     servo[4] = 1500; //R5 - kiri
; 0000 0526                     servo[3] = 1500; //R4 - maju
; 0000 0527                     servo[2] = 1500; //R3 - maju
; 0000 0528                     servo[1] = 1500; //R2 - maju
; 0000 0529                     servo[0] = 1500; //R1 - kiri
; 0000 052A                     //kaki kiri
; 0000 052B                     servo[11] = 1500;
; 0000 052C                     servo[10] = 1500; //L5 - kanan
; 0000 052D                     servo[9]  = 1500; //L4 - maju    984
; 0000 052E                     servo[8]  = 1500; //L3 - maju
; 0000 052F                     servo[7]  = 1500; //L2 - maju
; 0000 0530                     servo[6]  = 1500; //L1 - kanan
; 0000 0531                     //tangan kanan
; 0000 0532                     servo[14] = 1500; //R3 - CW
; 0000 0533                     servo[13] = 1500; //R2 - turun
; 0000 0534                     servo[12] = 1500; //R1 - mundur
; 0000 0535                     //tangan kiri
; 0000 0536                     servo[15]  = 1500; //L1 - maju
; 0000 0537                     servo[16]  = 1500; //L2 - naik
; 0000 0538                     servo[17]  = 1500; //L3 - CW
; 0000 0539                     delay_ms(de);
; 0000 053A 
; 0000 053B                     tango=0;
; 0000 053C            break;
; 0000 053D 
; 0000 053E            case 1:
; 0000 053F                     //kaki kanan
; 0000 0540                     servo[5] = 1500;
; 0000 0541                     servo[4] = 1500; //R5 - kiri
; 0000 0542                     servo[3] = 984;  //R4 - maju
; 0000 0543                     servo[2] = 2508; //R3 - maju
; 0000 0544                     servo[1] = 1006; //R2 - maju
; 0000 0545                     servo[0] = 1500; //R1 - kiri
; 0000 0546                     //kaki kiri
; 0000 0547                     servo[11] = 1500;
; 0000 0548                     servo[10] = 1500; //L5 - kanan
; 0000 0549                     servo[9]  = 984;  //L4 - maju    984
; 0000 054A                     servo[8]  = 2508; //L3 - maju
; 0000 054B                     servo[7]  = 1006; //L2 - maju
; 0000 054C                     servo[6]  = 1500; //L1 - kanan
; 0000 054D                     //tangan kanan
; 0000 054E                     servo[14] = 1500; //R3 - CW
; 0000 054F                     servo[13] = 1500; //R2 - turun
; 0000 0550                     servo[12] = 1500; //R1 - mundur
; 0000 0551                     //tangan kiri
; 0000 0552                     servo[15]  = 1500; //L1 - maju
; 0000 0553                     servo[16]  = 1500; //L2 - naik
; 0000 0554                     servo[17]  = 1500; //L3 - CW
; 0000 0555                     delay_ms(lay);
; 0000 0556 
; 0000 0557                     tango=2;
; 0000 0558            break;
; 0000 0559 
; 0000 055A 
; 0000 055B            case 2:
; 0000 055C                     //kaki kanan
; 0000 055D                     servo[5] = 1500;
; 0000 055E                     servo[4] = 1500; //R5 - kiri
; 0000 055F                     servo[3] = 984;  //R4 - maju
; 0000 0560                     servo[2] = 2508; //R3 - maju
; 0000 0561                     servo[1] = 1006; //R2 - maju
; 0000 0562                     servo[0] = 1500; //R1 - kiri
; 0000 0563                     //kaki kiri
; 0000 0564                     servo[11] = 1500;
; 0000 0565                     servo[10] = 1500; //L5 - kanan
; 0000 0566                     servo[9]  = 984;  //L4 - maju    984
; 0000 0567                     servo[8]  = 2508; //L3 - maju
; 0000 0568                     servo[7]  = 1006; //L2 - maju
; 0000 0569                     servo[6]  = 1500; //L1 - kanan
; 0000 056A                     //tangan kanan
; 0000 056B                     servo[14] = 1500; //R3 - CW
; 0000 056C                     servo[13] = 2100; //R2 - turun
; 0000 056D                     servo[12] = 1500; //R1 - mundur
; 0000 056E                     //tangan kiri
; 0000 056F                     servo[17]  = 1500; //L3 - CW
; 0000 0570                     servo[16]  = 900; //L2 - naik
; 0000 0571                     servo[15]  = 1500; //L1 - maju
; 0000 0572                     delay_ms(lay);
; 0000 0573 
; 0000 0574                     tango=3;
; 0000 0575            break;
; 0000 0576 
; 0000 0577            case 3:
; 0000 0578                     //kaki kanan
; 0000 0579                     servo[5] = 1500;
; 0000 057A                     servo[4] = 1500; //R5 - kiri
; 0000 057B                     servo[3] = 984;  //R4 - maju
; 0000 057C                     servo[2] = 2508; //R3 - maju
; 0000 057D                     servo[1] = 1006; //R2 - maju
; 0000 057E                     servo[0] = 1500; //R1 - kiri
; 0000 057F                     //kaki kiri
; 0000 0580                     servo[11] = 1500;
; 0000 0581                     servo[10] = 1500; //L5 - kanan
; 0000 0582                     servo[9]  = 984;  //L4 - maju    984
; 0000 0583                     servo[8]  = 2508; //L3 - maju
; 0000 0584                     servo[7]  = 1006; //L2 - maju
; 0000 0585                     servo[6]  = 1500; //L1 - kanan
; 0000 0586                     //tangan kanan
; 0000 0587                     servo[14] = 500; //R3 - CW
; 0000 0588                     servo[13] = 2100; //R2 - turun
; 0000 0589                     servo[12] = 1500; //R1 - mundur
; 0000 058A                     //tangan kiri
; 0000 058B                     servo[17]  = 2500; //L3 - CW
; 0000 058C                     servo[16]  = 900; //L2 - naik
; 0000 058D                     servo[15]  = 1500; //L1 - maju
; 0000 058E                     delay_ms(lay);
; 0000 058F 
; 0000 0590                     tango=4;
; 0000 0591            break;
; 0000 0592 
; 0000 0593            case 4:
; 0000 0594                     //kaki kanan
; 0000 0595                     servo[5] = 1500;
; 0000 0596                     servo[4] = 1500; //R5 - kiri
; 0000 0597                     servo[3] = 500;  //R4 - maju
; 0000 0598                     servo[2] = 2508; //R3 - maju
; 0000 0599                     servo[1] = 1006; //R2 - maju
; 0000 059A                     servo[0] = 1460; //R1 - kiri
; 0000 059B                     //kaki kiri
; 0000 059C                     servo[11] = 1500;
; 0000 059D                     servo[10] = 1500; //L5 - kanan
; 0000 059E                     servo[9]  = 470;  //L4 - maju    984
; 0000 059F                     servo[8]  = 2508; //L3 - maju
; 0000 05A0                     servo[7]  = 1006; //L2 - maju
; 0000 05A1                     servo[6]  = 1500; //L1 - kanan
; 0000 05A2                     //tangan kanan
; 0000 05A3                     servo[14] = 460; //R3 - CW
; 0000 05A4                     servo[13] = 2100; //R2 - turun
; 0000 05A5                     servo[12] = 1600; //R1 - mundur
; 0000 05A6                     //tangan kiri
; 0000 05A7                     servo[17]  = 2500; //L3 - CW
; 0000 05A8                     servo[16]  = 850; //L2 - naik
; 0000 05A9                     servo[15]  = 1500; //L1 - maju
; 0000 05AA                     delay_ms(lay);
; 0000 05AB 
; 0000 05AC                     tango=5;
; 0000 05AD            break;
; 0000 05AE 
; 0000 05AF            case 5:
; 0000 05B0                     //kaki kanan
; 0000 05B1                     servo[5] = 1500;
; 0000 05B2                     servo[4] = 1500; //R5 - kiri
; 0000 05B3                     servo[3] = 480;  //R4 - maju
; 0000 05B4                     servo[2] = 2508; //R3 - maju
; 0000 05B5                     servo[1] = 1006; //R2 - maju
; 0000 05B6                     servo[0] = 1460; //R1 - kiri
; 0000 05B7                     //kaki kiri
; 0000 05B8                     servo[11] = 1500;
; 0000 05B9                     servo[10] = 1500; //L5 - kanan
; 0000 05BA                     servo[9]  = 500;  //L4 - maju    984
; 0000 05BB                     servo[8]  = 2508; //L3 - maju
; 0000 05BC                     servo[7]  = 1006; //L2 - maju
; 0000 05BD                     servo[6]  = 1500; //L1 - kanan
; 0000 05BE                     //tangan kanan
; 0000 05BF                     servo[14] = 500; //R3 - CW
; 0000 05C0                     servo[13] = 2150; //R2 - turun
; 0000 05C1                     servo[12] = 1700; //R1 - mundur
; 0000 05C2                     //tangan kiri
; 0000 05C3                     servo[17]  = 2500; //L3 - CW
; 0000 05C4                     servo[16]  = 800; //L2 - naik
; 0000 05C5                     servo[15]  = 1400; //L1 - maju
; 0000 05C6                     delay_ms(de);
; 0000 05C7 
; 0000 05C8                     tango=6;
; 0000 05C9            break;
; 0000 05CA 
; 0000 05CB            case 6:
; 0000 05CC                     //kaki kanan
; 0000 05CD                     servo[5] = 1500;
; 0000 05CE                     servo[4] = 1500; //R5 - kiri
; 0000 05CF                     servo[3] = 500;  //R4 - maju
; 0000 05D0                     servo[2] = 2508; //R3 - maju
; 0000 05D1                     servo[1] = 1306; //R2 - maju
; 0000 05D2                     servo[0] = 1500; //R1 - kiri
; 0000 05D3                     //kaki kiri
; 0000 05D4                     servo[11] = 1500;
; 0000 05D5                     servo[10] = 1500; //L5 - kanan
; 0000 05D6                     servo[9]  = 500;  //L4 - maju    984
; 0000 05D7                     servo[8]  = 2508; //L3 - maju
; 0000 05D8                     servo[7]  = 1306; //L2 - maju
; 0000 05D9                     servo[6]  = 1500; //L1 - kanan
; 0000 05DA                     //tangan kanan
; 0000 05DB                     servo[14] = 500; //R3 - CW
; 0000 05DC                     servo[13] = 2100; //R2 - turun
; 0000 05DD                     servo[12] = 1800; //R1 - mundur
; 0000 05DE                     //tangan kiri
; 0000 05DF                     servo[17]  = 2500; //L3 - CW
; 0000 05E0                     servo[16]  = 900; //L2 - naik
; 0000 05E1                     servo[15]  = 1200; //L1 - maju
; 0000 05E2                     delay_ms(de);
; 0000 05E3 
; 0000 05E4                     tango=7;
; 0000 05E5            break;
; 0000 05E6 
; 0000 05E7            case 7:
; 0000 05E8                     //kaki kanan
; 0000 05E9                     servo[5] = 1500;
; 0000 05EA                     servo[4] = 1500; //R5 - kiri
; 0000 05EB                     servo[3] = 500;  //R4 - maju
; 0000 05EC                     servo[2] = 2508; //R3 - maju
; 0000 05ED                     servo[1] = 1306; //R2 - maju
; 0000 05EE                     servo[0] = 1500; //R1 - kiri
; 0000 05EF                     //kaki kiri
; 0000 05F0                     servo[11] = 1500;
; 0000 05F1                     servo[10] = 1500; //L5 - kanan
; 0000 05F2                     servo[9]  = 500;  //L4 - maju    984
; 0000 05F3                     servo[8]  = 2508; //L3 - maju
; 0000 05F4                     servo[7]  = 1306; //L2 - maju
; 0000 05F5                     servo[6]  = 1500; //L1 - kanan
; 0000 05F6                     //tangan kanan
; 0000 05F7                     servo[14] = 1600; //R3 - CW
; 0000 05F8                     servo[13] = 1000; //R2 - turun
; 0000 05F9                     servo[12] = 1800; //R1 - mundur
; 0000 05FA                     //tangan kiri
; 0000 05FB                     servo[17]  = 1400; //L3 - CW
; 0000 05FC                     servo[16]  = 2000; //L2 - naik
; 0000 05FD                     servo[15]  = 1200; //L1 - maju
; 0000 05FE                     delay_ms(de);
; 0000 05FF 
; 0000 0600                     tango=8;
; 0000 0601            break;
; 0000 0602 
; 0000 0603            case 8:
; 0000 0604                     //kaki kanan
; 0000 0605                     servo[5] = 1500;
; 0000 0606                     servo[4] = 1500; //R5 - kiri
; 0000 0607                     servo[3] = 800;  //R4 - maju
; 0000 0608                     servo[2] = 2508; //R3 - maju
; 0000 0609                     servo[1] = 1056; //R2 - maju
; 0000 060A                     servo[0] = 1500; //R1 - kiri
; 0000 060B                     //kaki kiri
; 0000 060C                     servo[11] = 1500;
; 0000 060D                     servo[10] = 1500; //L5 - kanan
; 0000 060E                     servo[9]  = 800;  //L4 - maju    984
; 0000 060F                     servo[8]  = 2508; //L3 - maju
; 0000 0610                     servo[7]  = 1056; //L2 - maju
; 0000 0611                     servo[6]  = 1500; //L1 - kanan
; 0000 0612                     //tangan kanan
; 0000 0613                     servo[14] = 1200; //R3 - CW
; 0000 0614                     servo[13] = 1000; //R2 - turun
; 0000 0615                     servo[12] = 1800; //R1 - mundur
; 0000 0616                     //tangan kiri
; 0000 0617                     servo[17]  = 1800; //L3 - CW
; 0000 0618                     servo[16]  = 2000; //L2 - naik
; 0000 0619                     servo[15]  = 1200; //L1 - maju
; 0000 061A                     delay_ms(de);
; 0000 061B 
; 0000 061C                     countTick=0;
; 0000 061D                     tango=9;
; 0000 061E            break;
; 0000 061F 
; 0000 0620            case 9:
; 0000 0621                     bangkit();
; 0000 0622            break;
; 0000 0623           }
; 0000 0624    }
;
;void bangkit()
; 0000 0627  {
; 0000 0628   langkahMax=10;
; 0000 0629   switch(0)
; 0000 062A         {
; 0000 062B            case 0 :     //gait  mlaku
; 0000 062C                 VY=10;
; 0000 062D                 if(counterDelay<=0)
; 0000 062E                 {
; 0000 062F                     switch(countTick)
; 0000 0630                     {
; 0000 0631                        case 0:
; 0000 0632                             X[0]=0; Y[0]=0; Z[0]=-80;
; 0000 0633                             X[1]=0; Y[1]=0; Z[1]=-80;
; 0000 0634                             InputXYZ();
; 0000 0635                        break;
; 0000 0636                         case 1:
; 0000 0637                             X[0]=0; Y[0]=0; Z[0]=-70;
; 0000 0638                             X[1]=0; Y[1]=0; Z[1]=-70;
; 0000 0639                             InputXYZ();
; 0000 063A 
; 0000 063B                         break;
; 0000 063C                         case 2:
; 0000 063D                             X[0]=0; Y[0]=0; Z[0]=-60;
; 0000 063E                             X[1]=0; Y[1]=0; Z[1]=-60;
; 0000 063F                             InputXYZ();
; 0000 0640 
; 0000 0641                         break;
; 0000 0642                         case 4:
; 0000 0643                             X[0]=0; Y[0]=0; Z[0]=-50;
; 0000 0644                             X[1]=0; Y[1]=0; Z[1]=-50;
; 0000 0645                             InputXYZ();
; 0000 0646                         break;
; 0000 0647                         case 5:
; 0000 0648                             X[0]=0 ; Y[0]=0; Z[0]=-40;
; 0000 0649                             X[1]=0 ; Y[1]=0; Z[1]=-40;
; 0000 064A                             InputXYZ();
; 0000 064B 
; 0000 064C                         break;
; 0000 064D                         case 6:
; 0000 064E                             X[0]=0; Y[0]=0; Z[0]=-30;
; 0000 064F                             X[1]=0; Y[1]=0; Z[1]=-30;
; 0000 0650                             InputXYZ();
; 0000 0651 
; 0000 0652                         break;
; 0000 0653                         case 7:
; 0000 0654                             X[0]=0; Y[0]=0; Z[0]=-20;
; 0000 0655                             X[1]=0; Y[1]=0; Z[1]=-20;
; 0000 0656                             InputXYZ();
; 0000 0657 
; 0000 0658                         break;
; 0000 0659                         case 8:
; 0000 065A                             X[0]=0; Y[0]=0; Z[0]=-10;
; 0000 065B                             X[1]=0; Y[1]=0; Z[1]=-10;
; 0000 065C                             InputXYZ();
; 0000 065D 
; 0000 065E                         break;
; 0000 065F                         case 9:
; 0000 0660                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 0661                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 0662                             InputXYZ();
; 0000 0663 
; 0000 0664                             sudah = 1;
; 0000 0665                         break;
; 0000 0666                     }
; 0000 0667                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 0668                     {
; 0000 0669                         countTick++;
; 0000 066A                         if(countTick>9)
; 0000 066B                            countTick=9;     //2
; 0000 066C                     }
; 0000 066D                     else
; 0000 066E                     {
; 0000 066F                         countTick=0;
; 0000 0670                     }
; 0000 0671 
; 0000 0672                     counterDelay=1000; //3000
; 0000 0673                 }
; 0000 0674             break;
; 0000 0675         }
; 0000 0676 
; 0000 0677         speed=10; //10
; 0000 0678         if(counterTG>speed)
; 0000 0679         {
; 0000 067A             counterTG=0;
; 0000 067B             taskGerakan();
; 0000 067C         }
; 0000 067D  }
;
;void maju(){
; 0000 067F void maju(){
_maju:
; .FSTART _maju
; 0000 0680     //tangan kanan
; 0000 0681     servo[14] = 1350+400; //R3 - CW
	CALL SUBOPT_0x6F
; 0000 0682     servo[13] = 900-330; //R2 - turun
; 0000 0683     servo[12] = 1900+600; //R1 - mundur
; 0000 0684     //tangan kiri
; 0000 0685     servo[17]  = 1650-300; //L3 - CW
	CALL SUBOPT_0x70
; 0000 0686     servo[16]  = 2050+440; //L2 - naik
; 0000 0687     servo[15]  = 1100-650; //L1 - maju
; 0000 0688 
; 0000 0689     //ndass
; 0000 068A     //servo[18]  = 1500; //tambah ngiri
; 0000 068B     //servo[19]  = 1500; //tambah mudun
; 0000 068C 
; 0000 068D     servoInitError[1]=-100;
; 0000 068E     servoInitError[2]=+310;
; 0000 068F     servoInitError[3]= -250;
; 0000 0690     servoInitError[7]=-100;
; 0000 0691     servoInitError[8]=+310;
; 0000 0692     servoInitError[9]= -250;
; 0000 0693 
; 0000 0694     switch(0)
; 0000 0695         {
; 0000 0696            case 0 :     //gait  mlaku
	BREQ PC+2
	RJMP _0x20E
; 0000 0697                 VY=36;
	__GETD1N 0x42100000
	CALL SUBOPT_0x7B
; 0000 0698                 if(counterDelay<=0)
	BRGE PC+2
	RJMP _0x210
; 0000 0699                 {
; 0000 069A                     switch(countTick)
	__GETW1R 13,14
; 0000 069B                     {
; 0000 069C                        case 0:
	SBIW R30,0
	BRNE _0x214
; 0000 069D                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7C
; 0000 069E                             X[1]=0; Y[1]=0; Z[1]=0;
	RJMP _0x293
; 0000 069F                             InputXYZ();
; 0000 06A0                         break;
; 0000 06A1                         case 1:
_0x214:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x215
; 0000 06A2                             X[0]=14; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7E
; 0000 06A3                             X[1]=-14; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x7F
	RJMP _0x293
; 0000 06A4                             InputXYZ();
; 0000 06A5                         break;
; 0000 06A6                         case 2:
_0x215:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x216
; 0000 06A7                             X[0]=14; Y[0]=40; Z[0]=-30;
	CALL SUBOPT_0x7D
	__GETD1N 0x42200000
	CALL SUBOPT_0x80
	__GETD1N 0xC1F00000
	CALL SUBOPT_0x81
; 0000 06A8                             X[1]=-14; Y[1]=0; Z[1]=0;
	__POINTW1MN _X,4
	CALL SUBOPT_0x7F
	RJMP _0x293
; 0000 06A9                             InputXYZ();
; 0000 06AA                         break;
; 0000 06AB                         case 3:
_0x216:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x217
; 0000 06AC                             X[0]=0; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x7C
; 0000 06AD                             X[1]=0; Y[1]=0; Z[1]=0;
	RJMP _0x293
; 0000 06AE                             InputXYZ();
; 0000 06AF                         break;
; 0000 06B0 
; 0000 06B1                         case 4:
_0x217:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x218
; 0000 06B2                             X[0]=-14; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x82
; 0000 06B3                             X[1]=14; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
	RJMP _0x293
; 0000 06B4                             InputXYZ();
; 0000 06B5                         break;
; 0000 06B6                         case 5:
_0x218:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x213
; 0000 06B7                             X[0]=-14; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x82
; 0000 06B8                             X[1]=14; Y[1]=VY; Z[1]=-30;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x85
	CALL SUBOPT_0x86
	__GETD2N 0xC1F00000
_0x293:
	CALL __PUTDZ20
; 0000 06B9                             InputXYZ();
	RCALL _InputXYZ
; 0000 06BA                         break;
; 0000 06BB //                        case 6:
; 0000 06BC //                            X[0]=0; Y[0]=0; Z[0]=0;
; 0000 06BD //                            X[1]=0; Y[1]=0; Z[1]=0;
; 0000 06BE //                            InputXYZ();
; 0000 06BF //                        break;
; 0000 06C0                     }
_0x213:
; 0000 06C1                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x21B
	CALL SUBOPT_0x72
	BREQ _0x21A
_0x21B:
; 0000 06C2                     {
; 0000 06C3                         countTick++;
	CALL SUBOPT_0x87
; 0000 06C4                         if(countTick>5)
	BRGE _0x21D
; 0000 06C5                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 06C6                     }
_0x21D:
; 0000 06C7                     else
	RJMP _0x21E
_0x21A:
; 0000 06C8                     {
; 0000 06C9                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 06CA                     }
_0x21E:
; 0000 06CB 
; 0000 06CC                     counterDelay=85; //65 80   85
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	CALL SUBOPT_0x88
; 0000 06CD                 }
; 0000 06CE             break;
_0x210:
; 0000 06CF         }
_0x20E:
; 0000 06D0 
; 0000 06D1         speed=1; //10
	CALL SUBOPT_0x75
; 0000 06D2         if(counterTG>speed)
	BRGE _0x21F
; 0000 06D3         {
; 0000 06D4             counterTG=0;
	CALL SUBOPT_0x76
; 0000 06D5             taskGerakan();
; 0000 06D6         }
; 0000 06D7 }
_0x21F:
	RET
; .FEND
;
;void rotasi_kiri()
; 0000 06DA  {
_rotasi_kiri:
; .FSTART _rotasi_kiri
; 0000 06DB    //tangan kanan
; 0000 06DC     servo[14] = 1350+400; //R3 - CW
	CALL SUBOPT_0x6F
; 0000 06DD     servo[13] = 900-330; //R2 - turun
; 0000 06DE     servo[12] = 1900+600; //R1 - mundur
; 0000 06DF     //tangan kiri
; 0000 06E0     servo[17]  = 1650-300; //L3 - CW
	CALL SUBOPT_0x89
; 0000 06E1     servo[16]  = 2050+440; //L2 - naik
; 0000 06E2     servo[15]  = 1100-650; //L1 - maju
; 0000 06E3 
; 0000 06E4     switch(0)
; 0000 06E5         {
; 0000 06E6            case 0 :     //gait  mlaku
	BREQ PC+2
	RJMP _0x222
; 0000 06E7                 //VY=36;
; 0000 06E8                 VX=14;
	CALL SUBOPT_0x8A
; 0000 06E9                 VY=25;
; 0000 06EA                 if(counterDelay<=0)
	BRGE PC+2
	RJMP _0x224
; 0000 06EB                 {
; 0000 06EC                     switch(countTick)
	__GETW1R 13,14
; 0000 06ED                     {
; 0000 06EE                        case 0:
	SBIW R30,0
	BRNE _0x228
; 0000 06EF                             servoInitError[1]=-100;
	CALL SUBOPT_0x78
; 0000 06F0                             servoInitError[2]=+310;
; 0000 06F1                             servoInitError[3]= -240; //-270
	CALL SUBOPT_0x8B
; 0000 06F2                             servoInitError[7]=-100;
	CALL SUBOPT_0x7A
; 0000 06F3                             servoInitError[8]=+310;
; 0000 06F4                             servoInitError[9]= -240;
	CALL SUBOPT_0x8B
; 0000 06F5 
; 0000 06F6                             X[0]=VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
; 0000 06F7                             X[1]=VX; Y[1]=0; Z[1]=0;
	RJMP _0x294
; 0000 06F8                             InputXYZ();
; 0000 06F9                         break;
; 0000 06FA                         case 1:
_0x228:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x229
; 0000 06FB                             X[0]=-VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8E
; 0000 06FC                             X[1]=VX; Y[1]=0; Z[1]=0;
	RJMP _0x294
; 0000 06FD                             InputXYZ();
; 0000 06FE                         break;
; 0000 06FF                         case 2: //mulai muter nganan
_0x229:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x22A
; 0000 0700                            servoInitError[11]=-120;
	__POINTW1MN _servoInitError,22
	LDI  R26,LOW(65416)
	LDI  R27,HIGH(65416)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0701 
; 0000 0702                             X[0]=-VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8E
; 0000 0703                             X[1]=VX; Y[1]=-40; Z[1]=-20;
	CALL SUBOPT_0x8F
	__POINTW1MN _Y,4
	__GETD2N 0xC2200000
	CALL SUBOPT_0x12
	__POINTW1MN _Z,4
	__GETD2N 0xC1A00000
	RJMP _0x295
; 0000 0704                             InputXYZ();
; 0000 0705                         break;
; 0000 0706 
; 0000 0707                         case 3:
_0x22A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x22B
; 0000 0708                             X[0]=VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0x91
	LDI  R30,LOW(0)
	STS  _Z,R30
	STS  _Z+1,R30
	STS  _Z+2,R30
	STS  _Z+3,R30
; 0000 0709                             X[1]=-VX; Y[1]=0; Z[1]=0;
	RJMP _0x296
; 0000 070A                             InputXYZ();
; 0000 070B                         break;
; 0000 070C                         case 4:
_0x22B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22C
; 0000 070D                             servoInitError[5]=-110;
	__POINTW1MN _servoInitError,10
	LDI  R26,LOW(65426)
	LDI  R27,HIGH(65426)
	RJMP _0x297
; 0000 070E 
; 0000 070F                             X[0]=VX; Y[0]=VY; Z[0]=-20;
; 0000 0710                             X[1]=-VX; Y[1]=0; Z[1]=0;
; 0000 0711                             InputXYZ();
; 0000 0712                         break;
; 0000 0713                         case 5:
_0x22C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x227
; 0000 0714                             servoInitError[5]=0;
	CALL SUBOPT_0x92
; 0000 0715                             servoInitError[11]=0;
_0x297:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0716 
; 0000 0717                             X[0]=VX; Y[0]=VY; Z[0]=-20;
	CALL SUBOPT_0x90
	CALL SUBOPT_0x85
	CALL SUBOPT_0x93
; 0000 0718                             X[1]=-VX; Y[1]=0; Z[1]=0;
_0x296:
	LDS  R30,_VX
	LDS  R31,_VX+1
	LDS  R22,_VX+2
	LDS  R23,_VX+3
	CALL __ANEGF1
_0x294:
	__PUTD1MN _X,4
	CALL SUBOPT_0x84
_0x295:
	CALL __PUTDZ20
; 0000 0719                             InputXYZ();
	RCALL _InputXYZ
; 0000 071A                         break;
; 0000 071B 
; 0000 071C                     }
_0x227:
; 0000 071D                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x22F
	CALL SUBOPT_0x72
	BREQ _0x22E
_0x22F:
; 0000 071E                     {
; 0000 071F                         countTick++;
	CALL SUBOPT_0x87
; 0000 0720                         if(countTick>5)
	BRGE _0x231
; 0000 0721                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 0722                     }
_0x231:
; 0000 0723                     else
	RJMP _0x232
_0x22E:
; 0000 0724                     {
; 0000 0725                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0726                     }
_0x232:
; 0000 0727 
; 0000 0728                     counterDelay=80; //65 80
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x88
; 0000 0729                 }
; 0000 072A             break;
_0x224:
; 0000 072B         }
_0x222:
; 0000 072C 
; 0000 072D         speed=1; //10
	CALL SUBOPT_0x75
; 0000 072E         if(counterTG>speed)
	BRGE _0x233
; 0000 072F         {
; 0000 0730             counterTG=0;
	CALL SUBOPT_0x76
; 0000 0731             taskGerakan();
; 0000 0732         }
; 0000 0733  }
_0x233:
	RET
; .FEND
;
;void rotasi_kanan()
; 0000 0736  {
_rotasi_kanan:
; .FSTART _rotasi_kanan
; 0000 0737     //tangan kanan
; 0000 0738     servo[14] = 1350+400; //R3 - CW
	CALL SUBOPT_0x6F
; 0000 0739     servo[13] = 900-330; //R2 - turun
; 0000 073A     servo[12] = 1900+600; //R1 - mundur
; 0000 073B     //tangan kiri
; 0000 073C     servo[17]  = 1650-300; //L3 - CW
	CALL SUBOPT_0x89
; 0000 073D     servo[16]  = 2050+440; //L2 - naik
; 0000 073E     servo[15]  = 1100-650; //L1 - maju
; 0000 073F 
; 0000 0740     switch(0)
; 0000 0741         {
; 0000 0742            case 0 :     //gait  mlaku
	BREQ PC+2
	RJMP _0x236
; 0000 0743                 //VY=36;
; 0000 0744                 VX=14;
	CALL SUBOPT_0x8A
; 0000 0745                 VY=25;
; 0000 0746                 if(counterDelay<=0)
	BRGE PC+2
	RJMP _0x238
; 0000 0747                 {
; 0000 0748                     switch(countTick)
	__GETW1R 13,14
; 0000 0749                     {
; 0000 074A                        case 0:
	SBIW R30,0
	BRNE _0x23C
; 0000 074B                             servoInitError[1]=-100;
	CALL SUBOPT_0x78
; 0000 074C                             servoInitError[2]=+310;
; 0000 074D                             servoInitError[3]= -240; //-270
	CALL SUBOPT_0x8B
; 0000 074E                             servoInitError[7]=-100;
	CALL SUBOPT_0x7A
; 0000 074F                             servoInitError[8]=+310;
; 0000 0750                             servoInitError[9]= -240;
	CALL SUBOPT_0x8B
; 0000 0751 
; 0000 0752                             X[0]=VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
; 0000 0753                             X[1]=VX; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x84
	RJMP _0x298
; 0000 0754                             InputXYZ();
; 0000 0755                         break;
; 0000 0756                         case 1:
_0x23C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x23D
; 0000 0757                             X[0]=VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
; 0000 0758                             X[1]=-VX; Y[1]=0; Z[1]=0;
	CALL __ANEGF1
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x84
	RJMP _0x298
; 0000 0759                             InputXYZ();
; 0000 075A                         break;
; 0000 075B                         case 2: //mulai muter nganan
_0x23D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x23E
; 0000 075C                            servoInitError[5]=+120;
	__POINTW1MN _servoInitError,10
	LDI  R26,LOW(120)
	LDI  R27,HIGH(120)
	CALL SUBOPT_0x94
; 0000 075D 
; 0000 075E                             X[0]=VX; Y[0]=-40; Z[0]=-20;
	__GETD1N 0xC2200000
	CALL SUBOPT_0x93
; 0000 075F                             X[1]=-VX; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x8C
	CALL __ANEGF1
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x84
	RJMP _0x298
; 0000 0760                             InputXYZ();
; 0000 0761                         break;
; 0000 0762 
; 0000 0763                         case 3:
_0x23E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x23F
; 0000 0764                             X[0]=-VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8E
; 0000 0765                             X[1]=VX; Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x84
	RJMP _0x298
; 0000 0766                             InputXYZ();
; 0000 0767                         break;
; 0000 0768                         case 4:
_0x23F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x240
; 0000 0769                             servoInitError[11]=+110;
	__POINTW1MN _servoInitError,22
	LDI  R26,LOW(110)
	LDI  R27,HIGH(110)
	RJMP _0x299
; 0000 076A 
; 0000 076B                             X[0]=-VX; Y[0]=0; Z[0]=0;
; 0000 076C                             X[1]=VX; Y[1]=VY; Z[1]=-20;
; 0000 076D                             InputXYZ();
; 0000 076E                         break;
; 0000 076F                         case 5:
_0x240:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x23B
; 0000 0770                             servoInitError[5]=0;
	CALL SUBOPT_0x92
; 0000 0771                             servoInitError[11]=0;
_0x299:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0772 
; 0000 0773                             X[0]=-VX; Y[0]=0; Z[0]=0;
	CALL SUBOPT_0x8E
; 0000 0774                             X[1]=VX; Y[1]=VY; Z[1]=-20;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x85
	CALL SUBOPT_0x86
	__GETD2N 0xC1A00000
_0x298:
	CALL __PUTDZ20
; 0000 0775                             InputXYZ();
	RCALL _InputXYZ
; 0000 0776                         break;
; 0000 0777 
; 0000 0778                     }
_0x23B:
; 0000 0779                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x243
	CALL SUBOPT_0x72
	BREQ _0x242
_0x243:
; 0000 077A                     {
; 0000 077B                         countTick++;
	CALL SUBOPT_0x87
; 0000 077C                         if(countTick>5)
	BRGE _0x245
; 0000 077D                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 077E                     }
_0x245:
; 0000 077F                     else
	RJMP _0x246
_0x242:
; 0000 0780                     {
; 0000 0781                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 0782                     }
_0x246:
; 0000 0783 
; 0000 0784                     counterDelay=80; //65 80
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x88
; 0000 0785                 }
; 0000 0786             break;
_0x238:
; 0000 0787         }
_0x236:
; 0000 0788 
; 0000 0789         speed=1; //10
	CALL SUBOPT_0x75
; 0000 078A         if(counterTG>speed)
	BRGE _0x247
; 0000 078B         {
; 0000 078C             counterTG=0;
	CALL SUBOPT_0x76
; 0000 078D             taskGerakan();
; 0000 078E         }
; 0000 078F  }
_0x247:
	RET
; .FEND
;
;void tes_1500()
; 0000 0792 {
; 0000 0793     servo[0] = 1500; //R3 - CW
; 0000 0794     servo[1] = 1500; //R2 - turun
; 0000 0795     servo[2] = 1500; //R1 - mundur
; 0000 0796     servo[3] = 1500; //R3 - CW
; 0000 0797     servo[4] = 1500; //R2 - turun
; 0000 0798     servo[5] = 1500; //R1 - mundur
; 0000 0799      servo[5] = 1500; //R3 - CW
; 0000 079A     servo[6] = 1500; //R2 - turun
; 0000 079B     servo[7] = 1500; //R1 - mundur
; 0000 079C      servo[8] = 1500; //R3 - CW
; 0000 079D     servo[9] = 1500; //R2 - turun
; 0000 079E     servo[10] = 1500; //R1 - mundur
; 0000 079F      servo[11] = 1500; //R3 - CW
; 0000 07A0     servo[12] = 1500; //R2 - turun
; 0000 07A1     servo[13] = 1500; //R1 - mundur
; 0000 07A2      servo[14] = 1500; //R3 - CW
; 0000 07A3     servo[15] = 1500; //R2 - turun
; 0000 07A4     servo[16] = 1500; //R1 - mundur
; 0000 07A5  servo[17] = 1500; //R3 - CW
; 0000 07A6     servo[18] = 1500; //R2 - turun
; 0000 07A7     servo[19] = 1500; //R1 - mundur
; 0000 07A8 
; 0000 07A9 }
;
;void tendang_dik(){
; 0000 07AB void tendang_dik(){
_tendang_dik:
; .FSTART _tendang_dik
; 0000 07AC 
; 0000 07AD     langkahMax=40;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _langkahMax,R30
	STS  _langkahMax+1,R31
; 0000 07AE 
; 0000 07AF     //tangan kanan
; 0000 07B0     servo[14] = 1350+400; //R3 - CW
	CALL SUBOPT_0x6F
; 0000 07B1     servo[13] = 900-330; //R2 - turun
; 0000 07B2     servo[12] = 1900+600; //R1 - mundur
; 0000 07B3     //tangan kiri
; 0000 07B4     servo[17]  = 1650-300; //L3 - CW
	__POINTW1MN _servo,34
	LDI  R26,LOW(1350)
	LDI  R27,HIGH(1350)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07B5     servo[16]  = 2050+440; //L2 - naik
	__POINTW1MN _servo,32
	LDI  R26,LOW(2490)
	LDI  R27,HIGH(2490)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07B6     servo[15]  = 1100-650; //L1 - maju
	__POINTW1MN _servo,30
	LDI  R26,LOW(450)
	LDI  R27,HIGH(450)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07B7 
; 0000 07B8     VX=10;
	CALL SUBOPT_0x95
	STS  _VX,R30
	STS  _VX+1,R31
	STS  _VX+2,R22
	STS  _VX+3,R23
; 0000 07B9     //VY=38;
; 0000 07BA     //VZ=30;
; 0000 07BB 
; 0000 07BC     switch(0)
	LDI  R30,LOW(0)
; 0000 07BD         {
; 0000 07BE            case 0 :     //gait  mlaku
	CPI  R30,0
	BREQ PC+2
	RJMP _0x24A
; 0000 07BF                 VY=75;   //40 42
	__GETD1N 0x42960000
	STS  _VY,R30
	STS  _VY+1,R31
	STS  _VY+2,R22
	STS  _VY+3,R23
; 0000 07C0                 VZ=-35;   //25 -50
	__GETD1N 0xC20C0000
	STS  _VZ,R30
	STS  _VZ+1,R31
	STS  _VZ+2,R22
	STS  _VZ+3,R23
; 0000 07C1                 if(counterDelay<=0)
	CALL SUBOPT_0x1
	BRGE PC+2
	RJMP _0x24C
; 0000 07C2                 {
; 0000 07C3                     switch(countTick)
	__GETW1R 13,14
; 0000 07C4                     {
; 0000 07C5                         case 0: //siap nendang
	SBIW R30,0
	BRNE _0x250
; 0000 07C6                         servoInitError[1]=-100;
	CALL SUBOPT_0x78
; 0000 07C7                         servoInitError[2]=+310;
; 0000 07C8                         servoInitError[3]= -270;
	CALL SUBOPT_0x96
; 0000 07C9                         servoInitError[7]=-100;
	CALL SUBOPT_0x7A
; 0000 07CA                         servoInitError[8]=+310;
; 0000 07CB                         servoInitError[9]= -270;
	LDI  R26,LOW(65266)
	LDI  R27,HIGH(65266)
	RJMP _0x29A
; 0000 07CC 
; 0000 07CD                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 07CE                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 07CF                             InputXYZ();
; 0000 07D0                         break;
; 0000 07D1 
; 0000 07D2                         case 1:  //miring kiri
_0x250:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x251
; 0000 07D3                            servoInitError[0]=0;
	CALL SUBOPT_0x97
; 0000 07D4                            servoInitError[3]=-270;
; 0000 07D5                            servoInitError[4]=+40;
	CALL SUBOPT_0x98
; 0000 07D6                            servoInitError[6]=0;
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL SUBOPT_0x99
; 0000 07D7                            servoInitError[9]=-270;
; 0000 07D8 
; 0000 07D9                             X[0]=VX;    Y[0]=0; Z[0]=15;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9A
; 0000 07DA                             X[1]=VX;    Y[1]=0; Z[1]=0;
	RJMP _0x29B
; 0000 07DB                             InputXYZ();
; 0000 07DC                         break;
; 0000 07DD 
; 0000 07DE                         case 2:  //miring kiri
_0x251:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x252
; 0000 07DF                            servoInitError[0]=0; //+270
	CALL SUBOPT_0x97
; 0000 07E0                            servoInitError[3]=-270;
; 0000 07E1                            servoInitError[4]=+40;
	CALL SUBOPT_0x98
; 0000 07E2                            servoInitError[6]=-110;
	LDI  R26,LOW(65426)
	LDI  R27,HIGH(65426)
	CALL SUBOPT_0x99
; 0000 07E3                            servoInitError[9]=-270;
; 0000 07E4 
; 0000 07E5                             X[0]=VX;    Y[0]=0; Z[0]=15;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9A
; 0000 07E6                             X[1]=VX;    Y[1]=0; Z[1]=0;
	RJMP _0x29B
; 0000 07E7                             InputXYZ();
; 0000 07E8                         break;
; 0000 07E9 
; 0000 07EA                         case 3:  //miring kiri
_0x252:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x253
; 0000 07EB                            servoInitError[0]=0; //+270
	CALL SUBOPT_0x97
; 0000 07EC                            servoInitError[3]=-270;
; 0000 07ED                            servoInitError[4]=+40;
	CALL SUBOPT_0x98
; 0000 07EE                            servoInitError[6]=-196;
	LDI  R26,LOW(65340)
	LDI  R27,HIGH(65340)
	CALL SUBOPT_0x99
; 0000 07EF                            servoInitError[9]=-270;
; 0000 07F0 
; 0000 07F1                             X[0]=VX;    Y[0]=0; Z[0]=15;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9A
; 0000 07F2                             X[1]=VX;    Y[1]=0; Z[1]=0;
	RJMP _0x29B
; 0000 07F3                             InputXYZ();
; 0000 07F4                         break;
; 0000 07F5 
; 0000 07F6                         case 4:
_0x253:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x254
; 0000 07F7                            servoInitError[0]=+180;
	CALL SUBOPT_0x9B
; 0000 07F8                            servoInitError[3]=-270;
	__POINTW1MN _servoInitError,6
	CALL SUBOPT_0x96
; 0000 07F9                            servoInitError[4]=+40;
	CALL SUBOPT_0x9C
; 0000 07FA 
; 0000 07FB                             X[0]=VX;    Y[0]=0; Z[0]=VZ;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9D
; 0000 07FC                             X[1]=VX;    Y[1]=0; Z[1]=0;
	RJMP _0x29B
; 0000 07FD                             InputXYZ();
; 0000 07FE                         break;
; 0000 07FF 
; 0000 0800                         case 5: //saat nendang
_0x254:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x255
; 0000 0801                             servoInitError[0]=+180;
	CALL SUBOPT_0x9B
; 0000 0802                             servoInitError[1]=400;
	__POINTW1MN _servoInitError,2
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0803                             servoInitError[2]=-250; //-250
	__POINTW1MN _servoInitError,4
	CALL SUBOPT_0x79
; 0000 0804                             servoInitError[3]=-270;
	__POINTW1MN _servoInitError,6
	CALL SUBOPT_0x96
; 0000 0805                             servoInitError[4]=+40;
	CALL SUBOPT_0x9C
; 0000 0806 
; 0000 0807                             X[0]=VX;    Y[0]=VY; Z[0]=VZ;
	CALL SUBOPT_0x85
	CALL SUBOPT_0x80
	CALL SUBOPT_0x9D
; 0000 0808                             X[1]=VX;    Y[1]=0; Z[1]=0;
	RJMP _0x29B
; 0000 0809                             InputXYZ();
; 0000 080A                         break;
; 0000 080B 
; 0000 080C                         case 6:
_0x255:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x256
; 0000 080D                             servoInitError[0]=+180;
	CALL SUBOPT_0x9B
; 0000 080E                             servoInitError[1]=-100;
	CALL SUBOPT_0x78
; 0000 080F                             servoInitError[2]=+310;
; 0000 0810                             servoInitError[3]=-270;
	CALL SUBOPT_0x96
; 0000 0811                             servoInitError[4]=+40;
	CALL SUBOPT_0x9C
; 0000 0812 
; 0000 0813                             X[0]=VX;    Y[0]=0; Z[0]=VZ;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9D
; 0000 0814                             X[1]=VX;    Y[1]=0; Z[1]=0;
	RJMP _0x29B
; 0000 0815                             InputXYZ();
; 0000 0816                         break;
; 0000 0817 
; 0000 0818                         case 7:
_0x256:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x257
; 0000 0819                             servoInitError[0]=+90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _servoInitError,R30
	STS  _servoInitError+1,R31
; 0000 081A                             servoInitError[6]=-150;
	__POINTW1MN _servoInitError,12
	LDI  R26,LOW(65386)
	LDI  R27,HIGH(65386)
	CALL SUBOPT_0x94
; 0000 081B 
; 0000 081C                             X[0]=VX;    Y[0]=0; Z[0]=VZ/5;
	CALL SUBOPT_0x91
	LDS  R26,_VZ
	LDS  R27,_VZ+1
	LDS  R24,_VZ+2
	LDS  R25,_VZ+3
	__GETD1N 0x40A00000
	CALL __DIVF21
	CALL SUBOPT_0x81
; 0000 081D                             X[1]=VX;    Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	RJMP _0x29B
; 0000 081E                             InputXYZ();
; 0000 081F                         break;
; 0000 0820 
; 0000 0821                         case 8:
_0x257:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x24F
; 0000 0822                             servoInitError[0]=0;
	LDI  R30,LOW(0)
	STS  _servoInitError,R30
	STS  _servoInitError+1,R30
; 0000 0823                             servoInitError[6]=0;
	__POINTW1MN _servoInitError,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
_0x29A:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0824 
; 0000 0825                             X[0]=0;    Y[0]=0; Z[0]=0;
	LDI  R30,LOW(0)
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	CALL SUBOPT_0x7E
; 0000 0826                             X[1]=0;    Y[1]=0; Z[1]=0;
	CALL SUBOPT_0x9E
_0x29B:
	__POINTW1MN _Y,4
	CALL SUBOPT_0x9E
	__POINTW1MN _Z,4
	CALL SUBOPT_0x9E
; 0000 0827 
; 0000 0828                             InputXYZ();
	RCALL _InputXYZ
; 0000 0829                         break;
; 0000 082A 
; 0000 082B //     switch(0)
; 0000 082C //        {
; 0000 082D //           case 0 :     //gait  mlaku
; 0000 082E //                VY=75;   //40 42
; 0000 082F //                VZ=-50;   //25
; 0000 0830 //                if(counterDelay<=0)
; 0000 0831 //                {
; 0000 0832 //                    switch(countTick)
; 0000 0833 //                    {
; 0000 0834 //                            case 0: //SIAP
; 0000 0835 //                            servoInitError[0]=-65;
; 0000 0836 //                            servoInitError[6]=-43;
; 0000 0837 //
; 0000 0838 //                            servoInitError[3] =-35;
; 0000 0839 //                            servoInitError[9] =-35;
; 0000 083A //
; 0000 083B //                            X[0]=VX; Y[0]=0; Z[0]=0;
; 0000 083C //                            X[1]=VX; Y[1]=0; Z[1]=0;
; 0000 083D //                            InputXYZ();
; 0000 083E //                        break;
; 0000 083F ////
; 0000 0840 //                        case 1:  //miring kiri
; 0000 0841 //
; 0000 0842 //
; 0000 0843 //                            servoInitError[6]=-185;      //-- luar keatas
; 0000 0844 //                             servoInitError[0]=+120-65;
; 0000 0845 //
; 0000 0846 //                            X[0]=VX;    Y[0]=0; Z[0]=0;
; 0000 0847 //                            X[1]=VX;    Y[1]=0; Z[1]=0;
; 0000 0848 //                            InputXYZ();
; 0000 0849 //                        break;
; 0000 084A //                        case 2:
; 0000 084B //                            X[0]=VX;    Y[0]=0; Z[0]=VZ;
; 0000 084C //                            X[1]=VX;    Y[1]=0; Z[1]=0;
; 0000 084D //                            InputXYZ();
; 0000 084E //                        break;
; 0000 084F //                        case 3:
; 0000 0850 //                            servoInitError[0]=-65;
; 0000 0851 //                            servoInitError[3]=-335;  //9
; 0000 0852 //                            servoInitError[2]=-300;  //8
; 0000 0853 //                            servoInitError[1]=500;
; 0000 0854 //                            X[0]=VX;    Y[0]=VY; Z[0]=VZ;
; 0000 0855 //                            X[1]=VX;    Y[1]=0; Z[1]=0;
; 0000 0856 //                            InputXYZ();
; 0000 0857 //                        break;
; 0000 0858 //                        case 4:
; 0000 0859 //                            servoInitError[3]=0;  //9
; 0000 085A //                            servoInitError[2]=0;  //8
; 0000 085B //                            servoInitError[1]=0; //-- depan keluar//servoInitError[17]=600;
; 0000 085C //                            X[0]=VX;    Y[0]=0; Z[0]=VZ;
; 0000 085D //                            X[1]=VX;    Y[1]=0; Z[1]=0;
; 0000 085E //                            InputXYZ();
; 0000 085F //                        break;
; 0000 0860 //
; 0000 0861 //                        case 5:
; 0000 0862 //                             servoInitError[6]=-185+60;
; 0000 0863 //                            X[0]=VX;    Y[0]=0; Z[0]=VZ/2;
; 0000 0864 //                            X[1]=VX;    Y[1]=0; Z[1]=-10;
; 0000 0865 //                            InputXYZ();
; 0000 0866 //                        break;
; 0000 0867 //
; 0000 0868 //                        case 6:
; 0000 0869 //                            servoInitError[0]=-65;
; 0000 086A //                            servoInitError[6]=-43;
; 0000 086B //
; 0000 086C //                            servoInitError[3] =-35;
; 0000 086D //                            servoInitError[9] =-35; //-- depan keluar//servoInitError[17]=600;
; 0000 086E //                            X[0]=VX;    Y[0]=0; Z[0]=0;
; 0000 086F //                            X[1]=VX;    Y[1]=0; Z[1]=-5;
; 0000 0870 //
; 0000 0871 //                            InputXYZ();
; 0000 0872 //                        break;
; 0000 0873                 }
_0x24F:
; 0000 0874                     if(VX != 0 || VY != 0 | W != 0 )
	CALL SUBOPT_0x2C
	BRNE _0x25A
	CALL SUBOPT_0x72
	BREQ _0x259
_0x25A:
; 0000 0875                     {
; 0000 0876                         countTick++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 0877                         if(countTick>8)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x25C
; 0000 0878                            countTick=0;     //2
	CLR  R13
	CLR  R14
; 0000 0879                     }
_0x25C:
; 0000 087A                     else
	RJMP _0x25D
_0x259:
; 0000 087B                     {
; 0000 087C                         countTick=0;
	CLR  R13
	CLR  R14
; 0000 087D                     }
_0x25D:
; 0000 087E 
; 0000 087F                     counterDelay=1000; //500
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x88
; 0000 0880                 }
; 0000 0881             break;
_0x24C:
; 0000 0882         }
_0x24A:
; 0000 0883 
; 0000 0884         speed=1; //10
	CALL SUBOPT_0x75
; 0000 0885         if(counterTG>speed)
	BRGE _0x25E
; 0000 0886         {
; 0000 0887             counterTG=0;
	CALL SUBOPT_0x76
; 0000 0888             taskGerakan();
; 0000 0889         }
; 0000 088A }
_0x25E:
	RET
; .FEND
;
;void mundur()
; 0000 088D  {
; 0000 088E     //tangan kanan
; 0000 088F     servo[14] = 1350+400; //R3 - CW
; 0000 0890     servo[13] = 900-330; //R2 - turun
; 0000 0891     servo[12] = 1900+600; //R1 - mundur
; 0000 0892     //tangan kiri
; 0000 0893     servo[17]  = 1650-300; //L3 - CW
; 0000 0894     servo[16]  = 2050+440; //L2 - naik
; 0000 0895     servo[15]  = 1100-650; //L1 - maju
; 0000 0896 
; 0000 0897     servoInitError[1]=-100;
; 0000 0898     servoInitError[2]=+310;
; 0000 0899     servoInitError[3]= -225; //-270
; 0000 089A     servoInitError[7]=-100;
; 0000 089B     servoInitError[8]=+310;
; 0000 089C     servoInitError[9]= -225;
; 0000 089D 
; 0000 089E     switch(0)
; 0000 089F         {
; 0000 08A0            case 0 :     //gait  mlaku
; 0000 08A1                 //VY=36;
; 0000 08A2                 VY=-5;
; 0000 08A3                 if(counterDelay<=0)
; 0000 08A4                 {
; 0000 08A5                     switch(countTick)
; 0000 08A6                     {
; 0000 08A7                        case 0:
; 0000 08A8                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 08A9                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 08AA                             InputXYZ();
; 0000 08AB                         break;
; 0000 08AC                         case 1:
; 0000 08AD                             X[0]=14; Y[0]=0; Z[0]=0;
; 0000 08AE                             X[1]=-14; Y[1]=0; Z[1]=0;
; 0000 08AF                             InputXYZ();
; 0000 08B0                         break;
; 0000 08B1                         case 2:
; 0000 08B2                             X[0]=14; Y[0]=VY; Z[0]=-30;
; 0000 08B3                             X[1]=-14; Y[1]=0; Z[1]=0;
; 0000 08B4                             InputXYZ();
; 0000 08B5                         break;
; 0000 08B6                         case 3:
; 0000 08B7                             X[0]=0; Y[0]=0; Z[0]=0;
; 0000 08B8                             X[1]=0; Y[1]=0; Z[1]=0;
; 0000 08B9                             InputXYZ();
; 0000 08BA                         break;
; 0000 08BB 
; 0000 08BC                         case 4:
; 0000 08BD                             X[0]=-14; Y[0]=0; Z[0]=0;
; 0000 08BE                             X[1]=14; Y[1]=0; Z[1]=0;
; 0000 08BF                             InputXYZ();
; 0000 08C0                         break;
; 0000 08C1                         case 5:
; 0000 08C2                             X[0]=-14; Y[0]=0; Z[0]=0;
; 0000 08C3                             X[1]=14; Y[1]=VY; Z[1]=-30;
; 0000 08C4                             InputXYZ();
; 0000 08C5                         break;
; 0000 08C6 
; 0000 08C7                     }
; 0000 08C8                     if(VX != 0 || VY != 0 | W != 0 )
; 0000 08C9                     {
; 0000 08CA                         countTick++;
; 0000 08CB                         if(countTick>5)
; 0000 08CC                            countTick=0;     //2
; 0000 08CD                     }
; 0000 08CE                     else
; 0000 08CF                     {
; 0000 08D0                         countTick=0;
; 0000 08D1                     }
; 0000 08D2 
; 0000 08D3                     counterDelay=85; //65 80
; 0000 08D4                 }
; 0000 08D5             break;
; 0000 08D6         }
; 0000 08D7 
; 0000 08D8         speed=1; //10
; 0000 08D9         if(counterTG>speed)
; 0000 08DA         {
; 0000 08DB             counterTG=0;
; 0000 08DC             taskGerakan();
; 0000 08DD         }
; 0000 08DE  }
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
; .FSTART _putchar
	ST   -Y,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x0
	ADIW R28,3
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x9F
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
	CALL SUBOPT_0xA0
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	CALL SUBOPT_0xA0
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	CALL SUBOPT_0xA1
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000027
	CALL SUBOPT_0xA0
_0x2000028:
	CALL SUBOPT_0xA1
	BRLO _0x200002A
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xA3
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0xA1
	BRSH _0x200002E
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xA5
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0xA0
_0x200002B:
	__GETD1S 12
	CALL SUBOPT_0xA6
	CALL __ADDF12
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA1
	BRLO _0x200002F
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xA3
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2000032
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA8
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x4A
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA2
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xAB
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x4B
	CALL SUBOPT_0xA5
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0xAA
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0xAD
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2000034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000119
_0x2000034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000119:
	ST   X,R30
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAD
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0xAD
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
; .FEND
__print_G100:
; .FSTART __print_G100
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
	CALL SUBOPT_0x0
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200003C
	CPI  R18,37
	BRNE _0x200003D
	LDI  R17,LOW(1)
	RJMP _0x200003E
_0x200003D:
	CALL SUBOPT_0xAE
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	CALL SUBOPT_0xAE
	RJMP _0x200011A
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
	BREQ PC+2
	RJMP _0x200003B
_0x2000054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAF
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xB1
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
	BREQ PC+2
	RJMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0xB2
	CALL __GETD1P
	CALL SUBOPT_0xB3
	CALL SUBOPT_0xB4
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	CPI  R26,LOW(0x20)
	BREQ _0x2000065
	RJMP _0x2000066
_0x2000061:
	CALL SUBOPT_0xB5
	CALL __ANEGF1
	CALL SUBOPT_0xB3
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000067
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0xB1
	RJMP _0x2000068
_0x2000067:
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000068:
_0x2000066:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x200006A
	CALL SUBOPT_0xB5
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x200006B
_0x200006A:
	CALL SUBOPT_0xB5
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x200006B:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0xB6
	RJMP _0x200006C
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006E
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xB6
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x70)
	BRNE _0x2000071
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB7
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200006F:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000073
	CP   R20,R17
	BRLO _0x2000074
_0x2000073:
	RJMP _0x2000072
_0x2000074:
	MOV  R17,R20
_0x2000072:
_0x200006C:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2000075
_0x2000071:
	CPI  R30,LOW(0x64)
	BREQ _0x2000078
	CPI  R30,LOW(0x69)
	BRNE _0x2000079
_0x2000078:
	ORI  R16,LOW(4)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x75)
	BRNE _0x200007B
_0x200007A:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0xB8
	LDI  R17,LOW(10)
	RJMP _0x200007D
_0x200007C:
	__GETD1N 0x2710
	CALL SUBOPT_0xB8
	LDI  R17,LOW(5)
	RJMP _0x200007D
_0x200007B:
	CPI  R30,LOW(0x58)
	BRNE _0x200007F
	ORI  R16,LOW(8)
	RJMP _0x2000080
_0x200007F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000BE
_0x2000080:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000082
	__GETD1N 0x10000000
	CALL SUBOPT_0xB8
	LDI  R17,LOW(8)
	RJMP _0x200007D
_0x2000082:
	__GETD1N 0x1000
	CALL SUBOPT_0xB8
	LDI  R17,LOW(4)
_0x200007D:
	CPI  R20,0
	BREQ _0x2000083
	ANDI R16,LOW(127)
	RJMP _0x2000084
_0x2000083:
	LDI  R20,LOW(1)
_0x2000084:
	SBRS R16,1
	RJMP _0x2000085
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB2
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200011B
_0x2000085:
	SBRS R16,2
	RJMP _0x2000087
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB7
	CALL __CWD1
	RJMP _0x200011B
_0x2000087:
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB7
	CLR  R22
	CLR  R23
_0x200011B:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000089
	LDD  R26,Y+13
	TST  R26
	BRPL _0x200008A
	CALL SUBOPT_0xB5
	CALL __ANEGD1
	CALL SUBOPT_0xB3
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200008A:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x200008B
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200008C
_0x200008B:
	ANDI R16,LOW(251)
_0x200008C:
_0x2000089:
	MOV  R19,R20
_0x2000075:
	SBRC R16,0
	RJMP _0x200008D
_0x200008E:
	CP   R17,R21
	BRSH _0x2000091
	CP   R19,R21
	BRLO _0x2000092
_0x2000091:
	RJMP _0x2000090
_0x2000092:
	SBRS R16,7
	RJMP _0x2000093
	SBRS R16,2
	RJMP _0x2000094
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2000095
_0x2000094:
	LDI  R18,LOW(48)
_0x2000095:
	RJMP _0x2000096
_0x2000093:
	LDI  R18,LOW(32)
_0x2000096:
	CALL SUBOPT_0xAE
	SUBI R21,LOW(1)
	RJMP _0x200008E
_0x2000090:
_0x200008D:
_0x2000097:
	CP   R17,R20
	BRSH _0x2000099
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200009A
	CALL SUBOPT_0xB9
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x200009A:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0xB1
	CPI  R21,0
	BREQ _0x200009C
	SUBI R21,LOW(1)
_0x200009C:
	SUBI R20,LOW(1)
	RJMP _0x2000097
_0x2000099:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009D
_0x200009E:
	CPI  R19,0
	BREQ _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A2
_0x20000A1:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A2:
	CALL SUBOPT_0xAE
	CPI  R21,0
	BREQ _0x20000A3
	SUBI R21,LOW(1)
_0x20000A3:
	SUBI R19,LOW(1)
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x20000A4
_0x200009D:
_0x20000A6:
	CALL SUBOPT_0xBA
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A8
	SBRS R16,3
	RJMP _0x20000A9
	SUBI R18,-LOW(55)
	RJMP _0x20000AA
_0x20000A9:
	SUBI R18,-LOW(87)
_0x20000AA:
	RJMP _0x20000AB
_0x20000A8:
	SUBI R18,-LOW(48)
_0x20000AB:
	SBRC R16,4
	RJMP _0x20000AD
	CPI  R18,49
	BRSH _0x20000AF
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AE
_0x20000AF:
	RJMP _0x20000B1
_0x20000AE:
	CP   R20,R19
	BRSH _0x200011C
	CP   R21,R19
	BRLO _0x20000B4
	SBRS R16,0
	RJMP _0x20000B5
_0x20000B4:
	RJMP _0x20000B3
_0x20000B5:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B6
_0x200011C:
	LDI  R18,LOW(48)
_0x20000B1:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B7
	CALL SUBOPT_0xB9
	BREQ _0x20000B8
	SUBI R21,LOW(1)
_0x20000B8:
_0x20000B7:
_0x20000B6:
_0x20000AD:
	CALL SUBOPT_0xAE
	CPI  R21,0
	BREQ _0x20000B9
	SUBI R21,LOW(1)
_0x20000B9:
_0x20000B3:
	SUBI R19,LOW(1)
	CALL SUBOPT_0xBA
	CALL __MODD21U
	CALL SUBOPT_0xB3
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0xB8
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A7
	RJMP _0x20000A6
_0x20000A7:
_0x20000A4:
	SBRS R16,0
	RJMP _0x20000BA
_0x20000BB:
	CPI  R21,0
	BREQ _0x20000BD
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xB1
	RJMP _0x20000BB
_0x20000BD:
_0x20000BA:
_0x20000BE:
_0x200005A:
_0x200011A:
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
; .FEND
_printf:
; .FSTART _printf
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
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
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
; .FEND
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x9F
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
	CALL SUBOPT_0xBB
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20A0007
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0xBB
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20A0007
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xBD
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
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xA8
	CALL SUBOPT_0xBF
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0xC0
	CALL __ADDF12
	CALL SUBOPT_0xBC
	LDI  R17,LOW(0)
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xBF
_0x2020014:
	CALL SUBOPT_0xC0
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xBF
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0xBB
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x20A0007
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0xBD
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xA8
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x4A
	CALL _floor
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xC0
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xBD
	CALL SUBOPT_0xAB
	LDI  R31,0
	CALL SUBOPT_0xBE
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x4B
	CALL SUBOPT_0xBC
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0006
	CALL SUBOPT_0xBD
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xBC
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xBD
	CALL SUBOPT_0xAB
	LDI  R31,0
	CALL SUBOPT_0xC2
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x4B
	CALL SUBOPT_0xBC
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
; .FEND

	.DSEG

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
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
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0xC3
	CALL _ftrunc
	CALL SUBOPT_0xC4
    brne __floor1
__floor0:
	CALL SUBOPT_0xC5
	RJMP _0x20A0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0xC6
	RJMP _0x20A0004
; .FEND
_sin:
; .FSTART _sin
	CALL SUBOPT_0xC7
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0xC8
	RCALL _floor
	CALL SUBOPT_0xC9
	CALL SUBOPT_0x4B
	CALL SUBOPT_0xC8
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040017
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xCB
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0xC9
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040018
	CALL SUBOPT_0xC9
	__GETD1N 0x3F000000
	CALL SUBOPT_0xCB
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0xCC
_0x2040019:
	CALL SUBOPT_0xCD
	__PUTD1S 1
	CALL SUBOPT_0xCE
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x4B
	CALL SUBOPT_0xCF
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0xC9
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xCE
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0xCF
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20A0005
; .FEND
_cos:
; .FSTART _cos
	CALL SUBOPT_0xC3
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	RJMP _0x20A0002
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC5
	__GETD2N 0x40CBD065
	CALL SUBOPT_0xD0
	CALL SUBOPT_0xAC
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC5
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xD0
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0xC3
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0xD1
	RCALL _xatan
	RJMP _0x20A0002
_0x2040020:
	CALL SUBOPT_0xD1
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xD2
	RJMP _0x20A0003
_0x2040021:
	CALL SUBOPT_0xC6
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC6
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xD2
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20A0002
; .FEND
_asin:
; .FSTART _asin
	CALL SUBOPT_0xC7
	CALL SUBOPT_0xD3
	BRLO _0x2040023
	CALL SUBOPT_0xC9
	CALL SUBOPT_0xC1
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x2040023
	RJMP _0x2040022
_0x2040023:
	CALL SUBOPT_0xD4
	RJMP _0x20A0005
_0x2040022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2040025
	CALL SUBOPT_0xCC
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0xCD
	__GETD2N 0x3F800000
	CALL SUBOPT_0x4B
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0xC9
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040026
	CALL SUBOPT_0xCA
	__GETD2S 1
	CALL SUBOPT_0xD5
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x4B
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0xCE
	CALL SUBOPT_0xC9
	CALL SUBOPT_0xD5
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0xCE
	CALL __ANEGF1
	RJMP _0x20A0005
_0x2040028:
	CALL SUBOPT_0xCE
_0x20A0005:
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
_acos:
; .FSTART _acos
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xD3
	BRLO _0x204002A
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xC1
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x204002A
	RJMP _0x2040029
_0x204002A:
	CALL SUBOPT_0xD4
	RJMP _0x20A0002
_0x2040029:
	CALL SUBOPT_0xD1
	RCALL _asin
_0x20A0003:
	__GETD2N 0x3FC90FDB
	CALL __SWAPD12
_0x20A0004:
	CALL __SUBF12
_0x20A0002:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0xA9
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	CALL SUBOPT_0xD4
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
	CALL SUBOPT_0xA9
	__GETD2S 8
	CALL __DIVF21
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xA7
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0xD1
	RCALL _yatan
	RJMP _0x20A0001
_0x2040031:
	CALL SUBOPT_0xD6
	CALL __ANEGF1
	RJMP _0x20A0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0xD6
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x4B
	RJMP _0x20A0001
_0x2040032:
	CALL SUBOPT_0xD1
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20A0001:
	ADIW R28,12
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
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
; .FEND
_isspace:
; .FSTART _isspace
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
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
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
; .FEND
_strlen:
; .FSTART _strlen
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
; .FEND
_strlenf:
; .FSTART _strlenf
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
; .FEND

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
_kiper:
	.BYTE 0x2
_cariBola:
	.BYTE 0x2
_jalan:
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
_DataMasukR:
	.BYTE 0xA
_CountRxR:
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
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1:
	LDS  R26,_counterDelay
	LDS  R27,_counterDelay+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R26,_L1
	LDS  R27,_L1+1
	LDS  R24,_L1+2
	LDS  R25,_L1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDS  R30,_L2
	LDS  R31,_L2+1
	LDS  R22,_L2+2
	LDS  R23,_L2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R26,_L2
	LDS  R27,_L2+1
	LDS  R24,_L2+2
	LDS  R25,_L2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	LDS  R26,_L3
	LDS  R27,_L3+1
	LDS  R24,_L3+2
	LDS  R25,_L3+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R26,_L4
	LDS  R27,_L4+1
	LDS  R24,_L4+2
	LDS  R25,_L4+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _countNo,R30
	STS  _countNo+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDS  R26,_countNo
	LDS  R27,_countNo+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0xA:
	LDS  R30,_countNo
	LDS  R31,_countNo+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_Xset)
	LDI  R27,HIGH(_Xset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R26,_initPositionX
	LDS  R27,_initPositionX+1
	LDS  R24,_initPositionX+2
	LDS  R25,_initPositionX+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __PUTDZ20
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_Yset)
	LDI  R27,HIGH(_Yset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDS  R26,_initPositionY
	LDS  R27,_initPositionY+1
	LDS  R24,_initPositionY+2
	LDS  R25,_initPositionY+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_Zset)
	LDI  R27,HIGH(_Zset)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R26,_initPositionZ
	LDS  R27,_initPositionZ+1
	LDS  R24,_initPositionZ+2
	LDS  R25,_initPositionZ+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x12:
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_countNo)
	LDI  R27,HIGH(_countNo)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x14:
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
	RCALL SUBOPT_0x12
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0x12
	__POINTW1MN _Z,4
	__GETD2N 0x0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x16:
	LDS  R26,_DataMasuk
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(180)
	SBCI R31,HIGH(180)
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	STS  _miringDepan,R30
	STS  _miringDepan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x17:
	__GETB2MN _DataMasuk,1
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(180)
	SBCI R31,HIGH(180)
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	STS  _miringSamping,R30
	STS  _miringSamping+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	__GETB2MN _DataMasuk,2
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	STS  _kompas,R30
	STS  _kompas+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x19:
	ADD  R30,R26
	ADC  R31,R27
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x1A:
	SUBI R30,LOW(-59536)
	SBCI R31,HIGH(-59536)
	MOV  R30,R31
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(6000)
	LDI  R27,HIGH(6000)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1D:
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
SUBOPT_0x1E:
	ADD  R30,R26
	LSL  R30
	LDI  R26,LOW(112)
	CALL __SWAPB12
	SUB  R30,R26
	SUBI R30,-LOW(144)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1F:
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
SUBOPT_0x20:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	MOV  R30,R3
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDS  R30,_Timeslot2
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  152,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x23:
	ADD  R30,R26
	LSL  R30
	SUBI R30,-LOW(144)
	STS  154,R30
	LDI  R30,LOW(232)
	STS  149,R30
	LDI  R30,LOW(144)
	STS  148,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETW1MN _servo,26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETW1MN _servo,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x26:
	__GETW1MN _servo,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	__GETW1MN _servo,38
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x2A:
	LDS  R26,_Ball
	LDS  R27,_Ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x2C:
	LDS  R26,_VX
	LDS  R27,_VX+1
	LDS  R24,_VX+2
	LDS  R25,_VX+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDS  R26,_VY
	LDS  R27,_VY+1
	LDS  R24,_VY+2
	LDS  R25,_VY+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDS  R26,_W
	LDS  R27,_W+1
	LDS  R24,_W+2
	LDS  R25,_W+3
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDS  R30,_langkahMax
	LDS  R31,_langkahMax+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0xA
	LDI  R26,LOW(_Xerror)
	LDI  R27,HIGH(_Xerror)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0xA
	LDI  R26,LOW(_X)
	LDI  R27,HIGH(_X)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x32:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x33:
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x2F
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	CALL __PUTDP1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x35:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	CALL __LSLW2
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0xA
	LDI  R26,LOW(_servoSet)
	LDI  R27,HIGH(_servoSet)
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	LDS  R30,_I
	LDS  R31,_I+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	MOVW R26,R30
	MOVW R24,R22
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDS  R26,_bi
	LDS  R27,_bi+1
	LDS  R24,_bi+2
	LDS  R25,_bi+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDS  R30,_ai
	LDS  R31,_ai+1
	LDS  R22,_ai+2
	LDS  R23,_ai+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	CALL __PUTDP1
	RCALL SUBOPT_0x38
	LDI  R26,LOW(_A3)
	LDI  R27,HIGH(_A3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDS  R26,_L2Kuadrat
	LDS  R27,_L2Kuadrat+1
	LDS  R24,_L2Kuadrat+2
	LDS  R25,_L2Kuadrat+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x4
	__GETD2N 0x40000000
	CALL __MULF12
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _acos

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	CALL __ADDF12
	CALL __ANEGF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x42:
	__GETD2N 0x42B40000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x43:
	LDS  R30,_rad
	LDS  R31,_rad+1
	LDS  R22,_rad+2
	LDS  R23,_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x44:
	CALL __MULF12
	RCALL SUBOPT_0x42
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__PUTD1MN _sudutSet,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	__GETD2N 0x40A00000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x47:
	CALL __MULF12
	__GETD2N 0x43340000
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	__GETD1MN _sudutSet,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	LDS  R26,_rad
	LDS  R27,_rad+1
	LDS  R24,_rad+2
	LDS  R25,_rad+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4B:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	__PUTD1MN _sudutSet,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4D:
	LDS  R26,_rad
	LDS  R27,_rad+1
	LDS  R24,_rad+2
	LDS  R25,_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	__GETD1MN _sudutSet,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(0)
	STS  _cariBola,R30
	STS  _cariBola+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x50:
	CALL _nek_ambruk
	__GETW2MN _servo,24
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x52:
	__POINTW1FN _0x0,49
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	CALL __CWD1
	CALL __PUTPARD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x53:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x54:
	LDS  R30,_hitungNgawur
	LDS  R31,_hitungNgawur+1
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	__PUTW1MN _servo,26
	__GETW2MN _servo,26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _kiper,R30
	STS  _kiper+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	__POINTW1FN _0x0,75
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	CALL _nek_ambruk
	__GETW2MN _servo,30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	__PUTW1MN _servo,32
	__GETW2MN _servo,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5C:
	CALL _nek_ambruk
	__GETW2MN _servo,38
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5D:
	__POINTW1MN _servo,38
	RJMP SUBOPT_0x51

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5E:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_miringDepan
	LDS  R31,_miringDepan+1
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	__PUTW1MN _servo,36
	__GETW2MN _servo,36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cariBola,R30
	STS  _cariBola+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	STS  _mvx,R30
	STS  _mvx+1,R31
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x63:
	STS  _mvy,R30
	STS  _mvy+1,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _state,R30
	STS  _state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x64:
	LDS  R26,_pos_x
	LDS  R27,_pos_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	LDS  R26,_mvx
	LDS  R27,_mvx+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x66:
	LDS  R30,_Ball
	LDS  R31,_Ball+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x67:
	LDS  R30,_delayNgawur
	LDS  R31,_delayNgawur+1
	STS  _hitungNgawur,R30
	STS  _hitungNgawur+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x68:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _state,R30
	STS  _state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	STS  _state,R30
	STS  _state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6A:
	CALL _nek_ambruk
	CALL _rotasi_kiri
	CALL _pid_servo
	RCALL SUBOPT_0x2A
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6B:
	__GETW2MN _servo,38
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _jalan,R30
	STS  _jalan+1,R31
	RJMP SUBOPT_0x5D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	STS  _jalan,R30
	STS  _jalan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x6D
	RJMP SUBOPT_0x5D

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x6F:
	__POINTW1MN _servo,28
	LDI  R26,LOW(1750)
	LDI  R27,HIGH(1750)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,26
	LDI  R26,LOW(570)
	LDI  R27,HIGH(570)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,24
	LDI  R26,LOW(2500)
	LDI  R27,HIGH(2500)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x70:
	__POINTW1MN _servo,34
	LDI  R26,LOW(1350)
	LDI  R27,HIGH(1350)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,32
	LDI  R26,LOW(2490)
	LDI  R27,HIGH(2490)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,30
	LDI  R26,LOW(450)
	LDI  R27,HIGH(450)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,2
	LDI  R26,LOW(65436)
	LDI  R27,HIGH(65436)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,4
	LDI  R26,LOW(310)
	LDI  R27,HIGH(310)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,6
	LDI  R26,LOW(65286)
	LDI  R27,HIGH(65286)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,14
	LDI  R26,LOW(65436)
	LDI  R27,HIGH(65436)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,16
	LDI  R26,LOW(310)
	LDI  R27,HIGH(310)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,18
	LDI  R26,LOW(65286)
	LDI  R27,HIGH(65286)
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R30,LOW(0)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x71:
	__GETD1N 0x41200000
	STS  _VY,R30
	STS  _VY+1,R31
	STS  _VY+2,R22
	STS  _VY+3,R23
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:165 WORDS
SUBOPT_0x72:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
	CLR  R0
	CP   R0,R13
	CPC  R0,R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	STS  _counterDelay,R30
	STS  _counterDelay+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _speed,R30
	STS  _speed+1,R31
	LDS  R26,_counterTG
	LDS  R27,_counterTG+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x76:
	LDI  R30,LOW(0)
	STS  _counterTG,R30
	STS  _counterTG+1,R30
	JMP  _taskGerakan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(0)
	STS  _X,R30
	STS  _X+1,R30
	STS  _X+2,R30
	STS  _X+3,R30
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	__GETD1N 0xC1F00000
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
	__POINTW1MN _X,4
	__GETD2N 0x0
	RCALL SUBOPT_0x12
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0x12
	__POINTW1MN _Z,4
	__GETD2N 0xC1F00000
	RCALL SUBOPT_0x12
	JMP  _InputXYZ

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x78:
	__POINTW1MN _servoInitError,2
	LDI  R26,LOW(65436)
	LDI  R27,HIGH(65436)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,4
	LDI  R26,LOW(310)
	LDI  R27,HIGH(310)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	LDI  R26,LOW(65286)
	LDI  R27,HIGH(65286)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7A:
	__POINTW1MN _servoInitError,14
	LDI  R26,LOW(65436)
	LDI  R27,HIGH(65436)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,16
	LDI  R26,LOW(310)
	LDI  R27,HIGH(310)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7B:
	STS  _VY,R30
	STS  _VY+1,R31
	STS  _VY+2,R22
	STS  _VY+3,R23
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:44 WORDS
SUBOPT_0x7C:
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
	RCALL SUBOPT_0x12
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0x12
	__POINTW1MN _Z,4
	__GETD2N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7D:
	__GETD1N 0x41600000
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x7E:
	LDI  R30,LOW(0)
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7F:
	__GETD2N 0xC1600000
	RCALL SUBOPT_0x12
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0x12
	__POINTW1MN _Z,4
	__GETD2N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x80:
	STS  _Y,R30
	STS  _Y+1,R31
	STS  _Y+2,R22
	STS  _Y+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x81:
	STS  _Z,R30
	STS  _Z+1,R31
	STS  _Z+2,R22
	STS  _Z+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x82:
	__GETD1N 0xC1600000
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RJMP SUBOPT_0x7E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	__GETD2N 0x41600000
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x84:
	__POINTW1MN _Y,4
	__GETD2N 0x0
	RCALL SUBOPT_0x12
	__POINTW1MN _Z,4
	__GETD2N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x85:
	LDS  R30,_VY
	LDS  R31,_VY+1
	LDS  R22,_VY+2
	LDS  R23,_VY+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	__PUTD1MN _Y,4
	__POINTW1MN _Z,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x87:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R13
	CPC  R31,R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	STS  _counterDelay,R30
	STS  _counterDelay+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x89:
	__POINTW1MN _servo,34
	LDI  R26,LOW(1350)
	LDI  R27,HIGH(1350)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,32
	LDI  R26,LOW(2490)
	LDI  R27,HIGH(2490)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servo,30
	LDI  R26,LOW(450)
	LDI  R27,HIGH(450)
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R30,LOW(0)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8A:
	__GETD1N 0x41600000
	STS  _VX,R30
	STS  _VX+1,R31
	STS  _VX+2,R22
	STS  _VX+3,R23
	__GETD1N 0x41C80000
	RJMP SUBOPT_0x7B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8B:
	LDI  R26,LOW(65296)
	LDI  R27,HIGH(65296)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:183 WORDS
SUBOPT_0x8C:
	LDS  R30,_VX
	LDS  R31,_VX+1
	LDS  R22,_VX+2
	LDS  R23,_VX+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0x8D:
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
	RJMP SUBOPT_0x8C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8E:
	RCALL SUBOPT_0x8C
	CALL __ANEGF1
	RJMP SUBOPT_0x8D

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x8F:
	__PUTD1MN _X,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x90:
	RCALL SUBOPT_0x8C
	STS  _X,R30
	STS  _X+1,R31
	STS  _X+2,R22
	STS  _X+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x91:
	LDI  R30,LOW(0)
	STS  _Y,R30
	STS  _Y+1,R30
	STS  _Y+2,R30
	STS  _Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x92:
	__POINTW1MN _servoInitError,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x93:
	RCALL SUBOPT_0x80
	__GETD1N 0xC1A00000
	RJMP SUBOPT_0x81

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x94:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x95:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x96:
	LDI  R26,LOW(65266)
	LDI  R27,HIGH(65266)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(0)
	STS  _servoInitError,R30
	STS  _servoInitError+1,R30
	__POINTW1MN _servoInitError,6
	RJMP SUBOPT_0x96

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x98:
	__POINTW1MN _servoInitError,8
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x99:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _servoInitError,18
	LDI  R26,LOW(65266)
	LDI  R27,HIGH(65266)
	RJMP SUBOPT_0x94

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9A:
	__GETD1N 0x41700000
	RCALL SUBOPT_0x81
	RCALL SUBOPT_0x8C
	RJMP SUBOPT_0x8F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9B:
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	STS  _servoInitError,R30
	STS  _servoInitError+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9C:
	__POINTW1MN _servoInitError,8
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	RJMP SUBOPT_0x94

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9D:
	LDS  R30,_VZ
	LDS  R31,_VZ+1
	LDS  R22,_VZ+2
	LDS  R23,_VZ+3
	RCALL SUBOPT_0x81
	RCALL SUBOPT_0x8C
	RJMP SUBOPT_0x8F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9E:
	__GETD2N 0x0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9F:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xA0:
	__GETD2S 4
	RCALL SUBOPT_0x95
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA1:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA2:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA3:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA4:
	RCALL SUBOPT_0x95
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA5:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA6:
	__GETD2N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA7:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA8:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA9:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAA:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAB:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAC:
	RCALL SUBOPT_0xA7
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xAD:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xAE:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xAF:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB0:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB1:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB2:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB3:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB4:
	RCALL SUBOPT_0xAF
	RJMP SUBOPT_0xB0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB5:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB6:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB7:
	RCALL SUBOPT_0xB2
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB8:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB9:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBA:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBB:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBC:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xBD:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBE:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBF:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC0:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC1:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC2:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC3:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC4:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC5:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC6:
	RCALL SUBOPT_0xC5
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC7:
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC8:
	__PUTD1S 5
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC9:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xCA:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCB:
	CALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCC:
	RCALL SUBOPT_0xCA
	CALL __ANEGF1
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCD:
	RCALL SUBOPT_0xCA
	RCALL SUBOPT_0xC9
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xCE:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCF:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD0:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD1:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD2:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD3:
	__GETD1N 0xBF800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD4:
	__GETD1N 0x7F7FFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD5:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD6:
	RCALL SUBOPT_0xC5
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
