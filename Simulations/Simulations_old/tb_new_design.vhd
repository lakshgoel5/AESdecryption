library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_new_design is
end tb_new_design;

architecture Behavioral of tb_new_design is

    -- Component declaration for the unit under test (UUT)
    component new_design is
        Port (
            string : in  STD_LOGIC_VECTOR(127 downto 0);
            f_cathode : out std_logic_vector(7 downto 0);
            f_anode : out std_logic_vector(3 downto 0);
            clk : in std_logic
        );
    end component;

    -- Testbench signals
    signal string_tb : STD_LOGIC_VECTOR(127 downto 0) := X"32343638414346636642453130323735";  -- 16 hex characters
    signal f_cathode_tb : std_logic_vector(7 downto 0);
    signal f_anode_tb : std_logic_vector(3 downto 0);
    signal clk_tb : std_logic := '0';

    -- Clock period for 100 MHz
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: new_design
        Port map (
            string => string_tb,
            f_cathode => f_cathode_tb,
            f_anode => f_anode_tb,
            clk => clk_tb
        );

    -- Clock process definition (100 MHz)
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process to monitor the output
    stim_proc: process
    begin
        -- Wait for a few clock cycles to allow the scrolling to start
        wait for 50 ms;  -- Simulate for 50 ms to observe scrolling

        -- Stop simulation after enough time to observe several shifts
        wait;
    end process;

end Behavioral;