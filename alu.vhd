library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity alu is

port(
     x, y : in std_logic_vector(31 downto 0);
     add_sub : in std_logic ;  
     logic_func : in std_logic_vector(1 downto 0) ;
     func_alu       : in std_logic_vector(1 downto 0) ;
     output_alu     : out std_logic_vector(31 downto 0) ;
     overflow   : out std_logic ;
     zero       : out std_logic);
end alu ;

architecture arch_alu of alu is
signal arith_out: std_logic_vector(31 downto 0);
signal logic_out: std_logic_vector(31 downto 0);
signal slt_out: std_logic_vector(31 downto 0);
signal y_num: signed(31 downto 0);
signal x_num: signed(31 downto 0);
signal overflow_sig: std_logic;
signal zero_sig: std_logic;
begin
   y_num <= signed(y);
   x_num <= signed(x);


   arith_out <= std_logic_vector(x_num + y_num) when add_sub = '0' else
	        std_logic_vector(x_num - y_num);
	
   overflow_sig <= '1' when ((x_num(31) = y_num(31) and arith_out(31) /= x_num(31) and add_sub = '0') or (x_num(31) /= y_num(31) and arith_out(31) = y_num(31) and add_sub = '1')) else
		   '0';
   
   zero_sig <= '1' when (arith_out = "00000000000000000000000000000000") else
	       '0';

   logic_out <= x AND y when (logic_func = "00") else
                x OR y when (logic_func = "01") else
	        x XOR y when (logic_func = "10") else
	        x NOR y;

    slt_out <= "00000000000000000000000000000001" when (x_num < y_num) else
	       "00000000000000000000000000000000";

    output_alu <= y when (func_alu = "00") else
                  slt_out when (func_alu = "01") else
		  arith_out when (func_alu = "10") else
		  logic_out;
                  
    overflow <= overflow_sig when func_alu = "10";
    zero <= zero_sig when func_alu = "10";
end arch_alu;

