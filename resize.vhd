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
-- This IP was created as a part of the IIR Hardware proect. It will resize a
-- 12 bit input to a 32 bit output.
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity resize_IP is
    Port ( i_value : in STD_LOGIC_VECTOR (11 downto 0);
           o_value : out STD_LOGIC_VECTOR (31 downto 0));
end resize_IP;

architecture Behavioral of resize_IP is

begin

  p_resize : process (i_value)
  begin
    o_value <= std_logic_vector(resize(signed(i_value), 32));
  end process;

end Behavioral;
