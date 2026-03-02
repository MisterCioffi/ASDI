----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2026 10:06:40
-- Design Name: 
-- Module Name: board_riconoscitore - Behavioral
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

-- L'Entity che corrisponde fisicamente alla tua scheda
entity board_riconoscitore is
    Port ( 
        A  : in  STD_LOGIC; -- Clock di sistema (Il quarzo della scheda)
        B  : in  STD_LOGIC; -- Bottone per l'Enable
        S1 : in  STD_LOGIC; -- Switch per l'ingresso dati 'i'
        Y  : out STD_LOGIC  -- LED di uscita del riconoscitore
    );
end board_riconoscitore;

architecture Structural of board_riconoscitore is

    -- 1. Dichiarazione del tuo Riconoscitore (la FSM)
    component riconoscitore_moore
        Port ( 
            A    : in  STD_LOGIC;
            enable : in  STD_LOGIC;
            i      : in  STD_LOGIC;
            y      : out STD_LOGIC
        );
    end component;

    -- 2. Dichiarazione del Filtro Bottone (con i Generic)
    component Button_Conditioner
        Generic (
            CLK_FREQ_HZ : integer := 50_000_000;
            DEBOUNCE_MS : integer := 20
        );
        Port ( 
            clk    : in  STD_LOGIC;
            btn_in : in  STD_LOGIC;
            pulse  : out STD_LOGIC
        );
    end component;

    -- Segnale interno: l'impulso pulito che esce dal filtro ed entra nella FSM
    signal E_pulse : STD_LOGIC;

begin

    -- 3. Istanziazione del Filtro
    Filtro_Bottone: Button_Conditioner 
        generic map (
            CLK_FREQ_HZ => 100_000_000, 
            DEBOUNCE_MS => 20          
        )
        port map (
            clk    => A,
            btn_in => B,
            pulse  => E_pulse
        );

    -- 4. Istanziazione del Riconoscitore
    Macchina_Stati: riconoscitore_moore port map (
        A    => A,
        enable => E_pulse, -- l'impulso filtrato, non il bottone diretto
        i      => S1,
        y      => Y
    );

end Structural;
