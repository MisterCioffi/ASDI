----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:31:21
-- Design Name: 
-- Module Name: Nodo_A - Behavioral
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

entity Nodo_A is
    port(
        clk, rst : in STD_LOGIC;
        start : in STD_LOGIC;
        
        ack, done : in STD_LOGIC;
        req : out STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Nodo_A;

architecture Structural of Nodo_A is
    
    component Datapath_A
        port(
            clk : in  std_logic;
            
            cnt_en, cnt_rst : in  std_logic;
            read_en : in  std_logic;
            load_A : in  std_logic;
            
            end_cnt  : out std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component control_unit_A
       port(
            clk, rst : in STD_LOGIC;
            start : in STD_LOGIC;
            
            end_cnt : in STD_LOGIC;
            cnt_en, cnt_rst : out STD_LOGIC;
            read_en : out STD_LOGIC;
            load_A : out STD_LOGIC;
            
            ack, done : in STD_LOGIC;
            req : out STD_LOGIC
        );
    end component;
    
    signal enable_count, enable_read, enable_load_RA : STD_LOGIC;
    signal count_reset, end_count : STD_LOGIC;
    
begin
    UO: Datapath_A port map(
        clk => clk,
        cnt_en => enable_count,
        cnt_rst => count_reset,
        read_en => enable_read,
        load_A => enable_load_RA,
        end_cnt  => end_count,
        data_out => data_out
    );
        
        
    UC : control_unit_A port map (
        clk => clk, 
        rst => rst,
        start => start,
        end_cnt => end_count,
        cnt_en => enable_count, 
        cnt_rst => count_reset,
        read_en => enable_read,
        load_A => enable_load_RA,
        ack => ack,
        done => done,
        req => req
    );

end Structural;
