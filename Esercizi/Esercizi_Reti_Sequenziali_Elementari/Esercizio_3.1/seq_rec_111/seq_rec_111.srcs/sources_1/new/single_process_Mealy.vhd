library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity single_process_Mealy is
port(
    I: in std_logic;
    A: in std_logic;
    RST: in std_logic;  
    Y: out std_logic 
);
end single_process_Mealy;

architecture Behavioral of single_process_Mealy is

type stato is (Q0, Q1, Q2);
signal stato_corrente : stato := Q0;

begin

    -----------------------------------------------------------------
    -- SINGOLO PROCESSO : Combinatorio + Sequenziale + Reset sincrono
    -----------------------------------------------------------------
f_uscita_mem: process(A)
    begin
      
      if (A'event and A = '1') then
        
        if (RST = '1') then --RESET SINCRONO
            stato_corrente <= Q0; 
            Y <= '0';            
            
        else

            case stato_corrente is
            
                when Q0 => 
                    if (I = '0') then  
                        stato_corrente <= Q0;
                        Y <= '0';
                    else
                        stato_corrente <= Q1;
                        Y <= '0';
                    end if; 
                    
                when Q1 => 
                    if (I = '0') then  
                        stato_corrente <= Q0;
                        Y <= '0';
                    else
                        stato_corrente <= Q2;
                        Y <= '0';
                    end if; 
                    
                when Q2 => 
                    if (I = '0') then  
                        stato_corrente <= Q0;
                        Y <= '0';
                    else
                        stato_corrente <= Q0;
                        Y <= '1';
                    end if; 
                
               when others => 
                        stato_corrente <= Q0;
                        Y <= '0';             
            end case;
            
        end if; -- Fine del controllo Reset
     end if; -- Fine del Clock event
end process;

end Behavioral;