----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 01:44:56 PM
-- Design Name: 
-- Module Name: Cronometro - Behavioral
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

entity Cronometro is
    Port ( 
        CLK_BOARD : in std_logic; -- Clock veloce (es. 100MHz o 50MHz)
        RST_BTN   : in std_logic; -- Reset Totale
        SET_BTN   : in std_logic; -- Abilitazione SET
        
        -- Ingressi per impostare l'orario (es. switch)
        IN_ORE    : in std_logic_vector(4 downto 0);
        IN_MIN    : in std_logic_vector(5 downto 0);
        IN_SEC    : in std_logic_vector(5 downto 0);
        
        -- Uscite visualizzate
        OUT_ORE   : out std_logic_vector(4 downto 0);
        OUT_MIN   : out std_logic_vector(5 downto 0);
        OUT_SEC   : out std_logic_vector(5 downto 0)
    );
end Cronometro;

architecture Structural of Cronometro is

    -- SEGNALI INTERNI DI COLLEGAMENTO
    signal tick_1s : std_logic:= '0';       -- Impulso ogni secondo
    signal carry_sec : std_logic:= '0';     -- Da Secondi a Minuti
    signal carry_min : std_logic:= '0';     -- Da Minuti a Ore

    -- DICHIARAZIONE COMPONENTI
    
    -- 1. PRESCALER (Divisore)
    component Prescaler is
        Generic ( CLOCK_FREQ : integer ); 
        Port ( clk_in, reset : in std_logic; pulse_1s : out std_logic );
    end component;

    -- 2. MODULO 60 (Secondi/Minuti)
    component cont_mod60_load is
        Port( C, RS, SET : in std_logic; LOAD_VAL : in std_logic_vector(5 downto 0); 
              Y : out std_logic_vector(5 downto 0); COUT : out std_logic );
    end component;

    -- 3. MODULO 24 (Ore)
    component cont_mod24 is
        Port( C, RS, SET : in std_logic; LOAD_VAL : in std_logic_vector(4 downto 0); 
              Y : out std_logic_vector(4 downto 0) );
    end component;

begin

    -- ISTANZA PRESCALER
    -- IMPORTANTE: CLOCK_FREQ => 10 significa che conta fino a 10 e poi genera 1 secondo.
    -- Per la scheda reale metti 50000000 o 100000000.
    DIVISORE: Prescaler 
        generic map ( CLOCK_FREQ => 10 ) 
        port map ( clk_in => CLK_BOARD, reset => RST_BTN, pulse_1s => tick_1s );

    -- ISTANZA SECONDI
    -- Clock: tick_1s (arriva dal divisore)
    CNT_SEC: cont_mod60_load port map (
        C => tick_1s, RS => RST_BTN, SET => SET_BTN, LOAD_VAL => IN_SEC, 
        Y => OUT_SEC, COUT => carry_sec
    );

    -- ISTANZA MINUTI
    -- Clock: carry_sec (arriva dai secondi - Schema Seriale/Ripple)
    CNT_MIN: cont_mod60_load port map (
        C => carry_sec, RS => RST_BTN, SET => SET_BTN, LOAD_VAL => IN_MIN, 
        Y => OUT_MIN, COUT => carry_min
    );

    -- ISTANZA ORE
    -- Clock: carry_min (arriva dai minuti)
    CNT_ORE: cont_mod24 port map (
        C => carry_min, RS => RST_BTN, SET => SET_BTN, LOAD_VAL => IN_ORE, 
        Y => OUT_ORE
    );

end Structural;