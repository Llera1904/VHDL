library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity decBcd2 is
	port (D, C, B, A: in std_logic;	--Entradas en binario;
	      TL, SEL_DISP: in std_logic; --TL: test led, Comprueba que el display no tenga leds fundidos; SEL_DISP: Elije el tipo de display;
	      da, db, dc, dd, de, df, dg: out std_logic); --Salidas al 7 segmentos;
end decBcd2;



architecture decBcd2 of decBcd2 is

signal DATO: std_logic_vector (3 downto 0);
signal OCHO: std_logic_vector (3 downto 0);
signal DATO_DECO: std_logic_vector (3 downto 0);
signal display: std_logic_vector (6 downto 0); --a, b, c, d, e, f, g;

begin
	
	DATO (3) <= D; DATO (2) <= C; DATO (1) <= B; DATO (0) <=A;
	OCHO <= "1000";
	
	multiplexor: process (DATO, OCHO, TL)-- Hace el test;
	begin
		if (TL= '0') then
			DATO_DECO <= OCHO;
		else
			DATO_DECO <= DATO;
		end if;
	end process multiplexor;
	
	decoder: process (DATO_DECO)--Decodifica;
	begin
		case DATO_DECO is --          abcdefg
			when "0000" => display <="1111110"; --0
		 	when "0001" => display <="0110000"; --1
			when "0010" => display <="1101101"; --2
			when "0011" => display <="1111001"; --3
			when "0100" => display <="0110011"; --4
			when "0101" => display <="1011011"; --5
			when "0110" => display <="1011111"; --6
			when "0111" => display <="1110000"; --7
			when "1000" => display <="1111111"; --8
			when "1001" => display <="1111011"; --9
			when "1010" => display <="1110111"; --A
			when "1011" => display <="0011111"; --b
			when "1100" => display <="1001110"; --C
			when "1101" => display <="0111101"; --d
			when "1110" => display <="1001111"; --E
	 		when others => display <= "1000111"; --F
		end case;
	end process decoder;
	
	xor_inversor: process (display, SEL_DISP)--Invierte la tabla;
	begin
		da <= display (6) xor SEL_DISP;
		db <= display (5) xor SEL_DISP;
		dc <= display (4) xor SEL_DISP;
		dd <= display (3) xor SEL_DISP;
		de <= display (2) xor SEL_DISP;
		df <= display (1) xor SEL_DISP;
		dg <= display (0) xor SEL_DISP;
	end process xor_inversor;
			
end decBcd2; 
