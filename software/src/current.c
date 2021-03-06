/* current-bricklet
 * Copyright (C) 2011-2012 Olaf Lüke <olaf@tinkerforge.com>
 *
 * current.c: Implementation of Current Bricklet messages
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "current.h"

#include "brickletlib/bricklet_entry.h"
#include "bricklib/bricklet/bricklet_communication.h"
#include "bricklib/drivers/adc/adc.h"
#include "bricklib/utility/util_definitions.h"
#include "bricklib/bricklet/bricklet_config.h"
#include "bricklib/com/i2c/i2c_eeprom/i2c_eeprom_common.h"
#include "brickletlib/bricklet_simple.h"
#include "config.h"

#define MAX_ADC_VALUE ((1  << 12) - 1)
#define MAX_VOLTAGE 3300

#define MIN_CURRENT -12500
#define MAX_CURRENT 12500

#define MIN_CURRENT_VALUE -15000
#define MAX_CURRENT_VALUE 15000

#define CURRENT_AVERAGE 100

#define SIMPLE_UNIT_CURRENT 0
#define SIMPLE_UNIT_ANALOG_VALUE 1

#define EEPROM_POSITION (I2C_EEPROM_INTERNAL_ADDRESS_PLUGIN + \
                         BRICKLET_PLUGIN_MAX_SIZE)

const SimpleMessageProperty smp[] = {
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_VALUE, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT
	{0, 0, 0}, // TYPE_CALIBRATE
	{0, 0, 0}, // TYPE_IS_OVER_CURRENT
	{SIMPLE_UNIT_ANALOG_VALUE, SIMPLE_TRANSFER_VALUE, SIMPLE_DIRECTION_GET}, // TYPE_GET_ANALOG_VALUE
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CURRENT_CALLBACK_PERIOD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT_CALLBACK_PERIOD
	{SIMPLE_UNIT_ANALOG_VALUE, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_SET}, // TYPE_SET_ANALOG_VALUE_CALLBACK_PERIOD
	{SIMPLE_UNIT_ANALOG_VALUE, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_GET}, // TYPE_GET_ANALOG_VALUE_CALLBACK_PERIOD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CURRENT_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_ANALOG_VALUE, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_ANALOG_VALUE_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_ANALOG_VALUE, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_ANALOG_VALUE_CALLBACK_THRESHOLD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_SET}, // TYPE_SET_DEBOUNCE_PERIOD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_GET}, // TYPE_GET_DEBOUNCE_PERIOD
};

const SimpleUnitProperty sup[] = {
	{current_from_analog_value, SIMPLE_SIGNEDNESS_INT, FID_CURRENT, FID_CURRENT_REACHED, SIMPLE_UNIT_ANALOG_VALUE}, // current
	{analog_value_from_mc, SIMPLE_SIGNEDNESS_UINT, FID_ANALOG_VALUE, FID_ANALOG_VALUE_REACHED, SIMPLE_UNIT_ANALOG_VALUE}, // analog value
};

const uint8_t smp_length = sizeof(smp);


void invocation(const ComType com, const uint8_t *data) {
	switch(((SimpleStandardMessage*)data)->header.fid) {
		case FID_IS_OVER_CURRENT: {
			is_over_current(com, (StandardMessage*)data);
			return;
		}

		case FID_CALIBRATE: {
			calibrate();
			return;
		}

		default: {
			simple_invocation(com, data);
			break;
		}
	}

	if(((SimpleStandardMessage*)data)->header.fid > FID_LAST) {
		BA->com_return_error(data, sizeof(MessageHeader), MESSAGE_ERROR_CODE_NOT_SUPPORTED, com);
	}
}

void calibrate(void) {
	uint32_t value = 0;

	for(uint8_t i = 0; i < 200; i++) {
		value += BA->adc_channel_get_data(BS->adc_channel);
		SLEEP_NS(100);
	}

	BC->offset = ADC_MAX_VALUE/2 - value/200;

    BA->bricklet_select(BS->port - 'a');
    BA->i2c_eeprom_master_write(BA->twid->pTwi,
                                EEPROM_POSITION,
                                (char *)&BC->offset,
                                2);
    BA->bricklet_deselect(BS->port - 'a');
}

void is_over_current(const ComType com, const StandardMessage *sm) {
	BoolMessage bm;
	bm.header        = sm->header;
	bm.header.length = sizeof(BoolMessage);
	bm.value         = PIN_OVER_CURRENT.pio->PIO_PDSR & PIN_OVER_CURRENT.mask;

	BA->send_blocking_with_timeout(&bm,
	                               sizeof(BoolMessage),
	                               com);
}

void constructor(void) {
	_Static_assert(sizeof(BrickContext) <= BRICKLET_CONTEXT_MAX_SIZE, "BrickContext too big");

	PIN_OVER_CURRENT.type = PIO_INPUT;
	PIN_OVER_CURRENT.attribute = PIO_PULLUP;
    BA->PIO_Configure(&PIN_OVER_CURRENT, 1);

	BC->over_current = false;
	BC->current_avg = 0;
	adc_channel_enable(BS->adc_channel);

    uint16_t data;

    BA->bricklet_select(BS->port - 'a');
    BA->i2c_eeprom_master_read(BA->twid->pTwi,
                               EEPROM_POSITION,
                               (char *)&data,
                               2);
    BA->bricklet_deselect(BS->port - 'a');

    if(data == 0xFFFF) {
    	BC->offset = 0;
    } else {
    	BC->offset = data;
    }

	simple_constructor();
}

void destructor(void) {
	simple_destructor();
	adc_channel_disable(BS->adc_channel);
}

int32_t analog_value_from_mc(const int32_t value) {
	return (uint16_t)BA->adc_channel_get_data(BS->adc_channel);
}

int32_t current_from_analog_value(const int32_t value) {
	int32_t new_value = value;
	if(value > MAX_ADC_VALUE/4 && value < MAX_ADC_VALUE*3/4) {
		new_value += BC->offset;
	}

	BC->current_avg_sum += new_value;

	if(BC->tick % CURRENT_AVERAGE == 0) {
		BC->current_avg = BETWEEN(MIN_CURRENT,
		                          SCALE(BC->current_avg_sum/CURRENT_AVERAGE,
                                        0,
                                        MAX_ADC_VALUE,
                                        MIN_CURRENT_VALUE,
                                        MAX_CURRENT_VALUE),
                                  MAX_CURRENT);
		BC->current_avg_sum = 0;
	}

	return BC->current_avg;
}

void tick(const uint8_t tick_type) {
	if(tick_type & TICK_TASK_TYPE_MESSAGE) {
		if(PIN_OVER_CURRENT.pio->PIO_PDSR & PIN_OVER_CURRENT.mask) {
			BC->over_current = false;
		} else {
			if(!BC->over_current) {
				logbli("Over Current");
				BC->over_current = true;

				StandardMessage sm;
				BA->com_make_default_header(&sm, BS->uid, sizeof(StandardMessage), FID_OVER_CURRENT);

				BA->send_blocking_with_timeout(&sm,
											   sizeof(StandardMessage),
											   *BA->com_current);
			}
		}
	}

	simple_tick(tick_type);
}
