library IEEE;
use IEEE.std_logic_1164.all;

entity registroPIPO8 is
	port (D: in std_logic_vector (7 downto 0);
	      C: in std_logic;		   
		  S: out std_logic_vector (7 downto 0));	
end registroPIPO8;

architecture registroPIPO8 of registroPIPO8 is
begin
	
	process (C, D)
	begin  
		if (C'event and C= '1') then
		  S<= D;
	    end if;
	end process;

end registroPIPO8;
