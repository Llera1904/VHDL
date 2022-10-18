library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Contador is	 
	port (clk_0: inout std_logic;
	      load, reset, arriba: in std_logic;
		  data: in std_logic_vector (3 downto 0);
		  conta: out std_logic_vector (3 downto 0);
		  off_LED: out std_logic_vector (2 downto 0); 	 
		  blink_LED: out std_logic);	
end Contador;

architecture Contador of Contador is  
---------------------------------------------------------------
component OSCH
	generic (NOM_FREQ: string);
	port (STDBY: in std_logic; OSC: out std_logic);
end component;

attribute NOM_FREQ: string;
attribute NOM_FREQ of OSCinst0: label is "26.60";

signal clk_low: std_logic := '0';
---------------------------------------------------------------	   
signal s_count: std_logic_vector (3 downto 0);
begin 
---------------------------------------------------------------	
	OSCInst0: OSCH
	generic map ("26.60")
	port map ('0', clk_0);
---------------------------------------------------------------
--off_LED <= "111";

contaBCD: process (clk_low, reset)
begin	
	if reset ='1' then
		s_count <= "0000";
	elsif (clk_low'event and clk_low = '1') then
		if load = '1' then
			s_count <= data;
		elsif arriba = '1' then
			if s_count = "1001" then
				s_count <= "0000";
			else s_count <= s_count + 1;
			end if;
		else   
			if s_count = "0000" then
				s_count <= "1001";
			else s_count <= s_count - 1;
			end if;
		end if;
	end if;
end process;

--conta <= not s_count;	
conta <= s_count;

P_blink_LED: process (clk_0)
variable count: integer range 0 to 25000000;
begin
	if (clk_0'event and clk_0 = '1') then
		if (count < 24000000) then 
			count := count + 1;
		else
			count := 0;
			clk_low <= not clk_low;
		end if;
	end if;
end process;

blink_LED <= clk_low;

end Contador;	   

