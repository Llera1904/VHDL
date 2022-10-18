library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity proyectoFinal is	
	port (clk_0: inout std_logic;
	      button, reset: in std_logic; 
	      blinkLED, blinkLED2, blinkLED3 : out std_logic;
	      salDatoMatriz: out std_logic_vector (7 downto 0);
		  salActivaMatriz: out std_logic_vector (15 downto 0));
end proyectoFinal;

architecture proyectoFinal of proyectoFinal is 
---------------------------------------------------------------
component OSCH
	generic (NOM_FREQ: string);
	port (STDBY: in std_logic; OSC: out std_logic);
end component;

attribute NOM_FREQ: string;
attribute NOM_FREQ of OSCinst0: label is "26.60";

signal clkLow: std_logic := '0';
signal clkLow2: std_logic := '0';  
signal clkLow3: std_logic := '0';
---------------------------------------------------------------	
component antiRebote is
	port (i_Clk: in std_logic;
	      i_Switch: in std_logic;
		  o_Switch: out std_logic);	
end component; 

--ROM para guardar los datos 
type ROM1 is Array (0 to 79)
of std_logic_vector (7 downto 0); 

type ROM2 is Array (0 to 31)
of std_logic_vector (7 downto 0);  


--Matrices auxiliares para guardar los datos
type matriz1 is Array (0 to 7)
of std_logic_vector (7 downto 0);

type matriz2 is Array (0 to 7)
of std_logic_vector (7 downto 0);

constant numeros:       ROM1 := (0 => "00000000",
                                 1 => "00000000",
                                 2 => "00000000",
                                 3 => "00000000",
                                 4 => "00000000",
                                 5 => "00000000",
                                 6 => "00000000",
                                 7 => "00000000",
								 
                                 8 =>  "00000000",
                                 9 =>  "00000000",
                                 10 => "00000000",
                                 11 => "00000000",
                                 12 => "00000000",
                                 13 => "00000000",
                                 14 => "00000000",
								 15 => "00000000", 
								 
								 16 => "00000000",
                                 17 => "00000000",
                                 18 => "00000000",
                                 19 => "00000000",
                                 20 => "00000000",
                                 21 => "00000000",
                                 22 => "00000000",
								 23 => "00000000",
								 
								 24 => "00000000",
                                 25 => "00000000",
                                 26 => "00000000",
                                 27 => "00000000",
                                 28 => "00000000",
                                 29 => "00000000",
                                 30 => "00000000",
								 31 => "00000000",
								 
								 32 => "00000000",
                                 33 => "00000000",
                                 34 => "00000000",
                                 35 => "00000000",
                                 36 => "00000000",
                                 37 => "00000000",
                                 38 => "00000000",
								 39 => "00000000",
								 
								 40 => "00000000",
                                 41 => "00000000",
                                 42 => "00000000",
                                 43 => "00000000",
                                 44 => "00000000",
                                 45 => "00000000",
                                 46 => "00000000",
								 47 => "00000000",
								 
								 48 => "00000000",
                                 49 => "00000000",
                                 50 => "00000000",
                                 51 => "00000000",
                                 52 => "00000000",
                                 53 => "00000000",
                                 54 => "00000000",
								 55 => "00000000",
								 
								 56 => "00000000",
                                 57 => "00000000",
                                 58 => "00000000",
                                 59 => "00000000",
                                 60 => "00000000",
                                 61 => "00000000",
                                 62 => "00000000",
								 63 => "00000000",
								 
								 64 => "00000000",
                                 65 => "00000000",
                                 66 => "00000000",
                                 67 => "00000000",
                                 68 => "00000000",
                                 69 => "00000000",
                                 70 => "00000000",
								 71 => "00000000",
								 
								 72 => "00000000",
                                 73 => "00000000",
                                 74 => "00000000",
                                 75 => "00000000",
                                 76 => "00000000",
                                 77 => "00000000",
                                 78 => "00000000",
								 79 => "00000000",
                                 others => "11111111");	 

 constant letras:       ROM2 := (0 => "00000000",
                                 1 => "00000000",
                                 2 => "00000000",
                                 3 => "00000000",
                                 4 => "00000000",
                                 5 => "00000000",
                                 6 => "00000000",
                                 7 => "00000000",
								 
                                 8 =>  "00000000",
                                 9 =>  "00000000",
                                 10 => "00000000",
                                 11 => "00000000",
                                 12 => "00000000",
                                 13 => "00000000",
                                 14 => "00000000",
								 15 => "00000000", 
								 
								 16 => "00000000",
                                 17 => "00000000",
                                 18 => "00000000",
                                 19 => "00000000",
                                 20 => "00000000",
                                 21 => "00000000",
                                 22 => "00000000",
								 23 => "00000000",
								 
								 24 => "00000000",
                                 25 => "00000000",
                                 26 => "00000000",
                                 27 => "00000000",
                                 28 => "00000000",
                                 29 => "00000000",
                                 30 => "00000000",
								 31 => "00000000",	
								 others => "11111111");	
								 
