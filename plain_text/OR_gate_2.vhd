----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/29/2024 04:33:59 PM
-- Design Name: 
-- Module Name: OR_gate - Behavioral
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

entity OR_gate_2 is
--  Port ( );
        Port (
            M : in STD_LOGIC_vector (3 downto 0);
            N : in STD_LOGIC_vector (3 downto 0);
            u : out STD_LOGIC_vector (3 downto 0)
        );
end OR_gate_2;

architecture Behavioral of OR_gate_2 is

begin
    process(M,N)
    
        begin
            for i in M'range loop
                u(i)<=M(i) or N(i);
            end loop;
        end process;
    

end Behavioral;
