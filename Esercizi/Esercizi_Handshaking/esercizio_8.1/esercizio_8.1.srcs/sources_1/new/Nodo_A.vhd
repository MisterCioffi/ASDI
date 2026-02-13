----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2026 05:42:55 PM
-- Design Name: 
-- Module Name: Nodo_A - Behavioral
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
use IEEE.NUMERIC_STD.ALL; -- Fondamentale per contare con "unsigned"

entity Nodo_A is
    Port ( 
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        -- Interfaccia Handshaking
        ack        : in  STD_LOGIC;
        strobe     : out STD_LOGIC;
        data_out   : out STD_LOGIC_VECTOR (7 downto 0)
    );
end Nodo_A;

architecture Behavioral of Nodo_A is

    -- 1. DICHIARAZIONE DEL COMPONENTE ROM
    -- (Copiamo esattamente l'entity che mi hai mandato)
    component ROM_16_8
        Port ( 
            A : in STD_LOGIC_VECTOR (3 downto 0);
            D : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- 2. SEGNALI INTERNI
    type stato_type is (IDLE, ASSERT_STROBE, WAIT_ACK, CHECK_NEXT, STOP);
    signal stato_curr, stato_next : stato_type;
    
    -- Contatore: uso "unsigned" perché è facile da convertire in std_logic_vector per la ROM
    signal counter : unsigned(3 downto 0);
    signal counter_next : unsigned(3 downto 0);

    -- Segnale intermedio per collegare il contatore alla porta A della ROM
    signal rom_addr : std_logic_vector(3 downto 0);

begin

    -- ==========================================
    -- ISTANZIAZIONE DELLA ROM (Datapath)
    -- ==========================================
    
    -- Converto il contatore (unsigned) in bit (std_logic_vector) per la ROM
    rom_addr <= std_logic_vector(counter);

    -- Collego i fili:
    -- L'indirizzo "rom_addr" entra nella porta A
    -- Il dato esce dalla porta D e va direttamente all'uscita "data_out" del Nodo A
    Rom_Inst: ROM_16_8 port map (
        A => rom_addr,
        D => data_out 
    );

    -- ==========================================
    -- PROCESSO SEQUENZIALE (Clock)
    -- ==========================================
    process (clk, reset)
    begin
        if reset = '1' then
            stato_curr <= IDLE;
            counter    <= (others => '0'); -- Resetta il contatore a "0000"
        elsif rising_edge(clk) then
            stato_curr <= stato_next;
            counter    <= counter_next;
        end if;
    end process;

    -- ==========================================
    -- PROCESSO COMBINATORIO (Logica FSM)
    -- ==========================================
    process (stato_curr, ack, counter)
    begin
        -- Valori di default
        strobe <= '0';
        stato_next <= stato_curr;
        counter_next <= counter; 

        case stato_curr is
            
            when IDLE =>
                -- Appena pronti, iniziamo
                stato_next <= ASSERT_STROBE;

            -- STATO 1: Dato pronto, alzo Strobe
            when ASSERT_STROBE =>
                strobe <= '1';
                -- Il dato è già stabile perché la ROM è combinatoria e "counter" è fermo
                
                if ack = '1' then
                    stato_next <= CHECK_NEXT; -- B ha letto, posso procedere
                else
                    stato_next <= ASSERT_STROBE; -- Aspetto B
                end if;

            -- STATO 2: Controllo se ho finito e incremento
            when CHECK_NEXT =>
                strobe <= '0'; -- Abbasso subito lo strobe
                
                -- Aspetto che B abbassi l'ACK (handshake completo)
                if ack = '0' then
                    if counter = "1111" then -- Ho raggiunto l'indirizzo 15?
                        stato_next <= STOP;
                    else
                        counter_next <= counter + 1; -- Incremento indirizzo
                        stato_next <= ASSERT_STROBE; -- Torno a inviare il prossimo
                    end if;
                end if;

            when STOP =>
                strobe <= '0';
                stato_next <= STOP; -- Bloccato qui per sempre

            when others =>
                stato_next <= IDLE;

        end case;
    end process;

end Behavioral;
