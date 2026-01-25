----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2026 03:24:15 PM
-- Design Name: 
-- Module Name: tb_mux_32_1 - Behavioral
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
-- Importante: ci serve questa libreria per usare i contatori nel ciclo for
use IEEE.NUMERIC_STD.ALL;

entity tb_mux_32_1 is
-- L'entity del testbench è vuota
end tb_mux_32_1;

architecture Behavioral of tb_mux_32_1 is

    -- 1. Componente da testare (UUT)
    component mux_32_1
        Port ( I : in STD_LOGIC_VECTOR (31 downto 0);
               S : in STD_LOGIC_VECTOR (4 downto 0);
               O : out STD_LOGIC);
    end component;

    -- 2. Segnali interni
    signal tb_I : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal tb_S : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal tb_O : STD_LOGIC;

begin

    -- 3. Istanziazione
    uut: mux_32_1 
    Port map ( 
        I => tb_I,
        S => tb_S,
        O => tb_O
    );

    -- 4. Processo di stimolo (Il cuore del test)
    stim_proc: process
    begin
        -- Attesa iniziale per stabilità
        wait for 100 ns;
        
        report "INIZIO TEST AUTOMATICO" severity note;

        -- CICLO FOR: Testiamo tutti i 32 canali uno per uno
        for k in 0 to 31 loop
            
            -- A. Impostiamo il selettore S al valore k (convertendo intero -> binario 5 bit)
            tb_S <= std_logic_vector(to_unsigned(k, 5));
            
            -- B. "Puliarno" l'ingresso: mettiamo tutto a 0
            tb_I <= (others => '0');
            
            -- C. Accendiamo SOLO il bit k-esimo (quello che vogliamo selezionare)
            -- Se il mux funziona, dovrebbe vedere questo '1'. 
            -- Se il mux ha i fili incrociati, vedrà '0' (perché gli altri sono 0).
            tb_I(k) <= '1';
            
            -- D. Aspettiamo che il segnale si propaghi
            wait for 20 ns;
            
            -- E. Controllo automatico (ASSERT)
            -- Se l'uscita non è '1', il simulatore stamperà un errore in rosso.
            assert (tb_O = '1') 
            report "ERRORE al canale " & integer'image(k) & ": L'uscita doveva essere 1 ma è 0!" 
            severity error;
            
        end loop;

        -- Test inverso veloce: Tutto a 1, tranne il selezionato che è 0
        wait for 50 ns;
        report "INIZIO TEST INVERSO (Walking Zero)" severity note;
        
        for k in 0 to 31 loop
            tb_S <= std_logic_vector(to_unsigned(k, 5));
            tb_I <= (others => '1'); -- Tutti 1
            tb_I(k) <= '0';          -- Solo il selezionato è 0
            wait for 20 ns;
            
            assert (tb_O = '0') 
            report "ERRORE INVERSO al canale " & integer'image(k) 
            severity error;
        end loop;

        report "TEST COMPLETATO CON SUCCESSO" severity note;
        wait; -- Ferma la simulazione
    end process;

end Behavioral;
