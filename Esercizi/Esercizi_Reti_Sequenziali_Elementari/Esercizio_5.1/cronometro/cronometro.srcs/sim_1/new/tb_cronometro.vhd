----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 01:50:02 PM
-- Design Name: 
-- Module Name: tb_cronometro - Behavioral
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

entity tb_Cronometro is
-- Entity vuota
end tb_Cronometro;

architecture behavior of tb_Cronometro is

    -- Componente da testare (DUT)
    component Cronometro
    Port(
        CLK_BOARD : in std_logic;
        RST_BTN   : in std_logic;
        SET_BTN   : in std_logic;
        IN_ORE    : in std_logic_vector(4 downto 0);
        IN_MIN    : in std_logic_vector(5 downto 0);
        IN_SEC    : in std_logic_vector(5 downto 0);
        OUT_ORE   : out std_logic_vector(4 downto 0);
        OUT_MIN   : out std_logic_vector(5 downto 0);
        OUT_SEC   : out std_logic_vector(5 downto 0)
    );
    end component;

    -- Segnali di Test
    signal t_clk   : std_logic := '0';
    signal t_rst   : std_logic := '0';
    signal t_set   : std_logic := '0';
    
    -- Ingressi Dati
    signal t_in_ore : std_logic_vector(4 downto 0) := (others => '0');
    signal t_in_min : std_logic_vector(5 downto 0) := (others => '0');
    signal t_in_sec : std_logic_vector(5 downto 0) := (others => '0');

    -- Uscite Dati
    signal t_out_ore : std_logic_vector(4 downto 0);
    signal t_out_min : std_logic_vector(5 downto 0);
    signal t_out_sec : std_logic_vector(5 downto 0);

    -- Clock period (Simuliamo un clock veloce da 100MHz)
    constant clk_period : time := 10 ns;

begin

    uut: Cronometro port map (
        CLK_BOARD => t_clk, RST_BTN => t_rst, SET_BTN => t_set,
        IN_ORE => t_in_ore, IN_MIN => t_in_min, IN_SEC => t_in_sec,
        OUT_ORE => t_out_ore, OUT_MIN => t_out_min, OUT_SEC => t_out_sec
    );

    -- Generazione Clock
    clk_process : process
    begin
        t_clk <= '0'; wait for clk_period/2;
        t_clk <= '1'; wait for clk_period/2;
    end process;

    -- PROCESSO DI STIMOLO
    -- PROCESSO DI STIMOLO CORRETTO
    stim_proc: process
    begin

    -- 1. RESET FORZATO
    -- NON TOCCARE t_clk QUI! Lo gestisce già il clk_process.
    t_rst <= '1';   
    
    wait for 50 ns; -- Tienilo alto per 5 cicli di clock
    
    t_rst <= '0';   -- Rilascia il reset.
                    -- ORA il Prescaler inizierà a contare perché il clock è libero!
    
    -- 2. TEST DEL SET: Impostiamo 23:59:58
    -- ... (il resto del codice era perfetto) ...
        t_in_ore <= "10111"; -- 23
        t_in_min <= "111011"; -- 59
        t_in_sec <= "111010"; -- 58
        
        t_set <= '1';       
        wait for 100 ns;    
        t_set <= '0';       

        -- Ora osserva:
        -- Se hai messo CLOCK_FREQ => 10 nel Top Level:
        -- Vedrai il tick_1s muoversi ogni 50-100ns.
        
        wait for 600 ns; -- Aumentiamo il tempo per vedere bene lo scatto dell'ora

        assert false report "Simulazione Finita" severity failure;
        wait;
    end process;

end behavior;