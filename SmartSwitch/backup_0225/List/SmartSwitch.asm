
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _interrupt_counter=R5
	.DEF _digit_1=R4
	.DEF _digit_2=R7
	.DEF _digit_3=R6
	.DEF _digit_4=R9
	.DEF _Buttons=R8
	.DEF _LEDs=R11
	.DEF _seconds_blinking_counter=R10
	.DEF _TMP_LED=R13
	.DEF _TMP_8_bit=R12

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
	JMP  _timer1_compa_isr
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

_symbols:
	.DB  0x22,0xBE,0x13,0x16,0x8E,0x46,0x42,0x3E
	.DB  0x2,0x6,0xA,0xC2,0x63,0x92,0x43,0x4B
	.DB  0xFF,0xDF,0x43,0xDB,0xB,0xC3
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x2,0x1
	.DB  0x0,0x3,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1F
_0x4:
	.DB  0xC
_0x5:
	.DB  0x5F
_0x6:
	.DB  0x13
_0x7:
	.DB  0x6

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _date
	.DW  _0x3*2

	.DW  0x01
	.DW  _month
	.DW  _0x4*2

	.DW  0x01
	.DW  _year
	.DW  _0x5*2

	.DW  0x01
	.DW  _year_thousands
	.DW  _0x6*2

	.DW  0x01
	.DW  _menu
	.DW  _0x7*2

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : SmartSwitch
;Version : 1
;Date    : 10/18/2022
;Author  : Skrrmrchoh
;Company :
;Comments:
;Skrrmrchoh@rambler.ru
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;#define Anode_3 PORTC.4
;#define Anode_4 PORTC.6
;#define Anode_1 PORTC.3
;#define Anode_2 PORTC.5
;#define Relay_reset PORTB.4 // 0-Reset; 1-work
;
;#define Reg_165_CLK_INH PORTB.1
;#define Reg_165_CLK PORTB.2
;#define Reg_165_n_LOAD PORTB.3
;#define Reg_165_OUT PINB.0
;
;
;#define indicator_dp PORTA.1
;
;#define contact_bounce_supression_value 15
;#define Buttons_debouncing_value 5
;#define double_click_counter_value 400
;#define max_menu_value 10
;#define Keyboard_inactive_value 20
;#define Back_to_main_menu_value 2000
;#define sec_error_counter_value 255
;#define switching_relay_off_prohibited_counter_value 20000
;
;
;#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0034 #endasm
;
;eeprom char settings[16];
;/*
;Relay_number - action -
;falling edge on switch #... - rising edge on switch #... -
;falling edge on relay #... - rising edge on relay #... -
;double click on switch #... -
;time, hours - time, minutes.
;
;*/
;
;eeprom char settings_line_1[16];
;eeprom char settings_line_2[16];
;eeprom char settings_line_3[16];
;eeprom char settings_line_4[16];
;eeprom char settings_line_5[16];
;eeprom char settings_line_6[16];
;eeprom char settings_line_7[16];
;eeprom char settings_line_8[16];
;eeprom char settings_line_9[16];
;eeprom char settings_line_10[16];
;eeprom char settings_line_11[16];
;eeprom char settings_line_12[16];
;eeprom char settings_line_13[16];
;eeprom char settings_line_14[16];
;eeprom char settings_line_15[16];
;eeprom char settings_line_16[16];
;eeprom char settings_line_17[16];
;eeprom char settings_line_18[16];
;eeprom char settings_line_19[16];
;eeprom char settings_line_20[16];
;eeprom char settings_line_21[16];
;eeprom char settings_line_22[16];
;eeprom char settings_line_23[16];
;eeprom char settings_line_24[16];
;eeprom char settings_line_25[16];
;eeprom char settings_line_26[16];
;eeprom char settings_line_27[16];
;eeprom char settings_line_28[16];
;eeprom char settings_line_29[16];
;eeprom char settings_line_30[16];
;eeprom char settings_line_31[16];
;eeprom char settings_line_32[16];
;
;
;unsigned char interrupt_counter=0;
;unsigned char digit_1=0, digit_2=1, digit_3=2, digit_4=3;
;unsigned char Buttons=0; // 16, 1, 2, 4, 8
;unsigned char LEDs=0; // 16, 1, 2, 4, 8
;
;bit seconds_blinking = 0;
;unsigned char seconds_blinking_counter=0;
;
;unsigned char TMP_LED=0, TMP_8_bit=0, TMP_1_8_bit=0;
;unsigned char relay_high=0, relay_low=0;
;unsigned int TMP_1_16_bit=0, TMP_2_16_bit=0;
;// unsigned int TMP_relay_16_bit=0;
;unsigned char reg_165_1=0, reg_165_2=0, reg_165_3=0;
;
;unsigned char sec=0, minute=0, hour=0, sec_oldstate=0;
;unsigned char day=0, date=31, month=12, year=95, year_thousands=19;

	.DSEG
;unsigned char calibration=0;
;
;unsigned char switches_contact_bounce_supression[24];
;unsigned char switches_state[24], switches_old_state[24];
;unsigned char relays_state[16];
;unsigned char switches_double_click[24];
;unsigned char timers[16];
;unsigned int double_click_counter[24];
;
;unsigned int relays_16=0, relays_16_oldstate;
;
;// unsigned int TMP_counter=0;
;
;unsigned char menu=6;// must be <16
;unsigned char Buttons_debouncing_counter=0, Keyboard_inactive=0;
;unsigned int Back_to_main_menu_counter=0;
;unsigned int error_blinking_counter=0;
;unsigned char error=0; //must be <99
;//error bit 0 - RTC error
;unsigned char sec_error_counter=0;
;bit switching_relay_off_prohibited=0;
;unsigned int switching_relay_off_prohibited_counter=0;
;unsigned int OFF_timer=0;   // see "settings[2]" in "registers.h" and "buttons_functions.h"
;bit preventing_multiple_inversions=0;
;
;/*
; 80_
;10/_/40 20
;04/_/01
;  08 .02
;*/
;flash char symbols[] =
;{
;0x22,                   //0
;0xBE,                   //1
;0x13,                   //2
;0x16,                   //3
;0x8E,                   //4
;0x46,                   //5
;0x42,                   //6
;0x3E,                   //7
;0x02,                   //8
;0x06,                   //9
;0x0A,                   //A
;0xC2,                   //B
;0x63,                   //C
;0x92,                   //D
;0x43,                   //E
;0x4B,                   //F
;0xFF,                   //Space
;0xDF,                   // -
;0x43,                   // E
;0xDB,                   // r
;0x0B,                   // P
;0xC3                    //t
;};
;
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <eeprom.h>
;#include <bcd.h>
;#include <i2c.h>
;#include <stdio.h>
;#include <spi.h>
;#include <interrupts.h>

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R26,LOW(_error_blinking_counter)
	LDI  R27,HIGH(_error_blinking_counter)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	INC  R10
	LDS  R26,_switching_relay_off_prohibited_counter
	LDS  R27,_switching_relay_off_prohibited_counter+1
	CALL __CPW02
	BRSH _0x8
	LDI  R26,LOW(_switching_relay_off_prohibited_counter)
	LDI  R27,HIGH(_switching_relay_off_prohibited_counter)
	CALL SUBOPT_0x0
	RJMP _0x9
_0x8:
	CLT
	BLD  R2,1
_0x9:
	CALL SUBOPT_0x1
	CALL __CPW02
	BRSH _0xA
	LDI  R26,LOW(_OFF_timer)
	LDI  R27,HIGH(_OFF_timer)
	CALL SUBOPT_0x0
_0xA:
	LDS  R26,_sec_error_counter
	CPI  R26,LOW(0x1)
	BRLO _0xB
	LDS  R30,_sec_error_counter
	SUBI R30,LOW(1)
	STS  _sec_error_counter,R30
	RJMP _0xC
_0xB:
	LDS  R30,_error
	ORI  R30,1
	STS  _error,R30
