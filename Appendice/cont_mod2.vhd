library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cont_mod2 is
    Port(
        clk : in std_logic;
        rst : in std_logic;
        Y : out std_logic
    );
end cont_mod2;

architecture Behavioral of cont_mod2 is
signal Y_reg: std_logic := '0';

begin
    ff_process: process(clk, rst)
    begin
        if rst = '1' then
            Y_reg <= '0'; -- Reset the output to 0
        elsif (clk'event and clk = '0') then
            Y_reg <= not Y_reg; -- Toggle the output on each clock cycle
        end if;
    end process;

    Y <= Y_reg;

end Behavioral;
