----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 19:56:26
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
        start : in STD_LOGIC;
        
        end_cnt : in STD_LOGIC;
        cnt_en, cnt_rst : out STD_LOGIC;
        read_en : out STD_LOGIC;
        load_A : out STD_LOGIC;
        
        ack, done : in STD_LOGIC;
        req : out STD_LOGIC
    );
end control_unit_A;

architecture Behavioral of control_unit_A is
    
    type stato is (
        IDLE, READ_ROM, LOAD_RA, 
        SEND_REQ, WAIT_ACK, WAIT_DONE, CHECK_END
    );
    signal stato_corrente : stato := IDLE;
    signal stato_prossimo : stato;

begin
    memory : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                stato_corrente <= IDLE;
            else
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;          
    
    f_state : process(stato_corrente, start, end_cnt, ack, done)
    begin
        case stato_corrente is
            when IDLE => 
                cnt_en <= '0';
                cnt_rst <= '1';
                read_en <= '0';
                load_A <= '0';
                req <= '0';
                
                if start = '1' then
                    stato_prossimo <= READ_ROM;
                else
                    stato_prossimo <= IDLE;
                end if;
                
            when READ_ROM => 
                cnt_en <= '0';
                cnt_rst <= '0';
                read_en <= '1';
                load_A <= '0';
                req <= '0';
                
                stato_prossimo <= LOAD_RA;
            
            when LOAD_RA => 
                cnt_en <= '0';
                cnt_rst <= '0';
                read_en <= '0';
                load_A <= '1';
                req <= '0';
                    
                stato_prossimo <= SEND_REQ;
                
            when SEND_REQ =>
                cnt_en <= '0';
                cnt_rst <= '0';
                read_en <= '0';
                load_A <= '0';
                req <= '1';
                
                if ack = '1' then
                    stato_prossimo <= WAIT_ACK;
                else
                    stato_prossimo <= SEND_REQ;
                end if;
                
             when WAIT_ACK =>
                cnt_en <= '0';
                cnt_rst <= '0';
                read_en <= '0';
                load_A <= '0';
                req <= '0';
                
                if ack = '0' then
                    stato_prossimo <= WAIT_DONE;
                else
                    stato_prossimo <= WAIT_ACK;
                end if;
                
              when WAIT_DONE =>
                cnt_en <= '0';
                cnt_rst <= '0';
                read_en <= '0';
                load_A <= '0';
                req <= '0';
                
                if done = '1' then
                    stato_prossimo <= CHECK_END;
                else
                    stato_prossimo <= WAIT_DONE;
                end if;
             
             when CHECK_END =>
                cnt_en <= '1';
                cnt_rst <= '0';
                read_en <= '0';
                load_A <= '0';
                req <= '0';
                
                if end_cnt = '1' then
                    stato_prossimo <= IDLE;
                else
                    stato_prossimo <= READ_ROM;
                end if;
        end case;
    end process;

end Behavioral;
