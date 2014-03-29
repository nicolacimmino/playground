--------------------------------------------------
-- Two to four decoder.
--
-- CLK  			in    	Clock
-- O    0-3 	out		Outputs
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
		if(CLK='1' and CLK'event) then
			O <= O + 1;
		end if;
	end process;
end Behaviour;

--------------------------------------------------