library IEEE;
use IEEE.std_logic_1164.ALL;

entity mux1 is
Port(	
	reg_in_src	: in std_logic;
        inpt0, inpt1	: in std_logic_vector(31 downto 0);
        mux_out		: out std_logic_vector(31 downto 0));
end mux1;

architecture mux1_arch of mux1 is
begin
    mux_out <= inpt0 when (reg_in_src = '0') else inpt1;
end mux1_arch;