_0xC:
	TST  R8
	BRNE _0xD
	LDS  R26,_Back_to_main_menu_counter
	LDS  R27,_Back_to_main_menu_counter+1
	CALL __CPW02
	BRSH _0xE
	LDI  R26,LOW(_Back_to_main_menu_counter)
	LDI  R27,HIGH(_Back_to_main_menu_counter)
	CALL SUBOPT_0x0
	RJMP _0xF
_0xE:
	LDI  R30,LOW(0)
	STS  _menu,R30
_0xF:
	LDS  R26,_Keyboard_inactive
	CPI  R26,LOW(0x1)
	BRLO _0x10
	LDS  R30,_Keyboard_inactive
	SUBI R30,LOW(1)
	STS  _Keyboard_inactive,R30
_0x10:
_0xD:
	LDI  R30,LOW(199)
	CP   R30,R10
	BRSH _0x11
	CLR  R10
_0x11:
	LDS  R26,_error_blinking_counter
	LDS  R27,_error_blinking_counter+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLO _0x12
	LDI  R30,LOW(0)
	STS  _error_blinking_counter,R30
	STS  _error_blinking_counter+1,R30
_0x12:
	LDI  R30,LOW(6)
	OUT  0x11,R30
	LDI  R30,LOW(248)
	OUT  0x12,R30
	IN   R8,16
	LSR  R8
	LSR  R8
	LSR  R8
	LDI  R30,LOW(255)
	SUB  R30,R8
	MOV  R8,R30
	LDI  R30,LOW(31)
	AND  R8,R30
	LDI  R30,LOW(254)
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	MOV  R13,R11
	LDI  R30,LOW(255)
	SUB  R30,R13
	MOV  R13,R30
	LSL  R13
	LSL  R13
	LSL  R13
	IN   R30,0x12
	AND  R30,R13
	OUT  0x12,R30
	MOV  R30,R5
	LDI  R31,0
	SBIW R30,0
	BRNE _0x16
	CBI  0x15,6
	SBI  0x15,3
	MOV  R30,R4
	RJMP _0x142
_0x16:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1B
	CBI  0x15,3
	SBI  0x15,5
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_symbols*2)
	SBCI R31,HIGH(-_symbols*2)
	LPM  R0,Z
	OUT  0x1B,R0
	LDI  R30,LOW(100)
	CP   R10,R30
	BRSH _0x21
	SBRC R2,0
	RJMP _0x22
_0x21:
	RJMP _0x20
_0x22:
	CBI  0x1B,1
	RJMP _0x25
_0x20:
	SBI  0x1B,1
_0x25:
	RJMP _0x15
_0x1B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28
	CBI  0x15,5
	SBI  0x15,4
	MOV  R30,R6
	RJMP _0x142
_0x28:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x15
	CBI  0x15,4
	SBI  0x15,6
	MOV  R30,R9
_0x142:
	LDI  R31,0
	SUBI R30,LOW(-_symbols*2)
	SBCI R31,HIGH(-_symbols*2)
	LPM  R0,Z
	OUT  0x1B,R0
_0x15:
	INC  R5
	LDI  R30,LOW(3)
	CP   R30,R5
	BRSH _0x32
	CLR  R5
_0x32:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;#include <delay.h>
;#include <functions.h>
_get_165_reg:
; .FSTART _get_165_reg
	CBI  0x18,1
	CBI  0x18,2
	CBI  0x18,3
	__DELAY_USB 53
	SBI  0x18,3
	CBI  0x18,1
	LDI  R30,LOW(0)
	STS  _reg_165_1,R30
	STS  _reg_165_2,R30
	STS  _reg_165_3,R30
	CALL SUBOPT_0x2
;	i -> Y+0
_0x3E:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x3F
	LDS  R30,_reg_165_1
	LSL  R30
	STS  _reg_165_1,R30
	SBIS 0x16,0
	RJMP _0x40
	LDS  R30,_reg_165_1
	SUBI R30,-LOW(1)
	STS  _reg_165_1,R30
_0x40:
	CALL SUBOPT_0x3
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x3E
_0x3F:
	LDI  R30,LOW(0)
	ST   Y,R30
_0x46:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x47
	LDS  R30,_reg_165_2
	LSL  R30
	STS  _reg_165_2,R30
	SBIS 0x16,0
	RJMP _0x48
	LDS  R30,_reg_165_2
	SUBI R30,-LOW(1)
	STS  _reg_165_2,R30
_0x48:
	CALL SUBOPT_0x3
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x46
_0x47:
	LDI  R30,LOW(0)
	ST   Y,R30
_0x4E:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x4F
	LDS  R30,_reg_165_3
	LSL  R30
	STS  _reg_165_3,R30
	SBIS 0x16,0
	RJMP _0x50
	LDS  R30,_reg_165_3
	SUBI R30,-LOW(1)
	STS  _reg_165_3,R30
_0x50:
	CALL SUBOPT_0x3
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x4E
_0x4F:
	ADIW R28,1
	LDS  R12,_reg_165_1
	LDI  R30,LOW(0)
	STS  _TMP_1_8_bit,R30
	SBRS R12,0
	RJMP _0x55
	CALL SUBOPT_0x4
_0x55:
	SBRS R12,1
	RJMP _0x56
	CALL SUBOPT_0x5
_0x56:
	SBRS R12,2
	RJMP _0x57
	CALL SUBOPT_0x6
_0x57:
	SBRS R12,3
	RJMP _0x58
	CALL SUBOPT_0x7
_0x58:
	SBRS R12,4
	RJMP _0x59
	CALL SUBOPT_0x8
_0x59:
	SBRS R12,5
	RJMP _0x5A
	CALL SUBOPT_0x9
_0x5A:
	SBRS R12,6
	RJMP _0x5B
	CALL SUBOPT_0xA
_0x5B:
	SBRS R12,7
	RJMP _0x5C
	CALL SUBOPT_0xB
_0x5C:
	LDS  R30,_TMP_1_8_bit
	STS  _reg_165_1,R30
	LDS  R12,_reg_165_2
	LDI  R30,LOW(0)
	STS  _TMP_1_8_bit,R30
	SBRS R12,0
	RJMP _0x5D
	CALL SUBOPT_0x4
_0x5D:
	SBRS R12,1
	RJMP _0x5E
	CALL SUBOPT_0x5
_0x5E:
	SBRS R12,2
	RJMP _0x5F
	CALL SUBOPT_0x6
_0x5F:
	SBRS R12,3
	RJMP _0x60
	CALL SUBOPT_0x7
_0x60:
	SBRS R12,4
	RJMP _0x61
	CALL SUBOPT_0x8
_0x61:
	SBRS R12,5
	RJMP _0x62
	CALL SUBOPT_0x9
_0x62:
	SBRS R12,6
	RJMP _0x63
	CALL SUBOPT_0xA
_0x63:
	SBRS R12,7
	RJMP _0x64
	CALL SUBOPT_0xB
_0x64:
	LDS  R30,_TMP_1_8_bit
	STS  _reg_165_2,R30
	LDS  R12,_reg_165_3
	LDI  R30,LOW(0)
	STS  _TMP_1_8_bit,R30
	SBRS R12,0
	RJMP _0x65
	CALL SUBOPT_0x4
_0x65:
	SBRS R12,1
	RJMP _0x66
	CALL SUBOPT_0x5
_0x66:
	SBRS R12,2
	RJMP _0x67
	CALL SUBOPT_0x6
_0x67:
	SBRS R12,3
	RJMP _0x68
	CALL SUBOPT_0x7
_0x68:
	SBRS R12,4
	RJMP _0x69
	CALL SUBOPT_0x8
_0x69:
	SBRS R12,5
	RJMP _0x6A
	CALL SUBOPT_0x9
_0x6A:
	SBRS R12,6
	RJMP _0x6B
	CALL SUBOPT_0xA
_0x6B:
	SBRS R12,7
	RJMP _0x6C
	CALL SUBOPT_0xB
_0x6C:
	LDS  R30,_TMP_1_8_bit
	STS  _reg_165_3,R30
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x6D
	LDS  R30,_reg_165_1
	COM  R30
	STS  _reg_165_1,R30
	LDS  R30,_reg_165_2
	COM  R30
	STS  _reg_165_2,R30
	LDS  R30,_reg_165_3
	COM  R30
	STS  _reg_165_3,R30
