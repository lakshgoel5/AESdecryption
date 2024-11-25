LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY blk_mem_gen_tb IS
 
END blk_mem_gen_tb;


Architecture behavioral of blk_mem_gen_tb is

signal addra : std_logic_vector(7 downto 0);
signal douta :  std_logic_vector (7 downto 0);
signal clka : std_logic := '0';
signal ena : std_logic := '1';


component blk_mem_gen_1
port(
clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end component;


begin
uut : blk_mem_gen_1
port map (
clka =>clka,
    ena => ena,
    addra => addra,
    douta => douta

);
process
begin
 clka <= not clka after 10 ns; -- Clock with 20 ns period (50 MHz)
        wait for 10 ns;
    end process;



    stimulus : process
    begin
        -- Reset sequence
 
        wait for 50 ns;
  
        
        -- Step 1: Read from preloaded memory
        ena <= '1'; -- Enable memory
   
        
        addra <= "00000000"; -- Read from address 0
        wait for 40 ns;
        
        addra <= "00010000"; -- Read from address 1
        wait for 40 ns;
        
        addra <= "00100000"; -- Read from address 2
        wait for 40 ns;
        
        addra <= "00110001"; -- Read from address 3
        wait for 40 ns;
        
        addra <= "01000001"; -- Read from address 4
        wait for 40 ns;
        
        addra <= "01000000"; -- Read from address 4
        wait for 40 ns;
        
        addra <= "01000011"; -- Read from address 4
        wait for 40 ns;

ena <= '0';
wait ;
        
end process;
end behavioral;