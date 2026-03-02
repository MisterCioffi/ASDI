library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    Port (
        CLK        : in  std_logic;
        RST        : in  std_logic; 
        START      : in  std_logic;
        READ_STEP  : in  std_logic;
        MATCH      : in  std_logic; 
        END_COUNT  : in  std_logic; 
        
        CNT_RST    : out std_logic; 
        CNT_EN     : out std_logic; 
        ROM_EN     : out std_logic; 
        MEM_WE     : out std_logic  
    );
end Control_Unit;

architecture Behavioral of Control_Unit is

    -- Aggiunto lo stato STABILIZE per la propagazione dei segnali
    type state_type is (IDLE, WAIT_BTN, READ_ROM, STABILIZE, EVALUATE, DONE);
    signal current_state, next_state : state_type;

begin

    -- PROCESSO 1: REGISTRO DI STATO (Sincrono)
    sync_proc: process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= IDLE;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    -- PROCESSO 2: LOGICA DEL PROSSIMO STATO E USCITE (Combinatorio)
    comb_proc: process(current_state, START, READ_STEP, MATCH, END_COUNT)
    begin
        -- Valori di default per evitare latch indesiderati
        CNT_RST    <= '0';
        CNT_EN     <= '0';
        ROM_EN     <= '0';
        MEM_WE     <= '0';
        next_state <= current_state; 

        case current_state is
        
            when IDLE =>
                CNT_RST <= '1'; 
                if START = '1' then
                    next_state <= WAIT_BTN;
                end if;

            when WAIT_BTN =>
                if READ_STEP = '1' then
                    next_state <= READ_ROM;
                end if;

            -------------------------------------------------------------------
            -- READ_ROM: Alza l'abilitazione della ROM. 
            -- I dati iniziano a uscire alla fine di questo ciclo.
            -------------------------------------------------------------------
            when READ_ROM =>
                ROM_EN <= '1'; 
                next_state <= STABILIZE; 

            -------------------------------------------------------------------
            -- STABILIZE: Stato di "bolla". 
            -- Qui la ROM ha i dati pronti e il comparatore sta calcolando il MATCH.
            -- Aspettiamo un colpo di clock per essere sicuri che MATCH sia stabile.
            -------------------------------------------------------------------
            when STABILIZE =>
                next_state <= EVALUATE;

            -------------------------------------------------------------------
            -- EVALUATE: MATCH è ora stabile e sicuro. 
            -- Scriviamo in memoria e incrementiamo il contatore.
            -------------------------------------------------------------------
            when EVALUATE =>
                MEM_WE <= MATCH; -- Assegnazione sicura senza glitch
                CNT_EN <= '1';   
                
                if END_COUNT = '1' then
                    next_state <= DONE;
                else
                    next_state <= WAIT_BTN;
                end if;

            when DONE =>
                next_state <= DONE;

            when others =>
                next_state <= IDLE; 
                
        end case;
    end process;

end Behavioral;