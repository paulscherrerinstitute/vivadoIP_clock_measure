------------------------------------------------------------------------------
--  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Libraries
------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
library std;
	use std.textio.all;

library work;
	use work.psi_tb_txt_util.all;
	use work.psi_tb_axi_pkg.all;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is

	-------------------------------------------------------------------------
	-- AXI Definition
	-------------------------------------------------------------------------
	constant ID_WIDTH 		: integer 	:= 1;
	constant ADDR_WIDTH 	: integer	:= 8;
	constant USER_WIDTH		: integer	:= 1;
	constant DATA_WIDTH		: integer	:= 32;
	constant BYTE_WIDTH		: integer	:= DATA_WIDTH/8;
	
	subtype ID_RANGE is natural range ID_WIDTH-1 downto 0;
	subtype ADDR_RANGE is natural range ADDR_WIDTH-1 downto 0;
	subtype USER_RANGE is natural range USER_WIDTH-1 downto 0;
	subtype DATA_RANGE is natural range DATA_WIDTH-1 downto 0;
	subtype BYTE_RANGE is natural range BYTE_WIDTH-1 downto 0;
	
	signal axi_ms : axi_ms_r (	arid(ID_RANGE), awid(ID_RANGE),
								araddr(ADDR_RANGE), awaddr(ADDR_RANGE),
								aruser(USER_RANGE), awuser(USER_RANGE), wuser(USER_RANGE),
								wdata(DATA_RANGE),
								wstrb(BYTE_RANGE));
	
	signal axi_sm : axi_sm_r (	rid(ID_RANGE), bid(ID_RANGE),
								ruser(USER_RANGE), buser(USER_RANGE),
								rdata(DATA_RANGE));

	-------------------------------------------------------------------------
	-- TB Defnitions
	-------------------------------------------------------------------------
	constant	ClockFrequencyAxi_c	: real		:= 125.0e3;							-- Use slow clocks to speed up simulation
	constant	ClockPeriodAxi_c	: time		:= (1 sec)/ClockFrequencyAxi_c;
	constant 	ClockFrequencyClk0	: real		:= 33.333e3;						-- Use slow clocks to speed up simulation
	constant	ClockPeriodClk0_c	: time		:= (1 sec)/ClockFrequencyClk0;
	constant 	ClockFrequencyClk1	: real		:= 223.5e3;							-- Use slow clocks to speed up simulation
	constant	ClockPeriodClk1_c	: time		:= (1 sec)/ClockFrequencyClk1;
	signal 		TbRunning			: boolean 	:= True;

	
	-------------------------------------------------------------------------
	-- Interface Signals
	-------------------------------------------------------------------------
	signal aclk			: std_logic							:= '0';
	signal aresetn		: std_logic							:= '0';
	signal Clk0			: std_logic							:= '0';
	signal Clk1			: std_logic							:= '0';

begin

	-------------------------------------------------------------------------
	-- DUT
	-------------------------------------------------------------------------
	i_dut : entity work.clock_measure_vivado_wrp
		generic map
		(
			-- Component Generics
			NumOfClocks_g				=> 2,
			AxiClkFreq_g				=> integer(ClockFrequencyAxi_c),
			MaxClkFreq_g				=> 250_000_000,
			-- AXI
			C_S00_AXI_ID_WIDTH     	 	=> ID_WIDTH	
		)
		port map
		(
			-- Clocks
			Clocks(0)			=> Clk0,
			Clocks(1)			=> Clk1,
			-- Axi Slave Bus Interface
			s00_axi_aclk    	=> aclk,
			s00_axi_aresetn  	=> aresetn,
			s00_axi_arid        => axi_ms.arid,
			s00_axi_araddr      => axi_ms.araddr,
			s00_axi_arlen       => axi_ms.arlen,
			s00_axi_arsize      => axi_ms.arsize,
			s00_axi_arburst     => axi_ms.arburst,
			s00_axi_arlock      => axi_ms.arlock,
			s00_axi_arcache     => axi_ms.arcache,
			s00_axi_arprot      => axi_ms.arprot,
			s00_axi_arvalid     => axi_ms.arvalid,
			s00_axi_arready     => axi_sm.arready,
			s00_axi_rid         => axi_sm.rid,
			s00_axi_rdata       => axi_sm.rdata,
			s00_axi_rresp       => axi_sm.rresp,
			s00_axi_rlast       => axi_sm.rlast,
			s00_axi_rvalid      => axi_sm.rvalid,
			s00_axi_rready      => axi_ms.rready,
			s00_axi_awid    	=> axi_ms.awid,    
			s00_axi_awaddr      => axi_ms.awaddr,
			s00_axi_awlen       => axi_ms.awlen,
			s00_axi_awsize      => axi_ms.awsize,
			s00_axi_awburst     => axi_ms.awburst,
			s00_axi_awlock      => axi_ms.awlock,
			s00_axi_awcache     => axi_ms.awcache,
			s00_axi_awprot      => axi_ms.awprot,
			s00_axi_awvalid     => axi_ms.awvalid,
			s00_axi_awready     => axi_sm.awready,
			s00_axi_wdata       => axi_ms.wdata,
			s00_axi_wstrb       => axi_ms.wstrb,
			s00_axi_wlast       => axi_ms.wlast,
			s00_axi_wvalid      => axi_ms.wvalid,
			s00_axi_wready      => axi_sm.wready,
			s00_axi_bid         => axi_sm.bid,
			s00_axi_bresp       => axi_sm.bresp,
			s00_axi_bvalid      => axi_sm.bvalid,
			s00_axi_bready      => axi_ms.bready			
		);
	
	-------------------------------------------------------------------------
	-- Clock
	-------------------------------------------------------------------------
	p_aclk : process
	begin
		aclk <= '0';
		while TbRunning loop
			wait for 0.5*ClockPeriodAxi_c;
			aclk <= '1';
			wait for 0.5*ClockPeriodAxi_c;
			aclk <= '0';
		end loop;
		wait;
	end process;
	
	p_clk0 : process
	begin
		Clk0 <= '0';
		while TbRunning loop
			wait for 0.5*ClockPeriodClk0_c;
			Clk0 <= '1';
			wait for 0.5*ClockPeriodClk0_c;
			Clk0 <= '0';
		end loop;
		wait;
	end process;

	p_clk1 : process
	begin
		Clk1 <= '0';
		while TbRunning loop
			wait for 0.5*ClockPeriodClk1_c;
			Clk1 <= '1';
			wait for 0.5*ClockPeriodClk1_c;
			Clk1 <= '0';
		end loop;
		wait;
	end process;		
	
	-------------------------------------------------------------------------
	-- TB Control
	-------------------------------------------------------------------------
	p_control : process
		file fr 			: text;
		variable r 			: line;
		variable sample		: integer;
	begin
		-- Reset
		aresetn <= '0';
		wait for 1 ms;
		wait until rising_edge(aclk);
		aresetn <= '1';
		wait for 1 ms;
		
		-- Wait for measurement to be executed
		wait for 1.5 sec;
		axi_single_expect(16#0000#, integer(ClockFrequencyClk0), axi_ms, axi_sm, aclk, "Wrong Clk0 value", 31, 0, false, 10);
		axi_single_expect(16#0004#, integer(ClockFrequencyClk1), axi_ms, axi_sm, aclk, "Wrong Clk1 value", 31, 0, false, 10);
		
		
		-- TB done
		TbRunning <= false;
		wait;
	end process;
	
	

end sim;
