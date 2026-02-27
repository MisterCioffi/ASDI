----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:44:09
-- Design Name: 
-- Module Name: RCA_4 - Structural
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

entity RCA_4 is
    port(
        x, y : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        c_in : in STD_LOGIC; 
        c_out : out STD_LOGIC;
        s : out STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end RCA_4;

architecture Structural of RCA_4 is
    
    component FA 
        port(
            x, y : in STD_LOGIC;
            c_in : in STD_LOGIC;
            s, c_out : out STD_LOGIC
        );
    end component;
    
    signal u : STD_LOGIC_VECTOR(4 DOWNTO 0);
    
begin
    
    u(0) <= c_in;
    rca: FOR i IN 0 TO 3 GENERATE
        fa_i: FA port map(
            x => x(i),
            y => y(i),
            c_in => u(i),
            c_out => u(i+1),
            s => s(i) 
        );
    end generate;
    c_out <= u(4);
    
end Structural;
