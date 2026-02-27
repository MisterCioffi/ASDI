----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:09:39
-- Design Name: 
-- Module Name: MEM_16_4 - Behavioral
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

entity MEM_16_4 is
    port(
        clk, write : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        din : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end MEM_16_4;

architecture Behavioral of MEM_16_4 is

    type memory_16_4 is array (0 to 15) of STD_LOGIC_VECTOR(3 downto 0);
    signal MEM_16_4 : memory_16_4 := (others => (others => '0'));
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write = '1' then
                MEM_16_4(to_integer(unsigned(address))) <= din;
            end if;
            
            dout <= MEM_16_4(to_integer(unsigned(address)));
            
        end if;
    end process;
end Behavioral;