signal datoNumero: matriz1;
signal datoLetra: matriz2; 

signal banderaContaAnillo: std_logic := '0';
signal buttonOut: std_logic; 
signal sCount: std_logic_vector (3 downto 0); 
signal sCount2: std_logic_vector (3 downto 0); 
signal cuenta: std_logic_vector (3 downto 0);
signal outActiva: std_logic_vector (15 downto 0) := "1111111111111110";							 

begin
---------------------------------------------------------------	
	OSCInst0: OSCH
	generic map ("26.60")
	port map ('0', clk_0);
--------------------------------------------------------------- 
SS0: antiRebote port map (clk_0, button, buttonOut); 

decoderNum: process (cuenta) --Decodifica y asigna letra;
	     begin
		    case sCount is --          
			    when "0000" => datoNumero (0) <= numeros (0); --0	
				               datoNumero (1) <= numeros (1);
							   datoNumero (2) <= numeros (2);
							   datoNumero (3) <= numeros (3);
							   datoNumero (4) <= numeros (4);
							   datoNumero (5) <= numeros (5);
							   datoNumero (6) <= numeros (6);
							   datoNumero (7) <= numeros (7); 
							   -------------------------------
							   datoLetra (0) <= letras (0); --R	
				               datoLetra (1) <= letras (1);
							   datoLetra (2) <= letras (2);
							   datoLetra (3) <= letras (3);
							   datoLetra (4) <= letras (4);
							   datoLetra (5) <= letras (5);
							   datoLetra (6) <= letras (6);
							   datoLetra (7) <= letras (7); 
				
		 	    when "0001" => datoNumero (0) <= numeros (8); --1	
				               datoNumero (1) <= numeros (9);
							   datoNumero (2) <= numeros (10);
							   datoNumero (3) <= numeros (11);
							   datoNumero (4) <= numeros (12);
							   datoNumero (5) <= numeros (13);
							   datoNumero (6) <= numeros (14);
							   datoNumero (7) <= numeros (15);
							   -------------------------------
							   datoLetra (0) <= letras (16); --B	
				               datoLetra (1) <= letras (17);
							   datoLetra (2) <= letras (18);
							   datoLetra (3) <= letras (19);
							   datoLetra (4) <= letras (20);
							   datoLetra (5) <= letras (21);
							   datoLetra (6) <= letras (22);
							   datoLetra (7) <= letras (23); 
				 
			    when "0010" => datoNumero (0) <= numeros (16); --2	
				               datoNumero (1) <= numeros (17);
							   datoNumero (2) <= numeros (18);
							   datoNumero (3) <= numeros (19);
							   datoNumero (4) <= numeros (20);
							   datoNumero (5) <= numeros (21);
							   datoNumero (6) <= numeros (22);
							   datoNumero (7) <= numeros (23); 
							   -------------------------------
							   datoLetra (0) <= letras (24); --Y	
				               datoLetra (1) <= letras (25);
							   datoLetra (2) <= letras (26);
							   datoLetra (3) <= letras (27);
							   datoLetra (4) <= letras (28);
							   datoLetra (5) <= letras (29);
							   datoLetra (6) <= letras (30);
							   datoLetra (7) <= letras (31); 
				
			    when "0011" => datoNumero (0) <= numeros (24); --3	
				               datoNumero (1) <= numeros (25);
							   datoNumero (2) <= numeros (26);
							   datoNumero (3) <= numeros (27);
							   datoNumero (4) <= numeros (28);
							   datoNumero (5) <= numeros (29);
							   datoNumero (6) <= numeros (30);
							   datoNumero (7) <= numeros (31); 
							   -------------------------------
							   datoLetra (0) <= letras (8); -- G	
				               datoLetra (1) <= letras (9);
							   datoLetra (2) <= letras (10);
							   datoLetra (3) <= letras (11);
							   datoLetra (4) <= letras (12);
							   datoLetra (5) <= letras (13);
							   datoLetra (6) <= letras (14);
							   datoLetra (7) <= letras (15); 
				
			    when "0100" => datoNumero (0) <= numeros (32); --4	
				               datoNumero (1) <= numeros (33);
							   datoNumero (2) <= numeros (34);
							   datoNumero (3) <= numeros (35);
							   datoNumero (4) <= numeros (36);
							   datoNumero (5) <= numeros (36);
							   datoNumero (6) <= numeros (38);
							   datoNumero (7) <= numeros (39); 
							   -------------------------------
							   datoLetra (0) <= letras (0); --R	
				               datoLetra (1) <= letras (1);
							   datoLetra (2) <= letras (2);
							   datoLetra (3) <= letras (3);
							   datoLetra (4) <= letras (4);
							   datoLetra (5) <= letras (5);
							   datoLetra (6) <= letras (6);
							   datoLetra (7) <= letras (7); 
							   
			    when "0101" => datoNumero (0) <= numeros (40); --5	
				               datoNumero (1) <= numeros (41);
							   datoNumero (2) <= numeros (42);
							   datoNumero (3) <= numeros (43);
							   datoNumero (4) <= numeros (44);
							   datoNumero (5) <= numeros (45);
							   datoNumero (6) <= numeros (46);
							   datoNumero (7) <= numeros (47);
							   -------------------------------
							   datoLetra (0) <= letras (8); -- G	
				               datoLetra (1) <= letras (9);
							   datoLetra (2) <= letras (10);
							   datoLetra (3) <= letras (11);
							   datoLetra (4) <= letras (12);
							   datoLetra (5) <= letras (13);
							   datoLetra (6) <= letras (14);
							   datoLetra (7) <= letras (15);  
							   
			    when "0110" => datoNumero (0) <= numeros (48); --6
				               datoNumero (1) <= numeros (49);
							   datoNumero (2) <= numeros (50);
							   datoNumero (3) <= numeros (51);
							   datoNumero (4) <= numeros (52);
							   datoNumero (5) <= numeros (53);
							   datoNumero (6) <= numeros (54);
							   datoNumero (7) <= numeros (55); 
							   -------------------------------
							   datoLetra (0) <= letras (16); --B	
				               datoLetra (1) <= letras (17);
							   datoLetra (2) <= letras (18);
							   datoLetra (3) <= letras (19);
							   datoLetra (4) <= letras (20);
							   datoLetra (5) <= letras (21);
							   datoLetra (6) <= letras (22);
							   datoLetra (7) <= letras (23);  
							   
			    when "0111" => datoNumero (0) <= numeros (56); --7	
				               datoNumero (1) <= numeros (57);
							   datoNumero (2) <= numeros (58);
							   datoNumero (3) <= numeros (59);
							   datoNumero (4) <= numeros (60);
							   datoNumero (5) <= numeros (61);
							   datoNumero (6) <= numeros (62);
							   datoNumero (7) <= numeros (63); 
							   -------------------------------
							   datoLetra (0) <= letras (24); --Y	
				               datoLetra (1) <= letras (25);
							   datoLetra (2) <= letras (26);
							   datoLetra (3) <= letras (27);
							   datoLetra (4) <= letras (28);
							   datoLetra (5) <= letras (29);
							   datoLetra (6) <= letras (30);
							   datoLetra (7) <= letras (31);
							   
			    when "1000" => datoNumero (0) <= numeros (64); --8	
				               datoNumero (1) <= numeros (65);
							   datoNumero (2) <= numeros (66);
							   datoNumero (3) <= numeros (67);
							   datoNumero (4) <= numeros (68);
							   datoNumero (5) <= numeros (69);
							   datoNumero (6) <= numeros (70);
							   datoNumero (7) <= numeros (71); 
							   -------------------------------
							   datoLetra (0) <= letras (16); --B	
				               datoLetra (1) <= letras (17);
							   datoLetra (2) <= letras (18);
							   datoLetra (3) <= letras (19);
							   datoLetra (4) <= letras (20);
							   datoLetra (5) <= letras (21);
							   datoLetra (6) <= letras (22);
							   datoLetra (7) <= letras (23); 
							   
			    when "1001" => datoNumero (0) <= numeros (72); --9	
				               datoNumero (1) <= numeros (73);
							   datoNumero (2) <= numeros (74);
							   datoNumero (3) <= numeros (75);
							   datoNumero (4) <= numeros (76);
							   datoNumero (5) <= numeros (77);
							   datoNumero (6) <= numeros (78);
							   datoNumero (7) <= numeros (79); 
							   -------------------------------
							   datoLetra (0) <= letras (8); -- G	
				               datoLetra (1) <= letras (9);
							   datoLetra (2) <= letras (10);
							   datoLetra (3) <= letras (11);
							   datoLetra (4) <= letras (12);
							   datoLetra (5) <= letras (13);
							   datoLetra (6) <= letras (14);
							   datoLetra (7) <= letras (15); 
	 		    when others => null; 
		   end case;
	     end process decoderNum; 
		 
