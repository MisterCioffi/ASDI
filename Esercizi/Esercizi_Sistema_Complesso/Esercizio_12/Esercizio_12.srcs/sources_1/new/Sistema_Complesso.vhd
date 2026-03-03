----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
-- Design Name: 
-- Module Name: Sistema_Complesso - Behavioral
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

entity Sistema_Complesso is
    port (
        clk_A, clk_B : in STD_LOGIC;
        rst : in STD_LOGIC;
        start : in STD_LOGIC
    );
end Sistema_Complesso;

architecture Structural of Sistema_Complesso is

    component Nodo_A
        port(
            clk, rst : in STD_LOGIC;
            start : in STD_LOGIC;
            ack : in STD_LOGIC;
            req : out STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component Nodo_B
        port (
            clk, rst : in STD_LOGIC;
            req : in STD_LOGIC;
            ack : out STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal richiesta, acknowledge : STD_LOGIC;
    signal data_bus : STD_LOGIC_VECTOR(7 downto 0);

begin

    a : Nodo_A
        port map (
            clk => clk_A,
            rst => rst,
            start => start,
            ack => acknowledge,
            req => richiesta,
            data_out => data_bus
        );

    b : Nodo_B
        port map (
            clk => clk_B,
            rst => rst,
            req => richiesta,
            ack => acknowledge,
            data_in => data_bus
        );

end Structural;
