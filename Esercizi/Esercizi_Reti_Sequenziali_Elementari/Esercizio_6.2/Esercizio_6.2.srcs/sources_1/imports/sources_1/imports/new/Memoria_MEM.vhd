----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 02:59:56 PM
-- Design Name: 
-- Module Name: Memoria_MEM - Behavioral
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

entity Memoria_MEM is
    Generic (
        ADDR_WIDTH : integer := 4 -- N locazioni (es. 4 bit = 16 locazioni)
    );
    Port (
        CLK       : in  std_logic;
        WRITE_EN  : in  std_logic;                                -- Abilitazione alla scrittura (sincrona)
        ADDR      : in  std_logic_vector(ADDR_WIDTH-1 downto 0);  -- Indirizzo dal contatore
        DATA_IN   : in  std_logic_vector(7 downto 0);             -- Dato da scrivere (arriva dalla ROM)
        
        -- Aggiungiamo un'uscita di lettura per poter verificare in simulazione se ha scritto davvero!
        DATA_OUT  : out std_logic_vector(7 downto 0)              
    );
end Memoria_MEM;

architecture Behavioral of Memoria_MEM is

    -- 1. Creazione del tipo Array (uguale alla ROM)
    type ram_type is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(7 downto 0);

    -- 2. Memoria vera e propria (signal, non constant!)
    -- Inizializziamo tutti i "cassetti" a "00000000" (others => '0') all'avvio.
    signal RAM_CONTENT : ram_type := (others => (others => '0'));

begin

    -- PROCESSO SINCRONO
    process(CLK)
    begin
        if rising_edge(CLK) then
            
            -- SCRITTURA SINCRONA: Avviene solo se l'Unità di Controllo alza WRITE_EN
            if WRITE_EN = '1' then
                RAM_CONTENT(to_integer(unsigned(ADDR))) <= DATA_IN;
            end if;

            -- Lettura Sincrona (Opzionale per l'algoritmo, ma vitale per il Testbench)
            -- Ci permetterà di "sbirciare" dentro la memoria durante la simulazione.
            DATA_OUT <= RAM_CONTENT(to_integer(unsigned(ADDR)));
            
        end if;
    end process;

end Behavioral;
