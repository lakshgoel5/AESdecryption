library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_design is
-- Testbench does not have ports
end tb_design;

architecture Behavioral of tb_design is

    -- Component declaration for the DUT (Device Under Test)
    component design
        Port (
            f_d1 : in std_logic_vector(7 downto 0);
            f_d2 : in std_logic_vector(7 downto 0);
            f_d3 : in std_logic_vector(7 downto 0);
            f_d4 : in std_logic_vector(7 downto 0);
            f_cathode : out std_logic_vector(7 downto 0);
            f_anode : out std_logic_vector(3 downto 0);
            clk_in_1: in std_logic
        );
    end component;

    -- Signals to connect to DUT
    signal f_d1, f_d2, f_d3, f_d4 : std_logic_vector(7 downto 0) := (others => '0');
    signal f_cathode : std_logic_vector(7 downto 0);
    signal f_anode : std_logic_vector(3 downto 0);
    signal clk_in_1 : std_logic := '0';

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the DUT
    DUT: design
        Port map (
            f_d1 => f_d1,
            f_d2 => f_d2,
            f_d3 => f_d3,
            f_d4 => f_d4,
            f_cathode => f_cathode,
            f_anode => f_anode,
            clk_in_1 => clk_in_1
        );

    -- Clock process definitions
    clk_process : process
    begin
        while True loop
            clk_in_1 <= '0';
            wait for clk_period/2;
            clk_in_1 <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Test case 1: Set inputs to known values
        f_d1 <= X"41";  -- ASCII for 'A'
        f_d2 <= X"42";  -- ASCII for 'B'
        f_d3 <= X"43";  -- ASCII for 'C'
        f_d4 <= X"44";  -- ASCII for 'D'
        wait for 400 ns; -- Wait to observe changes

        -- Test case 2: Change inputs
        f_d1 <= X"23";  -- ASCII for '0'
        f_d2 <= X"31";  -- ASCII for '1'
        f_d3 <= X"32";  -- ASCII for '2'
        f_d4 <= X"33";  -- ASCII for '3'
        wait for 20 ns;

        -- Add more test cases as needed

        wait; -- Wait indefinitely to observe the simulation
    end process;

end Behavioral;