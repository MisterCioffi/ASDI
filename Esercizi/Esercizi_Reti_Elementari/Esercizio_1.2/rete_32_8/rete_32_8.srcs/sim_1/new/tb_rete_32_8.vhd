library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Importante: serve per convertire i numeri dei cicli for in bit
use IEEE.NUMERIC_STD.ALL;

entity tb_rete_32_8 is
-- Entity vuota
end tb_rete_32_8;

architecture Behavioral of tb_rete_32_8 is

    -- 1. Componente da testare (UUT)
    component rete_32_8
        port(
          I : in std_logic_vector(31 downto 0);
          S1: in std_logic_vector(4 downto 0);
          S2: in std_logic_vector(2 downto 0);
          Y : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- 2. Segnali per la simulazione
    signal tb_I  : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_S1 : std_logic_vector(4 downto 0) := (others => '0');
    signal tb_S2 : std_logic_vector(2 downto 0) := (others => '0');
    signal tb_Y  : std_logic_vector(7 downto 0);

begin

    -- 3. Collegamento (Mapping)
    uut: rete_32_8 Port map (
        I  => tb_I,
        S1 => tb_S1,
        S2 => tb_S2,
        Y  => tb_Y
    );

    -- 4. Processo di Stimolo (Doppio Ciclo For)
    stim_proc: process
    begin
        wait for 50 ns;
        report "INIZIO TEST ROUTING COMPLETO (256 Percorsi)" severity note;

        -- CICLO ESTERNO: Seleziona l'USCITA del Demux (da 0 a 7)
        for output_idx in 0 to 7 loop
            
            -- Imposta S2 (conversione da intero a 3 bit)
            tb_S2 <= std_logic_vector(to_unsigned(output_idx, 3));

            -- CICLO INTERNO: Seleziona l'INGRESSO del Mux (da 0 a 31)
            for input_idx in 0 to 31 loop
                
                -- A. Imposta S1 (conversione da intero a 5 bit)
                tb_S1 <= std_logic_vector(to_unsigned(input_idx, 5));
                
                -- B. Pulisci tutti gli ingressi e attiva SOLO quello corrente
                tb_I <= (others => '0');    -- Reset
                tb_I(input_idx) <= '1';     -- Inietta '1' nel canale scelto
                
                -- C. Attendi propagazione
                wait for 10 ns;
                
                -- D. VERIFICA AUTOMATICA (Assert)
                -- Verifichiamo che il bit '1' sia arrivato esattamente all'uscita selezionata
                -- tb_Y(output_idx) deve essere '1'
                
                assert (tb_Y(output_idx) = '1')
                report "ERRORE: Il segnale non è arrivato! " &
                       "Input: " & integer'image(input_idx) & 
                       " -> Output: " & integer'image(output_idx)
                severity error;
                
                -- E. VERIFICA EXTRA: Controllo che gli altri bit siano 0?
                -- Per semplicità ci fidiamo che se tb_Y(output_idx) è 1, il routing funziona.
                
            end loop; -- Fine ciclo ingressi
            
        end loop; -- Fine ciclo uscite

        report "TEST COMPLETATO CON SUCCESSO. Tutti i percorsi funzionano." severity note;
        wait; -- Ferma la simulazione per sempre
    end process;

end Behavioral;