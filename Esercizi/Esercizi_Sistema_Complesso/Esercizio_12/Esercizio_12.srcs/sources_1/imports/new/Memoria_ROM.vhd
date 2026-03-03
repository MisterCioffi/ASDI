----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 02:45:35 PM
-- Design Name: 
-- Module Name: Memoria_ROM - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memoria_ROM is
    Port (
        clk      : in  std_logic;
        read_en  : in  std_logic;                                -- Abilitazione alla lettura
        addr     : in  std_logic_vector(3 downto 0);             -- Indirizzo dal contatore
        data_out : out std_logic_vector(7 downto 0)              -- Dato in uscita (8 bit)
    );
end Memoria_ROM;

architecture Behavioral of Memoria_ROM is

    type rom_type is array (0 to 15) of std_logic_vector(7 downto 0);

    constant ROM_CONTENT : rom_type := (
        0 => x"12",
        1 => x"AA", 
        2 => x"34",
        3 => x"56",
        4 => x"AA", 
        others => x"00" -- Riempe il resto a zero
    );

begin

    -- PROCESSO SINCRONO
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- La lettura avviene SOLO se la Control Unit alza READ_EN
            if READ_EN = '1' then
                DATA_OUT <= ROM_CONTENT(to_integer(unsigned(ADDR)));
            end if;
        end if;
    end process;

end Behavioral;
