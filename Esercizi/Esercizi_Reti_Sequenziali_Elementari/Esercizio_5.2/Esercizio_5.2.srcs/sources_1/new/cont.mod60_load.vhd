library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cont_mod60_load is
    Port(
        C         : in std_logic;
        RS        : in std_logic;
        SET       : in std_logic;                    -- Pulsante di SET
        LOAD_VAL  : in std_logic_vector(5 downto 0); -- Valore da caricare
        Y         : out std_logic_vector(5 downto 0);
        COUT      : out std_logic                    -- NECESSARIO: Clock per lo stadio successivo
    );
end cont_mod60_load;

architecture Structural of cont_mod60_load is

    signal q0,q1,q2,q3,q4,q5 : std_logic := '0';
    signal reset_totale : std_logic := '0';

    component cont_mod2_load is
        Port(
            clk, rst, load, d_in : in std_logic;
            Y : out std_logic
        );
    end component;

begin
    -- Logica di Reset a 60 (111100)
    -- Questa logica serve sia per azzerare i flip-flop sia per generare il Carry
    reset_totale <= RS or (q5 and q4 and q3 and q2); 

    -- Collegamento Seriale (Ripple Counter)
    CONT_0: cont_mod2_load port map (C, reset_totale, SET, LOAD_VAL(0), q0);
    CONT_1: cont_mod2_load port map (q0, reset_totale, SET, LOAD_VAL(1), q1);
    CONT_2: cont_mod2_load port map (q1, reset_totale, SET, LOAD_VAL(2), q2);
    CONT_3: cont_mod2_load port map (q2, reset_totale, SET, LOAD_VAL(3), q3);
    CONT_4: cont_mod2_load port map (q3, reset_totale, SET, LOAD_VAL(4), q4);
    CONT_5: cont_mod2_load port map (q4, reset_totale, SET, LOAD_VAL(5), q5);       

    -- Uscita del conteggio
    Y <= q5 & q4 & q3 & q2 & q1 & q0;

    -- Uscita di Riporto (Carry Out)
    -- Quando arriva a 60, resetta E manda un impulso allo stadio successivo
    COUT <= (q5 and q4 and q3 and q2);

end Structural;