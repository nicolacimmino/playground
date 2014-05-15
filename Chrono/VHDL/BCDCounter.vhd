-- BCDCounter implements a counter with programmable max value.
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
-- Two to four decoder.
--
-- CLK  			in    	Clock
-- MAX  3-0    in			Max value
-- O    3-0 	out		Outputs
-- C           out      Carry      
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
--------------------------------------------------

entity BCDCounter is
port(	
	CLK: in std_logic;
	MAX: in std_logic_vector(3 downto 0);
   O : buffer std_logic_vector(3 downto 0);
	C : out std_logic
);
end BCDCounter;  

--------------------------------------------------


architecture Behaviour of BCDCounter is
begin
	process (CLK, O)
	begin
		-- On the rising edge of the clock we increment
		--	 and if we reach maximum we reset the counter
		--	 and flag the carry. Carry will be reset on the
		--	 following clock rising edge.
		if(CLK='1' and CLK'event) then
			if(O = MAX) then
				O <= "0000";
				C <= '1';
			else
				O <= O + 1;
				C <= '0';
			end if;
		end if;
	end process;
end Behaviour;

--------------------------------------------------