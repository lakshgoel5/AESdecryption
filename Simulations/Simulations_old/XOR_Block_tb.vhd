library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR_Block_tb is
-- No ports for a testbench
end XOR_Block_tb;

architecture Behavioral of XOR_Block_tb is

    -- Component Declaration for XOR_Block
    component XOR_Block is
        Port ( input1  : in  std_logic_vector(127 downto 0);
               input2  : in  std_logic_vector(127 downto 0);
               result  : out std_logic_vector(127 downto 0);
               clk     : in  std_logic);
    end component;

    -- Testbench signals
    signal input1_tb : std_logic_vector(127 downto 0) := (others => '0');
    signal input2_tb : std_logic_vector(127 downto 0) := (others => '0');
    signal result_tb : std_logic_vector(127 downto 0);
    signal clk_tb    : std_logic := '0';

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the XOR_Block component
    uut: XOR_Block
        port map (
            input1 => input1_tb,
            input2 => input2_tb,
            result => result_tb,
            clk    => clk_tb
        );

    -- Clock process definition
    clk_process :process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
--        wait for clk_period*2;
        input1_tb <= x"00112233445566778899AABBCCDDEEFF";
        input2_tb <= x"0F1E2D3C4B5A69788796A5B123AB4560";

        -- Wait for several clock cycles to observe XOR operations
        wait for clk_period * 22; -- 16 cycles + 2 extra for setup

        -- Add other test vectors if necessary
        wait;
    end process;

end Behavioral;
