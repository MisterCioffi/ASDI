----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.02.2026 10:52:31
-- Design Name: 
-- Module Name: ROM - dataflow
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

entity ROM_16_8 is
    port (
        clk : in STD_LOGIC;
        read : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end ROM_16_8;

architecture Behavioral of ROM_16_8 is
    
    TYPE memory_16_8 IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT ROM_16_8 : memory_16_8 := (
        x"A0", x"B1", x"C2", x"D3", 
        x"E4", x"F5", x"06", x"17",
        x"28", x"39", x"4A", x"5B",
        x"6C", x"7D", x"8E", x"9F"
    );
    
begin
    rom : process(clk)
    begin
        if rising_edge(clk) then
            if read = '1' then
                dout <= ROM_16_8(to_integer(unsigned(address)));
            end if;
        end if;
    end process;
    
end Behavioral;
