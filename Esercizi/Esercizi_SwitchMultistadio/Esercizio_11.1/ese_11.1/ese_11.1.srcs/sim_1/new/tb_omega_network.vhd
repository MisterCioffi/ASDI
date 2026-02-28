----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2026 10:01:21 AM
-- Design Name: 
-- Module Name: tb_omega_network - Behavioral
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
use work.omega_pkg.ALL; -- Assicurati che il package sia compilato!

entity tb_omega_network is
-- Il testbench non ha porte di ingresso o uscita
end tb_omega_network;

architecture Behavioral of tb_omega_network is

    -- 1. Componente da testare (Il nostro Top-Level)
    component omega_network is
        Port ( 
            clk     : in std_logic;
            rst     : in std_logic;
            req_in  : in t_req_array;
            msg_in  : in t_msg_array;
            msg_out : out t_msg_array
        );
    end component;

    -- 2. Segnali interni per collegare il componente
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal req_in  : t_req_array := (others => '0');
    signal msg_in  : t_msg_array := (others => MSG_EMPTY);
    signal msg_out : t_msg_array;

    -- Costante per il periodo del clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. Istanziazione della Rete Omega (Device Under Test)
    DUT: omega_network
        port map (
            clk     => clk,
            rst     => rst,
            req_in  => req_in,
            msg_in  => msg_in,
            msg_out => msg_out
        );

    -- 4. Generazione del Clock (Onda quadra continua)
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. PROCESSO DI STIMOLO (La simulazione vera e propria)
    -- 5. PROCESSO DI STIMOLO (Simulazione estesa e approfondita)
    stimulus_process : process
    begin
        -- ==========================================
        -- FASE 1: RESET (Inizializzazione)
        -- ==========================================
        rst <= '1';
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;
        -- Da questo momento la priorità massima è sul Nodo 1 (indice 0)
        
        -- ==========================================
        -- FASE 2: SCENARIO DELLA TRACCIA (Conflitto Nodo 1 e Nodo 3)
        -- ==========================================
        -- Nodo 1 (idx 0) vs Nodo 3 (idx 2).
        -- Coda della priorità: 1,2,3,4,5,6,7,8 (indice 0,1,2,3,4,5,6,7)
        
        req_in(0) <= '1';
        msg_in(0).valid   <= '1';
        msg_in(0).src     <= "000"; 
        msg_in(0).dst     <= "100"; -- Dest: Nodo 5 
        msg_in(0).payload <= "1010"; -- Payload 'a'
        
        req_in(2) <= '1';
        msg_in(2).valid   <= '1';
        msg_in(2).src     <= "010"; 
        msg_in(2).dst     <= "111"; -- Dest: Nodo 8
        msg_in(2).payload <= "1100"; -- Payload 'c'
        
        wait for CLK_PERIOD * 2;
        -- RISULTATO ATTESO: Vince Nodo 1. msg_out(4) mostra 'a'.
        -- La priorità scala al Nodo 2 (indice 1).
        req_in(0) <= '0';
        msg_in(0) <= MSG_EMPTY;
        
        wait for CLK_PERIOD * 2;
        -- RISULTATO ATTESO: Ora tocca al Nodo 3. msg_out(7) mostra 'c'.
        -- La priorità scala al Nodo 4 (indice 3).
        req_in(2) <= '0';
        msg_in(2) <= MSG_EMPTY;
        
        -- Pausa di inattività per testare la stabilità
        wait for CLK_PERIOD * 2;


        -- ==========================================
        -- FASE 3: RICHIESTA ISOLATA (Nodo 5)
        -- ==========================================
        -- Coda della priorità: 2,4,5,6,7,8,1,3 (indice 1,3,4,5,6,7,0,3)
        
        req_in(4) <= '1';
        msg_in(4).valid   <= '1';
        msg_in(4).src     <= "100"; -- Nodo 5
        msg_in(4).dst     <= "001"; -- Dest: Nodo 2
        msg_in(4).payload <= "1011"; -- Payload 'b'
        
        wait for CLK_PERIOD * 2;
        -- RISULTATO ATTESO: Vince Nodo 5. msg_out(1) mostra 'b'.
        -- La priorità scala al Nodo 6 (indice 5).
        req_in(4) <= '0';
        msg_in(4) <= MSG_EMPTY;

        wait for CLK_PERIOD * 2;

        -- ==========================================
        -- FASE 4: CONFLITTO CON WRAP-AROUND (Nodo 8 e Nodo 2)
        -- ==========================================
        -- Coda della priorità: 2,4,5,6,7,8,1,3 (indice 1,3,4,5,6,7,0,3)
        -- Chiedono Nodo 8 (indice 7) e Nodo 2 (indice 1) --> vince il nodo 2.
        
        req_in(7) <= '1';
        msg_in(7).valid   <= '1';
        msg_in(7).src     <= "111"; -- Nodo 8
        msg_in(7).dst     <= "011"; -- Dest: Nodo 4
        msg_in(7).payload <= "1111"; -- Payload 'f'
        
        req_in(1) <= '1';
        msg_in(1).valid   <= '1';
        msg_in(1).src     <= "001"; -- Nodo 2
        msg_in(1).dst     <= "110"; -- Dest: Nodo 7
        msg_in(1).payload <= "0010"; -- Payload '2'
        
        wait for CLK_PERIOD * 2;
        -- Vince Nodo 2! msg_out(3) mostra '2'.
        req_in(7) <= '0';
        msg_in(7) <= MSG_EMPTY;
        
        wait for CLK_PERIOD * 2;
        -- Vince Nodo 8! msg_out(6) mostra 'f'.
        req_in(1) <= '0';
        msg_in(1) <= MSG_EMPTY;

        -- ==========================================
        -- FINE SIMULAZIONE
        -- ==========================================
        wait for CLK_PERIOD * 2;
        wait;
    end process;

end Behavioral;