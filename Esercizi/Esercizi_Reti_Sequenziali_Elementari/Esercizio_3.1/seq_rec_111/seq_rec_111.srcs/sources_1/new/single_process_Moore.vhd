----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2026 03:06:45 PM
-- Design Name: 
-- Module Name: single_process_Moore - Behavioral
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

entity single_process_Moore is
port(
    I   : in STD_LOGIC;
    A   : in STD_LOGIC;
    RST : in STD_LOGIC; 
    Y   : out STD_LOGIC
);
end single_process_Moore;

architecture Behavioral of single_process_Moore is
    type stato is (Q0, Q1, Q2, Q3);
    signal stato_corrente : stato := Q0;

begin
    f_uscita_mem: process(A) 
    begin
        if rising_edge(A) then 

            if (RST = '1') then 
                stato_corrente <= Q0;
                Y <= '0';
            else
                
                -- Default assignment per sicurezza
                Y <= '0'; 

                case stato_corrente is

                    when Q0 =>
                        if (I = '1') then
                            stato_corrente <= Q1;
                        else
                            stato_corrente <= Q0;
                        end if;

                    when Q1 =>
                        if (I = '1') then
                            stato_corrente <= Q2;
                        else
                            stato_corrente <= Q0;
                        end if;

                    when Q2 =>
                        if (I = '1') then
                            stato_corrente <= Q3;
                            Y <= '1'; 
                        else
                            stato_corrente <= Q0;
                        end if;

                    when Q3 => 
                        if (I = '1') then
                            stato_corrente <= Q1; 
                        else
                            stato_corrente <= Q0;
                        end if;

                    when others =>
                        stato_corrente <= Q0;
                        Y <= '0';
                end case;

            end if; -- fine reset
        end if; -- fine clock
    end process; -- fine processo

end Behavioral;