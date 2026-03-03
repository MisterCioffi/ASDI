----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 03:08:37 PM
-- Design Name: 
-- Module Name: Contatore_Generic - Behavioral
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

entity Contatore_mod16 is
    Port (
        CLK       : in  std_logic;
        RST       : in  std_logic;                                -- Azzera il contatore
        EN        : in  std_logic;                                -- Abilita l'incremento
        COUNT     : out std_logic_vector(3 downto 0)              -- Indirizzo in uscita
    );
end Contatore_mod16;

architecture Behavioral of Contatore_mod16 is

    -- Segnale interno di tipo "unsigned" per poter fare le operazioni matematiche (+1)
    signal count_reg : unsigned(3 downto 0) := (others => '0');

begin

    process(CLK, RST)
    begin
        -- Reset Asincrono: ha la priorità su tutto
        if RST = '1' then
            count_reg <= (others => '0');
            
        elsif rising_edge(CLK) then
            -- Incrementa solo se l'Unità di Controllo lo abilita
            if EN = '1' then
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    -- Assegnazione continua dell'uscita (convertendo da unsigned a std_logic_vector)
    COUNT <= std_logic_vector(count_reg);

end Behavioral;
