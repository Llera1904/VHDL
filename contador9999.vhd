library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity contador9999 is
	port (clk_0: inout std_logic;
	      reset, arriba, TL, SEL_DISP: in std_logic;
		  button1, button2: in std_logic;
		  disCom: out std_logic_vector (3 downto 0);
		  salida7Seg: out std_logic_vector (7 downto 0); 	 
		  --off_LED: out std_logic_vector (7 downto 0);
		  button1_LED, button2_LED: out std_logic;
		  blink_LED: out std_logic);	
end contador9999;

architecture contador9999 of contador9999 is 
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
component antiRebote 
	port (i_Clk: in std_logic;
	      i_Switch: in std_logic;
		  o_Switch: out std_logic);
end component;

signal s_count: std_logic_vector (13 downto 0);
signal num_bin: std_logic_vector (13 downto 0);

signal num_bcd: std_logic_vector (15 downto 0);

signal unidades: std_logic_vector (3 downto 0);
signal decenas: std_logic_vector (3 downto 0);  
signal centenas: std_logic_vector (3 downto 0); 
signal miles: std_logic_vector (3 downto 0);

signal uniDeco: std_logic_vector (7 downto 0);
signal decDeco: std_logic_vector (7 downto 0);
signal cenDeco: std_logic_vector (7 downto 0);	
signal milDeco: std_logic_vector (7 downto 0);

signal OCHO: std_logic_vector (3 downto 0);
signal DATO_DECO: std_logic_vector (3 downto 0);
signal display: std_logic_vector (7 downto 0); --a, b, c, d, e, f, g, dp;	
signal display2: std_logic_vector (7 downto 0); --a, b, c, d, e, f, g, dp;

signal o_button1: std_logic;
signal o_button2: std_logic;

signal banderaDis: std_logic_vector (1 downto 0) := "00";
--signal banderaDeco: std_logic := '0';

begin
---------------------------------------------------------------	
	OSCInst0: OSCH
	generic map ("26.60")
	port map ('0', clk_0);
---------------------------------------------------------------
--off_LED <= "11111111"; 
OCHO <= "1000";	

SS0: antiRebote port map (clk_0, button1, o_button1);
SS1: antiRebote port map (clk_0, button2, o_button2); 

button1_LED <= o_button1;
button2_LED <= o_button2;

contaBCD: process (clk_low,reset)
begin
	if reset ='1' then
		s_count <= "00000000000000";
	elsif (clk_low'event and clk_low = '1') then
		if arriba = '1' then
			if s_count = "10011100001111" then --10 0111 0000 1111 = 9999;
				s_count <= "00000000000000";						
			else 
			    s_count <= s_count + 1;
			end if;
		else   
			if s_count = "00000000000000" then
				s_count <= "10011100001111";				
			else 
			    s_count <= s_count - 1;
			end if;
		end if;
	end if;
end process; 

num_bin <= s_count;

proceso_bcd: process(num_bin) 
                 variable z: STD_LOGIC_VECTOR(29 downto 0);
                 begin 
					 -- Inicialización de datos en cero.
                     z := (others => '0');
                     -- Se realizan los primeros tres corrimientos
                     z(16 downto 3) := num_bin;
                     for i in 0 to 10 loop 
						 -- Unidades (4 bits).
                         if z(17 downto 14) > 4 then
							 z(17 downto 14) := z(17 downto 14) + 3;
                         end if;
                         -- Decenas (4 bits).
                         if z(21 downto 18) > 4 then 
							 z(21 downto 18) := z(21 downto 18) + 3;
                         end if;
                         -- Centenas (4 bits).
                         if z(25 downto 22) > 4 then 
							 z(25 downto 22) := z(25 downto 22) + 3;
                         end if;	
						 -- Miles (4 bits).
                         if z(29 downto 26) > 4 then 
							 z(29 downto 26) := z(29 downto 26) + 3;
                         end if;
                         -- Corrimiento a la izquierda.
                         z(29 downto 1) := z(28 downto 0);
                      end loop;
                      -- Pasando datos de variable Z, correspondiente a BCD.
                      num_bcd <= z(29 downto 14);
               end process;	
			   
unidades <= num_bcd(3 downto 0);	  
decenas <= num_bcd(7 downto 4);
centenas <= num_bcd(11 downto 8);
miles <= num_bcd(15 downto 12);
 
multiplexorDis: process (clk_low2, uniDeco, decDeco, cenDeco, milDeco)
begin 
	if (clk_low2'event and clk_low2 = '1') then
		if banderaDis = "00" then
			salida7Seg <= decDeco;
			disCom <= "0001";
			banderaDis <= banderaDis + '1';
		elsif banderaDis = "01" then 
			salida7Seg <= cenDeco;
			disCom <= "0010";
			banderaDis <= banderaDis + '1';
		elsif banderaDis = "10" then 
			salida7Seg <= milDeco;
			disCom <= "0100";
			banderaDis <= banderaDis + '1';
		elsif banderaDis = "11" then 
			salida7Seg <= uniDeco;
			disCom <= "1000";
			banderaDis <= "00";
		end if;
	end if;
end process multiplexorDis;	

multiplexorDeco: process (clk_low2, unidades, decenas, centenas, miles, TL, reset)
begin 
    if reset ='1' then
	       uniDeco <= "11111100";
		   decDeco <= "11111100";
		   cenDeco <= "11111100";
		   milDeco <= "11111100";
    elsif (TL= '0') then
		   DATO_DECO <= OCHO;
		   uniDeco <= display2;
		   decDeco <= display2;
		   cenDeco <= display2;	
		   milDeco <= display2;	
	elsif (clk_low2'event and clk_low2 = '1') then
		if banderaDis = "00" then		
		    DATO_DECO <= unidades;
			uniDeco <= display2;
		elsif banderaDis = "01" then  		
		    DATO_DECO <= decenas;
			decDeco <= display2;
		elsif banderaDis = "10" then  		
		    DATO_DECO <= centenas;
			cenDeco <= display2;
		elsif banderaDis = "11" then  		
		    DATO_DECO <= miles;
			milDeco <= display2;
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
		if (count < 2600000) then 
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
		if (count < 60000) then 
			count := count + 1;
		else
			count := 0;
			clk_low2 <= not clk_low2;
		end if;
	end if;
end process;

blink_LED <= clk_low;

end contador9999;