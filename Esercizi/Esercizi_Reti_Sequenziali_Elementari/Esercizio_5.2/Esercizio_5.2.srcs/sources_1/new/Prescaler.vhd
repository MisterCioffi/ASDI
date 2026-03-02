library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Prescaler is
    Generic ( CLOCK_FREQ : integer := 4 ); -- Valore di default basso per simulazione
    Port ( 
        clk_in   : in  std_logic;
        reset    : in  std_logic;
        pulse_1s : out std_logic
    );
end Prescaler;

architecture Behavioral of Prescaler is
    -- Contiamo fino a metà del periodo
    signal count : integer range 0 to CLOCK_FREQ;
    -- Usiamo un segnale interno per mantenere lo stato alto/basso
    signal clock_lento : std_logic := '0';
begin

    process(clk_in, reset)
    begin
        if reset = '1' then
            count <= 0;
            clock_lento <= '0';
        elsif rising_edge(clk_in) then
            -- Se abbiamo contato metà dei cicli necessari...
            if count >= (CLOCK_FREQ / 2) - 1 then
                clock_lento <= not clock_lento; -- INVERTIAMO LO STATO (Toggle)
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    -- Assegniamo il segnale interno all'uscita
    pulse_1s <= clock_lento;

end Behavioral;