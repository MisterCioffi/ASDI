library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_single_process_Mealy is
-- Entity vuota
end tb_single_process_Mealy;

architecture Behavioral of tb_single_process_Mealy is

    -- 1. Dichiarazione Componente 
    component single_process_Mealy
    port(
        I   : in std_logic;
        A : in std_logic;
        RST : in std_logic; 
        Y   : out std_logic
    );
    end component;

    -- 2. Segnali interni
    signal tb_I   : std_logic := '0';
    signal tb_CLK : std_logic := '0';
    signal tb_RST : std_logic := '0'; 
    signal tb_Y   : std_logic;

    -- Periodo del Clock (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. Istanziazione UUT (Mapping)
    uut: single_process_Mealy port map (
        I   => tb_I,
        A => tb_CLK,
        RST => tb_RST,
        Y   => tb_Y
    );

    -- 4. Processo Clock
    clk_process : process
    begin
        tb_CLK <= '0';
        wait for CLK_PERIOD/2;
        tb_CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Processo Stimoli
    stim_proc: process
    begin		
        -- =========================================================
        -- FASE 1: RESET INIZIALE
        -- =========================================================
        -- Iniziamo con ingressi stabili
        tb_I <= '0';
        
        -- Attiviamo il Reset. 
        -- Essendo sincrono, deve essere attivo durante un fronte di salita del clock.
        tb_RST <= '1'; 
        wait for 20 ns; -- Aspettiamo 2 cicli per essere sicuri
        
        -- Rilasciamo il Reset
        tb_RST <= '0';
        wait for 10 ns; 
        
        -- Sincronizziamo gli stimoli sul fronte di discesa per pulizia visiva
        wait until falling_edge(tb_CLK);

        -- =========================================================
        -- FASE 2: TEST SEQUENZA CORRETTA (1-1-1)
        -- =========================================================
        -- 1° Bit -> Va a Q1
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- 2° Bit -> Va a Q2
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- 3° Bit -> Completa! Y deve andare alto (per 1 ciclo) e stato a Q0
        tb_I <= '1';
        wait for CLK_PERIOD;
        
        -- Reset ingresso -> Y torna basso
        tb_I <= '0';
        wait for CLK_PERIOD;

        -- =========================================================
        -- FASE 3: TEST DEL RESET A METÀ SEQUENZA
        -- =========================================================
        wait for 20 ns;
        
        -- Mando due "1". La macchina va in Q2.
        tb_I <= '1'; wait for CLK_PERIOD; -- Q1
        tb_I <= '1'; wait for CLK_PERIOD; -- Q2
        
        -- ORA PREMO IL RESET!
        -- Invece di completare con il terzo "1", resetto tutto.
        tb_RST <= '1';
        wait for CLK_PERIOD; -- Aspetto che il clock catturi il reset
        tb_RST <= '0';
        
        -- Ora provo a mandare un "1".
        -- Se il reset NON avesse funzionato, questo sarebbe il 3° "1" e darebbe Y=1.
        -- Se il reset HA funzionato, questo è il 1° "1" di una nuova serie e Y resta 0.
        tb_I <= '1'; 
        wait for CLK_PERIOD; -- Y deve essere 0 qui!
        
        -- Pulisco
        tb_I <= '0';
        wait for 20 ns;

        -- Fine simulazione
        assert false report "Test completato!" severity failure;
        wait;
    end process;

end Behavioral;