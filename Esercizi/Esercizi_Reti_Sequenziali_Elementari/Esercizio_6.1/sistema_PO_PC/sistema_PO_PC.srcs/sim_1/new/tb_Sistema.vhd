----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 05:39:37 PM
-- Design Name: 
-- Module Name: tb_Sistema - Behavioral
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

entity tb_Sistema is
-- vuoto
end tb_Sistema;

architecture behavior of tb_Sistema is

    -- Segnali di test
    signal t_clk       : std_logic := '0';
    signal t_rst       : std_logic := '0';
    signal t_start     : std_logic := '0';
    signal t_stringa_x : std_logic_vector(7 downto 0) := (others => '0');

    constant clk_period : time := 10 ns;

begin

    -- Istanziamo il Top-Level
    uut: entity work.Sistema_TopLevel
        generic map ( ADDR_WIDTH => 4 )
        port map (
            CLK => t_clk,
            RST => t_rst,
            START => t_start,
            STRINGA_X => t_stringa_x
        );

    -- Generazione del Clock
    clk_process : process
    begin
        t_clk <= '0'; wait for clk_period/2;
        t_clk <= '1'; wait for clk_period/2;
    end process;

    -- Processo di Stimolo
    stim_proc: process
    begin
        -- 1. Reset iniziale del sistema
        t_rst <= '1';
        wait for 20 ns;
        t_rst <= '0';
        wait for 20 ns;

        -- 2. Impostiamo la stringa da cercare (Cerchiamo x"AA")
        t_stringa_x <= x"AA";
        
        -- 3. Diamo il comando di START (un impulso)
        t_start <= '1';
        wait for clk_period; -- Lo teniamo alto per 1 colpo di clock
        t_start <= '0';

        -- 4. Ora ci mettiamo comodi e lasciamo lavorare la FSM!
        -- Il sistema ha 16 locazioni. Per ogni locazione la FSM spende 2 stati 
        -- (READ_ROM e EVALUATE). Quindi ci vorranno circa 32 colpi di clock (320 ns).
        wait for 400 ns;

        -- Fine simulazione
        assert false report "Scansione Memoria Completata!" severity failure;
        wait;
    end process;

end behavior;