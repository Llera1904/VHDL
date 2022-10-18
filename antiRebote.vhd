library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity antiRebote is 
	port (i_Clk: in std_logic;
	      i_Switch: in std_logic;
		  o_Switch: out std_logic);
end antiRebote;

architecture antiRebote of antiRebote is  

constant C_DEBOUCE_LIMIT : integer := 250000;

signal r_Count : integer range 0 to C_DEBOUCE_LIMIT := 0; 
signal r_State : std_logic := '0';

begin
	
	p_Debounce : process (i_Clk) is
	begin 
		if rising_edge (i_Clk) then
		  if (i_Switch /= r_State and r_Count < C_DEBOUCE_LIMIT) then
			r_Count <= r_Count + 1;
		  elsif r_Count = C_DEBOUCE_LIMIT then
			r_State <= i_Switch;
			r_Count <= 0; 
		  else 
			r_Count <= 0;
		  end if;
		 end if;
	end process; 
	
o_Switch <= r_State;

end antiRebote;
