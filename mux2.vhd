library IEEE;
use IEEE.std_logic_1164.ALL;

entity mux2 is
Port(	
	alu_src		: in std_logic;
        inpt0, inpt1	: in std_logic_vector(31 downto 0);
        mux_out		: out std_logic_vector(31 downto 0));
end mux2;

architecture mux2_arch of mux2 is
begin
    mux_out <= inpt0 when (alu_src = '0') else inpt1;
end mux2_arch;
