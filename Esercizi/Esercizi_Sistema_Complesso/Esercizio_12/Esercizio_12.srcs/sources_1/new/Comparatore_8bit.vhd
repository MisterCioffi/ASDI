----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 03:29:51 PM
-- Design Name: 
-- Module Name: Comparatore_8bit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Comparatore_8bit is
    Port ( 
        IN_A  : in  std_logic_vector(7 downto 0);
        IN_B  : in  std_logic_vector(7 downto 0);
        alpha : out std_logic; 
        beta  : out std_logic 
    );
end Comparatore_8bit;

architecture Behavioral of Comparatore_8bit is

begin
    

    -- alpha=1 solo se A è strettamente maggiore di B
    alpha <= '1' when (signed(IN_A) > signed(IN_B)) else '0';
    
    -- beta=1 in tutti gli altri casi (minore o uguale)
    beta  <= '1' when (signed(IN_A) <= signed(IN_B)) else '0';

end Behavioral;