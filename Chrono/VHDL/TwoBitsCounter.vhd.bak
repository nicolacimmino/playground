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