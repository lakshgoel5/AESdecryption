library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_for_eight is
    Port ( input1  : in  std_logic_vector(7 downto 0); -- State
           input2  : in  std_logic_vector(7 downto 0); -- Round Key
           result  : out std_logic_vector(7 downto 0)
           );
end xor_for_eight;


architecture Behavioral of xor_for_eight is
    
begin
result <= input1 xor input2;

end Behavioral;
