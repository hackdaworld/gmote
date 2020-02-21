/*******************************************************************************
   
   GMote - Generic LoRaWAN Node

   Author: frank@hackdaworld.org
   HTTP: https://digidev.de/gmote

   Based on the OTAA TTN example sketch of the lmic Arduino library.
   
 *******************************************************************************/

#include <lmic.h>
#include <hal/hal.h>
#include <SPI.h>

#include <avr/boot.h>
#include <EEPROM.h>

#include <avr/sleep.h>
#include <avr/wdt.h>

#include <Wire.h>

#define MST_DD_VCC  A0
#define MST_DD_OUT  A1

#define PCB_MINI

#ifdef PCB_MINI
  // PCB Mini
  #define LORA_RST  5
  #define US_ECHO   A0
  #define US_TRIG   A1
  #define US_VCC    A2
#else
  // PCB Small
  #define LORA_RST  3
  #define US_ECHO   4
  #define US_TRIG   5
  #define US_VCC    6
#endif

//
// LMIC LoRaWAN stuff
//

// little endian AppEUI
// For TTN issued EUIs the last bytes should be 0xD5, 0xB3, 0x70.
uint8_t APPEUI[8];
#define EEPROM_OFFSET_APPEUI 8
void os_getArtEui (u1_t* buf) {
  for(uint8_t i=0;i<8;i++)
    buf[i]=APPEUI[7-i];
}

// little endian DevEUI
uint8_t DEVEUI[8];
#define EEPROM_OFFSET_DEVEUI 0 
void os_getDevEui (u1_t* buf) {
  for(uint8_t i=0;i<8;i++)
    buf[i]=DEVEUI[7-i];
}

// big endian application key
uint8_t APPKEY[16];
#define EEPROM_OFFSET_APPKEY 16
void os_getDevKey (u1_t* buf) {
  memcpy(buf, APPKEY, 16);
}

// data
static uint8_t data[32];
static uint8_t data_old[32];

// memory for the sendjob function
static osjob_t sendjob;

// Pin mapping
const lmic_pinmap lmic_pins = {
  .nss = 10,
  .rxtx = LMIC_UNUSED_PIN,
  .rst = LORA_RST,
  .dio = {8, 9, LMIC_UNUSED_PIN},
};

//
// GMote configuration & state machine
//

// Serial
uint8_t serGM[10];

// GMote configuration
uint8_t confGM[8];
#define EEPROM_OFFSET_CONFGM 32

/* byte:  7       6    5    4           3           2                    1    0
 *        custom  rfu  rfu  keep alive  sleep time  temperature offeset  rfu  type
 *        
 * rfu: reserved for future use
 * custom: whatever you require
 */

#define SENSOR_TYPE           0
#define TEMP_OFFSET           2
#define SLEEP_TIME            3
#define KEEP_ALIVE            4
#define CUSTOM                7

#define SENSORS_EXT           0
#define SENSOR_ULTRASONIC     0x01
#define SENSOR_IO             0x02
#define SENSOR_LOUDNESS       0x04
#define SENSOR_MOISTURE       0x08
#define SENSOR_MOISTURE_ADC   0x10

#define SENSORS_INT           1
#define SENSOR_BAT_ADC        0x01
#define SENSOR_BAT_TEMP       0x02

// GMote states
uint8_t state=1;
#define STARTUP 1
#define RTC_INITIALIZED 2
#define SENDING 3  
#define STARTUP_DELAY 2000
uint8_t keep_alive=0;
uint8_t keep_alive_cnt=0;

// rtc timer
#define RTC_I2C_ADDR 0x51
#define RTC_ADDR_CS2 0x01
#define RTC_CS2 0x11 // pulsed timer interrupt enabled, timer interrupt enabled, timer flag cleared 
#define RTC_ADDR_TC 0x0e
#define RTC_TC 0x83 // timer enabled & src clock freq 1/60 hz (minute)
uint8_t rtc_t = 1; // timer counter, default 1 (minute)

// Serial communication
uint8_t inSerBuf[36];
uint8_t inSerCnt = 0;

