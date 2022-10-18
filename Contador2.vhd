library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Contador is	 
	port (clk_0: inout std_logic;
	      load, reset, arriba, TL, SEL_DISP: in std_logic;
		  data: in std_logic_vector (3 downto 0); 
		  conta: out std_logic_vector (3 downto 0);
		  conta2: out std_logic_vector (3 downto 0);
		  disCom: out std_logic_vector (3 downto 0);
		  salida7Seg: out std_logic_vector (7 downto 0); 	 
		  --off_LED: out std_logic_vector (7 downto 0); 	 
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
signal clk_low2: std_logic := '0';
---------------------------------------------------------------	   
signal s_count: std_logic_vector (3 downto 0); 
signal s_count2: std_logic_vector (3 downto 0); 	

signal dato1: std_logic_vector (3 downto 0);
signal dato2: std_logic_vector (3 downto 0);  
signal datoDeco1: std_logic_vector (7 downto 0);
signal datoDeco2: std_logic_vector (7 downto 0);

signal OCHO: std_logic_vector (3 downto 0);
signal DATO_DECO: std_logic_vector (3 downto 0);
signal display: std_logic_vector (7 downto 0); --a, b, c, d, e, f, g, dp;	
signal display2: std_logic_vector (7 downto 0); --a, b, c, d, e, f, g, dp;	

signal banderaDis: std_logic := '0';
--signal banderaDeco: std_logic := '0';

begin 
---------------------------------------------------------------	
	OSCInst0: OSCH
	generic map ("26.60")
	port map ('0', clk_0);
---------------------------------------------------------------
--off_LED <= "11111111"; 
OCHO <= "1000";

process ( clk_low, load, reset)
begin
    if reset ='1' then
		s_count2 <= "0000";
    elsif (clk_low'event and clk_low = '1') then
		if load = '1' then
		      s_count2 <= data;
		end if;
	end if;
end process;

contaBCD: process (clk_low,reset)
begin
	if reset ='1' then
		s_count <= "0000";
	elsif (clk_low'event and clk_low = '1') then
		if arriba = '1' then
			if s_count = "1111" then
				s_count <= "0000";						
			else 
			    s_count <= s_count + 1;
			end if;
		else   
			if s_count = "0000" then
				s_count <= "1111";				
			else 
			    s_count <= s_count - 1;
			end if;
		end if;
	end if;
end process;

conta <= s_count;
conta2 <= s_count2;
dato1 <= s_count;
dato2 <= s_count2;	 
	
multiplexorDis: process (clk_low2, datoDeco1, datoDeco2)
begin 
	if (clk_low2'event and clk_low2 = '1') then
		if banderaDis = '0' then
			salida7Seg <= datoDeco2;
			disCom <= "0001";
			banderaDis <= not banderaDis;
		else 
			salida7Seg <= datoDeco1;
			disCom <= "0010";
			banderaDis <= not banderaDis;
		end if;
	end if;
end process multiplexorDis;	

multiplexorDeco: process (clk_low2, dato1, dato2, TL, reset)
begin 
    if reset ='1' then
	       datoDeco1 <= "11111100";
		   datoDeco2 <= "11111100";
    elsif (TL= '0') then
		   DATO_DECO <= OCHO;
		   datoDeco1 <= display2;
		   datoDeco2 <= display2;		   
	elsif (clk_low2'event and clk_low2 = '1') then
		if banderaDis = '0' then		
		    DATO_DECO <= dato1;
			datoDeco1 <= display2;
		else  		
		    DATO_DECO <= dato2;
			datoDeco2 <= display2;
		end if;
	end if;
end process multiplexorDeco;	

	decoder: process (DATO_DECO)--Decodifica;
	begin
		case DATO_DECO is --          abcdefgDp
			when "0000" => display <= "11111100"; --0
		 	when "0001" => display <= "01100000"; --1
			when "0010" => display <= "11011010"; --2
			when "0011" => display <= "11110010"; --3
			when "0100" => display <= "01100110"; --4
			when "0101" => display <= "10110110"; --5
			when "0110" => display <= "10111110"; --6
			when "0111" => display <= "11100000"; --7
			when "1000" => display <= "11111110"; --8
			when "1001" => display <= "11110110"; --9
			when "1010" => display <= "11101110"; --A
			when "1011" => display <= "00111110"; --b
			when "1100" => display <= "10011100"; --C
			when "1101" => display <= "01111010"; --d
			when "1110" => display <= "10011110"; --E
	 		when others => display <= "10001110"; --F
		end case;
	end process decoder;   
	
	xor_inversor: process (display, SEL_DISP)--Invierte la tabla;
	begin
		display2 (7) <= display (7) xor SEL_DISP; --a
		display2 (6) <= display (6) xor SEL_DISP; --b
		display2 (5) <= display (5) xor SEL_DISP; --c
		display2 (4) <= display (4) xor SEL_DISP; --d
		display2 (3) <= display (3) xor SEL_DISP; --e
		display2 (2) <= display (2) xor SEL_DISP; --f
		display2 (1) <= display (1) xor SEL_DISP; --g
		display2 (0) <= display (0) xor SEL_DISP; --dp
	end process xor_inversor;

P_blink_LED: process (clk_0)
variable count: integer range 0 to 25000000;
begin
	if (clk_0'event and clk_0 = '1') then
		if (count < 6000000) then 
			count := count + 1;
		else
			count := 0;
			clk_low <= not clk_low;
		end if;
	end if;
end process; 

P_blink_LED2: process (clk_0)
variable count: integer range 0 to 540000;
begin
	if (clk_0'event and clk_0 = '1') then
		if (count < 160000) then 
			count := count + 1;
		else
			count := 0;
			clk_low2 <= not clk_low2;
		end if;
	end if;
end process;

blink_LED <= clk_low;

end Contador;	   