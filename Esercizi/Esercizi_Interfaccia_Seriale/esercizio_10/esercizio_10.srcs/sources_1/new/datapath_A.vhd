----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:56:26
-- Design Name: 
-- Module Name: datapath_A - Behavioral
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

entity datapath_A is
    port(
        clk, rst : in STD_LOGIC;
        read : in STD_LOGIC;
        en_cont : in STD_LOGIC;
        WR : in STD_LOGIC;
        cout16 : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        TXD : out std_logic  	:= '1';
        TBE	: inout std_logic 	:= '1'
    );
end datapath_A;

architecture Structural of datapath_A is

    component ROM_16_8
        port (
            clk : in STD_LOGIC;
            read : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dout : out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    end component;
    
    component cont_16
        port(
            clk, rst : in STD_LOGIC;
            en : in STD_LOGIC;
            y : out STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;
    
    component Rs232RefComp
        port ( 
            TXD 	: out std_logic  	:= '1';
            RXD 	: in  std_logic;					
            CLK 	: in  std_logic;					--Master Clock
            DBIN 	: in  std_logic_vector (7 downto 0);--Data Bus in
            DBOUT : out std_logic_vector (7 downto 0);	--Data Bus out
            RDA	: inout std_logic;						--Read Data Available(1 quando il dato è disponibile nel registro rdReg)
            TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare è stato caricato nello shift register)
            RD		: in  std_logic;					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
            WR		: in  std_logic;					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
            PE		: out std_logic;					--Parity Error Flag
            FE		: out std_logic;					--Frame Error Flag
            OE		: out std_logic;					--Overwrite Error Flag
            RST		: in  std_logic	:= '0');			--Master Reset
    end component;
    
    signal data_rom : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');

begin

    rom: ROM_16_8 port map (
        clk => clk,
        read => read,
        address => cout16,
        dout => data_rom
    );
    
    cont: cont_16 port map (
        clk => clk,
        rst => rst,
        en => en_cont,
        y => cout16
    );
    
    uart_A: Rs232RefComp port map (
        TXD   => TXD,         
        RXD   => '1',         -- Il nodo A non riceve: '1' => (stato di riposo UART)
        CLK   => clk,        
        DBIN  => data_rom,    
        DBOUT => open,        -- Non ci interessa, lasciamo l'uscita scollegata con open
        RDA   => open,        
        TBE   => TBE,         
        RD    => '0',         -- Disabilitiamo il Read Strobe con 0 
        WR    => WR,          
        PE    => open,       
        FE    => open,       
        OE    => open,       
        RST   => rst         
    );
    
end Structural;
    