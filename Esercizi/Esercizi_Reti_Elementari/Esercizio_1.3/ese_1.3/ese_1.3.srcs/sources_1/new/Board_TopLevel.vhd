----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 04:55:17 PM
-- Design Name: 
-- Module Name: Board_TopLevel - Behavioral
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

----------------------------------------------------------------------------------
-- Modulo Top Level per l'implementazione su scheda (Esercizio 1.3)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Board_TopLevel is
    Port (
        clk        : in  STD_LOGIC;                      -- Clock 100MHz della board
        sw         : in  STD_LOGIC_VECTOR (15 downto 0); -- I 16 Switch fisici
        btn_load_L : in  STD_LOGIC;                      -- Bottone GIÙ (BTND) per i 16 bit bassi
        btn_load_H : in  STD_LOGIC;                      -- Bottone SU (BTNU) per i 16 bit alti
        led        : out STD_LOGIC_VECTOR (7 downto 0)   -- Gli 8 LED di uscita
    );
end Board_TopLevel;

architecture Behavioral of Board_TopLevel is

    -- 1. DICHIARAZIONE DEL COMPONENTE CON I NOMI CORRETTI
    component rete_32_8
        Port ( 
            I  : in  STD_LOGIC_VECTOR (31 downto 0);
            S1 : in  STD_LOGIC_VECTOR (4 downto 0);
            S2 : in  STD_LOGIC_VECTOR (2 downto 0);
            Y  : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- 2. REGISTRO INTERNO PER MEMORIZZARE I 32 BIT DI DATI
    signal data_reg : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin

    -- =========================================================================
    -- PROCESSO DI CARICAMENTO DEI DATI (Logica Sequenziale / "Rete di Controllo")
    -- =========================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            -- Se premo il bottone Low, copio gli switch nei primi 16 bit del registro
            if btn_load_L = '1' then
                data_reg(15 downto 0) <= sw;
            end if;
            
            -- Se premo il bottone High, copio gli switch negli ultimi 16 bit del registro
            if btn_load_H = '1' then
                data_reg(31 downto 16) <= sw;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- ISTANZIAZIONE DELLA TUA RETE (Mapping Logica Combinatoria)
    -- =========================================================================
    Rete_Inst: rete_32_8 port map (
        I  => data_reg,          -- I dati presi dal registro (FERMI)
        S1 => sw(4 downto 0),    -- MUX collegato in tempo reale ai primi 5 switch (0 -> 4)
        S2 => sw(7 downto 5),    -- DEMUX collegato in tempo reale agli switch (5 -> 7)
        Y  => led                -- Uscite collegate fisicamente agli 8 LED
    );

end Behavioral;