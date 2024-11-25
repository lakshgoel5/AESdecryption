----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/29/2024 04:33:36 PM
-- Design Name: 
-- Module Name: AND_gate - Behavioral
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

entity AND_gate is
--  Port ( )
Port (
            X : in STD_LOGIC_vector (7 downto 0);
            Y : in STD_LOGIC;
            Z : out STD_LOGIC_vector (7 downto 0)
        );
end AND_gate;

architecture Behavioral of AND_gate is
    begin
    process(X,Y)
    
        begin
                Z(0)<=X(0) and Y;
                Z(1)<=X(1) and Y;
                Z(2)<=X(2) and Y;
                Z(3)<=X(3) and Y;
                Z(4)<=X(4) and Y;
                Z(5)<=X(5) and Y;
                Z(6)<=X(6) and Y;
                Z(7)<=X(7) and Y;
        end process;
        
    


end Behavioral;