multiplexorMatriz: process (clkLow2, datoNumero, datoLetra)
                   begin 
		              if (banderaContaAnillo = '0') then
		                for i in 0 to 7 loop
			               if (clkLow2'event and clkLow2 = '1') then
			                 salDatoMatriz <= datoLetra (i);
			               end if;
		                end loop;
		              else 
		                for i in 0 to 7 loop
			               if (clkLow2'event and clkLow2 = '1') then
			                 salDatoMatriz <= datoNumero (i);
			               end if;
		                end loop;
		              end if;
                   end process multiplexorMatriz;
							  
contador: process (buttonOut, clkLow, reset)
          begin
	         if (reset = '1') then
		       sCount <= "0000";
	         elsif (buttonOut = '1') then
				  elsif (clkLow'event and clkLow = '1') then
			           if sCount = "1111" then
				         sCount <= "0000";						
			           else
					     sCount <= sCount + 1; 
			           end if;
			      end if;
         end process contador;
		 
contadorVisible: process (buttonOut, clkLow)
                 begin
					if (buttonOut'event and buttonOut = '0') then
					  scount2 <= sCount;
					  for i in 0 to 80000000 loop
						 if (clkLow'event and clkLow = '1') then
						   if sCount2 = "1111" then
				             sCount2 <= "0000";						
			               else
					         sCount2 <= sCount2 + 1; 
			               end if;
						 end if;
					  end loop;
					end if;
				end process contadorVisible;
				cuenta <= sCount2;
						  
contaAnillo: process (clkLow2)
         begin
            if (clkLow2'event and  clkLow2 = '1') then 
		      outActiva(1) <= outActiva(0);
              outActiva(2) <= outActiva(1);
              outActiva(3) <= outActiva(2);
              outActiva(4) <= outActiva(3);
              outActiva(5) <= outActiva(4);
              outActiva(6) <= outActiva(5);
              outActiva(7) <= outActiva(6);
              outActiva(8) <= outActiva(7); 
              outActiva(9) <= outActiva(8);
              outActiva(10) <= outActiva(9);
              outActiva(11) <= outActiva(10);
              outActiva(12) <= outActiva(11);
              outActiva(13) <= outActiva(12);
              outActiva(14) <= outActiva(13);
              outActiva(15) <= outActiva(14);
              outActiva(0) <= outActiva(15);
            end if;
         end process contaAnillo;
         salActivaMatriz <= outActiva; 
		 
banderaContadorAnillo: process (outActiva)
                       begin
						  if (outActiva (8) = '0') then
		 					banderaContaAnillo <= '1';
						  elsif (outActiva (0) = '0') then
							banderaContaAnillo <= '0';
						  end if;
					   end process banderaContadorAnillo;		 
--------------------------------------------		 
P_blink_LED: process (clk_0)
variable count: integer range 0 to 25000000;
begin
	if (clk_0'event and clk_0 = '1') then
	  if (count < 2600000) then --100ms 
		count := count + 1;
	  else
		count := 0;
		clkLow <= not clkLow;
		end if;
	end if;
end process; 

P_blink_LED2: process (clk_0)
variable count: integer range 0 to 540000;
begin
	if (clk_0'event and clk_0 = '1') then
		if (count < 60000) then --2.5ms
			count := count + 1;
		else
			count := 0;
			clkLow2 <= not clkLow2;
		end if;
	end if;
end process;

P_blink_LED3: process (clk_0)
variable count: integer range 0 to 80000000;
begin
	if (clk_0'event and clk_0 = '1') then
		if (count < 80000000) then --3s
			count := count + 1;
		else
			count := 0;
			clkLow3 <= not clkLow3;
		end if;
	end if;
end process;

blinkLED <= clkLow;	
blinkLED2 <= clkLow2;	
blinkLED3 <= clkLow3;	
	 
end proyectoFinal;
