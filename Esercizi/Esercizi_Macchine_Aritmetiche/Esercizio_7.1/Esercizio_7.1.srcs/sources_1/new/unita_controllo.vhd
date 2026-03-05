----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 17:57:27
-- Design Name: 
-- Module Name: unita_controllo - Behavioral
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

entity unita_controllo is
    port (
        clock, reset, start: in std_logic;
        q0, q_minus1 : in std_logic;
        counter: in std_logic_vector(2 downto 0);
        loadA, loadQ, loadM : out std_logic;
        shift, subtract, reset_init, count_in : out std_logic;
        stop_cu : out std_logic
    );
end unita_controllo;

architecture Behavioral of unita_controllo is

    type state_type is (
        IDLE, INIT, EVALUATE, SOMMA, 
        SOTTRAZIONE, SHIFT_STATE, FINE
    );
    signal current_state, next_state : state_type;
begin

    -- Registro di stato sincrono
    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    -- Rete combinatoria per il calcolo del prossimo stato e delle uscite
    process(current_state, start, q0, q_minus1, counter)
    begin
        loadA      <= '0';
        loadQ      <= '0';
        loadM      <= '0';
        shift      <= '0';
        subtract   <= '0';
        reset_init <= '0';
        count_in   <= '0';
        stop_cu    <= '0';

        case current_state is
            when IDLE =>
                if start = '1' then
                    reset_init <= '1'; -- l'impulso di pulizia per UO
                    next_state <= INIT;
                else
                    next_state <= IDLE;
                end if;

            when INIT =>
                loadM <= '1'; 
                loadQ <= '1'; 
                next_state <= EVALUATE;

            when EVALUATE =>
            
                if q0 = '1' and q_minus1 = '0' then
                    next_state <= SOTTRAZIONE;
                elsif q0 = '0' and q_minus1 = '1' then
                    next_state <= SOMMA;
                else
                    -- "00" o "11": solo scorrimento
                    next_state <= SHIFT_STATE;
                end if;

            when SOMMA =>
                loadA <= '1';
                subtract <= '0'; 
                next_state <= SHIFT_STATE;

            when SOTTRAZIONE =>
                loadA <= '1';
                subtract <= '1'; 
                next_state <= SHIFT_STATE;

            when SHIFT_STATE =>
                shift <= '1';
                count_in <= '1';
                
                if counter = "111" then
                    next_state <= FINE;
                else
                    next_state <= EVALUATE;
                end if;

            when FINE =>
                stop_cu <= '1';
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;
end Behavioral;
