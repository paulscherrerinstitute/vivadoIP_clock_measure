------------------------------------------------------------------------------
--  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------


--Add next line to constraints file:
--set_false_path -to [get_cells -hierarchical -filter {NAME =~ *async_fd_inst && IS_SEQUENTIAL}]


-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library unisim;
        use unisim.vcomponents.all;


-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity single_clock_measurement is
	generic (
		MasterFrequency_g	: positive := 125000000;
		MaxMeasFrequency_g	: positive := 250000000
	);
	port (
		----------------------------------------
		-- Control Signals
		----------------------------------------
		ClkMaster		: in	std_logic;
		Rst			: in	std_logic;
		
		----------------------------------------
		-- Test
		----------------------------------------
		FrequencyHz		: out	std_logic_vector(31 downto 0);
		ClkTest			: in	std_logic
	);
end;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture rtl of single_clock_measurement is

	----------------------------------------
	-- Constants
	----------------------------------------

	----------------------------------------
	-- Signals Master Clock
	----------------------------------------
	signal Cntr1Hz_M 			: integer range 0 to MasterFrequency_g-1;
	signal Toggle1Hz_M			: std_logic;
	signal ResultToggle_M   	        : std_logic;
	signal ResultToggleSync_M	        : std_logic_vector(2 downto 0);
	signal AwaitResult_M		        : std_logic;
	signal FrequencyHz_M	  	        : std_logic_vector(31 downto 0);

        
	----------------------------------------
	-- Signals Test Clock
	----------------------------------------	
	signal Rst_T		                : std_logic;
	signal CntrTest_T			: integer range 0 to MaxMeasFrequency_g;
	signal Result_T				: integer range 0 to MaxMeasFrequency_g;
	signal ResultToggle_T		        : std_logic;	
	signal Toggle1Hz_T			: std_logic;
	signal Toggle1HzSync_T		        : std_logic_vector(2 downto 0);
	signal FrequencyHz_T	  	        : std_logic_vector(31 downto 0);

        
	---------------------------------------------------------------------------
	-- Asynchonous flip-flops
	---------------------------------------------------------------------------
        attribute ASYNC_REG                                   : string;
        attribute ASYNC_REG of Rst_T_async_fd_inst            : label is "true";
        attribute ASYNC_REG of Toggle1Hz_T_async_fd_inst      : label is "true";
        attribute ASYNC_REG of ResultToggle_M_async_fd_inst   : label is "true";

        
begin


	---------------------------------------------------------------------------
	-- Reset Generation and Result Latching(Master Clock)
	---------------------------------------------------------------------------
	p_rstGen : process(ClkMaster)
	begin
		if rising_edge(ClkMaster) then
			if Rst = '1' then
				Cntr1Hz_M 		<= MasterFrequency_g-1;
				Toggle1Hz_M 		<= '0';
				AwaitResult_M 		<= '0';
				FrequencyHz 		<= (others => '0');
				ResultToggleSync_M 	<= (others => '0');
			else
				-- Request new result
				if Cntr1Hz_M = 0 then
					Cntr1Hz_M 	<= MasterFrequency_g-1;
					Toggle1Hz_M 	<= not Toggle1Hz_M;
					AwaitResult_M 	<= '1';
					if AwaitResult_M = '1' then
						FrequencyHz <= (others => '0');
					end if;
				else
					Cntr1Hz_M 	<= Cntr1Hz_M-1;
				end if;
				
				-- Latch new result
				ResultToggleSync_M <= ResultToggleSync_M(1 downto 0) & ResultToggle_M;
				if ResultToggleSync_M(2) /= ResultToggleSync_M(1) then
                                  FrequencyHz   <= FrequencyHz_M;
                                  AwaitResult_M <= '0';
				end if;		
			end if;
		end if;
	end process;


        
	---------------------------------------------------------------------------
	-- Edge Counter (Test Clock)
	---------------------------------------------------------------------------
	p_meas : process(ClkTest)
	begin
		if rising_edge(ClkTest) then
			if Rst_T = '1' then
				Toggle1HzSync_T <= (others => '0');
				ResultToggle_T 	<= '0';
				Result_T 	<= 0;
			else
				Toggle1HzSync_T <= Toggle1HzSync_T(1 downto 0) & Toggle1Hz_T;
				
				-- On every toggle, reset counter and output result
				if Toggle1HzSync_T(2) /= Toggle1HzSync_T(1) then	
					CntrTest_T 	<= 1; --the first edge implicitly arrived
					Result_T 	<= CntrTest_T;
					ResultToggle_T 	<= not ResultToggle_T;
				-- Otherwise count (prevent overflows!)
				elsif CntrTest_T /= MaxMeasFrequency_g then
					CntrTest_T      <= CntrTest_T + 1;
				end if;
			end if;
		end if;
	end process;


        
	---------------------------------------------------------------------------
	-- Asynchonous flip-flops
	---------------------------------------------------------------------------
        Rst_T_async_fd_inst : fd
        port map(c => ClkTest,
                 d => Rst,
                 q => Rst_T);
        
        Toggle1Hz_T_async_fd_inst : fd
        port map(c => ClkTest,
                 d => Toggle1Hz_M,
                 q => Toggle1Hz_T);

        ResultToggle_M_async_fd_inst : fd
        port map(c => ClkMaster,
                 d => ResultToggle_T,
                 q => ResultToggle_M);


        FrequencyHz_T <= std_logic_vector(to_unsigned(Result_T, 32));
        frequency_asyn_fds : for i in 0 to 31 generate
          attribute ASYNC_REG of FrequencyHz_async_fd_inst   : label is "true";
        begin 
          FrequencyHz_async_fd_inst : fd
            port map(c => ClkMaster,
                     d => FrequencyHz_T(i),
                     q => FrequencyHz_M(i));
        end generate;
                                    


end;

-------------------------------------------------------------------------------
-- EOF
-------------------------------------------------------------------------------

