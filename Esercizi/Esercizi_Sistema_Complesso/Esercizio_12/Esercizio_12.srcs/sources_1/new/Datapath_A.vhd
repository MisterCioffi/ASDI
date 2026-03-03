----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
-- Design Name: 
-- Module Name: Datapath_A - Behavioral
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

entity Datapath_A is
    port(
        clk, rst : in STD_LOGIC;
        read : in STD_LOGIC;
        load_temp, load_RA : in STD_LOGIC;
        start_m : in STD_LOGIC;
        en_cont16 : in STD_LOGIC;
        cont16 : out STD_LOGIC_VECTOR(3 downto 0);
        done_m : out STD_LOGIC;
        product_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Datapath_A;

architecture Structural of Datapath_A is

    component Contatore_mod16 
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            en : in STD_LOGIC;
            cont : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component molt_rob 
  	    port( 
            clock, reset, start: in std_logic;
		    X, Y: in std_logic_vector(3 downto 0);  
		    P: out std_logic_vector(7 downto 0);
		    stop_cu: out std_logic
    );  
    end component;

    component reg_pp
        generic (
            N : integer := 8
        );
        port(
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            load : in STD_LOGIC;
            d : in STD_LOGIC_VECTOR(N-1 downto 0);
            q : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    component Memoria_ROM 
        port (
            clk      : in  std_logic;
            read_en  : in  std_logic;                               
            addr     : in  std_logic_vector(3 downto 0);            
            data_out : out std_logic_vector(3 downto 0) 
        );
    end component;

    signal temp_cont16 : STD_LOGIC_VECTOR(3 downto 0);
    signal output_rom : STD_LOGIC_VECTOR(3 downto 0);
    signal output_reg_temp : STD_LOGIC_VECTOR(3 downto 0);

    signal product : STD_LOGIC_VECTOR(7 downto 0);

begin

    Cont16_inst : Contatore_mod16
        port map (
            clk => clk,
            rst => rst,
            en => en_cont16,
            cont => temp_cont16
        );

    ROM_inst : Memoria_ROM
        port map (
            clk => clk,
            read_en => read,
            addr => temp_cont16,
            data_out => output_rom
        );

    temp : reg_pp
        generic map (
            N => 4
        )
        port map (
            clk => clk,
            reset => rst,
            load => load_temp,
            d => output_rom,
            q => output_reg_temp
        );

    molt_inst : molt_rob
        port map (
            clock => clk,
            reset => rst,
            start => start_m,
            X => output_rom,
            Y => output_reg_temp,
            P => product,
            stop_cu => done_m
    );

    RA : reg_pp
        generic map (
            N => 8
        )
        port map (
            clk => clk,
            reset => rst,
            load => load_RA,
            d => product(7 downto 0), 
            q => product_out
        );

end Structural;
