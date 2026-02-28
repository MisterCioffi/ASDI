library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.omega_pkg.all;

entity global_arbiter is
    Port ( clk   : in std_logic;
           rst   : in std_logic;
           req_i : in t_req_array;
           gnt_o : out t_req_array);
end global_arbiter;

architecture Behavioral of global_arbiter is
    -- La nostra coda delle priorità (indici da 0 a 7)
    type t_prio_queue is array (0 to 7) of integer range 0 to 7;
    signal queue : t_prio_queue;
begin
    process(clk, rst)
        variable v_winner_found : boolean;
        variable v_winner_node  : integer;
        variable v_winner_idx   : integer;
    begin
        if rst = '1' then
            -- Inizializza la priorità: 0, 1, 2, 3, 4, 5, 6, 7
            for i in 0 to 7 loop
                queue(i) <= i;
            end loop;
            gnt_o <= (others => '0');
            
        elsif rising_edge(clk) then
            gnt_o <= (others => '0'); -- Resetta i grant di default
            v_winner_found := false;
            
            -- 1. FASE DI ARBITRAGGIO: Scorri la coda da sinistra (priorità max) a destra
            for i in 0 to 7 loop
                if not v_winner_found then
                    if req_i(queue(i)) = '1' then
                        v_winner_found := true;
                        v_winner_idx   := i;
                        v_winner_node  := queue(i);
                        gnt_o(v_winner_node) <= '1'; -- Assegna il permesso!
                    end if;
                end if;
            end loop;
            
            -- 2. FASE DI AGGIORNAMENTO CODA (Il tuo scorrimento dinamico)
            if v_winner_found then
                for j in 0 to 6 loop
                    if j < v_winner_idx then
                        -- Chi sta prima del vincitore resta fermo
                        queue(j) <= queue(j); 
                    else
                        -- Chi sta dopo fa un passo avanti (scorre a sinistra)
                        queue(j) <= queue(j+1); 
                    end if;
                end loop;
                -- Il vincitore finisce in fondo (priorità minima)
                queue(7) <= v_winner_node; 
            end if;
        end if;
    end process;
end Behavioral;