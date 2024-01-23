library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ALU is
    port(
        a:in std_logic_vector(15 downto 0);
        b:in std_logic_vector(15 downto 0);
        selectors: in std_logic_vector(2 downto 0);
        q: inout std_logic_vector(15 downto 0); 
        zero_out, carry_out, overflow_out, sign_out : inout std_logic :='0'
        );
        
end ALU;

architecture asd of ALU is

signal res_carry: std_logic_vector(16 downto 0);
signal overflow_9:std_logic_vector(16 downto 0);
signal sign_a, sign_b, sign_sum:std_logic_vector(15 downto 0);
signal a1, a2: std_logic ;
signal a3: std_logic_vector(7 downto 0); 
begin    
    ha: process(a,b,selectors)
    begin

    case(selectors) is
    when "000" =>
    q<=std_logic_vector(unsigned(a)+unsigned(b));
    res_carry<=std_logic_vector(unsigned('0'&a)+unsigned('0'&b));
    carry_out<=res_carry(16);
    
    when "001" =>
    q<=std_logic_vector(unsigned(a)-unsigned(b));
    -- res_carry<= std_logic_vector(unsigned(a)-unsigned(b));
    -- carry_out<=res_carry(8);

    when "010" =>
    q<=std_logic_vector(unsigned(a(7 downto 0))*unsigned(b(7 downto 0))); 
    when "011" =>
        q(15 downto 0)<=std_logic_vector(unsigned(a(15 downto 0))/unsigned(b(15 downto 0)));
    when "100" =>
        q<= a and b;
    when "101" =>
        q<= a or b;
    when "110" =>
        q<= a xor b;
    when others =>
        q<= not a;
    end case;

    if q="0000000000000000" then
        zero_out <= '1';
    end if ;
    sign_out<=q(15);

a1<=q(8);
a3<=std_logic_vector(unsigned('0'&a(6 downto 0))+unsigned('0'&b(6 downto 0)));
a2<=a3(7);
overflow_out<=a1 xor a2;
end process ha;
end asd;
