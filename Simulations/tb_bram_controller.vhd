LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_bram_controller IS
END tb_bram_controller;

ARCHITECTURE behavior OF tb_bram_controller IS

    -- Component declaration for the bram_controller
    COMPONENT bram_controller
    PORT(
        clka         : IN  STD_LOGIC;
        ena          : IN  STD_LOGIC;
        write_enable : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
        start        : IN  STD_LOGIC;
        dina1        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        dina2        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        dina3        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        dina4        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta1       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta2       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta3       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta4       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        done         : OUT STD_LOGIC;
        pause        : IN  STD_LOGIC;
        start_address: IN  STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL clka         : STD_LOGIC := '0';
    SIGNAL ena          : STD_LOGIC := '1';
    SIGNAL write_enable : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    SIGNAL start        : STD_LOGIC := '0';
    SIGNAL dina1        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    SIGNAL dina2        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    SIGNAL dina3        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    SIGNAL dina4        : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    SIGNAL douta1       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL douta2       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL douta3       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL douta4       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL done         : STD_LOGIC;
    SIGNAL pause        : STD_LOGIC := '0';
    SIGNAL start_address: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

    -- Clock generation: 10 ns period
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the bram_controller component
    uut: bram_controller
    PORT MAP (
        clka         => clka,
        ena          => ena,
        write_enable => write_enable,
        start        => start,
        dina1        => dina1,
        dina2        => dina2,
        dina3        => dina3,
        dina4        => dina4,
        douta1       => douta1,
        douta2       => douta2,
        douta3       => douta3,
        douta4       => douta4,
        done         => done,
        pause        => pause,
        start_address => start_address
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clka <= '0';
        WAIT FOR clk_period/2;
        clka <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Test procedure
    stimulus_process: PROCESS
    BEGIN
        -- Test initial reset state
        start <= '0';
        pause <= '0';
        WAIT FOR clk_period * 10;

        -- Test Write Process
--        write_enable <= "1";
        start <= '1';
        dina1 <= X"12345678";
        dina2 <= X"9ABCDEF0";
        dina3 <= X"11111111";
        dina4 <= X"22222222";
        WAIT until done='1';
        pause <= '1';
        wait for 20 ns;
        pause <='0';
        -- Stop writing, and start reading process
        write_enable <= "1";
        WAIT FOR clk_period * 5;

        -- Test Read Process
        start <= '1';
        WAIT UNTIL done = '1';
        pause <='1';
        WAIT FOR clk_period * 5;
        pause<='0';
        write_enable <= "0";
        start <='1';
        wait until done='1';
--        WAIT FOR clk_period * 5;
--        start <='1';
--        wait until done='1';
        -- Check the outputs
        ASSERT douta1 = X"12345678" AND douta2 = X"9ABCDEF0" AND douta3 = X"11111111" AND douta4 = X"22222222"
        REPORT "Read values do not match expected data"
        SEVERITY ERROR;

        -- Test pause feature
        pause <= '1';
        WAIT FOR clk_period * 5;
        ASSERT done = '1' REPORT "Pause failed to hold done signal" SEVERITY ERROR;

        -- Finish simulation
        WAIT;
    END PROCESS;

END behavior;
