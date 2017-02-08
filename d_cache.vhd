--D-CACHE
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity d_cache is
port(	
	clk, reset, data_write : std_logic;
	add: in std_logic_vector(4 downto 0);
	d_in: in std_logic_vector(31 downto 0);
	d_out: out std_logic_vector(31 downto 0));
end d_cache;

architecture d_cache_arch of d_cache is
type data_array is array (0 to 31) of std_logic_vector(31 downto 0);
signal d_array : data_array;
begin
   process(clk,reset,add)
   begin
      if(reset = '1') then
       	 for I in 0 to 31 loop
            d_array(I) <= (others => '0');
       	 end loop;

      elsif(clk'event and clk = '1' and data_write = '1') then
         d_array(to_integer(unsigned(add))) <= d_in;

    	 end if;
    end process;
d_out <= d_array(to_integer(unsigned(add)));    
end d_cache_arch;
