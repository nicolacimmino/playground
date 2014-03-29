--------------------------------------------------
-- Driver for a seven segments display.
--
-- SEGM  0-7 	out	Segments from a to g
-- BCD   15-0 	in		Input value BCD coded (4 digits)
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;
--------------------------------------------------

entity Chrono is
port(	
   CLK_1MHz : in std_logic;
	DISPLAY_SEG : out std_logic_vector(6 downto 0);
	DISPLAY_EN : out std_logic_vector(3 downto 0);
	DISPLAY_DP : out std_logic
);
end Chrono;  


architecture structure of Chrono is


	component SevenSegmentDriver
	port(	
		SEGM: out std_logic_vector(0 to 6);
		BCD : in std_logic_vector(3 downto 0)
	);
	end component;

	
	component ThreeStateBuffer is
	port(	
		I: in std_logic_vector(0 to 3);
		O : out std_logic_vector(0 to 3);
		EN: in std_logic
	);
	end component; 

	component TwoToFourDecoder is
	port(	
		I: in std_logic_vector(0 to 1);
		O : out std_logic_vector(0 to 3)
	);
	end component;  

	component TwoBitsCounter is
	port(	
		CLK: in std_logic;
		O : buffer std_logic_vector(1 downto 0)
	);
	end component;  

	component BCDCounter is
	port(	
		CLK: in std_logic;
		MAX: in std_logic_vector(3 downto 0);
		O : buffer std_logic_vector(3 downto 0);
		C : out std_logic
	);
	end component; 

	
	signal current_number : std_logic_vector(15 downto 0);
	signal selected_bcd : std_logic_vector(3 downto 0);
	signal en_d : std_logic_vector(3 downto 0);
	signal cnt : std_logic_vector(1 downto 0);
	signal clock_counter : std_logic_vector(25 downto 0);
	signal clock_multiplexer : std_logic;
	signal clock_1Hz : std_logic;
	signal seconds_units_bcd, seconds_tens_bcd,  minutes_units_bcd, minutes_tens_bcd  : std_logic_vector(3 downto 0);
	signal seconds_units_carry, seconds_tens_carry, minutes_units_carry, minutes_tens_carry : std_logic; 
	
begin
		--current_number <= std_logic_vector(to_unsigned(16#2014#, current_number'length));
		seconds_unit: BCDCounter port map (CLK => clock_1Hz, MAX => "1001", O => seconds_units_bcd, C => seconds_units_carry);
		seconds_tens: BCDCounter port map (CLK => seconds_units_carry, MAX => "0101", O => seconds_tens_bcd, C => seconds_tens_carry);
		minutes_units: BCDCounter port map (CLK => seconds_tens_carry, MAX => "1001", O => minutes_units_bcd, C => minutes_units_carry);
		minutes_tens: BCDCounter port map (CLK => minutes_units_carry, MAX => "0101", O => minutes_tens_bcd);
		
		
		
		buf_0 : ThreeStateBuffer port map (I => seconds_units_bcd, O => selected_bcd, EN => en_d(3));
		buf_1 : ThreeStateBuffer port map (I => seconds_tens_bcd, O => selected_bcd, EN => en_d(2));
		buf_2 : ThreeStateBuffer port map (I => minutes_units_bcd, O => selected_bcd, EN => en_d(1));
		buf_3 : ThreeStateBuffer port map (I => minutes_tens_bcd, O => selected_bcd, EN => en_d(0));
		
		decoder : TwoToFourDecoder port map (I => cnt, O=>en_d);
		counter: TwoBitsCounter port map (CLK => clock_multiplexer, O => cnt);
	   display_driver: SevenSegmentDriver port map (SEGM => DISPLAY_SEG, BCD => selected_bcd);
		DISPLAY_EN <= en_d;
		--DISPLAY_DP <= clock_counter(23) and en_d(0) and en_d(3);
		DISPLAY_DP <= clock_1Hz or (not (en_d(1) or en_d(2)));
		
		process (CLK_1MHz)		
	   begin	   
		if(CLK_1MHz = '1' and CLK_1MHz'event) then
			clock_counter <= clock_counter + 1;
			if(clock_counter = 25000000) then
				clock_1Hz <= not clock_1Hz;
				clock_counter <= std_logic_vector(to_unsigned(0, clock_counter'length));
			end if;
			
			-- This is roughly 100Hz
			clock_multiplexer <= clock_counter(17);
			
		end if;
		end process;
		
end structure;

--------------------------------------------------


--architecture Behaviour of SevenSegmentDriver is
--begin
--	process (CLK)		
		
--	end process;

--end Behaviour;

--------------------------------------------------