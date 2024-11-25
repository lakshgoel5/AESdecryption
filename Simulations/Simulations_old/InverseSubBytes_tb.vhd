library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_InverseSubBytes is
end tb_InverseSubBytes;

architecture Behavioral of tb_InverseSubBytes is

    -- Component Declaration for the Unit Under Test (UUT)
    component InverseSubBytes
    Port (
        clk : in std_logic;
        input_byte_address : in std_logic_vector(5 downto 0);
        inv_sub_byte : out std_logic_vector(7 downto 0)
    );
    end component;
    
    COMPONENT dist_mem_gen_0
    PORT(
        a : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        d : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        clk : IN  STD_LOGIC;
        we : IN  STD_LOGIC;
        spo : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL a : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL d : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL we : STD_LOGIC := '0';
    SIGNAL spo : STD_LOGIC_VECTOR(7 DOWNTO 0);


    -- Testbench signals
--    signal clk : std_logic := '0';
    signal input_byte_address : std_logic_vector(5 downto 0);
    signal inv_sub_byte : std_logic_vector(7 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin




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
        d <= "00000001"; -- Data 0xAA
        wait for clk_period;

        -- Write data to address 1
        a <= "000001";  -- Address 1
        d <= "00000010"; -- Data 0xCC
        wait for clk_period;

        we <= '1';
        a <= "000010";  -- Address 0
        d <= "00000011"; -- Data 0xAA
        wait for clk_period;

        -- Write data to address 1
        a <= "000011";  -- Address 1
        d <= "00000100"; -- Data 0xCC
        wait for clk_period;
        
        -- Disable write enable
        we <= '0';
        
--        -- Read data from address 0
--        a <= "000000";  -- Address 0
--        wait for clk_period;

--        -- Read data from address 1
--        a <= "000001";  -- Address 1
--        wait for clk_period;

        -- Add more test cases if needed
        wait;
    end process;



    -- Instantiate the Unit Under Test (UUT)
    uut1: InverseSubBytes
        port map (
            clk => clk,
            input_byte_address => input_byte_address,
            inv_sub_byte => inv_sub_byte
        );

    -- Clock Generation Process
    clk_process1 : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus Process
    stimulus_process : process
    begin
        -- Initialize inputs
        wait for 40 ns;
        input_byte_address <= "000000";  -- Address for first test case
        wait for clk_period;

        input_byte_address <= "000001";  -- Address for second test case
        wait for clk_period;

        input_byte_address <= "000010";  -- Address for third test case
        wait for clk_period;

        input_byte_address <= "000011";  -- Address for fourth test case
        wait for clk_period;

        input_byte_address <= "000100";  -- Address for fifth test case
        wait for clk_period;

        -- Additional test cases can be added here

        -- Finish simulation
        wait;
    end process;

end Behavioral;
