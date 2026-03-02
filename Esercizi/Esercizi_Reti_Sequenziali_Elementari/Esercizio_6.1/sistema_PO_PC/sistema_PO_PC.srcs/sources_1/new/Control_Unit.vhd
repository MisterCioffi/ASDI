----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 05:29:19 PM
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
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

entity Control_Unit is
    Port (
        CLK       : in  std_logic;
        RST       : in  std_logic; -- Reset asincrono del sistema
        START     : in  std_logic; -- Pulsante di avvio
        MATCH     : in  std_logic; -- Dal Comparatore: '1' se uguali
        END_COUNT : in  std_logic; -- Dal Contatore: '1' se siamo all'ultima locazione
        
        -- Uscite di Comando
        CNT_RST   : out std_logic; -- Azzera il contatore
        CNT_EN    : out std_logic; -- Incrementa il contatore
        ROM_EN    : out std_logic; -- Abilita lettura ROM
        MEM_WE    : out std_logic  -- Abilita scrittura MEM
    );
end Control_Unit;

architecture Behavioral of Control_Unit is

    -- 1. Definizione degli Stati (Proprio quelli che abbiamo disegnato!)
    type state_type is (IDLE, READ_ROM, EVALUATE);
    
    -- 2. Segnali per memorizzare lo stato attuale e il prossimo
    signal current_state, next_state : state_type;

begin

    -- =========================================================================
    -- PROCESSO 1: REGISTRO DI STATO (Sincrono)
    -- Si sveglia solo col Clock o col Reset. Memorizza lo stato.
    -- =========================================================================
    sync_proc: process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= IDLE; -- Il reset ci riporta subito a riposo
        elsif rising_edge(CLK) then
            current_state <= next_state; -- Al colpo di clock, facciamo il salto
        end if;
    end process;


    -- =========================================================================
    -- PROCESSO 2: LOGICA DEL PROSSIMO STATO E DELLE USCITE (Combinatorio)
    -- Si sveglia ogni volta che cambia uno stato o un ingresso.
    -- =========================================================================
    comb_proc: process(current_state, START, STABILIZE, MATCH, END_COUNT)
    begin
        -- VALORI DI DEFAULT DELLE USCITE (Fondamentale per evitare i Latch!)
        -- All'inizio del processo, spegniamo tutto. Così negli stati dovremo 
        -- accendere solo quello che ci serve davvero.
        CNT_RST   <= '0';
        CNT_EN    <= '0';
        ROM_EN    <= '0';
        MEM_WE    <= '0';
        next_state <= current_state; -- Di default, rimani nello stato attuale

        case current_state is
        
            -------------------------------------------------------------------
            when IDLE =>
                CNT_RST <= '1'; -- Teniamo il contatore schiacciato a 0
                
                if START = '1' then
                    next_state <= READ_ROM;
                end if;
                -- Se START è '0', il next_state rimane IDLE per il default sopra.

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
            when EVALUATE =>
                CNT_EN <= '1';   -- Diciamo al contatore di prepararsi al +1
                MEM_WE <= MATCH; -- LA MAGIA: Scriviamo solo se il comparatore dice '1'!
                
                -- Dobbiamo andare avanti o abbiamo finito?
                if END_COUNT = '1' then
                    next_state <= IDLE;     -- Abbiamo analizzato tutte le N locazioni
                else
                    next_state <= READ_ROM; -- Ne mancano ancora, andiamo a leggere la prossima
                end if;

            -------------------------------------------------------------------
            when others =>
                next_state <= IDLE; -- Rete di sicurezza (Good practice in VHDL)
                
        end case;
    end process;

end Behavioral;
