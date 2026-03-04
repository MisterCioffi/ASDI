----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
-- Design Name: 
-- Module Name: Datapath_B - Behavioral
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

entity Datapath_B is
    port(
        clk, rst : in STD_LOGIC;
        write : in STD_LOGIC;
        load_RB : in STD_LOGIC;
        en_cont8 : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(7 downto 0);
        alpha, beta : out STD_LOGIC;
        cont8 : inout STD_LOGIC_VECTOR(2 downto 0)
    );
end Datapath_B;

architecture Structural of Datapath_B is

    component Contatore_mod8 
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            en : in STD_LOGIC;
            count : out STD_LOGIC_VECTOR(2 downto 0)
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

    component Memoria_MEM
        port (
            CLK       : in  std_logic;
            WRITE_EN  : in  std_logic;                                
            ADDR      : in  std_logic_vector(2 downto 0);  
            DATA_IN   : in  std_logic_vector(7 downto 0);             
            DATA_OUT  : out std_logic_vector(7 downto 0)              
        );
    end component;

    component Comparatore_8bit
        port ( 
            IN_A  : in  std_logic_vector(7 downto 0);
            IN_B  : in  std_logic_vector(7 downto 0);
            alpha : out std_logic; 
            beta  : out std_logic 
        );
    end component;

    signal output_reg_b : STD_LOGIC_VECTOR(7 downto 0);
    signal value_x : STD_LOGIC_VECTOR(7 downto 0); -- Valore costante da confrontare con il registro B

begin

    contatore : Contatore_mod8
        port map (
            clk => clk,
            rst => rst,
            en => en_cont8,
            count => cont8
        );

    RB : reg_pp
        generic map (
            N => 8
        )
        port map (
            clk => clk,
            reset => rst,
            load => load_RB,
            d => data_in,
            q => output_reg_b
        );

    RX : reg_pp
        generic map (
            N => 8
        )
        port map (
            clk => clk,
            reset => '0',
            load => '1', 
            d => x"05", 
            q => value_x
        );

    MEM : Memoria_MEM
        port map (
            CLK => clk,
            WRITE_EN => write,
            ADDR => cont8, 
            DATA_IN => output_reg_b, 
            DATA_OUT => open -- Non ci interessa l'uscita di questa memoria per ora
        );

    COMP : Comparatore_8bit
        port map (
            IN_A => output_reg_b, 
            IN_B => value_x,
            alpha => alpha,
            beta => beta
        );


end Structural;
