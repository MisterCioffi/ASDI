----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 10:44:29 AM
-- Design Name: 
-- Module Name: MoltBooth8bit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity MoltBooth8bit is
    Port (
        clk      : in  STD_LOGIC;
        reset_n  : in  STD_LOGIC; -- Reset attivo basso
        avvio    : in  STD_LOGIC; -- Segnale di START
        dato_X   : in  STD_LOGIC_VECTOR(7 downto 0); -- Moltiplicando (M)
        dato_Y   : in  STD_LOGIC_VECTOR(7 downto 0); -- Moltiplicatore (Q)
        risultato: out STD_LOGIC_VECTOR(15 downto 0);
        fatto    : out STD_LOGIC -- Segnale di DONE
    );
end MoltBooth8bit;

architecture RTL of MoltBooth8bit is
    type stato_fsm is (IDLE, ANALISI, SPOSTAMENTO, FINE);
    signal stato_corr : stato_fsm;
    
    -- Registri interni come da slide
    signal reg_A    : signed(7 downto 0);       -- Accumulatore
    signal reg_Q    : std_logic_vector(7 downto 0); -- Moltiplicatore
    signal reg_M    : signed(7 downto 0);       -- Moltiplicando
    signal bit_Q_m1 : std_logic;                -- Bit ausiliario Q[-1]
    signal contatore: unsigned(2 downto 0);     -- Conta gli 8 cicli
begin

    process(clk, reset_n)
    begin
    if reset_n = '0' then
                stato_corr <= IDLE;
                fatto <= '0';
                reg_A <= (others => '0');
                bit_Q_m1 <= '0';
                risultato <= (others => '0');
        elsif rising_edge(clk) then
            case stato_corr is
                
                when IDLE =>
                    fatto <= '0';
                    if avvio = '1' then
                        reg_A <= (others => '0'); -- A := 0
                        reg_M <= signed(dato_X);  -- M := INBUS
                        reg_Q <= dato_Y;          -- Q := INBUS
                        bit_Q_m1 <= '0';          -- Q[-1] := 0
                        contatore <= "000";
                        stato_corr <= ANALISI;
                    end if;

                when ANALISI =>
                    -- Logica basata sulle coppie di bit x_j, x_{j-1}
                    if reg_Q(0) = '0' and bit_Q_m1 = '1' then
                        reg_A <= reg_A + reg_M; -- Caso 01: somma
                    elsif reg_Q(0) = '1' and bit_Q_m1 = '0' then
                        reg_A <= reg_A - reg_M; -- Caso 10: sottrazione
                    end if;
                    stato_corr <= SPOSTAMENTO;

                when SPOSTAMENTO =>
                    -- Arithmetic Shift Right (ASR) combinato
                    -- Preserva il bit di segno A[7]
                    reg_A <= reg_A(7) & reg_A(7 downto 1);
                    reg_Q <= reg_A(0) & reg_Q(7 downto 1);
                    bit_Q_m1 <= reg_Q(0);
                    
                    if contatore = 7 then
                        stato_corr <= FINE;
                    else
                        contatore <= contatore + 1;
                        stato_corr <= ANALISI;
                    end if;

                when FINE =>
                    fatto <= '1';
                    risultato <= std_logic_vector(reg_A) & reg_Q; -- Risultato A & Q
                    stato_corr <= IDLE;

            end case;
        end if;
    end process;

end RTL;