_0x6D:
	RET
; .FEND
_contact_bounce_supression:
; .FSTART _contact_bounce_supression
	CALL SUBOPT_0x2
;	i -> Y+0
_0x6F:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x70
	CALL SUBOPT_0xC
	LDS  R26,_reg_165_1
	CALL SUBOPT_0xD
	BREQ _0x71
	CALL SUBOPT_0xE
	LD   R26,Z
	CPI  R26,LOW(0xF)
	BRSH _0x72
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
_0x72:
	RJMP _0x73
_0x71:
	CALL SUBOPT_0xE
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x74
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
_0x74:
_0x73:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x6F
_0x70:
	ADIW R28,1
	CALL SUBOPT_0x2
;	i -> Y+0
_0x76:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x77
	CALL SUBOPT_0xC
	LDS  R26,_reg_165_2
	CALL SUBOPT_0xD
	BREQ _0x78
	CALL SUBOPT_0x11
	LD   R26,Z
	CPI  R26,LOW(0xF)
	BRSH _0x79
	CALL SUBOPT_0x11
	CALL SUBOPT_0xF
_0x79:
	RJMP _0x7A
_0x78:
	CALL SUBOPT_0x11
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x7B
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
_0x7B:
_0x7A:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x76
_0x77:
	ADIW R28,1
	CALL SUBOPT_0x2
;	i -> Y+0
_0x7D:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x7E
	CALL SUBOPT_0xC
	LDS  R26,_reg_165_3
	CALL SUBOPT_0xD
	BREQ _0x7F
	CALL SUBOPT_0x12
	LD   R26,Z
	CPI  R26,LOW(0xF)
	BRSH _0x80
	CALL SUBOPT_0x12
	CALL SUBOPT_0xF
_0x80:
	RJMP _0x81
_0x7F:
	CALL SUBOPT_0x12
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x82
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
_0x82:
_0x81:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x7D
_0x7E:
	RJMP _0x20C0001
; .FEND
_edge_detection:
; .FSTART _edge_detection
	CALL SUBOPT_0x2
;	i -> Y+0
_0x84:
	LD   R26,Y
	CPI  R26,LOW(0x18)
	BRLO PC+2
	RJMP _0x85
	CALL SUBOPT_0x13
	LD   R26,Z
	CPI  R26,LOW(0xF)
	BRNE _0x86
	CALL SUBOPT_0x14
	LD   R26,Z
	CPI  R26,LOW(0xF)
	BRNE _0x87
	CALL SUBOPT_0x15
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x87:
	CALL SUBOPT_0x14
	LD   R30,Z
	CPI  R30,0
	BRNE _0x88
	CALL SUBOPT_0x15
	LDI  R26,LOW(2)
	CALL SUBOPT_0x16
	BRNE _0x89
	CALL SUBOPT_0x17
_0x89:
_0x88:
	CALL SUBOPT_0x18
	LD   R30,Z
	ST   X,R30
_0x86:
	CALL SUBOPT_0x13
	LD   R30,Z
	CPI  R30,0
	BRNE _0x8A
	CALL SUBOPT_0x14
	LD   R30,Z
	CPI  R30,0
	BRNE _0x8B
	CALL SUBOPT_0x15
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x8B:
	CALL SUBOPT_0x14
	LD   R26,Z
	CPI  R26,LOW(0xF)
	BRNE _0x8C
	CALL SUBOPT_0x15
	LDI  R26,LOW(1)
	CALL SUBOPT_0x16
	BRNE _0x8D
	CALL SUBOPT_0x17
_0x8D:
_0x8C:
	CALL SUBOPT_0x18
	LD   R30,Z
	ST   X,R30
_0x8A:
	CALL SUBOPT_0x19
	CALL __GETW1P
	CALL __CPW01
	BRSH _0x8E
	CALL SUBOPT_0x19
	CALL SUBOPT_0x0
	RJMP _0x8F
_0x8E:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_switches_double_click)
	SBCI R31,HIGH(-_switches_double_click)
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x8F:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x84
_0x85:
	RJMP _0x20C0001
; .FEND
_relays_edge_detection:
; .FSTART _relays_edge_detection
	SBIW R28,3
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	STD  Y+2,R30
;	i -> Y+2
;	k -> Y+0
	STD  Y+2,R30
_0x91:
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRSH _0x92
	LDD  R30,Y+2
	CALL SUBOPT_0x1B
	ST   Y,R30
	STD  Y+1,R31
	LDS  R30,_relays_16_oldstate
	LDS  R31,_relays_16_oldstate+1
	CALL SUBOPT_0x1C
	BREQ _0x93
	CALL SUBOPT_0x1D
	BREQ _0x94
	CALL SUBOPT_0x1E
	LDI  R26,LOW(0)
	RJMP _0x143
_0x94:
	CALL SUBOPT_0x1E
	LDI  R26,LOW(1)
_0x143:
	STD  Z+0,R26
	RJMP _0x96
_0x93:
	CALL SUBOPT_0x1D
	BREQ _0x97
	CALL SUBOPT_0x1E
	LDI  R26,LOW(2)
	RJMP _0x144
_0x97:
	CALL SUBOPT_0x1E
	LDI  R26,LOW(0)
_0x144:
	STD  Z+0,R26
_0x96:
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	RJMP _0x91
_0x92:
	ADIW R28,3
	RET
; .FEND
_switches_event_check:
; .FSTART _switches_event_check
	CALL SUBOPT_0x2
;	i -> Y+0
_0x9A:
	LD   R26,Y
	CPI  R26,LOW(0x18)
	BRLO PC+2
	RJMP _0x9B
	CALL SUBOPT_0x15
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x9C
	CALL SUBOPT_0x1F
;	i -> Y+1
;	j -> Y+0
_0x9E:
	CALL SUBOPT_0x20
	BRSH PC+2
	RJMP _0x9F
	CALL SUBOPT_0x21
	ADIW R30,2
	CALL SUBOPT_0x22
	BRNE _0xA0
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x2)
	BRNE _0xA1
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0xA2
	SBRC R2,1
	RJMP _0xA3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xA3:
	RJMP _0xA4
_0xA2:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xA4:
_0xA1:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x1)
	BRNE _0xA5
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xA5:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,0
	BRNE _0xA6
	SBRC R2,1
	RJMP _0xA7
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xA7:
_0xA6:
_0xA0:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x9E
_0x9F:
	ADIW R28,1
_0x9C:
	CALL SUBOPT_0x15
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0xA8
	CALL SUBOPT_0x1F
;	i -> Y+1
;	j -> Y+0
_0xAA:
	CALL SUBOPT_0x20
	BRSH PC+2
	RJMP _0xAB
	CALL SUBOPT_0x21
	ADIW R30,3
	CALL SUBOPT_0x22
	BRNE _0xAC
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x2)
	BRNE _0xAD
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0xAE
	SBRC R2,1
	RJMP _0xAF
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xAF:
	RJMP _0xB0
_0xAE:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xB0:
_0xAD:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x1)
	BRNE _0xB1
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xB1:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,0
	BRNE _0xB2
	SBRC R2,1
	RJMP _0xB3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xB3:
_0xB2:
_0xAC:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xAA
_0xAB:
	ADIW R28,1
_0xA8:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x9A
_0x9B:
	RJMP _0x20C0001
; .FEND
_relays_event_check:
; .FSTART _relays_event_check
	CALL SUBOPT_0x2
;	i -> Y+0
_0xB5:
	LD   R26,Y
	CPI  R26,LOW(0x10)
	BRLO PC+2
	RJMP _0xB6
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_relays_state)
	SBCI R31,HIGH(-_relays_state)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xB7
	CALL SUBOPT_0x1F
;	i -> Y+1
;	j -> Y+0
_0xB9:
	CALL SUBOPT_0x20
	BRSH PC+2
	RJMP _0xBA
	CALL SUBOPT_0x21
	ADIW R30,4
	CALL SUBOPT_0x22
	BRNE _0xBB
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x2)
	BRNE _0xBC
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0xBD
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	RJMP _0x145
_0xBD:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x29
_0x145:
	STS  _relays_16,R30
	STS  _relays_16+1,R31
