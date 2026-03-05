----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 09:51:02
-- Design Name: 
-- Module Name: shift_register_comportamentale - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity shift_register_comportamentale is
    generic (
        N : integer := 8  -- Dimensione registro
    );
    port (
        CLK, RST : in std_logic;
        SEL      : in std_logic_vector(1 downto 0);
        SI       : in std_logic_vector(1 downto 0); -- Ingresso "vettoriale"
        PO       : out std_logic_vector(N-1 downto 0)
    );
end shift_register_comportamentale;

architecture Behavioral of shift_register_comportamentale is
    signal tmp : std_logic_vector(N-1 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                tmp <= (others => '0');
            else
                case SEL is
                    when "00" => -- Destra, Y=1
                        -- Usiamo solo un bit di SI
                        tmp <= SI(0) & tmp(N-1 downto 1);
                        
                    when "01" => -- Destra, Y=2
                        -- Usiamo entrambi i bit di SI!
                        tmp <= SI & tmp(N-1 downto 2);
                        
                    when "10" => -- Sinistra, Y=1
                        tmp <= tmp(N-2 downto 0) & SI(0);
                        
                    when "11" => -- Sinistra, Y=2
                        tmp <= tmp(N-3 downto 0) & SI;
                        
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    PO <= tmp;
end Behavioral;
