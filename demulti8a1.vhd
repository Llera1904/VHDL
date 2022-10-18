library IEEE;
use IEEE.std_logic_1164.all;

entity demulti8a1 is
	port (f: in std_logic; s : in std_logic_vector (2 downto 0);
	      A: out std_logic_vector (7 downto 0)); 
end demulti8a1;

architecture demulti8a1 of demulti8a1 is

component demulti4a1
	port (f : in std_logic; s1,s0 : in std_logic;
	      A : out std_logic_vector (3 downto 0));
end component;

signal AParcial: std_logic_vector (3 downto 0);

begin
	
	SS0: demulti4a1 port map(f, '0', s(2), Aparcial(3 downto 0));   
	SS1: demulti4a1 port map(Aparcial(0), s(1), s(0), A(3 downto 0)); 
	SS2: demulti4a1 port map(Aparcial(1), s(1), s(0), A(7 downto 4)); 
	
end demulti8a1;
