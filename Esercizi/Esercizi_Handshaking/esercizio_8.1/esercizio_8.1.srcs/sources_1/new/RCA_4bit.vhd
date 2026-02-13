----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2026 05:18:48 PM
-- Design Name: 
-- Module Name: RCA_4bit - Behavioral
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

entity RCA_4bit is
    Port ( 
        A_in  : in  STD_LOGIC_VECTOR (3 downto 0); -- Primo addendo (nibble alto)
        B_in  : in  STD_LOGIC_VECTOR (3 downto 0); -- Secondo addendo (nibble basso)
        S_out : out STD_LOGIC_VECTOR (4 downto 0)  -- Somma (5 bit per evitare overflow)
    );
end RCA_4bit;

architecture Structural of RCA_4bit is

    -- 1. Dichiarazione del componente fatto prima
    component full_adder
        Port ( a, b, cin : in STD_LOGIC;
               s, cout   : out STD_LOGIC);
    end component;

    -- 2. Segnali interni per i riporti (Carry)
    signal c1, c2, c3 : STD_LOGIC;

begin

    -- 3. Istanziazione dei 4 Full Adder
    -- Bit 0 (LSB) - Il carry in ingresso è fisso a '0'
    FA0: full_adder port map (
        a    => A_in(0),
        b    => B_in(0),
        cin  => '0',
        s    => S_out(0),
        cout => c1  -- Il riporto esce su c1
    );

    -- Bit 1 - Prende c1 in ingresso
    FA1: full_adder port map (
        a    => A_in(1),
        b    => B_in(1),
        cin  => c1, -- Eccolo collegato
        s    => S_out(1),
        cout => c2
    );

    -- Bit 2
    FA2: full_adder port map (
        a    => A_in(2),
        b    => B_in(2),
        cin  => c2,
        s    => S_out(2),
        cout => c3
    );

    -- Bit 3 (MSB)
    FA3: full_adder port map (
        a    => A_in(3),
        b    => B_in(3),
        cin  => c3,
        s    => S_out(3),
        cout => S_out(4) -- L'ultimo riporto diventa il 5° bit della somma
    );

end Structural;
