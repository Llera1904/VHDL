library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity multiplicacion6Bits is	
	port (datoA, datoB: in std_logic_vector (5 downto 0);
	      resultado: out std_logic_vector (11 downto 0));
end multiplicacion6Bits;


architecture multiplicacion6Bits of multiplicacion6Bits is	

component sum12Bits is
	port (a: in std_logic_vector (11 downto 0); 
	      b: in std_logic_vector (11 downto 0); Cin: in std_logic;
	      s: out std_logic_vector (11 downto 0); Cout: out std_logic);
end component; 	 

type matrizArr is array (5 downto 0) of std_logic_vector (11 downto 0); -- Matriz de datos
type matrizSalida is array (4 downto 0) of std_logic_vector (11 downto 0); -- Matriz de resultados

signal arr: matrizArr;
signal salida: matrizSalida; 

signal carry: std_logic_vector (4 downto 0);

begin 
	
-- Multiplicacion de bits	
	arr(0)(0) <= datoB(0) and datoA(0);	-- Se pasan directo a la matriz
    arr(0)(1) <= datoB(0) and datoA(1);
	arr(0)(2) <= datoB(0) and datoA(2);
	arr(0)(3) <= datoB(0) and datoA(3);
	arr(0)(4) <= datoB(0) and datoA(4);
	arr(0)(5) <= datoB(0) and datoA(5);  
	
	arr(1)(1) <= datoB(1) and datoA(0);
    arr(1)(2) <= datoB(1) and datoA(1);
	arr(1)(3) <= datoB(1) and datoA(2);
	arr(1)(4) <= datoB(1) and datoA(3);
	arr(1)(5) <= datoB(1) and datoA(4);
	arr(1)(6) <= datoB(1) and datoA(5);  
	
	arr(2)(2) <= datoB(2) and datoA(0);
    arr(2)(3) <= datoB(2) and datoA(1);
	arr(2)(4) <= datoB(2) and datoA(2);
	arr(2)(5) <= datoB(2) and datoA(3);
	arr(2)(6) <= datoB(2) and datoA(4);
	arr(2)(7) <= datoB(2) and datoA(5);  
	
	arr(3)(3) <= datoB(3) and datoA(0);
    arr(3)(4) <= datoB(3) and datoA(1);
	arr(3)(5) <= datoB(3) and datoA(2);
	arr(3)(6) <= datoB(3) and datoA(3);
	arr(3)(7) <= datoB(3) and datoA(4);
	arr(3)(8) <= datoB(3) and datoA(5);  
	
	arr(4)(4) <= datoB(4) and datoA(0);
    arr(4)(5) <= datoB(4) and datoA(1);
	arr(4)(6) <= datoB(4) and datoA(2);
	arr(4)(7) <= datoB(4) and datoA(3);
	arr(4)(8) <= datoB(4) and datoA(4);
	arr(4)(9) <= datoB(4) and datoA(5);  
	
	arr(5)(5) <= datoB(5) and datoA(0);
    arr(5)(6) <= datoB(5) and datoA(1);
	arr(5)(7) <= datoB(5) and datoA(2);
	arr(5)(8) <= datoB(5) and datoA(3);
	arr(5)(9) <= datoB(5) and datoA(4);
	arr(5)(10) <= datoB(5) and datoA(5);  
	
-- Sumas
   S0: sum12Bits port map (arr(0), arr(1), '0', salida(0),carry(0));

   Sumas: for i in 1 to 4 generate 
	         S1: sum12Bits port map (salida(i-1), arr(i+1), carry(i-1), salida(i), carry(i));
          end generate;

   resultado <= salida(4);

end multiplicacion6Bits;