/*############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
############################################################################*/

#include "clock_measure.h"
#include <xil_io.h>

uint32_t ClockMeasure_GetFreq(const uint32_t baseAddr, const uint8_t clock)
{
	return Xil_In32(baseAddr+4*clock);
}

float ClockMeasure_GetFreqMhz(const uint32_t baseAddr, const uint8_t clock)
{
	uint32_t hz = ClockMeasure_GetFreq(baseAddr, clock);
	return hz/1.0e6f;
}
