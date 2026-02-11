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

entity Contatore_Generic is
    Generic (
        ADDR_WIDTH : integer := 4 -- N locazioni (es. 4 bit = conta da 0 a 15)
    );
    Port (
        CLK       : in  std_logic;
        RST       : in  std_logic;                                -- Azzera il contatore
        EN        : in  std_logic;                                -- Abilita l'incremento
        COUNT     : out std_logic_vector(ADDR_WIDTH-1 downto 0);  -- Indirizzo in uscita
        END_COUNT : out std_logic                                 -- Segnale "Ho finito!" (raggiunto N-1)
    );
end Contatore_Generic;

architecture Behavioral of Contatore_Generic is

    -- Segnale interno di tipo "unsigned" per poter fare le operazioni matematiche (+1)
    signal count_reg : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');

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

    -- Logica per il segnale di "Fine Conteggio" (Terminal Count)
    -- Si alza a '1' quando il contatore raggiunge il valore massimo (tutti i bit a '1')
    -- Es. con 4 bit, si alza quando count_reg = "1111" (15 in decimale)
    END_COUNT <= '1' when count_reg = (2**ADDR_WIDTH) - 1 else '0';

end Behavioral;
