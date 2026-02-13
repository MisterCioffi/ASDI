----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2026 05:56:43 PM
-- Design Name: 
-- Module Name: tb_System - Behavioral
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

entity tb_System is
-- L'entità del testbench è sempre vuota!
end tb_System;

architecture Behavior of tb_System is

    -- 1. Dichiarazione del componente da testare (DUT - Device Under Test)
    component System_Top_Level
        Port ( 
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            somma_finale : out STD_LOGIC_VECTOR (4 downto 0)
        );
    end component;

    -- 2. Segnali interni per pilotare il DUT
    signal tb_clk   : STD_LOGIC := '0';
    signal tb_reset : STD_LOGIC := '0';
    signal tb_somma : STD_LOGIC_VECTOR (4 downto 0);

    -- Costante per il periodo del clock (es. 20 ns -> 50 MHz)
    constant CLK_PERIOD : time := 20 ns;

begin

    -- 3. Istanziazione del Top Level (DUT)
    uut: System_Top_Level port map (
        clk          => tb_clk,
        reset        => tb_reset,
        somma_finale => tb_somma
    );

    -- ==========================================
    -- 4. Processo di Generazione del CLOCK
    -- ==========================================
    clk_process : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD/2;
        tb_clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- ==========================================
    -- 5. Processo di Stimolo (Reset iniziale)
    -- ==========================================
    stim_proc: process
    begin
        -- All'inizio teniamo il sistema in reset
        tb_reset <= '1';
        wait for 100 ns; 

        -- Rilasciamo il reset: la simulazione parte!
        tb_reset <= '0';
        
        -- Il testbench ora non deve fare altro, aspetta all'infinito 
        -- mentre il clock continua a girare e i nodi A e B lavorano.
        wait;
    end process;

end Behavior;