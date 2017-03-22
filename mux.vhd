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
-- This IP was created as a part of the IIR Hardware project. It will send an
-- input to the output based on the select.
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( i_select : in STD_LOGIC_VECTOR (7 downto 0);
           i_0      : in STD_LOGIC_VECTOR (11 downto 0);
           i_1      : in STD_LOGIC_VECTOR (11 downto 0);
           i_2      : in STD_LOGIC_VECTOR (11 downto 0);
           i_3      : in STD_LOGIC_VECTOR (11 downto 0);
           i_4      : in STD_LOGIC_VECTOR (11 downto 0);
           i_5      : in STD_LOGIC_VECTOR (11 downto 0);
           o        : out STD_LOGIC_VECTOR (11 downto 0));
end mux;

architecture Behavioral of mux is

begin


  p_dmux : process (i_select)
  begin
    case i_select is
      when x"00" =>
        o <= i_0;
      when x"01" =>
        o <= i_1;
      when x"02" =>
        o <= i_2;
      when x"03" =>
        o <= i_3;
      when others =>
        -- do nothing
    end case;
  end process;

end Behavioral;
