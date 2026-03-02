----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2026 11:55:05
-- Design Name: 
-- Module Name: tb_riconoscitore - Behavioral
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

entity tb_riconoscitore is
end tb_riconoscitore;

-- architettura per riconoscitore di moore
architecture moore of tb_riconoscitore is

    -- componente di moore
    component riconoscitore_moore
        port(
            i : in STD_LOGIC;
            A : in STD_LOGIC;
            Y : out STD_LOGIC
        );
    end component;

    signal input : STD_LOGIC := '0';
    signal clock : STD_LOGIC := '0';
    signal output : STD_LOGIC;

    -- Periodo del clock
    constant T_CLK : time := 10 ns;

begin

    uut: riconoscitore_moore port map (
        i => input,
        A => clock,
        Y => output
    );

    -- Generazione del Clock continuo 
    process_clock : process
    begin
        clock <= '0';
        wait for T_CLK / 2;
        clock <= '1';
        wait for T_CLK / 2;
    end process;

    stim_proc : process
    begin
        -- Prima sequenza con "111" => SUCCESSO 
        input <= '1'; 
        wait for 3*T_CLK; --così l'input viene valutato 3 volte
        -- dopo il successo mi trovo nello stato S0_1 con uscita 1
        assert output = '1'
            report "Errore! uscita non corretta"
            severity failure;

        -- Seconda sequenza con "011" => FALLIMENTO al primo bit
        input <= '0'; wait for T_CLK;
        input <= '1'; wait for 2*T_CLK;

        -- Terza sequenza con "110" -> FALLIMENTO all'ultimo bit
        input <= '1'; wait for 2*T_CLK;
        input <= '0'; wait for T_CLK;
        
        wait;
    end process;

end moore;

---- architettura per riconoscitore di mealy
--architecture mealy of tb_riconoscitore is

--    -- componente di moore
--    component riconoscitore_mealy
--        port(
--            i : in STD_LOGIC;
--            A : in STD_LOGIC;
--            Y : out STD_LOGIC
--        );
--    end component;

--    signal input : STD_LOGIC := '0';
--    signal clock : STD_LOGIC := '0';
--    signal output : STD_LOGIC;

--    -- Periodo del clock
--    constant T_CLK : time := 10 ns;

--begin

--    uut: riconoscitore_mealy port map (
--        i => input,
--        A => clock,
--        Y => output
--    );

--    -- Generazione del Clock continuo 
--    process_clock : process
--    begin
--        clock <= '0';
--        wait for T_CLK / 2;
--        clock <= '1';
--        wait for T_CLK / 2;
--    end process;

--    stim_proc : process
--    begin
--        -- Prima sequenza con "111" => SUCCESSO 
--        input <= '1'; 
--        wait for 3*T_CLK; --così l'input viene valutato 3 volte
        
--        assert output = '1'
--            report "Errore! uscita non corretta"
--            severity failure;

--        -- Seconda sequenza con "011" => FALLIMENTO al primo bit
--        input <= '0'; wait for T_CLK;
--        input <= '1'; wait for 2*T_CLK;

--        -- Terza sequenza con "110" -> FALLIMENTO all'ultimo bit
--        input <= '1'; wait for 2*T_CLK;
--        input <= '0'; wait for T_CLK;
        
--        wait;
--    end process;

--end mealy;
