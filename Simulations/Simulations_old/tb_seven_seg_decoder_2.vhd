library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_seven_seg_decoder_2 is
-- Testbench has no ports
end tb_seven_seg_decoder_2;

architecture test of tb_seven_seg_decoder_2 is
    -- Component declaration of the Unit Under Test (UUT)
    component seven_seg_decoder_2
        Port (
            variables : in STD_LOGIC_VECTOR (3 downto 0);
            cathodes : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal variables : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal cathodes : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: seven_seg_decoder_2
        Port map (
            variables => variables,
            cathodes => cathodes
        );

    -- Test process
    process
    begin
        -- Test case 1: Undefined state (all don't-care bits)
        variables <= "----";
        wait for 10 ns;
        assert (cathodes = "11111101") report "Test case 1 failed" severity error;

        -- Test case 2: 0000 (Expected: cathode pattern for '0')
        variables <= "0000";
        wait for 10 ns;
        assert (cathodes = "00111111") report "Test case 2 failed" severity error;

        -- Test case 3: 0001 (Expected: cathode pattern for '1')
        variables <= "0001";
        wait for 10 ns;
        assert (cathodes = "00000110") report "Test case 3 failed" severity error;

        -- Test case 4: 0010 (Expected: cathode pattern for '2')
        variables <= "0010";
        wait for 10 ns;
        assert (cathodes = "01011011") report "Test case 4 failed" severity error;

        -- Test case 5: 0011 (Expected: cathode pattern for '3')
        variables <= "0011";
        wait for 10 ns;
        assert (cathodes = "01001111") report "Test case 5 failed" severity error;

        -- Test case 6: 0100 (Expected: cathode pattern for '4')
        variables <= "0100";
        wait for 10 ns;
        assert (cathodes = "01100110") report "Test case 6 failed" severity error;

        -- Test case 7: 0101 (Expected: cathode pattern for '5')
        variables <= "0101";
        wait for 10 ns;
        assert (cathodes = "01101101") report "Test case 7 failed" severity error;

        -- Test case 8: 0110 (Expected: cathode pattern for '6')
        variables <= "0110";
        wait for 10 ns;
        assert (cathodes = "01111101") report "Test case 8 failed" severity error;

        -- Test case 9: 0111 (Expected: cathode pattern for '7')
        variables <= "0111";
        wait for 10 ns;
        assert (cathodes = "00000111") report "Test case 9 failed" severity error;

        -- Test case 10: 1000 (Expected: cathode pattern for '8')
        variables <= "1000";
        wait for 10 ns;
        assert (cathodes = "01111111") report "Test case 10 failed" severity error;

        -- Test case 11: 1001 (Expected: cathode pattern for '9')
        variables <= "1001";
        wait for 10 ns;
        assert (cathodes = "01101111") report "Test case 11 failed" severity error;

        -- Complete simulation
        wait;
    end process;

end test;
