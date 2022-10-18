library IEEE;
use IEEE.std_logic_1164.all;

entity multi4a1 is
	port (w : in std_logic_vector (3 downto 0); s : in std_logic_vector (1 downto 0); En : in std_logic;
	      f : out std_logic);
end multi4a1;

architecture multi4a1 of multi4a1 is 

component multiBasico
	port (W0, W1, s, En : in std_logic;
	      f : out std_logic);
end component;

signal fParcial : std_logic_vector (1 downto 0);

begin
	
	SS0: multiBasico port map (W(0),W(1),s(0),En,fParcial(0));
	SS1: multiBasico port map (W(2),W(3),s(0),En,fParcial(1));
	SS2: multiBasico port map (fParcial(0),fParcial(1),s(1),En,f);
	
end multi4a1;
