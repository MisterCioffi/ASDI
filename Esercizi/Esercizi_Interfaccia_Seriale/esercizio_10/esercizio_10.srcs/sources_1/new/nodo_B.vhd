----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:55:14
-- Design Name: 
-- Module Name: nodo_B - Structural
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

entity nodo_B is
    port(
        clk, rst : in STD_LOGIC;
        serial_data : in STD_LOGIC
    );
end nodo_B;

architecture Structural of nodo_B is

    component control_unit_B
        port(
            clk, rst : in STD_LOGIC;
            write, en_cont : out STD_LOGIC;
            RDA	: in STD_LOGIC;
            RD	: out  STD_LOGIC;
            PE	: in STD_LOGIC;
            FE	: in STD_LOGIC;		
            OE	: in STD_LOGIC				
        ); 
    end component;
    
    component datapath_B
        port(
            clk, rst : in STD_LOGIC;
            write, en_cont : in STD_LOGIC;
            RXD : in STD_LOGIC;
            RDA	: inout STD_LOGIC;
            RD	: in  STD_LOGIC;
            PE	: out STD_LOGIC;
            FE	: out STD_LOGIC;		
            OE	: out STD_LOGIC				
        );
    end component;
    
    signal write_en, count_en, rd_en : STD_LOGIC;
    signal RDA_SIGNAL : STD_LOGIC;
    
    signal PE_ERROR, FE_ERROR, OE_ERROR	: STD_LOGIC;

begin

     ucB: control_unit_B port map(
        clk => clk,
        rst => rst,
        write => write_en,
        en_cont => count_en,
        RDA => RDA_SIGNAL,
        RD => rd_en,
        PE => PE_ERROR,
        FE => FE_ERROR,	
        OE => OE_ERROR	
    );

    uoB: datapath_B port map(
        clk => clk,
        rst => rst,
        write => write_en,
        en_cont => count_en,
        RD => rd_en,
        RXD => serial_data,
        RDA => RDA_SIGNAL,
        PE => PE_ERROR,
        FE => FE_ERROR,	
        OE => OE_ERROR
    );

end Structural;
