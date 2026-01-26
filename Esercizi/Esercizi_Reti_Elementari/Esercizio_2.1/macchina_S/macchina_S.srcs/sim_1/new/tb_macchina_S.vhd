----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2026 02:12:58 PM
-- Design Name: 
-- Module Name: tb_macchina_S - Behavioral
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

entity tb_macchina_S is
-- Entity vuota
end tb_macchina_S;

architecture Behavioral of tb_macchina_S is

    -- Componente da testare (UUT)
    component macchina_S
        Port ( S : in STD_LOGIC_VECTOR (3 downto 0);
               Y : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    -- Segnali
    signal tb_S : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal tb_Y : STD_LOGIC_VECTOR (3 downto 0);

begin

    -- Istanziazione
    uut: macchina_S Port map (
        S => tb_S,
        Y => tb_Y
    );

    -- Processo di stimolo
    stim_proc: process
    begin
        wait for 100 ns;
        report "INIZIO TEST: Verifica Identità (Input = Output)" severity note;

        -- Testiamo tutti i 16 valori possibili (da 0 a 15)
        for i in 0 to 15 loop
            
            -- Impostiamo l'ingresso
            tb_S <= std_logic_vector(to_unsigned(i, 4));
            
            -- Attendiamo propagazione (ROM + Macchina_M)
            wait for 20 ns;
            
            -- VERIFICA: L'uscita deve essere uguale all'ingresso
            assert (tb_Y = tb_S)
            report "ERRORE con input " & integer'image(i) & 
                   ". Uscita attesa: " & integer'image(i) & 
                   " ma ottenuta: " & integer'image(to_integer(unsigned(tb_Y)))
            severity error;
            
        end loop;

        report "TEST COMPLETATO. Il sistema funziona come un filo perfetto!" severity note;
        wait;
    end process;

end Behavioral;
