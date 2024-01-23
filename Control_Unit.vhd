library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Unit
 is
  port
  (
    instruc                : inout std_logic_vector(15 downto 0);
    result                  : inout std_logic_vector(15 downto 0):= "0000000000000000";
    result_f                 : inout std_logic_vector(7 downto 0):= "00000000";
    flag            : inout std_logic_vector(3 downto 0):="0000";
    pc:inout std_logic_vector(3 downto 0):= "0000";
    reset: in std_logic := '0';
    clk: in std_logic
  );
end Control_Unit;

architecture Control_arch of Control_Unit
 is
	
  component ROM
  port ( A : in std_logic_vector(3 downto 0); 
  CE : in std_logic;  
  RE : in std_logic;  
  D : out std_logic_vector(15 downto 0)
  );
  end component; 

  component RAM 
  Port ( address : in STD_LOGIC_VECTOR(3 downto 0);
  data_in : in STD_LOGIC_VECTOR(15 downto 0);
  ce : in STD_LOGIC;
  re : in STD_LOGIC :='0';
  we : in STD_LOGIC :='0';
  data_out : inout STD_LOGIC_VECTOR(15 downto 0)
  );
end component;

  component ALU_Control
    port(
        initial :in std_logic_vector(1 downto 0);
        a1:in std_logic_vector(15 downto 0);
        b1:in std_logic_vector(15 downto 0);
        selectors1: in std_logic_vector(2 downto 0);
        q1: inout std_logic_vector(15 downto 0);
        zero_out1, carry_out1, overflow_out1, sign_out1 : inout std_logic
    
    );
  end component;
--component flag_register is
--    port ( 
--        zero_flag, carry_flag, overflow_flag, sign_flag : inout STD_LOGIC;
--        f_zero_out, f_carry_out, f_overflow_out, f_sign_out : out STD_LOGIC
--    );
--  end component;

--Signals:
  signal rs_i, rt_i,alu_out1, alu_out2, a_sig, b_sig,res_sig , ram_r, rstoram : std_logic_vector(15 downto 0);
  signal in_rs :std_logic_vector (15 downto 0) :="0000000000000000" ;
  signal tmp : std_logic_vector(15 downto 0):="0000000000000000";
  signal alu_sel: std_logic_vector( 2 downto 0);
  signal reg_sel: std_logic := '0' ;
  signal initial1: std_logic_vector( 1 downto 0); 
  signal ram_add: std_logic_vector( 3 downto 0):= "0000"; 
--  signal instruc(3 downto 0): std_logic_vector( 3 downto 0); 
  signal w: std_logic;
  signal r: std_logic := '1';
  signal c: std_logic := '1';
  signal buff1: std_logic := '0';
  signal sig_zero, sig_carry, sig_overflow, sig_sign : std_logic;
  signal inst2 : std_logic_vector (15 downto 0);
  signal pc1: std_logic_vector( 3 downto 0):="0000"; 
  signal ram_r_2: std_logic_vector(15 downto 0);
  signal prev_clk : STD_LOGIC := '0';
  type reg1 is array (0 to 7) of std_logic_vector(15 downto 0);

--REGISTER  
  signal reg : reg1:= (
"0000000000000000",  
"0000000000000000",  
"0000000000000000",  
"0000000000000000",  
"0000000000000000",  
"0000000000000000",  
"0000000000000000",  
"0000000000000000"
);
----END OF REG

  begin
    rom_1 : ROM port map (pc, '1', '1', instruc); --add --e --r --data / --fetching 

    ram_add<=instruc(3 downto 0) ;
    ram1: ram port map(ram_add ,in_rs, '1' ,r ,w, ram_r); --sel, in, c ,r ,w, out
    rs_i<=reg(to_integer(unsigned(instruc(11 downto 9))));
    rt_i<=reg(to_integer(unsigned(instruc(8 downto 6))));
