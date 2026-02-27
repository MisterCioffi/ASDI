----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:29:29
-- Design Name: 
-- Module Name: cont_16 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cont_16 is
    port(
        clk, rst : in STD_LOGIC;
        en : in STD_LOGIC;
        y : out STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end cont_16;

architecture Behavioral of cont_16 is
    
    signal temp : unsigned(3 DOWNTO 0);
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                temp <= (others => '0');
            elsif (en = '1') then
                temp <= temp + 1;
            end if;
        end if;
    end process;
    y <= std_logic_vector(temp);

end Behavioral;
