/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#include <assert.h>
#include <string.h>

#include "sysinit/sysinit.h"
#include "os/os.h"

#include "bsp/bsp.h"
#include "hal/hal_gpio.h"
#include "hal/hal_spi.h"

#include "node/lora_priv.h"
#include "node/lora.h"

#include "console/console.h"
#include "hal/hal_uart.h"

#ifdef ARCH_sim
#include "mcu/mcu_sim.h"
#endif

#define LORA_TX_OUTPUT_POWER		14	/* dBm */
#define LORA_BANDWIDTH			0	/* 0=125 kHz, ... 2=500 kHz */
#define LORA_SPREADING_FACTOR		7	/* SF7 - SF 12 */
#define LORA_CODING_RATE		1	/* 1 = 4/5, ... 4 = 4/8 */
#define LORA_PREAMBLE_LENGTH		8
#define LORA_SYMBOL_TIMEOUT		5
#define LORA_FIX_LENGTH_PAYLOAD		false
#define LORA_CRC			true
#define LORA_FREQUENCY_HOPPING		0
#define LORA_FREQUENCY_HOPPING_PERIOD	0
#define LORA_IQ_INVERSION		false
#define LORA_TX_TIMEOUT			3000	/* ms */
#define LORA_RX_TIMEOUT			1000	/* ms */
#define LORA_CONTINUOUS_RECEIVE		true
#define LORA_BUFFER_SIZE		64

uint8_t lora_dev_eui[] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
uint8_t lora_app_eui[] = {0x23, 0x42, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
uint8_t lora_app_key[] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                          0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};



// lora callbacks
void
gmote_join_cb(LoRaMacEventInfoStatus_t stat, uint8_t att)
{
	console_printf("Joined: status=%d, attempts=%u\n", stat, att);
}
void
gmote_link_check_cb(LoRaMacEventInfoStatus_t stat, uint8_t ngw, uint8_t dm)
{
	console_printf("Link check: status=%d, #GWs=%u, demod_margin=%u\n",
	              stat, ngw, dm);
}

/*
 * main
 *
 */

int
main(int argc, char **argv)
{
    int rc;

#ifdef ARCH_sim
    mcu_sim_parse_args(argc, argv);
#endif

    sysinit();

    /*
     * LoRa
     */

    /*
    RadioEvents_t radio_events;
    
    // radio
    radio_events.TxDone = on_tx_done;
    Radio.Init(&radio_events);

    // frequency
    Radio.SetChannel(868000000);

    // tx and rx config
    Radio.SetTxConfig(MODEM_LORA,
                      LORA_TX_OUTPUT_POWER,
		      0,
                      LORA_BANDWIDTH,
                      LORA_SPREADING_FACTOR,
                      LORA_CODING_RATE,
                      LORA_PREAMBLE_LENGTH,
                      LORA_FIX_LENGTH_PAYLOAD,
		      LORA_CRC,
		      LORA_FREQUENCY_HOPPING,
		      LORA_FREQUENCY_HOPPING_PERIOD,
		      LORA_IQ_INVERSION,
		      LORA_TX_TIMEOUT);

    Radio.SetRxConfig(MODEM_LORA,
                      LORA_BANDWIDTH,
                      LORA_SPREADING_FACTOR,
                      LORA_CODING_RATE,
		      0,
                      LORA_PREAMBLE_LENGTH,
                      LORA_SYMBOL_TIMEOUT,
                      LORA_FIX_LENGTH_PAYLOAD,
		      0,
		      LORA_CRC,
		      LORA_FREQUENCY_HOPPING,
		      LORA_FREQUENCY_HOPPING_PERIOD,
		      LORA_IQ_INVERSION,
		      LORA_CONTINUOUS_RECEIVE);
    */


    /* join callback */
    lora_app_set_join_cb(gmote_join_cb);

    /* link check callback */
    lora_app_set_link_check_cb(gmote_link_check_cb);

    memcpy(g_lora_dev_eui,lora_dev_eui,8);
    memcpy(g_lora_app_key,lora_app_key,16);
    memcpy(g_lora_app_eui,lora_app_eui,8);

    console_printf("GMote on ARM\n");

    rc=lora_app_join(g_lora_dev_eui, g_lora_app_eui, g_lora_app_key, 5);
    if(rc) {
	    console_printf("Join failed: err=%d\n", rc);
    }
    else {
	    console_printf("Joining ...\n");
    }

    int cnt=0;
    char *str="FooBar!";
    char *ptr;

    while (1) {
        /* Wait one second */
        os_time_delay(OS_TICKS_PER_SEC);

        /* hello world */
	console_printf("Hello World! %d\n",cnt);
	ptr=&str[0];
	while(*ptr)
		hal_uart_blocking_tx(1,*ptr++);
	hal_uart_blocking_tx(1,'\n');
	hal_uart_blocking_tx(1,'\r');

	cnt++;
    }
    assert(0);

    return rc;
}

