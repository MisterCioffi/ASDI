library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cont_mod24 is
    Port (
        C         : in std_logic;
        RS        : in std_logic;
        SET       : in std_logic;              -- Pulsante di SET
        LOAD_VAL  : in std_logic_vector(4 downto 0); -- Valore da caricare (es. 12 = 01100)
        Y         : out std_logic_vector(4 downto 0)
    );
end cont_mod24;

architecture Structural of cont_mod24 is

    signal q0,q1,q2,q3,q4 : std_logic := '0';
    signal reset_totale : std_logic := '0';

    -- Nuova componente con LOAD
    component cont_mod2_load is
        Port(
            clk, rst, load, d_in : in std_logic;
            Y : out std_logic
        );
    end component;

begin

    -- Reset combinato (Manuale OR Automatico a 24)
    -- Nota: Il Reset ha priorità sul Load nel componente base, quindi va bene.
    reset_totale <= RS or (q4 and q3); 

    -- Collegamento Strutturale
    -- Ogni FF riceve il suo pezzetto di LOAD_VAL (d_in) e il segnale SET (load)
    
    CONT_0: cont_mod2_load port map (
        clk => C, rst => reset_totale, load => SET, d_in => LOAD_VAL(0), Y => q0
    );
    
    CONT_1: cont_mod2_load port map (
        clk => q0, rst => reset_totale, load => SET, d_in => LOAD_VAL(1), Y => q1
    );
    
    CONT_2: cont_mod2_load port map (
        clk => q1, rst => reset_totale, load => SET, d_in => LOAD_VAL(2), Y => q2
    );
    
    CONT_3: cont_mod2_load port map (
        clk => q2, rst => reset_totale, load => SET, d_in => LOAD_VAL(3), Y => q3
    );
    
    CONT_4: cont_mod2_load port map (
        clk => q3, rst => reset_totale, load => SET, d_in => LOAD_VAL(4), Y => q4
    );

    Y <= q4 & q3 & q2 & q1 & q0;

end Structural;
