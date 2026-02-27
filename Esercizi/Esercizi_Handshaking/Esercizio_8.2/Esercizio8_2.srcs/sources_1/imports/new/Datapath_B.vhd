----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:29:29
-- Design Name: 
-- Module Name: Datapath_B - Behavioral
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

entity Datapath_B is
    port(
        clk : in STD_LOGIC;
        
        data_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        load_B : in STD_LOGIC;
        
        sum_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        c_out_final : out STD_LOGIC
    );
end Datapath_B;

architecture Structural of Datapath_B is
    
    component RCA_4
        port(
            x, y : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            c_in : in STD_LOGIC; 
            c_out : out STD_LOGIC;
            s : out STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;
    
    signal data_register_B : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
begin

    load_register_B: process(clk)
    begin 
        if rising_edge(clk) then
            if load_B = '1' then
                data_register_B <= data_in;
            end if;
        end if;
    end process;
        
    rca: RCA_4 port map (
        x => data_register_B(7 DOWNTO 4),
        y => data_register_B(3 DOWNTO 0),
        c_in => '0',
        c_out => c_out_final,
        s => sum_out
    );

end Structural;
