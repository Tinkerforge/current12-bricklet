/*************************************************************
 * This file was automatically generated on 23.08.2011.      *
 *                                                           *
 * If you have a bugfix for this file and want to commit it, *
 * please fix the bug in the generator. You can find a link  *
 * to the generator git on tinkerforge.com                   *
 *************************************************************/

#ifndef BRICKLET_CURRENT12_H
#define BRICKLET_CURRENT12_H

#include "ip_connection.h"

typedef Device Current12;

#define CURRENT12_CALLBACK_CURRENT 15
#define CURRENT12_CALLBACK_ANALOG_VALUE 16
#define CURRENT12_CALLBACK_CURRENT_REACHED 17
#define CURRENT12_CALLBACK_ANALOG_VALUE_REACHED 18
#define CURRENT12_CALLBACK_OVER_CURRENT 19

void current12_create(Current12 *current12, const char *uid);

int current12_get_current(Current12 *current12, int16_t *ret_current);
int current12_calibrate(Current12 *current12);
int current12_is_over_current(Current12 *current12, bool *ret_over);
int current12_get_analog_value(Current12 *current12, uint16_t *ret_value);
int current12_set_current_callback_period(Current12 *current12, uint32_t period);
int current12_get_current_callback_period(Current12 *current12, uint32_t *ret_period);
int current12_set_analog_value_callback_period(Current12 *current12, uint32_t period);
int current12_get_analog_value_callback_period(Current12 *current12, uint32_t *ret_period);
int current12_set_current_callback_threshold(Current12 *current12, char option, int16_t min, int16_t max);
int current12_get_current_callback_threshold(Current12 *current12, char *ret_option, int16_t *ret_min, int16_t *ret_max);
int current12_set_analog_value_callback_threshold(Current12 *current12, char option, uint16_t min, uint16_t max);
int current12_get_analog_value_callback_threshold(Current12 *current12, char *ret_option, uint16_t *ret_min, uint16_t *ret_max);
int current12_set_debounce_period(Current12 *current12, uint32_t debounce);
int current12_get_debounce_period(Current12 *current12, uint32_t *ret_debounce);
int current12_current(Current12 *current12, int16_t *ret_current);
int current12_analog_value(Current12 *current12, uint16_t *ret_value);
int current12_current_reached(Current12 *current12, int16_t *ret_current);
int current12_analog_value_reached(Current12 *current12, uint16_t *ret_value);
int current12_over_current(Current12 *current12);

void current12_register_callback(Current12 *current12, uint8_t cb, void *func);

#endif