-- $Id: sys_conf.vhd 788 2016-07-16 22:23:23Z mueller $
--
-- Copyright 2011-2016 by Walter F.J. Mueller <W.F.J.Mueller@gsi.de>
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
-- Package Name:   sys_conf
-- Description:    Definitions for sys_w11a_n3 (for synthesis)
--
-- Dependencies:   -
-- Tool versions:  xst 13.1-14.7; ghdl 0.29-0.33
-- Revision History: 
-- Date         Rev Version  Comment
-- 2016-07-16   788   1.7    use cram_*delay functions to determine delays
-- 2016-07-10   786   1.6    memctl with page mode, new read1delay
-- 2016-05-28   770   1.5.1  sys_conf_mem_losize now type natural 
-- 2016-03-22   750   1.5    add sys_conf_cache_twidth
-- 2015-06-26   695   1.4.2  add sys_conf_(dmscnt|dmhbpt*|dmcmon*)
-- 2015-06-21   692   1.4.1  use clksys=64 (no closure after rhrp fixes)
-- 2015-03-14   658   1.4    add sys_conf_ibd_* definitions
-- 2015-02-15   647   1.3    drop bram and minisys options
-- 2014-12-26   621   1.2.2  use 68 MHz, get occasional problems with 72 MHz
-- 2014-12-22   619   1.2.1  add _rbmon_awidth
-- 2013-10-06   538   1.2    pll support, use clksys_vcodivide ect
-- 2013-10-05   537   1.1.1  use 72 MHz, no closure w/ ISE 14.x for 80 anymore
-- 2013-04-21   509   1.1    add fx2 settings
-- 2011-11-26   433   1.0.1  use 80 MHz clksys (no closure for 85 after rev 432)
-- 2011-11-20   430   1.0    Initial version (derived from _n2 version)
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.slvtypes.all;
use work.nxcramlib.all;

package sys_conf is

  -- configure clocks --------------------------------------------------------
  constant sys_conf_clksys_vcodivide   : positive :=  25;
  constant sys_conf_clksys_vcomultiply : positive :=  16;   -- dcm   64 MHz
  constant sys_conf_clksys_outdivide   : positive :=   1;   -- sys   64 MHz
  constant sys_conf_clksys_gentype     : string   := "DCM";
  
  -- configure rlink and hio interfaces --------------------------------------
  constant sys_conf_ser2rri_defbaud : integer := 115200;   -- default 115k baud
  constant sys_conf_hio_debounce : boolean := true;    -- instantiate debouncers

  -- fx2 settings: petowidth=10 -> 2^10 30 MHz clocks -> ~33 usec
  constant sys_conf_fx2_petowidth  : positive := 10;
  constant sys_conf_fx2_ccwidth  : positive := 5;

  -- configure memory controller ---------------------------------------------
  -- now under derived constants

  -- configure debug and monitoring units ------------------------------------
  constant sys_conf_rbmon_awidth  : integer := 9; -- use 0 to disable
  constant sys_conf_ibmon_awidth  : integer := 9; -- use 0 to disable
  constant sys_conf_dmscnt        : boolean := true;
  constant sys_conf_dmhbpt_nunit  : integer := 2; -- use 0 to disable
  constant sys_conf_dmcmon_awidth : integer := 9; -- use 0 to disable

  -- configure w11 cpu core --------------------------------------------------
  constant sys_conf_mem_losize     : natural := 8#167777#; --   4 MByte

  constant sys_conf_cache_fmiss    : slbit   := '0';     -- cache enabled
  constant sys_conf_cache_twidth   : integer :=  9;      -- 8kB cache

  -- configure w11 system devices --------------------------------------------
  -- configure character and communication devices
  -- configure character and communication devices
  constant sys_conf_ibd_dl11_1 : boolean := true;  -- 2nd DL11
  constant sys_conf_ibd_pc11   : boolean := true;  -- PC11
  constant sys_conf_ibd_lp11   : boolean := true;  -- LP11

  -- configure mass storage devices
  constant sys_conf_ibd_rk11   : boolean := true;  -- RK11
  constant sys_conf_ibd_rl11   : boolean := true;  -- RL11
  constant sys_conf_ibd_rhrp   : boolean := true;  -- RHRP
  constant sys_conf_ibd_tm11   : boolean := true;  -- TM11

  -- configure other devices
  constant sys_conf_ibd_iist   : boolean := true;  -- IIST

  -- derived constants =======================================================
  constant sys_conf_clksys : integer :=
    ((100000000/sys_conf_clksys_vcodivide)*sys_conf_clksys_vcomultiply) /
    sys_conf_clksys_outdivide;
  constant sys_conf_clksys_mhz : integer := sys_conf_clksys/1000000;

  constant sys_conf_ser2rri_cdinit : integer :=
    (sys_conf_clksys/sys_conf_ser2rri_defbaud)-1;

  constant sys_conf_memctl_read0delay : positive :=
              cram_read0delay(sys_conf_clksys_mhz);
  constant sys_conf_memctl_read1delay : positive := 
              cram_read1delay(sys_conf_clksys_mhz);
  constant sys_conf_memctl_writedelay : positive := 
              cram_writedelay(sys_conf_clksys_mhz);

end package sys_conf;