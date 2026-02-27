----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 10:46:13 AM
-- Design Name: 
-- Module Name: TB_MoltBooth8bit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity TB_MoltBooth8bit is
end TB_MoltBooth8bit;

architecture Test of TB_MoltBooth8bit is
    signal clk       : std_logic := '0';
    signal rst_n     : std_logic := '0';
    signal start     : std_logic := '0';
    signal in_X      : std_logic_vector(7 downto 0) := (others => '0');
    signal in_Y      : std_logic_vector(7 downto 0) := (others => '0');
    signal out_P     : std_logic_vector(15 downto 0);
    signal done      : std_logic;

    constant CLK_PERIOD : time := 10 ns;
begin

    -- Istanza del componente
    inst_molt: entity work.MoltBooth8bit
        port map (
            clk => clk,
            reset_n => rst_n,
            avvio => start,
            dato_X => in_X,
            dato_Y => in_Y,
            risultato => out_P,
            fatto => done
        );

    -- Generatore di clock
    clk <= not clk after CLK_PERIOD/2;

    -- Processo di stimolo
    proc_test: process
    begin
        -- Inizializzazione
        rst_n <= '0';
        wait for 25 ns;
        rst_n <= '1';
        wait for CLK_PERIOD;

        -- Test 1: 15 * 4 = 60
        in_X <= std_logic_vector(to_signed(15, 8));
        in_Y <= std_logic_vector(to_signed(4, 8));
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until done = '1';
        wait for CLK_PERIOD * 2;

        -- Test 2: -7 * 3 = -21
        in_X <= std_logic_vector(to_signed(-7, 8));
        in_Y <= std_logic_vector(to_signed(3, 8));
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until done = '1';
        wait for CLK_PERIOD * 2;

        -- Test 3: -5 * -6 = 30
        in_X <= std_logic_vector(to_signed(-5, 8));
        in_Y <= std_logic_vector(to_signed(-6, 8));
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until done = '1';

        wait;
    end process;

end Test;
