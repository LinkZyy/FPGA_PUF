-- ############################################################################################################################
-- ############################################################################################################################

-- #################################################################################################
-- # << Technology-Agnostic Physical Unclonable Function (PUF) - 1-bit PUF Cell >>                 #
-- # ********************************************************************************************* #
-- # Based on a simple 1-bit oscillator decoupled by a latch (also providing reset).               #
-- # Make sure that all signals that control the oscillator cell are registered.                   #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2021, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # fpga_puf - https://github.com/stnolting/fpga_puf                          (c) Stephan Nolting #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;

entity fpga_puf_cell is
  port (
    clk_i    : in  std_ulogic;
    reset_i  : in  std_ulogic;
    latch_i  : in  std_ulogic;
    sample_i : in  std_ulogic;
    data_o   : out std_ulogic 
  );
end fpga_puf_cell;

architecture fpga_puf_cell_rtl of fpga_puf_cell is

  signal osc : std_ulogic;

begin

  -- Oscillator Cell ------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  oscillator: process(osc, reset_i, latch_i)
  begin
    if (reset_i = '1') then -- reset oscillator to defined state
      osc <= '0';
    elsif (latch_i = '1') then -- enable ring-oscillator; keep current state when disabled
      osc <= not osc;
      -- osc <= '1';
    end if;
  end process oscillator;


  -- Output Capture Register ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  cap_reg: process(clk_i)
  begin
    if rising_edge(clk_i) then
      if (sample_i = '1') then
        data_o <= osc;
      end if;
    end if;
  end process cap_reg;


end fpga_puf_cell_rtl;