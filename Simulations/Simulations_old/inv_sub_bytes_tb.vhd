library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity inv_sub_bytes_tb IS
 
END inv_sub_bytes_tb;


Architecture behavioral of inv_sub_bytes_tb is

signal addra : std_logic_vector(7 downto 0);
signal douta :  std_logic_vector (7 downto 0) := "00000000";
signal clka : std_logic := '0';


component InverseSubBytes is
   Port (
      clk : in std_logic;
      input_byte_address : in std_logic_vector(7 downto 0);
      inv_sub_byte : out std_logic_vector(7 downto 0)
   );
end component;


begin
uut : InverseSubBytes
port map (
clka,addra,douta
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


wait ;
        
end process;
end behavioral;