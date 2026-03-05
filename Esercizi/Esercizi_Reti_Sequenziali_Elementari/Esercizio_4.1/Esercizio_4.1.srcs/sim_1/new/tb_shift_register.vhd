----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 09:52:14
-- Design Name: 
-- Module Name: tb_shift_register - Behavioral
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


entity tb_shift_register is
-- Il testbench non ha porte
end tb_shift_register;

architecture Behavioral of tb_shift_register is

    -- Costanti e Segnali
    constant N_bits : integer := 8;
    constant CLK_PERIOD : time := 10 ns;

    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal SEL : std_logic_vector(1 downto 0) := "00";
    signal SI  : std_logic_vector(1 downto 0) := "00";
    signal PO  : std_logic_vector(N_bits-1 downto 0);

begin

    -- Istanza della Unit Under Test (UUT)
    uut: entity work.shift_register_comportamentale
        generic map (
            N => N_bits
        )
        port map (
            CLK => CLK,
            RST => RST,
            SEL => SEL,
            SI  => SI,
            PO  => PO
        );

    -- Processo per la generazione del Clock
    clk_process : process
    begin
        while now < 500 ns loop  -- Limite di simulazione
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Processo di stimolo
    stim_proc: process
    begin		
        -- 1. Reset del sistema
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;

        -- 2. Modalità "00": Shift a Destra di 1 bit
        -- Inseriamo una sequenza di '1'
        SEL <= "00";
        SI  <= "01"; -- Usiamo solo SI(0)
        wait for 40 ns; -- Shiftiamo per 4 colpi di clock

        -- 3. Modalità "01": Shift a Destra di 2 bit
        -- Inseriamo "11" ad ogni colpo
        SEL <= "01";
        SI  <= "11";
        wait for 30 ns;

        -- 4. Modalità "10": Shift a Sinistra di 1 bit
        -- Inseriamo '0' per pulire parzialmente da destra
        SEL <= "10";
        SI  <= "00"; 
        wait for 40 ns;

        -- 5. Modalità "11": Shift a Sinistra di 2 bit
        -- Inseriamo "10" (SI(1)=1, SI(0)=0)
        SEL <= "11";
        SI  <= "10";
        wait for 30 ns;

        -- Fine simulazione
        wait for 50 ns;
        assert false report "Simulazione Terminata" severity note;
        wait;
    end process;

end Behavioral;
