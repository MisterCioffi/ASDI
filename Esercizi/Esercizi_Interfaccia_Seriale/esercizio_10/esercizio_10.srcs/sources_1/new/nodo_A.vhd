----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:55:14
-- Design Name: 
-- Module Name: nodo_A - Structural
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

entity nodo_A is
    port(
        clk, rst : in STD_LOGIC;
        start : in STD_LOGIC;
        serial_data : out STD_LOGIC
    );
end nodo_A;

architecture Structural of nodo_A is
    
    component control_unit_A
        port(
            clk, rst : in STD_LOGIC;
            cout16 : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            TBE : in STD_LOGIC;
            start : in STD_LOGIC;
            WR : out STD_LOGIC;
            read : out STD_LOGIC;
            en_count : out STD_LOGIC
        );
    end component;

    component datapath_A
        port(
            clk, rst : in STD_LOGIC;
            read : in STD_LOGIC;
            en_cont : in STD_LOGIC;
            WR : in STD_LOGIC;
            cout16 : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            TXD : out std_logic  	:= '1';
            TBE	: inout std_logic 	:= '1'
        );
    end component;
    
    signal read_en, count_en, wr_en : STD_LOGIC;
    signal TBE_SIGNAL : STD_LOGIC;
    signal cout16_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
begin

    ucA: control_unit_A port map(
        clk => clk,
        rst => rst,
        cout16 => cout16_signal,
        TBE => TBE_SIGNAL,
        start => start,
        WR => wr_en,
        read => read_en,
        en_count => count_en
    );

    uoA: datapath_A port map(
        clk => clk,
        rst => rst,
        read => read_en,
        en_cont => count_en,
        WR => wr_en,
        TXD => serial_data,
        TBE	=> TBE_SIGNAL,
        cout16 => cout16_signal
    );
    
end Structural;
