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
    
    -- Flag per ricordare se i valori sono stati caricati
    signal flag_A : STD_LOGIC := '0';
    signal flag_B : STD_LOGIC := '0';

    -- Registri di appoggio per "congelare" i valori degli switch
    signal reg_A_val : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal reg_B_val : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    -- Segnali interni per collegare il moltiplicatore
    signal booth_res_raw : STD_LOGIC_VECTOR(15 downto 0);
    signal booth_done    : STD_LOGIC;
    
    -- Reset attivo basso per il modulo Booth
    signal rst_n : STD_LOGIC;

begin

    -- Inversione del reset
    rst_n <= btn_reset;

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
    -- 4. GESTIONE INTERFACCIA UTENTE (Registri, Flag e LED)
    ---------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_reset = '1' then
                reg_A_val      <= (others => '0');
                reg_B_val      <= (others => '0');
                flag_A         <= '0';
                flag_B         <= '0';
                leds_risultato <= (others => '0');
                led_fatto      <= '0';
            else
                -- AVVIO: Spegni il LED di stato e resetta i flag per la prossima operazione
                if pulse_start = '1' then
                    led_fatto <= '0';
                    flag_A    <= '0';
                    flag_B    <= '0';
                    
                -- FINE CALCOLO: Aggiorna i LED risultato e riaccendi il LED di stato
                elsif booth_done = '1' then
                    leds_risultato <= booth_res_raw;
                    
                -- FASE DI CARICAMENTO E ATTESA
                else
                    if pulse_A = '1' then
                        reg_A_val <= switches;
                        flag_A    <= '1'; -- Ricorda che A è stato caricato
                    end if;
                    
                    if pulse_B = '1' then
                        reg_B_val <= switches;
                        flag_B    <= '1'; -- Ricorda che B è stato caricato
                    end if;
                    
                    -- Condizione di accensione LED "Sistema Pronto"
                    -- Se entrambi i flag sono 1 (o stanno diventando 1 proprio in questo ciclo)
                    if (flag_A = '1' or pulse_A = '1') and (flag_B = '1' or pulse_B = '1') then
                        led_fatto <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- 5. Istanza del Moltiplicatore di Booth
    ---------------------------------------------------------------------------
    Booth_Core: entity work.molt_booth
        port map (
            clock       => clk,
            reset       => rst_n,
            start       => pulse_start,   -- Il modulo si sveglia solo con il terzo bottone!
            X           => reg_A_val,
            Y           => reg_B_val,
            P           => booth_res_raw,
            stop_cu     => booth_done     
        );
        
end Structural;