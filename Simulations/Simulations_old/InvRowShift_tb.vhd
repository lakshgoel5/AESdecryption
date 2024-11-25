library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InvRowShift_tb is
-- No ports in a testbench
end InvRowShift_tb;

architecture Behavioral of InvRowShift_tb is
    -- Signal declarations to connect to the InvRowShift entity
    signal state_in   : std_logic_vector(31 downto 0);
    signal state_out  : std_logic_vector(31 downto 0);
    signal row_number : std_logic_vector(1 downto 0);
    
    -- Component declaration for the unit under test (UUT)
    component InvRowShift
        Port ( state_in   : in  std_logic_vector(31 downto 0);
               state_out  : out std_logic_vector(31 downto 0);
               row_number : in  std_logic_vector(1 downto 0)
             );
    end component;
    
begin

    -- Instantiate the UUT
    uut: InvRowShift port map(
        state_in   => state_in,
        state_out  => state_out,
        row_number => row_number
    );
    
    -- Test process
    stimulus: process
    begin
        -- Test case 1: row_number = "00", apply a test state
        row_number <= "00";
        state_in <= x"00112233"; -- Example 32-bit state input
        wait for 10 ns;
        
        -- Test case 2: row_number = "01", change state input
        row_number <= "01";
        state_in <= x"44556677";
        wait for 10 ns;
        
        -- Test case 3: row_number = "10", apply another test state
        row_number <= "10";
        state_in <= x"8899AABB";
        wait for 10 ns;

        -- Test case 4: row_number = "11"
        row_number <= "11";
        state_in <= x"CCDDEEFF";
        wait for 10 ns;
        
        -- Stop simulation
        wait;
    end process;

end Behavioral;
