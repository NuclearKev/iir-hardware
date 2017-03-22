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
-- This IP was created as a part of the IIR Hardware proect. It will send the
-- input to one of the outputs based on the select.
--
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dmux is
    Port ( i_select : in STD_LOGIC_VECTOR(7 downto 0);
           i        : in STD_LOGIC;
           o_0      : out STD_LOGIC;
           o_1      : out STD_LOGIC;
           o_2      : out STD_LOGIC;
           o_3      : out STD_LOGIC;
           o_4      : out STD_LOGIC;
           o_5      : out STD_LOGIC;
           o_6      : out STD_LOGIC;
           o_7      : out STD_LOGIC);
end dmux;

architecture Behavioral of dmux is

begin

  p_dmux : process (i_select)
  begin
    case i_select is
      when x"00" =>
        o_0 <= i;
      when x"01" =>
        o_1 <= i;
      when x"02" =>
        o_2 <= i;
      when x"03" =>
        o_3 <= i;
      when x"04" =>
        o_4 <= i;
      when x"05" =>
        o_5 <= i;
      when x"06" =>
        o_6 <= i;
      when x"07" =>
        o_7 <= i;
      when others =>
        -- do nothing
    end case;
  end process;

end Behavioral;
