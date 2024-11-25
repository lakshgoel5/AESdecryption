----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2024 02:53:47 AM
-- Design Name: 
-- Module Name: shift_three - Behavioral
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

entity shift_two is
  Port ( byte_in  : in  std_logic_vector(7 downto 0);
        byte_out: out std_logic_vector(7 downto 0));
end shift_two;

architecture Behavioral of shift_two is
    component shift_xor_check 
        port (
        input_vector : in std_logic_vector(7 downto 0);
        result       : out std_logic_vector(7 downto 0)
    );
    end component;

    signal m1: std_logic_vector(7 downto 0);
 begin
        -- First instance: input is byte_in, output is m1
    u1: shift_xor_check
        port map (
            input_vector => byte_in,
            result       => m1
        );
    
    -- Second instance: input is m1, output is m2
    u2: shift_xor_check
        port map (
            input_vector => m1,
            result       => byte_out
        );
    

end Behavioral;