_0xBC:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x1)
	BRNE _0xBF
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xBF:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,0
	BRNE _0xC0
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xC0:
_0xBB:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xB9
_0xBA:
	ADIW R28,1
_0xB7:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_relays_state)
	SBCI R31,HIGH(-_relays_state)
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0xC1
	CALL SUBOPT_0x1F
;	i -> Y+1
;	j -> Y+0
_0xC3:
	CALL SUBOPT_0x20
	BRSH PC+2
	RJMP _0xC4
	CALL SUBOPT_0x21
	ADIW R30,5
	CALL SUBOPT_0x22
	BRNE _0xC5
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x2)
	BRNE _0xC6
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0xC7
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	RJMP _0x146
_0xC7:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x29
_0x146:
	STS  _relays_16,R30
	STS  _relays_16+1,R31
_0xC6:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x1)
	BRNE _0xC9
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xC9:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,0
	BRNE _0xCA
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xCA:
_0xC5:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xC3
_0xC4:
	ADIW R28,1
_0xC1:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xB5
_0xB6:
_0x20C0001:
	ADIW R28,1
	RET
; .FEND
_time_check:
; .FSTART _time_check
	LDS  R30,_sec
	CPI  R30,0
	BREQ PC+2
	RJMP _0xCB
	SBRC R2,2
	RJMP _0xCC
	SET
	BLD  R2,2
	CALL SUBOPT_0x1F
;	j -> Y+0
_0xCE:
	CALL SUBOPT_0x20
	BRSH PC+2
	RJMP _0xCF
	CALL SUBOPT_0x21
	ADIW R30,7
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R26,R30
	LDS  R30,_hour
	CP   R30,R26
	BREQ PC+2
	RJMP _0xD0
	CALL SUBOPT_0x21
	ADIW R30,8
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R26,R30
	LDS  R30,_minute
	CP   R30,R26
	BRNE _0xD1
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x2)
	BRNE _0xD2
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0xD3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	RJMP _0x147
_0xD3:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x29
_0x147:
	STS  _relays_16,R30
	STS  _relays_16+1,R31
_0xD2:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,LOW(0x1)
	BRNE _0xD5
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
_0xD5:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CPI  R30,0
	BRNE _0xD6
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0xD6:
_0xD1:
_0xD0:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xCE
_0xCF:
	ADIW R28,1
_0xCC:
	RJMP _0xD7
_0xCB:
	CLT
	BLD  R2,2
_0xD7:
	RET
; .FEND
;#include <registers.h>
_registers:
; .FSTART _registers
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	OUT  0x1A,R30
	LDI  R30,LOW(97)
	OUT  0x18,R30
	LDI  R30,LOW(190)
	OUT  0x17,R30
	LDI  R30,LOW(7)
	OUT  0x15,R30
	LDI  R30,LOW(248)
	OUT  0x14,R30
	LDI  R30,LOW(6)
	OUT  0x11,R30
	LDI  R30,LOW(249)
	OUT  0x12,R30
	LDI  R30,LOW(0)
	OUT  0x33,R30
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x2F,R30
	LDI  R30,LOW(10)
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x27,R30
	OUT  0x26,R30
	LDI  R30,LOW(39)
	OUT  0x2B,R30
	LDI  R30,LOW(16)
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	OUT  0x29,R30
	OUT  0x28,R30
	OUT  0x22,R30
	OUT  0x25,R30
	OUT  0x24,R30
	OUT  0x23,R30
	OUT  0x35,R30
	OUT  0x34,R30
	LDI  R30,LOW(16)
	OUT  0x39,R30
	LDI  R30,LOW(2)
	OUT  0xB,R30
	LDI  R30,LOW(24)
	OUT  0xA,R30
	LDI  R30,LOW(6)
	OUT  0x20,R30
	LDI  R30,LOW(0)
	OUT  0x20,R30
	LDI  R30,LOW(16)
	OUT  0x9,R30
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x30,R30
	OUT  0x6,R30
	LDI  R30,LOW(113)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
	OUT  0x36,R30
	CALL _i2c_init
	CALL SUBOPT_0x2A
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDS  R26,_calibration
	CALL SUBOPT_0x2B
	CALL _i2c_stop
	CALL SUBOPT_0x2C
	LDI  R30,LOW(17)
	MOV  R6,R30
	MOV  R9,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	SBIW R28,2
;	i -> Y+0
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0xD9:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,16
	BRGE _0xDA
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_timers)
	SBCI R31,HIGH(-_timers)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	CALL SUBOPT_0x2F
	RJMP _0xD9
_0xDA:
	ADIW R28,2
	LDI  R26,LOW(_settings)
	LDI  R27,HIGH(_settings)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings,1
	CALL __EEPROMWRB
	__POINTW2MN _settings,2
	CALL __EEPROMWRB
	__POINTW2MN _settings,3
	CALL __EEPROMWRB
	__POINTW2MN _settings,4
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings,5
	CALL __EEPROMWRB
	__POINTW2MN _settings,6
	CALL __EEPROMWRB
	__POINTW2MN _settings,7
	CALL __EEPROMWRB
	__POINTW2MN _settings,8
	CALL __EEPROMWRB
	__POINTW2MN _settings,9
	CALL __EEPROMWRB
	__POINTW2MN _settings,10
	CALL __EEPROMWRB
	__POINTW2MN _settings,11
	CALL __EEPROMWRB
	__POINTW2MN _settings,12
	CALL __EEPROMWRB
	__POINTW2MN _settings,13
	CALL __EEPROMWRB
	__POINTW2MN _settings,14
	CALL __EEPROMWRB
	__POINTW2MN _settings,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_1)
	LDI  R27,HIGH(_settings_line_1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,1
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,2
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,3
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,7
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,8
	LDI  R30,LOW(20)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,9
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_1,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_2)
	LDI  R27,HIGH(_settings_line_2)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,1
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,2
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,3
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_2,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_3)
	LDI  R27,HIGH(_settings_line_3)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,2
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_3,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_4)
	LDI  R27,HIGH(_settings_line_4)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,1
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,3
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_4,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_5)
	LDI  R27,HIGH(_settings_line_5)
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,2
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_5,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_6)
	LDI  R27,HIGH(_settings_line_6)
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,3
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_6,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_7)
	LDI  R27,HIGH(_settings_line_7)
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,2
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_7,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_8)
	LDI  R27,HIGH(_settings_line_8)
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,3
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_8,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_9)
	LDI  R27,HIGH(_settings_line_9)
	LDI  R30,LOW(4)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,2
	LDI  R30,LOW(4)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_9,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_10)
	LDI  R27,HIGH(_settings_line_10)
	LDI  R30,LOW(4)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,3
	LDI  R30,LOW(4)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_10,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_11)
	LDI  R27,HIGH(_settings_line_11)
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,2
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_11,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_12)
	LDI  R27,HIGH(_settings_line_12)
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,3
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_12,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_13)
	LDI  R27,HIGH(_settings_line_13)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,2
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_13,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_14)
	LDI  R27,HIGH(_settings_line_14)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,3
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_14,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_15)
	LDI  R27,HIGH(_settings_line_15)
	LDI  R30,LOW(7)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,2
	LDI  R30,LOW(7)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_15,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_16)
	LDI  R27,HIGH(_settings_line_16)
	LDI  R30,LOW(7)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,3
	LDI  R30,LOW(7)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_16,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_17)
	LDI  R27,HIGH(_settings_line_17)
	LDI  R30,LOW(8)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,2
	LDI  R30,LOW(8)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_17,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_18)
	LDI  R27,HIGH(_settings_line_18)
	LDI  R30,LOW(8)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,3
	LDI  R30,LOW(8)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_18,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_19)
	LDI  R27,HIGH(_settings_line_19)
	LDI  R30,LOW(9)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,2
	LDI  R30,LOW(9)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_19,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_20)
	LDI  R27,HIGH(_settings_line_20)
	LDI  R30,LOW(9)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,3
	LDI  R30,LOW(9)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_20,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_21)
	LDI  R27,HIGH(_settings_line_21)
	LDI  R30,LOW(10)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,2
	LDI  R30,LOW(10)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_21,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_22)
	LDI  R27,HIGH(_settings_line_22)
	LDI  R30,LOW(10)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,3
	LDI  R30,LOW(10)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_22,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_23)
	LDI  R27,HIGH(_settings_line_23)
	LDI  R30,LOW(11)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,2
	LDI  R30,LOW(11)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_23,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_24)
	LDI  R27,HIGH(_settings_line_24)
	LDI  R30,LOW(11)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,3
	LDI  R30,LOW(11)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_24,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_25)
	LDI  R27,HIGH(_settings_line_25)
	LDI  R30,LOW(12)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,2
	LDI  R30,LOW(12)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_25,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_26)
	LDI  R27,HIGH(_settings_line_26)
	LDI  R30,LOW(12)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,3
	LDI  R30,LOW(12)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_26,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_27)
	LDI  R27,HIGH(_settings_line_27)
	LDI  R30,LOW(13)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,2
	LDI  R30,LOW(13)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_27,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_28)
	LDI  R27,HIGH(_settings_line_28)
	LDI  R30,LOW(13)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,3
	LDI  R30,LOW(13)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_28,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_29)
	LDI  R27,HIGH(_settings_line_29)
	LDI  R30,LOW(14)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,2
	LDI  R30,LOW(14)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,3
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,4
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_29,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_30)
	LDI  R27,HIGH(_settings_line_30)
	LDI  R30,LOW(14)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,3
	LDI  R30,LOW(14)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,5
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_30,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_31)
	LDI  R27,HIGH(_settings_line_31)
	LDI  R30,LOW(15)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,2
	LDI  R30,LOW(15)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,3
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,4
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,5
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,6
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_31,15
	CALL __EEPROMWRB
	LDI  R26,LOW(_settings_line_32)
	LDI  R27,HIGH(_settings_line_32)
	LDI  R30,LOW(15)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,1
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,2
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,3
	LDI  R30,LOW(15)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,4
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,5
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,6
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,7
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,8
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,9
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,10
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,11
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,12
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,13
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,14
	CALL __EEPROMWRB
	__POINTW2MN _settings_line_32,15
	CALL __EEPROMWRB
	STS  _sec_error_counter,R30
	sei
	RET
