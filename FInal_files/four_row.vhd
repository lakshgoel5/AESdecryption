library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_row is
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
end four_row;

architecture Behavioral of four_row is

    component InvRowShift
        Port (
            state_in   : in  std_logic_vector(31 downto 0);
            state_out  : out std_logic_vector(31 downto 0);
            row_number : in  std_logic_vector(1 downto 0)
        );
    end component;

begin

    -- Instantiate four instances of InvRowShift
    InvRowShift_0: InvRowShift port map (
        state_in   => input_signal_0,
        state_out  => output_signal_0,
        row_number => "00" -- row number 0
    );

    InvRowShift_1: InvRowShift port map (
        state_in   => input_signal_1,
        state_out  => output_signal_1,
        row_number => "01" -- row number 1
    );

    InvRowShift_2: InvRowShift port map (
        state_in   => input_signal_2,
        state_out  => output_signal_2,
        row_number => "10" -- row number 2
    );

    InvRowShift_3: InvRowShift port map (
        state_in   => input_signal_3,
        state_out  => output_signal_3,
        row_number => "11" -- row number 3
    );

end Behavioral;
