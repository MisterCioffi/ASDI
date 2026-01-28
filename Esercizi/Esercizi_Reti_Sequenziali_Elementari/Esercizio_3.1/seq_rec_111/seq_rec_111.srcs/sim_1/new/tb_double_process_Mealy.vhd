----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2026 06:50:32 PM
-- Design Name: 
-- Module Name: tb_double_process_Mealy - Behavioral
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

entity tb_double_process_Mealy is
-- Entity vuota
end tb_double_process_Mealy;

architecture Behavioral of tb_double_process_Mealy is

    -- 1. Dichiarazione del Componente
    -- Deve corrispondere esattamente alla tua entity "double_process_Mealy"
    component double_process_Mealy
    port(
        I   : in std_logic;
        A : in std_logic;
        R   : in std_logic; -- Nota: nel tuo codice precedente l'hai chiamata "R"
        Y   : out std_logic
    );
    end component;

    -- 2. Segnali interni
    signal tb_I   : std_logic := '0';
    signal tb_CLK : std_logic := '0';
    signal tb_R   : std_logic := '0';
    signal tb_Y   : std_logic;

    -- Costanti di simulazione
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. Istanziazione della UUT (Unit Under Test)
    uut: double_process_Mealy port map (
        I   => tb_I,
        A => tb_CLK,
        R   => tb_R,
        Y   => tb_Y
    );

    -- 4. Generazione Clock
    clk_process : process
    begin
        tb_CLK <= '0';
        wait for CLK_PERIOD/2;
        tb_CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Processo di Stimolo
    stim_proc: process
    begin		
        -- ============================================================
        -- FASE 1: RESET INIZIALE
        -- ============================================================
        tb_I <= '0';
        tb_R <= '1'; -- Attivo il Reset
        wait for 20 ns;
        
        -- Sincronizzo col fronte di discesa del clock per pulizia
        wait until falling_edge(tb_CLK);
        tb_R <= '0'; -- Rilascio il Reset
        wait for CLK_PERIOD;

        -- ============================================================
        -- FASE 2: RILEVAMENTO SEQUENZA CORRETTA (1-1-1)
        -- ============================================================
        -- Qui vedrai la differenza del Mealy!
        
        -- 1° '1' -> Prossimo stato sarà Q1
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- 2° '1' -> Prossimo stato sarà Q2
        tb_I <= '1';
        wait for CLK_PERIOD;

        -- 3° '1' -> L'USCITA DEVE ANDARE A 1 IMMEDIATAMENTE
        -- Essendo Mealy a due processi, appena metti I=1 qui,
        -- Y deve alzarsi senza aspettare il fronte di salita del clock!
        tb_I <= '1';
        wait for CLK_PERIOD; -- Osserva Y alto in questo intervallo
        
        -- Reset ingresso
        tb_I <= '0';
        wait for CLK_PERIOD;

        -- ============================================================
        -- FASE 3: SEQUENZA ERRATA (1-1-0)
        -- ============================================================
        wait for 20 ns;
        
        tb_I <= '1'; wait for CLK_PERIOD; -- va verso Q1
        tb_I <= '1'; wait for CLK_PERIOD; -- va verso Q2
        tb_I <= '0'; wait for CLK_PERIOD; -- Rottura sequenza! torna a Q0
        
        -- Verifico che non dia output falso positivo dopo la rottura
        tb_I <= '1'; wait for CLK_PERIOD; -- Questo è il 1° bit di una nuova serie
        
        -- Pulisco
        tb_I <= '0';
        wait for 20 ns;
        
        -- ============================================================
        -- FASE 4: TEST DEL RESET DURANTE IL FUNZIONAMENTO
        -- ============================================================
        -- Mando due bit corretti
        tb_I <= '1'; wait for CLK_PERIOD; -- Q1
        tb_I <= '1'; wait for CLK_PERIOD; -- Q2
        
        -- Ora resetto brutalmente
        tb_R <= '1';
        wait for CLK_PERIOD; 
        tb_R <= '0';
        
        -- Se mando un '1' ora, non deve dare output (perché sono tornato a Q0)
        tb_I <= '1'; 
        wait for CLK_PERIOD;

        -- Fine
        assert false report "Simulazione Terminata" severity failure;
        wait;
    end process;

end Behavioral;