----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2026 16:26:38
-- Design Name: 
-- Module Name: shift_register - Behavioral
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

entity shift_register is
    generic (X : integer := 4);
    port(
        din : in STD_LOGIC;
        s, Y : in STD_LOGIC;
        clk, rst : in STD_LOGIC;
        qout : out STD_LOGIC
    );
end shift_register;

-- Architettura comortamentale
architecture Behavioral of shift_register is
    signal temp : STD_LOGIC_VECTOR(X-1 DOWNTO 0);
begin
    sr : process(clk, rst)
    begin
        if (rst = '1') then
            temp <= (others => '0');
        elsif (rising_edge(clk)) then
            
            if (s = '1') then 
                if (Y = '0') then
                    temp <= temp(X-2 DOWNTO 0) & din;
                else 
                    temp <= temp(X-3 DOWNTO 0) & din & din;
                end if;
            else 
                if (Y = '0') then
                    temp <= din & temp(X-1 DOWNTO 1);
                else 
                    temp <= din & din & temp(X-1 DOWNTO 2);
                end if;
            end if;
        end if;
    end process;
    
    qout <= temp(X-1);

end Behavioral;

-- Architettura Strutturale
architecture Structural of shift_register is
    
    component ffD 
        port(
            D : in STD_LOGIC;
            clk, rst : in STD_LOGIC;
            Qd : out STD_LOGIC
        );
    end component;
    
    component mux_4_1
        port(
            b0, b1, b2, b3 : in STD_LOGIC;
            s0, s1 : in STD_LOGIC;
            y0 : out STD_LOGIC
        );
    end component;
    
    signal u : STD_LOGIC_VECTOR(X-1 DOWNTO 0); --collegamenti della coppia mux-ff
    
begin
    
    ff_generate: for i in 0 to X-1 generate
        
        signal mux_to_ff : STD_LOGIC;
        signal sx_1, sx_2, dx_1, dx_2 : STD_LOGIC;
        
        begin
        
        sx_1 <= u(i-1) when i > 0 else din;
        sx_2 <= u(i-2) when i > 1 else din;
        dx_1 <= u(i+1) when i < X-1 else din;
        dx_2 <= u(i+2) when i < X-2 else din;
        
        mux_i : mux_4_1 port map(
            b0 => dx_1,       -- shift di un elemento a sinistra
            b1 => dx_2,       -- shift di due elementi a sinistra
            b2 => sx_1,       -- shift di un elemento a destra
            b3 => sx_2,       -- shift di due elementi a destra
            s0 => y,
            s1 => s,
            y0 => mux_to_ff
        );
        
        ff : ffD port map(
            D => mux_to_ff,
            clk => clk,
            rst => rst,
            Qd => u(i)
        );
    
    end generate;
        
    qout <= u(X-1);

end Structural;
