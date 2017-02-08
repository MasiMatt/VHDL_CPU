library IEEE;
use IEEE.std_logic_1164.ALL;

entity mux3 is
Port(	
	reg_dist	: in std_logic;
        inpt0, inpt1	: in std_logic_vector(4 downto 0);
        mux_out		: out std_logic_vector(4 downto 0));
end mux3;

architecture mux3_arch of mux3 is
begin
    mux_out <= inpt0 when (reg_dist = '0') else inpt1;
end mux3_arch;
