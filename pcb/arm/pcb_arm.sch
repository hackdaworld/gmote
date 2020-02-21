EESchema Schematic File Version 4
LIBS:pcb_arm-cache
EELAYER 26 0
EELAYER END
$Descr User 8661 5906
encoding utf-8
Sheet 1 1
Title "GMote on ARM"
Date "2019-05-12"
Rev "1.0"
Comp "DigiDev"
Comment1 "https://www.digidev.de/gmote"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_ST_STM32F0:STM32F051K8Tx U2
U 1 1 5CD33387
P 7000 2000
F 0 "U2" H 6950 914 50  0000 C CNN
F 1 "STM32F051K8Tx" H 6950 823 50  0000 C CNN
F 2 "Package_QFP:LQFP-32_7x7mm_P0.8mm" H 6500 1100 50  0001 R CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/DM00039193.pdf" H 7000 2000 50  0001 C CNN
	1    7000 2000
	1    0    0    -1  
$EndComp
Text GLabel 2900 2850 2    50   Input ~ 0
ARM_UART_RX
Text GLabel 2900 2750 2    50   Input ~ 0
ARM_UART_TX
Wire Wire Line
	6900 1100 6900 1000
Wire Wire Line
	6900 1000 7000 1000
Wire Wire Line
	7100 1000 7100 1100
Wire Wire Line
	7000 1100 7000 1000
Connection ~ 7000 1000
Wire Wire Line
	7000 1000 7100 1000
Wire Wire Line
	7000 1000 7000 900 
Text GLabel 7000 900  1    50   Input ~ 0
VCC
Text GLabel 6950 3350 3    50   Input ~ 0
GND
Wire Wire Line
	6900 3000 6900 3250
Wire Wire Line
	6900 3250 6950 3250
Wire Wire Line
	7000 3250 7000 3000
Wire Wire Line
	6950 3250 6950 3350
Connection ~ 6950 3250
Wire Wire Line
	6950 3250 7000 3250
$Comp
L Device:C C1
U 1 1 5CD33EF6
P 1950 1050
F 0 "C1" H 2065 1096 50  0000 L CNN
F 1 "100nF" H 2065 1005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1988 900 50  0001 C CNN
F 3 "~" H 1950 1050 50  0001 C CNN
	1    1950 1050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 5CD33F5F
P 2500 1050
F 0 "C2" H 2615 1096 50  0000 L CNN
F 1 "10uF" H 2615 1005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 2538 900 50  0001 C CNN
F 3 "~" H 2500 1050 50  0001 C CNN
	1    2500 1050
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J1
U 1 1 5CD35C2F
P 950 900
F 0 "J1" H 1056 1078 50  0000 C CNN
F 1 "JST_POWER" H 1056 987 50  0000 C CNN
F 2 "Connector_JST:JST_PH_B2B-PH-K_1x02_P2.00mm_Vertical" H 950 900 50  0001 C CNN
F 3 "~" H 950 900 50  0001 C CNN
	1    950  900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 900  1950 900 
Connection ~ 1950 900 
Wire Wire Line
	1950 900  2500 900 
Connection ~ 2500 900 
Wire Wire Line
	2500 900  3000 900 
Wire Wire Line
	1150 1000 1600 1000
Wire Wire Line
	1600 1000 1600 1200
Wire Wire Line
	1600 1200 1950 1200
Connection ~ 1950 1200
Wire Wire Line
	1950 1200 2500 1200
Connection ~ 2500 1200
Wire Wire Line
	2500 1200 3000 1200
Text GLabel 3000 900  2    50   Input ~ 0
VCC
Text GLabel 3000 1200 2    50   Input ~ 0
GND
$Comp
L Connector:Conn_01x06_Male J2
U 1 1 5CD369CC
P 950 2650
F 0 "J2" H 1056 3028 50  0000 C CNN
F 1 "231X_Breakout" H 1056 2937 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" H 950 2650 50  0001 C CNN
F 3 "~" H 950 2650 50  0001 C CNN
	1    950  2650
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper JP1
U 1 1 5CD37120
P 1900 2650
F 0 "JP1" H 1900 2914 50  0000 C CNN
F 1 "Jumper" H 1900 2823 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1900 2650 50  0001 C CNN
F 3 "~" H 1900 2650 50  0001 C CNN
	1    1900 2650
	1    0    0    -1  
