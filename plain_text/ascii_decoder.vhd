library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ascii_decoder is
    Port (
        hex_input : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit hex input
        bin_output : out STD_LOGIC_VECTOR(3 downto 0)  -- 4-bit binary output
    );
end ascii_decoder;

architecture Behavioral of ascii_decoder is
begin
    process(hex_input)
    begin
        case hex_input is
            -- Map hex 30 to 39 to binary 0 to 9
            when x"30" => bin_output <= "0000"; -- 0
            when x"31" => bin_output <= "0001"; -- 1
            when x"32" => bin_output <= "0010"; -- 2
            when x"33" => bin_output <= "0011"; -- 3
            when x"34" => bin_output <= "0100"; -- 4
            when x"35" => bin_output <= "0101"; -- 5
            when x"36" => bin_output <= "0110"; -- 6
            when x"37" => bin_output <= "0111"; -- 7
            when x"38" => bin_output <= "1000"; -- 8
            when x"39" => bin_output <= "1001"; -- 9
            
            -- Map hex 41 to 46 to binary A to F (uppercase)
            when x"41" => bin_output <= "1010"; -- A
            when x"42" => bin_output <= "1011"; -- B
            when x"43" => bin_output <= "1100"; -- C
            when x"44" => bin_output <= "1101"; -- D
            when x"45" => bin_output <= "1110"; -- E
            when x"46" => bin_output <= "1111"; -- F
            
            -- Map hex 61 to 66 to binary A to F (lowercase)
            when x"61" => bin_output <= "1010"; -- a
            when x"62" => bin_output <= "1011"; -- b
            when x"63" => bin_output <= "1100"; -- c
            when x"64" => bin_output <= "1101"; -- d
            when x"65" => bin_output <= "1110"; -- e
            when x"66" => bin_output <= "1111"; -- f
            
            -- Default case for invalid inputs
            when others => bin_output <= "----"; -- Invalid input
        end case;
    end process;
end Behavioral;