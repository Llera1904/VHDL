library IEEE;
use IEEE.std_logic_1164.all;

entity sum12Bits is
	port (a: in std_logic_vector (11 downto 0); 
	      b: in std_logic_vector (11 downto 0); Cin: in std_logic;
	      s: out std_logic_vector (11 downto 0); Cout: out std_logic);
end sum12Bits;

architecture sum12Bits of sum12Bits is 

component sum4Bits
	port (a: in std_logic_vector (3 downto 0); 
	      b: in std_logic_vector (3 downto 0);	Cin: in std_logic;
	      s: out std_logic_vector (3 downto 0); Cout: out std_logic);
end component;

signal Cout_parcial: std_logic_vector (1 downto 0);

begin  
				    
	SS0: sum4Bits port map(a(3 downto 0), b(3 downto 0), 
	                       Cin, s(3 downto 0), Cout_parcial(0));
	
	SS1: sum4Bits port map(a(7 downto 4), b(7 downto 4), 
	                       Cout_parcial(0), s(7 downto 4), Cout_parcial(1));
	
	SS2: sum4Bits port map(a(11 downto 8), b(11 downto 8), 
	                       Cout_parcial(1), s(11 downto 8), Cout);

end sum12Bits;
													