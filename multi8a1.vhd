library IEEE;
use IEEE.std_logic_1164.all;

entity multi8a1 is
	port (w : in std_logic_vector (7 downto 0); s : in std_logic_vector (2 downto 0); En : in std_logic;
	      f : out std_logic);
end multi8a1;

architecture multi8a1 of multi8a1 is

component multiBasico
	port (W0, W1, s, En : in std_logic;
	      f : out std_logic);
end component;	

component multi4a1
	port (w : in std_logic_vector (3 downto 0); s : in std_logic_vector (1 downto 0); En : in std_logic;
	      f : out std_logic);
end component;

signal f_parcial: std_logic_vector (1 downto 0);

begin
	
	SS0: multi4a1 port map(w(3 downto 0), s(2 downto 1), En, f_parcial(0));
	SS1: multi4a1 port map(w(7 downto 4), s(2 downto 1), En, f_parcial(1));
	SS2: multiBasico port map (f_parcial(0), f_parcial(1), s(0), En, f);
					 
end multi8a1;
