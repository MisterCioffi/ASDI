----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:29:29
-- Design Name: 
-- Module Name: Datapath_A - Behavioral
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

entity Datapath_A is
    port(
        clk : in  std_logic;
        
        cnt_en, cnt_rst : in  std_logic;
        read_en : in  std_logic;
        load_A : in  std_logic;
        
        end_cnt  : out std_logic;
        data_out : out std_logic_vector(7 downto 0)
    );
end Datapath_A;

architecture Structural of Datapath_A is
    
    -- ROM
    TYPE memoria_16_8 IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT rom : memoria_16_8 := (
        0  => "00000000", 
        1  => "00000001",
        2  => "01010101", 
        3  => "10100101", 
        4  => "10001000", 
        5  => "11110001",
        6  => "11111111", 
        7  => "01111000", 
        8  => "10010111",
        9  => "00111100", 
        10 => "11000110", 
        11 => "11100011", 
        12 => "01000100", 
        13 => "11011011", 
        14 => "00011110", 
        15 => "10011001"  
    );
    -- Contatore modulo 16
    component cont_16 
        port(
            clk, rst: in STD_LOGIC;
            en : in STD_LOGIC;
            y : out STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;
    
    signal address : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    signal data_register_A : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    
    count: cont_16 port map(
        clk => clk,
        rst => cnt_rst,
        en => cnt_en,
        y => address
    );
    
    read_rom: process(clk, read_en)
    begin
        if (rising_edge(clk)) then
            if (read_en = '1') then
                data_register_A <= rom(to_integer(unsigned(address)));
            end if;
        end if;
    end process;
    
    load_register_A: process(clk)
    begin 
        if rising_edge(clk) then
            if load_A = '1' then
                data_out <= data_register_A;
            end if;
        end if;
    end process;
    
    end_cnt <= '1' when address = "1111" else '0';
    
end Structural;
