----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:55:14
-- Design Name: 
-- Module Name: Sistema - Structural
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

entity Sistema is
    port (
        clk, rst : in STD_LOGIC;
        start : in STD_LOGIC
    );
end Sistema;

architecture Structural of Sistema is

    component nodo_A
        port(
            clk, rst : in STD_LOGIC;
            start : in STD_LOGIC;
            serial_data : out STD_LOGIC
        );
    end component;

    component nodo_B
        port(
            clk, rst : in STD_LOGIC;
            serial_data : in STD_LOGIC
        );
    end component;
    
    signal bus_seriale : STD_LOGIC := '1';
    
begin

    A: nodo_A port map(
        clk => clk,
        rst => rst,
        start => start,
        serial_data => bus_seriale
    );

    B: nodo_B port map(
        clk => clk, 
        rst => rst,
        serial_data => bus_seriale
    );
    
end Structural;
