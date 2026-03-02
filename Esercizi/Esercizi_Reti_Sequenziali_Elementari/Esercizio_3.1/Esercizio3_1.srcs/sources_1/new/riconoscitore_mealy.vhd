----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2026 10:59:06
-- Design Name: 
-- Module Name: riconoscitore_mealy - Behavioral
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

entity riconoscitore_mealy is
    port(
        i : in STD_LOGIC; 
        A : in STD_LOGIC;
        Y : out STD_LOGIC
    );
end riconoscitore_mealy;

-- Architettura automa con due processi
architecture Behavioral_v1 of riconoscitore_mealy is
    
    type stato is (S0, S1, S2, S3, S4);
    signal stato_corrente : stato := S0;
    signal stato_prossimo : stato;
    
begin
    -- 1° processo, parte combinatoria
    f_stato_uscita : process(stato_corrente, i)
    begin
        case stato_corrente is
            when S0 =>
                if (i = '0') then
                    stato_prossimo <= S3;
                    y <= '0';
                else
                    stato_prossimo <= S1;
                    y <= '0';
                end if;
            when S1 =>
                if (i = '0') then
                    stato_prossimo <= S4;
                    y <= '0';
                else
                    stato_prossimo <= S2;
                    y <= '0';
                end if;
            when S2 =>
                stato_prossimo <= S0;
                if (i = '0') then
                    y <= '0';
                else
                    y <= '1';
                end if;
            when S3 =>
                stato_prossimo <= S4;
                y <= '0';
            when S4 =>
                stato_prossimo <= S0;
                y <= '0';
            when others => 
                stato_prossimo <= S0;
                y <= '0';
        end case;
    end process;
    
    -- 2° processo, memoria
    memoria : process(A)
    begin
        if (rising_edge(A)) then
            stato_corrente <= stato_prossimo;
        end if;
    end process;
    
end Behavioral_v1;


-- Architettura automa con un processo
architecture Behavioral_v2 of riconoscitore_mealy is
    
    type stato is (S0, S1, S2, S3, S4);
    signal stato_corrente : stato := S0;
    
begin
    -- unico processo
    stato_uscita_memoria : process(A)
    begin
        if (rising_edge(A)) then
            case stato_corrente is
                when S0 =>
                    if (i = '0') then
                        stato_corrente <= S3;
                        y <= '0';
                    else
                        stato_corrente <= S1;
                        y <= '0';
                    end if;
                when S1 =>
                    if (i = '0') then
                        stato_corrente <= S4;
                        y <= '0';
                    else
                        stato_corrente <= S2;
                        y <= '0';
                    end if;
                when S2 =>
                    stato_corrente <= S0;
                    if (i = '0') then
                        y <= '0';
                    else
                        y <= '1';
                    end if;
                when S3 =>
                    stato_corrente <= S4;
                    y <= '0';
                when S4 =>
                    stato_corrente <= S0;
                    y <= '0';
                when others => 
                    stato_corrente <= S0;
                    y <= '0';
            end case;
        end if;
    end process;
    
end Behavioral_v2;
