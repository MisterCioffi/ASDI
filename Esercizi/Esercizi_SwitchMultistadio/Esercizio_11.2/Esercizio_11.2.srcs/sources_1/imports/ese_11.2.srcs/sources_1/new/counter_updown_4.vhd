library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_updown_4 is
    Port ( 
        clk   : in  std_logic;
        rst   : in  std_logic;
        up    : in  std_logic; -- Incrementa di 1 (es. quando faccio push)
        down  : in  std_logic; -- Decrementa di 1 (es. quando faccio pop)
        count : out integer range 0 to 4
    );
end counter_updown_4;

architecture Behavioral of counter_updown_4 is
    signal val : integer range 0 to 4 := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            val <= 0;
        elsif rising_edge(clk) then
            -- Se faccio push ma non pop (e non sono pieno)
            if up = '1' and down = '0' and val < 4 then
                val <= val + 1;
            -- Se faccio pop ma non push (e non sono vuoto)
            elsif up = '0' and down = '1' and val > 0 then
                val <= val - 1;
            end if;
            -- Nota: Se up='1' e down='1' simultaneamente, scrivo e leggo 
            -- nello stesso colpo di clock, quindi la quantità totale non cambia!
        end if;
    end process;
    
    count <= val;
end Behavioral;