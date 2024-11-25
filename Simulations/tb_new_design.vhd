library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_new_design is
end tb_new_design;

architecture Behavioral of tb_new_design is
    -- Component declaration of the unit under test (UUT)
    component new_design
        Port (
            string1 : in  STD_LOGIC_VECTOR(31 downto 0);
            string2 : in  STD_LOGIC_VECTOR(31 downto 0);
            string3 : in  STD_LOGIC_VECTOR(31 downto 0);
            string4 : in  STD_LOGIC_VECTOR(31 downto 0);
            f_cathode : out std_logic_vector(7 downto 0);
            f_anode : out std_logic_vector(3 downto 0);
            clk : in std_logic;
            display_seg : out  STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Testbench signals
    signal display :  STD_LOGIC_VECTOR(31 downto 0);
    signal tb_string1 : STD_LOGIC_VECTOR(31 downto 0) := X"11111111";
    signal tb_string2 : STD_LOGIC_VECTOR(31 downto 0) := X"22222222";
    signal tb_string3 : STD_LOGIC_VECTOR(31 downto 0) := X"33333333";
    signal tb_string4 : STD_LOGIC_VECTOR(31 downto 0) := X"44444444";
    signal tb_f_cathode : std_logic_vector(7 downto 0);
    signal tb_f_anode : std_logic_vector(3 downto 0);
    signal tb_clk : std_logic := '0';

    constant clk_period : time := 10 ns;  -- Adjust to match the FPGA clock

begin
    -- Instantiate the unit under test (UUT)
    uut: new_design
        Port map (
            string1 => tb_string1,
            string2 => tb_string2,
            string3 => tb_string3,
            string4 => tb_string4,
            f_cathode => tb_f_cathode,
            f_anode => tb_f_anode,
            clk => tb_clk,
            display_seg => display
        );

    -- Clock generation process
    clk_process : process
    begin
        tb_clk <= '0';
        wait for clk_period / 2;
        tb_clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process to monitor display segment changes
    test_process : process
        variable change_count : integer := 0;  -- Counts segment changes
    begin
        -- Wait for a few clock cycles to initialize
        wait for clk_period * 20;

        -- Monitor for 2 seconds display change as per counter timing logic
        for i in 0 to 5 loop
            wait for 2 sec;  -- Wait for the segment change interval
            report "Display segment changed to: " & integer'image(change_count);
            change_count := change_count + 1;
        end loop;

        -- Finish simulation
        report "Simulation complete" severity note;
        wait;
    end process;
end Behavioral;