LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rom_controller_tb IS
END rom_controller_tb;

ARCHITECTURE Behavioral OF rom_controller_tb IS
   -- Signals for the DUT
   SIGNAL clk              : STD_LOGIC := '0';
   SIGNAL start            : STD_LOGIC := '0';
   SIGNAL starting_address : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
   SIGNAL ena              : STD_LOGIC := '1';
   SIGNAL done,pause             : STD_LOGIC;
   SIGNAL douta1, douta2, douta3, douta4 : STD_LOGIC_VECTOR(31 DOWNTO 0);

   -- Instantiate the DUT (Device Under Test)
   COMPONENT rom_controller
       PORT (
           clk              : IN  STD_LOGIC;
           start            : in  STD_LOGIC;
           starting_address : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
           ena              : IN  STD_LOGIC;
           done             : OUT STD_LOGIC;
           douta1           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
           douta2           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
           douta3           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
           douta4           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
           pause : in std_logic
       );
   END COMPONENT;

BEGIN
   -- Instantiate the ROM controller
   uut: rom_controller
       PORT MAP (
           clk              => clk,
           start            => start,
           starting_address => starting_address,
           ena              => ena,
           done             => done,
           douta1           => douta1,
           douta2           => douta2,
           douta3           => douta3,
           douta4           => douta4,
           pause => pause
       );

   -- Clock generation process
   clk_process : PROCESS
   BEGIN
       clk <= '0';
       WAIT FOR 5 ns;
       clk <= '1';
       WAIT FOR 5 ns;
   END PROCESS;

   -- Test process
   stim_proc: PROCESS
   BEGIN
       -- Initial delay
       WAIT FOR 10 ns;
       start <= '1';
       pause <= '0';                -- Set start high to begin reading
       starting_address <= "00000000"; -- Set a starting address
       WAIT until done='1';
       pause <= '1';
       
       start <= '0';                -- Reset start to low after some time
       WAIT FOR 50 ns;
       pause <='0';
       start <= '1';                -- Restart the operation with a different address
       starting_address <= "00010000";
       WAIT until done='1';
       pause <='1';

       -- Stop the simulation
       WAIT;
   END PROCESS;

END Behavioral;