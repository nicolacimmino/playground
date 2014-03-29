--------------------------------------------------
-- Driver for a seven segments display.
--
-- SEGM  0-7 	out	Segments from a to g
-- BCD   15-0 	in		Input value BCD coded (4 digits)
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