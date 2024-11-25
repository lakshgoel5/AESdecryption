library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_xor_check is
    port (
        input_vector : in std_logic_vector(7 downto 0);
        result       : out std_logic_vector(7 downto 0)
    );
end entity shift_xor_check;

architecture behavior of shift_xor_check is
    constant XOR_MASK : std_logic_vector(7 downto 0) := "00011011"; -- 0x1B in binary
    signal shifted    : std_logic_vector(7 downto 0);
    signal old_bit: std_logic;
begin
    process(input_vector)
    begin
        -- Shift the input_vector left by 1 and ignore the overflow
        old_bit <= input_vector(7);
        shifted <= (input_vector(6 downto 0) & '0');  -- Shift left by 1
        end process;
    process(shifted, old_bit)
    begin
        -- Check if the highest bit (7th bit) is set
        if old_bit = '1' then
            -- XOR the shifted vector with 0x1B if the highest bit was set
            result <= shifted xor XOR_MASK;
        else
            -- If highest bit is not set, no XOR, just return shifted vector
            result <= shifted;
        end if;
    end process;
end architecture behavior;