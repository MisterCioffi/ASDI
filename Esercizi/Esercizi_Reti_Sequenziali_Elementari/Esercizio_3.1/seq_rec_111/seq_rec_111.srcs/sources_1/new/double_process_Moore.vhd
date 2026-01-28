----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2026 04:00:33 PM
-- Design Name: 
-- Module Name: double_process_Moore - Behavioral
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

entity double_process_Moore is
port(
    I   : in STD_LOGIC;
    A   : in STD_LOGIC;
    RST : in STD_LOGIC; 
    Y   : out STD_LOGIC
);
end double_process_Moore;

architecture Behavioral of double_process_Moore is

    type stato is (Q0, Q1, Q2, Q3);
    signal stato_corrente : stato := Q0;
    signal stato_successivo : stato;

begin

    f_stato_uscita: process(stato_corrente, I) 
    begin
        -- Default assignment per sicurezza
        stato_successivo <= stato_corrente;
        Y <= '0';   

        case stato_corrente is

            when Q0 =>
                if (I = '1') then
                    stato_successivo  <= Q1;
                else
                    stato_successivo  <= Q0;
                end if;
            
            when Q1 =>
                if (I = '1') then
                    stato_successivo  <= Q2;
                else
                    stato_successivo  <= Q0;
                end if;
            
            when Q2 =>
                if (I = '1') then
                    stato_successivo  <= Q3;
                else
                    stato_successivo  <= Q0;
                end if;
            
            when Q3 => 
                Y <= '1';
                if (I = '1') then
                    stato_successivo  <= Q1; 
                else
                    stato_successivo  <= Q0;
                end if;
            when others =>
                stato_successivo  <= Q0;
                Y <= '0';
        end case;
    end process;    

    f_memoria: process(A)
    begin
        if rising_edge(A) then 
            if (RST = '1') then 
                stato_corrente <= Q0;
            else
                stato_corrente <= stato_successivo;
            end if;
        end if;
    end process;

end Behavioral;
