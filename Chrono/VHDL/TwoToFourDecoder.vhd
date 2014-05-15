-- TwoToFourDecoder implements a two to four bits decoder.
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
-- I    0-1 	in    	Inputs
-- O    0-3 	out		Outputs
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
--------------------------------------------------

entity TwoToFourDecoder is
port(	
	I: in std_logic_vector(0 to 1);
   O : out std_logic_vector(0 to 3)
);
end TwoToFourDecoder;  

--------------------------------------------------


architecture Behaviour of TwoToFourDecoder is
begin
	process (I)
	begin
		case  I is
			when "00"=> O <="0001";
			when "01"=> O <="0010";
			when "10"=> O <="0100";
			when "11"=> O <="1000";
		end case;
	end process;
end Behaviour;

--------------------------------------------------