# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Configuration [ipgui::add_page $IPINST -name "Configuration"]
  ipgui::add_param $IPINST -name "NumOfClocks_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "AxiClkFreq_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "MaxClkFreq_g" -parent ${Configuration}


}

proc update_PARAM_VALUE.AxiClkFreq_g { PARAM_VALUE.AxiClkFreq_g } {
	# Procedure called to update AxiClkFreq_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AxiClkFreq_g { PARAM_VALUE.AxiClkFreq_g } {
	# Procedure called to validate AxiClkFreq_g
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to update C_S00_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to validate C_S00_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.MaxClkFreq_g { PARAM_VALUE.MaxClkFreq_g } {
	# Procedure called to update MaxClkFreq_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MaxClkFreq_g { PARAM_VALUE.MaxClkFreq_g } {
	# Procedure called to validate MaxClkFreq_g
	return true
}

proc update_PARAM_VALUE.NumOfClocks_g { PARAM_VALUE.NumOfClocks_g } {
	# Procedure called to update NumOfClocks_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NumOfClocks_g { PARAM_VALUE.NumOfClocks_g } {
	# Procedure called to validate NumOfClocks_g
	return true
}


proc update_MODELPARAM_VALUE.NumOfClocks_g { MODELPARAM_VALUE.NumOfClocks_g PARAM_VALUE.NumOfClocks_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NumOfClocks_g}] ${MODELPARAM_VALUE.NumOfClocks_g}
}

proc update_MODELPARAM_VALUE.AxiClkFreq_g { MODELPARAM_VALUE.AxiClkFreq_g PARAM_VALUE.AxiClkFreq_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AxiClkFreq_g}] ${MODELPARAM_VALUE.AxiClkFreq_g}
}

proc update_MODELPARAM_VALUE.MaxClkFreq_g { MODELPARAM_VALUE.MaxClkFreq_g PARAM_VALUE.MaxClkFreq_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MaxClkFreq_g}] ${MODELPARAM_VALUE.MaxClkFreq_g}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH}
}

