library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity new_design is
    Port (
        string1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit segments
        string2 : in  STD_LOGIC_VECTOR(31 downto 0);
        string3 : in  STD_LOGIC_VECTOR(31 downto 0);
        string4 : in  STD_LOGIC_VECTOR(31 downto 0);
        f_cathode : out std_logic_vector(7 downto 0);
        f_anode : out std_logic_vector(3 downto 0);
        clk : in std_logic;
        display_seg : out  STD_LOGIC_VECTOR(31 downto 0)  -- Clock signal to control segment selection
--        vanshika : out STD_LOGIC_VECTOR(31 downto 0)
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
--        laksh : out std_logic_vector(31 downto 0)
    );
end component;

signal display_segment : std_logic_vector(31 downto 0);  -- Holds the selected 32-bit segment
signal index : integer range 0 to 3 := 0;  -- Tracks the active input string (0 to 3)
signal counter : integer := 0;  -- For timing control
constant clock_period : integer := 1000;  -- Adjust for desired timing
--signal fgh : std_logic_vector(7 downto 0):="00000000";

begin
    -- Segment selection process
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = clock_period * 1000000 then  -- Change segment every 2 seconds
                counter <= 0;
                if index < 15 then
                    index <= index + 1;
                else
                    index <= 0;  -- Loop back to the first segment
                end if;
            else
                counter <= counter + 1;
            end if;
        end if;
        
        if index = 0 then
        display_segment <= string1;
           elsif index = 1 then
               display_segment <= string1(23 downto 0) & string2(31 downto 24);
           elsif index = 2 then
               display_segment <= string1(15 downto 0) & string2(31 downto 16);
--               vanshika <= display_segment;
           elsif index = 3 then
               display_segment <= string1(7 downto 0) & string2(31 downto 8);
           elsif index = 4 then
               display_segment <= string2;
           elsif index = 5 then
               display_segment <= string2(23 downto 0) & string3(31 downto 24);
           elsif index = 6 then
               display_segment <= string2(15 downto 0) & string3(31 downto 16);
           elsif index = 7 then
               display_segment <= string2(7 downto 0) & string3(31 downto 8);
           elsif index = 8 then
               display_segment <= string3;
           elsif index = 9 then
               display_segment <= string3(23 downto 0) & string4(31 downto 24);
           elsif index = 10 then
               display_segment <= string3(15 downto 0) & string4(31 downto 16);
           elsif index = 11 then
               display_segment <= string3(7 downto 0) & string4(31 downto 8);
           elsif index = 12 then
               display_segment <= string4;
           elsif index = 13 then
               display_segment <= string4(23 downto 0) & string1(31 downto 24);
           elsif index = 14 then
               display_segment <= string4(15 downto 0) & string1(31 downto 16);
           elsif index = 15 then
               display_segment <= string4(7 downto 0) & string1(31 downto 8);
           end if;
    end process;
    display_seg<=display_segment;
    -- Select the 32-bit segment based on the current index
    -- Select the 32-bit segment based on the current index with scrolling logic


    -- Instantiate the design component and connect it to the selected segment
    display_unit: design port map(
        f_d1 => display_segment(31 downto 24),
        f_d2 => display_segment(23 downto 16),
        f_d3 => display_segment(15 downto 8),
        f_d4 => display_segment(7 downto 0),
        f_cathode => f_cathode,
        f_anode => f_anode,
        clk_in_1 => clk  -- Passing the clock signal
--        laksh => vanshika
    );

end Behavioral;