----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2026 03:28:28 PM
-- Design Name: 
-- Module Name: tb_single_process_Moore - Behavioral
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

entity tb_single_process_Moore is
-- Entity vuota
end tb_single_process_Moore;

architecture Behavioral of tb_single_process_Moore is

    -- 1. Dichiarazione Componente (Uso 'A' come richiesto)
    component single_process_Moore
    port(
        I   : in STD_LOGIC;
        A   : in STD_LOGIC; -- Il tuo Clock si chiama A
        RST : in STD_LOGIC;
        Y   : out STD_LOGIC
    );
    end component;

    -- 2. Segnali interni
    signal tb_I   : std_logic := '0';
    signal tb_A   : std_logic := '0'; -- Segnale che piloterà la porta A
    signal tb_RST : std_logic := '0';
    signal tb_Y   : std_logic;

    -- Periodo del Clock (es. 100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. Istanziazione (Mapping)
    uut: single_process_Moore port map (
        I   => tb_I,
        A   => tb_A, -- Collego il segnale tb_A alla porta A
        RST => tb_RST,
        Y   => tb_Y
    );

    -- 4. Generazione del Clock (su segnale tb_A)
    clk_process : process
    begin
        tb_A <= '0';
        wait for CLK_PERIOD/2;
        tb_A <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Stimoli
    stim_proc: process
    begin		
        -- =========================================================
        -- FASE 1: RESET INIZIALE
        -- =========================================================
        tb_I <= '0';
        tb_RST <= '1';
        wait for 20 ns; 
        
        -- Rilascio il reset (sincronizzato col fronte di discesa per pulizia)
        wait until falling_edge(tb_A);
        tb_RST <= '0';
        wait for CLK_PERIOD;

        -- =========================================================
        -- FASE 2: RILEVAMENTO SEQUENZA "1-1-1"
        -- =========================================================
        -- Nota: In Moore l'uscita cambia UN CICLO DOPO rispetto a Mealy
        
        -- 1° Bit '1' -> Transizione a Q1
        tb_I <= '1';
        wait for CLK_PERIOD; 
        
        -- 2° Bit '1' -> Transizione a Q2
        tb_I <= '1';
        wait for CLK_PERIOD;

        -- 3° Bit '1' -> Transizione a Q3
        -- Qui, appena scatta il fronte di salita di A, lo stato diventa Q3
        -- e l'uscita Y diventerà '1'.
        tb_I <= '1';
        wait for CLK_PERIOD; 
        
        -- A questo punto Y dovrebbe essere ALTA.

        -- =========================================================
        -- FASE 3: VERIFICA NON-SOVRAPPOSIZIONE (Il 4° bit)
        -- =========================================================
        -- Mando un altro '1'.
        -- Essendo Non Sovrapposta, da Q3 dovremmo andare a Q1.
        -- L'uscita Y deve tornare a '0'.
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- Verifica rottura sequenza
        tb_I <= '0'; -- Torno a Q0
        wait for CLK_PERIOD;

        -- =========================================================
        -- FASE 4: RESET DURANTE OPERAZIONE
        -- =========================================================
        tb_I <= '1'; wait for CLK_PERIOD; -- Q1
        tb_I <= '1'; wait for CLK_PERIOD; -- Q2
        
        -- Reset improvviso!
        tb_RST <= '1';
        wait for CLK_PERIOD;
        tb_RST <= '0';
        
        -- Verifico che sia tornato a Q0 (nessun output se mando un altro 1)
        tb_I <= '1'; 
        wait for CLK_PERIOD;

        -- Fine
        tb_I <= '0';
        wait for 20 ns;
        assert false report "Simulazione Moore Completata" severity failure;
        wait;
    end process;

end Behavioral;