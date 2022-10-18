library IEEE;
use IEEE.std_logic_1164.all;

entity flipflopSR is 
	port (C, S: in std_logic;
	      R, Q: inout std_logic);	
end flipflopSR;

architecture flipflopSR of flipflopSR is
begin
	
	process (C, S, R)
	begin  
		if (C'event and C= '1') then
		  if (S= '0' and R= '0') then
			null;
		  elsif (S= '0' and R= '1') then 
			   Q <= '0';
		  elsif (S= '1' and R= '0') then 
			   Q <= '1';
		  elsif (S= '1' and R= '0') then
			   null;
		  end if;
	    end if;
	end process;
			 
end flipflopSR;
