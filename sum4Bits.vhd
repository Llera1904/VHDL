library IEEE;
use IEEE.std_logic_1164.all;

entity sum4Bits is
	port (a: in std_logic_vector (3 downto 0); b: in std_logic_vector (3 downto 0);	Cin: in std_logic;
	      s: out std_logic_vector (3 downto 0); Cout: out std_logic);
end sum4Bits;

architecture sum4Bits of sum4Bits is

component sumCompleto
	port (a,b: in std_logic; Cin:in std_logic;
	      s,Cout: out std_logic);
end component;

signal Cout_parcial: std_logic_vector (2 downto 0);

begin 
	
	SS0: sumCompleto port map(a(0), b(0), Cin, s(0), Cout_parcial(0));
	SS1: sumCompleto port map(a(1), b(1), Cout_parcial(0), s(1), Cout_parcial(1));
	SS2: sumCompleto port map(a(2), b(2), Cout_parcial(1), s(2), Cout_parcial(2));
	SS3: sumCompleto port map(a(3), b(3), Cout_parcial(2), s(3), Cout);

end sum4Bits;
