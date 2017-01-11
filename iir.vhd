--------------------------------------------------------------------------------
-- Copyright (C) 2017  Kevin Bloom <kdb5pct.edu>
--
-- This program is free software: you can redistribute it and/or modify it under
-- the terms of the Lesser GNU General Public License as published by the Free
-- Software Foundation, either version 3 of the License, or (at your option) any
-- later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE.  See the Lesser GNU General Public License for more
-- details.
--
-- You should have received a copy of the Lesser GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Description:
--
-- IIR Filter IP
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- As of now, the coefficients will be internally set contstants
entity iir is
  Port ( Clk      : in STD_LOGIC;       --probably should be a fast non-fs clock
         data_in  : in STD_LOGIC_VECTOR  (11 downto 0);
         data_out : out STD_LOGIC_VECTOR (11 downto 0));
end iir;

architecture Behavioral of iir is

  -- Defining of the coefficient arrays
  type a is array (14 downto 0) of STD_LOGIC_VECTOR;
  type a_elem is array (8 downto 0) of a;
  type b is array (14 downto 0) of STD_LOGIC_VECTOR;
  type b_elem is array (9 downto 0) of b;
  variable a_coeff : a_elem;
  variable b_coeff : b_elem;

  -- Data array
  type data_array is array (11 downto 0) of STD_LOGIC_VECTOR;
  type data_elem is array (9 downto 0) of data_array;
  variable data : data_elem;

  -- Assigning the values (not correct yet)
  a_coeff := (0x"E168");
  b_coeff := ();

  -- Initialize data array to zeros
  data := (0x"0000", 0x"0000", 0x"0000", 0x"0000", 0x"0000", 0x"0000", 0x"0000",
           0x"0000", 0x"0000", 0x"0000");

begin

  process(Clk)
  begin
    -- Calculations go here! Don't forget to use pipelining!
  end process;

end Behavioral;
