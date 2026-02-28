----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2026 09:53:28 AM
-- Design Name: 
-- Module Name: omega_pkg - Behavioral
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

package omega_pkg is
    -- Definizione del singolo messaggio (11 bit totali)
    type t_message is record
        valid   : std_logic;
        src     : std_logic_vector(2 downto 0); -- Nodo 0-7 (che per noi sono 1-8)
        dst     : std_logic_vector(2 downto 0); -- Destinazione
        payload : std_logic_vector(3 downto 0); -- I 4 bit di dati
    end record;
    
    -- Messaggio vuoto di default
    constant MSG_EMPTY : t_message := ('0', "000", "000", "0000");
    
    -- Array per passare gli 8 messaggi e le 8 richieste
    type t_msg_array is array (0 to 7) of t_message;
    type t_req_array is array (0 to 7) of std_logic;
end package omega_pkg;
