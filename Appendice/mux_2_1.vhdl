library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity mux_2_1 is
   port(
       I0 : in std_logic;
       I1 : in std_logic;
       s : in std_logic;
       y: out std_logic
   );
end mux_2_1;

architecture Behavioral of mux_2_1 is
   begin
       y <= I0 when s = '0' else
            I1 when s = '1' else
            '-';
   end Behavioral;