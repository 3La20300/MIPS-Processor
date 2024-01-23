library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    Port ( address : in STD_LOGIC_VECTOR(3 downto 0);
    data_in : in STD_LOGIC_VECTOR(15 downto 0);
    ce : in STD_LOGIC;
    re : in STD_LOGIC :='0';
    we : in STD_LOGIC :='0';
    data_out : inout STD_LOGIC_VECTOR(15 downto 0)
    );
    end RAM;

architecture Behavioral of RAM is
    type ram_type is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    
    
    signal ram_data : ram_type ;

begin
    process (ce, re, we, address, data_in)
    begin
       if ce = '1' then
            if we = '1' then
                ram_data(to_integer(unsigned(address))) <= data_in;
            elsif re = '1' then
                data_out <= ram_data(to_integer(unsigned(address)));                
            end if;
        else
        end if;
    end process;
end Behavioral;

