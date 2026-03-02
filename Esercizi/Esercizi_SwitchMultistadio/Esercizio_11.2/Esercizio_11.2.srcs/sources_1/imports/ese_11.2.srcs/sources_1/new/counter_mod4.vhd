----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2026 03:34:05 PM
-- Design Name: 
-- Module Name: counter_mod4 - Behavioral
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

entity counter_mod4 is
    Port ( 
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;  -- Enable: conta solo quando questo è a '1'
        count : out integer range 0 to 3
    );
end counter_mod4;

architecture Behavioral of counter_mod4 is
    signal val : integer range 0 to 3 := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            val <= 0;
        elsif rising_edge(clk) then
            if en = '1' then
                if val = 3 then
                    val <= 0; -- Riavvolgimento circolare
                else
                    val <= val + 1;
                end if;
            end if;
        end if;
    end process;
    
    count <= val;
end Behavioral;