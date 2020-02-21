# GMote
[GMote](https://digidev.de/gmote) - The Generic LoRaWAN Node

GMote stands for Generic Mote.
It is meant to be a flexible (i.e. applicable in different scenarios for different purposes utilizing different sensors) IoT Node using the LoRa wireless data communication technology. 

![The first GMote test version](https://www.digidev.de/gmote/img/pcb_ics_web02.jpg)

The first test version was based on the Arduino Pro Mini, which requires very low power if you remove the LED and bypass the power regulator.
Once this proved to be a good idea, a slim version of the Mini Pro board (i.e. the ATMega 328P) has been integrated and routed on the GMote circuit board.
At first, the Dragino LoRa Bee was the transceiving unit since we had good results with respect to range and usability.
In later versions, the relevant HopeRF modem (RFM95) chip was likewise integrated on the board due to availability and price. 

There are two PCB versions, a small and a mini version, which provide different amount of pin headers to connect various sensors or even actuators. 
Development of an ARM Cortex M0 based version will start soon.

The node is configurable via UART and LoRaWAN download frames.
It started within the Arduino framework and tries to stay compatible to not loose the huge developer community.
However, to experience and share the beauty and simplicity of AVR programming and to gain flexibility, a pure AVR GCC port is planned as soon as possible.

## Most important

GMote is meant to become an all-purpose LoRaWAN node (and in fact a whole eco system).
Moreover, the design, hardware, firmware and software of the GMote project is open source and free to use without any restriction.
To enable everyone to participate, everything is kept as simple as possible, ranging from the low-level PCB design and firmware up to the high-level IoT platform app.

Since it aims to become a project for a hopefully huge community, let the GMote developers know what you think about it, about problems that occured, additional features that you require and everything you would like to have different in the current realization. 
Anything on your mind?
Maybe to remove the RTC in favor of the internal watchdog timer to make the board even more simple (thereby accepting some inaccuracy in the periodicity of frames)? 
No I2C pinout or at least another version without?
A voltage regulator for a well defined supply but a shorter battery lifetime in return?
Whatever it is, let us know!

## Requirements

* ISP programmer, e.g. the [Pocket AVR Programmer](https://www.digikey.de/product-detail/de/sparkfun-electronics/PGM-09825/1568-1080-ND/5230949), to upload the firmware or an optional Arduino bootloader as you please.
* USB to serial converter (3.3V), e.g. the [FT231X Breakout](https://www.digikey.de/product-detail/de/sparkfun-electronics/BOB-13263/1568-1720-ND/7675364) for optionally uploading the firmware the Arduino way (via boot loader) and for serial communication and configuration. Strictly speaking, this is not required, since you could configure the node (i.e. program the EEPROM) via ISP. However, it is strongly suggested!
* A board (see below) produced by your favorite PCB manufacturer.
* The parts listed in the respective bill of materials.
* Soldering iron and solder.

## Hardware

### PCB

![Small and mini version of the GMote LoRaWAN node](https://www.digidev.de/gmote/img/pcb_small_min_web03.jpg)

There are currently two versions (small and mini) of the GMote LoRaWAN node.
You can find the available PCBs in the respective [PCB](pcb) directory
together with further details as well as the bill of materials and respective [DigiKey](https://www.digikey.de/) part numbers.

The boards are designed with [KiCad](http://kicad-pcb.org/).
A lot of PCB manufacturers directly support the KiCad PCB files.

The size of the SMD parts was chosen to be 0805 (2012) and hand soldering pads were used for the resistors and capacitors so you can DIY at home with a low cost soldering iron.
Caution: Patience required!

### Battery

The popular JST connector is used to connect the battery.
It is directly wired to VCC of the used ICs, no voltage regulator no polarity protection diodes!
Thus, be extremely careful when connecting your power supply.

GMote runs nicely with 3.7V LiPo batteries.
Higher voltages were not tested, so don't use higher voltages!
If you don't use the moisture or ultrasound distance sensor (these seem to require more than 3.3V), you can even run it with two AA(A) batteries (3V) or even accus (~2.8V).

## Firmware

### AVR Mega328PB

So far, you need the [Arduino IDE](https://www.arduino.cc/en/Main/Software) to build the firmware.
Moreover, the [LMIC library](https://github.com/matthijskooijman/arduino-lmic) is currently used to implement LoRaWAN.
Please follow the [instructions](https://github.com/matthijskooijman/arduino-lmic/#Installing) to include this library in your Arduino IDE.

Now you can build the firmware from the Arduino Sketch. 
[./firmware/m328pb.ino](./firmware/m328pb.ino)
Comment or uncomment the line
```c
#define PCB_MINI
```
in the very beginning of the sketch as required.

Alternatively, feel free to use one of the precompiled binaries.
Mini: [./firmware/m328pb_mini.hex](firmware/m328pb_mini.hex) (recommended)
Small: [./firmware/m328pb_small.hex](firmware/m328pb_small.hex) (recommended)

Since you build a GMote device from scratch, you start with a plain Atmega328P without an installed Arduino bootloader.
Use the ISP programmer and the [avrdude](https://www.nongnu.org/avrdude/) software to program either an optional Arduino bootloader or upload the GMote firmware directly.
To upload the firmware directly using the Pocket AVR Programmer, do:
```
avrdude -patmega328pb -cusbtiny -v -Uflash:w:<b>/path/to/m328pb_mini.hex</b>:i
```
and for disablinge the clock divider
```
avrdude -patmega328pb -cusbtiny -v -Ulfuse:w:0xe2:m
```

All files can be found in the [firmware](firmware) location. 

## Sensors

Next to the very basic digital input sensing and ADC meassurements on the availabe IO and ADC pins, there are a couple of other sensors which require a slightly more special treatment.
At the moment, these are the ultrasound distance and the capacitive soil moisture sensor.

![Soil moisture and ultrasound distance sensor](https://www.digidev.de/gmote/img/sensors.jpg)

## Utils and configuration

The GMote device is configured via the serial interface utilizing the USB to serial converter.
you can find the source code as well as installation and usage instructions in the [utils](utils) directory.

## Cases

To cover GMote and its sensors, a case was designed using [OpenSCAD](http://www.openscad.org/).
At the moment, the ultrasound distance and capacative moisture sensors are considered.

![GMote Cases and sensors for illustration](https://www.digidev.de/gmote/img/mini_900_showcase.png)

The image illustrates the idea of the case and sensors.
Details and files can be found in the [cases](cases) directory.

## Backend 

ToDo

## Software 

ToDo
