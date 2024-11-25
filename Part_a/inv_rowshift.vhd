library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InvRowShift is
    Port ( state_in  : in  std_logic_vector(31 downto 0); -- 4x4 matrix (128 bits total)
           state_out : out std_logic_vector(31 downto 0);
           row_number : in std_logic_vector(1 downto 0)); -- check debug
end InvRowShift;

architecture Behavioral of InvRowShift is
signal yo : std_logic_vector(7 downto 0); -- Declare yo as a signal
    component multiplexer
    Port ( d1 : in std_logic_vector(7 downto 0);
            d2 : in std_logic_vector(7 downto 0);
            d3 : in std_logic_vector(7 downto 0);
            d4 : in std_logic_vector(7 downto 0);
            o : out std_logic_vector(7 downto 0);
            s: in std_logic_vector(1 downto 0)
            );
    end component;
begin

M1: multiplexer port map(
            d1=>state_in(31 downto 24),
            d2=>state_in(23 downto 16),
            d3=>state_in(15 downto 8),
            d4=>state_in(7 downto 0),
            o=>state_out(31 downto 24),
            s=>yo(1 downto 0)
        );
        M2: multiplexer port map(
            d1=>state_in(31 downto 24),
            d2=>state_in(23 downto 16),
            d3=>state_in(15 downto 8),
            d4=>state_in(7 downto 0),
            o=>state_out(23 downto 16),
            s=>yo(3 downto 2)
        );
        M3: multiplexer port map(
            d1=>state_in(31 downto 24),
            d2=>state_in(23 downto 16),
            d3=>state_in(15 downto 8),
            d4=>state_in(7 downto 0),
            o=>state_out(15 downto 8),
            s=>yo(5 downto 4)
        );
        M4: multiplexer port map(
            d1=>state_in(31 downto 24),
            d2=>state_in(23 downto 16),
            d3=>state_in(15 downto 8),
            d4=>state_in(7 downto 0),
            o=>state_out(7 downto 0),
            s=>yo(7 downto 6)
        );


    process(state_in,row_number)
    
    begin
        if row_number = "00" then
            yo <= "00011011";
        elsif row_number = "01" then
            yo <= "01101100";
        elsif row_number = "10" then
            yo <= "10110001";
        elsif row_number = "11" then
            yo <= "11000110";
        else
            yo <= "00000000";
        end if;

        
    end process;
end Behavioral;