----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2026 03:41:33 PM
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
        src     : std_logic_vector(2 downto 0); 
        dst     : std_logic_vector(2 downto 0); 
        payload : std_logic_vector(3 downto 0); 
    end record;
    
    -- Messaggio vuoto di default
    constant MSG_EMPTY : t_message := ('0', "000", "000", "0000");
    
    -- Array per passare gli 8 messaggi fra gli stadi
    type t_msg_array is array (0 to 7) of t_message;
    
    -- Array per i segnali di WAIT (backpressure)
    type t_wait_array is array (0 to 7) of std_logic;
end package omega_pkg;