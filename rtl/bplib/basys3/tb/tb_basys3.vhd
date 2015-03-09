-- $Id: tb_basys3.vhd 648 2015-02-20 20:16:21Z mueller $
--
-- Copyright 2015- by Walter F.J. Mueller <W.F.J.Mueller@gsi.de>
--
-- This program is free software; you may redistribute and/or modify it under
-- the terms of the GNU General Public License as published by the Free
-- Software Foundation, either version 2, or at your option any later version.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY, without even the implied warranty of MERCHANTABILITY
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
-- for complete details.
-- 
------------------------------------------------------------------------------
-- Module Name:    tb_basys3 - sim
-- Description:    Test bench for basys3 (base)
--
-- Dependencies:   simlib/simclk
--                 simlib/simclkcnt
--                 rlink/tb/tbcore_rlink
--                 xlib/s7_cmt_sfs
--                 tb_basys3_core
--                 serport/serport_uart_rxtx
--                 basys3_aif [UUT]
--
-- To test:        generic, any basys3_aif target
--
-- Target Devices: generic
-- Tool versions:  viv 2014.4; ghdl 0.31
--
-- Revision History: 
-- Date         Rev Version  Comment
-- 2015-02-18   648   1.0    Initial version (derived from tb_nexys4)
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.slvtypes.all;
use work.rlinklib.all;
use work.rlinktblib.all;
use work.serportlib.all;
use work.xlib.all;
use work.basys3lib.all;
use work.simlib.all;
use work.simbus.all;
use work.sys_conf.all;

entity tb_basys3 is
end tb_basys3;

architecture sim of tb_basys3 is
  
  signal CLKOSC : slbit := '0';         -- board clock (100 Mhz)
  signal CLKCOM : slbit := '0';         -- communication clock

  signal CLK_STOP : slbit := '0';
  signal CLKCOM_CYCLE : integer := 0;

  signal RESET : slbit := '0';
  signal CLKDIV : slv2 := "00";         -- run with 1 clocks / bit !!
  signal RXDATA : slv8 := (others=>'0');
  signal RXVAL : slbit := '0';
  signal RXERR : slbit := '0';
  signal RXACT : slbit := '0';
  signal TXDATA : slv8 := (others=>'0');
  signal TXENA : slbit := '0';
  signal TXBUSY : slbit := '0';

  signal I_RXD : slbit := '1';
  signal O_TXD : slbit := '1';
  signal I_SWI : slv16 := (others=>'0');
  signal I_BTN : slv5 := (others=>'0');
  signal O_LED : slv16 := (others=>'0');
  signal O_ANO_N : slv4 := (others=>'0');
  signal O_SEG_N : slv8 := (others=>'0');

  constant clock_period : time :=  10 ns;
  constant clock_offset : time := 200 ns;

begin
  
  CLKGEN : simclk
    generic map (
      PERIOD => clock_period,
      OFFSET => clock_offset)
    port map (
      CLK      => CLKOSC,
      CLK_STOP => CLK_STOP
    );
  
  CLKGEN_COM : s7_cmt_sfs
    generic map (
      VCO_DIVIDE   => sys_conf_clkser_vcodivide,
      VCO_MULTIPLY => sys_conf_clkser_vcomultiply,
      OUT_DIVIDE   => sys_conf_clkser_outdivide,
      CLKIN_PERIOD => 10.0,
      CLKIN_JITTER => 0.01,
      STARTUP_WAIT => false,
      GEN_TYPE     => sys_conf_clksys_gentype)
    port map (
      CLKIN   => CLKOSC,
      CLKFX   => CLKCOM,
      LOCKED  => open
    );

  CLKCNT : simclkcnt port map (CLK => CLKCOM, CLK_CYCLE => CLKCOM_CYCLE);

  TBCORE : tbcore_rlink
    port map (
      CLK      => CLKCOM,
      CLK_STOP => CLK_STOP,
      RX_DATA  => TXDATA,
      RX_VAL   => TXENA,
      RX_HOLD  => TXBUSY,
      TX_DATA  => RXDATA,
      TX_ENA   => RXVAL
    );

  N4CORE : entity work.tb_basys3_core
    port map (
      I_SWI       => I_SWI,
      I_BTN       => I_BTN
    );

  UUT : basys3_aif
    port map (
       I_CLK100    => CLKOSC,
      I_RXD       => I_RXD,
      O_TXD       => O_TXD,
      I_SWI       => I_SWI,
      I_BTN       => I_BTN,
      O_LED       => O_LED,
      O_ANO_N     => O_ANO_N,
      O_SEG_N     => O_SEG_N
    );
  
  UART : serport_uart_rxtx
    generic map (
      CDWIDTH => CLKDIV'length)
    port map (
      CLK    => CLKCOM,
      RESET  => RESET,
      CLKDIV => CLKDIV,
      RXSD   => O_TXD,
      RXDATA => RXDATA,
      RXVAL  => RXVAL,
      RXERR  => RXERR,
      RXACT  => RXACT,
      TXSD   => I_RXD,
      TXDATA => TXDATA,
      TXENA  => TXENA,
      TXBUSY => TXBUSY
    );

  proc_moni: process
    variable oline : line;
  begin
    
    loop
      wait until rising_edge(CLKCOM);

      if RXERR = '1' then
        writetimestamp(oline, CLKCOM_CYCLE, " : seen RXERR=1");
        writeline(output, oline);
      end if;
      
    end loop;
    
  end process proc_moni;

end sim;
