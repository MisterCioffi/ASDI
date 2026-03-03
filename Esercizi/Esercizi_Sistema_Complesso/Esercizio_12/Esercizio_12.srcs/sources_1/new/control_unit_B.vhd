----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
-- Design Name: 
-- Module Name: control_unit_B - Behavioral
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

entity control_unit_B is
    port (
        clk, rst : in STD_LOGIC;
        req : in STD_LOGIC;
        ack : out STD_LOGIC;
        write : out STD_LOGIC;
        load_RB : out STD_LOGIC;
        en_cont8 : out STD_LOGIC;
        alpha, beta : in STD_LOGIC;
        cont8 : in STD_LOGIC_VECTOR(2 downto 0)
    );
end control_unit_B;

architecture Behavioral of control_unit_B is

    type stato is (
        IDLE, CARICA, RISPONDI, 
        CHIUDI, SCRIVI, INCR_CONT
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

    f_stato : process(stato_corrente, req, alpha, beta, cont8)
    begin
        ack <= '0';
        write <= '0';
        load_RB <= '0';
        en_cont8 <= '0';

        case stato_corrente is
            when IDLE =>
                if req = '1' then
                    stato_prossimo <= CARICA;
                else
                    stato_prossimo <= IDLE;
                end if;

            when CARICA =>
                load_RB <= '1';
                stato_prossimo <= RISPONDI;

            when RISPONDI =>
                ack <= '1';
                if req = '1' then
                    stato_prossimo <= RISPONDI;
                else
                    stato_prossimo <= CHIUDI;
                end if;

            when CHIUDI =>
                ack <= '0';
                if alpha = '1' then
                    stato_prossimo <= SCRIVI;
                else
                    stato_prossimo <= IDLE;
                end if;

            when SCRIVI =>
                write <= '1';
                stato_prossimo <= INCR_CONT;

            when INCR_CONT =>
                en_cont8 <= '1';
                stato_prossimo <= IDLE;

            when others =>
                stato_prossimo <= IDLE;

        end case;
    end process;

end Behavioral;
