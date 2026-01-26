----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2026 03:22:01 PM
-- Design Name: 
-- Module Name: mux_2_1 - Behavioral
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

-- Module Name: mux_2_1 - Behavioral
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity mux_2_1 is
   port(
       I0 : in std_logic;
       I1 : in std_logic;
       s : in std_logic;
       y: out std_logic
   );
end mux_2_1;

architecture Behavioral of mux_2_1 is
   begin
       y <= I0 when s = '0' else
            I1 when s = '1' else
            '-';
   end Behavioral;