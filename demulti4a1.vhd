library IEEE;
use IEEE.std_logic_1164.all;

entity demulti4a1 is   
	port (f : in std_logic; s1,s0 : in std_logic;
	       A : out std_logic_vector (3 downto 0));
end demulti4a1;

architecture demulti4a1 of demulti4a1 is
begin
		
	A(0) <= f when (s1= '0' and s0= '0')else '0';
	A(1) <= f when (s1= '0' and s0= '1')else '0';
	A(2) <= f when (s1= '1' and s0= '0')else '0';
	A(3) <= f when (s1= '1' and s0= '1')else '0';

end demulti4a1;
