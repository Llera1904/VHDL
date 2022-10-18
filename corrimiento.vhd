library IEEE;
use IEEE.std_logic_1164.all;

entity corrimiento is
	port (A : in std_logic_vector (7 downto 0);
	      B	: in std_logic_vector (2 downto 0); 
		  hold, load, LR : in std_logic;
		  C : out std_logic_vector (7 downto 0));
end corrimiento;

architecture corrimiento of corrimiento is
begin
	
	process (A, load) 
	begin
		if (load= '1') then
	      C<= A;
	    end if;     
	end process; 
	
	process (A, B, LR, hold) 
	begin
		if (hold= '0') then
		  if (LR= '0') then	--
		    case B is
			  when "000"=> null;
			  when "001"=> C <= A(6 downto 0) & A(7);
			  when "010"=> C <= A(5 downto 0) & A(7 downto 6);
			  when "011"=> C <= A(4 downto 0) & A(7 downto 5);
			  when "100"=> C <= A(3 downto 0) & A(7 downto 4);
			  when "101"=> C <= A(2 downto 0) & A(7 downto 3);
			  when "110"=> C <= A(1 downto 0) & A(7 downto 2);
			  when "111"=> C <= A(0) & A(7 downto 1); 
			  when others => null;
		    end case;
	       else             --
		    case B is 
			  when "000"=> null;
			  when "001"=> C <= A(0) & A(7 downto 1);
			  when "010"=> C <= A(1 downto 0) & A(7 downto 2);
			  when "011"=> C <= A(2 downto 0) & A(7 downto 3);
			  when "100"=> C <= A(3 downto 0) & A(7 downto 4);
			  when "101"=> C <= A(4 downto 0) & A(7 downto 5);
			  when "110"=> C <= A(5 downto 0) & A(7 downto 6);
			  when "111"=> C <= A(6 downto 0) & A(7);
			  when others => null;
		    end case;
	      end if; 
		end if;
	 end process;
	 
end corrimiento;
