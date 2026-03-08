----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:09:39
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
        clk, rst : in STD_LOGIC;
        write, en_cont : out STD_LOGIC;
        RDA	: in STD_LOGIC;
        RD	: out  STD_LOGIC;
        PE	: in STD_LOGIC;
        FE	: in STD_LOGIC;		
		OE	: in STD_LOGIC				
    ); 
end control_unit_B;

architecture Behavioral of control_unit_B is

    type stato is (IDLE, CHECK_ERROR, SCRITTURA, CONFERMA_UART, INCR_COUNT);
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
    
    f_stato: process(stato_corrente, RDA, PE, FE, OE)
    begin
        write <= '0';
        en_cont <= '0';
        RD <= '0';
        
        case stato_corrente is
        
            when IDLE =>
                if RDA = '0' then
                    stato_prossimo <= IDLE;
                else
                    stato_prossimo <= CHECK_ERROR;
                end if;
             
            when CHECK_ERROR =>
                if (PE = '1' or FE = '1' or OE = '1') then
                    stato_prossimo <= CONFERMA_UART;
                else
                    stato_prossimo <= SCRITTURA;
                end if;
            
            when SCRITTURA =>
                write <= '1';
                stato_prossimo <= CONFERMA_UART;
            
            when CONFERMA_UART =>
                RD <= '1';
                stato_prossimo <= INCR_COUNT;
        
            when INCR_COUNT =>
                en_cont <= '1';
                stato_prossimo <= IDLE;

            when others =>
                stato_prossimo <= IDLE;
               
        end case;
    end process;

end Behavioral;
