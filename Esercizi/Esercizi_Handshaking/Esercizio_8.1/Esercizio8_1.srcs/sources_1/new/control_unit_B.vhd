----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 19:56:26
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
    port(
        clk : in STD_LOGIC;
        req : in STD_LOGIC;
        load_B, ack : out STD_LOGIC
    );
end control_unit_B;

architecture Behavioral of control_unit_B is

    type stato is (
        IDLE, LOAD_RB, RESPONSE, END_COM
    );
    signal stato_corrente : stato := IDLE;
    signal stato_prossimo : stato;

begin
    memory : process(clk)
    begin
        if (rising_edge(clk)) then
            stato_corrente <= stato_prossimo;
        end if;
    end process;          
    
    f_state : process(stato_corrente, req)
    begin
        load_B <= '0';
        ack <= '0';

        case stato_corrente is
            when IDLE =>
                if req = '1' then
                    stato_prossimo <= LOAD_RB;
                else
                    stato_prossimo <= IDLE;
                end if;
            
            when LOAD_RB =>
                load_B <= '1';
                stato_prossimo <= RESPONSE;
                
            when RESPONSE => 
                ack <= '1';
                if req = '0' then
                    stato_prossimo <= END_COM;
                else
                    stato_prossimo <= RESPONSE;
                end if;
                
            when END_COM =>
                stato_prossimo <= IDLE;

            when others =>
                stato_prossimo <= IDLE;
                
        end case;
    end process;
    
end Behavioral;
