--------------------------------------------------
-- Three state 4 bits buffer.
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
		if(EN = '1') then
			O <= I;
		else
			O <= "ZZZZ";
		end if;
	end process;
end Behaviour;

--------------------------------------------------