// LMIC callbacks
void onEvent (ev_t ev) {
  Serial.print(os_getTime());
  Serial.print(": ");
  switch (ev) {
    case EV_SCAN_TIMEOUT:
      Serial.println(F("EV_SCAN_TIMEOUT"));
      break;
    case EV_BEACON_FOUND:
      Serial.println(F("EV_BEACON_FOUND"));
      break;
    case EV_BEACON_MISSED:
      Serial.println(F("EV_BEACON_MISSED"));
      break;
    case EV_BEACON_TRACKED:
      Serial.println(F("EV_BEACON_TRACKED"));
      break;
    case EV_JOINING:
      Serial.println(F("EV_JOINING"));
      break;
    case EV_JOINED:
      Serial.println(F("EV_JOINED"));
      // Disable link check validation (automatically enabled
      // during join, but not supported by TTN at this time).
      LMIC_setLinkCheckMode(0);
      break;
    case EV_RFU1:
      Serial.println(F("EV_RFU1"));
      break;
    case EV_JOIN_FAILED:
      Serial.println(F("EV_JOIN_FAILED"));
      break;
    case EV_REJOIN_FAILED:
      Serial.println(F("EV_REJOIN_FAILED"));
      break;
    case EV_TXCOMPLETE:
      Serial.println(F("EV_TXCOMPLETE"));
      if (LMIC.txrxFlags & TXRX_ACK)
        Serial.println(F("Received ack"));
      if (LMIC.dataLen) {
        Serial.println(F("Received "));
        Serial.println(LMIC.dataLen);
        Serial.println(F(" bytes of payload"));
        // new config
        if(LMIC.dataLen!=8) {
          Serial.println(F("Wrong payload length, doing nothing!"));
        }
        else {
          Serial.print(F("New configuration: "));
          for(uint8_t i=0;i<8;i++) {
            confGM[i]=LMIC.frame[LMIC.dataBeg+i];
            EEPROM.write(EEPROM_OFFSET_CONFGM+i,confGM[i]);
            Serial.print(confGM[i],HEX);
          }
          Serial.println();
          bitClear(state,RTC_INITIALIZED);
        }
      }
      
      // Schedule next transmission
      rtc_t = confGM[SLEEP_TIME];
      if(rtc_t == 0) {
        Serial.println(F("Immediate action ..."));
        do_send(&sendjob);
      }
      // initial rtc setup
      if(!(state&bit(RTC_INITIALIZED)))
        rtc_setup();

      // GMote state
      bitClear(state,SENDING);

      break;
    case EV_LOST_TSYNC:
      Serial.println(F("EV_LOST_TSYNC"));
      break;
    case EV_RESET:
      Serial.println(F("EV_RESET"));
      break;
    case EV_RXCOMPLETE:
      // data received in ping slot
      Serial.println(F("EV_RXCOMPLETE"));
      break;
    case EV_LINK_DEAD:
      Serial.println(F("EV_LINK_DEAD"));
      break;
    case EV_LINK_ALIVE:
      Serial.println(F("EV_LINK_ALIVE"));
      break;
    default:
      Serial.println(F("Unknown event"));
      break;
  }
  // enter_sleep
  if(!(state&bit(SENDING)))
    enter_sleep();    
}

// LMIC send function
void do_send(osjob_t* j) {
  // Check if there is not a current TX/RX job running
  if (LMIC.opmode & OP_TXRXPEND) {
    Serial.println(F("OP_TXRXPEND, not sending"));
  } else {
    uint8_t datalen;
    // sensor config
    data[0]=confGM[SENSORS_EXT];
    datalen=1;

    // external sensor data
    
    if(confGM[SENSORS_EXT]&SENSOR_ULTRASONIC) {
      *((uint16_t *)(data+datalen))=us();
      datalen+=2;      
    }
    if(confGM[SENSORS_EXT]&SENSOR_IO) {
      data[datalen]=io();
      datalen+=1;
    }
    if(confGM[SENSORS_EXT]&SENSOR_LOUDNESS) {
      data[datalen]=loudness();
      datalen+=1;
    }
    if(confGM[SENSORS_EXT]&SENSOR_MOISTURE) {
      //data[datalen]=moisture();
      data[datalen]=moisture_dd();
      datalen+=1;
    }
    if(confGM[SENSORS_EXT]&SENSOR_MOISTURE_ADC) {
      *((uint16_t *)(data+datalen))=moisture_analog();
      datalen+=2;
    }

    // internal sensors (bat & temp)

    data[datalen]=adc_bat();
    datalen+=1;
    data[datalen]=adc_temp();
    datalen+=1;

    keep_alive_cnt+=1;  
    if(memcmp(data_old,data,datalen-2) || keep_alive_cnt>=keep_alive) {
      // new data
      // reset keep alive counter
      keep_alive_cnt=0;
      // copy data
      memcpy(data_old,data,datalen-2);
      // Prepare upstream data transmission at the next possible time
      bitSet(state,SENDING);
      LMIC_setTxData2(1, data, datalen, 0);
      Serial.println(F("Packet queued"));
    }
    else {
      Serial.println(F("Old data"));
      enter_sleep();
    }
 
  }
}

