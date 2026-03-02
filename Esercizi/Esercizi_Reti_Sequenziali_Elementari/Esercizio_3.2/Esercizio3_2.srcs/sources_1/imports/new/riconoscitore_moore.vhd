----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2026 10:59:06
-- Design Name: 
-- Module Name: riconoscitore_moore - Behavioral
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

entity riconoscitore_moore is
    port(
        i : in STD_LOGIC;
        enable : in STD_LOGIC;
        A : in STD_LOGIC;
        Y : out STD_LOGIC     
    );
end riconoscitore_moore;

-- Architettura automa con due processi
architecture Behavioral_v1 of riconoscitore_moore is
    
    type stato is (S0_0, S0_1, S1, S2, S3, S4);
    -- S0_0 equivale allo stato S0 con uscita 0
    -- S0_1 equivale allo stato S0 con uscita 1
    
    signal stato_corrente : stato := S0_0;
    signal stato_prossimo : stato;
    
begin
    -- 1° processo, combinatorio
    f_stato_uscita : process(stato_corrente, i)
    begin
        y <= '0';
        case stato_corrente is 
            when S0_0 =>
                if (i = '0') then stato_prossimo <= S3;
                else stato_prossimo <= S1;
                end if;
            when S0_1 =>
                y <= '1';
                if (i = '0') then stato_prossimo <= S3;
                else stato_prossimo <= S1;
                end if;
            when S1 =>
                if (i = '0') then stato_prossimo <= S4;
                else stato_prossimo <= S2;
                end if;
            when S2 =>
                if (i = '0') then stato_prossimo <= S0_0;
                else stato_prossimo <= S0_1;
                end if;
            when S3 =>
                stato_prossimo <= S4;
            when S4 =>
                stato_prossimo <= S0_0;
            when others =>
                stato_prossimo <= S0_0;
                
        end case;
    end process;
    
    memoria : process(A)
    begin
        if (rising_edge(A)) then
            if enable = '1' then 
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;

end Behavioral_v1;
