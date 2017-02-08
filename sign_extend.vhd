library IEEE;
use IEEE.std_logic_1164.all;

entity sign_extend is
port( 	
	func_sign: in std_logic_vector(1 downto 0);
	input : in std_logic_vector(15 downto 0);
	output_s: out std_logic_vector(31 downto 0));
end sign_extend;

architecture sign_extend_arch of sign_extend is
signal out_sig : std_logic_vector(31 downto 0);
begin
   process(func_sign, out_sig, input)
   begin
      case func_sign is
         when "00" => 
	   out_sig <= input & "0000000000000000";

	 when "01" => 
	    if(input(15) = '1') then
	       out_sig <= "1111111111111111" & input;
	    elsif(input(15) = '0') then
	       out_sig <= "0000000000000000" & input;
	    end if;

	 when "10" => 
	   if(input(15) = '1') then
	       out_sig <= "1111111111111111" & input;
	    elsif(input(15) = '0') then
	       out_sig <= "0000000000000000" & input;
	    end if;

	 when others => 
	   out_sig <= "0000000000000000" & input;
      end case;
   end process;

output_s <= out_sig;
end sign_extend_arch;
