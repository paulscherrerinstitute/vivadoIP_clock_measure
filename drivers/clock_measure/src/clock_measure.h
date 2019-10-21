/*############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
############################################################################*/

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

//*******************************************************************************
// Includes
//*******************************************************************************
#include <stdint.h>

//*******************************************************************************
// Functions
//*******************************************************************************
/**
 * Get the frequency of a given clock input
 *
 * @param baseAddr		Base address of the clock measurement component to access
 * @param clock			Index of the clock to get the frequency for
 * @return				Frequency of the clock in Hz
 */
uint32_t ClockMeasure_GetFreq(const uint32_t baseAddr, const uint8_t clock);

/**
 * Get the frequency of a given clock input in MHz
 *
 * @param baseAddr		Base address of the clock measurement component to access
 * @param clock			Index of the clock to get the frequency for
 * @return				Frequency of the clock in MHz
 */
float ClockMeasure_GetFreqMhz(const uint32_t baseAddr, const uint8_t clock);

#ifdef __cplusplus
}
#endif

