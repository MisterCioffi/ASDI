----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
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
    port (
        clk, rst : in STD_LOGIC;
        req : in STD_LOGIC;
        ack : out STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(7 downto 0)
    );
end Nodo_B;

architecture Structural of Nodo_B is

    component control_unit_B
        port (
            clk, rst : in STD_LOGIC;
            req : in STD_LOGIC;
            ack : out STD_LOGIC;
            write : out STD_LOGIC;
            load_RB : out STD_LOGIC;
            en_cont8 : out STD_LOGIC;
            alpha, beta : in STD_LOGIC;
            cont8 : in STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component Datapath_B
        port(
            clk, rst : in STD_LOGIC;
            write : in STD_LOGIC;
            load_RB : in STD_LOGIC;
            en_cont8 : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR(7 downto 0);
            alpha, beta : out STD_LOGIC;
            cont8 : inout STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    signal write_sig, load_RB_sig, en_cont8_sig : STD_LOGIC;
    signal alpha_sig, beta_sig : STD_LOGIC;
    signal cont8_sig : STD_LOGIC_VECTOR(2 downto 0);

begin

    CU_B : control_unit_B
        port map (
            clk => clk,
            rst => rst,
            req => req,
            ack => ack,
            write => write_sig,
            load_RB => load_RB_sig,
            en_cont8 => en_cont8_sig,
            alpha => alpha_sig,
            beta => beta_sig,
            cont8 => cont8_sig
        );

    DP_B : Datapath_B
        port map (
            clk => clk,
            rst => rst,
            write => write_sig,
            load_RB => load_RB_sig,
            en_cont8 => en_cont8_sig,
            data_in => data_in,
            alpha => alpha_sig,
            beta => beta_sig,
            cont8 => cont8_sig
        );
        
end Structural;