$EndComp
Text GLabel 2200 2650 2    50   Input ~ 0
VCC
Text GLabel 1150 2750 2    50   Input ~ 0
231X_TX
Text GLabel 1150 2850 2    50   Input ~ 0
231X_RX
$Comp
L Device:Jumper JP2
U 1 1 5CD377E5
P 1900 2950
F 0 "JP2" H 1900 3214 50  0000 C CNN
F 1 "Jumper" H 1900 3123 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1900 2950 50  0001 C CNN
F 3 "~" H 1900 2950 50  0001 C CNN
	1    1900 2950
	1    0    0    -1  
$EndComp
Text GLabel 2850 2850 0    50   Input ~ 0
231X_TX
Text GLabel 2850 2750 0    50   Input ~ 0
231X_RX
$Comp
L RF_AM_FM:RFM95W-868S2 U1
U 1 1 5CD39821
P 4750 1700
F 0 "U1" H 4750 2378 50  0000 C CNN
F 1 "RFM95W-868S2" H 4750 2287 50  0000 C CNN
F 2 "RF_Module:HOPERF_RFM9XW_SMD" H 1450 3350 50  0001 C CNN
F 3 "http://www.hoperf.com/upload/rf/RFM95_96_97_98W.pdf" H 1450 3350 50  0001 C CNN
	1    4750 1700
	1    0    0    -1  
$EndComp
Text GLabel 4750 900  1    50   Input ~ 0
VCC
Text GLabel 4750 2500 3    50   Input ~ 0
GND
Wire Wire Line
	4650 2300 4650 2400
Wire Wire Line
	4650 2400 4750 2400
Wire Wire Line
	4750 2400 4750 2300
Wire Wire Line
	4850 2300 4850 2400
Wire Wire Line
	4850 2400 4750 2400
Connection ~ 4750 2400
Wire Wire Line
	4750 2500 4750 2400
Text GLabel 1300 2450 2    50   Input ~ 0
GND
Wire Wire Line
	1150 2450 1200 2450
Wire Wire Line
	1150 2550 1200 2550
Wire Wire Line
	1200 2550 1200 2450
Connection ~ 1200 2450
Wire Wire Line
	1200 2450 1300 2450
Wire Wire Line
	1600 2650 1150 2650
Wire Wire Line
	1150 2950 1600 2950
Text GLabel 2200 2950 2    50   Input ~ 0
RST
Wire Wire Line
	2850 2750 2900 2750
Wire Wire Line
	2850 2850 2900 2850
Wire Wire Line
	4750 1200 4750 900 
$Comp
L Connector:Conn_01x01_Male J4
U 1 1 5CD43701
P 4250 3200
F 0 "J4" H 4356 3378 50  0000 C CNN
F 1 "ANT_WIRE" H 4356 3287 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 4250 3200 50  0001 C CNN
F 3 "~" H 4250 3200 50  0001 C CNN
	1    4250 3200
	1    0    0    -1  
$EndComp
Text GLabel 5250 1400 2    50   Input ~ 0
ANT
Text GLabel 4600 3200 2    50   Input ~ 0
ANT
Wire Wire Line
	4600 3200 4500 3200
$Comp
L Device:C C3
U 1 1 5CD44703
P 1300 1650
F 0 "C3" H 1415 1696 50  0000 L CNN
F 1 "100nF" H 1415 1605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1338 1500 50  0001 C CNN
F 3 "~" H 1300 1650 50  0001 C CNN
	1    1300 1650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5CD44AED
P 1800 1650
F 0 "C4" H 1915 1696 50  0000 L CNN
F 1 "100nF" H 1915 1605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1838 1500 50  0001 C CNN
F 3 "~" H 1800 1650 50  0001 C CNN
	1    1800 1650
	1    0    0    -1  
$EndComp
Text GLabel 1150 1500 0    50   Input ~ 0
VCC
Text GLabel 1150 1800 0    50   Input ~ 0
GND
Wire Wire Line
	1150 1500 1300 1500
Connection ~ 1300 1500
Wire Wire Line
	1300 1500 1800 1500
Wire Wire Line
	1150 1800 1300 1800
Connection ~ 1300 1800
Wire Wire Line
	1300 1800 1800 1800
