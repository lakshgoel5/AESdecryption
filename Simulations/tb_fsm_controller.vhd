 LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fsm_controller_tb IS
END fsm_controller_tb;

ARCHITECTURE behavior OF fsm_controller_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT fsm_controller
    PORT(
        clk      : IN  std_logic;
        start    : IN  std_logic;
        done     : OUT std_logic;
        f_cathode : OUT std_logic_vector(7 downto 0);
        f_anode : OUT std_logic_vector(3 downto 0);
        out1 : out std_logic_vector(31 downto 0);
        out2 : out std_logic_vector(31 downto 0);
        out3 : out std_logic_vector(31 downto 0);
        out4 : out std_logic_vector(31 downto 0);
        test: out std_logic_vector(3 downto 0)
    );
    END COMPONENT;

    -- Testbench Signals
    SIGNAL clk       : std_logic := '0';
    SIGNAL start     : std_logic := '0';
    SIGNAL done      : std_logic;
    SIGNAL f_cathode : std_logic_vector(7 downto 0);
    SIGNAL f_anode   : std_logic_vector(3 downto 0);
    signal out1 :  std_logic_vector(31 downto 0);
    signal out2 :  std_logic_vector(31 downto 0);
    signal out3 :  std_logic_vector(31 downto 0);
    signal out4 :  std_logic_vector(31 downto 0);
    signal test: std_logic_vector(3 downto 0);
    -- Clock Period
    CONSTANT clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: fsm_controller PORT MAP (
        clk       => clk,
        start     => start,
        done      => done,
        f_cathode => f_cathode,
        f_anode   => f_anode,
        out1 => out1,
        out2 => out2,
        out3 => out3,
        out4 => out4,
        test => test
    );

    -- Clock Generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus Process
    stimulus_process : PROCESS
    BEGIN
        -- Initial Condition
        start <= '0';
        WAIT FOR 20 ns;
        
        -- Start the FSM
        start <= '1';
        WAIT FOR clk_period;
        
        -- Allow FSM to process, then turn off start signal
        start <= '0';
        WAIT FOR 100 ns;
        
        -- Check done signal after the expected process duration
        IF done = '1' THEN
            REPORT "FSM completed successfully." SEVERITY note;
        ELSE
            REPORT "FSM did not complete within expected time." SEVERITY error;
        END IF;

        -- Additional cycle to reset and re-trigger
        WAIT FOR 50 ns;
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        
        -- Final wait period before ending simulation
        WAIT FOR 200 ns;
        REPORT "Testbench finished." SEVERITY note;
        WAIT;
    END PROCESS;

END behavior;