void rtc_setup() {
  uint8_t result;
  Serial.print(F("RTC setup - control status 2: "));
  Wire.begin();
  Wire.beginTransmission(RTC_I2C_ADDR);
  Wire.write(RTC_ADDR_CS2);
  Wire.write(RTC_CS2);
  result = Wire.endTransmission();
  Serial.println(result);
  Serial.print(F("RTC setup - timer control (rtc_t="));
  Serial.print(rtc_t);
  Serial.print(F("): "));
  Wire.begin();
  Wire.beginTransmission(RTC_I2C_ADDR);
  Wire.write(RTC_ADDR_TC);
  Wire.write(RTC_TC);
  Wire.write(rtc_t);
  result = Wire.endTransmission();
  Serial.println(result);
  bitSet(state,RTC_INITIALIZED);
}

// external sensors

uint8_t io() {
  // io: 5 = vcc, 6 = input
  pinMode(5,INPUT);
  pinMode(6,OUTPUT);
  // apply voltage
  digitalWrite(6,HIGH);
  delay(50);
  uint8_t in = digitalRead(5);
  // shut down voltage
  digitalWrite(6,LOW);
  Serial.print(F("IO: "));
  Serial.println(in,HEX);
  return(in);  
}

uint16_t us() {
  // io: echo = 4, trigger = 5, vcc = 6
  pinMode(US_VCC,OUTPUT);
  pinMode(US_TRIG,OUTPUT);
  pinMode(US_ECHO,INPUT);
  // power us sensor
  digitalWrite(US_VCC,HIGH);
  delay(200);
  // reset / trigger sensor
  digitalWrite(US_TRIG,LOW);
  delayMicroseconds(5);
  digitalWrite(US_TRIG,HIGH);
  delayMicroseconds(10);
  digitalWrite(US_TRIG,LOW);
  // count high time
  unsigned long pulse=pulseIn(US_ECHO,HIGH);
  digitalWrite(US_VCC,LOW);
  if(pulse>65535)
    pulse=0;
  Serial.print(F("US: "));
  Serial.println(pulse);
  return(pulse&0xffff);
}

uint8_t loudness() {
  // power on sensor
  pinMode(A3,OUTPUT);
  digitalWrite(A3,HIGH);
  delay(500);
  uint16_t mean=0;
  Serial.print("DBG: ");
  for(uint8_t i=0; i<4; i++) {
    mean+=analogRead(A1);
    Serial.print(mean);
    Serial.print(" ");
    delay(100); 
  }
  uint8_t loudness=mean>>2;
  // power down
  digitalWrite(A3,LOW);
  Serial.print(F("L: "));
  Serial.println(loudness);
  return loudness; 
}

uint8_t moisture () {
  pinMode(6,OUTPUT);
  pinMode(5,INPUT);
  digitalWrite(6,HIGH);
  TCCR1A = 0;
  TCNT1 = 0;            // Reset Counter
  delay(10);            // Delay for stable channel selection
  bitSet(TCCR1B, CS12); // Select counter clock
  bitSet(TCCR1B, CS11); // Count on rising edge
  delay(100);           // Count for 50mS
  TCCR1B = 0;           // Stop counting
  digitalWrite(6,LOW);
  uint16_t tc=TCNT1;
  Serial.print(F("M: "));
  Serial.println(tc);
  uint8_t moisture=tc>>8;
  return moisture;
}

