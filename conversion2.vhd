library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;	 

entity conversion2 is
	PORT(num_bin: in STD_LOGIC_VECTOR (13 downto 0);
         num_bcd: out STD_LOGIC_VECTOR (15 downto 0));
end conversion2;	

architecture Behavioral of conversion2 is
begin 
	
	proceso_bcd: process(num_bin) 
                 variable z: STD_LOGIC_VECTOR(29 downto 0);
                 begin 
					 -- Inicialización de datos en cero.
                     z := (others => '0');
                     -- Se realizan los primeros tres corrimientos
                     z(16 downto 3) := num_bin;
                     for i in 0 to 11 loop 
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
end Behavioral;