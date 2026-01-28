library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROM_16_8 is
   Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
          D : out STD_LOGIC_VECTOR (7 downto 0));
end ROM_16_8;

architecture Behavioral of ROM_16_8 is

begin
    process(A)
    begin
         case A is
              when "0000" => D <= "11010101";
              when "0001" => D <= "01101010";
              when "0010" => D <= "11110000";
              when "0011" => D <= "00001111";
              when "0100" => D <= "10101010";
              when "0101" => D <= "01010101";
              when "0110" => D <= "10011001";
              when "0111" => D <= "01100110";
              when "1000" => D <= "11111111";
              when "1001" => D <= "00000000";
              when "1010" => D <= "00110011";
              when "1011" => D <= "11001100";
              when "1100" => D <= "10000001";
              when "1101" => D <= "01111110";
              when "1110" => D <= "01011010";
              when "1111" => D <= "10100101";
              when others => D <= (others => '0');
         end case;
    end process;
    end Behavioral;