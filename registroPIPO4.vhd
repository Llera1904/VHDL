library IEEE;
use IEEE.std_logic_1164.all;

entity registroPIPO4 is	  
	port (D: in std_logic_vector (3 downto 0);
	      C: in std_logic;
		  S: out std_logic_vector (3 downto 0));
end registroPIPO4;

architecture registroPIPO4 of registroPIPO4 is
begin

	process (C, D)
	begin  
		if (C'event and C= '1') then
		  S<= D;
	    end if;
	end process;

end registroPIPO4;