; .FEND
;#include <buttons_functions.h>
_buttons_functions:
; .FSTART _buttons_functions
	TST  R8
	BRNE PC+2
	RJMP _0xDB
	LDS  R30,_Keyboard_inactive
	CPI  R30,0
	BREQ PC+2
	RJMP _0xDC
	LDI  R30,LOW(255)
	STS  _sec_error_counter,R30
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	STS  _Back_to_main_menu_counter,R30
	STS  _Back_to_main_menu_counter+1,R31
	LDS  R26,_Buttons_debouncing_counter
	CPI  R26,LOW(0x5)
	BRSH _0xDD
	LDS  R30,_Buttons_debouncing_counter
	SUBI R30,-LOW(1)
	STS  _Buttons_debouncing_counter,R30
	RJMP _0xDE
_0xDD:
	LDI  R30,LOW(16)
	CP   R30,R8
	BRNE _0xDF
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
	LDS  R26,_menu
	CPI  R26,LOW(0xA)
	BRSH _0xE0
	LDS  R30,_menu
	SUBI R30,-LOW(1)
	RJMP _0x148
_0xE0:
	LDI  R30,LOW(0)
_0x148:
	STS  _menu,R30
_0xDF:
	LDS  R30,_menu
	CPI  R30,0
	BREQ PC+2
	RJMP _0xE2
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0xE3
	CALL SUBOPT_0x30
	CPI  R30,0
	BREQ _0xE4
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
	SET
	BLD  R2,1
	CALL SUBOPT_0x30
	CPI  R30,LOW(0x6)
	BRSH _0xE5
	CALL SUBOPT_0x30
	LDI  R31,0
	LDI  R26,LOW(12000)
	LDI  R27,HIGH(12000)
	CALL __MULW12
	RJMP _0x149
_0xE5:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	LDI  R30,LOW(60000)
	LDI  R31,HIGH(60000)
_0x149:
	STS  _switching_relay_off_prohibited_counter,R30
	STS  _switching_relay_off_prohibited_counter+1,R31
_0xE4:
_0xE3:
	LDI  R30,LOW(2)
	CP   R30,R8
	BRNE _0xE7
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
	STS  _switching_relay_off_prohibited_counter,R30
	STS  _switching_relay_off_prohibited_counter+1,R30
_0xE7:
	LDI  R30,LOW(4)
	CP   R30,R8
	BRNE _0xE8
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
	LDI  R30,LOW(0)
	STS  _OFF_timer,R30
	STS  _OFF_timer+1,R30
_0xE8:
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0xE9
	CALL SUBOPT_0x31
	CPI  R30,0
	BREQ _0xEA
	CALL SUBOPT_0x31
	CPI  R30,LOW(0xFF)
	BREQ _0xEB
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x6)
	BRSH _0xEC
	CALL __EEPROMRDB
	LDI  R31,0
	LDI  R26,LOW(12000)
	LDI  R27,HIGH(12000)
	CALL __MULW12
	RJMP _0x14A
_0xEC:
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	LDI  R30,LOW(60000)
	LDI  R31,HIGH(60000)
_0x14A:
	STS  _OFF_timer,R30
	STS  _OFF_timer+1,R31
_0xEB:
	RJMP _0xEE
_0xEA:
	CALL SUBOPT_0x32
_0xEE:
_0xE9:
_0xE2:
	LDS  R26,_menu
	CPI  R26,LOW(0x4)
	BREQ PC+2
	RJMP _0xEF
	MOV  R30,R8
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xF3
	LDS  R30,_hour
	SUBI R30,-LOW(10)
	STS  _hour,R30
	LDS  R26,_hour
	CPI  R26,LOW(0x18)
	BRLO _0xF4
	LDI  R30,LOW(0)
	STS  _hour,R30
_0xF4:
	RJMP _0x14B
_0xF3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF5
	LDS  R30,_hour
	SUBI R30,-LOW(1)
	STS  _hour,R30
	LDS  R26,_hour
	CPI  R26,LOW(0x18)
	BRLO _0xF6
	LDI  R30,LOW(0)
	STS  _hour,R30
_0xF6:
	RJMP _0x14B
_0xF5:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xF7
	LDS  R30,_minute
	SUBI R30,-LOW(10)
	STS  _minute,R30
	LDS  R26,_minute
	CPI  R26,LOW(0x3C)
	BRLO _0xF8
	LDI  R30,LOW(0)
	STS  _minute,R30
_0xF8:
	RJMP _0x14B
_0xF7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xF2
	LDS  R30,_minute
	SUBI R30,-LOW(1)
	STS  _minute,R30
	LDS  R26,_minute
	CPI  R26,LOW(0x3C)
	BRLO _0xFA
	LDI  R30,LOW(0)
	STS  _minute,R30
_0xFA:
_0x14B:
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
_0xF2:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x33
	LDS  R26,_minute
	CALL SUBOPT_0x2B
	LDS  R26,_hour
	CALL SUBOPT_0x2B
	CALL _i2c_stop
_0xEF:
	LDS  R26,_menu
	CPI  R26,LOW(0x5)
	BRNE _0xFC
	LDI  R30,LOW(12)
	CP   R30,R8
	BREQ _0xFD
_0xFC:
	RJMP _0xFB
_0xFD:
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
	LDI  R30,LOW(0)
	STS  _sec,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x33
	LDS  R26,_minute
	CALL SUBOPT_0x2B
	LDS  R26,_hour
	CALL SUBOPT_0x2B
	CALL _i2c_stop
_0xFB:
_0xDE:
_0xDC:
	RJMP _0xFE
_0xDB:
	LDS  R26,_Buttons_debouncing_counter
	CPI  R26,LOW(0x1)
	BRLO _0xFF
	LDS  R30,_Buttons_debouncing_counter
	SUBI R30,LOW(1)
	STS  _Buttons_debouncing_counter,R30
