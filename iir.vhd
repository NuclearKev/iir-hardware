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
use IEEE.STD_LOGIC_SIGNED.ALL;

-- As of now, the coefficients will be internally set contstants
entity iir is
  Port ( in_clk   : in STD_LOGIC;       --probably should be a fast non-fs clock
         data_in  : in STD_LOGIC_VECTOR  (11 downto 0);
         data_out : out STD_LOGIC_VECTOR (11 downto 0));
end iir;

architecture Behavioral of iir is

  signal fir_out : STD_LOGIC_VECTOR(11 downto 0);

  -- Defining of the coefficient arrays
  type a_int is array (4 downto 0) of STD_LOGIC_VECTOR(11 downto 0);
  -- type a_elem is array (8 downto 0) of a;
  -- type b is array (14 downto 0) of integer;
  -- type b_elem is array (9 downto 0) of b;
  -- signal a_coeff : a_elem;
  -- signal b_coeff : b_elem;

  signal a : a_int := (
    0 => x"1999",
    1 => x"1999",
    2 => x"1999",
    3 => x"1999",
    4 => x"1999",
    others => x"1999");

  -- Data array
  type data_array is array (4 downto 0) of STD_LOGIC_VECTOR(11 downto 0);
  -- type data_elem is array (9 downto 0) of data_array;
  signal data : data_array := (
    0 => x"5",
    1 => x"4",
    2 => x"3",
    3 => x"2",
    4 => x"1",
    others => x"0");

begin

  data_out <= fir_out;

  -- Assigning the coefficient values
  -- a_coeff <= ( 2, 2, 2, 2, 2, 2, 2, 2, 2 );
  -- b_coeff <= ( 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 );

  -- Initialize data array to zeros
  -- data <= ( x"0009", x"0008", x"0007", x"0006", x"0005", x"0004", x"0003",
  --          x"0002", x"0001", x"0000" );

  fir: process(in_clk,data)
    
  variable i : integer := 0;
  variable big_output : STD_LOGIC_VECTOR(23 downto 0);
  
  begin
    
    -- variable buf : integer := 0;        -- Declare loop variable here
    if(rising_edge(in_clk)) then

      -- Shift the data array and feed in the new data      
      for i in 0 to 3 loop
        data(i+1) <= data(i);
      end loop;
      data(0) <= data_in;

      big_output := data(0)*a(0) + data(1)*a(1) + data(2)*a(2) + data(3)*a(3) +
                 data(4)*a(4);
      
      fir_out <= big_output(11 downto 0);                

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

  end process fir;

end Behavioral;
