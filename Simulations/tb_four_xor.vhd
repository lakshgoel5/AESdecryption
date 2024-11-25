LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY four_xor_tb IS
END four_xor_tb;

ARCHITECTURE behavior OF four_xor_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT four_xor
        PORT(
            row0       : IN std_logic_vector(31 downto 0);
            row1       : IN std_logic_vector(31 downto 0);
            row2       : IN std_logic_vector(31 downto 0);
            row3       : IN std_logic_vector(31 downto 0);
            
            my_row0    : IN std_logic_vector(31 downto 0);
            my_row1    : IN std_logic_vector(31 downto 0);
            my_row2    : IN std_logic_vector(31 downto 0);
            my_row3    : IN std_logic_vector(31 downto 0);
            
            final_row0 : OUT std_logic_vector(31 downto 0);
            final_row1 : OUT std_logic_vector(31 downto 0);
            final_row2 : OUT std_logic_vector(31 downto 0);
            final_row3 : OUT std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL row0       : std_logic_vector(31 downto 0) := (others => '0');
    SIGNAL row1       : std_logic_vector(31 downto 0) := (others => '0');
    SIGNAL row2       : std_logic_vector(31 downto 0) := (others => '0');
    SIGNAL row3       : std_logic_vector(31 downto 0) := (others => '0');
    
    SIGNAL my_row0    : std_logic_vector(31 downto 0) := (others => '0');
    SIGNAL my_row1    : std_logic_vector(31 downto 0) := (others => '0');
    SIGNAL my_row2    : std_logic_vector(31 downto 0) := (others => '0');
    SIGNAL my_row3    : std_logic_vector(31 downto 0) := (others => '0');
    
    SIGNAL final_row0 : std_logic_vector(31 downto 0);
    SIGNAL final_row1 : std_logic_vector(31 downto 0);
    SIGNAL final_row2 : std_logic_vector(31 downto 0);
    SIGNAL final_row3 : std_logic_vector(31 downto 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: four_xor PORT MAP (
        row0       => row0,
        row1       => row1,
        row2       => row2,
        row3       => row3,
        
        my_row0    => my_row0,
        my_row1    => my_row1,
        my_row2    => my_row2,
        my_row3    => my_row3,
        
        final_row0 => final_row0,
        final_row1 => final_row1,
        final_row2 => final_row2,
        final_row3 => final_row3
    );

    -- Stimulus Process
    stimulus_process : PROCESS
    BEGIN
        -- Initialize rows with test values
        row0    <= X"FFFFFFFF";
        row1    <= X"10001001";
        row2    <= X"12345678";
        row3    <= X"11110101";
        
        my_row0 <= X"FFFFFFFF";
        my_row1 <= X"FFFFFFFF";
        my_row2 <= X"00000000";
        my_row3 <= X"00100100";

        WAIT FOR 10 ns;

        -- Check results
        assert final_row0 = (row0 XOR my_row0) report "final_row0 mismatch" severity error;
        assert final_row1 = (row1 XOR my_row1) report "final_row1 mismatch" severity error;
        assert final_row2 = (row2 XOR my_row2) report "final_row2 mismatch" severity error;
        assert final_row3 = (row3 XOR my_row3) report "final_row3 mismatch" severity error;

        -- Finish the test
        WAIT;
    END PROCESS;

END behavior;
