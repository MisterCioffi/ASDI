----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2026 11:55:59 AM
-- Design Name: 
-- Module Name: rete_32_8 - Behavioral
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

entity rete_32_8 is
port(
  I: in std_logic_vector(31 downto 0);
  S1: in std_logic_vector(4 downto 0); --segnale di selezione del multiplexer
  S2: in std_logic_vector(2 downto 0); --segnale di selezione del demultiplexer
  Y : out STD_LOGIC_VECTOR (7 downto 0)
  
  );
end rete_32_8;

architecture Behavioral of rete_32_8 is

--SEGNALE INTERMEDIO
signal U: std_logic := '0';

--COMPONENTI

component mux_32_1
    Port ( I : in STD_LOGIC_VECTOR (31 downto 0);
           S : in STD_LOGIC_VECTOR (4 downto 0); -- Sempre 5 bit totali
           O : out STD_LOGIC);
end component;
    
component demux_8_1
   Port ( D : in STD_LOGIC;
          S : in STD_LOGIC_VECTOR (2 downto 0);
          Y : out STD_LOGIC_VECTOR (7 downto 0));
end component;
   
begin

mux: mux_32_1 Port map(I => I(31 downto 0), S => S1(4 downto 0), O => U);
demux: demux_8_1 Port map(D => U, S => S2(2 downto 0), Y => Y(7 downto 0));

end Behavioral;
