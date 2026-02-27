----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2026 17:31:21
-- Design Name: 
-- Module Name: Sistema - Behavioral
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

entity Sistema is
    port(
        clk, rst : in STD_LOGIC;
        start : in STD_LOGIC;
        okUser : in STD_LOGIC;
        
        sum_final : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        carry_final : out STD_LOGIC
    );
end Sistema;

architecture Structural of Sistema is
    
    component Nodo_A
        port(
            clk, rst : in STD_LOGIC;
            start : in STD_LOGIC;
            
            ack, done : in STD_LOGIC;
            req : out STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    component Nodo_B
        port(
            clk : in STD_LOGIC;
            okUser : in STD_LOGIC;
            
            ack, done : out STD_LOGIC;
            req : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR(7 downto 0);
            
            result_sum : out STD_LOGIC_VECTOR(3 DOWNTO 0); 
            carry_out : out STD_LOGIC
        );
    end component;
    
    signal acknowledge, request, done : STD_LOGIC;
    signal data_bus : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    A: Nodo_A port map(
        clk => clk, 
        rst => rst,
        start => start,
        
        ack => acknowledge,
        done => done,
        req => request,
        data_out => data_bus
    );
    
    B : Nodo_B port map(
        clk => clk,
        okUser => okUser,
        
        ack => acknowledge,
        done => done,
        req => request,
        data_in => data_bus,
        
        result_sum => sum_final,
        carry_out => carry_final
    );

end Structural;
