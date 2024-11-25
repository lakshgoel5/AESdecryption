LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
ENTITY fsm_controller IS
    PORT (
        clk      : IN  std_logic;
        start    : IN  std_logic;
        done     : OUT std_logic;
--        check : OUT std_logic_vector(3 downto 0);
--        check_extra : out std_logic;
        f_cathode : out std_logic_vector(7 downto 0);
        f_anode : out std_logic_vector(3 downto 0)
--        out1 : out std_logic_vector(31 downto 0);
--        out2 : out std_logic_vector(31 downto 0);
--        out3 : out std_logic_vector(31 downto 0);
--        out4 : out std_logic_vector(31 downto 0);
--        test: out std_logic_vector(3 downto 0)
    );
END fsm_controller;

ARCHITECTURE fsm_arch OF fsm_controller IS
    -- Define FSM states
    TYPE state_type IS (
        INIT, READ1, READ2, XOR1, ROW1, SUBBOX1, MULT, ROW, SUBBOX, READ, XOR2,
        NEXT_ROUND, FINAL_READ, FINAL_XOR, WRITE, DONE1, NEWSTATE, pause1, READ3, wait3, wait4, READq, xor2q, display
    );
    SIGNAL state : state_type := INIT;

--    SIGNAL address_offset    : std_logic_vector(7 DOWNTO 0) := x"80";
    SIGNAL bram_address      : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL brom_address      : std_logic_vector(7 DOWNTO 0) := x"90";

    -- Intermediate signals for data storage and operations
    SIGNAL data_bram, data_round0 : std_logic_vector(31 DOWNTO 0);
    SIGNAL xor_result, mult_result, row_result, subbox_result : std_logic_vector(31 DOWNTO 0);

    -- Control signals for components
    SIGNAL bram_start, bram_done, brom_done, pause , bram_pause      : std_logic;
    SIGNAL bram_write_enable                      : std_logic_vector(0 DOWNTO 0) := "0";
    SIGNAL xor_start, mult_start, subbox_start : std_logic;

    -- Component ports