_0xFF:
_0xFE:
	RET
; .FEND
;#include <indication.h>
_indication:
; .FSTART _indication
	LDS  R11,_menu
	LDS  R30,_menu
	LDI  R31,0
	SBIW R30,0
	BREQ PC+2
	RJMP _0x103
	SBRC R2,1
	RJMP _0x105
	CALL SUBOPT_0x1
	SBIW R26,0
	BREQ _0x106
_0x105:
	RJMP _0x104
_0x106:
	LDS  R30,_error
	CPI  R30,0
	BRNE _0x107
	CALL SUBOPT_0x34
	RJMP _0x14C
_0x107:
	LDS  R26,_error_blinking_counter
	LDS  R27,_error_blinking_counter+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0x109
	CALL SUBOPT_0x34
	RJMP _0x14C
_0x109:
	LDI  R30,LOW(18)
	MOV  R4,R30
	LDI  R30,LOW(19)
	MOV  R7,R30
	LDS  R26,_error
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R6,R30
	CALL SUBOPT_0x35
	LDS  R26,_error
	SUB  R26,R30
	MOV  R9,R26
_0x14C:
	CLT
	BLD  R2,0
_0x104:
	SBRS R2,1
	RJMP _0x10C
	CALL SUBOPT_0x1
	SBIW R26,0
	BREQ _0x10D
_0x10C:
	RJMP _0x10B
_0x10D:
	LDS  R26,_switching_relay_off_prohibited_counter
	LDS  R27,_switching_relay_off_prohibited_counter+1
	CALL SUBOPT_0x36
	LDI  R30,LOW(20)
	CALL SUBOPT_0x37
	MOV  R26,R22
	SUB  R26,R30
	MOV  R9,R26
	LDI  R30,LOW(50)
	CP   R10,R30
	BRLO _0x10F
	LDI  R30,LOW(99)
	CP   R30,R10
	BRSH _0x110
	LDI  R30,LOW(150)
	CP   R10,R30
	BRLO _0x10F
_0x110:
	RJMP _0x10E
_0x10F:
	LDI  R30,LOW(2)
	MOV  R11,R30
_0x10E:
_0x10B:
	CALL SUBOPT_0x1
	CALL __CPW02
	BRSH _0x113
	CALL SUBOPT_0x1
	CALL SUBOPT_0x36
	LDI  R30,LOW(21)
	CALL SUBOPT_0x37
	MOV  R26,R22
	SUB  R26,R30
	MOV  R9,R26
	LDI  R30,LOW(50)
	CP   R10,R30
	BRLO _0x115
	LDI  R30,LOW(99)
	CP   R30,R10
	BRSH _0x116
	LDI  R30,LOW(150)
	CP   R10,R30
	BRLO _0x115
_0x116:
	RJMP _0x114
_0x115:
	LDI  R30,LOW(4)
	MOV  R11,R30
_0x114:
_0x113:
	RJMP _0x102
_0x103:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x119
	SBIW R28,2
	CALL SUBOPT_0x1A
;	i -> Y+0
	LDS  R30,_reg_165_1
	CALL SUBOPT_0x38
_0x11B:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x11C
	LDS  R30,_TMP_2_16_bit
	ANDI R30,LOW(0x8)
	BREQ _0x11D
	CALL SUBOPT_0xC
	CALL SUBOPT_0x39
_0x11D:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2F
	RJMP _0x11B
_0x11C:
	ADIW R28,2
	LDS  R4,_TMP_1_16_bit
	SBIW R28,2
	CALL SUBOPT_0x1A
;	i -> Y+0
	LDS  R30,_reg_165_1
	CALL SUBOPT_0x3B
_0x11F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x120
	LDS  R30,_TMP_2_16_bit
	ANDI R30,LOW(0x8)
	BREQ _0x121
	CALL SUBOPT_0xC
	CALL SUBOPT_0x39
_0x121:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2F
	RJMP _0x11F
_0x120:
	ADIW R28,2
	LDS  R7,_TMP_1_16_bit
	RJMP _0x14D
_0x119:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x122
	LDI  R30,LOW(17)
	MOV  R4,R30
	SBIW R28,2
	CALL SUBOPT_0x1A
;	i -> Y+0
	LDS  R30,_reg_165_2
	CALL SUBOPT_0x38
_0x124:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x125
	LDS  R30,_TMP_2_16_bit
	ANDI R30,LOW(0x8)
	BREQ _0x126
	CALL SUBOPT_0xC
	CALL SUBOPT_0x39
_0x126:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2F
	RJMP _0x124
_0x125:
	ADIW R28,2
	LDS  R7,_TMP_1_16_bit
	SBIW R28,2
	CALL SUBOPT_0x1A
;	i -> Y+0
	LDS  R30,_reg_165_2
	CALL SUBOPT_0x3B
_0x128:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x129
	LDS  R30,_TMP_2_16_bit
	ANDI R30,LOW(0x8)
	BREQ _0x12A
	CALL SUBOPT_0xC
	CALL SUBOPT_0x39
_0x12A:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2F
	RJMP _0x128
_0x129:
	ADIW R28,2
	LDS  R6,_TMP_1_16_bit
	RJMP _0x14E
_0x122:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x12B
	CALL SUBOPT_0x2C
	SBIW R28,2
	CALL SUBOPT_0x1A
;	i -> Y+0
	LDS  R30,_reg_165_3
	CALL SUBOPT_0x38
_0x12D:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x12E
	LDS  R30,_TMP_2_16_bit
	ANDI R30,LOW(0x8)
	BREQ _0x12F
	CALL SUBOPT_0xC
	CALL SUBOPT_0x39
_0x12F:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2F
	RJMP _0x12D
_0x12E:
	ADIW R28,2
	LDS  R6,_TMP_1_16_bit
	SBIW R28,2
	CALL SUBOPT_0x1A
;	i -> Y+0
	LDS  R30,_reg_165_3
	CALL SUBOPT_0x3B
_0x131:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x132
	LDS  R30,_TMP_2_16_bit
	ANDI R30,LOW(0x8)
	BREQ _0x133
	CALL SUBOPT_0xC
	CALL SUBOPT_0x39
_0x133:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2F
	RJMP _0x131
_0x132:
	ADIW R28,2
	LDS  R9,_TMP_1_16_bit
	RJMP _0x14F
_0x12B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x134
	LDS  R26,_hour
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDS  R30,_minute
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOV  R4,R30
	CALL SUBOPT_0x3E
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R7,R30
	CALL SUBOPT_0x3E
	MOVW R22,R26
	MOV  R26,R7
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R6,R30
	MOV  R30,R4
	LDI  R26,LOW(232)
	MULS R30,R26
	MOVW R30,R0
	LDS  R26,_TMP_1_16_bit
	SUB  R26,R30
	MOV  R22,R26
	MOV  R30,R7
	LDI  R26,LOW(100)
	MULS R30,R26
	MOVW R30,R0
	SUB  R22,R30
	CALL SUBOPT_0x35
	MOV  R26,R22
	SUB  R26,R30
	MOV  R9,R26
	RJMP _0x102
_0x134:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x136
	LDS  R30,_sec
	LDI  R31,0
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x3D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R6,R30
	CALL SUBOPT_0x35
	LDS  R26,_TMP_1_16_bit
	SUB  R26,R30
	MOV  R9,R26
	RJMP _0x102
_0x136:
	CALL SUBOPT_0x2C
_0x14D:
	LDI  R30,LOW(17)
	MOV  R6,R30
_0x14E:
	LDI  R30,LOW(17)
	MOV  R9,R30
_0x14F:
	CLT
	BLD  R2,0
_0x102:
	RET
