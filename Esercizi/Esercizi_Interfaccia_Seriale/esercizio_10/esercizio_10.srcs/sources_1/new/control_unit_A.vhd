----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:09:39
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
    port(
        clk, rst : in STD_LOGIC;
        TBE : in STD_LOGIC;
        start : in STD_LOGIC;
        WR : out STD_LOGIC;
        read : out STD_LOGIC;
        en_count : out STD_LOGIC
    );
end control_unit_A;

architecture Behavioral of control_unit_A is

    type stato is (IDLE, LETTURA, AVVIA_TX, WAIT_TX, INCR_COUNT);
    signal stato_corrente : stato := IDLE;
    signal stato_prossimo : stato;

begin
    mem: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato_corrente <= IDLE;
            else
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;
    
    f_stato: process(stato_corrente, start, TBE)
    begin
        read <= '0';
        en_count <= '0';
        WR <= '0';
        
        case stato_corrente is
        
            when IDLE =>
                if start = '0' then
                    stato_prossimo <= IDLE;
                else
                    stato_prossimo <= LETTURA;
                end if; 
                
            when LETTURA =>
                read <= '1';
                stato_prossimo <= AVVIA_TX;
                
            when AVVIA_TX =>
                WR <= '1';
                stato_prossimo <= WAIT_TX;
            
            when WAIT_TX =>
                if TBE = '0' then
                    stato_prossimo <= WAIT_TX;
                else
                    stato_prossimo <= INCR_COUNT;
                end if; 
                
            when INCR_COUNT =>
                en_count <= '1';
                stato_prossimo <= LETTURA;
        
        end case;
    end process;
    
end Behavioral;
