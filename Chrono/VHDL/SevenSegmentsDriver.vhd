-- SevenSegmentDriver implements a driver for a 7-segments display.
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
-- Driver for a seven segments display.
--
-- SEGM  0-7 	out	Segments from a to g
-- BCD   3-0 	in		Input value BCD coded
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
--------------------------------------------------

entity SevenSegmentDriver is
port(	
	SEGM: out std_logic_vector(6 downto 0);
   BCD : in std_logic_vector(3 downto 0)
);
end SevenSegmentDriver;  

--------------------------------------------------


architecture Behaviour of SevenSegmentDriver is
begin
	process (BCD)		
	begin	    
		case  BCD is
			when "0000"=> SEGM <="1000000";  -- '0'
			when "0001"=> SEGM <="1111001";  -- '1'
			when "0010"=> SEGM <="0100100";  -- '2'
			when "0011"=> SEGM <="0110000";  -- '3'
			when "0100"=> SEGM <="0011001";  -- '4' 
			when "0101"=> SEGM <="0010010";  -- '5'
			when "0110"=> SEGM <="0000010";  -- '6'
			when "0111"=> SEGM <="1111000";  -- '7'
			when "1000"=> SEGM <="0000000";  -- '8'
			when "1001"=> SEGM <="0010000";  -- '9'
			when others=> SEGM <="1111111"; 		
		end case;
	end process;

end Behaviour;

--------------------------------------------------