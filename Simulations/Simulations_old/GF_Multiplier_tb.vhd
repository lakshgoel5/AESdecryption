library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GF_Multiplier_tb is
    -- Test bench has no ports
end GF_Multiplier_tb;

architecture Behavioral of GF_Multiplier_tb is
    -- Component declaration for the unit under test (UUT)
    component GF_Multiplier
        Port ( red_input  : in  std_logic_vector(7 downto 0);
               multiplier : in  std_logic_vector(7 downto 0); -- 0x09, 0x0B, 0x0D, 0x0E
               result  : out std_logic_vector(7 downto 0));
    end component;

    -- Test signals
    signal red_input  : std_logic_vector(7 downto 0);
    signal multiplier : std_logic_vector(7 downto 0);
    signal result     : std_logic_vector(7 downto 0);
    
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: GF_Multiplier
        Port map (
            red_input  => red_input,
            multiplier => multiplier,
            result     => result
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Multiply by 0x09
        red_input <= x"57";       -- Example value to be multiplied
        multiplier <= x"09";      -- Multiplier 0x09
        wait for 100 ns;          -- Wait for result
        
        -- Test case 2: Multiply by 0x0B
        red_input <= x"57";       -- Example value to be multiplied
        multiplier <= x"0B";      -- Multiplier 0x0B
        wait for 100 ns;          -- Wait for result
        
        -- Test case 3: Multiply by 0x0D
        red_input <= x"57";       -- Example value to be multiplied
        multiplier <= x"0D";      -- Multiplier 0x0D
        wait for 100 ns;          -- Wait for result
        
        -- Test case 4: Multiply by 0x0E
        red_input <= x"57";       -- Example value to be multiplied
        multiplier <= x"0E";      -- Multiplier 0x0E
        wait for 100 ns;   
        red_input <= x"4A";       -- Example value to be multiplied
        multiplier <= x"09";      -- Multiplier 0x09
        wait for 100 ns;          -- Wait for result
        
        -- Test case 2: Multiply by 0x0B
        red_input <= x"4A";       -- Example value to be multiplied
        multiplier <= x"0B";      -- Multiplier 0x0B
        wait for 100 ns;          -- Wait for result
        
        -- Test case 3: Multiply by 0x0D
        red_input <= x"4A";       -- Example value to be multiplied
        multiplier <= x"0D";      -- Multiplier 0x0D
        wait for 100 ns;          -- Wait for result
        
        -- Test case 4: Multiply by 0x0E
        red_input <= x"4A";       -- Example value to be multiplied
        multiplier <= x"0E";      -- Multiplier 0x0E
        wait for 100 ns;        -- Wait for result

        -- Finish simulation
        wait;
    end process;

end Behavioral;