uint8_t moisture_dd() {
  // make it an input (again)
  pinMode(MST_DD_OUT,INPUT_PULLUP);
  delay(50);
  pinMode(MST_DD_VCC,OUTPUT);
  digitalWrite(MST_DD_VCC,HIGH);
  delay(200);
  uint8_t moisture=pulseIn(MST_DD_OUT,LOW);
  digitalWrite(MST_DD_VCC,LOW);
  Serial.print(F("M_DD: "));
  Serial.println(moisture);
  // maybe current flows via pullup -> mode output, low
  delay(50);
  pinMode(MST_DD_OUT,OUTPUT);
  digitalWrite(MST_DD_OUT,LOW);
  return moisture;
}

uint16_t moisture_analog() {
  uint16_t ar;
  uint8_t oldADMUX = ADMUX;

  // enable ADC
  ADCSRA |= (1 << ADEN);
  // refs1/0 => 01 (use vcc as a reference), mux3/2/1/0 => 0001 (ADC1)
  ADMUX = (0 << REFS1) | (1 << REFS0) | (0 << ADLAR) | (0 << MUX3) | (0 << MUX2) | (0 << MUX1) | (1 << MUX0);

  pinMode(A0,OUTPUT);
  pinMode(A1,INPUT);
  digitalWrite(A0,HIGH);
  delay(200);

  ar=0;
  for(uint8_t i=0;i<3;i++) {
    ADCSRA |= (1 << ADSC);
    while (((ADCSRA & (1 << ADSC)) != 0));
    // skip first conversion
    if(i>0) ar+=ADC;
  }
  
  digitalWrite(A0,LOW);

  // mean of remaining 2 samples
  ar=ar>>1;
   
  ADMUX = oldADMUX;
  
  Serial.print(F("M_A HV: "));
  Serial.println(ar);

  return ar;
}

// internal sensors

