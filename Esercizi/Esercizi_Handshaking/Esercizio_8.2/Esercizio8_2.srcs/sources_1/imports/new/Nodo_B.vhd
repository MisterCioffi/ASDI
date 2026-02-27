----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:31:21
-- Design Name: 
-- Module Name: Nodo_B - Behavioral
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


entity Nodo_B is
    port(
        clk : in STD_LOGIC;
        okUser : in STD_LOGIC;
        
        ack, done : out STD_LOGIC;
        req : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(7 downto 0);
        
        result_sum : out STD_LOGIC_VECTOR(3 DOWNTO 0); 
        carry_out : out STD_LOGIC
    );
end Nodo_B;

architecture Structural of Nodo_B is
    
    component Datapath_B
        port(
            clk : in  std_logic;
            
            data_in : in std_logic_vector(7 downto 0);
            load_B : in STD_LOGIC;
        
            sum_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            c_out_final : out STD_LOGIC
        );
    end component;
    
    component control_unit_B
       port(
            clk : in STD_LOGIC;
            
            okUser : in STD_LOGIC;
            req : in STD_LOGIC;
            ack, done : out STD_LOGIC;
        
            load_B : out STD_LOGIC
        );
    end component;
    
    signal enable_load_RB : STD_LOGIC;
    
begin
    UO: Datapath_B port map(
        clk => clk,
        data_in => data_in,
        load_B => enable_load_RB,
        sum_out => result_sum,
        c_out_final => carry_out
    );
    
    UC : control_unit_B port map (
        clk => clk, 
        okUser => okUser,
        load_B => enable_load_RB,
        ack => ack,
        done => done,
        req => req
    );

end Structural;
