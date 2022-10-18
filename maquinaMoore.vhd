library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity maquinaMoore is 
	port (clk, reset, X : in std_logic;
	      Z: out std_logic);
end maquinaMoore;

architecture maquinaMoore of maquinaMoore is

type estados is (A, B, C, D);

signal presentState: estados := A;
signal nextState: estados;

begin 
	
	process (clk)
	begin
		if rising_edge(clk) then
		  if (reset = '1') then
			presentState <= A;
		  else
			presentState <= nextState;
		  end if;
		end if;
	end process;
	
	process (clk)
	begin
		if (clk'event and clk = '1') then
		  case presentState is 
			  when A => Z <= '0'; if (X = '1') then 
				                    nextState <= B; 
				  		          end if;
			  when B => Z <= '0'; if (X = '1') then 
				                    nextState <= C; 	
				  		          end if;
			  when C => Z <= '0'; if (X = '1') then 
				                    nextState <= D; 
				  		          end if;
			  when D => Z <= '1'; if (X = '1') then 
				                    nextState <= B;	
						          else
						            nextState <= A;
				  		          end if;
		   end case;
		end if;
	end process;

	

end maquinaMoore;
