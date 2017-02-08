library IEEE;
use IEEE.std_logic_1164.all;

entity pc is
port( 	
	clk, reset: in std_logic;
	d : in std_logic_vector(31 downto 0);
	q: out std_logic_vector(31 downto 0));
end pc;
architecture pc_arch of pc is
begin
   process(clk,reset)
   begin
	if (reset='1') then
	   q<="00000000000000000000000000000000";

	elsif (clk'event and clk='1') then
	   q<=d;

	end if;
    end process;
end pc_arch;
