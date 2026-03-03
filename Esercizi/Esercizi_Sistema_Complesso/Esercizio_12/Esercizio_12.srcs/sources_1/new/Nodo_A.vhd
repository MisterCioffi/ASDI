----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2026 09:50:39
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
        ack : in STD_LOGIC;
        req : out STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Nodo_A;

architecture Structural of Nodo_A is

    component control_unit_A
        port (
            clk, rst, start : in STD_LOGIC;
            ack : in STD_LOGIC;
            req : out STD_LOGIC;
            read : out STD_LOGIC;
            load_temp, load_RA : out STD_LOGIC;
            start_m : out STD_LOGIC;
            en_cont16 : out STD_LOGIC;
            cont16 : in STD_LOGIC_VECTOR(3 downto 0);
            done_m : in STD_LOGIC
        );
    end component;

    component Datapath_A
        port(
            clk, rst : in STD_LOGIC;
            read : in STD_LOGIC;
            load_temp, load_RA : in STD_LOGIC;
            start_m : in STD_LOGIC;
            en_cont16 : in STD_LOGIC;
            cont16 : out STD_LOGIC_VECTOR(3 downto 0);
            done_m : out STD_LOGIC;
            product_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal read_sig, load_temp_sig, load_RA_sig, start_m_sig, en_cont16_sig, done_m_sig : STD_LOGIC;
    signal cont16_sig : STD_LOGIC_VECTOR(3 downto 0);

begin

    UC_A : control_unit_A
        port map (
            clk => clk,
            rst => rst,
            start => start,
            ack => ack,
            req => req,
            read => read_sig,
            load_temp => load_temp_sig,
            load_RA => load_RA_sig,
            start_m => start_m_sig,
            en_cont16 => en_cont16_sig,
            cont16 => cont16_sig,
            done_m => done_m_sig
        );

    UO_A : Datapath_A
        port map (
            clk => clk,
            rst => rst,
            read => read_sig,
            load_temp => load_temp_sig,
            load_RA => load_RA_sig,
            start_m => start_m_sig,
            en_cont16 => en_cont16_sig,
            cont16 => cont16_sig,
            done_m => done_m_sig,
            product_out => data_out
        );

end Structural;