--    COMPONENT bram_controller IS
--        PORT (
--            clka         : IN  std_logic;
--            ena          : IN  std_logic;
--            write_enable : IN  std_logic_vector(0 DOWNTO 0);
--            start        : IN  std_logic;
--            start_address: IN  std_logic_vector(7 DOWNTO 0);
--            dina123      : IN  std_logic_vector(31 DOWNTO 0);
--            dout         : OUT std_logic_vector(31 DOWNTO 0);
--            done         : OUT std_logic
--        );
--    END COMPONENT;
component new_design is
    Port (
        string1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit segments
        string2 : in  STD_LOGIC_VECTOR(31 downto 0);
        string3 : in  STD_LOGIC_VECTOR(31 downto 0);
        string4 : in  STD_LOGIC_VECTOR(31 downto 0);

        f_cathode : out std_logic_vector(7 downto 0);
        f_anode : out std_logic_vector(3 downto 0);
        clk : in std_logic  -- Clock signal to control segment selection
--        vanshika : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component bram_controller IS
 PORT (
   clka         : IN  STD_LOGIC;
   ena          : IN  STD_LOGIC;
   write_enable : IN  STD_LOGIC_vector(0 downto 0);
   start        : IN  STD_LOGIC;
   dina1         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 32-bit input data
   dina2         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
   dina3         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
   dina4        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
   douta1         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 32-bit output data
   douta2         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
   douta3        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
   douta4        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
   done         : OUT STD_LOGIC;
   pause : in std_logic;
   start_address: IN std_logic_vector(7 downto 0)
 );
END component;

--    COMPONENT brom_controller IS
--        PORT (
--            clka   : IN  std_logic;
--            ena    : IN  std_logic;
--            addra  : IN  std_logic_vector(7 DOWNTO 0);
--            douta  : OUT std_logic_vector(31 DOWNTO 0);
--            start: in std_logic;
--            done: in std_logic
--        );
--    END COMPONENT;


    component rom_controller IS
        PORT (
            clk              : IN  STD_LOGIC;
            start            : in  STD_LOGIC;
            starting_address : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            ena              : in STD_LOGIC;
            done             : OUT STD_LOGIC;
            douta1           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 1st 32-bit vector output
            douta2           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 2nd 32-bit vector output
            douta3           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 3rd 32-bit vector output
            douta4           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);   -- 4th 32-bit vector output
            pause : in std_logic
        );
    END component;

    COMPONENT four_mult IS
        PORT (
            input_signal_0 : IN  std_logic_vector(31 DOWNTO 0);
            input_signal_1 : IN  std_logic_vector(31 DOWNTO 0);
            input_signal_2 : IN  std_logic_vector(31 DOWNTO 0);
            input_signal_3 : IN  std_logic_vector(31 DOWNTO 0);

            output_signal_0 : OUT std_logic_vector(31 DOWNTO 0);
            output_signal_1 : OUT std_logic_vector(31 DOWNTO 0);
            output_signal_2 : OUT std_logic_vector(31 DOWNTO 0);
            output_signal_3 : OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT four_row IS
        PORT (
            input_signal_0 : IN  std_logic_vector(31 DOWNTO 0);
            input_signal_1 : IN  std_logic_vector(31 DOWNTO 0);
            input_signal_2 : IN  std_logic_vector(31 DOWNTO 0);
            input_signal_3 : IN  std_logic_vector(31 DOWNTO 0);

            output_signal_0 : OUT std_logic_vector(31 DOWNTO 0);
            output_signal_1 : OUT std_logic_vector(31 DOWNTO 0);
            output_signal_2 : OUT std_logic_vector(31 DOWNTO 0);
            output_signal_3 : OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT four_subbytes IS
        PORT (
            clk          : IN  std_logic;
            start : in std_logic;
            input_row_0  : IN  std_logic_vector(31 DOWNTO 0);
            input_row_1  : IN  std_logic_vector(31 DOWNTO 0);
            input_row_2  : IN  std_logic_vector(31 DOWNTO 0);
            input_row_3  : IN  std_logic_vector(31 DOWNTO 0);

            output_row_0 : OUT std_logic_vector(31 DOWNTO 0);
            output_row_1 : OUT std_logic_vector(31 DOWNTO 0);
            output_row_2 : OUT std_logic_vector(31 DOWNTO 0);
            output_row_3 : OUT std_logic_vector(31 DOWNTO 0);
            subbox_done: OUT std_logic
        );
    END COMPONENT;

    -- Signals to capture output from components
    SIGNAL mult_out_0, mult_out_1, mult_out_2, mult_out_3 : std_logic_vector(31 DOWNTO 0);
    SIGNAL row_out_0, row_out_1, row_out_2, row_out_3     : std_logic_vector(31 DOWNTO 0);
    SIGNAL subbox_out_0, subbox_out_1, subbox_out_2, subbox_out_3 : std_logic_vector(31 DOWNTO 0);
    SIGNAL subbox_result_0, subbox_result_1, subbox_result_2, subbox_result_3 : std_logic_vector(31 DOWNTO 0);
    signal subbox_done, subbox_done2: std_logic;
    SIGNAL round_final_0, round_final_1, round_final_2, round_final_3 : std_logic_vector(31 DOWNTO 0);
    SIGNAL data_bram1, data_bram2, data_bram3, data_bram4 : std_logic_vector(31 DOWNTO 0):="00000000000000000000000000000000";
    SIGNAL converted_0, converted_1, converted_2, converted_3 : std_logic_vector(31 DOWNTO 0);
    SIGNAL xor_0, xor_1, xor_2, xor_3 : std_logic_vector(31 DOWNTO 0);
    SIGNAL column_0, column_1, column_2, column_3 : std_logic_vector(31 DOWNTO 0);
    SIGNAL row_out_00, row_out_01, row_out_02, row_out_03 : std_logic_vector(31 DOWNTO 0);
    SIGNAL subbox_out_00, subbox_out_01, subbox_out_02, subbox_out_03 : std_logic_vector(31 DOWNTO 0);
    SIGNAL round_data_0, round_data_1, round_data_2, round_data_3 : std_logic_vector(31 DOWNTO 0);


    signal bram_data_out1, bram_data_out2, bram_data_out3, bram_data_out4, data_read_0,data_read_1,data_read_2,data_read_3: std_logic_vector(31 DOWNTO 0);
    signal xor_result_0,xor_result_1,xor_result_2,xor_result_3: std_logic_vector(31 DOWNTO 0);
    signal brom_data_out1,brom_data_out2,brom_data_out3,brom_data_out4,round0_data_0,round0_data_1,round0_data_2,round0_data_3: std_logic_vector(31 DOWNTO 0);
    signal row_result_0,row_result_1,row_result_2,row_result_3: std_logic_vector(31 DOWNTO 0);
    signal brom_start: std_logic;
     signal something: std_logic;
     signal round_count  : integer:=0;
    signal start1, init_start: std_logic:='0';
BEGIN
    -- Instantiate BRAM and BROM controllers
--    bram_inst: bram_controller PORT MAP (
--        clka         => clk,
--        ena          => '1',
--        write_enable => bram_write_enable,
--        start        => bram_start,
--        start_address => bram_address,
--        dina123      => data_bram,
--        dout         => bram_data_out,
--        done         => bram_done
--    );

new_design_init: new_design
    Port map (
        string1 => data_bram1,  -- 32-bit segments
        string2  => data_bram2,
        string3  => data_bram3,
        string4  => data_bram4,

        f_cathode => f_cathode,
        f_anode => f_anode,
        clk => clk  -- Clock signal to control segment selection
--        vanshika : out STD_LOGIC_VECTOR(31 downto 0)
    );





    bram_inst: bram_controller port map
    (
       clka       => clk,
       ena        => '1',
       write_enable => bram_write_enable,
       start    => bram_start,
       dina1       => data_bram1,  -- 32-bit input data
       dina2      => data_bram2,
       dina3     => data_bram3,
       dina4     => data_bram4,
       douta1     => bram_data_out1, -- 32-bit output data
       douta2      => bram_data_out2,
       douta3   => bram_data_out3,
       douta4    => bram_data_out4,
       done   => bram_done,
       pause => bram_pause,
       start_address => bram_address
        );


    brom_inst: rom_controller PORT MAP (
        clk   => clk,
        start => brom_start,
        starting_address  => brom_address,
        ena    => '1',
        done => brom_done,
        douta1  => brom_data_out1,
        douta2  => brom_data_out2,
        douta3  => brom_data_out3,
        douta4  => brom_data_out4,
        pause => pause

    );

    -- Instantiate four_mult component
    mult_inst: four_mult PORT MAP (
        input_signal_0 => column_0,
        input_signal_1 => column_1,
        input_signal_2 => column_2,  -- Adjust signals as needed
        input_signal_3 => column_3, -- Adjust signals as needed

        output_signal_0 => mult_out_0,
        output_signal_1 => mult_out_1,
        output_signal_2 => mult_out_2,
        output_signal_3 => mult_out_3
    );

    -- Instantiate four_row component
    row_inst: four_row PORT MAP (
        input_signal_0 => converted_0,
        input_signal_1 => converted_1,
        input_signal_2 => converted_2,
        input_signal_3 => converted_3,

        output_signal_0 => row_out_0,
        output_signal_1 => row_out_1,
        output_signal_2 => row_out_2,
        output_signal_3 => row_out_3
    );

    row_inst1: four_row PORT MAP (
        input_signal_0 => xor_0,
        input_signal_1 => xor_1,
        input_signal_2 => xor_2,
        input_signal_3 => xor_3,

        output_signal_0 => row_out_00,
        output_signal_1 => row_out_01,
        output_signal_2 => row_out_02,
        output_signal_3 => row_out_03
    );

    subbox_inst1: four_subbytes PORT MAP (
        clk          => clk,
        start => start1,
        input_row_0  => row_out_00,
        input_row_1  => row_out_01,
        input_row_2  => row_out_02,
        input_row_3  => row_out_03,

        output_row_0 => subbox_out_00,
        output_row_1 => subbox_out_01,
        output_row_2 => subbox_out_02,
        output_row_3 => subbox_out_03,
        subbox_done=> subbox_done2
    );

    -- Instantiate four_subbytes component
    subbox_inst: four_subbytes PORT MAP (
        clk          => clk,
        start => init_start,
        input_row_0  => row_out_0,
        input_row_1  => row_out_1,
        input_row_2  => row_out_2,
        input_row_3  => row_out_3,

        output_row_0 => subbox_out_0,
        output_row_1 => subbox_out_1,
        output_row_2 => subbox_out_2,
        output_row_3 => subbox_out_3,
        subbox_done=> subbox_done
    );

    -- State Machine Logic
    PROCESS (clk)

--    variable round_count2  : std_logic_vector(3 downto 0);
    BEGIN
        if rising_edge(clk) THEN

        -- Default assignments



            CASE state IS
                -- Initialization of values
                WHEN INIT =>
--                test <="0000";
                    start1 <= '0';
--                    next_state <= state;
--                    bram_start <= '0';
--                    brom_start <= '0';
                    bram_write_enable <= "0";
            --        xor_start <= '0';
            --        mult_start <= '0';
                    subbox_start <= '0';
                    done <= '0';

--                    check<="1011"; --b
                    bram_address <= x"00";
                    round_count <= 1;
--                    address_offset <= x"70"; -- Starting address as specified
                    brom_address <= x"90";
                    state <= read1;

                    bram_start <= '1';
                    bram_pause <='0';
                    report "i am in init state" ;

                -- State to read data four times from BRAM using bram_controller

                WHEN READ1 =>
--                    test <="0001";
--                    check<="1111";
                    IF bram_done = '1' THEN
                        -- Store data read from BRAM in 32-bit signals for further use
                        data_read_0 <= bram_data_out1;
                        data_read_1 <= bram_data_out2;
                        data_read_2 <= bram_data_out3;
                        data_read_3 <= bram_data_out4;

                        state <= read2;
                        bram_pause <='1';
                        brom_start <= '1';
                    pause <= '0';
                    END IF;

                -- Read data using brom_controller and store in four signals for XOR1
                WHEN READ2 =>
--                    test <="0001";
                    IF brom_done = '1' THEN
--                        abcd<="00000000000000000000000000000000";
--                        abcd<= brom_data_out1;
                        -- Store data read from BROM into "round0" signals
                        round0_data_0 <= brom_data_out1;
                        round0_data_1 <= brom_data_out2;
                        round0_data_2 <= brom_data_out3;
                        round0_data_3 <= brom_data_out4;
                        state <= XOR1;
                        pause <= '1';

                    END IF;
                    report "i am in read2 state" ;

                -- XOR signals from READ1 and READ2
                WHEN XOR1 =>
--                    test <="0010";
                    xor_0 <= data_read_0 XOR round0_data_0;
                    xor_1 <= data_read_1 XOR round0_data_1;
                    xor_2 <= data_read_2 XOR round0_data_2;
                    xor_3 <= data_read_3 XOR round0_data_3;
                    state <= ROW1;
                    report "i am in xor1 state" ;

                -- Pass results through row transformation
                WHEN ROW1 =>
--                    test <="0100";
--                    abcd <= xor_1;
--                        out1 <=row_out_00;
--                        out2 <=row_out_01;
--                        out3 <=row_out_02;
--                        out4 <=row_out_03;
--                    row_out_0 <= row_out_00;
--                    row_out_1 <= row_out_01;
--                    row_out_2 <= row_out_02;
--                    row_out_3 <= row_out_03;
                    state <= readq;
                    
                    report "i am in row1 state" ;
                    
                when readq =>
                    start1 <='1';
                    state <= subbox1;
                -- Pass results through sub-box transformation
                WHEN SUBBOX1 =>
--                    test <="0101";
                    subbox_start <= '1';
--                    start1 <='1';
                    
--                    out1 <=start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1
--                    & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1;
--                    abcd <=row_result_1;
--                        out1<= subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done ;
                    IF subbox_done2 = '1' THEN
                        subbox_result_0 <= subbox_out_00;
                        subbox_result_1 <= subbox_out_01;
                        subbox_result_2 <= subbox_out_02;
                        subbox_result_3 <= subbox_out_03;
                        brom_address <= std_logic_vector(unsigned(brom_address) - 16);
                        state <= READ;
                        pause <='0';
                        start1 <= '0';
--                        out1 <="00000000000000000000000000000000";
--                        out2 <=subbox_out_01;
--                        out3 <=subbox_out_02;
--                        out4 <=subbox_out_03;
--                        brom_start <= '1';

                    END IF;
                    report "i am in subbox1 state" ;


                -- Read data using brom_controller and store in four signals for XOR1
                WHEN READ =>
--                out1 <=start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1
--                    & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1 & start1;
--                    abcd <=row_result_1;
--                    out1 <=subbox_out_00;
--                        out2 <=subbox_out_01;
--                        out3 <=subbox_out_02;
--                        out4 <=subbox_out_03;
--                        out1 <=subbox_result_0;
--                        out2 <=subbox_result_1;
--                        out3 <=subbox_result_2;
--                        out4 <=subbox_result_3;
--                    check<="0001";
--                    abcd <=subbox_result_1;
                    IF brom_done = '1' THEN

                            round_data_0 <= brom_data_out1;
                            round_data_1 <= brom_data_out2;
                            round_data_2 <= brom_data_out3;
                            round_data_3 <= brom_data_out4;
                            pause <= '1';
                            state <= xor2;
                    END IF;
                    report "i am in read state" ;
                -- XOR signals from READ1 and READ2
                WHEN XOR2 =>
--                test <="0010";
--                  out1<= subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done & subbox_done ;
--                    out1 <="11111111111111111111111111111111";
--                check<="0000";
--                check<="0001";
--                        out1 <= brom_address & brom_address & brom_address & brom_address;
--                        out2 <=brom_data_out2;
--                        out3 <=brom_data_out3;
--                        out4 <=brom_data_out4;
                    xor_result_0 <= round_data_0 XOR subbox_result_0;
                    xor_result_1 <= round_data_0 XOR subbox_result_1;
                    xor_result_2 <= round_data_0 XOR subbox_result_2;
                    xor_result_3 <= round_data_0 XOR subbox_result_3;
                    state <= NEWSTATE;
                    round_count <= round_count + 1;
                    report "i am in xor2 state" ;
                when NEWSTATE =>
--                    abcd<=xor_result_2;
                    column_0 <= xor_result_0(31 downto 24) & xor_result_1(31 downto 24) & xor_result_2(31 downto 24) & xor_result_3(31 downto 24);
                    column_1 <= xor_result_0(23 downto 16) & xor_result_1(23 downto 16) & xor_result_2(23 downto 16) & xor_result_3(23 downto 16);
                    column_2 <= xor_result_0(15 downto 8)  & xor_result_1(15 downto 8)  & xor_result_2(15 downto 8)  & xor_result_3(15 downto 8);
                    column_3 <= xor_result_0(7 downto 0)   & xor_result_1(7 downto 0)   & xor_result_2(7 downto 0)   & xor_result_3(7 downto 0);
                    state <= mult;
                -- Convert rows to columns and perform multiplication, then back to row format
                WHEN MULT =>
--                test <="0011";
                    -- Reorder to column form before multiplication
    --                column_0 <= xor_result_0;
    --                column_1 <= xor_result_1;
    --                column_2 <= xor_result_2;
    --                column_3 <= xor_result_3;
                    -- Start multiplication
--                    abcd <= column_1;
                    converted_0 <= mult_out_0(31 downto 24) & mult_out_1(31 downto 24) & mult_out_2(31 downto 24) & mult_out_3(31 downto 24);
                    converted_1 <= mult_out_0(23 downto 16) & mult_out_1(23 downto 16) & mult_out_2(23 downto 16) & mult_out_3(23 downto 16);
                    converted_2 <= mult_out_0(15 downto 8)  & mult_out_1(15 downto 8)  & mult_out_2(15 downto 8)  & mult_out_3(15 downto 8);
                    converted_3 <= mult_out_0(7 downto 0)   & mult_out_1(7 downto 0)   & mult_out_2(7 downto 0)   & mult_out_3(7 downto 0);

                    state <= ROW;
                    report "i am in mult state" ;

                -- Pass results through row transformation
                WHEN ROW =>
--                test <="0100";
--                abcd<= converted_1;
                    row_result_0 <= row_out_0;
                    row_result_1 <= row_out_1;
                    row_result_2 <= row_out_2;
                    row_result_3 <= row_out_3;
                    state <= SUBBOX;
                    init_start <= '1';
                    subbox_start <= '1';
--                    round_count2:= round_count;
                    report "i am in row state" ;
                -- Pass results through sub-box transformation
                WHEN SUBBOX =>
--                test <="0101";
--                abcd<=row_out_1;
--                    check <= "0000";
--                    check <= round_count;
                
                    IF subbox_done = '1' THEN
                        subbox_result_0 <= subbox_out_0;
                        subbox_result_1 <= subbox_out_1;
                        subbox_result_2 <= subbox_out_2;
                        subbox_result_3 <= subbox_out_3;
                        brom_address <= std_logic_vector(unsigned(brom_address) - 16);
                        init_start <= '0';
                        if(round_count = 9) then
                            state <= final_read;
                            pause <= '0';
                        else
                            state <= read;
                            pause <= '0';
                        end if;
                    END IF;
                    report "i am in subbox state" ;
                -- Final read of round keys for XOR
                WHEN FINAL_READ =>
--                test <="0001";
--                    done <='1';
--                    abcd<=subbox_out_3;
--                    check<="1101"; --d
                    IF brom_done = '1' THEN

                        round_final_0 <= brom_data_out1;
                        round_final_1 <= brom_data_out2;
                        round_final_2 <= brom_data_out3;
                        round_final_3 <= brom_data_out4;
                        pause <='1';
                        state<=final_xor;
                    END IF;
                    report "i am in final_read state" ;
                    
                -- Final XOR operation
                WHEN FINAL_XOR =>
--                test <="0010";
--                    out1 <= brom_address & brom_address & brom_address & brom_address;
--                    out2 <=brom_data_out2;
--                    out3 <=brom_data_out3;
--                    out4 <=brom_data_out4;
--                    done <='0';
                    data_bram1 <= subbox_result_0 XOR round_final_0;
                    data_bram2 <= subbox_result_1 XOR round_final_1;
                    data_bram3 <= subbox_result_2 XOR round_final_2;
                    data_bram4 <= subbox_result_3 XOR round_final_3;
                    state <= WRITE;
                    bram_write_enable <= "1";
                    bram_pause<='0';
                    report "i am in final_xor state" ;
                -- Write final results back to memory



                WHEN WRITE =>
--                test <="0110";
--                        out1 <=data_bram1;
--                        out2 <=data_bram2;
--                        out3 <=data_bram3;
--                        out4 <=data_bram4;
--                    abcd <= data_bram4;
--                    check<=bram_done & bram_done & bram_done & bram_done; --5
                    IF bram_done = '1' THEN
--                        check<="1010"; --a
                        done <= '1';
                        state <= wait3;
                        bram_pause<='1';
                        bram_write_enable<="0";
                    END IF;
                    report "i am in write state" ;

                when wait3 =>
                
                    bram_pause<='0';
                    state <=wait4;

                when wait4 =>
                    bram_write_enable<="0";
                    state<=pause1;


--                WHEN READ3 =>
--                    check<= bram_done & bram_done & bram_done & bram_done;
--                    IF bram_done = '1' THEN
--                        check<="0001";
--                        -- Store data read from BRAM in 32-bit signals for further use
--                        data_read_0 <= bram_data_out1;
--                        data_read_1 <= bram_data_out2;
--                        data_read_2 <= bram_data_out3;
--                        data_read_3 <= bram_data_out4;

--                        state <= pause1;
--                        bram_pause <='1';
--                    END IF;
--                report "i am in read3 state" ;


                when pause1 =>
--                test <="0111";
--                abcd <= data_bram4;
--                check<="0011";

                    if start ='1' then
--                        done <='0';
                        state<=init;
                    end if;
                report "i am in pause1 state" ;
                -- Default to INIT if undefined state
                WHEN OTHERS =>
--                check<="1100"; --c
                    state <= INIT;
                    report "i am in other state" ;
            END CASE;
            end if;
    END PROCESS;

END fsm_arch;