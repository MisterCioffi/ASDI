library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Level is
    Port (
        clk            : in  STD_LOGIC;                      -- Clock di sistema
        btn_reset      : in  STD_LOGIC;                      -- Reset (es. BTNC)
        btn_load_A     : in  STD_LOGIC;                      -- Carica primo operando (es. BTNL)
        btn_load_B     : in  STD_LOGIC;                      -- Carica secondo operando (es. BTNR)
        btn_start      : in  STD_LOGIC;                      -- AVVIA il calcolo (es. BTNU)
        switches       : in  STD_LOGIC_VECTOR(7 downto 0);   -- Input dati
        leds_risultato : out STD_LOGIC_VECTOR(15 downto 0);  -- Risultato Booth
        led_fatto      : out STD_LOGIC                       -- Segnale di fine calcolo
    );
end Top_Level;

architecture Structural of Top_Level is

    -- Segnali in uscita dai TRE debouncer
    signal pulse_A     : STD_LOGIC;
    signal pulse_B     : STD_LOGIC;
    signal pulse_start : STD_LOGIC;

    -- Registri di appoggio per "congelare" i valori degli switch
    signal reg_A_val : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal reg_B_val : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    -- Segnali interni per collegare il moltiplicatore
    signal booth_res_raw : STD_LOGIC_VECTOR(15 downto 0);
    signal booth_done    : STD_LOGIC;
    
    -- Reset attivo basso per il modulo Booth
    signal rst_n : STD_LOGIC;

begin

    -- Inversione del reset (da attivo alto della board a attivo basso del modulo)
    rst_n <= not btn_reset;

    ---------------------------------------------------------------------------
    -- 1. Istanza Debouncer per il primo operando (A)
    ---------------------------------------------------------------------------
    Debounce_Inst_A: entity work.Button_Conditioner
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            DEBOUNCE_MS => 20
        )
        port map (
            clk    => clk,
            btn_in => btn_load_A,
            pulse  => pulse_A
        );

    ---------------------------------------------------------------------------
    -- 2. Istanza Debouncer per il secondo operando (B)
    ---------------------------------------------------------------------------
    Debounce_Inst_B: entity work.Button_Conditioner
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            DEBOUNCE_MS => 20
        )
        port map (
            clk    => clk,
            btn_in => btn_load_B,
            pulse  => pulse_B
        );

    ---------------------------------------------------------------------------
    -- 3. Istanza Debouncer per l'AVVIO (Start)
    ---------------------------------------------------------------------------
    Debounce_Inst_Start: entity work.Button_Conditioner
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            DEBOUNCE_MS => 20
        )
        port map (
            clk    => clk,
            btn_in => btn_start,
            pulse  => pulse_start
        );

    ---------------------------------------------------------------------------
    -- 4. Logica di memorizzazione ingressi (Input Registers)
    ---------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_reset = '1' then
                reg_A_val <= (others => '0');
                reg_B_val <= (others => '0');
            else
                -- I bottoni di load si limitano ESCLUSIVAMENTE a salvare il dato
                if pulse_A = '1' then
                    reg_A_val <= switches;
                end if;
                
                if pulse_B = '1' then
                    reg_B_val <= switches;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- 5. Istanza del Moltiplicatore di Booth
    ---------------------------------------------------------------------------
    Booth_Core: entity work.MoltBooth8bit
        port map (
            clk       => clk,
            reset_n   => rst_n,
            avvio     => pulse_start,   -- Il modulo si sveglia solo con il terzo bottone!
            dato_X    => reg_A_val,
            dato_Y    => reg_B_val,
            risultato => booth_res_raw,
            fatto     => booth_done     
        );

    ---------------------------------------------------------------------------
    -- 6. REGISTRO DI USCITA E GESTIONE LED
    ---------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_reset = '1' then
                leds_risultato <= (others => '0');
                led_fatto      <= '0';
            else
                -- Quando premiamo START, spegniamo subito il LED 'fatto'
                -- così capiamo visivamente che il calcolo è in corso
                if pulse_start = '1' then
                    led_fatto <= '0';
                    
                -- Quando il core finisce, "catturiamo" i nuovi dati e riaccendiamo il LED
                elsif booth_done = '1' then
                    leds_risultato <= booth_res_raw;
                    led_fatto      <= '1';
                end if;
            end if;
        end if;
    end process;

end Structural;