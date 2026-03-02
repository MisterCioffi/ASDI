library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cont_mod2_load is
    Port ( 
        clk   : in std_logic;
        rst   : in std_logic;
        load  : in std_logic; -- SEGNALE DI ABILITAZIONE CARICAMENTO
        d_in  : in std_logic; -- IL DATO DA CARICARE (0 o 1)
        Y     : out std_logic
    );
end cont_mod2_load;

architecture Behavioral of cont_mod2_load is
    signal Y_reg : std_logic := '0';
begin
    
    -- Processo con sensibilità a CLK, RST e LOAD
    process(clk, rst, load, d_in)
    begin
        -- Priorità 1: RESET (Azzera tutto)
        if rst = '1' then
            Y_reg <= '0';
            
        -- Priorità 2: LOAD (Imposta il valore desiderato)
        -- Funziona anche senza clock (Asincrono)
        elsif load = '1' then
            Y_reg <= d_in; 
            
        -- Priorità 3: CLOCK (Funzionamento normale da contatore)
        elsif (clk'event and clk = '0') then
            Y_reg <= not Y_reg; -- Toggle
        end if;
    end process;

    Y <= Y_reg;

end Behavioral;