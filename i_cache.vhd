library IEEE;
use IEEE.std_logic_1164.all;

entity i_cache is
port(	
	add : in std_logic_vector(4 downto 0);
	output_i: out std_logic_vector(31 downto 0));
end i_cache;

architecture i_cache_arch of i_cache is
begin
   process(add)
   begin
      case add is
         when "00000" =>
            output_i <= "00100000001000000000000000000111";   --addi $rt0,$rs1,7 -> $rt0=7, $rs1=0
         when "00001" =>
           output_i <= "00100000001000100000000000000110";   --addi $rt2,$rs1,6 -> $rt2=6, $rs1=0
         when "00010" =>
           output_i <= "00000000000000100001100000100010";   --sub  $rd3,$rt0,$rt2 -> $rd3=7-6=1,$rt0=7,$rt2=6
         when "00011" =>
           output_i <= "10101100101000110000000000000000";   --sw $rt3,0($s5) -> MM[0+$s5]=$rt3=1
         when "00100" =>
           output_i <= "00000000011000100001100000100100";   --and $rt3,$rt3,$rt2 -> $rt3 = 1 AND 6 = 0
         when "00101" =>
           output_i <= "00101000011001000000000000000010";   --slti $rt4,$rt3,2 -> $rt3=0 < imm=2, $rt4 = 1
         when "00110" =>
           output_i <= "10001100101001100000000000000000";   --lw $rt6,0($s5) -> $rt6 = MM[0+$s5]=1
         when "00111" =>
           output_i <= "00000000110000100000100000100101";   --or $rt1,$rt6,$rt2 -> $rt1 = 1 OR 6 = 7
         when "01000" =>
           output_i <= "00000000001000100010100000100110";   --xor $rt5,$rt1,$rt2 -> $rt5 = 6 XOR 7 = 1
         when "01001" =>
           output_i <= "00000000101000100010100000100111";   --nor $rt5,$rt5,$rt2 -> $rt5 = 0001 NOR 0006 = -8
         when "01010" =>
           output_i <= "00110000010000110000000000000100";   --andi $rt3,$rt2,4 -> $rt3 = 6 ANDi 4 = 4
         when "01011" =>
           output_i <= "00110100101000110000000000000111";   --ori $rt3,$rt5,7 -> $rt3 = -8 ORi 7 = -1
         when "01100" =>
           output_i <= "00111000011000110000000000000110";   --xori $rt3,$rt3,6 -> $rt3 = -1 XORi 6 = -7
         when "01101" =>
           output_i <= "00000000101000110010000000101010";   --slt $rt4,$rt5,$rt3 -> $rt4 = 1 --> -8 < -7
         when "01110" =>
           output_i <= "00001000000000000000000000010000";   --j target -> target = 10000
         when "01111" =>
           output_i <= "00010000100001100000000000000001";   --beq $rt4,$rt6,1 -> if $rt4 == $rt6 then jump to ADD = 10001
         when "10000" =>
           output_i <= "00010100101000111111111111111110";   --bne $rt5,$rt3,(FFFE) -> if $rt5 != $rt3 then jump back to the previous instruction
         when "10001" =>
           output_i <= "00000100100000000000000000000000";   --bltz $rt4,0 -> branch all the way back to address 00000 if $rt4 < 0
         when "10010" =>
           output_i <= "00111100000001000000000000000001";   --lui $rt4,1 -> $rt4 = 1 << 16 = (65536)10
         when "10011" =>
           output_i <= "00000000100001000010000000100000";   --add $rt4,$rt4,$rt4
         when "10100" =>
           output_i <= "00000001010000000000000000001000";  --jr $rt10 -> jump to adress 00000 The whole program BEGINS executing again  
	 when "10101" => 
	   output_i <= "00000000000000000000000000000000";
	 when "10110" => 
	   output_i <= "00000000000000000000000000000000";
	 when "10111" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11000" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11001" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11010" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11011" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11100" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11101" => 
	   output_i <= "00000000000000000000000000000000";
	 when "11110" => 
	   output_i <= "00000000000000000000000000000000";
	 when others => 
	   output_i <= "00000000000000000000000000000000";
      end case;
   end process;
end i_cache_arch;
