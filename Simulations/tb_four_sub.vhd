library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_four_subbytes is
end tb_four_subbytes;

architecture Behavioral of tb_four_subbytes is

    -- Component declaration of the DUT (Device Under Test)
    component four_subbytes
        Port (
            clk          : in std_logic;
            start          : in std_logic;
            input_row_0  : in std_logic_vector(31 downto 0);
            input_row_1  : in std_logic_vector(31 downto 0);
            input_row_2  : in std_logic_vector(31 downto 0);
            input_row_3  : in std_logic_vector(31 downto 0);

            output_row_0 : out std_logic_vector(31 downto 0);
            output_row_1 : out std_logic_vector(31 downto 0);
            output_row_2 : out std_logic_vector(31 downto 0);
            output_row_3 : out std_logic_vector(31 downto 0);
            subbox_done  : out std_logic
        );
    end component;

    -- Testbench signals
    signal clk_tb          : std_logic := '0';
    signal input_row_0_tb  : std_logic_vector(31 downto 0) := x"01020304";
    signal input_row_1_tb  : std_logic_vector(31 downto 0) := x"05060708";
    signal input_row_2_tb  : std_logic_vector(31 downto 0) := x"090A0B0C";
    signal input_row_3_tb  : std_logic_vector(31 downto 0) := x"0D0E0F10";

    signal output_row_0_tb : std_logic_vector(31 downto 0);
    signal output_row_1_tb : std_logic_vector(31 downto 0);
    signal output_row_2_tb : std_logic_vector(31 downto 0);
    signal output_row_3_tb : std_logic_vector(31 downto 0);
    signal subbox_done_tb  : std_logic;
    signal start  : std_logic:='0';

    constant clk_period : time := 10 ns;

begin
    -- DUT instantiation
    DUT: four_subbytes
        Port map (
            clk          => clk_tb,
            start => start,
            input_row_0  => input_row_0_tb,
            input_row_1  => input_row_1_tb,
            input_row_2  => input_row_2_tb,
            input_row_3  => input_row_3_tb,

            output_row_0 => output_row_0_tb,
            output_row_1 => output_row_1_tb,
            output_row_2 => output_row_2_tb,
            output_row_3 => output_row_3_tb,
            subbox_done  => subbox_done_tb
        );

    -- Clock generation
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process
    stim_proc: process
    begin
        -- Initialize inputs
        wait for 20 ns;
        start <='1';
        -- Wait for processing to complete
        wait until subbox_done_tb = '1';
        wait for 100 ns;
        start <='0';
        -- Check output values
        -- Insert any assertions or checks as required for verification
--        report "Output Row 0: " & std_logic_vector(output_row_0_tb);
--        report "Output Row 1: " & std_logic_vector(output_row_1_tb);
--        report "Output Row 2: " & std_logic_vector(output_row_2_tb);
--        report "Output Row 3: " & std_logic_vector(output_row_3_tb);

        wait for 20 ns;
        assert subbox_done_tb = '1' report "Subbox processing not completed correctly." severity error;

        -- End simulation
        wait;
    end process;

end Behavioral;