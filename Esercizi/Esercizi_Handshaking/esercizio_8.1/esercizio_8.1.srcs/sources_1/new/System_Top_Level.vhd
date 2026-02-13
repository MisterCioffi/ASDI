----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2026 05:53:55 PM
-- Design Name: 
-- Module Name: System_Top_Level - Behavioral
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

entity System_Top_Level is
    Port ( 
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        
        -- Portiamo fuori il risultato finale per vederlo nella simulazione
        somma_finale : out STD_LOGIC_VECTOR (4 downto 0)
    );
end System_Top_Level;

architecture Structural of System_Top_Level is

    -- 1. DICHIARAZIONE DEI COMPONENTI
    
    component Nodo_A
        Port ( 
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            ack        : in  STD_LOGIC;
            strobe     : out STD_LOGIC;
            data_out   : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component Nodo_B
        Port ( 
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            strobe     : in  STD_LOGIC;
            ack        : out STD_LOGIC;
            data_in    : in  STD_LOGIC_VECTOR (7 downto 0);
            somma_out  : out STD_LOGIC_VECTOR (4 downto 0)
        );
    end component;

    -- 2. SEGNALI INTERNI (I "fili" di collegamento)
    signal wire_strobe : STD_LOGIC;
    signal wire_ack    : STD_LOGIC;
    signal wire_data   : STD_LOGIC_VECTOR (7 downto 0);

begin

    -- 3. ISTANZIAZIONE E COLLEGAMENTO
    -- Nota: "wire_..." collega l'uscita di uno all'ingresso dell'altro

    Istanza_A: Nodo_A port map (
        clk      => clk,
        reset    => reset,
        ack      => wire_ack,     -- Riceve l'ACK da B
        strobe   => wire_strobe,  -- Manda lo Strobe sul filo
        data_out => wire_data     -- Manda i dati sul bus
    );

    Istanza_B: Nodo_B port map (
        clk       => clk,
        reset     => reset,
        strobe    => wire_strobe, -- Legge lo Strobe dal filo
        ack       => wire_ack,    -- Manda l'ACK sul filo
        data_in   => wire_data,   -- Legge i dati dal bus
        somma_out => somma_finale -- Manda il risultato fuori dal chip
    );

end Structural;