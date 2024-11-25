library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ascii_decoder_tb is
end ascii_decoder_tb;

architecture testbench of ascii_decoder_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component ascii_decoder
        Port (
            hex_input : in STD_LOGIC_VECTOR(7 downto 0);
            bin_output : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Signals for inputs and outputs
    signal hex_input : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal bin_output : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ascii_decoder Port map (
        hex_input => hex_input,
        bin_output => bin_output
    );

    -- Stimulus Process
    stim_proc: process
    begin
        -- Testing numbers 0-9
        hex_input <= x"30"; wait for 10 ns;  -- Expect bin_output = "0000" for 0
        hex_input <= x"31"; wait for 10 ns;  -- Expect bin_output = "0001" for 1
        hex_input <= x"32"; wait for 10 ns;  -- Expect bin_output = "0010" for 2
        hex_input <= x"33"; wait for 10 ns;  -- Expect bin_output = "0011" for 3
        hex_input <= x"34"; wait for 10 ns;  -- Expect bin_output = "0100" for 4
        hex_input <= x"35"; wait for 10 ns;  -- Expect bin_output = "0101" for 5
        hex_input <= x"36"; wait for 10 ns;  -- Expect bin_output = "0110" for 6
        hex_input <= x"37"; wait for 10 ns;  -- Expect bin_output = "0111" for 7
        hex_input <= x"38"; wait for 10 ns;  -- Expect bin_output = "1000" for 8
        hex_input <= x"39"; wait for 10 ns;  -- Expect bin_output = "1001" for 9

        -- Testing uppercase A-F
        hex_input <= x"41"; wait for 10 ns;  -- Expect bin_output = "1010" for A
        hex_input <= x"42"; wait for 10 ns;  -- Expect bin_output = "1011" for B
        hex_input <= x"43"; wait for 10 ns;  -- Expect bin_output = "1100" for C
        hex_input <= x"44"; wait for 10 ns;  -- Expect bin_output = "1101" for D
        hex_input <= x"45"; wait for 10 ns;  -- Expect bin_output = "1110" for E
        hex_input <= x"46"; wait for 10 ns;  -- Expect bin_output = "1111" for F

        -- Testing lowercase a-f
        hex_input <= x"61"; wait for 10 ns;  -- Expect bin_output = "1010" for a
        hex_input <= x"62"; wait for 10 ns;  -- Expect bin_output = "1011" for b
        hex_input <= x"63"; wait for 10 ns;  -- Expect bin_output = "1100" for c
        hex_input <= x"64"; wait for 10 ns;  -- Expect bin_output = "1101" for d
        hex_input <= x"65"; wait for 10 ns;  -- Expect bin_output = "1110" for e
        hex_input <= x"66"; wait for 10 ns;  -- Expect bin_output = "1111" for f

        -- Testing invalid input
        hex_input <= x"FF"; wait for 10 ns;  -- Expect bin_output = "XXXX" for invalid

        -- Finish simulation
        wait;
    end process;
end testbench;