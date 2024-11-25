LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_dist_mem_gen_0 IS
END tb_dist_mem_gen_0;

ARCHITECTURE behavior OF tb_dist_mem_gen_0 IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT dist_mem_gen_0
    PORT(
        a : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        d : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        clk : IN  STD_LOGIC;
        we : IN  STD_LOGIC;
        spo : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    -- Signals for driving and observing the UUT
    SIGNAL a : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL d : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL we : STD_LOGIC := '0';
    SIGNAL spo : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: dist_mem_gen_0 PORT MAP (
        a => a,
        d => d,
        clk => clk,
        we => we,
        spo => spo
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin	
        -- Initialize inputs
--        wait for 20 ns;
        
        -- Write data to address 0
        we <= '1';
        a <= "000000";  -- Address 0
        d <= "10101010"; -- Data 0xAA
        wait for clk_period;

        -- Write data to address 1
        a <= "000001";  -- Address 1
        d <= "11001100"; -- Data 0xCC
        wait for clk_period;
        
        a <= "000010";  -- Address 0
        d <= "10101111"; -- Data 0xAA
        wait for clk_period;

        -- Write data to address 1
        a <= "000011";  -- Address 1
        d <= "11111100"; -- Data 0xCC
        wait for clk_period;

        -- Disable write enable
        we <= '0';
        
        -- Read data from address 0
        a <= "000000";  -- Address 0
        wait for clk_period;

        -- Read data from address 1
        a <= "000001";  -- Address 1
        wait for clk_period;
        
        a <= "000010";  -- Address 0
        wait for clk_period;

        -- Read data from address 1
        a <= "000011";  -- Address 1
        wait for clk_period;

        -- Add more test cases if needed
        wait;
    end process;

END behavior;
