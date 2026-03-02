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

entity Comparatore_8bit is
    Port ( 
        IN_A  : in  std_logic_vector(7 downto 0); -- Dato in arrivo dalla ROM
        IN_B  : in  std_logic_vector(7 downto 0); -- Stringa "X" precaricata
        MATCH : out std_logic                     -- Uscita: '1' se uguali, '0' se diversi
    );
end Comparatore_8bit;

architecture Behavioral of Comparatore_8bit is
begin

    -- Approccio Comportamentale Combinatorio (Dataflow)
    -- Il sintetizzatore trasformerà questa riga in una rete di porte XNOR e AND.
    MATCH <= '1' when (IN_A = IN_B) else '0';

end Behavioral;