Text GLabel 5250 2100 2    50   Input ~ 0
RFM95_DIO0
Text GLabel 5250 2000 2    50   Input ~ 0
RFM95_DIO1
Text GLabel 4250 1400 0    50   Input ~ 0
SPI_SCK
Text GLabel 4250 1500 0    50   Input ~ 0
SPI_MOSI
Text GLabel 4250 1600 0    50   Input ~ 0
SPI_MISO
Text GLabel 4250 1700 0    50   Input ~ 0
SPI_NSS
Text GLabel 4250 1900 0    50   Input ~ 0
RFM95_RST
NoConn ~ 5250 1600
NoConn ~ 5250 1700
NoConn ~ 5250 1800
NoConn ~ 5250 1900
$Comp
L Connector:Conn_Coaxial J5
U 1 1 5CD4E34D
P 4700 3400
F 0 "J5" H 4799 3376 50  0000 L CNN
F 1 "Conn_Coaxial" H 4799 3285 50  0000 L CNN
F 2 "Connector_Coaxial:U.FL_Hirose_U.FL-R-SMT-1_Vertical" H 4700 3400 50  0001 C CNN
F 3 " ~" H 4700 3400 50  0001 C CNN
	1    4700 3400
	1    0    0    -1  
$EndComp
Connection ~ 4500 3200
Wire Wire Line
	4500 3200 4450 3200
Wire Wire Line
	4500 3200 4500 3400
Text GLabel 4700 3600 3    50   Input ~ 0
GND
Text GLabel 7500 1700 2    50   Input ~ 0
SPI_NSS
Text GLabel 7500 1800 2    50   Input ~ 0
SPI_SCK
Text GLabel 7500 1900 2    50   Input ~ 0
SPI_MISO
Text GLabel 7500 2000 2    50   Input ~ 0
SPI_MOSI
$Comp
L Connector:Conn_01x09_Male J3
U 1 1 5CD502D9
P 950 3800
F 0 "J3" H 1056 4378 50  0000 C CNN
F 1 "IO_ADC_PINOUT" H 1056 4287 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x09_P2.54mm_Vertical" H 950 3800 50  0001 C CNN
F 3 "~" H 950 3800 50  0001 C CNN
	1    950  3800
	1    0    0    -1  
$EndComp
Text GLabel 1150 3400 2    50   Input ~ 0
ARM_SCL
Text GLabel 1150 3500 2    50   Input ~ 0
ARM_SDA
Text GLabel 1150 3600 2    50   Input ~ 0
GND
Text GLabel 1150 3700 2    50   Input ~ 0
VCC
Text GLabel 1150 4200 2    50   Input ~ 0
GND
Text GLabel 7500 2200 2    50   Input ~ 0
ARM_UART_TX
Text GLabel 7500 2300 2    50   Input ~ 0
ARM_UART_RX
Text GLabel 6400 1500 0    50   Input ~ 0
ARM_BOOT0
Text GLabel 3150 3300 2    50   Input ~ 0
ARM_BOOT0
$Comp
L Device:R R1
U 1 1 5CD51D2F
P 2650 3300
F 0 "R1" V 2443 3300 50  0000 C CNN
F 1 "10k" V 2534 3300 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 2580 3300 50  0001 C CNN
F 3 "~" H 2650 3300 50  0001 C CNN
	1    2650 3300
	0    1    1    0   
$EndComp
Text GLabel 2400 3300 0    50   Input ~ 0
GND
Wire Wire Line
	2400 3300 2500 3300
Text GLabel 6400 1300 0    50   Input ~ 0
ARM_RST
Text GLabel 2900 4250 2    50   Input ~ 0
ARM_RST
$Comp
L Device:R R2
U 1 1 5CD55D81
P 2650 4250
F 0 "R2" V 2443 4250 50  0000 C CNN
F 1 "10k" V 2534 4250 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 2580 4250 50  0001 C CNN
F 3 "~" H 2650 4250 50  0001 C CNN
	1    2650 4250
	0    1    1    0   
$EndComp
Text GLabel 2400 4250 0    50   Input ~ 0
VCC
Wire Wire Line
	2400 4250 2500 4250
Wire Wire Line
	2800 4250 2850 4250
Text GLabel 2850 4800 3    50   Input ~ 0
RST
$Comp
L Device:C C5
U 1 1 5CD58675
P 2850 4600
F 0 "C5" H 2965 4646 50  0000 L CNN
F 1 "100nF" H 2965 4555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 2888 4450 50  0001 C CNN
F 3 "~" H 2850 4600 50  0001 C CNN
	1    2850 4600
	1    0    0    -1  
$EndComp
Connection ~ 2850 4250
Wire Wire Line
	2850 4250 2900 4250
Wire Wire Line
	2850 4750 2850 4800
$Comp
L Device:Jumper JP3
U 1 1 5CD5A00C
P 2750 3750
F 0 "JP3" H 2750 4014 50  0000 C CNN
F 1 "Jumper" H 2750 3923 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2750 3750 50  0001 C CNN
F 3 "~" H 2750 3750 50  0001 C CNN
	1    2750 3750
	1    0    0    -1  
