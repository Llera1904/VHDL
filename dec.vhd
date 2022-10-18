library IEEE;
use IEEE.std_logic_1164.all;

entity dec is
	port (I: in std_logic_vector (1 downto 0);
	      O: out std_logic_vector (3 downto 0));	      
end dec;

architecture dec of dec is
begin
	
	process (I) begin
		case I is
			when "00" => O <= "0001";
            when "01" => O <= "0010";
            when "10" => O <= "0100";
            when "11" => O <= "1000";
            when others => O <= "0000";
        end case; 
	end process;

end dec;
