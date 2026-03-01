library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity macchina_M is
    Port ( I : in STD_LOGIC_VECTOR (7 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end macchina_M;

architecture Behavioral of macchina_M is

begin
    process(I)
    begin
        case I is
            when "11010101" => Y <= "0000";
            when "01101010" => Y <= "0001";     
            when "11110000" => Y <= "0010";
            when "00001111" => Y <= "0011";
            when "10101010" => Y <= "0100";
            when "01010101" => Y <= "0101";
            when "10011001" => Y <= "0110";
            when "01100110" => Y <= "0111";
            when "11111111" => Y <= "1000";
            when "00000000" => Y <= "1001";
            when "00110011" => Y <= "1010";
            when "11001100" => Y <= "1011";
            when "10000001" => Y <= "1100";
            when "01111110" => Y <= "1101";
            when "01011010" => Y <= "1110";
            when "10100101" => Y <= "1111";
            when others => Y <= (others => '0');
        end case;
    end process;    
end Behavioral;