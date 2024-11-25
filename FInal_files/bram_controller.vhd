LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY bram_controller IS
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
END bram_controller;

ARCHITECTURE behavior OF bram_controller IS
COMPONENT blk_mem_gen_0 IS
   PORT (
     clka   : IN  STD_LOGIC;
     ena    : IN  STD_LOGIC;
     wea    : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
     addra  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
     dina   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
     douta  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
 END COMPONENT;

  SIGNAL byte_accum : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');  -- Accumulate each 32-bit vector
   SIGNAL addra00      : STD_LOGIC_VECTOR(7 DOWNTO 0) := start_address;
   SIGNAL rom_douta  : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Internal signal to hold data output from ROM
   SIGNAL rom_dina : STD_LOGIC_VECTOR(7 downto 0 );
   SIGNAL byte_count : INTEGER := 0;  -- Tracks byte count within a 32-bit vector
   SIGNAL outer_count : INTEGER := 0;  -- Tracks number of 32-bit vectors read
   SIGNAL state      : INTEGER := 0;  -- FSM state tracking
   SIGNAL clk_counter: INTEGER := 0;  -- Clock counter for 3-cycle trigger
   CONSTANT IDLE     : INTEGER := 0;
   CONSTANT READ     : INTEGER := 1;
   CONSTANT STABLE   : INTEGER := 2;
   CONSTANT WRITE : INTEGER := 3;
   CONSTANT wait1 : integer := 4;
   CONSTANT wait2 : integer := 5;
   CONSTANT wait3 : integer := 6;
   CONSTANT wait4 : integer := 7;
   SIGNAL write_me : STD_LOGIC_VECTOR(31 DOWNTO 0);


   BEGIN
   -- Instantiate RAM component
   U1 : blk_mem_gen_0
       PORT MAP (
           clka => clka,
           ena  => '1',  -- Enable ROM always high
           wea => write_enable,
           addra => addra00,
           dina => rom_dina,
           douta => rom_douta
       );

   PROCESS (clka)
   BEGIN
       IF rising_edge(clka) THEN
           -- Increment the clock counter and check if it has reached 3
           clk_counter <= clk_counter + 1;

           IF clk_counter = 3 THEN
               clk_counter <= 0;  -- Reset counter after 3 cycles

               IF start = '1' AND pause = '0' THEN  -- Only run FSM when start is high and done is low
                   CASE state IS
                       WHEN IDLE =>
                           -- Initialize signals and move to READ state
                           douta1 <= (others => '0');
                           douta2 <= (others => '0');
                           douta3 <= (others => '0');
                           douta4 <= (others => '0');
                           byte_accum <= (others => '0');
                           write_me <= dina1;
                           byte_count <= 0;
                           outer_count <= 0;
                           addra00 <= start_address;
                           if write_enable = "1" then
                               state <= WRITE;
                            else
                                state <= READ;

                             end if;

                       WHEN READ =>


                           -- If 4 bytes (32 bits) accumulated, store in douta1 to douta4 based on read_count
                           IF byte_count = 4 THEN
                               CASE outer_count IS
                                   WHEN 0 => douta1 <= byte_accum;
                                   WHEN 1 => douta2 <= byte_accum;
                                   WHEN 2 => douta3 <= byte_accum;
                                   WHEN 3 => douta4 <= byte_accum;
                                   WHEN OTHERS => NULL;
                               END CASE;

                               -- Reset byte count and increment read_count
                               byte_count <= 0;
                               outer_count <= outer_count + 1;

                               -- If all four 32-bit vectors are stored, set done and go to STABLE
                               IF outer_count = 4 THEN
                                   done <= '1';
                                   state <= STABLE;
                               END IF;

                            else
                                     -- Accumulate bytes into 32-bit vectors
                           byte_accum <= byte_accum(23 DOWNTO 0) & rom_douta;  -- Shift left and append rom_douta (8-bit)

                           -- Increment address for next byte read
                           addra00 <= std_logic_vector(unsigned(addra00) + 1);
                           byte_count <= byte_count + 1;
                           END IF;


                       WHEN WRITE =>

                               -- If 4 bytes (32 bits) accumulated, store in douta1 to douta4 based on read_count
                           IF byte_count = 4 THEN
                               CASE outer_count IS
                                   WHEN 0 =>  write_me <= dina2;
                                   WHEN 1 =>  write_me <= dina3;
                                   WHEN 2 =>  write_me <= dina4;

                                   WHEN OTHERS => NULL;
                               END CASE;

                               -- Reset byte count and increment read_count
                               byte_count <= 0;
                               outer_count <= outer_count + 1;

                               -- If all four 32-bit vectors are stored, set done and go to STABLE
                               IF outer_count = 4 THEN
                                   done <= '1';
                                   state <= STABLE;
                               END IF;

                            else
                                     -- Accumulate bytes into 32-bit vectors
                          --- byte_accum <= byte_accum(23 DOWNTO 0) & rom_douta;  -- Shift left and append rom_douta (8-bit)

                          rom_dina <= write_me( (31 - byte_count*8) downto (24 - byte_count*8) );
                          state <= wait1;

                          END IF;

                          when wait1 =>

                           -- Increment address for next byte read
                          state <= wait2;


                          when wait2 =>
                          state <= wait4;





                          when wait4 =>

                           -- Increment address for next byte read
                           addra00 <= std_logic_vector(unsigned(addra00) + 1);
                           byte_count <= byte_count + 1;
                           state <= write;

                       WHEN STABLE =>
                           -- Transition back to IDLE and reset done

                           if pause ='0' then
                               done <= '0';
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

END behavior;


