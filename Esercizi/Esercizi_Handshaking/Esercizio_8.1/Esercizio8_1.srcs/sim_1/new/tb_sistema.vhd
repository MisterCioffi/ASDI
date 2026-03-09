----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.02.2026 10:36:06
-- Design Name: 
-- Module Name: tb_sistema - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- L'entità del testbench è sempre vuota perché non ha pin verso l'esterno
entity tb_Sistema is
end tb_Sistema;

architecture behavior of tb_Sistema is

    component Sistema
        port(
            clk         : in STD_LOGIC;
            rst         : in STD_LOGIC;
            start       : in STD_LOGIC;
            sum_final   : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            carry_final : out STD_LOGIC
        );
    end component;

    signal clk, rst    : std_logic := '0';
    signal start       : std_logic := '0';
    signal sum_final   : std_logic_vector(3 downto 0);
    signal carry_final : std_logic;

    -- periodo del segnale di Clock
    constant clk_period : time := 10 ns;

begin

    uut: Sistema port map (
        clk         => clk,
        rst         => rst,
        start       => start,
        sum_final   => sum_final,
        carry_final => carry_final
    );

    -- generazione del Clock continuo
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
    
        rst <= '1';
        start <= '0';
        wait for 30 ns; 
        
        rst <= '0';
        wait for 20 ns;
        
        -- START per avviare il Trasmettitore
        start <= '1';
        wait for clk_period; 
        start <= '0';
        
        -- attesa esecuzione operazioni
        wait for 2000 ns; 
        
        wait;
    end process;

end behavior;
