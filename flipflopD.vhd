library IEEE;
use IEEE.std_logic_1164.all;

entity flipflopD is	
	port (C, D: in std_logic;
	      Q: out std_logic);	
end flipflopD;

architecture flipflopD of flipflopD is
begin	
	
	process (C)
	begin 
		if (C'event and C='1') then
			Q <= D;
		end if;
	end process;
 
end flipflopD;
