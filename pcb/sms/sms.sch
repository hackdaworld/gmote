EESchema Schematic File Version 4
LIBS:sms-cache
EELAYER 26 0
EELAYER END
$Descr User 6693 5118
encoding utf-8
Sheet 1 1
Title "Soil Mositure Sensor"
Date "2019-05-23"
Rev "1.0"
Comp "DigiDev"
Comment1 "https://digidev.de/gmote"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74xx:74HC14 U1
U 1 1 5CE46C5E
P 3200 1650
F 0 "U1" H 3200 1967 50  0000 C CNN
F 1 "74HC14" H 3200 1876 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3200 1650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 3200 1650 50  0001 C CNN
	1    3200 1650
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 2 1 5CE46CFA
P 3900 1650
F 0 "U1" H 3900 1967 50  0000 C CNN
F 1 "74HC14" H 3900 1876 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3900 1650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 3900 1650 50  0001 C CNN
	2    3900 1650
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 3 1 5CE46D95
P 4600 1650
F 0 "U1" H 4600 1967 50  0000 C CNN
F 1 "74HC14" H 4600 1876 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 4600 1650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 4600 1650 50  0001 C CNN
	3    4600 1650
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 4 1 5CE46E11
P 3200 2350
F 0 "U1" H 3200 2667 50  0000 C CNN
F 1 "74HC14" H 3200 2576 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3200 2350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 3200 2350 50  0001 C CNN
	4    3200 2350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 5 1 5CE46E9A
P 3900 2350
F 0 "U1" H 3900 2667 50  0000 C CNN
F 1 "74HC14" H 3900 2576 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3900 2350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 3900 2350 50  0001 C CNN
	5    3900 2350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 6 1 5CE46EEE
P 4600 2350
F 0 "U1" H 4600 2667 50  0000 C CNN
F 1 "74HC14" H 4600 2576 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 4600 2350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 4600 2350 50  0001 C CNN
	6    4600 2350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U1
U 7 1 5CE46F61
P 1500 2400
F 0 "U1" H 1730 2446 50  0000 L CNN
F 1 "74HC14" H 1730 2355 50  0000 L CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1500 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 1500 2400 50  0001 C CNN
	7    1500 2400
	1    0    0    -1  
$EndComp
Text GLabel 1600 1300 2    50   Input ~ 0
VCC
Text GLabel 1600 1400 2    50   Input ~ 0
GND
Text GLabel 1600 1200 2    50   Input ~ 0
OUT
Text GLabel 1500 1900 1    50   Input ~ 0
VCC
Text GLabel 1500 2900 3    50   Input ~ 0
GND
$Comp
L Device:C C1
U 1 1 5CE47B78
P 2250 2400
F 0 "C1" H 2365 2446 50  0000 L CNN
F 1 "10u" H 2365 2355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 2288 2250 50  0001 C CNN
F 3 "~" H 2250 2400 50  0001 C CNN
	1    2250 2400
	1    0    0    -1  
$EndComp
Text GLabel 2250 2250 1    50   Input ~ 0
VCC
Text GLabel 2250 2550 3    50   Input ~ 0
GND
$Comp
L Connector:Conn_01x03_Male J1
U 1 1 5CE481D5
P 1400 1300
F 0 "J1" H 1506 1578 50  0000 C CNN
F 1 "Conn_01x03_Male" H 1506 1487 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 1400 1300 50  0001 C CNN
F 3 "~" H 1400 1300 50  0001 C CNN
	1    1400 1300
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5CE48323
P 3200 1200
F 0 "R1" V 2993 1200 50  0000 C CNN
F 1 "100k" V 3084 1200 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 3130 1200 50  0001 C CNN
F 3 "~" H 3200 1200 50  0001 C CNN
	1    3200 1200
	0    1    1    0   
$EndComp
Text GLabel 4250 1400 1    50   Input ~ 0
OSC2
Text GLabel 5300 1650 2    50   Input ~ 0
OUT
Text GLabel 2700 1450 0    50   Input ~ 0
OSC1
Wire Wire Line
	2900 1650 2800 1650
Wire Wire Line
	2800 1200 3050 1200
Wire Wire Line
	2800 1200 2800 1450
Wire Wire Line
	3500 1650 3550 1650
Wire Wire Line
	3550 1200 3350 1200
NoConn ~ 3500 2350
NoConn ~ 4200 2350
NoConn ~ 4900 2350
Wire Wire Line
	2700 1450 2800 1450
Connection ~ 2800 1450
Wire Wire Line
	2800 1450 2800 1650
Wire Wire Line
	3550 1200 3550 1650
Wire Wire Line
	3550 1650 3600 1650
Connection ~ 3550 1650
Wire Wire Line
	4200 1650 4250 1650
Wire Wire Line
	4250 1400 4250 1650
Connection ~ 4250 1650
Wire Wire Line
	4250 1650 4300 1650
Wire Wire Line
	4900 1650 4950 1650
$Comp
L Device:R R2
U 1 1 5CE5D073
P 5100 1650
F 0 "R2" V 4893 1650 50  0000 C CNN
F 1 "100" V 4984 1650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 5030 1650 50  0001 C CNN
F 3 "~" H 5100 1650 50  0001 C CNN
	1    5100 1650
	0    1    1    0   
$EndComp
Wire Wire Line
	5250 1650 5300 1650
Text GLabel 2900 2550 3    50   Input ~ 0
GND
Text GLabel 3600 2550 3    50   Input ~ 0
GND
Text GLabel 4300 2550 3    50   Input ~ 0
GND
Wire Wire Line
	4300 2350 4300 2550
Wire Wire Line
	3600 2350 3600 2550
Wire Wire Line
	2900 2350 2900 2550
$EndSCHEMATC
