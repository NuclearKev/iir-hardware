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

  signal fir_out : STD_LOGIC_VECTOR(11 downto 0);

  -- Defining of the coefficient arrays
  type a is array (14 downto 0) of integer;
  type a_elem is array (8 downto 0) of a;
  type b is array (14 downto 0) of integer;
  type b_elem is array (9 downto 0) of b;
  signal a_coeff : a_elem;
  signal b_coeff : b_elem;

  -- Data array
  type data_array is array (11 downto 0) of integer;
  type data_elem is array (9 downto 0) of data_array;
  signal data : data_elem;

begin

  data_out <= fir_out;

  -- Assigning the coefficient values
  a_coeff <= ( 222, 222, 222, 222, 222, 222, 222, 222, 222 );
  b_coeff <= ( 222, 222, 222, 222, 222, 222, 222, 222, 222, 222 );

  -- Initialize data array to zeros
  data <= ( x"0009", x"0008", x"0007", x"0006", x"0005", x"0004", x"0003",
           x"0002", x"0001", x"0000" );

  process(Clk,a_coeff,b_coeff,data)
  begin

    -- variable buf : integer := 0;        -- Declare loop variable here
    if(rising_edge(Clk)) then

      fir_out <= data(0)*b_coeff(0) + data(1)*b_coeff(1) + data(2)*b_coeff(2) +
      data(3)*b_coeff(3) + data(4)*b_coeff(4);

    end if;
    -- Right shift the data array here

    -- for i in 0 to 9 loop
    --   case i is
    --     when 0 => temp1 <= a*data;
    --     when 1 => temp2 <= temp1*b;
    --     when 2 => result <= temp2*c;
    --     when others => null;
    --   end case;
    -- end loop;

  end process;

end Behavioral;
