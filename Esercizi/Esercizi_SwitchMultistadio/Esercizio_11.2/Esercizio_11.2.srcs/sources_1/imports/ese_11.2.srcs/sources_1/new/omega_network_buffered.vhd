library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.omega_pkg.ALL;

entity omega_network_buffered is
    Port ( 
        clk      : in  std_logic;
        rst      : in  std_logic;
        
        -- Ingressi dai Nodi (Dati in avanti)
        msg_in   : in  t_msg_array;
        -- Uscite verso i Nodi (Backpressure all'indietro: "Fermatevi!")
        wait_out : out t_wait_array;
        
        -- Uscite verso le Destinazioni (Dati in avanti)
        msg_out  : out t_msg_array;
        -- Ingressi dalle Destinazioni (Backpressure all'indietro: "Sono pieno!")
        wait_in  : in  t_wait_array
    );
end omega_network_buffered;

architecture Structural of omega_network_buffered is

    -- Il nostro Switch Intelligente
    component switch_2x2_buffered is
        generic ( STAGE_BIT : integer );
        Port ( 
            clk, rst   : in  std_logic;
            in_0       : in  t_message; wait_out_0 : out std_logic;
            in_1       : in  t_message; wait_out_1 : out std_logic;
            out_0      : out t_message; wait_in_0  : in  std_logic;
            out_1      : out t_message; wait_in_1  : in  std_logic
        );
    end component;

    -- ==========================================
    -- CAVI DI INTERCONNESSIONE INTERNI
    -- ==========================================
    -- Dati in ingresso agli stadi
    signal s0_msg_in, s1_msg_in, s2_msg_in : t_msg_array;
    -- Dati in uscita dagli stadi
    signal s0_msg_out, s1_msg_out, s2_msg_out : t_msg_array;
    
    -- Wait in uscita dagli stadi (verso sinistra)
    signal s0_wait_out, s1_wait_out, s2_wait_out : t_wait_array;
    -- Wait in ingresso agli stadi (da destra)
    signal s0_wait_in, s1_wait_in, s2_wait_in : t_wait_array;

begin

    -- ==========================================
    -- CABLAGGIO 1: INGRESSI -> STADIO 0 (Perfect Shuffle)
    -- ==========================================
    -- I Dati vanno da msg_in a s0_msg_in. 
    -- I Wait tornano indietro da s0_wait_out a wait_out.
    s0_msg_in(0) <= msg_in(0);  wait_out(0) <= s0_wait_out(0);
    s0_msg_in(1) <= msg_in(4);  wait_out(4) <= s0_wait_out(1);
    s0_msg_in(2) <= msg_in(1);  wait_out(1) <= s0_wait_out(2);
    s0_msg_in(3) <= msg_in(5);  wait_out(5) <= s0_wait_out(3);
    s0_msg_in(4) <= msg_in(2);  wait_out(2) <= s0_wait_out(4);
    s0_msg_in(5) <= msg_in(6);  wait_out(6) <= s0_wait_out(5);
    s0_msg_in(6) <= msg_in(3);  wait_out(3) <= s0_wait_out(6);
    s0_msg_in(7) <= msg_in(7);  wait_out(7) <= s0_wait_out(7);

    -- ISTANZIAZIONE STADIO 0 (Guarda il MSB dell'indirizzo: bit 2)
    ST0_SW0: switch_2x2_buffered generic map(STAGE_BIT => 2) 
        port map(
            clk => clk, 
            rst => rst, 
            in_0 => s0_msg_in(0), 
            wait_out_0 => s0_wait_out(0), 
            in_1 => s0_msg_in(1), 
            wait_out_1 => s0_wait_out(1), 
            out_0 => s0_msg_out(0), 
            wait_in_0 => s0_wait_in(0), 
            out_1 => s0_msg_out(1), 
            wait_in_1 => s0_wait_in(1)
        );  
    ST0_SW1: switch_2x2_buffered generic map(STAGE_BIT => 2) 
        port map(
            clk => clk, 
            rst => rst,
            in_0 => s0_msg_in(2), 
            wait_out_0 => s0_wait_out(2), 
            in_1 => s0_msg_in(3), 
            wait_out_1 => s0_wait_out(3), 
            out_0 => s0_msg_out(2), 
            wait_in_0 => s0_wait_in(2), 
            out_1 => s0_msg_out(3), 
            wait_in_1 => s0_wait_in(3)
        );
    ST0_SW2: switch_2x2_buffered generic map(STAGE_BIT => 2) 
        port map(
            clk => clk, 
            rst => rst, 
            in_0 => s0_msg_in(4), 
            wait_out_0 => s0_wait_out(4), 
            in_1 => s0_msg_in(5), 
            wait_out_1 => s0_wait_out(5), 
            out_0 => s0_msg_out(4), 
            wait_in_0 => s0_wait_in(4), 
            out_1 => s0_msg_out(5), 
            wait_in_1 => s0_wait_in(5)
        ); 
    ST0_SW3: switch_2x2_buffered generic map(STAGE_BIT => 2) 
        port map(
            clk => clk, 
            rst => rst, 
            in_0 => s0_msg_in(6), 
            wait_out_0 => s0_wait_out(6), 
            in_1 => s0_msg_in(7), 
            wait_out_1 => s0_wait_out(7), 
            out_0 => s0_msg_out(6), 
            wait_in_0 => s0_wait_in(6), 
            out_1 => s0_msg_out(7), 
            wait_in_1 => s0_wait_in(7)
        ); 
    -- ==========================================
    -- CABLAGGIO 2: STADIO 0 -> STADIO 1 (Perfect Shuffle)
    -- ==========================================
    s1_msg_in(0) <= s0_msg_out(0);  s0_wait_in(0) <= s1_wait_out(0);
    s1_msg_in(1) <= s0_msg_out(4);  s0_wait_in(4) <= s1_wait_out(1);
    s1_msg_in(2) <= s0_msg_out(1);  s0_wait_in(1) <= s1_wait_out(2);
    s1_msg_in(3) <= s0_msg_out(5);  s0_wait_in(5) <= s1_wait_out(3);
    s1_msg_in(4) <= s0_msg_out(2);  s0_wait_in(2) <= s1_wait_out(4);
    s1_msg_in(5) <= s0_msg_out(6);  s0_wait_in(6) <= s1_wait_out(5);
    s1_msg_in(6) <= s0_msg_out(3);  s0_wait_in(3) <= s1_wait_out(6);
    s1_msg_in(7) <= s0_msg_out(7);  s0_wait_in(7) <= s1_wait_out(7);

  -- ISTANZIAZIONE STADIO 1 (Guarda il bit centrale: bit 1)
    
    ST1_SW0: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 1
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s1_msg_in(0),
            wait_out_0 => s1_wait_out(0),
            in_1       => s1_msg_in(1),
            wait_out_1 => s1_wait_out(1),
            out_0      => s1_msg_out(0),
            wait_in_0  => s1_wait_in(0),
            out_1      => s1_msg_out(1),
            wait_in_1  => s1_wait_in(1)
        );

    ST1_SW1: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 1
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s1_msg_in(2),
            wait_out_0 => s1_wait_out(2),
            in_1       => s1_msg_in(3),
            wait_out_1 => s1_wait_out(3),
            out_0      => s1_msg_out(2),
            wait_in_0  => s1_wait_in(2),
            out_1      => s1_msg_out(3),
            wait_in_1  => s1_wait_in(3)
        );

    ST1_SW2: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 1
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s1_msg_in(4),
            wait_out_0 => s1_wait_out(4),
            in_1       => s1_msg_in(5),
            wait_out_1 => s1_wait_out(5),
            out_0      => s1_msg_out(4),
            wait_in_0  => s1_wait_in(4),
            out_1      => s1_msg_out(5),
            wait_in_1  => s1_wait_in(5)
        );

    ST1_SW3: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 1
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s1_msg_in(6),
            wait_out_0 => s1_wait_out(6),
            in_1       => s1_msg_in(7),
            wait_out_1 => s1_wait_out(7),
            out_0      => s1_msg_out(6),
            wait_in_0  => s1_wait_in(6),
            out_1      => s1_msg_out(7),
            wait_in_1  => s1_wait_in(7)
        );
    -- ==========================================
    -- CABLAGGIO 3: STADIO 1 -> STADIO 2 (Perfect Shuffle)
    -- ==========================================
    s2_msg_in(0) <= s1_msg_out(0);  s1_wait_in(0) <= s2_wait_out(0);
    s2_msg_in(1) <= s1_msg_out(4);  s1_wait_in(4) <= s2_wait_out(1);
    s2_msg_in(2) <= s1_msg_out(1);  s1_wait_in(1) <= s2_wait_out(2);
    s2_msg_in(3) <= s1_msg_out(5);  s1_wait_in(5) <= s2_wait_out(3);
    s2_msg_in(4) <= s1_msg_out(2);  s1_wait_in(2) <= s2_wait_out(4);
    s2_msg_in(5) <= s1_msg_out(6);  s1_wait_in(6) <= s2_wait_out(5);
    s2_msg_in(6) <= s1_msg_out(3);  s1_wait_in(3) <= s2_wait_out(6);
    s2_msg_in(7) <= s1_msg_out(7);  s1_wait_in(7) <= s2_wait_out(7);

    -- ISTANZIAZIONE STADIO 2 (Guarda il LSB: bit 0)
    
    ST2_SW0: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 0
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s2_msg_in(0),
            wait_out_0 => s2_wait_out(0),
            in_1       => s2_msg_in(1),
            wait_out_1 => s2_wait_out(1),
            out_0      => s2_msg_out(0),
            wait_in_0  => s2_wait_in(0),
            out_1      => s2_msg_out(1),
            wait_in_1  => s2_wait_in(1)
        );

    ST2_SW1: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 0
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s2_msg_in(2),
            wait_out_0 => s2_wait_out(2),
            in_1       => s2_msg_in(3),
            wait_out_1 => s2_wait_out(3),
            out_0      => s2_msg_out(2),
            wait_in_0  => s2_wait_in(2),
            out_1      => s2_msg_out(3),
            wait_in_1  => s2_wait_in(3)
        );

    ST2_SW2: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 0
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s2_msg_in(4),
            wait_out_0 => s2_wait_out(4),
            in_1       => s2_msg_in(5),
            wait_out_1 => s2_wait_out(5),
            out_0      => s2_msg_out(4),
            wait_in_0  => s2_wait_in(4),
            out_1      => s2_msg_out(5),
            wait_in_1  => s2_wait_in(5)
        );

    ST2_SW3: switch_2x2_buffered 
        generic map (
            STAGE_BIT => 0
        ) 
        port map (
            clk        => clk,
            rst        => rst,
            in_0       => s2_msg_in(6),
            wait_out_0 => s2_wait_out(6),
            in_1       => s2_msg_in(7),
            wait_out_1 => s2_wait_out(7),
            out_0      => s2_msg_out(6),
            wait_in_0  => s2_wait_in(6),
            out_1      => s2_msg_out(7),
            wait_in_1  => s2_wait_in(7)
        );
    -- ==========================================
    -- CABLAGGIO 4: USCITE FINALI
    -- ==========================================
    -- I dati escono dalla rete, e i segnali di backpressure finali 
    -- entrano dall'esterno (es. se un nodo ricevitore è troppo lento).
    msg_out    <= s2_msg_out;
    s2_wait_in <= wait_in;

end Structural;