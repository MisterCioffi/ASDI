----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2026 05:41:33 PM
-- Design Name: 
-- Module Name: Nodo_B - Behavioral
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

entity Nodo_B is
    Port ( 
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        -- Interfaccia Handshaking
        strobe     : in  STD_LOGIC;
        ack        : out STD_LOGIC;
        data_in    : in  STD_LOGIC_VECTOR (7 downto 0);
        
        -- Uscita per visualizzare il risultato (opzionale ma utile per debug)
        somma_out  : out STD_LOGIC_VECTOR (4 downto 0)
    );
end Nodo_B;

architecture Behavioral of Nodo_B is

    -- 1. Richiamo il componente RCA (Sommatore) creato prima
    component RCA_4bit
        Port ( 
            A_in  : in  STD_LOGIC_VECTOR (3 downto 0);
            B_in  : in  STD_LOGIC_VECTOR (3 downto 0);
            S_out : out STD_LOGIC_VECTOR (4 downto 0)
        );
    end component;

    -- Stati della FSM
    type stato_type is (IDLE, SEND_ACK);
    signal stato_curr, stato_next : stato_type;

    -- Segnali interni per il Datapath
    signal data_reg : STD_LOGIC_VECTOR(7 downto 0); -- Registro per memorizzare il dato in ingresso
    signal op1, op2 : STD_LOGIC_VECTOR(3 downto 0); -- I due nibble
    signal somma_res: STD_LOGIC_VECTOR(4 downto 0); -- Il risultato del sommatore

begin

    -- ==========================================
    -- 1. ISTANZIAZIONE DEL SOMMATORE (Datapath)
    -- ==========================================
    
    -- Colleghiamo i fili: op1 è la parte alta, op2 la bassa
    -- Nota: questi segnali vengono aggiornati quando data_reg cambia
    op1 <= data_reg(7 downto 4);
    op2 <= data_reg(3 downto 0);

    My_Adder: RCA_4bit port map (
        A_in  => op1,
        B_in  => op2,
        S_out => somma_res
    );

    -- Portiamo il risultato all'esterno
    somma_out <= somma_res;


    -- ==========================================
    -- 2. PROCESSO SEQUENZIALE (Memoria FSM)
    -- ==========================================
    process (clk, reset)
    begin
        if reset = '1' then
            stato_curr <= IDLE;
            data_reg   <= (others => '0'); -- Reset del registro dati
        elsif rising_edge(clk) then
            stato_curr <= stato_next;
            
            -- Se siamo in IDLE e arriva lo strobe, campioniamo il dato
            if (stato_curr = IDLE and strobe = '1') then
                data_reg <= data_in;
            end if;
        end if;
    end process;

    -- ==========================================
    -- 3. PROCESSO COMBINATORIO (Logica FSM)
    -- ==========================================
    process (stato_curr, strobe)
    begin
        -- Valori di default
        ack <= '0';
        stato_next <= stato_curr;

        case stato_curr is
            
            -- Aspetto che il Master (A) mi mandi qualcosa
            when IDLE =>
                ack <= '0';
                if strobe = '1' then
                    stato_next <= SEND_ACK;
                else
                    stato_next <= IDLE;
                end if;

            -- Ho ricevuto il dato, alzo ACK e aspetto che strobe scenda
            when SEND_ACK =>
                ack <= '1'; -- Dico ad A: "Ho preso il dato!"
                
                -- Rimango qui finché A non abbassa lo strobe
                if strobe = '0' then
                    stato_next <= IDLE;
                else
                    stato_next <= SEND_ACK;
                end if;

        end case;
    end process;

end Behavioral;
