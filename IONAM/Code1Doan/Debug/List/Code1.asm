
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 1
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	.EQU GICR=0x3B
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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF _I_RH=R5
	.DEF _I_Temp=R4
	.DEF _pm25_value=R6
	.DEF _pm25_value_msb=R7
	.DEF _menu_state=R9
	.DEF _time_10ms_cnt=R10
	.DEF _time_10ms_cnt_msb=R11
	.DEF _time_2s_cnt=R12
	.DEF _time_2s_cnt_msb=R13
	.DEF _flag_10ms=R8

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
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x21,0x20,0x43,0x41,0x4E,0x48,0x20,0x42
	.DB  0x41,0x4F,0x20,0x41,0x4D,0x20,0x21,0x20
	.DB  0x0,0x20,0x48,0x45,0x20,0x54,0x48,0x4F
	.DB  0x4E,0x47,0x20,0x54,0x41,0x54,0x20,0x20
	.DB  0x20,0x0,0x54,0x3A,0x25,0x64,0x25,0x63
	.DB  0x43,0x20,0x48,0x3A,0x25,0x64,0x25,0x25
	.DB  0x20,0x5B,0x25,0x63,0x5D,0x20,0x0,0x50
	.DB  0x4D,0x3A,0x25,0x64,0x20,0x20,0x49,0x4F
	.DB  0x4E,0x3A,0x4F,0x4E,0x20,0x0,0x50,0x4D
	.DB  0x3A,0x25,0x64,0x20,0x20,0x49,0x4F,0x4E
	.DB  0x3A,0x4F,0x46,0x46,0x0,0x3E,0x20,0x43
	.DB  0x41,0x49,0x20,0x44,0x41,0x54,0x20,0x42
	.DB  0x55,0x49,0x20,0x3C,0x20,0x0,0x4E,0x67
	.DB  0x75,0x6F,0x6E,0x67,0x3A,0x20,0x25,0x64
	.DB  0x20,0x75,0x67,0x2F,0x6D,0x33,0x0,0x3E
	.DB  0x20,0x43,0x41,0x49,0x20,0x44,0x4F,0x20
	.DB  0x41,0x4D,0x20,0x20,0x3C,0x20,0x20,0x0
	.DB  0x4E,0x67,0x75,0x6F,0x6E,0x67,0x3A,0x20
	.DB  0x25,0x64,0x20,0x25,0x25,0x20,0x20,0x20
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x11
	.DW  _0x73
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x73+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0x73+34
	.DW  _0x0*2+85

	.DW  0x11
	.DW  _0x73+51
	.DW  _0x0*2+119

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;char hienthi[16];
;unsigned char I_RH = 0;
;unsigned char I_Temp = 0;
;unsigned int pm25_value = 0;
;eeprom unsigned int pm25_limit = 50;
;eeprom unsigned char hum_limit = 80;
;bit sys_mode = 0;
;bit ion_state = 0;
;unsigned char menu_state = 0;
;unsigned int time_10ms_cnt = 0;
;unsigned int time_2s_cnt = 0;
;unsigned char flag_10ms = 0;
;unsigned char flag_2s = 0;
;unsigned char rx_buffer[7];
;unsigned char rx_index = 0;
;interrupt[TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002A {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002B TCNT0 = 0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 002C 
; 0000 002D time_10ms_cnt++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 002E if (time_10ms_cnt >= 10)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R10,R30
	CPC  R11,R31
	BRLO _0x3
; 0000 002F {
; 0000 0030 time_10ms_cnt = 0;
	CLR  R10
	CLR  R11
; 0000 0031 flag_10ms = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0032 }
; 0000 0033 
; 0000 0034 time_2s_cnt++;
_0x3:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0035 if (time_2s_cnt >= 2000)
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0x4
; 0000 0036 {
; 0000 0037 time_2s_cnt = 0;
	CLR  R12
	CLR  R13
; 0000 0038 flag_2s = 1;
	LDI  R30,LOW(1)
	STS  _flag_2s,R30
; 0000 0039 }
; 0000 003A }
_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;interrupt[USART_RXC] void usart_rx_isr(void)
; 0000 003D {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003E unsigned char status;
; 0000 003F unsigned char data;
; 0000 0040 
; 0000 0041 status = UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0042 data = UDR;
	IN   R16,12
; 0000 0043 
; 0000 0044 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x5
; 0000 0045 {
; 0000 0046 if (rx_index == 0 && data != 0xFE)
	LDS  R26,_rx_index
	CPI  R26,LOW(0x0)
	BRNE _0x7
	CPI  R16,254
	BRNE _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 0047 return;
	RJMP _0x89
; 0000 0048 if (rx_index == 1 && data != 0xA5)
_0x6:
	LDS  R26,_rx_index
	CPI  R26,LOW(0x1)
	BRNE _0xA
	CPI  R16,165
	BRNE _0xB
_0xA:
	RJMP _0x9
_0xB:
; 0000 0049 {
; 0000 004A rx_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_index,R30
; 0000 004B return;
	RJMP _0x89
; 0000 004C }
; 0000 004D 
; 0000 004E rx_buffer[rx_index] = data;
_0x9:
	LDS  R30,_rx_index
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 004F rx_index++;
	LDS  R30,_rx_index
	SUBI R30,-LOW(1)
	STS  _rx_index,R30
; 0000 0050 
; 0000 0051 if (rx_index >= 7)
	LDS  R26,_rx_index
	CPI  R26,LOW(0x7)
	BRLO _0xC
; 0000 0052 {
; 0000 0053 pm25_value = (rx_buffer[4] << 8) | rx_buffer[5];
	__GETBRMN 27,_rx_buffer,4
	LDI  R26,LOW(0)
	__GETB1MN _rx_buffer,5
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R6,R30
; 0000 0054 rx_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_index,R30
; 0000 0055 }
; 0000 0056 }
_0xC:
; 0000 0057 }
_0x5:
_0x89:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;void DHT_Start(void)
; 0000 005A {
_DHT_Start:
; .FSTART _DHT_Start
; 0000 005B DHT_DDR = 1;
	SBI  0x11,7
; 0000 005C DHT_PORT = 0;
	CBI  0x12,7
; 0000 005D delay_ms(20);
	CALL SUBOPT_0x0
; 0000 005E DHT_DDR = 0;
	CBI  0x11,7
; 0000 005F DHT_PORT = 1;
	SBI  0x12,7
; 0000 0060 }
	RET
; .FEND
;unsigned char DHT_CheckResponse(void)
; 0000 0062 {
_DHT_CheckResponse:
; .FSTART _DHT_CheckResponse
; 0000 0063 unsigned int timeout = 0;
; 0000 0064 delay_us(40);
	ST   -Y,R17
	ST   -Y,R16
;	timeout -> R16,R17
	__GETWRN 16,17,0
	__DELAY_USB 107
; 0000 0065 if (DHT_PIN == 0)
	SBIC 0x10,7
	RJMP _0x15
; 0000 0066 {
; 0000 0067 timeout = 0;
	__GETWRN 16,17,0
; 0000 0068 while (DHT_PIN == 0)
_0x16:
	SBIC 0x10,7
	RJMP _0x18
; 0000 0069 {
; 0000 006A if (++timeout > 1000)
	CALL SUBOPT_0x1
	BRSH _0x2080004
; 0000 006B return 0;
; 0000 006C }
	RJMP _0x16
_0x18:
; 0000 006D timeout = 0;
	__GETWRN 16,17,0
; 0000 006E while (DHT_PIN == 1)
_0x1A:
	SBIS 0x10,7
	RJMP _0x1C
; 0000 006F {
; 0000 0070 if (++timeout > 1000)
	CALL SUBOPT_0x1
	BRSH _0x2080004
; 0000 0071 return 0;
; 0000 0072 }
	RJMP _0x1A
_0x1C:
; 0000 0073 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2080003
; 0000 0074 }
; 0000 0075 return 0;
_0x15:
_0x2080004:
	LDI  R30,LOW(0)
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0076 }
; .FEND
;unsigned char DHT_ReadByte(void)
; 0000 0078 {
_DHT_ReadByte:
; .FSTART _DHT_ReadByte
; 0000 0079 unsigned char i;
; 0000 007A unsigned char data = 0;
; 0000 007B unsigned int timeout;
; 0000 007C for (i = 0; i < 8; i++)
	CALL __SAVELOCR4
;	i -> R17
;	data -> R16
;	timeout -> R18,R19
	LDI  R16,0
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,8
	BRSH _0x20
; 0000 007D {
; 0000 007E timeout = 0;
	__GETWRN 18,19,0
; 0000 007F while (DHT_PIN == 0)
_0x21:
	SBIC 0x10,7
	RJMP _0x23
; 0000 0080 {
; 0000 0081 if (++timeout > 1000)
	CALL SUBOPT_0x2
	BRLO _0x21
; 0000 0082 break;
; 0000 0083 }
_0x23:
; 0000 0084 delay_us(30);
	__DELAY_USB 80
; 0000 0085 if (DHT_PIN == 1)
	SBIS 0x10,7
	RJMP _0x25
; 0000 0086 {
; 0000 0087 data = (data << 1) | 1;
	MOV  R30,R16
	LSL  R30
	ORI  R30,1
	MOV  R16,R30
; 0000 0088 timeout = 0;
	__GETWRN 18,19,0
; 0000 0089 while (DHT_PIN == 1)
_0x26:
	SBIS 0x10,7
	RJMP _0x28
; 0000 008A {
; 0000 008B if (++timeout > 1000)
	CALL SUBOPT_0x2
	BRLO _0x26
; 0000 008C break;
; 0000 008D }
_0x28:
; 0000 008E }
; 0000 008F else
	RJMP _0x2A
_0x25:
; 0000 0090 {
; 0000 0091 data = (data << 1);
	LSL  R16
; 0000 0092 }
_0x2A:
; 0000 0093 }
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 0094 return data;
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 0095 }
; .FEND
;void Doc_DHT11(void)
; 0000 0098 {
_Doc_DHT11:
; .FSTART _Doc_DHT11
; 0000 0099 #asm("cli")
	CLI
; 0000 009A DHT_Start();
	RCALL _DHT_Start
; 0000 009B if (DHT_CheckResponse() == 1)
	RCALL _DHT_CheckResponse
	CPI  R30,LOW(0x1)
	BRNE _0x2B
; 0000 009C {
; 0000 009D I_RH = DHT_ReadByte();
	RCALL _DHT_ReadByte
	MOV  R5,R30
; 0000 009E DHT_ReadByte();
	RCALL _DHT_ReadByte
; 0000 009F I_Temp = DHT_ReadByte();
	RCALL _DHT_ReadByte
	MOV  R4,R30
; 0000 00A0 DHT_ReadByte();
	RCALL _DHT_ReadByte
; 0000 00A1 DHT_ReadByte();
	RCALL _DHT_ReadByte
; 0000 00A2 }
; 0000 00A3 #asm("sei")
_0x2B:
	SEI
; 0000 00A4 }
	RET
; .FEND
;void YeuCau_Doc_PM25(void)
; 0000 00A7 {
_YeuCau_Doc_PM25:
; .FSTART _YeuCau_Doc_PM25
; 0000 00A8 rx_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_index,R30
; 0000 00A9 while (!(UCSRA & (1 << UDRE)))
_0x2C:
	SBIS 0xB,5
; 0000 00AA ;
	RJMP _0x2C
; 0000 00AB UDR = 0xFE;
	LDI  R30,LOW(254)
	OUT  0xC,R30
; 0000 00AC while (!(UCSRA & (1 << UDRE)))
_0x2F:
	SBIS 0xB,5
; 0000 00AD ;
	RJMP _0x2F
; 0000 00AE UDR = 0xA5;
	LDI  R30,LOW(165)
	OUT  0xC,R30
; 0000 00AF while (!(UCSRA & (1 << UDRE)))
_0x32:
	SBIS 0xB,5
; 0000 00B0 ;
	RJMP _0x32
; 0000 00B1 UDR = 0x00;
	LDI  R30,LOW(0)
	OUT  0xC,R30
; 0000 00B2 while (!(UCSRA & (1 << UDRE)))
_0x35:
	SBIS 0xB,5
; 0000 00B3 ;
	RJMP _0x35
; 0000 00B4 UDR = 0x00;
	LDI  R30,LOW(0)
	OUT  0xC,R30
; 0000 00B5 while (!(UCSRA & (1 << UDRE)))
_0x38:
	SBIS 0xB,5
; 0000 00B6 ;
	RJMP _0x38
; 0000 00B7 UDR = 0xA5;
	LDI  R30,LOW(165)
	OUT  0xC,R30
; 0000 00B8 }
	RET
; .FEND
;void Quet_NutBam(void)
; 0000 00BB {
_Quet_NutBam:
; .FSTART _Quet_NutBam
; 0000 00BC if (BT1 == 0)
	SBIC 0x13,0
	RJMP _0x3B
; 0000 00BD {
; 0000 00BE delay_ms(20);
	CALL SUBOPT_0x0
; 0000 00BF if (BT1 == 0)
	SBIC 0x13,0
	RJMP _0x3C
; 0000 00C0 {
; 0000 00C1 while (BT1 == 0)
_0x3D:
	SBIS 0x13,0
; 0000 00C2 ;
	RJMP _0x3D
; 0000 00C3 menu_state++;
	INC  R9
; 0000 00C4 if (menu_state > 2)
	LDI  R30,LOW(2)
	CP   R30,R9
	BRSH _0x40
; 0000 00C5 menu_state = 0;
	CLR  R9
; 0000 00C6 lcd_clear();
_0x40:
	RCALL _lcd_clear
; 0000 00C7 }
; 0000 00C8 }
_0x3C:
; 0000 00C9 if (BT4 == 0)
_0x3B:
	SBIC 0x13,3
	RJMP _0x41
; 0000 00CA {
; 0000 00CB delay_ms(20);
	CALL SUBOPT_0x0
; 0000 00CC if (BT4 == 0)
	SBIC 0x13,3
	RJMP _0x42
; 0000 00CD {
; 0000 00CE while (BT4 == 0)
_0x43:
	SBIS 0x13,3
; 0000 00CF ;
	RJMP _0x43
; 0000 00D0 if (menu_state == 0)
	TST  R9
	BRNE _0x46
; 0000 00D1 sys_mode = !sys_mode;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 00D2 }
_0x46:
; 0000 00D3 }
_0x42:
; 0000 00D4 
; 0000 00D5 if (BT2 == 0)
_0x41:
	SBIC 0x13,1
	RJMP _0x47
; 0000 00D6 {
; 0000 00D7 delay_ms(20);
	CALL SUBOPT_0x0
; 0000 00D8 if (BT2 == 0)
	SBIC 0x13,1
	RJMP _0x48
; 0000 00D9 {
; 0000 00DA if (menu_state == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x49
; 0000 00DB pm25_limit += 5;
	CALL SUBOPT_0x3
	ADIW R30,5
	LDI  R26,LOW(_pm25_limit)
	LDI  R27,HIGH(_pm25_limit)
	CALL __EEPROMWRW
; 0000 00DC else if (menu_state == 2)
	RJMP _0x4A
_0x49:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x4B
; 0000 00DD {
; 0000 00DE if (hum_limit < 100)
	CALL SUBOPT_0x4
	CPI  R30,LOW(0x64)
	BRSH _0x4C
; 0000 00DF hum_limit++;
	CALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 00E0 }
_0x4C:
; 0000 00E1 else if (menu_state == 0 && sys_mode == 1)
	RJMP _0x4D
_0x4B:
	TST  R9
	BRNE _0x4F
	SBRC R2,0
	RJMP _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 00E2 ion_state = 1;
	SET
	BLD  R2,1
; 0000 00E3 delay_ms(150);
_0x4E:
_0x4D:
_0x4A:
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 00E4 }
; 0000 00E5 }
_0x48:
; 0000 00E6 
; 0000 00E7 if (BT3 == 0)
_0x47:
	SBIC 0x13,2
	RJMP _0x51
; 0000 00E8 {
; 0000 00E9 delay_ms(20);
	CALL SUBOPT_0x0
; 0000 00EA if (BT3 == 0)
	SBIC 0x13,2
	RJMP _0x52
; 0000 00EB {
; 0000 00EC if (menu_state == 1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x53
; 0000 00ED {
; 0000 00EE if (pm25_limit >= 5)
	CALL SUBOPT_0x3
	SBIW R30,5
	BRLO _0x54
; 0000 00EF pm25_limit -= 5;
	CALL SUBOPT_0x3
	SBIW R30,5
	LDI  R26,LOW(_pm25_limit)
	LDI  R27,HIGH(_pm25_limit)
	RJMP _0x84
; 0000 00F0 else pm25_limit = 5;
_0x54:
	LDI  R26,LOW(_pm25_limit)
	LDI  R27,HIGH(_pm25_limit)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x84:
	CALL __EEPROMWRW
; 0000 00F1 }
; 0000 00F2 else if (menu_state == 2)
	RJMP _0x56
_0x53:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x57
; 0000 00F3 {
; 0000 00F4 if (hum_limit >= 1)
	CALL SUBOPT_0x4
	CPI  R30,LOW(0x1)
	BRLO _0x58
; 0000 00F5 hum_limit--;
	CALL SUBOPT_0x4
	SUBI R30,LOW(1)
	RJMP _0x85
; 0000 00F6 else hum_limit = 0;
_0x58:
	LDI  R26,LOW(_hum_limit)
	LDI  R27,HIGH(_hum_limit)
	LDI  R30,LOW(0)
_0x85:
	CALL __EEPROMWRB
; 0000 00F7 }
; 0000 00F8 else if (menu_state == 0 && sys_mode == 1)
	RJMP _0x5A
_0x57:
	TST  R9
	BRNE _0x5C
	SBRC R2,0
	RJMP _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
; 0000 00F9 ion_state = 0;
	CLT
	BLD  R2,1
; 0000 00FA delay_ms(150);
_0x5B:
_0x5A:
_0x56:
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 00FB }
; 0000 00FC }
_0x52:
; 0000 00FD }
_0x51:
	RET
; .FEND
;void XuLy_Logic(void)
; 0000 0100 {
_XuLy_Logic:
; .FSTART _XuLy_Logic
; 0000 0101 if (I_RH >= hum_limit && I_RH <= 100)
	CALL SUBOPT_0x4
	CP   R5,R30
	BRLO _0x5F
	LDI  R30,LOW(100)
	CP   R30,R5
	BRSH _0x60
_0x5F:
	RJMP _0x5E
_0x60:
; 0000 0102 {
; 0000 0103 IONAM = 0;
	CBI  0x1B,0
; 0000 0104 ion_state = 0;
	CLT
	BLD  R2,1
; 0000 0105 }
; 0000 0106 else
	RJMP _0x63
_0x5E:
; 0000 0107 {
; 0000 0108 if (sys_mode == 0)
	SBRC R2,0
	RJMP _0x64
; 0000 0109 {
; 0000 010A if (pm25_value >= pm25_limit)
	CALL SUBOPT_0x3
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x65
; 0000 010B IONAM = 1;
	SBI  0x1B,0
; 0000 010C else if (pm25_value < pm25_limit - 5)
	RJMP _0x68
_0x65:
	CALL SUBOPT_0x3
	SBIW R30,5
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x69
; 0000 010D IONAM = 0;
	CBI  0x1B,0
; 0000 010E }
_0x69:
_0x68:
; 0000 010F else
	RJMP _0x6C
_0x64:
; 0000 0110 IONAM = ion_state;
	SBRC R2,1
	RJMP _0x6D
	CBI  0x1B,0
	RJMP _0x6E
_0x6D:
	SBI  0x1B,0
_0x6E:
; 0000 0111 }
_0x6C:
_0x63:
; 0000 0112 }
	RET
; .FEND
;void HienThi_LCD(void)
; 0000 0115 {
_HienThi_LCD:
; .FSTART _HienThi_LCD
; 0000 0116 if (menu_state == 0)
	TST  R9
	BREQ PC+2
	RJMP _0x6F
; 0000 0117 {
; 0000 0118 if (I_RH >= hum_limit && I_RH <= 100)
	CALL SUBOPT_0x4
	CP   R5,R30
	BRLO _0x71
	LDI  R30,LOW(100)
	CP   R30,R5
	BRSH _0x72
_0x71:
	RJMP _0x70
_0x72:
; 0000 0119 {
; 0000 011A lcd_gotoxy(0, 0);
	CALL SUBOPT_0x5
; 0000 011B lcd_puts("! CANH BAO AM ! ");
	__POINTW2MN _0x73,0
	RCALL _lcd_puts
; 0000 011C lcd_gotoxy(0, 1);
	CALL SUBOPT_0x6
; 0000 011D lcd_puts(" HE THONG TAT   ");
	__POINTW2MN _0x73,17
	RJMP _0x86
; 0000 011E }
; 0000 011F else
_0x70:
; 0000 0120 {
; 0000 0121 sprintf(hienthi, "T:%d%cC H:%d%% [%c] ", I_Temp, 0xdf, I_RH, (sys_mode == 0 ? 'A ...
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CALL SUBOPT_0x8
	__GETD1N 0xDF
	CALL __PUTPARD1
	MOV  R30,R5
	CALL SUBOPT_0x8
	SBRC R2,0
	RJMP _0x75
	LDI  R30,LOW(65)
	RJMP _0x76
_0x75:
	LDI  R30,LOW(77)
_0x76:
	CALL SUBOPT_0x8
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 0122 lcd_gotoxy(0, 0);
	CALL SUBOPT_0x5
; 0000 0123 lcd_puts(hienthi);
	LDI  R26,LOW(_hienthi)
	LDI  R27,HIGH(_hienthi)
	RCALL _lcd_puts
; 0000 0124 
; 0000 0125 if (IONAM == 1)
	SBIS 0x1B,0
	RJMP _0x78
; 0000 0126 {
; 0000 0127 sprintf(hienthi, "PM:%d  ION:ON ", pm25_value);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,55
	RJMP _0x87
; 0000 0128 }
; 0000 0129 else
_0x78:
; 0000 012A {
; 0000 012B sprintf(hienthi, "PM:%d  ION:OFF", pm25_value);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,70
_0x87:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 012C }
; 0000 012D lcd_gotoxy(0, 1);
	CALL SUBOPT_0x6
; 0000 012E lcd_puts(hienthi);
	LDI  R26,LOW(_hienthi)
	LDI  R27,HIGH(_hienthi)
_0x86:
	RCALL _lcd_puts
; 0000 012F }
; 0000 0130 }
; 0000 0131 else if (menu_state == 1)
	RJMP _0x7A
_0x6F:
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x7B
; 0000 0132 {
; 0000 0133 lcd_gotoxy(0, 0);
	CALL SUBOPT_0x5
; 0000 0134 lcd_puts("> CAI DAT BUI < ");
	__POINTW2MN _0x73,34
	RCALL _lcd_puts
; 0000 0135 sprintf(hienthi, "Nguong: %d ug/m3", pm25_limit);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,102
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
	CLR  R22
	CLR  R23
	RJMP _0x88
; 0000 0136 lcd_gotoxy(0, 1);
; 0000 0137 lcd_puts(hienthi);
; 0000 0138 }
; 0000 0139 else if (menu_state == 2)
_0x7B:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x7D
; 0000 013A {
; 0000 013B lcd_gotoxy(0, 0);
	CALL SUBOPT_0x5
; 0000 013C lcd_puts("> CAI DO AM  <  ");
	__POINTW2MN _0x73,51
	RCALL _lcd_puts
; 0000 013D sprintf(hienthi, "Nguong: %d %%   ", hum_limit);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,136
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4
	CLR  R31
	CLR  R22
	CLR  R23
_0x88:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 013E lcd_gotoxy(0, 1);
	CALL SUBOPT_0x6
; 0000 013F lcd_puts(hienthi);
	LDI  R26,LOW(_hienthi)
	LDI  R27,HIGH(_hienthi)
	RCALL _lcd_puts
; 0000 0140 }
; 0000 0141 }
_0x7D:
_0x7A:
	RET
; .FEND

	.DSEG
_0x73:
	.BYTE 0x44
;void main(void)
; 0000 0144 {

	.CSEG
_main:
; .FSTART _main
; 0000 0145 DDRA = 0x01;
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 0146 PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0147 DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0148 PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0149 DDRC = (0 << DDC7) | (0 << DDC6) | (0 << DDC5) | (0 << DDC4) | (0 << DDC3) | (0  ...
	OUT  0x14,R30
; 0000 014A PORTC = (0 << PORTC7) | (0 << PORTC6) | (0 << PORTC5) | (0 << PORTC4) | (1 << PO ...
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 014B DDRD = 0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 014C PORTD = 0x10;
	LDI  R30,LOW(16)
	OUT  0x12,R30
; 0000 014D 
; 0000 014E TCCR0 = (0 << WGM00) | (0 << COM01) | (0 << COM00) | (0 << WGM01) | (0 << CS02)  ...
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 014F TCNT0 = 0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0150 OCR0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0151 
; 0000 0152 TIMSK = (0 << OCIE2) | (0 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE ...
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0153 
; 0000 0154 UCSRA = (0 << RXC) | (0 << TXC) | (0 << UDRE) | (0 << FE) | (0 << DOR) | (0 << U ...
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0155 UCSRB = (1 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN) | ...
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0156 UCSRC = (1 << URSEL) | (0 << UMSEL) | (0 << UPM1) | (0 << UPM0) | (0 << USBS) |  ...
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0157 UBRRH = 0x01;
	LDI  R30,LOW(1)
	OUT  0x20,R30
; 0000 0158 UBRRL = 0xA0;
	LDI  R30,LOW(160)
	OUT  0x9,R30
; 0000 0159 
; 0000 015A lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 015B lcd_clear();
	RCALL _lcd_clear
; 0000 015C 
; 0000 015D #asm("sei")
	SEI
; 0000 015E 
; 0000 015F while (1)
_0x7E:
; 0000 0160 {
; 0000 0161 if (flag_10ms)
	TST  R8
	BREQ _0x81
; 0000 0162 {
; 0000 0163 flag_10ms = 0;
	CLR  R8
; 0000 0164 Quet_NutBam();
	RCALL _Quet_NutBam
; 0000 0165 XuLy_Logic();
	RCALL _XuLy_Logic
; 0000 0166 HienThi_LCD();
	RCALL _HienThi_LCD
; 0000 0167 }
; 0000 0168 
; 0000 0169 if (flag_2s)
_0x81:
	LDS  R30,_flag_2s
	CPI  R30,0
	BREQ _0x82
; 0000 016A {
; 0000 016B flag_2s = 0;
	LDI  R30,LOW(0)
	STS  _flag_2s,R30
; 0000 016C Doc_DHT11();
	RCALL _Doc_DHT11
; 0000 016D YeuCau_Doc_PM25();
	RCALL _YeuCau_Doc_PM25
; 0000 016E }
; 0000 016F }
_0x82:
	RJMP _0x7E
; 0000 0170 }
_0x83:
	RJMP _0x83
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x12,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x12,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x12,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x12,4
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x12,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x12,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x12,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x12,6
_0x200000B:
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x2080002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x9
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080002
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x11,3
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0x0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0xB
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0xB
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0xC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xD
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0xC
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0xC
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0xB
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xD
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
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

	.CSEG

	.DSEG
_hienthi:
	.BYTE 0x10

	.ESEG
_pm25_limit:
	.DB  0x32,0x0
_hum_limit:
	.DB  0x50

	.DSEG
_flag_2s:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0x7
_rx_index:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOVW R30,R16
	ADIW R30,1
	MOVW R16,R30
	CPI  R30,LOW(0x3E9)
	LDI  R26,HIGH(0x3E9)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	MOVW R30,R18
	ADIW R30,1
	MOVW R18,R30
	CPI  R30,LOW(0x3E9)
	LDI  R26,HIGH(0x3E9)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_pm25_limit)
	LDI  R27,HIGH(_pm25_limit)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_hum_limit)
	LDI  R27,HIGH(_hum_limit)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_hienthi)
	LDI  R31,HIGH(_hienthi)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
