----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 17:57:27
-- Design Name: 
-- Module Name: molt_booth - Behavioral
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


entity molt_booth is
    port(
        clock, reset, start : in std_logic;
        X, Y                : in std_logic_vector(7 downto 0);
        P                   : out std_logic_vector(15 downto 0);
        stop_cu             : out std_logic
    );
end molt_booth;

architecture Structural of molt_booth is

    component unita_controllo is
        port(
            clock, reset, start : in std_logic;
            q0, q_minus1        : in std_logic;
            counter             : in std_logic_vector(2 downto 0);
            loadA, loadQ, loadM : out std_logic;
            shift, subtract     : out std_logic;
            reset_init          : out std_logic;
            count_in            : out std_logic;
            stop_cu             : out std_logic
        );
    end component;

    component unita_operativa is
        port( 
            X, Y                                  : in std_logic_vector(7 downto 0);
            clock, reset                          : in std_logic;
            loadA, loadQ, loadM                   : in std_logic;
            shift, subtract, reset_init, count_in : in std_logic;
            q0, q_minus1                          : out std_logic;
            counter                               : out std_logic_vector(2 downto 0);
            P                                     : out std_logic_vector(15 downto 0)
        );
    end component;

    signal temp_q0, temp_q_minus1 : std_logic;
    signal temp_counter           : std_logic_vector(2 downto 0);
    signal temp_loadA, temp_loadQ, temp_loadM : std_logic;
    signal temp_shift, temp_subtract, temp_reset_init, temp_count_in : std_logic;

begin

    UC: unita_controllo port map(
        clock      => clock,
        reset      => reset,
        start      => start,
        q0         => temp_q0,
        q_minus1   => temp_q_minus1,
        counter    => temp_counter,
        loadA      => temp_loadA,
        loadQ      => temp_loadQ,
        loadM      => temp_loadM,
        shift      => temp_shift,
        subtract   => temp_subtract,
        reset_init => temp_reset_init,
        count_in   => temp_count_in,
        stop_cu    => stop_cu
    );

    UO: unita_operativa port map(
        X          => X,
        Y          => Y,
        clock      => clock,
        reset      => reset,
        loadA      => temp_loadA,
        loadQ      => temp_loadQ,
        loadM      => temp_loadM,
        shift      => temp_shift,
        subtract   => temp_subtract,
        reset_init => temp_reset_init,
        count_in   => temp_count_in,
        q0         => temp_q0,
        q_minus1   => temp_q_minus1,
        counter    => temp_counter,
        P          => P
    );

end Structural;
