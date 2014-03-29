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