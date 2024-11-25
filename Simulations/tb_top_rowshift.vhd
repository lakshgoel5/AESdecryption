library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_four_row is
end tb_four_row;

architecture Behavioral of tb_four_row is

    -- Signals for DUT (Device Under Test)
    signal input_signal_0 : std_logic_vector(31 downto 0) := (others => '0');
    signal input_signal_1 : std_logic_vector(31 downto 0) := (others => '0');
    signal input_signal_2 : std_logic_vector(31 downto 0) := (others => '0');
    signal input_signal_3 : std_logic_vector(31 downto 0) := (others => '0');
    
    signal output_signal_0 : std_logic_vector(31 downto 0);
    signal output_signal_1 : std_logic_vector(31 downto 0);
    signal output_signal_2 : std_logic_vector(31 downto 0);
    signal output_signal_3 : std_logic_vector(31 downto 0);

    -- Instantiate the Unit Under Test (UUT)
    component four_row
        Port (
            input_signal_0 : in std_logic_vector(31 downto 0);
            input_signal_1 : in std_logic_vector(31 downto 0);
            input_signal_2 : in std_logic_vector(31 downto 0);
            input_signal_3 : in std_logic_vector(31 downto 0);
            output_signal_0 : out std_logic_vector(31 downto 0);
            output_signal_1 : out std_logic_vector(31 downto 0);
            output_signal_2 : out std_logic_vector(31 downto 0);
            output_signal_3 : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Instantiate the DUT
    uut: four_row port map (
        input_signal_0 => input_signal_0,
        input_signal_1 => input_signal_1,
        input_signal_2 => input_signal_2,
        input_signal_3 => input_signal_3,
        output_signal_0 => output_signal_0,
        output_signal_1 => output_signal_1,
        output_signal_2 => output_signal_2,
        output_signal_3 => output_signal_3
    );

    -- Test process
    stimulus: process
    begin
        -- Test case 1
        input_signal_0 <= X"12345678"; -- Expected output depends on row 0 behavior of InvRowShift
        input_signal_1 <= X"23456789"; -- Expected output depends on row 1 behavior of InvRowShift
        input_signal_2 <= X"3456789A"; -- Expected output depends on row 2 behavior of InvRowShift
        input_signal_3 <= X"456789AB"; -- Expected output depends on row 3 behavior of InvRowShift
        wait for 10 ns;

        -- Test case 2
        input_signal_0 <= X"00000001";
        input_signal_1 <= X"00000002";
        input_signal_2 <= X"00000003";
        input_signal_3 <= X"00000004";
        wait for 10 ns;

        -- Test case 3
        input_signal_0 <= X"FFFFFFFF";
        input_signal_1 <= X"FFFFFFFE";
        input_signal_2 <= X"FFFFFFFD";
        input_signal_3 <= X"FFFFFFFC";
        wait for 10 ns;

        -- Stop the simulation
        wait;
    end process stimulus;

end Behavioral;
