library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity estado is  
	port (clk, reset: in std_logic;	
	      cOunt: out std_logic_vector (4 downto 0));
	     
end estado;

architecture estado of estado is  

subtype state is std_logic_vector (4 downto 0);
signal presentState, nextState : state;	 
--2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31
constant state2: state := "00010";  
constant state3: state := "00011";
constant state5: state := "00101";
constant state7: state := "00111";
constant state11: state := "01011";
constant state13: state := "01101";
constant state17: state := "10001";
constant state19: state := "10011";   
constant state23: state := "10111"; 
constant state29: state := "11101"; 
constant state31: state := "11111"; 

begin
	process (clk)
	begin
		if rising_edge(clk) then 
		  if (reset = '1') then
			presentState <= state2;
		  else  
			presentState <= nextState;
		  end if;  
		end if;
	end process;
	

	process (presentState)
	begin
		case presentState is
			when state2 => nextState <= state3;	   -- 2
			when state3 => nextState <= state5;	   -- 3
			when state5 => nextState <= state7;	   -- 5
			when state7 => nextState <= state11;   -- 7
			when state11 => nextState <= state13;  -- 11
			when state13 => nextState <= state17;  -- 13
			when state17 => nextState <= state19;  -- 17
			when state19 => nextState <= state23;  -- 19
			when state23 => nextState <= state29;  -- 23
			when state29 => nextState <= state31;  -- 29
			when state31 => nextState <= state2;   -- 31
			when others => nextState <= state2;	   -- 2
		end case;
		cOunt <= presentState;
	end process;
		  
end estado;
