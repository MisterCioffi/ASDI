----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2026 17:45:04
-- Design Name: 
-- Module Name: ffD - Behavioral
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

entity ffD is
    port(
        D : in STD_LOGIC;
        clk, rst : in STD_LOGIC;
        Qd : out STD_LOGIC
    );
end ffD;

architecture Behavioral of ffD is
    
begin
    ff: process(clk, rst)
    begin
        if (rst = '1') then
            Qd <= '0';
        elsif (rising_edge(clk)) then
            Qd <= D;
        end if;
    end process;
        
end Behavioral;
