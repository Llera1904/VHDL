library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ROM is  
	port (CLK : in std_logic;
	      reset : in std_logic;
		  enable : in std_logic;
		  read : in std_logic;
		  address : in std_logic_vector (4 downto 0);
		  dataOut : out std_logic_vector (7 downto 0));
end ROM;

architecture ROM of ROM is 

type ROM_Array is Array (0 to 31)
of std_logic_vector (7 downto 0);

constant Content : ROM_Array := (0 => "00000000",
                                 1 => "00000000",
                                 2 => "00000000",
                                 3 => "00000000",
                                 4 => "00000000",
                                 5 => "00000000",
                                 6 => "00000000",
                                 7 => "00000000",
                                 8 => "00000000",
                                 9 => "00000000",
                                 10 => "00000000",
                                 11 => "00000000",
                                 12 => "00000000",
                                 13 => "00000000",
                                 14 => "00000000",
                                 others => "11111111");


begin  
	
	process (CLK, reset, enable, read, address)
	begin
		if (reset = '1') then
		  dataOut <= "ZZZZZZZZ";
		elsif (CLK'event and CLK = '1') then
		  if enable = '1' then
			dataOut <= Content (conv_integer(address));
		  else 
			dataOut	<= "ZZZZZZZZ";
		  end if;
		end if;	 
	end process;	

end ROM;
