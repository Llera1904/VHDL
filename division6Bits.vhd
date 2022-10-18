library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity division6Bits is
    Port (Ain : in  STD_LOGIC_VECTOR (5 downto 0);
          Bin : in  STD_LOGIC_VECTOR (5 downto 0);
          Q : out  STD_LOGIC_VECTOR (5 downto 0);
          R : out  STD_LOGIC_VECTOR (5 downto 0));
end division6Bits;

architecture Behavioral of division6Bits is
begin

  Proc1 : process (Ain, Bin) is
	      variable N : integer range 0 to 100;
          variable cnt   : std_logic_vector(5 downto 0);
          variable Atemp : std_logic_vector(5 downto 0);
          begin
		      N := 0;
		      cnt   := "000000";
		      Atemp := Ain;
		      while (Atemp >= Bin) loop
		           exit when N = 100;
		           Atemp := (Atemp - Bin);
		           cnt   := cnt + "000001";
		           N := N + 1;
		      end loop;
		      Q <= cnt;
		      R <= Atemp;
           end process Proc1;

end Behavioral;

