library IEEE;
use IEEE.std_logic_1164.all;

entity flipflopJK is 
	port (C, J, K: in std_logic;
	      Q: inout std_logic);
end flipflopJK;

architecture flipflopJK of flipflopJK is 

signal Qparcial : std_logic;
begin 
	
	process (C, J, K)
	begin
		if (C'event and C= '1') then
			 if (J= '0' and K= '0') then
			   null; 
			 elsif (J= '0' and K= '1') then
			      Q <= '0';
			 elsif (J= '1' and K= '0') then
			      Q <= '1'; 
			 elsif (J= '1' and K= '1') then	
			      Q <= not Q;
			 end if;
	    end if;
	end process;

end flipflopJK;
