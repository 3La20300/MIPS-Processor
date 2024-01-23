library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ALU_Control is
    port(
        initial :in std_logic_vector(1 downto 0);
        a1:in std_logic_vector(15 downto 0);
        b1:in std_logic_vector(15 downto 0);
        selectors1: in std_logic_vector(2 downto 0);
        q1: inout std_logic_vector(15 downto 0);
        zero_out1, carry_out1, overflow_out1, sign_out1 : inout std_logic
    
    );
end ALU_Control;

architecture alucon of ALU_Control is

    component ALU
    port(
        a:in std_logic_vector(15 downto 0);
        b:in std_logic_vector(15 downto 0);
        selectors: in std_logic_vector(2 downto 0);
        q: inout std_logic_vector(15 downto 0); 
        zero_out, carry_out, overflow_out, sign_out : inout std_logic :='0'
        );
end component;

    signal res: std_logic_vector (2 downto 0);
    begin
        process(initial, a1, b1, selectors1)
        begin

        if initial="00" then
                res<=selectors1;
            elsif initial="10" then 
                if selectors1="010" then
                    res<="000";
                elsif selectors1="011" then 
                    res<="001";
                else
                    res<=selectors1;
                end if ;
            end if ;
        end process;
    alu1: ALU  port map (a1, b1, res, q1, zero_out1, carry_out1, overflow_out1, sign_out1);
    end alucon;       
    
    