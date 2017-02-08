library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity control_unit is
port(
	op, func_control: in std_logic_vector(5 downto 0);
	output_c	: out std_logic_vector(13 downto 0));
	
end control_unit;

architecture control_arch of control_unit is
signal sig : std_logic_vector(13 downto 0);
begin
   sig <= "11100000100000" when func_control = "100000" else
	  "11101000100000" when func_control = "100010" else
	  "10100000010000" when func_control = "101010" else
          "11101000110000" when func_control = "100100" else
	  "11100001110000" when func_control = "100101" else
	  "11100010110000" when func_control = "100110" else
	  "11100011110000" when func_control = "100111" else
	  "00000000000010" when func_control = "001000";

   output_c <= "10110000000000" when op = "001111" else
   	     "10110000100000" when op = "001000" else -- same
	     "10110000100000" when op = "001010" else -- same
             "10110000110000" when op = "001100" else
	     "10110001110000" when op = "001101" else
	     "10110010110000" when op = "001110" else
	     "10010010100000" when op = "100011" else
	     "00010100100000" when op = "101011" else -- do we put dont cares??
	     "00000000000001" when op = "000010" else
	     "00000000001100" when op = "000001" else
	     "00000000000100" when op = "000100" else
	     "00000000001000" when op = "000101" else
	     sig when op = "000000";
end control_arch;

