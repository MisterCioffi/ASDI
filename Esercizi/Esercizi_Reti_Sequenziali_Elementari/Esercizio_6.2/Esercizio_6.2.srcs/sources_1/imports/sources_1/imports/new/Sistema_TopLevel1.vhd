library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sistema_TopLevel is
    Port (
        CLK        : in  std_logic;
        RST        : in  std_logic;                    -- Bottone Centrale
        START      : in  std_logic;                    -- Switch 15
        READ_BTN   : in  std_logic;                    -- Bottone Destro
        STRINGA_X  : in  std_logic_vector(7 downto 0); -- Switch 0-7

        LED_DATA   : out std_logic_vector(7 downto 0); -- LD0-LD7
        LED_MATCH  : out std_logic                     -- LD15
    );
end Sistema_TopLevel;

architecture Structural of Sistema_TopLevel is
    signal w_addr      : std_logic_vector(3 downto 0);
    signal w_rom_data  : std_logic_vector(7 downto 0);
    signal w_match     : std_logic;
    signal w_read_step : std_logic;
    signal w_cnt_en, w_rom_en, w_mem_we, w_cnt_rst, w_end_count : std_logic;
begin

    -- Uscite dirette
    LED_DATA  <= w_rom_data;
    LED_MATCH <= w_match;

    -- Debouncer per il bottone di lettura (fondamentale per i tasti fisici)
    INST_DEB: entity work.Button_Conditioner
        generic map ( CLK_FREQ_HZ => 100_000_000, DEBOUNCE_MS => 20 )
        port map ( clk => CLK, btn_in => READ_BTN, pulse => w_read_step );

    -- Contatore (Indirizzi)
    INST_CONT: entity work.Contatore_Generic
        port map ( CLK => CLK, RST => w_cnt_rst, EN => w_cnt_en, COUNT => w_addr, END_COUNT => w_end_count );

    -- ROM (Dati precaricati)
    INST_ROM: entity work.Memoria_ROM
        port map ( clk => CLK, read_en => w_rom_en, addr => w_addr, data_out => w_rom_data );

    -- Comparatore
    INST_COMP: entity work.Comparatore_8bit
        port map ( IN_A => w_rom_data, IN_B => STRINGA_X, MATCH => w_match );

    -- MEM (Scrittura risultati)
    INST_MEM: entity work.Memoria_MEM
        port map ( CLK => CLK, WRITE_EN => w_mem_we, ADDR => w_addr, DATA_IN => w_rom_data, DATA_OUT => open );

    -- FSM (Gestione passi)
    INST_FSM: entity work.Control_Unit
        port map ( CLK => CLK, RST => RST, START => START, READ_STEP => w_read_step, 
                   MATCH => w_match, END_COUNT => w_end_count, CNT_RST => w_cnt_rst, 
                   CNT_EN => w_cnt_en, ROM_EN => w_rom_en, MEM_WE => w_mem_we );
end Structural;