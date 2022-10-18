library IEEE;
use IEEE.std_logic_1164.all;

entity sumSimple is
	port (a,b: in std_logic;
	      s,c: out std_logic);
end sumSimple;

architecture sumSimple of sumSimple is
begin
	
	s <= a xor b;
	c <= a and b;
	 
end sumSimple;
