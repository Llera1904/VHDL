library IEEE;
use IEEE.std_logic_1164.all;

entity sumCompleto is 
	port (a,b: in std_logic; Cin: in std_logic;
	      s,Cout: out std_logic);
end sumCompleto;

architecture sumCompleto of sumCompleto is

component sumSimple
	port (a,b: in std_logic;
	      s,c: out std_logic);
end component;

signal s_parcial: std_logic;
signal C_parcial1, C_parcial2: std_logic;

begin
	
	SS0: sumSimple port map(a, b, s_parcial, C_parcial1);
	SS1: sumSimple port map(s_parcial, Cin, s, C_parcial2);
	Cout <= C_parcial1 or C_parcial2;
	 
end sumCompleto;
