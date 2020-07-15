------------------------------------------------------------------------------
--  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity single_clock_measurement_tb is
end;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture sim of single_clock_measurement_tb is

	----------------------------------------
	-- Constants
	----------------------------------------
	constant RstTime_c		: time	:= 1 us;
	
	----------------------------------------
	-- TB Signals
	----------------------------------------	
	signal TbRunning		: boolean 	:= true;
	signal TriggerPeriod	: time		:= 100 ms;
	signal HzMaster			: real		:= 250.0;
	signal HzTest			: real		:= 500.0;
	
	----------------------------------------
	-- Signals
	----------------------------------------
	signal ClkMaster		: std_logic						:= '0';
	signal Rst				: std_logic						:= '1';
	signal ClkTest			: std_logic						:= '0';
	signal FrequencyHz		: std_logic_vector(31 downto 0);
	
	----------------------------------------
	-- Procedure
	----------------------------------------
	procedure CheckFrequency( 	constant Fexp	: in 		integer;
								constant Ftol	: in 		integer;
								signal Freq 	: in 		std_logic_vector)
								is
	begin
		assert unsigned(Freq) <= Fexp+Ftol report "###ERROR###: Wrong Frequency (too high) " & integer'image(to_integer(unsigned(Freq))) & " " & integer'image(Fexp+Ftol) severity error;
		assert unsigned(Freq) >= Fexp-Ftol report "###ERROR###: Wrong Frequency (too low)" & integer'image(to_integer(unsigned(Freq))) & " " & integer'image(Fexp-Ftol) severity error;
	end procedure;
	
begin

	---------------------------------------------------------------------------
	-- DUT
	---------------------------------------------------------------------------
	i_dut : entity work.single_clock_measurement
		generic map (
			MasterFrequency_g	=> 250,
			MaxMeasFrequency_g	=> 2000
		)
		port map (
			ClkMaster		=> ClkMaster,
			Rst				=> Rst,
			FrequencyHz		=> FrequencyHz,
			ClkTest			=> ClkTest
		);
	
		
	---------------------------------------------------------------------------
	-- Clock Generators
	---------------------------------------------------------------------------
	p_clk_master : process
		variable Period_v : time;
	begin
		while TbRunning loop
			Period_v := (1 sec) / HzMaster;
			wait for Period_v/2;
			ClkMaster <= '1';
			wait for Period_v/2;
			ClkMaster <= '0';
		end loop;
		wait;
	end process;
	
	p_clk_test : process
		variable Period_v : time;
	begin
		while TbRunning loop
			Period_v := (1 sec) / HzTest;
			wait for Period_v/2;
			ClkTest <= '1';
			wait for Period_v/2;
			ClkTest <= '0';
		end loop;
		wait;
	end process;	
	
	---------------------------------------------------------------------------
	-- Test Cases
	---------------------------------------------------------------------------
	p_stimuli : process
	begin
		-- *** Reset ***
		wait for RstTime_c;
		wait until rising_edge(ClkMaster);
		Rst <= '0';
		wait for 2 sec;
		
		report "Test faster (integer)";
		HzTest <= 500.0;
		wait for 2 sec;
		CheckFrequency(500, 1, FrequencyHz);
		
		report "Master faster (integer)";
		HzTest <= 125.0;
		wait for 2 sec;
		CheckFrequency(125, 1, FrequencyHz);
		
		report "Test faster (fractional)";
		HzTest <= 221.0;
		wait for 2 sec;
		CheckFrequency(221, 1, FrequencyHz);		
		
		report "Master faster (fractional)";
		HzTest <= 305.0;
		wait for 2 sec;
		CheckFrequency(305, 1, FrequencyHz);			
		
		report "Maximum";
		HzTest <= 5000.0;
		wait for 2 sec;
		CheckFrequency(2000, 1, FrequencyHz);	
		
		report "Zero";
		HzTest <= 0.001;
		wait for 2 sec;
		CheckFrequency(0, 0, FrequencyHz);	
			
		-- *** Finish *** TB
		report "done";
		TbRunning <= false;
		wait;
	end process;


end;

-------------------------------------------------------------------------------
-- EOF
-------------------------------------------------------------------------------

