##############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
##############################################################################

###############################################################
# Include PSI packaging commands
###############################################################
source ../../../TCL/PsiIpPackage/PsiIpPackage.tcl
namespace import -force psi::ip_package::latest::*

###############################################################
# General Information
###############################################################
set IP_NAME clock_measure
set IP_VERSION 1.4
set IP_REVISION "auto"
set IP_LIBRARY PSI
set IP_DESCIRPTION "Measure the frequency of up to 32 clocks"

init $IP_NAME $IP_VERSION $IP_REVISION $IP_LIBRARY
set_description $IP_DESCIRPTION
set_logo_relative "../doc/psi_logo_150.gif"
set_datasheet_relative "../doc/$IP_NAME.pdf"

###############################################################
# Add Source Files
###############################################################

#Relative Source Files
add_sources_relative { \
	../hdl/single_clock_measurement.vhd \
	../hdl/clock_measure_vivado_wrp.vhd \
}

#PSI Common
add_lib_relative \
	"../../../VHDL/psi_common/hdl"	\
	{ \
		psi_common_array_pkg.vhd \
		psi_common_math_pkg.vhd \
		psi_common_logic_pkg.vhd \
		psi_common_pl_stage.vhd \
		psi_common_axi_slave_ipif.vhd \
	}

###############################################################
# Driver Files
###############################################################	

add_drivers_relative ../drivers/clock_measure { \
	src/clock_measure.c \
	src/clock_measure.h \
}
	

###############################################################
# GUI Parameters
###############################################################

#User Parameters
gui_add_page "Configuration"

gui_create_parameter "NumOfClocks_g" "Number of clocks to measure"
gui_parameter_set_range 1 32
gui_add_parameter

gui_create_parameter "AxiClkFreq_g" "Frequencyof the AXI-clock"
gui_add_parameter

gui_create_parameter "MaxClkFreq_g" "Maximum clock frequency to measure"
gui_add_parameter


###############################################################
# Optional Ports
###############################################################

#None

###############################################################
# Package Core
###############################################################
set TargetDir ".."
#											Edit  	Synth	
package_ip $TargetDir 						false 	true