uint8_t adc_bat() {
  uint16_t val;
  uint16_t tmp;
  uint8_t oldADMUX = ADMUX;

  // enable ADC
  ADCSRA |= (1 << ADEN);
  // refs1/0 => 01 (use vcc as a reference), mux3/2/1/0 => 1110 (1.1v endpoint)
  ADMUX = (0 << REFS1) | (1 << REFS0) | (0 << ADLAR) | (1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (0 << MUX0);
  delay(20); // settle

  tmp=0;
  for(uint8_t i=0;i<3;i++) {
    ADCSRA |= (1 << ADSC);
    while (((ADCSRA & (1 << ADSC)) != 0));
    // skip first conversion
    if(i>0) tmp+=ADC;
  }
  // mean of remaining 2 samples
  tmp=tmp>>1;
   
  // v_endpoint = adc / 1023 * v_ref, v_ref = vcc, v_endpoint = 1.1 => vcc = 1.1 * 1023 / adc
  val = ((1100L * 1023)/tmp);
  uint8_t result = val>>5;
  ADMUX = oldADMUX;
  Serial.print(F("BAT ADC: "));
  Serial.print(val);
  Serial.print(F(" / "));
  Serial.println(result);
  return result;
}

uint8_t adc_temp() {
  uint8_t oldADMUX = ADMUX;
  uint16_t tmp;
  // enable ADC
  //ADCSRA |= (1 << ADEN);
  // refs1/0 => 11 (internal 1.1v as a reference), mux3/2/1/0 => 1000 (temperature sensor endpoint)
  ADMUX = (1 << REFS1) | (1 << REFS0) | (0 << ADLAR) | (1 << MUX3) | (0 << MUX2) | (0 << MUX1) | (0 << MUX0);
  delay(20);
  tmp=0;
  for(uint8_t i=0;i<3;i++) {
    ADCSRA |= (1 << ADSC);
    while (((ADCSRA & (1 << ADSC)) != 0));
    // skip first conversion
    if(i>0) tmp+=ADC;
  }
  // mean of remaining 2 samples
  tmp=tmp>>1;
  uint8_t result = (uint8_t)(tmp-335);
  ADMUX = oldADMUX;
  Serial.print(F("TEMP ADC: "));
  if(confGM[TEMP_OFFSET]==0xff) {
    Serial.println(result);
    return result;
  }
  else {
    Serial.print(result);
    Serial.print(F(" / "));
    Serial.println(result+confGM[TEMP_OFFSET]);
    return result+confGM[TEMP_OFFSET];
  }
}

//
// setup
//

void setup() {
  Serial.begin(9600);
  Serial.print(F("MCUSR: ")); Serial.println(MCUSR,HEX);
  Serial.println(F("GMote startup"));

  Serial.print(F("FW version: "));
  #ifdef PCB_MINI
  Serial.println(F("MINI"));
  #else
  Serial.println(F("SMALL"));
  #endif

  bool virgin=true;
  uint8_t i;

  // External interrupt 0
  pinMode(2,INPUT_PULLUP);  
  
  // Serial
  Serial.print(F("Serial:"));
  for(i=0;i<10;i++) {
    Serial.print(F(" "));
    serGM[i] = boot_signature_byte_get(i+14);
    Serial.print(serGM[i],HEX);
  }
  Serial.println();

  // DevEUI
  Serial.print(F("DevEUI:"));
  for(i=0;i<8;i++) {
    DEVEUI[i]=EEPROM.read(EEPROM_OFFSET_DEVEUI+i);
    Serial.print(F(" "));
    Serial.print(DEVEUI[i],HEX);
    if(DEVEUI[i]!=0xff)
      virgin=false;
  }
  Serial.println(F(""));
  if(virgin) {
    Serial.println(F("Virgin GMote DevEUI detected!"));
    Serial.print(F("Setting default DevEUI to:"));
    for(i=0;i<8;i++) {
      DEVEUI[i]=serGM[i+2];
      EEPROM.write(EEPROM_OFFSET_DEVEUI+i,serGM[i+2]);
      Serial.print(F(" "));
      Serial.print(DEVEUI[i],HEX);
    }
    Serial.println();
  }

  // AppEUI
  virgin=true;
  Serial.print(F("AppEUI:"));
  for(i=0;i<8;i++) {
    APPEUI[i]=EEPROM.read(EEPROM_OFFSET_APPEUI+i);
    Serial.print(F(" "));
    Serial.print(APPEUI[i],HEX);
    if(APPEUI[i]!=0xff)
      virgin=false;
  }
  Serial.println();
  if(virgin) {
    Serial.println(F("Virgin AppEUI detected!"));
    Serial.print(F("Setting default AppEUI to:"));
    for(i=0;i<8;i++) {
      APPEUI[i]=i;
      EEPROM.write(EEPROM_OFFSET_APPEUI+i,APPEUI[i]);
      Serial.print(F(" "));
      Serial.print(APPEUI[i],HEX);
    }
    Serial.println(F(""));
  }

  // AppKey
  virgin=true;
  Serial.print(F("AppKey:"));
  for(i=0;i<16;i++) {
    APPKEY[i]=EEPROM.read(EEPROM_OFFSET_APPKEY+i);
    Serial.print(F(" "));
    Serial.print(APPKEY[i],HEX);
    if(APPKEY[i]!=0xff)
      virgin=false;
  }
  Serial.println(F(""));
  if(virgin) {
    Serial.println(F("Virgin AppKey detected!"));
    Serial.print(F("Setting default AppKey to:"));
    for(i=0;i<16;i++) {
      APPKEY[i]=i;
      EEPROM.write(EEPROM_OFFSET_APPKEY+i,APPKEY[i]);
      Serial.print(F(" "));
      Serial.print(APPKEY[i],HEX);
    }
    Serial.println(F(""));
  }
  
  // ConfGM
  virgin=true;
  Serial.print(F("ConfGM:"));
  for(i=0;i<8;i++) {
    confGM[i]=EEPROM.read(EEPROM_OFFSET_CONFGM+i);
    Serial.print(F(" "));
    Serial.print(confGM[i],HEX);
    if(confGM[i]!=0xff)
      virgin=false;
  }
  Serial.println();
  if(virgin) {
    Serial.println(F("Virgin GMote config detected!"));
    Serial.print(F("Setting default config to:"));
    for(i=0;i<8;i++) {
      confGM[i]=0;
      EEPROM.write(EEPROM_OFFSET_CONFGM+i,confGM[i]);
      Serial.print(F(" "));
      Serial.print(confGM[i],HEX);
    }
    Serial.println(F(""));
  }

  // GMote state
  state = 0;
  bitSet(state,STARTUP);
  keep_alive_cnt=0;
  keep_alive=confGM[KEEP_ALIVE];

  // LMIC init
  os_init();
  // Reset the MAC state.
  LMIC_reset();

  // Let LMIC compensate for +/- 1% clock error --- required for the 8 MHz Mini Pro
  LMIC_setClockError(MAX_CLOCK_ERROR * 1 / 100);
}

void loop() {

  os_runloop_once();

  if(!(state&bit(STARTUP))) {
    if(!(state&bit(SENDING))) {
      do_send(&sendjob);
    }
  }
  else {
    Serial.println(F("Startup, ready for UART configuration ... "));
    delay(STARTUP_DELAY);
    bitClear(state,STARTUP);
  }

}

void process_uart_cmd() {

  uint8_t eeprom_offset=0;
  uint8_t *ram_ptr;
  uint8_t len;
  uint8_t i=0;
  uint8_t sc=0;
  
  Serial.print(F("S:"));
  for(int i=0;i<inSerCnt;i++) {
    Serial.print(F(" "));
    Serial.print(inSerBuf[i],HEX);
  }
  Serial.println();
  if(inSerCnt<2) {
    Serial.println(F("Command too short!"));
    inSerCnt=0;
    return;
  }

  sc=1;
  while(sc<inSerCnt) {
    
    switch(inSerBuf[sc]) {
      case 'd':
        Serial.print(F("DevEUI"));
        eeprom_offset=0;
        ram_ptr=DEVEUI;
        len=8;
        break;
      case 'a':
        Serial.print(F("AppEUI"));
        eeprom_offset=8;
        ram_ptr=APPEUI;
        len=8;
        break;
      case 'k':
        Serial.print(F("AppKey"));
        eeprom_offset=16;
        ram_ptr=APPKEY;
        len=16;
        break;
      case 'c':
        Serial.print(F("GMote Config"));
        eeprom_offset=32;
        ram_ptr=confGM;
        len=8;
        break;
      default:
        Serial.print(F("unknown command"));
        len=0;
        break;
    }
    sc+=1;
    // write to ram & eeprom
    for(i=0; i<len; i++) {
      Serial.print(F(" "));
      Serial.print(inSerBuf[i+sc],HEX);
      ram_ptr[i]=inSerBuf[i+sc];
      EEPROM.write(eeprom_offset+i,ram_ptr[i]);
    }
    sc+=len;
    Serial.println();
  
  }
  
  // reset serial counter
  inSerCnt=0;
}

void print_eeprom_content(int sAddr,int eAddr) {
  int offset=0;
  if(sAddr>=eAddr)
    return;
  Serial.println(F("EEPROM content:"));
  for(int offset=0;offset<eAddr-sAddr;) {
    if(offset%8==0) {
      Serial.print(offset);
      Serial.print(F(": "));
    }
    else {
      Serial.print(F(" "));
    }
    Serial.print(EEPROM.read(offset),HEX);
    offset+=1;
    if((offset%8==0)||(offset==eAddr-sAddr))
      Serial.println();
  }
}

void enter_sleep() {

  Serial.println(F("Sleep mode"));
  Serial.flush();
  // disable ADC
  ADCSRA=0;
  // clear various "reset" flags
  MCUSR = 0;     
  
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);  
  noInterrupts ();
  // attach int0 isr
  attachInterrupt(0,wakeup,LOW);
  sleep_enable();
  // turn off brown-out enable in software
  MCUCR = bit (BODS) | bit (BODSE);
  MCUCR = bit (BODS); 
  interrupts();
  sleep_cpu();
}

//
// interrupt routines
//
 
void serialEvent() {
  while (Serial.available()) {
    // 1xlength, 3xcmd, 2x8 (appeui & config), 1x16 (appkey)
    if(inSerCnt<36) {
      inSerBuf[inSerCnt]=(char)Serial.read();
      inSerCnt+=1;
      if(inSerCnt-1==inSerBuf[0]) {
        process_uart_cmd();
      }
    }
    else {
      Serial.println(F("Serial Buffer Overflow!"));
      process_uart_cmd();
    }
  }
}

void wakeup() {
  sleep_disable();
  detachInterrupt(0);
  Serial.println(F("Wake up!"));
}


