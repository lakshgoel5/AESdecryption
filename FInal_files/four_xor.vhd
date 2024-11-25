library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity four_xor is
    Port (
        -- Input rows
        row0    : in std_logic_vector(31 downto 0);
        row1    : in std_logic_vector(31 downto 0);
        row2    : in std_logic_vector(31 downto 0);
        row3    : in std_logic_vector(31 downto 0);
        
        -- Second set of input rows to XOR with
        my_row0 : in std_logic_vector(31 downto 0);
        my_row1 : in std_logic_vector(31 downto 0);
        my_row2 : in std_logic_vector(31 downto 0);
        my_row3 : in std_logic_vector(31 downto 0);
        
        -- Output rows
        final_row0 : out std_logic_vector(31 downto 0);
        final_row1 : out std_logic_vector(31 downto 0);
        final_row2 : out std_logic_vector(31 downto 0);
        final_row3 : out std_logic_vector(31 downto 0)
    );
end four_xor;

architecture Behavioral of four_xor is
begin

    -- Perform XOR operation on each pair of rows and assign to final rows
    final_row0 <= row0 xor my_row0;
    final_row1 <= row1 xor my_row1;
    final_row2 <= row2 xor my_row2;
    final_row3 <= row3 xor my_row3;

end Behavioral;
