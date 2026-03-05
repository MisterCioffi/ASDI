----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2026 11:22:49 AM
-- Design Name: 
-- Module Name: Button_Conditioner - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Button_Conditioner is
    Generic (
        CLK_FREQ_HZ : integer := 50_000_000; 
        DEBOUNCE_MS : integer := 20          
    );
    Port ( 
        clk    : in  STD_LOGIC;
        btn_in : in  STD_LOGIC;  
        pulse  : out STD_LOGIC   
    );
end Button_Conditioner;

architecture Behavioral of Button_Conditioner is
    
    -- Il compilatore calcola da solo il tetto massimo del contatore!
    -- (Frequenza in Hz / 1000) ti dà i cicli per 1 millisecondo, moltiplicato per i MS scelti
    constant MAX_COUNT : integer := (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
    
    signal counter    : integer range 0 to MAX_COUNT := 0;
    signal btn_stable : STD_LOGIC := '0';
    signal btn_reg    : STD_LOGIC := '0';
    
begin

    -- Processo 1: Filtro Antirimbalzo (Debouncer)
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_in = '1' then
                if counter < MAX_COUNT then
                    counter <= counter + 1;
                else
                    btn_stable <= '1';
                end if;
            else
                counter <= 0;
                btn_stable <= '0';
            end if;
        end if;
    end process;

    -- Processo 2: Rilevatore di Fronte (Edge Detector)
    process(clk)
    begin
        if rising_edge(clk) then
            btn_reg <= btn_stable;
            
            -- L'impulso viene generato solo quando il bottone diventa stabile
            if btn_stable = '1' and btn_reg = '0' then
                pulse <= '1';
            else
                pulse <= '0';
            end if;
        end if;
    end process;

end Behavioral;
