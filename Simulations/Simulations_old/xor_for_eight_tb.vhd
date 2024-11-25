----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/25/2024 02:57:34 PM
-- Design Name: 
-- Module Name: xor_for_eight_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xor_for_eight_tb is
--  Port ( );
end xor_for_eight_tb;

architecture Behavioral of xor_for_eight_tb is
component xor_for_eight is
    Port ( input1  : in  std_logic_vector(7 downto 0); -- State
           input2  : in  std_logic_vector(7 downto 0); -- Round Key
           result  : out std_logic_vector(7 downto 0)
           );
           
end component;
signal input1 : std_logic_vector(7 downto 0);
signal input2 : std_logic_vector(7 downto 0);
signal output :  std_logic_vector(7 downto 0);
begin
uut : xor_for_eight port map (
input1,input2,output);
process begin 
 input1 <= "10101001";
 input2 <= "10001010";
 wait for 10 ns;
  input1 <= "11111111";
 input2 <= "10010001";
 wait for 10 ns;
  input1 <= "11111111";
 input2 <= "00000000";
 wait for 10 ns;
  input1 <= "10101010";
 input2 <= "01010101";
 wait for 10 ns;
  input1 <= "11100010";
 input2 <= "00011111";
 wait for 10 ns;
end process;
end Behavioral;
