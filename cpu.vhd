library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity cpu is
port(
	reset		: in std_logic;
	clk		: in std_logic;
	rs_out, rt_out 	: out std_logic_vector(3 downto 0);

	-- output ports from register file
	pc_out 		: out std_logic_vector(3 downto 0); -- pc reg
	overflow, zero 	: out std_logic); -- will not be constrained
					  -- in Xilinx since
					  -- not enough LEDs
end cpu;

architecture cpu_arch of cpu is
   component alu
   port(
        x, y : in std_logic_vector(31 downto 0);
        add_sub : in std_logic ;  
        logic_func : in std_logic_vector(1 downto 0) ;
        func_alu       : in std_logic_vector(1 downto 0) ;
        output_alu     : out std_logic_vector(31 downto 0) ;
        overflow   : out std_logic ;
        zero       : out std_logic);
   end component;

   component d_cache is
   port(	
	clk, reset, data_write : std_logic;
	add	: in std_logic_vector(4 downto 0);
	d_in	: in std_logic_vector(31 downto 0);
	d_out	: out std_logic_vector(31 downto 0));
   end component;

   component i_cache is
   port(	
	add 	: in std_logic_vector(4 downto 0);
	output_i	: out std_logic_vector(31 downto 0));
   end component;

   component mux1 is
   Port(	
	reg_in_src	: in std_logic;
        inpt0, inpt1	: in std_logic_vector(31 downto 0);
        mux_out		: out std_logic_vector(31 downto 0));
   end component;

   component mux2 is
   Port(	
	alu_src		: in std_logic;
        inpt0, inpt1	: in std_logic_vector(31 downto 0);
        mux_out		: out std_logic_vector(31 downto 0));
   end component;

   component mux3 is
   Port(	
	reg_dist	: in std_logic;
        inpt0, inpt1	: in std_logic_vector(4 downto 0);
        mux_out		: out std_logic_vector(4 downto 0));
   end component;

   component next_address is
   port(
	rt, rs 		: in std_logic_vector(31 downto 0);
	pc		: in std_logic_vector(31 downto 0);
	target_address	: in std_logic_vector(25 downto 0);
	branch_type 	: in std_logic_vector(1 downto 0);
	pc_sel 		: in std_logic_vector(1 downto 0);
	next_pc		: out std_logic_vector(31 downto 0));
   end component;

   component pc is
   port( 	
	clk, reset: in std_logic;
	d : in std_logic_vector(31 downto 0);
	q : out std_logic_vector(31 downto 0));
   end component;

   component regfile  is
   port( 
        din   : in std_logic_vector(31 downto 0);
        reset : in std_logic;
        clk   : in std_logic;
        write : in std_logic;
        read_a : in std_logic_vector(4 downto 0);
        read_b : in std_logic_vector(4 downto 0);
        write_address : in std_logic_vector(4 downto 0);
        out_a  : out std_logic_vector(31 downto 0);
        out_b  : out std_logic_vector(31 downto 0));
   end component;

   component sign_extend is
   port( 	
	func_sign: in std_logic_vector(1 downto 0);
	input : in std_logic_vector(15 downto 0);
	output_s: out std_logic_vector(31 downto 0));
   end component;

   component control_unit is
   port(
	op, func_control: in std_logic_vector(5 downto 0);
	output_c	: out std_logic_vector(13 downto 0));	
   end component;

signal next_address_out : std_logic_vector(31 downto 0);
signal pc_reg_out : std_logic_vector(31 downto 0);
signal i_cache_out : std_logic_vector(31 downto 0);
signal mux3_out : std_logic_vector(4 downto 0);
signal sign_extend_out : std_logic_vector(31 downto 0);
signal regfile_out_a : std_logic_vector(31 downto 0);
signal regfile_out_b : std_logic_vector(31 downto 0);
signal mux2_out : std_logic_vector(31 downto 0);
signal alu_out : std_logic_vector(31 downto 0);
signal alu_overflow : std_logic;
signal alu_zero : std_logic;
signal d_cache_out : std_logic_vector(31 downto 0);
signal mux1_out : std_logic_vector(31 downto 0);
signal control_unit_out : std_logic_vector(13 downto 0);

begin

   NA : next_address port map (
      	rt => regfile_out_b,
	rs => regfile_out_a,
	pc => pc_reg_out,
	target_address => i_cache_out(25 downto 0),  
	branch_type => control_unit_out(3 downto 2), 	
	pc_sel => control_unit_out(1 downto 0),	
	next_pc => next_address_out
	);

   PC1 : pc port map(
	clk => clk,
	reset => reset,
	d => next_address_out, 
	q => pc_reg_out
	);   

   IC : i_cache port map(	
	add => pc_reg_out(4 downto 0), 
	output_i => i_cache_out	
	);
   
   M3 : mux3 port map(
	reg_dist => control_unit_out(12),
        inpt0 => i_cache_out(20 downto 16),
	inpt1 => i_cache_out(15 downto 11),
        mux_out => mux3_out
	);	

   REG : regfile port map(
	din => mux1_out,
        reset => reset,
        clk => clk,
        write => control_unit_out(13),
        read_a => i_cache_out(25 downto 21),
        read_b => i_cache_out(20 downto 16),
        write_address => mux3_out,
        out_a => regfile_out_a,
        out_b => regfile_out_b
	);

   SIGN : sign_extend port map(
	func_sign => control_unit_out(5 downto 4),
	input => i_cache_out(15 downto 0),
	output_s => sign_extend_out
	);
	
   M2 : mux2 port map(
	alu_src	=> control_unit_out(10),
        inpt0 => regfile_out_b, 
	inpt1 => sign_extend_out,
        mux_out => mux2_out
	);

   ALU1 : alu port map(
	x => regfile_out_a, 
	y => mux2_out,
        add_sub => control_unit_out(9),  
        logic_func => control_unit_out(7 downto 6),
        func_alu => control_unit_out(5 downto 4),
        output_alu => alu_out,
        overflow => overflow,
        zero => zero
	);

   DC : d_cache port map(
	clk => clk, 
	reset => reset, 
	data_write => control_unit_out(8),
	add => alu_out(4 downto 0),
	d_in => regfile_out_b,
	d_out => d_cache_out
	);

   M1 : mux1 port map(
	reg_in_src => control_unit_out(11),
        inpt0 => d_cache_out, 
	inpt1 => alu_out,	
        mux_out => mux1_out
	);

   CONTROL : control_unit port map(
	op => i_cache_out(31 downto 26), --not sure about this
	func_control => i_cache_out(5 downto 0), -- not sure about this
	output_c => control_unit_out
	);
	
   rs_out <= (regfile_out_a(3 downto 0)); -- dont forget to negate 
   rt_out <= (regfile_out_b(3 downto 0));-- dont forget to negate 
   pc_out <= (pc_reg_out(3 downto 0));-- dont forget to negate 
		
end cpu_arch;