$EndComp
Text GLabel 2400 3750 0    50   Input ~ 0
VCC
Wire Wire Line
	2450 3750 2400 3750
Wire Wire Line
	2800 3300 3050 3300
Wire Wire Line
	3050 3300 3050 3750
Connection ~ 3050 3300
Wire Wire Line
	3050 3300 3150 3300
Wire Wire Line
	2850 4250 2850 4400
Wire Wire Line
	2850 4400 2550 4400
Wire Wire Line
	2550 4400 2550 4750
Connection ~ 2850 4400
Wire Wire Line
	2850 4400 2850 4450
$Comp
L Connector:Conn_01x02_Male J6
U 1 1 5CD631B6
P 2450 4950
F 0 "J6" H 2556 5128 50  0000 C CNN
F 1 "RST_PIN" H 2556 5037 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2450 4950 50  0001 C CNN
F 3 "~" H 2450 4950 50  0001 C CNN
	1    2450 4950
	0    -1   -1   0   
$EndComp
Text GLabel 2400 4400 0    50   Input ~ 0
GND
Wire Wire Line
	2450 4400 2400 4400
Wire Wire Line
	2450 4400 2450 4750
Text GLabel 6400 2700 0    50   Input ~ 0
ARM_SCL
Text GLabel 6400 2800 0    50   Input ~ 0
ARM_SDA
Text GLabel 7500 1300 2    50   Input ~ 0
PA0
Text GLabel 7500 1400 2    50   Input ~ 0
PA1
Text GLabel 7500 1500 2    50   Input ~ 0
PA2
Text GLabel 7500 1600 2    50   Input ~ 0
PA3
Text GLabel 1150 3800 2    50   Input ~ 0
PA0
Text GLabel 1150 3900 2    50   Input ~ 0
PA1
Text GLabel 1150 4000 2    50   Input ~ 0
PA2
Text GLabel 1150 4100 2    50   Input ~ 0
PA3
NoConn ~ 7500 2100
NoConn ~ 7500 2700
NoConn ~ 7500 2800
NoConn ~ 6400 2200
NoConn ~ 6400 2300
NoConn ~ 6400 2400
NoConn ~ 6400 2500
NoConn ~ 6400 2600
NoConn ~ 6400 1900
NoConn ~ 6400 2000
Text GLabel 7500 2400 2    50   Input ~ 0
RFM95_RST
Text GLabel 7500 2500 2    50   Input ~ 0
RFM95_DIO1
Text GLabel 7500 2600 2    50   Input ~ 0
RFM95_DIO0
Text GLabel 2850 2250 0    50   Input ~ 0
SPI_NSS
$Comp
L Device:R R3
U 1 1 5CD9EE95
P 3050 2250
F 0 "R3" V 2843 2250 50  0000 C CNN
F 1 "10k" V 2934 2250 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 2980 2250 50  0001 C CNN
F 3 "~" H 3050 2250 50  0001 C CNN
	1    3050 2250
	0    -1   -1   0   
$EndComp
Text GLabel 2850 1950 0    50   Input ~ 0
ARM_SCL
Text GLabel 2850 1650 0    50   Input ~ 0
ARM_SDA
$Comp
L Device:R R5
U 1 1 5CDA5C34
P 3050 1950
F 0 "R5" V 2843 1950 50  0000 C CNN
F 1 "10k" V 2934 1950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 2980 1950 50  0001 C CNN
F 3 "~" H 3050 1950 50  0001 C CNN
	1    3050 1950
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R4
U 1 1 5CDA5C6C
P 3050 1650
F 0 "R4" V 2843 1650 50  0000 C CNN
F 1 "10k" V 2934 1650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 2980 1650 50  0001 C CNN
F 3 "~" H 3050 1650 50  0001 C CNN
	1    3050 1650
	0    -1   -1   0   
$EndComp
Text GLabel 3350 1950 2    50   Input ~ 0
VCC
Wire Wire Line
	3200 1950 3250 1950
Wire Wire Line
	2850 1950 2900 1950
Wire Wire Line
	2850 1650 2900 1650
Wire Wire Line
	2850 2250 2900 2250
Wire Wire Line
	3200 2250 3250 2250
Wire Wire Line
	3250 2250 3250 1950
Connection ~ 3250 1950
Wire Wire Line
	3250 1950 3350 1950
Wire Wire Line
	3200 1650 3250 1650
Wire Wire Line
	3250 1650 3250 1950
$EndSCHEMATC
