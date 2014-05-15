-- TwoBitsCounter implements a counter.
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
-- Two bits counter.
--
-- CLK  			in    	Clock
-- O    0-1 	out		Outputs
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
--------------------------------------------------

entity TwoBitsCounter is
port(	
	CLK: in std_logic;
   O : buffer std_logic_vector(1 downto 0)
);
end TwoBitsCounter;  

--------------------------------------------------


architecture Behaviour of TwoBitsCounter is
begin
	process (CLK, O)
	begin
	   -- At every clock rising edge we increment.
		if(CLK='1' and CLK'event) then
			O <= O + 1;
		end if;
	end process;
end Behaviour;

--------------------------------------------------