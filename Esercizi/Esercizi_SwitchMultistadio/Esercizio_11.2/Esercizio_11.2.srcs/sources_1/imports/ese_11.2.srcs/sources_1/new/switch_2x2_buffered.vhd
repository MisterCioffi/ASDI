library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.omega_pkg.ALL;

entity switch_2x2_buffered is
    generic (
        STAGE_BIT : integer -- Quale bit dell'indirizzo guardare (2, 1, o 0)
    );
    Port ( 
        clk        : in  std_logic;
        rst        : in  std_logic;
        
        -- Ingresso 0 (Top)
        in_0       : in  t_message;
        wait_out_0 : out std_logic;  -- Segnale "Sono pieno" verso chi ci manda dati
        
        -- Ingresso 1 (Bottom)
        in_1       : in  t_message;
        wait_out_1 : out std_logic;
        
        -- Uscita 0 (Top)
        out_0      : out t_message;
        wait_in_0  : in  std_logic;  -- Segnale "Sono pieno" dallo stadio successivo
        
        -- Uscita 1 (Bottom)
        out_1      : out t_message;
        wait_in_1  : in  std_logic
    );
end switch_2x2_buffered;

architecture Behavioral of switch_2x2_buffered is

    -- Componente FIFO
    component fifo_4 is
        Port ( clk : in std_logic; rst : in std_logic; push : in std_logic; data_in : in t_message; full : out std_logic; pop : in std_logic; data_out : out t_message; empty : out std_logic);
    end component;

    -- Segnali FIFO 0
    signal pop_0      : std_logic;
    signal fifo_0_out : t_message;
    signal empty_0    : std_logic;

    -- Segnali FIFO 1
    signal pop_1      : std_logic;
    signal fifo_1_out : t_message;
    signal empty_1    : std_logic;

    -- Segnali di decodifica (Dove vogliono andare i pacchetti?)
    signal req_0_to_0, req_0_to_1 : std_logic;
    signal req_1_to_0, req_1_to_1 : std_logic;

    -- Segnali di Concessione (Chi ha vinto il conflitto?)
    signal grant_0_to_0, grant_1_to_0 : std_logic;
    signal grant_0_to_1, grant_1_to_1 : std_logic;

    -- Flag per il Round-Robin Locale
    signal rr_flag : std_logic := '0'; 
    signal conflict_0, conflict_1 : std_logic;

begin

    -- ==========================================
    -- 1. ISTANZIAZIONE DELLE FIFO DI INGRESSO
    -- ==========================================
    FIFO_TOP: fifo_4 port map (
        clk      => clk,
        rst      => rst,
        push     => in_0.valid,   -- Scrivo se arriva un pacchetto valido
        data_in  => in_0,
        full     => wait_out_0,   -- Il "Full" blocca direttamente lo stadio precedente!
        pop      => pop_0,
        data_out => fifo_0_out,
        empty    => empty_0
    );

    FIFO_BOTTOM: fifo_4 port map (
        clk      => clk,
        rst      => rst,
        push     => in_1.valid,
        data_in  => in_1,
        full     => wait_out_1,
        pop      => pop_1,
        data_out => fifo_1_out,
        empty    => empty_1
    );

    -- ==========================================
    -- 2. LOGICA DI ROUTING (Dove vogliono andare?)
    -- ==========================================
    -- Se la FIFO non è vuota, guardo il bit STAGE_BIT del pacchetto in testa
    req_0_to_0 <= '1' when empty_0 = '0' and fifo_0_out.dst(STAGE_BIT) = '0' else '0';
    req_0_to_1 <= '1' when empty_0 = '0' and fifo_0_out.dst(STAGE_BIT) = '1' else '0';
    
    req_1_to_0 <= '1' when empty_1 = '0' and fifo_1_out.dst(STAGE_BIT) = '0' else '0';
    req_1_to_1 <= '1' when empty_1 = '0' and fifo_1_out.dst(STAGE_BIT) = '1' else '0';

    -- Rilevamento Conflitti fisici
    conflict_0 <= req_0_to_0 and req_1_to_0; -- Entrambi vogliono l'uscita Top
    conflict_1 <= req_0_to_1 and req_1_to_1; -- Entrambi vogliono l'uscita Bottom

    -- ==========================================
    -- 3. ARBITRAGGIO COMBINATORIO E ASSEGNAZIONE
    -- ==========================================
    -- Assegnazione Uscita 0 (Top)
    grant_0_to_0 <= '1' when req_0_to_0 = '1' and (conflict_0 = '0' or rr_flag = '0') else '0';
    grant_1_to_0 <= '1' when req_1_to_0 = '1' and (conflict_0 = '0' or rr_flag = '1') else '0';

    -- Assegnazione Uscita 1 (Bottom)
    grant_0_to_1 <= '1' when req_0_to_1 = '1' and (conflict_1 = '0' or rr_flag = '0') else '0';
    grant_1_to_1 <= '1' when req_1_to_1 = '1' and (conflict_1 = '0' or rr_flag = '1') else '0';

    -- MUX per Uscita 0 (MODIFICATO: aggiunto il blocco wait_in)
    out_0 <= fifo_0_out when (grant_0_to_0 = '1' and wait_in_0 = '0') else
             fifo_1_out when (grant_1_to_0 = '1' and wait_in_0 = '0') else 
             MSG_EMPTY;

    -- MUX per Uscita 1 (MODIFICATO: aggiunto il blocco wait_in)
    out_1 <= fifo_0_out when (grant_0_to_1 = '1' and wait_in_1 = '0') else
             fifo_1_out when (grant_1_to_1 = '1' and wait_in_1 = '0') else 
             MSG_EMPTY;

    -- ==========================================
    -- 4. LOGICA DI ESTRAZIONE E BACKPRESSURE
    -- ==========================================
    -- Un pacchetto viene estratto dalla sua FIFO SOLO SE ha vinto l'arbitraggio 
    -- E l'uscita corrispondente non è bloccata dallo stadio successivo (wait_in = '0')
    pop_0 <= (grant_0_to_0 and not wait_in_0) or (grant_0_to_1 and not wait_in_1);
    pop_1 <= (grant_1_to_0 and not wait_in_0) or (grant_1_to_1 and not wait_in_1);

    -- ==========================================
    -- 5. AGGIORNAMENTO ROUND-ROBIN
    -- ==========================================
    -- Il flag cambia stato solo se c'è stato un conflitto e il vincitore
    -- è riuscito fisicamente a trasmettere il dato (nessun wait_in attivo).
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rr_flag <= '0';
            else
                if (conflict_0 = '1' and wait_in_0 = '0') or 
                   (conflict_1 = '1' and wait_in_1 = '0') then
                    rr_flag <= not rr_flag; -- Alterna la priorità
                end if;
            end if;
        end if;
    end process;

end Behavioral;