; .FEND
;
;
;
;void main(void)
; 0000 00BC {
_main:
; .FSTART _main
; 0000 00BD registers();
	CALL _registers
; 0000 00BE Relay_reset=1;
	SBI  0x18,4
; 0000 00BF 
; 0000 00C0 
; 0000 00C1 
; 0000 00C2 while (1)
_0x139:
; 0000 00C3       {
; 0000 00C4 
; 0000 00C5 
; 0000 00C6         i2c_start();
	CALL SUBOPT_0x2A
; 0000 00C7         i2c_write(0xd0);
; 0000 00C8         i2c_write(0);
	CALL SUBOPT_0x2D
; 0000 00C9         i2c_start();
; 0000 00CA         i2c_write(0xd1);
; 0000 00CB         sec=bcd2bin(i2c_read(1)&0x7F);
; 0000 00CC         minute=bcd2bin(i2c_read(1)&0x7F);
; 0000 00CD         hour=bcd2bin(i2c_read(1)&0x3F);
; 0000 00CE         day=bcd2bin(i2c_read(1)&0x07);
; 0000 00CF         date=bcd2bin(i2c_read(1)&0x3F);
; 0000 00D0         month=bcd2bin(i2c_read(1)&0x1F);
; 0000 00D1         year=bcd2bin(i2c_read(1)&0xFF);
; 0000 00D2         calibration=bcd2bin(i2c_read(1)&0xFF);
	CALL SUBOPT_0x2E
; 0000 00D3         year_thousands=bcd2bin(i2c_read(0)&0xFF);
; 0000 00D4         i2c_stop();
; 0000 00D5 
; 0000 00D6         if(sec != sec_oldstate)// no time error situation
	LDS  R30,_sec_oldstate
	LDS  R26,_sec
	CP   R30,R26
	BREQ _0x13C
; 0000 00D7         {
; 0000 00D8             sec_error_counter = sec_error_counter_value;
	LDI  R30,LOW(255)
	STS  _sec_error_counter,R30
; 0000 00D9         };
_0x13C:
; 0000 00DA 
; 0000 00DB         sec_oldstate = sec;
	LDS  R30,_sec
	STS  _sec_oldstate,R30
; 0000 00DC 
; 0000 00DD         get_165_reg();
	CALL _get_165_reg
; 0000 00DE         contact_bounce_supression();
	CALL _contact_bounce_supression
; 0000 00DF         edge_detection();
	CALL _edge_detection
; 0000 00E0 
; 0000 00E1         relays_16_oldstate = relays_16;
	LDS  R30,_relays_16
	LDS  R31,_relays_16+1
	STS  _relays_16_oldstate,R30
	STS  _relays_16_oldstate+1,R31
; 0000 00E2         switches_event_check();
	CALL _switches_event_check
; 0000 00E3         time_check();
	CALL _time_check
; 0000 00E4 
; 0000 00E5         relays_edge_detection();
	CALL _relays_edge_detection
; 0000 00E6         relays_event_check();
	CALL _relays_event_check
; 0000 00E7 
; 0000 00E8 
; 0000 00E9 
; 0000 00EA 
; 0000 00EB         buttons_functions();
	RCALL _buttons_functions
; 0000 00EC         if(error>99)
	LDS  R26,_error
	CPI  R26,LOW(0x64)
	BRLO _0x13D
; 0000 00ED         {
; 0000 00EE             error=99;
	LDI  R30,LOW(99)
	STS  _error,R30
; 0000 00EF         };
_0x13D:
; 0000 00F0         indication();
	RCALL _indication
; 0000 00F1 
; 0000 00F2         /*
; 0000 00F3         Call functions relays_"edge_detection" and "relays_event_check" twice or more times
; 0000 00F4         is nesessary because of possible nesting of user settings. Here's an example:
; 0000 00F5         Switch #0 turns on relay #1.
; 0000 00F6         Turning on relay #1 turns on relay #15. That situation is OK.
; 0000 00F7         Then, user can program that turning on relay #15 turns on relay #8. If you call
; 0000 00F8         the functions once, events will be as following:
; 0000 00F9         Assume that all relays turned off;
; 0000 00FA         "edge detection" detects edge on SW0;
; 0000 00FB         relays_16_oldstate = 0;
; 0000 00FC         "switches_event_check" turns relay #1 on;
; 0000 00FD         "relays_edge_detection" detects that relay #1 is on , which
; 0000 00FE         turns relay #15 by "relays_event_check". Now "relays_16" contains turned on
; 0000 00FF         relays 1 and 15. At the next iteration of "while" cycle
; 0000 0100         assigning "relays_16_oldstate = relays_16;" will be executes, and we won't be having
; 0000 0101         change on relay #15, so system won't turn on relay #8 as programmed.
; 0000 0102         Calling mentioned functions twice, or 3 times solves the issue.
; 0000 0103         */
; 0000 0104 
; 0000 0105 
; 0000 0106 
; 0000 0107         if(OFF_timer>0 && OFF_timer<30)
	CALL SUBOPT_0x1
	CALL __CPW02
	BRSH _0x13F
	CALL SUBOPT_0x1
	SBIW R26,30
	BRLO _0x140
_0x13F:
	RJMP _0x13E
_0x140:
; 0000 0108         {
; 0000 0109             relays_16_oldstate = 0;
	CALL SUBOPT_0x32
; 0000 010A             relays_16 = 0;
; 0000 010B         };
_0x13E:
; 0000 010C 
; 0000 010D         relay_high = relays_16 >> 8;
	LDS  R30,_relays_16+1
	STS  _relay_high,R30
; 0000 010E         relay_low = relays_16 & 0xFF;
	LDS  R30,_relays_16
	STS  _relay_low,R30
; 0000 010F         spi(relay_low);
	LDS  R26,_relay_low
	CALL _spi
; 0000 0110         spi(relay_high);
	LDS  R26,_relay_high
	CALL _spi
; 0000 0111 
; 0000 0112 
; 0000 0113 
; 0000 0114 
; 0000 0115 
; 0000 0116 
; 0000 0117 
; 0000 0118 
; 0000 0119 
; 0000 011A 
; 0000 011B 
; 0000 011C 
; 0000 011D 
; 0000 011E 
; 0000 011F 
; 0000 0120 
; 0000 0121       }
	RJMP _0x139
; 0000 0122 }
_0x141:
	RJMP _0x141
; .FEND

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2060003:
	SBIS 0xE,7
	RJMP _0x2060003
	IN   R30,0xF
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.ESEG
_settings:
	.BYTE 0x10
_settings_line_1:
	.BYTE 0x10
_settings_line_2:
	.BYTE 0x10
_settings_line_3:
	.BYTE 0x10
_settings_line_4:
	.BYTE 0x10
_settings_line_5:
	.BYTE 0x10
_settings_line_6:
	.BYTE 0x10
_settings_line_7:
	.BYTE 0x10
_settings_line_8:
	.BYTE 0x10
_settings_line_9:
	.BYTE 0x10
_settings_line_10:
	.BYTE 0x10
_settings_line_11:
	.BYTE 0x10
_settings_line_12:
	.BYTE 0x10
_settings_line_13:
	.BYTE 0x10
_settings_line_14:
	.BYTE 0x10
_settings_line_15:
	.BYTE 0x10
_settings_line_16:
	.BYTE 0x10
_settings_line_17:
	.BYTE 0x10
_settings_line_18:
	.BYTE 0x10
_settings_line_19:
	.BYTE 0x10
_settings_line_20:
	.BYTE 0x10
_settings_line_21:
	.BYTE 0x10
_settings_line_22:
	.BYTE 0x10
_settings_line_23:
	.BYTE 0x10
_settings_line_24:
	.BYTE 0x10
_settings_line_25:
	.BYTE 0x10
_settings_line_26:
	.BYTE 0x10
_settings_line_27:
	.BYTE 0x10
_settings_line_28:
	.BYTE 0x10
_settings_line_29:
	.BYTE 0x10
_settings_line_30:
	.BYTE 0x10
_settings_line_31:
	.BYTE 0x10
_settings_line_32:
	.BYTE 0x10

	.DSEG
_TMP_1_8_bit:
	.BYTE 0x1
_relay_high:
	.BYTE 0x1
_relay_low:
	.BYTE 0x1
_TMP_1_16_bit:
	.BYTE 0x2
_TMP_2_16_bit:
	.BYTE 0x2
