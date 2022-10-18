library IEEE;
use IEEE.std_logic_1164.all;

entity muxCon is   
	port (W0, W1, s, En : in std_logic;
	      f : out std_logic);	
end muxCon;

architecture muxCon of muxCon is
begin
	
	with s select
	f <= w0 when '0',
	     w1 when  others;
	
end muxCon;
	 