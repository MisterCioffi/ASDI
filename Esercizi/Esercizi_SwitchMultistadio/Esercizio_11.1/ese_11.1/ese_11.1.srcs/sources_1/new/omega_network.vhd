library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.omega_pkg.ALL; -- Importiamo i nostri tipi (t_message, ecc.)

entity omega_network is
    Port ( 
        clk     : in std_logic;
        rst     : in std_logic;
        
        -- Ingressi dai 8 Nodi (Richieste e Dati)
        req_in  : in t_req_array;
        msg_in  : in t_msg_array;
        
        -- Uscite verso i Nodi
        msg_out : out t_msg_array
    );
end omega_network;

architecture Structural of omega_network is

    -- Componente: Arbitro Globale
    component global_arbiter is
        Port ( clk   : in std_logic;
               rst   : in std_logic;
               req_i : in t_req_array;
               gnt_o : out t_req_array);
    end component;

    -- Componente: Switch Elementare
    component switch_2x2 is
        generic ( STAGE_BIT : integer );
        Port ( in_0  : in t_message;
               in_1  : in t_message;
               out_0 : out t_message;
               out_1 : out t_message);
    end component;

    -- Segnali interni
    signal grants         : t_req_array;
    signal filtered_msg   : t_msg_array;
    
    -- Cavi di connessione tra gli stadi
    signal stage0_in  : t_msg_array;
    signal stage0_out : t_msg_array;
    signal stage1_in  : t_msg_array;
    signal stage1_out : t_msg_array;
    signal stage2_in  : t_msg_array;
    signal stage2_out : t_msg_array;

begin

    -- 1. ISTANZIAZIONE DELL'ARBITRO
    arbiter_inst : global_arbiter
        port map (
            clk   => clk,
            rst   => rst,
            req_i => req_in,
            gnt_o => grants
        );

    -- 2. FILTRAGGIO INGRESSI (Solo chi ha il GRANT passa, gli altri diventano vuoti)
    process(msg_in, grants)
    begin
        for i in 0 to 7 loop
            if grants(i) = '1' then
                filtered_msg(i) <= msg_in(i);
            else
                filtered_msg(i) <= MSG_EMPTY;
            end if;
        end loop;
    end process;

    -- 3. CABLAGGIO PERFECT SHUFFLE: Ingresso -> Stadio 0
    -- Segue rigorosamente la regola matematica dello shuffle
    stage0_in(0) <= filtered_msg(0);
    stage0_in(1) <= filtered_msg(4);
    stage0_in(2) <= filtered_msg(1);
    stage0_in(3) <= filtered_msg(5);
    stage0_in(4) <= filtered_msg(2);
    stage0_in(5) <= filtered_msg(6);
    stage0_in(6) <= filtered_msg(3);
    stage0_in(7) <= filtered_msg(7);

    -- 4. ISTANZIAZIONE STADIO 0 (Guarda il MSB: bit 2)
    ST0_SW0: switch_2x2 generic map(STAGE_BIT => 2) port map(stage0_in(0), stage0_in(1), stage0_out(0), stage0_out(1));
    ST0_SW1: switch_2x2 generic map(STAGE_BIT => 2) port map(stage0_in(2), stage0_in(3), stage0_out(2), stage0_out(3));
    ST0_SW2: switch_2x2 generic map(STAGE_BIT => 2) port map(stage0_in(4), stage0_in(5), stage0_out(4), stage0_out(5));
    ST0_SW3: switch_2x2 generic map(STAGE_BIT => 2) port map(stage0_in(6), stage0_in(7), stage0_out(6), stage0_out(7));

    -- 5. CABLAGGIO PERFECT SHUFFLE: Stadio 0 -> Stadio 1
    stage1_in(0) <= stage0_out(0);
    stage1_in(1) <= stage0_out(4);
    stage1_in(2) <= stage0_out(1);
    stage1_in(3) <= stage0_out(5);
    stage1_in(4) <= stage0_out(2);
    stage1_in(5) <= stage0_out(6);
    stage1_in(6) <= stage0_out(3);
    stage1_in(7) <= stage0_out(7);

    -- 6. ISTANZIAZIONE STADIO 1 (Guarda il bit centrale: bit 1)
    ST1_SW0: switch_2x2 generic map(STAGE_BIT => 1) port map(stage1_in(0), stage1_in(1), stage1_out(0), stage1_out(1));
    ST1_SW1: switch_2x2 generic map(STAGE_BIT => 1) port map(stage1_in(2), stage1_in(3), stage1_out(2), stage1_out(3));
    ST1_SW2: switch_2x2 generic map(STAGE_BIT => 1) port map(stage1_in(4), stage1_in(5), stage1_out(4), stage1_out(5));
    ST1_SW3: switch_2x2 generic map(STAGE_BIT => 1) port map(stage1_in(6), stage1_in(7), stage1_out(6), stage1_out(7));

    -- 7. CABLAGGIO PERFECT SHUFFLE: Stadio 1 -> Stadio 2
    stage2_in(0) <= stage1_out(0);
    stage2_in(1) <= stage1_out(4);
    stage2_in(2) <= stage1_out(1);
    stage2_in(3) <= stage1_out(5);
    stage2_in(4) <= stage1_out(2);
    stage2_in(5) <= stage1_out(6);
    stage2_in(6) <= stage1_out(3);
    stage2_in(7) <= stage1_out(7);

    -- 8. ISTANZIAZIONE STADIO 2 (Guarda il LSB: bit 0)
    ST2_SW0: switch_2x2 generic map(STAGE_BIT => 0) port map(stage2_in(0), stage2_in(1), msg_out(0), msg_out(1));
    ST2_SW1: switch_2x2 generic map(STAGE_BIT => 0) port map(stage2_in(2), stage2_in(3), msg_out(2), msg_out(3));
    ST2_SW2: switch_2x2 generic map(STAGE_BIT => 0) port map(stage2_in(4), stage2_in(5), msg_out(4), msg_out(5));
    ST2_SW3: switch_2x2 generic map(STAGE_BIT => 0) port map(stage2_in(6), stage2_in(7), msg_out(6), msg_out(7));

end Structural;