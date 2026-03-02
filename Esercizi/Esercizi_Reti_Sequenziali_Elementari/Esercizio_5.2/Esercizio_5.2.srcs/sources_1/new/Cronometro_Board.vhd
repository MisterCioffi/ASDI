library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Cronometro_Board is
    Port ( 
        CLK100MHZ : in STD_LOGIC;
        BTNU      : in STD_LOGIC; -- Bottone per il RESET
        BTNC      : in STD_LOGIC; -- Bottone per il SET
        SW        : in STD_LOGIC_VECTOR(10 downto 0); -- 11 Switch (5 per Ore, 6 per Minuti)
        
        -- Uscite Display 7 Segmenti
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;
        DP : out STD_LOGIC;
        AN : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Cronometro_Board;

architecture Structural of Cronometro_Board is

    -- 1. Istanza del tuo Cronometro
    component Cronometro
        Port ( 
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

    -- Segnali in uscita dal cronometro
    signal sec_bin, min_bin : std_logic_vector(5 downto 0);
    signal ore_bin : std_logic_vector(4 downto 0);

    -- Segnali BCD (Cifre separate da 0 a 9)
    signal sec_U, sec_D : integer range 0 to 9;
    signal min_U, min_D : integer range 0 to 9;
    signal ore_U, ore_D : integer range 0 to 9;

    -- Segnali per il Multiplexer del Display
    signal refresh_cnt  : integer range 0 to 100000 := 0; -- Contatore per 1 kHz
    signal active_digit : integer range 0 to 7 := 0;
    signal current_bcd  : integer range 0 to 9;

begin

    -- =========================================================
    -- MAPPARURA DEL CRONOMETRO
    -- =========================================================
    UUT: Cronometro port map (
        CLK_BOARD => CLK100MHZ,
        RST_BTN   => BTNU,
        SET_BTN   => BTNC,
        -- Cablaggio Switch
        IN_ORE    => SW(10 downto 6), -- I 5 switch più a sinistra
        IN_MIN    => SW(5 downto 0),  -- I 6 switch a destra
        IN_SEC    => "000000",        -- Secondi bloccati a 0 durante il SET
        -- Uscite
        OUT_ORE   => ore_bin,
        OUT_MIN   => min_bin,
        OUT_SEC   => sec_bin
    );

    -- =========================================================
    -- CONVERSIONE BINARY TO BCD (Matematica per il decimale)
    -- =========================================================
    -- Trasformiamo i vettori in interi per estrarre decine (/10) e unità (mod 10)
    sec_D <= to_integer(unsigned(sec_bin)) / 10;
    sec_U <= to_integer(unsigned(sec_bin)) mod 10;
    
    min_D <= to_integer(unsigned(min_bin)) / 10;
    min_U <= to_integer(unsigned(min_bin)) mod 10;
    
    ore_D <= to_integer(unsigned(ore_bin)) / 10;
    ore_U <= to_integer(unsigned(ore_bin)) mod 10;

    -- =========================================================
    -- MULTIPLEXER DISPLAY 7 SEGMENTI (Scansione a ~1 kHz)
    -- =========================================================
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if refresh_cnt = 100000 then -- Ogni 1 ms si sposta alla cifra successiva
                refresh_cnt <= 0;
                if active_digit = 5 then -- Usiamo solo 6 display (0 a 5)
                    active_digit <= 0;
                else
                    active_digit <= active_digit + 1;
                end if;
            else
                refresh_cnt <= refresh_cnt + 1;
            end if;
        end if;
    end process;

    -- Selettore degli Anodi e del dato da mostrare
    process(active_digit, sec_U, sec_D, min_U, min_D, ore_U, ore_D)
    begin
        -- Di default spegniamo tutti i display (1 = spento su Nexys)
        AN <= "11111111"; 
        
        case active_digit is
            when 0 => 
                AN(0) <= '0';         -- Accende il primo display a destra
                current_bcd <= sec_U; -- Invia le Unità dei Secondi
            when 1 => 
                AN(1) <= '0';
                current_bcd <= sec_D; -- Invia le Decine dei Secondi
            when 2 => 
                AN(2) <= '0';
                current_bcd <= min_U;
            when 3 => 
                AN(3) <= '0';
                current_bcd <= min_D;
            when 4 => 
                AN(4) <= '0';
                current_bcd <= ore_U;
            when 5 => 
                AN(5) <= '0';
                current_bcd <= ore_D;
            when others =>
                current_bcd <= 0;
        end case;
    end process;

    -- =========================================================
    -- DECODER BCD TO 7-SEGMENTS
    -- =========================================================
    -- I segmenti della Nexys si accendono con lo ZERO logico!
    process(current_bcd)
    begin
        case current_bcd is
            --               CA CB CC CD CE CF CG
            when 0 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0000001");
            when 1 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("1001111");
            when 2 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0010010");
            when 3 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0000110");
            when 4 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("1001100");
            when 5 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0100100");
            when 6 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0100000");
            when 7 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0001111");
            when 8 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0000000");
            when 9 => (CA,CB,CC,CD,CE,CF,CG) <= std_logic_vector'("0000100");
            when others =>(CA,CB,CC,CD,CE,CF,CG)<= std_logic_vector'("1111111");
        end case;
    end process;

    -- I punti decimali li teniamo spenti inserendo '1' (oppure potresti usarli per lampeggiare!)
    DP <= '1';

end Structural;