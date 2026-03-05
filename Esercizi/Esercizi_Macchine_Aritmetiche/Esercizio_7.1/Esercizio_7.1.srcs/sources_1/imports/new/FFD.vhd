library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FFD is
    port( 
        clock  : in std_logic;
        reset  : in std_logic;
        enable : in std_logic;
        d      : in std_logic;
        y      : out std_logic
    );
end FFD;

architecture Behavioral of FFD is
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                y <= '0';            -- Il reset ha la priorità assoluta
            elsif enable = '1' then
                y <= d;              -- Cattura il dato SOLO se enable è alto
            end if;
            -- Se enable è '0', il processo termina senza assegnazioni, 
            -- mantenendo implicitamente memorizzato il vecchio valore di y.
        end if;
    end process;
end Behavioral;