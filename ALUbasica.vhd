library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;	 

entity ALUbasica is	
	port (S: in std_logic_vector (1 downto 0); 
	      datoA, datoB: in std_logic_vector (2 downto 0);
	      salida: out std_logic_vector (3 downto 0));
	     
end ALUbasica;

architecture ALUbasica of ALUbasica is	

signal comp2: std_logic_vector (3 downto 0);

begin 
	
	comp2 <= '0' & datoA;
	
	process (S)
	begin 
		case (S) is
			when "00" => salida <= '0' & (datoA and datoB); 
			when "01" => salida <= '0' & (datoA or datoB);
			when "10" => salida <= '0' & (not datoA);
			when "11" => salida <= (not comp2) + 1;
			when others => salida <= "0000";  
	    end case;
	end process;  
		  		
end ALUbasica;