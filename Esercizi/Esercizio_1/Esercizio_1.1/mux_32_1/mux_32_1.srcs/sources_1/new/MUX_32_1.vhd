----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2026 03:20:03 PM
-- Design Name: 
-- Module Name: MUX_32_1 - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_32_1 is
    Port ( I : in STD_LOGIC_VECTOR (31 downto 0);
           S : in STD_LOGIC_VECTOR (4 downto 0); -- Sempre 5 bit totali
           O : out STD_LOGIC);
end mux_32_1;

architecture Behavioral of mux_32_1 is

    -- SEGNALI INTERMEDI
    -- U1: Uscita del primo stadio (8 fili)
    signal U1: std_logic_vector(7 downto 0) := (others => '0');
    
    -- U2: Uscita del secondo stadio 
    -- NOTA: Ora sono 4 fili, perché usiamo 4 mux 2:1 (8 diviso 2 = 4)
    signal U2: std_logic_vector(3 downto 0) := (others => '0');

    -- COMPONENTI
    component mux_4_1
        port ( I : in STD_LOGIC_VECTOR (3 downto 0);
               S : in STD_LOGIC_VECTOR (1 downto 0);
               Y : out STD_LOGIC
      );
    end component;

    component mux_2_1
        port (
            I0 : in std_logic;
            I1 : in std_logic;
            s : in std_logic;
            y: out std_logic
      );
    end component;

begin

    -------------------------------------------------------------------------
    -- LIVELLO 1: Otto Mux 4:1 (INVARIATO)
    -- Input: I (32 bit) --> Output: U1 (8 bit)
    -- Selezione: S(1 downto 0)
    -------------------------------------------------------------------------
    mux_L1_0: mux_4_1 Port map( I => I(3 downto 0),   S => S(1 downto 0), Y => U1(0) );
    mux_L1_1: mux_4_1 Port map( I => I(7 downto 4),   S => S(1 downto 0), Y => U1(1) );
    mux_L1_2: mux_4_1 Port map( I => I(11 downto 8),  S => S(1 downto 0), Y => U1(2) );
    mux_L1_3: mux_4_1 Port map( I => I(15 downto 12), S => S(1 downto 0), Y => U1(3) );
    mux_L1_4: mux_4_1 Port map( I => I(19 downto 16), S => S(1 downto 0), Y => U1(4) );
    mux_L1_5: mux_4_1 Port map( I => I(23 downto 20), S => S(1 downto 0), Y => U1(5) );
    mux_L1_6: mux_4_1 Port map( I => I(27 downto 24), S => S(1 downto 0), Y => U1(6) );
    mux_L1_7: mux_4_1 Port map( I => I(31 downto 28), S => S(1 downto 0), Y => U1(7) );

    -------------------------------------------------------------------------
    -- LIVELLO 2: Quattro Mux 2:1 (MODIFICATO COME RICHIESTO)
    -- Input: U1 (8 bit) --> Output: U2 (4 bit)
    -- Selezione: S(2) -> Usiamo il terzo bit di selezione
    -------------------------------------------------------------------------
    
    -- Mux A: prende U1(0) e U1(1) -> Esce su U2(0)
    mux_L2_0: mux_2_1 
    Port map( I0 => U1(0), I1 => U1(1), s => S(2), y => U2(0) );

    -- Mux B: prende U1(2) e U1(3) -> Esce su U2(1)
    mux_L2_1: mux_2_1 
    Port map( I0 => U1(2), I1 => U1(3), s => S(2), y => U2(1) );

    -- Mux C: prende U1(4) e U1(5) -> Esce su U2(2)
    mux_L2_2: mux_2_1 
    Port map( I0 => U1(4), I1 => U1(5), s => S(2), y => U2(2) );

    -- Mux D: prende U1(6) e U1(7) -> Esce su U2(3)
    mux_L2_3: mux_2_1 
    Port map( I0 => U1(6), I1 => U1(7), s => S(2), y => U2(3) );


    -------------------------------------------------------------------------
    -- LIVELLO 3: Un Mux 4:1 (FINALE)
    -- Input: U2 (4 bit) --> Output: O (1 bit)
    -- Selezione: S(4 downto 3) -> Usiamo gli ultimi due bit più alti
    -------------------------------------------------------------------------
    -- Dato che dal livello 2 escono 4 fili, qui serve un Mux 4:1 per finire
    
    mux_final: mux_4_1
    Port map(
        I => U2,            -- Colleghiamo tutto il vettore U2 (4 bit)
        S => S(4 downto 3), -- Usiamo i bit più significativi
        Y => O              -- Uscita finale
    );

end Behavioral;
