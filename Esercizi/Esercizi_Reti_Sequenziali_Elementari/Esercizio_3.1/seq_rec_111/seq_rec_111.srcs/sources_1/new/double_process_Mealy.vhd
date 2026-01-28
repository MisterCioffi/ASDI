library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity double_process_Mealy is
    Port ( I   : in STD_LOGIC;
           A : in STD_LOGIC;
           R   : in STD_LOGIC;
           Y   : out STD_LOGIC);
end double_process_Mealy;

architecture Behavioral of double_process_Mealy is

    type stato is (Q0, Q1, Q2);
    signal stato_corrente : stato := Q0;
    signal stato_prossimo : stato;

begin

    -----------------------------------------------------------------
    -- PROCESSO 1: Combinatorio (Stato Prossimo + Uscita)
    -----------------------------------------------------------------
    f_stato_uscita: process(stato_corrente, I)
    begin
        -- Assegnazioni di default
        stato_prossimo <= stato_corrente; 
        Y <= '0'; 

        case stato_corrente is
            when Q0 => 
                if (I = '0') then  
                    stato_prossimo <= Q0;
                    Y <= '0';
                else
                    stato_prossimo <= Q1;
                    Y <= '0';
                end if; 

            when Q1 => 
                if (I = '0') then  
                    stato_prossimo <= Q0;
                    Y <= '0';
                else
                    stato_prossimo <= Q2;
                    Y <= '0';
                end if; 
                
            when Q2 => 
                if (I = '0') then  
                    stato_prossimo <= Q0;
                    Y <= '0';
                else
                    stato_prossimo <= Q0;
                    Y <= '1'; 
                end if; 
            
            when others => 
                stato_prossimo <= Q0;
                Y <= '0';             
        end case;
    end process;

    -----------------------------------------------------------------
    -- PROCESSO 2: Sequenziale (Memoria Stato + Reset Sincrono)
    -----------------------------------------------------------------
    mem: process(A)
    begin
        if (A'event and A = '1') then 
            
            if (R = '1') then 
                -- Reset Sincrono: vado a Q0
                stato_corrente <= Q0;
            else
                -- Funzionamento normale: aggiorno lo stato
                stato_corrente <= stato_prossimo;
            end if;
            
        end if;
    end process;

end Behavioral;