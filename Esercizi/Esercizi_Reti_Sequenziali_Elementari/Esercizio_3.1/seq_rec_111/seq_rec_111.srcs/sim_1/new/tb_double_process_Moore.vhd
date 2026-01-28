----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2026 03:31:16 PM
-- Design Name: 
-- Module Name: tb_double_process_Moore - Behavioral
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

entity tb_double_process_Moore is
-- Entity vuota
end tb_double_process_Moore;

architecture Behavioral of tb_double_process_Moore is

    -- 1. Dichiarazione Componente (UUT)
    component double_process_Moore
    port(
        I   : in std_logic;
        A   : in std_logic; -- Clock
        RST : in std_logic;
        Y   : out std_logic
    );
    end component;

    -- 2. Segnali Interni
    signal tb_I   : std_logic := '0';
    signal tb_A   : std_logic := '0'; -- Piloterà la porta A
    signal tb_RST : std_logic := '0';
    signal tb_Y   : std_logic;

    -- Costanti
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. Istanziazione UUT
    uut: double_process_Moore port map (
        I   => tb_I,
        A   => tb_A,
        RST => tb_RST,
        Y   => tb_Y
    );

    -- 4. Generazione Clock (su segnale A)
    clk_process : process
    begin
        tb_A <= '0';
        wait for CLK_PERIOD/2;
        tb_A <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Processo Stimoli
    stim_proc: process
    begin		
        -- ============================================================
        -- FASE 1: RESET INIZIALE
        -- ============================================================
        tb_I <= '0';
        tb_RST <= '1'; -- Attivo Reset
        wait for 20 ns;
        
        -- Rilascio il reset sul fronte di discesa del clock (buona pratica)
        wait until falling_edge(tb_A);
        tb_RST <= '0';
        wait for CLK_PERIOD;

        -- ============================================================
        -- FASE 2: RILEVAMENTO SEQUENZA "1-1-1" (MOORE)
        -- ============================================================
        -- Obiettivo: Vedere che l'uscita scatta SOLO dopo il fronte di clock
        
        -- 1° Bit '1' -> Transizione Q0 -> Q1
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- 2° Bit '1' -> Transizione Q1 -> Q2
        tb_I <= '1';
        wait for CLK_PERIOD;

        -- 3° Bit '1' -> Transizione Q2 -> Q3
        -- ATTENZIONE QUI:
        -- Poiché è una Moore, appena cambi tb_I qui, tb_Y resta ancora 0.
        -- Devi aspettare che tb_A salga (a metà del wait) affinché lo stato diventi Q3.
        -- Solo allora tb_Y diventerà 1.
        tb_I <= '1';
        wait for CLK_PERIOD; 
        
        -- Qui siamo in Q3, tb_Y deve essere 1.

        -- ============================================================
        -- FASE 3: VERIFICA NON-SOVRAPPOSIZIONE
        -- ============================================================
        -- Inviamo un 4° bit '1'.
        -- Essendo Non Sovrapposta, da Q3 dobbiamo andare a Q1 (il nuovo '1' conta come primo).
        -- Y deve tornare a 0.
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- Rompiamo la sequenza
        tb_I <= '0';
        wait for CLK_PERIOD;

        -- ============================================================
        -- FASE 4: RESET DURANTE IL FUNZIONAMENTO
        -- ============================================================
        -- Andiamo in Q2
        tb_I <= '1'; wait for CLK_PERIOD; -- Q1
        tb_I <= '1'; wait for CLK_PERIOD; -- Q2
        
        -- Reset improvviso!
        tb_RST <= '1';
        wait for CLK_PERIOD;
        tb_RST <= '0';
        
        -- Provo a mandare un '1'. Se il reset ha funzionato, sono in Q0 -> vado in Q1.
        -- Se non avesse funzionato (ero in Q2), sarei andato in Q3 e avrei avuto Y=1.
        -- Quindi qui mi aspetto Y=0.
        tb_I <= '1'; 
        wait for CLK_PERIOD;

        -- Fine simulazione
        tb_I <= '0';
        wait for 20 ns;
        assert false report "Testbench Moore Completato!" severity failure;
        wait;
    end process;

end Behavioral;