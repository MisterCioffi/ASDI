----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 17:57:27
-- Design Name: 
-- Module Name: unita_operativa - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity unita_operativa is
    port( 
        X, Y: in std_logic_vector(7 downto 0); --moltiplicatore e moltiplicando
        clock, reset: in std_logic;
        loadA, loadQ, loadM : in std_logic;
        shift, subtract, reset_init, count_in : in std_logic;
        q0, q_minus1 : out std_logic;
        counter: out std_logic_vector(2 downto 0);
        P: out std_logic_vector(15 downto 0)
    );
end unita_operativa;

architecture Structural of unita_operativa is

    component adder_sub is
	port( X, Y: in std_logic_vector(7 downto 0);
		  cin: in std_logic;
		  Z: out std_logic_vector(7 downto 0);
		  cout: out std_logic);		  
	end component;
	
	component registro8 is 
		port( A: in std_logic_vector(7 downto 0);
		  clk, res, load: in std_logic;
		  B: out std_logic_vector(7 downto 0));
	end component;

	component shift_register is
	port( parallel_in: in std_logic_vector(7 downto 0);
		  serial_in: in std_logic;
		  clock, reset, load, shift: in std_logic;
		  parallel_out: out std_logic_vector(7 downto 0));	  
	end component;
	
	component FFD is
        port( 
            clock  : in std_logic;
            reset  : in std_logic;
            enable : in std_logic;
            d      : in std_logic;
            y      : out std_logic
        );
    end component;
	
	component cont_mod8 is
	port( clock,  reset: in std_logic;
		  count_in: in std_logic;
		  count: out std_logic_vector(2 downto 0));
	end component;
    
    signal internal_reset : std_logic := '0';
    signal out_reg_M, out_reg_A, out_reg_Q : std_logic_vector(7 downto 0);
    signal in_reg_A : std_logic_vector(7 downto 0) := (others => '0');
    signal riporto: std_logic; -- riporto in uscita dell'adder che non utilizziamo

begin

    internal_reset <= reset or reset_init;

    reg_M : registro8 port map (
        A => Y,
        clk => clock,
        res => reset,
        load => loadM,
        B => out_reg_M
    );
    
    reg_A : shift_register port map (
        parallel_in => in_reg_A,
        serial_in => out_reg_A(7),
        clock => clock,
        reset => internal_reset,
        load => loadA,
        shift => shift,
        parallel_out => out_reg_A
    );

    reg_Q : shift_register port map (
        parallel_in => X,
        serial_in => out_reg_A(0),
        clock => clock,
        reset => reset,
        load => loadQ,
        shift => shift,
        parallel_out => out_reg_Q
    );
    
    ff_q_minus1 : FFD port map (
        clock => clock,
        reset => internal_reset,
        enable => shift,
        d => out_reg_Q(0),
        y => q_minus1
    );

    CONT : cont_mod8 port map ( 
        clock => clock,
        reset => internal_reset,
		count_in => count_in,
		count => counter
	);
	
	ADDER: adder_sub port map (
	   X => out_reg_A,
	   Y => out_reg_M,
	   cin => subtract,
	   Z => in_reg_A,
	   cout => riporto
	);
	
	P <= out_reg_A & out_reg_Q;
	q0 <= out_reg_Q(0);
    
end Structural;
