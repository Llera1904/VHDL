library ieee;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity maquinaMily is 
	port (clk, reset, X : in std_logic;
	      Z: out std_logic);
end maquinaMily;

architecture maquinaMily of maquinaMily is	 
type estados is (S0, S1, S2, S3);

signal presentState: estados := S0;
signal nextState: estados;

begin
	
	process (clk)
	begin
		if rising_edge(clk) then
		  if (reset = '1') then
			presentState <= S0;
		  else
			presentState <= nextState;
		  end if;
		end if;
	end process;
	
	process (clk)
	begin
		if (clk'event and clk = '1') then
		  case presentState is 
			  when S0 => if (X = '0') then 
				           nextState <= S1;	Z <= '0';
			             else 
				           nextState <= S2; Z <= '1'; 
				  		 end if;
			  when S1 => Z <= '0'; 
			             if (X = '0') then 
				           nextState <= S3;	
				  		 end if;
			  when S2 => if (X = '1') then 
				           nextState <= S3; Z <= '0';
			             else 
				           Z <= '1';
				  		 end if;
			  when S3 => Z <= '1'; 
			             if (X = '1') then 
				           nextState <= S0;	
				  		 end if;
		   end case;
		end if;
	end process;
						   
end maquinaMily;
