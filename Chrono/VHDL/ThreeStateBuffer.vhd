-- ThreeStateBuffer implements a simple 3-state 4-bits buffer.
--
--  Copyright (C) 2014 Nicola Cimmino
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--   This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see http://www.gnu.org/licenses/.
--
--------------------------------------------------
-- 3-state 4-bits buffer.
--
-- I    0-3 	in    	Inputs
-- O    0-3 	out		Outputs
-- EN				in			If low outputs HI-Z
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
--------------------------------------------------

entity ThreeStateBuffer is
port(	
	I: in std_logic_vector(0 to 3);
   O : out std_logic_vector(0 to 3);
	EN: in std_logic
);
end ThreeStateBuffer;  

--------------------------------------------------

architecture Behaviour of ThreeStateBuffer is
begin
	process (EN, I)
	begin
		-- We just mirror input to output unless EN=0
		--		in which case we put the output to hi-impedance
		if(EN = '1') then
			O <= I;
		else
			O <= "ZZZZ";
		end if;
	end process;
end Behaviour;

--------------------------------------------------