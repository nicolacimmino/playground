--------------------------------------------------
-- Driver for a seven segments 4 digits display.
--
-- COMM  0-4 	out	Common lines of each display
-- SEGM  0-7 	out	Segments from a to g
-- INPUT 15-0 	in		Input value BCD coded (4 digits)
-- CLOCK 		in		Clock
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
--------------------------------------------------

entity SevenSegmentDriver is
port(	
	COMM: out std_logic_vector(0 to 3);
	SEGM: out std_logic_vector(0 to 6);
   signal INPUT : buffer std_logic_vector(15 downto 0);
	CLK: in std_logic
);
end SevenSegmentDriver;  

--------------------------------------------------


architecture Behaviour of SevenSegmentDriver is
begin
    
	 COMM <= "0000";
	 	 
	 process (INPUT)
		BEGIN
	 case  INPUT is
		when "0000"=> SEGM <="0000001";  -- '0'
		when "0001"=> SEGM <="1001111";  -- '1'
		when "0010"=> SEGM <="0010010";  -- '2'
		when "0011"=> SEGM <="0000110";  -- '3'
		when "0100"=> SEGM <="1001100";  -- '4' 
		when "0101"=> SEGM <="0100100";  -- '5'
		when "0110"=> SEGM <="0100000";  -- '6'
		when "0111"=> SEGM <="0001111";  -- '7'
		when "1000"=> SEGM <="0000000";  -- '8'
		when "1001"=> SEGM <="0000100";  -- '9'
		when others=> SEGM <="1111111"; 		
	end case;
	end process;

end Behaviour;

--------------------------------------------------