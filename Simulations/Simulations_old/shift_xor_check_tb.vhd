library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_xor_check_tb is
    -- Test bench has no ports
end entity shift_xor_check_tb;

architecture behavior of shift_xor_check_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component shift_xor_check
        port (
            input_vector : in std_logic_vector(7 downto 0);
            result       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Test signals
    signal input_vector : std_logic_vector(7 downto 0);
    signal result       : std_logic_vector(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: shift_xor_check
        port map (
            input_vector => input_vector,
            result       => result
        );

    -- Stimulus process to apply test cases
    stim_proc: process
    begin
        -- Test case 1: Input vector with highest bit set (should trigger XOR with 0x1B)
        input_vector <= "00000001";  -- Equivalent to 0x80
        wait for 100 ns;
        
        -- Test case 2: Input vector without highest bit set (no XOR should happen)
        input_vector <= "10000000";  -- Equivalent to 0x7F
        wait for 100 ns;

        -- Test case 3: Input vector with random value (highest bit set)
        input_vector <= "11001010";  -- Equivalent to 0xCA
        wait for 100 ns;

        -- Test case 4: Input vector with another random value (highest bit not set)
        input_vector <= "00100101";  -- Equivalent to 0x25
        wait for 100 ns;
        
        -- Add more test cases if needed, or apply boundary conditions
        
        -- Finish simulation
        wait;
    end process;

end architecture behavior;
