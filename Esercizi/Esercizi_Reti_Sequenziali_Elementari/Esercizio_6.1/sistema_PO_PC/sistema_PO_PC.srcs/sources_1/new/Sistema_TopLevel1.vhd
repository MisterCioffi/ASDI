----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2026 05:45:23 PM
-- Design Name: 
-- Module Name: Sistema_TopLevel - Structural
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

entity Sistema_TopLevel is
    Generic ( ADDR_WIDTH : integer := 4 ); -- 16 locazioni
    Port (
        CLK       : in  std_logic;
        RST       : in  std_logic;
        START     : in  std_logic;
        STRINGA_X : in  std_logic_vector(7 downto 0) -- La stringa da cercare
    );
end Sistema_TopLevel;

architecture Structural of Sistema_TopLevel is

    -- Componenti (Dichiarazioni omesse per brevità, il software le prende in automatico)
    -- FILI INTERNI DI COLLEGAMENTO (Datapath e Controllo)
    signal w_addr      : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal w_rom_data  : std_logic_vector(7 downto 0);
    signal w_match     : std_logic;
    signal w_end_count : std_logic;
    
    signal w_cnt_rst   : std_logic;
    signal w_cnt_en    : std_logic;
    signal w_rom_en    : std_logic;
    signal w_mem_we    : std_logic;

begin

    -- 1. CONTATORE
    INST_CONTATORE: entity work.Contatore_Generic
        generic map ( ADDR_WIDTH => ADDR_WIDTH )
        port map ( CLK => CLK, RST => w_cnt_rst, EN => w_cnt_en, 
                   COUNT => w_addr, END_COUNT => w_end_count );

    -- 2. ROM
    INST_ROM: entity work.Memoria_ROM
        generic map ( ADDR_WIDTH => ADDR_WIDTH )
        port map ( CLK => CLK, READ_EN => w_rom_en, 
                   ADDR => w_addr, DATA_OUT => w_rom_data );

    -- 3. COMPARATORE
    INST_COMP: entity work.Comparatore_8bit
        port map ( IN_A => w_rom_data, IN_B => STRINGA_X, MATCH => w_match );

    -- 4. MEM (RAM)
    INST_MEM: entity work.Memoria_MEM
        generic map ( ADDR_WIDTH => ADDR_WIDTH )
        port map ( CLK => CLK, WRITE_EN => w_mem_we, 
                   ADDR => w_addr, DATA_IN => w_rom_data, DATA_OUT => open );

    -- 5. UNITA' DI CONTROLLO (FSM)
    INST_FSM: entity work.Control_Unit
        port map ( CLK => CLK, RST => RST, START => START, 
                   MATCH => w_match, END_COUNT => w_end_count,
                   CNT_RST => w_cnt_rst, CNT_EN => w_cnt_en, 
                   ROM_EN => w_rom_en, MEM_WE => w_mem_we );

end Structural;