--    reg_file1: register_file port map(instruc , reg_sel, result, rs_i ,rt_i);
    alu_1: ALU_Control port map ("00",rs_i,rt_i,instruc(2 downto 0), alu_out1,sig_zero, sig_carry, sig_overflow, sig_sign );
    tmp(5 downto 0)<= instruc(5 downto 0); 
    alu_2: ALU_Control port map ("10",rs_i ,tmp,instruc(14 downto 12), alu_out2,sig_zero, sig_carry, sig_overflow, sig_sign );
 --   flag1: flag_register port map(sig_zero, sig_carry, sig_overflow, sig_sign,flag(0), flag(1), flag(2), flag(3));
       

    process(pc1,instruc , clk)
    begin

        if reset='1' then
          pc1<="0000";
			else 
		 if rising_edge(clk) then

			pc1<=std_logic_vector(unsigned(pc1)+1);
		flag(2)<=sig_overflow;
		  r<='1';
		  w<='0';
        if instruc(15 downto 12) = "0001" then
          initial1<="00";
--          reg_sel<='1';
        reg(to_integer(unsigned(instruc(5 downto 3))))<=alu_out1 ;
	result<=alu_out1;
        elsif instruc(15 downto 12)= "0010" or instruc(15 downto 12)="0011" or instruc(15 downto 12)="0100" or instruc(15 downto 12)="0101" or instruc(15 downto 12)= "0110" then
          initial1<="10";
--          reg_sel<='1';
        reg(to_integer(unsigned(instruc(8 downto 6))))<=alu_out2 ;
	result<=alu_out2;
	--flag(2)<=buff1;
        elsif instruc(15 downto 12)= "0111"then
--          reg_sel<='1';
        reg(to_integer(unsigned(instruc(11 downto 9))))(8 downto 0)<= instruc(8 downto 0);   
        elsif instruc(15 downto 12)="1000" then
          reg_sel<='1';
          w<='0';
          in_rs<="0000000000000000";
          result<=ram_r;
        elsif instruc( 15 downto 12)="1001" then
          reg_sel<='0';
          r<='0';
          w<='1';
          in_rs<=rs_i;
          result<=rs_i;
        elsif instruc(15 downto 12)= "1010" or instruc(15 downto 12)="1011" or instruc(15 downto 12)="1100" or instruc(15 downto 12)="1101" or instruc(15 downto 12)= "1110" or instruc(15 downto 12)= "1111" or instruc(15 downto 12)= "0000" then            
   --         instruc(3 downto 0)<=instruc(3 downto 0);        
            if instruc( 15 downto 12)="1010" then
              reg_sel<='0';
              if rs_i = rt_i then
                pc1<= instruc(3 downto 0);
              else
          --      pc<=pc2;
              end if ;

            elsif instruc( 15 downto 12)="1011" then
--                reg_sel<='0';
              if reg(to_integer(unsigned(instruc(11 downto 9)))) > reg(to_integer(unsigned(instruc(8 downto 6)))) then
                pc1<= instruc(3 downto 0);
              else
--              pc1<= "0101";
    
	      end if ;

            elsif instruc( 15 downto 12)="1100" then
--              reg_sel<='0';
              if reg(to_integer(unsigned(instruc(11 downto 9)))) < reg(to_integer(unsigned(instruc(8 downto 6)))) then
                pc1<= instruc(3 downto 0);
                else
	        end if ;
            elsif instruc( 15 downto 12)="1101" then
--              reg_sel<='0';
		flag(1)<=sig_carry;
              if flag(1)= '1' then
                pc1<= instruc(3 downto 0);
              else
              end if ;

            elsif instruc( 15 downto 12)="1110" then
              reg_sel<='0';
	      flag(0)<=sig_zero;	
              if flag(0)='1' then
                pc1<= instruc(3 downto 0);
              else
              end if ;
      
            elsif instruc( 15 downto 12)="1111" then
              reg_sel<='0';
              pc1<=instruc(3 downto 0);
            
          end if ;
          
        else
--        reg_sel<='0';
        --pc<=pc2;      
        end if;
           result_f<=reg(2)(7 downto 0);
        end if ;
		  end if;
		pc<=pc1;
		
			  end process;
    
    
     
  end Control_arch;  

