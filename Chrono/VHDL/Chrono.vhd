-- Chrono implements a simple chronometer with minutes:seconds display.
--	 This is just to demonstrate VHDL code, the actual hardware is not suitable
--		for the instended purpose, at least LED drivers should be added, as it
--		stands display is too faint.
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
-- We assume a 50MHz clock to be available.

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
   CLK_50MHz : in std_logic;
	DISPLAY_SEG : out std_logic_vector(6 downto 0);
	DISPLAY_EN : out std_logic_vector(3 downto 0);
	DISPLAY_DP : out std_logic
);
end Chrono;  


architecture structure of Chrono is

	-- Driver for a seven segment display.
	--	Takes a bcd digit as input and drives directly one display.
	component SevenSegmentDriver
	port(	
		SEGM: out std_logic_vector(0 to 6);
		BCD : in std_logic_vector(3 downto 0)
	);
	end component;

	-- A 4-bit 3-state buffer.
	-- Presents input state in output if EN is high, has
	--		high impedance outputs othrwise.
	component ThreeStateBuffer is
	port(	
		I: in std_logic_vector(0 to 3);
		O : out std_logic_vector(0 to 3);
		EN: in std_logic
	);
	end component; 

	-- A 2 to 4 decoder.
	-- Keeps high one of the four outputs depending on the
	--		2-bits input value.
	component TwoToFourDecoder is
	port(	
		I: in std_logic_vector(0 to 1);
		O : out std_logic_vector(0 to 3)
	);
	end component;  

	-- A simple two bits counter.
	-- Output increases at every positive edge of clock.
	component TwoBitsCounter is
	port(	
		CLK: in std_logic;
		O : buffer std_logic_vector(1 downto 0)
	);
	end component;  

	-- Counter from 0 to 9.
	-- Output increases at every positive edge of clock.
	-- The carry output C is set when output rolls from 9 to 0.
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

		-- These are the 4 BCD counters set to have maximum of 5,9,5 and 9 respectively (59:59), they are cascaded so that at each
		--		digit carry the following digit will increase. The chain is fed by the 1Hz clock.
		--
		seconds_unit: BCDCounter port map (CLK => clock_1Hz, MAX => "1001", O => seconds_units_bcd, C => seconds_units_carry);
		seconds_tens: BCDCounter port map (CLK => seconds_units_carry, MAX => "0101", O => seconds_tens_bcd, C => seconds_tens_carry);
		minutes_units: BCDCounter port map (CLK => seconds_tens_carry, MAX => "1001", O => minutes_units_bcd, C => minutes_units_carry);
		minutes_tens: BCDCounter port map (CLK => minutes_units_carry, MAX => "0101", O => minutes_tens_bcd);
		
		
		-- These are the display drivers and the multiplexing logic. The display multiplexing is timed by the clock_multiplexer signal
		--		which runs at roughly 190Hz. The digital point is set only on the two middle digits, this is because the display used was
		--		ment specifically for clocks and has a colon separator in the middle connected to the second and third digit.
		--
		buf_0 : ThreeStateBuffer port map (I => seconds_units_bcd, O => selected_bcd, EN => en_d(3));
		buf_1 : ThreeStateBuffer port map (I => seconds_tens_bcd, O => selected_bcd, EN => en_d(2));
		buf_2 : ThreeStateBuffer port map (I => minutes_units_bcd, O => selected_bcd, EN => en_d(1));
		buf_3 : ThreeStateBuffer port map (I => minutes_tens_bcd, O => selected_bcd, EN => en_d(0));
		decoder : TwoToFourDecoder port map (I => cnt, O=>en_d);
		counter: TwoBitsCounter port map (CLK => clock_multiplexer, O => cnt);
	   display_driver: SevenSegmentDriver port map (SEGM => DISPLAY_SEG, BCD => selected_bcd);
		DISPLAY_EN <= en_d;
		DISPLAY_DP <= clock_1Hz or (not (en_d(1) or en_d(2)));
		
		-- Here we generate the board clocks starting from the 50MHz clock present in the circuit.
		-- We need:
		--		1 Hz for time keeping
		--	 190 Hz for display multiplexing
		--
		process (CLK_50MHz)		
	   begin	   
		if(CLK_50MHz = '1' and CLK_50MHz'event) then
			clock_counter <= clock_counter + 1;
			if(clock_counter = 25000000) then
				clock_1Hz <= not clock_1Hz;
				clock_counter <= std_logic_vector(to_unsigned(0, clock_counter'length));
			end if;
			
			-- This is roughly 190Hz (50E6 / 2^18)
			-- There is no reason for this value, as long as it's reasonably low but not too low
			--		to prevent flickering. Tapping on a bit of a counter is the easiert way to divide.
			clock_multiplexer <= clock_counter(17);
			
		end if;
		end process;
		
end structure;

--------------------------------------------------
