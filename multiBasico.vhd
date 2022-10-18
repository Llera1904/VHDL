library IEEE;
use IEEE.std_logic_1164.all;

entity multiBasico is
	port (W0, W1, s, En : in std_logic;
	      f : out std_logic);	  
end multiBasico;

architecture multiBasico of multiBasico is
begin
	
	process (W0, W1, s, En)
	begin
	
	if En = '1' then
	  if s= '0' then
		f <= W0;
	  else
		f <= W1;
	  end if;
	end if;	
	
	end process;
	 
end multiBasico;	