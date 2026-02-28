library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.omega_pkg.ALL;

entity switch_2x2 is
    generic (
        STAGE_BIT : integer -- Quale bit dell'indirizzo guardare (2, 1, o 0)
    );
    Port ( in_0  : in t_message;
           in_1  : in t_message;
           out_0 : out t_message;
           out_1 : out t_message);
end switch_2x2;

architecture Combinational of switch_2x2 is
begin
    process(in_0, in_1)
    begin
        -- Default: uscite vuote
        out_0 <= MSG_EMPTY;
        out_1 <= MSG_EMPTY;
        
        -- Instradamento IN_0
        if in_0.valid = '1' then
            if in_0.dst(STAGE_BIT) = '0' then
                out_0 <= in_0;
            else
                out_1 <= in_0;
            end if;
        end if;
        
        -- Instradamento IN_1
        if in_1.valid = '1' then
            if in_1.dst(STAGE_BIT) = '0' then
                out_0 <= in_1;
            else
                out_1 <= in_1;
            end if;
        end if;
    end process;
end Combinational;