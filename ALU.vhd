library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity ALU is
	port (clk_0: inout std_logic;
	      dato: in std_logic_vector (11 downto 0);
		  numCorri: in std_logic_vector (3 downto 0);
		  selector: in std_logic_vector (3 downto 0);
	      reset, TL, SEL_DISP, enable: in std_logic;
		  disCom: out std_logic_vector (3 downto 0);
		  salida7Seg: out std_logic_vector (7 downto 0); 
          salidaLogica: out std_logic_vector (12 downto 0);	
          salidaDato: out std_logic_vector (11 downto 0);	
          salidanumCorri: out std_logic_vector (3 downto 0);		  
		  --off_LED: out std_logic_vector (7 downto 0);
		  blink_LED: out std_logic);	
end ALU;

architecture ALU of ALU is 
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
component sum12Bits is
	port (a: in std_logic_vector (11 downto 0); 
	      b: in std_logic_vector (11 downto 0); Cin: in std_logic;
	      s: out std_logic_vector (11 downto 0); Cout: out std_logic);
end component;

component multiplicacion6Bits is
	port (datoA, datoB: in std_logic_vector (5 downto 0);
	      resultado: out std_logic_vector (11 downto 0));
end component;

component division6Bits is
	Port (Ain : in  STD_LOGIC_VECTOR (5 downto 0);
          Bin : in  STD_LOGIC_VECTOR (5 downto 0);
          Q : out  STD_LOGIC_VECTOR (5 downto 0);
          R : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

signal datoW, datoZ, datoA, datoB: std_logic_vector (11 downto 0);
signal datoP, datoQ, datoX, datoY: std_logic_vector (5 downto 0);

signal salidaSuma: std_logic_vector (12 downto 0);
signal salidaMulti: std_logic_vector (11 downto 0);
signal salidaDiv: std_logic_vector (5 downto 0);
signal salidaRes: std_logic_vector (5 downto 0);

signal salidaArit: std_logic_vector (12 downto 0);
signal salidaLog: std_logic_vector (12 downto 0);

signal datoCorri: std_logic_vector (11 downto 0); 
signal corriOut: std_logic_vector (11 downto 0); 
----------------------------------------------------------------------
signal num_bin: std_logic_vector (12 downto 0);
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
signal UNO: std_logic_vector (11 downto 0);
signal menosUNO: std_logic_vector (11 downto 0);

signal DATO_DECO: std_logic_vector (3 downto 0);
signal display: std_logic_vector (7 downto 0);  --a, b, c, d, e, f, g, dp;	
signal display2: std_logic_vector (7 downto 0); --a, b, c, d, e, f, g, dp;

signal banderaDis: std_logic_vector (1 downto 0) := "00";
signal bandera: std_logic:= '0';

begin
---------------------------------------------------------------	
	OSCInst0: OSCH
	generic map ("26.60")
	port map ('0', clk_0);
---------------------------------------------------------------
--off_LED <= "11111111"; 
OCHO <= "1000";
UNO <= "000000000001"; --12 bits
menosUNO <= (not UNO)+ 1;

sumador: sum12Bits port map(datoW, datoZ, '0', salidaSuma(11 downto 0), salidaSuma(12));
multiplicacion: multiplicacion6Bits port map (datoX, datoY, salidaMulti);
division: division6Bits port map (datoP, datoQ, salidaDiv, salidaRes);

registroDato: process (clk_low, dato, enable)
              begin
                 if (clk_low'event and clk_low = '1') then			  
	               if enable = '0' then
		             datoA <= dato;
				     salidaDato <= dato;
		           else 
		             datoB <= dato;
				     salidaDato <= dato;
		           end if;
				 end if;
	          end process registroDato;

selecOp:  process (selector)
          begin
		     case selector is
			    when "0000" => datoW <= "0000" & datoA (7 downto 0); datoZ <= "0000" & datoB (7 downto 0); bandera <= '0';
		 	    when "0001" => datoW <= "0000" & datoA (7 downto 0); datoZ <= (not ("0000" & datoB (7 downto 0))) + 1; bandera <= '0';
			    when "0010" => datoW <= "0000" & datoA (7 downto 0); datoZ <= UNO; bandera <= '0';
			    when "0011" => datoW <= "0000" & datoA (7 downto 0); datoZ <= menosUNO; bandera <= '0';  
			    when "0100" => datoW <= datoB ; datoZ <= UNO; bandera <= '0';  
			    when "0101" => datoW <= datoB ; datoZ <= menosUNO; bandera <= '0';
			    when "0110" => datoW <= datoA ; datoZ <= datoB; bandera <= '0'; 
			    when "0111" => datoW <= datoA ; datoZ <= (not datoB) + 1; bandera <= '0';
			    when "1000" => salidaLog <= '0' & (datoA and datoB); bandera <= '1';
			    when "1001" => salidaLog <= '0' & (datoA or datoB); bandera <= '1';
			    when "1010" => salidaLog <= '0' & (datoA xor datoB); bandera <= '1';
			    when "1011" => salidaLog <= '0' & (not datoA); bandera <= '1';
			    when "1100" => salidaLog <= (not ('0' & datoA)) + 1; bandera <= '1';
			    when "1101" => datoX <= datoA (5 downto 0); datoY <= datoB (5 downto 0); bandera <= '0';
			    when "1110" => datoP <= datoA (5 downto 0); datoQ <= datoB (5 downto 0); bandera <= '0'; 
	 		    when others => datoCorri <= datoA; bandera <= '0';   
		     end case;
	       end process selecOp;  		   
			 
selecSalida: process (selector)
        begin
		  case selector is
		     when "0000" => salidaArit <= salidaSuma; 
		 	 when "0001" => salidaArit <= '0' & salidaSuma(11 downto 0); 
			 when "0010" => salidaArit <= salidaSuma; 
			 when "0011" => salidaArit <= '0' & salidaSuma(11 downto 0); 
			 when "0100" => salidaArit <= salidaSuma; 
			 when "0101" => salidaArit <= '0' & salidaSuma(11 downto 0); 
			 when "0110" => salidaArit <= salidaSuma; 
			 when "0111" => salidaArit <= '0' & salidaSuma(11 downto 0); 
			 when "1101" => salidaArit <= '0' & salidaMulti; 
			 when "1110" => salidaArit <= "0000000" & salidaDiv; 
             when others => salidaArit <= '0' & corriOut;		 
		  end case;
	    end process; 
-----------------------------------------------------------------------------------------		
salidanumCorri <= numCorri;			
		
corrimiento: process (numCorri, datoCorri)
             variable corriAux : std_logic_vector (11 downto 0);
             begin
			     corriAux := datoCorri;
				 case numCorri is
				     when "0000" => corriOut <= corriAux;
					 when "0001" => corriOut <= corriAux(10 downto 0) & '0';
					 when "0010" => corriOut <= corriAux(9 downto 0) & "00";
					 when "0011" => corriOut <= corriAux(8 downto 0) & "000";
					 when "0100" => corriOut <= corriAux(7 downto 0) & "0000";
					 when "0101" => corriOut <= corriAux(6 downto 0) & "00000";
					 when "0110" => corriOut <= corriAux(5 downto 0) & "000000";
					 when "0111" => corriOut <= corriAux(4 downto 0) & "0000000";
					 when "1000" => corriOut <= corriAux(3 downto 0) & "00000000";
					 when "1001" => corriOut <= corriAux(2 downto 0) & "000000000";
					 when "1010" => corriOut <= corriAux(1 downto 0) & "0000000000";
					 when "1011" => corriOut <= corriAux(0) & "00000000000";
					 when others => corriOut <= "000000000000";
                 end case;
			 end process;		 
				    			
salida: process (salidaArit, salidaLog)
        begin 
		   if bandera = '0' then 
		     num_bin <= salidaArit;
			 salidaLogica <= "0000000000000"; 
		   elsif bandera = '1' then 
		     salidaLogica <= salidaLog;
			 num_bin <= "0000000000000";
		   end if;
		end process salida;
	      		
---------------------------------------------------------------
proceso_bcd: process(num_bin) 
                 variable z: STD_LOGIC_VECTOR(28 downto 0);
                 begin 
					 -- Inicialización de datos en cero.
                     z := (others => '0');
                     -- Se realizan los primeros tres corrimientos
                     z(15 downto 3) := num_bin;
                     for i in 0 to 9 loop 
						 -- Unidades (4 bits).
                         if z(16 downto 13) > 4 then
							 z(16 downto 13) := z(16 downto 13) + 3;
                         end if;
                         -- Decenas (4 bits).
                         if z(20 downto 17) > 4 then 
							 z(20 downto 17) := z(20 downto 17) + 3;
                         end if;
                         -- Centenas (4 bits).
                         if z(24 downto 21) > 4 then 
							 z(24 downto 21) := z(24 downto 21) + 3;
                         end if;	
						 -- Miles (4 bits).
                         if z(28 downto 25) > 4 then 
							 z(28 downto 25) := z(28 downto 25) + 3;
                         end if;
                         -- Corrimiento a la izquierda.
                         z(28 downto 1) := z(27 downto 0);
                      end loop;
                      -- Pasando datos de variable Z, correspondiente a BCD.
                      num_bcd <= z(28 downto 13);
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

end ALU;
