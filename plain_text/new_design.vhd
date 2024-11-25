library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity new_design is
    Port (
        string : in  STD_LOGIC_VECTOR(127 downto 0);  -- 16 hexadecimal letters (128 bits)
        
        f_cathode : out std_logic_vector(7 downto 0);
        f_anode : out std_logic_vector(3 downto 0);
        clk : in std_logic  -- Clock signal to control scrolling
    );
end new_design;

architecture Behavioral of new_design is

component design is 
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

signal display_segment : std_logic_vector(31 downto 0);  -- To hold 4 letters (32 bits)
signal index : integer range 0 to 12 := 0;  -- To track which 4 letters to display
signal counter : integer := 0;  -- For timing control
constant clock_period : integer := 1000;  -- Adjust based on clock frequency (e.g., 100 MHz)

begin
    -- Scrolling process: selects 4 letters (32 bits) at a time
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = clock_period * 2 then  -- Change segment every 2 seconds
                counter <= 0;
                if index < 12 then  -- 12 possible shifts in a 128-bit string
                    index <= index + 1;
                else
                    index <= 0;  -- Loop back to the start
                end if;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Selecting the current 32-bit segment
    display_segment <= string(127 - (index * 8) downto 96 - (index * 8));

    -- Instantiate the design component and connect it to the selected segment
    display_unit: design port map(
        f_d1 => display_segment(31 downto 24),
        f_d2 => display_segment(23 downto 16),
        f_d3 => display_segment(15 downto 8),
        f_d4 => display_segment(7 downto 0),
        f_cathode => f_cathode,
        f_anode => f_anode,
        clk_in_1 => clk  -- Passing the clock signal
    );

end Behavioral;