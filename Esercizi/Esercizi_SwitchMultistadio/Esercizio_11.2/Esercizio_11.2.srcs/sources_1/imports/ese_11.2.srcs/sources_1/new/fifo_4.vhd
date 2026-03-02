library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.omega_pkg.ALL; -- Importiamo il tipo t_message

entity fifo_4 is
    Port ( 
        clk      : in  std_logic;
        rst      : in  std_logic;
        
        -- Interfaccia di Ingresso
        push     : in  std_logic;
        data_in  : in  t_message;
        full     : out std_logic;
        
        -- Interfaccia di Uscita
        pop      : in  std_logic;
        data_out : out t_message;
        empty    : out std_logic
    );
end fifo_4;

architecture Structural of fifo_4 is

    -- Dichiarazione dei componenti elementari
    component counter_mod4 is
        Port ( clk : in std_logic; rst : in std_logic; en : in std_logic; count : out integer range 0 to 3 );
    end component;

    component counter_updown_4 is
        Port ( clk : in std_logic; rst : in std_logic; up : in std_logic; down : in std_logic; count : out integer range 0 to 4 );
    end component;

    -- Array fisico della memoria (4 locazioni)
    type t_fifo_mem is array (0 to 3) of t_message;
    signal mem : t_fifo_mem := (others => MSG_EMPTY);

    -- Cavi interni per i contatori
    signal head_ptr  : integer range 0 to 3; -- Indice di lettura
    signal tail_ptr  : integer range 0 to 3; -- Indice di scrittura
    signal num_elems : integer range 0 to 4; -- Quantità di pacchetti

    -- Segnali di sicurezza (non scrivo se pieno, non leggo se vuoto)
    signal s_full    : std_logic;
    signal s_empty   : std_logic;
    signal do_push   : std_logic;
    signal do_pop    : std_logic;

begin

    -- Logica per capire lo stato della memoria
    s_full  <= '1' when num_elems = 4 else '0';
    s_empty <= '1' when num_elems = 0 else '0';
    
    full  <= s_full;
    empty <= s_empty;

    -- Filtro di protezione contro scritture e letture non valide
    do_push <= push and (not s_full);
    do_pop  <= pop and (not s_empty);

    -- 1. Istanziazione Puntatore di Scrittura
    TAIL_COUNTER: counter_mod4 port map (
        clk   => clk,
        rst   => rst,
        en    => do_push,
        count => tail_ptr
    );

    -- 2. Istanziazione Puntatore di Lettura
    HEAD_COUNTER: counter_mod4 port map (
        clk   => clk,
        rst   => rst,
        en    => do_pop,
        count => head_ptr
    );

    -- 3. Istanziazione Contatore della quantità
    ELEM_COUNTER: counter_updown_4 port map (
        clk   => clk,
        rst   => rst,
        up    => do_push,
        down  => do_pop,
        count => num_elems
    );

    -- 4. Processo Sincrono per scrivere fisicamente nell'array
    process(clk)
    begin
        if rising_edge(clk) then
            if do_push = '1' then
                mem(tail_ptr) <= data_in;
            end if;
        end if;
    end process;

    -- 5. Lettura puramente combinatoria (FWFT)
    -- Se la memoria non è vuota, ti faccio subito vedere il dato in testa alla coda
    data_out <= mem(head_ptr) when s_empty = '0' else MSG_EMPTY;

end Structural;