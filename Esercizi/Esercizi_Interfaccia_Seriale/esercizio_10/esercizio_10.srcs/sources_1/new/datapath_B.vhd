----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2026 11:56:26
-- Design Name: 
-- Module Name: datapath_B - Behavioral
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

entity datapath_B is
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
end datapath_B;

architecture Structural of datapath_B is

    component MEM_16_4
        port(
            clk, write : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            din : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dout : out STD_LOGIC_VECTOR(3 DOWNTO 0)
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
    
    component RCA_4
        port(
            x, y : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            c_in : in STD_LOGIC; 
            c_out : out STD_LOGIC;
            s : out STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;

    signal cont_addr, read_mem : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal string_received : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    
    signal sum_rca : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal carry_out : STD_LOGIC;
    
begin

    uart_B: Rs232RefComp port map (
        TXD   => open,         
        RXD   => RXD,         
        CLK   => clk,        
        DBIN  => (others => '0'),    
        DBOUT => string_received,      
        RDA   => RDA,        
        TBE   => open,         
        RD    => RD,         
        WR    => '0',          
        PE    => PE,       
        FE    => FE,       
        OE    => OE,       
        RST   => rst         
    );
    
    rpc: RCA_4 port map (
        x => string_received(7 DOWNTO 4),
        y => string_received(3 DOWNTO 0),
        c_in => '0',
        c_out => carry_out,
        s => sum_rca
    );

    mem: MEM_16_4 port map (
        clk => clk, 
        write => write,
        address => cont_addr,
        din => sum_rca,
        dout => read_mem
    );
    
    cont: cont_16 port map (
        clk => clk,
        rst => rst,
        en => en_cont,
        y => cont_addr
    );
    
end Structural;
