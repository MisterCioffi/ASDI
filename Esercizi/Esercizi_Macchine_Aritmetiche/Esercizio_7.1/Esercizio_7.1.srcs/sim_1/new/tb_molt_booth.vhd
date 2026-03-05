----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 20:43:49
-- Design Name: 
-- Module Name: tb_molt_booth - Behavioral
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

entity tb_molt_booth is
end tb_molt_booth;

architecture Test of tb_molt_booth is
    
    component molt_booth is
        port(
            clock, reset, start : in std_logic;
            X, Y                : in std_logic_vector(7 downto 0);
            P                   : out std_logic_vector(15 downto 0);
            stop_cu             : out std_logic
        );
    end component;

    signal clock   : std_logic;
    signal reset   : std_logic := '0'; 
    signal start   : std_logic := '0';
    signal in_X    : std_logic_vector(7 downto 0) := (others => '0');
    signal in_Y    : std_logic_vector(7 downto 0) := (others => '0');
    signal out_P   : std_logic_vector(15 downto 0);
    signal stop_cu : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: molt_booth
        port map (
            clock   => clock,
            reset   => reset,
            start   => start,
            X       => in_X,
            Y       => in_Y,
            P       => out_P,
            stop_cu => stop_cu
        );

    -- Generatore di clock
    clk_process : process
    begin
        clock <= '0'; wait for clk_period/2;
        clock <= '1'; wait for clk_period/2;
    end process;

    proc_test: process
    begin
      
        reset <= '1';
        wait for 25 ns;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Test 1: 15 * 4 = 60
        in_X <= std_logic_vector(to_signed(15, 8));
        in_Y <= std_logic_vector(to_signed(4, 8));
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until stop_cu = '1';
        wait for CLK_PERIOD * 2;

        -- Test 2: -7 * 3 = -21
        in_X <= std_logic_vector(to_signed(-7, 8));
        in_Y <= std_logic_vector(to_signed(3, 8));
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until stop_cu = '1';
        wait for CLK_PERIOD * 2;

        -- Test 3: -5 * -6 = 30
        in_X <= std_logic_vector(to_signed(-5, 8));
        in_Y <= std_logic_vector(to_signed(-6, 8));
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until stop_cu = '1';

        wait;
    end process;

end Test;
