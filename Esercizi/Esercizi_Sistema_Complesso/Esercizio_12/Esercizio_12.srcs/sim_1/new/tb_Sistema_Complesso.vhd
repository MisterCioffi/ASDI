----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.03.2026 14:05:28
-- Design Name: 
-- Module Name: tb_Sistema_Complesso - Behavioral
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

entity tb_Sistema_Complesso is
end tb_Sistema_Complesso;

architecture Behavioral of tb_Sistema_Complesso is

    component Sistema_Complesso
        port (
            clk_A, clk_B : in STD_LOGIC;
            rst   : in STD_LOGIC;
            start : in STD_LOGIC
        );
    end component;

    signal clk_A : std_logic := '0';
    signal clk_B : std_logic := '0';
    signal rst   : std_logic := '0';
    signal start : std_logic := '0';

    -- ========================================================
    -- CONFIGURAZIONE FREQUENZE 
    -- ========================================================
    -- SCENARIO 1 (clkA > clkB): A=10ns (100MHz), B=25ns (40MHz)
    -- SCENARIO 2 (clkB > clkA): A=25ns (40MHz), B=10ns (100MHz)
    
    constant CLK_A_PERIOD : time := 10 ns; 
    constant CLK_B_PERIOD : time := 25 ns; 
    
    constant PHASE_SHIFT  : time := 3 ns; -- Sfasamento tra i due clock

begin

    UUT: Sistema_Complesso port map (
        clk_A => clk_A,
        clk_B => clk_B,
        rst   => rst,
        start => start
    );

    -- Generatore Clock A
    process
    begin
        clk_A <= '0'; wait for CLK_A_PERIOD/2;
        clk_A <= '1'; wait for CLK_A_PERIOD/2;
    end process;

    -- Generatore Clock B (Con sfasamento iniziale)
    process
    begin
        wait for PHASE_SHIFT; -- Attesa iniziale per sfasare le creste
        loop
            clk_B <= '0'; wait for CLK_B_PERIOD/2;
            clk_B <= '1'; wait for CLK_B_PERIOD/2;
        end loop;
    end process;

    -- Processo di Stimolo
    process
    begin
        -- 1. Reset iniziale prolungato
        rst <= '1';
        wait for 50 ns;
        
        rst <= '0';

        -- 2. Diamo l'impulso di START al Nodo A
        -- Assicurati che l'impulso sia abbastanza lungo da essere letto 
        -- dal clock di A, indipendentemente dalla sua velocit�.
        start <= '1';
        wait for CLK_A_PERIOD * 2; 
        start <= '0';

        -- A questo punto il sistema � autonomo. 
        -- La CU di A legger� gli indirizzi 0 e 1, moltiplicher�, 
        -- mander� il dato a B tramite handshaking,
        -- e poi passer� automaticamente agli indirizzi 2 e 3 (Scenario Negativo).
        
        wait for 2000 ns; -- Tempo sufficiente per completare pi� cicli
        
        wait;
    end process;

end Behavioral;
