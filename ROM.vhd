library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port ( A : in std_logic_vector(3 downto 0); 
           CE : in std_logic;  
           RE : in std_logic;  
           D : out std_logic_vector(15 downto 0)
           );  
end ROM;

architecture behavioral of ROM is
    type arr is array (0 to 15) of std_logic_vector(15 downto 0);
    constant data : arr := (
        "0111000000001001", --Added  
        "0111001000000101", --max count 
        "0111010000000000", --result 
        "0111011000000000", --counter
        "0111100000000001", --cosnt=1
		"0001000010010000", --0   
        "0001011100011000", --2 
        "1011001011000101", --4  
        "0000000000000000",  
        "0000000000000000",  
        "0000000000000000",  
        "0000000000000000",  
        "0000000000000000",  
        "0000000000000000",  
        "0000000000000000",  
        "0000000000000000"
    );

begin
    process(CE, RE, A)
    begin
        if CE = '1' and RE = '1' then
            D <= data(to_integer(unsigned(A)));
        end if;
    end process;
end behavioral;

