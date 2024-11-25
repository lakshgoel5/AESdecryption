library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity four_mult is
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
end four_mult;

architecture Behavioral of four_mult is

    component new_multiplier
        Port (
            input_vector  : in  std_logic_vector(31 downto 0);
            output_vector : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Instantiate four instances of new_multiplier
    new_multiplier_0: new_multiplier port map (
        input_vector => input_signal_0,
        output_vector => output_signal_0
    );

    new_multiplier_1: new_multiplier port map (
        input_vector => input_signal_1,
        output_vector => output_signal_1
    );

    new_multiplier_2: new_multiplier port map (
        input_vector => input_signal_2,
        output_vector => output_signal_2
    );

    new_multiplier_3: new_multiplier port map (
        input_vector => input_signal_3,
        output_vector => output_signal_3
    );

end Behavioral;
