library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Sistema is

end tb_Sistema;

architecture behavior of tb_Sistema is

    component Sistema
        port(
            clk   : in STD_LOGIC;
            rst   : in STD_LOGIC;
            start : in STD_LOGIC
        );
    end component;

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1'; -- Inizializzo il sistema resettato
    signal start : std_logic := '0';

    constant clk_period : time := 40 ns;

begin

    uut: Sistema port map (
        clk   => clk,
        rst   => rst,
        start => start
    );

    -- Processo del Clock
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- Reset attivo per stabilizzare il sistema
        wait for 100 ns;
        
        rst <= '0';
        wait for 100 ns;

        -- impulso di START 
        start <= '1';
        wait for clk_period; 
        start <= '0';

        -- Attesa della fine delle trasmissioni
        wait for 20 ms;
        
        -- Contenuto finale atteso nella mem:
        -- x"A", x"C", x"E", x"0", x"2", x"4", x"6", x"8", x"A", x"C", x"E", x"0", x"2", x"4", x"6", x"8"
        
    end process;

end behavior;