----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2026 02:00:46 PM
-- Design Name: 
-- Module Name: macchina_S - Behavioral
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

entity macchina_S is
    Port ( S : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end macchina_S;

architecture Behavioral of macchina_S is

    -- SEGNALI
    signal U : STD_LOGIC_VECTOR (7 downto 0);

    -- COMPONENTI
    component ROM_16_8 is
       Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
              D : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component macchina_M is
        Port ( I : in STD_LOGIC_VECTOR (7 downto 0);
               Y : out STD_LOGIC_VECTOR (3 downto 0));
    end component;


begin

    ROM : ROM_16_8
        port map (
            A => S,
            D => U
        );

    MACCHINA : macchina_M
        port map (
            I => U,
            Y => Y
        );

end Behavioral;
