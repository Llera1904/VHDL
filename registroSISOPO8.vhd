library IEEE;
use IEEE.std_logic_1164.all;

entity registroSISOPO8 is 
	port (D, C, SOPO: in std_logic;
	      SP: out std_logic_vector (7 downto 0);
	      SS: out std_logic);
end registroSISOPO8;

architecture registroSISOPO8 of registroSISOPO8 is 	
signal sParcial: std_logic_vector (7 downto 0);
begin
	
	process (D, C)
    begin   
	   if (C'event and C= '1')then
	     sParcial(0) <= D;
	   end if;
	end process;   
		
	process (D, C)
    begin 
	   if (C'event and C= '1')then
		 sParcial(1) <= sParcial(0);	 
	   end if;
	end process;
		  
    process (D, C)
	begin  
	   if (C'event and C= '1')then
	     sParcial(2)<= sParcial(1);
	   end if;
	end process;
		  
    process (D, C)
	begin  
       if (C'event and C= '1')then
	     sParcial(3)<= sParcial(2);
	   end if;
	end process;
		  
    process (D, C)
    begin 
	   if (C'event and C= '1')then
	     sParcial(4)<= sParcial(3); 
	   end if;
	end process;
		  
    process (D, C)
	begin  
	   if (C'event and C= '1')then
		 sParcial(5)<= sParcial(4);
	   end if;
	end process;
		  
	process (D, C)
    begin 
	   if (C'event and C= '1')then
	     sParcial(6)<= sParcial(5);
	   end if;
	end process;
		  
    process (D, C)
	begin 
	   if (C'event and C= '1')then
	     sParcial(7)<= sParcial(6); 
	   end if;
	end process;		 
		
    process (SOPO)
    begin
	   if (SOPO= '0') then
	 	 SS<= sparcial(7);
	   else 
		 SP<= sParcial;
	   end if;
	end process;
	
end registroSISOPO8;
