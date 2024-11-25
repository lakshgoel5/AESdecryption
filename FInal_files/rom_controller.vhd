LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
--USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rom_controller IS
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
END rom_controller;

ARCHITECTURE Behavioral OF rom_controller IS
    COMPONENT blk_mem_gen_1
        PORT (
            clka  : IN STD_LOGIC;
            ena   : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL byte_accum : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');  -- Accumulate each 32-bit vector
    SIGNAL addra      : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    SIGNAL rom_douta  : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Internal signal to hold data output from ROM
    SIGNAL byte_count : INTEGER := 0;  -- Tracks byte count within a 32-bit vector
    SIGNAL read_count : INTEGER := 0;  -- Tracks number of 32-bit vectors read

    SIGNAL clk_counter: INTEGER := 0;  -- Clock counter for 3-cycle trigger
    CONSTANT IDLE     : INTEGER := 0;
    CONSTANT READ     : INTEGER := 1;
    CONSTANT STABLE   : INTEGER := 2;
    SIGNAL state      : INTEGER := IDLE;  -- FSM state tracking

BEGIN
    -- Instantiate ROM component
    U1 : blk_mem_gen_1
        PORT MAP (
            clka => clk,
            ena  => '1',  -- Enable ROM always high
            addra => addra,
            douta => rom_douta
        );

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) then

            -- Increment the clock counter and check if it has reached 3
            clk_counter <= clk_counter + 1;

            IF clk_counter = 4 THEN
                clk_counter <= 0;  -- Reset counter after 3 cycles

                IF start = '1' and pause = '0' THEN  -- Only run FSM when start is high and done is low
                    CASE state IS
                        WHEN IDLE =>

                            -- Initialize signals and move to READ state
                            douta1 <= (others => '0');
                            douta2 <= (others => '0');
                            douta3 <= (others => '0');
                            douta4 <= (others => '0');
                            byte_accum <= (others => '0');
                            byte_count <= 0;
                            read_count <= 0;
                            addra <= starting_address;
                            state <= READ;

                        WHEN READ =>
                            -- Accumulate bytes into 32-bit vectors


                            -- If 4 bytes (32 bits) accumulated, store in douta1 to douta4 based on read_count
                            IF byte_count = 4 THEN
                                CASE read_count IS
                                    WHEN 0 => douta1 <= byte_accum;
                                    WHEN 1 => douta2 <= byte_accum;
                                    WHEN 2 => douta3 <= byte_accum;
                                    WHEN 3 => douta4 <= byte_accum;
                                    WHEN OTHERS => NULL;
                                END CASE;

                                -- Reset byte count and increment read_count
                                byte_count <= 0;
                                read_count <= read_count + 1;

                                -- If all four 32-bit vectors are stored, set done and go to STABLE
                                IF read_count = 4 THEN
                                    done <= '1';


                                    state <= STABLE;
                                END IF;
                                else
                                    byte_accum <= byte_accum(23 DOWNTO 0) & rom_douta;  -- Shift left and append rom_douta (8-bit)

                                    -- Increment address for next byte read
                                    addra <= std_logic_vector(unsigned(addra) + 1);
                                    byte_count <= byte_count + 1;
                            END IF;

                        WHEN STABLE =>
--                        check_green <= '1';
                            -- Transition back to IDLE and reset done
--                            start <= '0';package
                            done <= '0';
                            if pause ='0' then
                                state <= IDLE;
                            end if;

                        WHEN OTHERS =>
                            state <= IDLE;  -- Default to IDLE state
                    END CASE;
                    else
                    done <='0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;