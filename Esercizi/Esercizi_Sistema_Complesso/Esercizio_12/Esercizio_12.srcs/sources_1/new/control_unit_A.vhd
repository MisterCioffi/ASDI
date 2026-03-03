----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
-- Design Name: 
-- Module Name: control_unit_A - Behavioral
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

entity control_unit_A is
    port (
        clk, rst, start : in STD_LOGIC;
        ack : in STD_LOGIC;
        req : out STD_LOGIC;
        read : out STD_LOGIC;
        load_temp, load_RA : out STD_LOGIC;
        start_m : out STD_LOGIC;
        en_cont16 : out STD_LOGIC;
        cont16 : in STD_LOGIC_VECTOR(3 downto 0);
        done_m : in STD_LOGIC
    );
end control_unit_A;

architecture Behavioral of control_unit_A is

    type stato is (
        IDLE, LEGGI_PRIMO, CARICA_PRIMO, 
        LEGGI_SECONDO, AVVIA_MOLT, WAIT_MOLT,
        CARICA_RIS, RICHIESTA, WAIT_ACK, INCR_CONT
    );

    signal stato_corrente : stato := IDLE;
    signal stato_prossimo : stato;

begin
    
    mem : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato_corrente <= IDLE;
            else
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;

    f_state : process(stato_corrente, start, ack, done_m, cont16)
    begin
        req <= '0';
        read <= '0';
        load_temp <= '0';
        load_RA <= '0';
        start_m <= '0';
        en_cont16 <= '0';

        case stato_corrente is
            when IDLE =>
                if start = '1' then
                    stato_prossimo <= LEGGI_PRIMO;
                else
                    stato_prossimo <= IDLE;
                end if;

            when LEGGI_PRIMO =>
                read <= '1';
                stato_prossimo <= CARICA_PRIMO;

            when CARICA_PRIMO =>
                load_temp <= '1';
                en_cont16 <= '1';
                stato_prossimo <= LEGGI_SECONDO;

            when LEGGI_SECONDO =>
                read <= '1';
                stato_prossimo <= AVVIA_MOLT;

            when AVVIA_MOLT =>
                start_m <= '1';
                stato_prossimo <= WAIT_MOLT;

            when WAIT_MOLT =>
                if done_m = '1' then
                    stato_prossimo <= CARICA_RIS;
                else
                    stato_prossimo <= WAIT_MOLT;
                end if;

            when CARICA_RIS =>
                load_RA <= '1';
                stato_prossimo <= RICHIESTA;

            when RICHIESTA =>
                req <= '1';
                if ack = '1' then
                    stato_prossimo <= WAIT_ACK;
                else
                    stato_prossimo <= RICHIESTA;
                end if;

            when WAIT_ACK =>
                if ack = '1' then
                    stato_prossimo <= WAIT_ACK;
                else
                    stato_prossimo <= INCR_CONT;
                end if;

            when INCR_CONT =>
                en_cont16 <= '1';
                if cont16 = "1111" then
                    stato_prossimo <= IDLE;
                else
                    stato_prossimo <= LEGGI_PRIMO;
                end if;

            when others =>
                stato_prossimo <= IDLE;

        end case;
    end process;
    
end Behavioral;