_reg_165_1:
	.BYTE 0x1
_reg_165_2:
	.BYTE 0x1
_reg_165_3:
	.BYTE 0x1
_sec:
	.BYTE 0x1
_minute:
	.BYTE 0x1
_hour:
	.BYTE 0x1
_sec_oldstate:
	.BYTE 0x1
_day:
	.BYTE 0x1
_date:
	.BYTE 0x1
_month:
	.BYTE 0x1
_year:
	.BYTE 0x1
_year_thousands:
	.BYTE 0x1
_calibration:
	.BYTE 0x1
_switches_contact_bounce_supression:
	.BYTE 0x18
_switches_state:
	.BYTE 0x18
_switches_old_state:
	.BYTE 0x18
_relays_state:
	.BYTE 0x10
_switches_double_click:
	.BYTE 0x18
_timers:
	.BYTE 0x10
_double_click_counter:
	.BYTE 0x30
_relays_16:
	.BYTE 0x2
_relays_16_oldstate:
	.BYTE 0x2
_menu:
	.BYTE 0x1
_Buttons_debouncing_counter:
	.BYTE 0x1
_Keyboard_inactive:
	.BYTE 0x1
_Back_to_main_menu_counter:
	.BYTE 0x2
_error_blinking_counter:
	.BYTE 0x2
_error:
	.BYTE 0x1
_sec_error_counter:
	.BYTE 0x1
_switching_relay_off_prohibited_counter:
	.BYTE 0x2
_OFF_timer:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R26,_OFF_timer
	LDS  R27,_OFF_timer+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	__DELAY_USB 27
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(8)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(4)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(2)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(1)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(128)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(64)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(32)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R30,_TMP_1_8_bit
	SUBI R30,-LOW(16)
	STS  _TMP_1_8_bit,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xC:
	LD   R30,Y
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	LD   R30,Y
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_switches_contact_bounce_supression)
	SBCI R31,HIGH(-_switches_contact_bounce_supression)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	MOVW R26,R30
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R26,R30
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x11:
	LD   R30,Y
	LDI  R31,0
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_switches_contact_bounce_supression)
	SBCI R31,HIGH(-_switches_contact_bounce_supression)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x12:
	LD   R30,Y
	LDI  R31,0
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_switches_contact_bounce_supression)
	SBCI R31,HIGH(-_switches_contact_bounce_supression)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_switches_contact_bounce_supression)
	SBCI R31,HIGH(-_switches_contact_bounce_supression)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_switches_old_state)
	SBCI R31,HIGH(-_switches_old_state)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_switches_state)
	SBCI R31,HIGH(-_switches_state)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x16:
	STD  Z+0,R26
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_switches_double_click)
	SBCI R27,HIGH(-_switches_double_click)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	LD   R30,Y
	LDI  R26,LOW(_double_click_counter)
	LDI  R27,HIGH(_double_click_counter)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	LD   R30,Y
	LDI  R26,LOW(_double_click_counter)
	LDI  R27,HIGH(_double_click_counter)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_switches_old_state)
	SBCI R27,HIGH(-_switches_old_state)
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LD   R30,Y
	LDI  R26,LOW(_double_click_counter)
	LDI  R27,HIGH(_double_click_counter)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LD   R26,Y
	LDD  R27,Y+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDS  R30,_relays_16
	LDS  R31,_relays_16+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-_relays_state)
	SBCI R31,HIGH(-_relays_state)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	SBIW R28,1
	LDI  R30,LOW(1)
	ST   Y,R30
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_settings)
	LDI  R27,HIGH(_settings)
	CALL __EEPROMRDB
	LD   R26,Y
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 46 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x21:
	LD   R30,Y
	LDI  R26,LOW(16)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x23:
	ADIW R30,1
	MOVW R26,R30
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x24:
	MOVW R26,R30
	CALL __EEPROMRDB
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x25:
	LDS  R26,_relays_16
	LDS  R27,_relays_16+1
	AND  R30,R26
	AND  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x26:
	COM  R30
	COM  R31
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x27:
	STS  _relays_16,R30
	STS  _relays_16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x28:
	LDS  R26,_relays_16
	LDS  R27,_relays_16+1
	OR   R30,R26
	OR   R31,R27
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDS  R26,_relays_16
	LDS  R27,_relays_16+1
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2B:
	CALL _bin2bcd
	MOV  R26,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(17)
	MOV  R4,R30
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(0)
	CALL _i2c_write
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,0x7F
	MOV  R26,R30
	CALL _bcd2bin
	STS  _sec,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,0x7F
	MOV  R26,R30
	CALL _bcd2bin
	STS  _minute,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,LOW(0x3F)
	MOV  R26,R30
	CALL _bcd2bin
	STS  _hour,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,LOW(0x7)
	MOV  R26,R30
	CALL _bcd2bin
	STS  _day,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,LOW(0x3F)
	MOV  R26,R30
	CALL _bcd2bin
	STS  _date,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	ANDI R30,LOW(0x1F)
	MOV  R26,R30
	CALL _bcd2bin
	STS  _month,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	STS  _year,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2E:
	MOV  R26,R30
	CALL _bcd2bin
	STS  _calibration,R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	STS  _year_thousands,R30
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(20)
	STS  _Keyboard_inactive,R30
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(0)
	STS  _relays_16_oldstate,R30
	STS  _relays_16_oldstate+1,R30
	STS  _relays_16,R30
	STS  _relays_16+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(0)
	CALL _i2c_write
	LDS  R26,_sec
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x34:
	LDS  R30,_relay_low
	ANDI R30,LOW(0xF)
	MOV  R4,R30
	LDS  R30,_relay_low
	SWAP R30
	ANDI R30,0xF
	MOV  R7,R30
	LDS  R30,_relay_high
	ANDI R30,LOW(0xF)
	MOV  R6,R30
	LDS  R30,_relay_high
	SWAP R30
	ANDI R30,0xF
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	MOV  R30,R6
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL __DIVW21U
	STS  _TMP_1_16_bit,R30
	STS  _TMP_1_16_bit+1,R31
	CLT
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x37:
	MOV  R4,R30
	LDS  R26,_TMP_1_16_bit
	LDS  R27,_TMP_1_16_bit+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R7,R30
	MOV  R26,R7
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	LDS  R26,_TMP_1_16_bit
	LDS  R27,_TMP_1_16_bit+1
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R6,R30
	MOV  R30,R7
	LDI  R26,LOW(100)
	MULS R30,R26
	MOVW R30,R0
	LDS  R26,_TMP_1_16_bit
	SUB  R26,R30
	MOV  R22,R26
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x38:
	LDI  R31,0
	CALL __ASRW4
	STS  _TMP_2_16_bit,R30
	STS  _TMP_2_16_bit+1,R31
	LDI  R30,LOW(0)
	STS  _TMP_1_16_bit,R30
	STS  _TMP_1_16_bit+1,R30
	STD  Y+0,R30
	STD  Y+0+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x39:
	LDS  R26,_TMP_1_16_bit
	LDS  R27,_TMP_1_16_bit+1
	OR   R30,R26
	OR   R31,R27
	STS  _TMP_1_16_bit,R30
	STS  _TMP_1_16_bit+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x3A:
	LDS  R30,_TMP_2_16_bit
	LDS  R31,_TMP_2_16_bit+1
	LSL  R30
	ROL  R31
	STS  _TMP_2_16_bit,R30
	STS  _TMP_2_16_bit+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x3B:
	LDI  R31,0
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STS  _TMP_2_16_bit,R30
	STS  _TMP_2_16_bit+1,R31
	LDI  R30,LOW(0)
	STS  _TMP_1_16_bit,R30
	STS  _TMP_1_16_bit+1,R30
	STD  Y+0,R30
	STD  Y+0+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	STS  _TMP_1_16_bit,R30
	STS  _TMP_1_16_bit+1,R31
	SET
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDS  R26,_TMP_1_16_bit
	LDS  R27,_TMP_1_16_bit+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	MOV  R26,R4
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MULW12
	RCALL SUBOPT_0x3D
	SUB  R26,R30
	SBC  R27,R31
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

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

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
