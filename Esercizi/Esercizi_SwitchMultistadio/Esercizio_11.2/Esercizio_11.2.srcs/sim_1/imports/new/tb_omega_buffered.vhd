----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2026 03:45:32 PM
-- Design Name: 
-- Module Name: tb_omega_buffered - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.omega_pkg.ALL;

entity tb_omega_buffered is
-- Testbench vuoto
end tb_omega_buffered;

architecture Behavioral of tb_omega_buffered is

    -- Componente DUT (Device Under Test)
    component omega_network_buffered is
        Port ( 
            clk      : in  std_logic;
            rst      : in  std_logic;
            msg_in   : in  t_msg_array;
            wait_out : out t_wait_array;
            msg_out  : out t_msg_array;
            wait_in  : in  t_wait_array
        );
    end component;

    -- Segnali interni
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    
    signal msg_in   : t_msg_array := (others => MSG_EMPTY);
    signal wait_out : t_wait_array;
    signal msg_out  : t_msg_array;
    signal wait_in  : t_wait_array := (others => '0'); -- Di default i ricevitori sono pronti

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Istanziazione della Rete Omega Buffered
    DUT: omega_network_buffered port map (
        clk      => clk,
        rst      => rst,
        msg_in   => msg_in,
        wait_out => wait_out,
        msg_out  => msg_out,
        wait_in  => wait_in
    );

    -- Processo di generazione del Clock
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Processo degli Stimoli
    stimulus : process
    begin
        -- ==========================================
        -- FASE 0: RESET
        -- ==========================================
        rst <= '1';
        wait for CLK_PERIOD * 2;
        rst <= '0';
        wait for CLK_PERIOD;

        -- ==========================================
        -- FASE 1: PACCHETTO SINGOLO (Latenza della Pipeline)
        -- ==========================================
        -- Inviamo un pacchetto dal Nodo 0 al Nodo 7.
        -- Essendo una rete a 3 stadi sincronizzata dal clock, impiegherà 3 colpi di clock per uscire.
        msg_in(0) <= ('1', "000", "111", "1010"); -- Payload 'a'
        
        wait for CLK_PERIOD;
        msg_in(0) <= MSG_EMPTY; -- Togliamo il pacchetto dopo averlo inserito
        
        wait for CLK_PERIOD * 4; -- Aspettiamo che esca dalla rete

        -- ==========================================
        -- FASE 2: CONFLITTO LOCALE E ROUND-ROBIN
        -- ==========================================
        -- Per il Perfect Shuffle, il Nodo 0 e il Nodo 4 entrano nello STESSO switch (Stadio 0, Switch 0).
        -- Li facciamo puntare entrambi a destinazioni che iniziano con '0' (bit 2 = 0).
        -- Si creerà un conflitto sullo Switch 0.
        
        msg_in(0) <= ('1', "000", "001", "1011"); -- Payload 'b' (Dest 1: 001)
        msg_in(4) <= ('1', "100", "010", "1100"); -- Payload 'c' (Dest 2: 010)
        
        wait for CLK_PERIOD;
        msg_in(0) <= MSG_EMPTY;
        msg_in(4) <= MSG_EMPTY;
        
        -- Il primo pacchetto vincerà subito, il secondo resterà in FIFO per un ciclo
        -- e poi riprenderà il viaggio. Usciranno sfasati di 1 ciclo di clock!
        wait for CLK_PERIOD * 5;

        -- ==========================================
        -- FASE 3: BACKPRESSURE E SATURAZIONE BUFFER
        -- ==========================================
        -- 1. Simuliamo che il destinatario Nodo 5 sia bloccato/lento
        wait_in(5) <= '1'; 
        
        -- "Spammiamo" 15 pacchetti dal Nodo 2 verso il Nodo 5
        for i in 1 to 15 loop
            msg_in(2) <= ('1', "010", "101", std_logic_vector(to_unsigned(i, 4))); 
            wait for CLK_PERIOD;
        end loop;
            
        
        msg_in(2) <= MSG_EMPTY;
        
        -- In questo momento, la FIFO dello stadio 2 è piena (4 pacchetti), 
        -- e la FIFO dello stadio 1 sta iniziando a riempirsi. 
        -- Noterai su Vivado che "wait_out(2)" diventerà '1'.
        wait for CLK_PERIOD * 30;
        
        -- 3. Il destinatario si sblocca!
        wait_in(5) <= '0';
        
        -- Ora i pacchetti accumulati nei buffer inizieranno a defluire uno alla volta,
        -- al ritmo di uno per ciclo di clock, verso il Nodo 5.
        wait for CLK_PERIOD * 10;

        -- Fine simulazione
        wait;
    end process;

end Behavioral;
