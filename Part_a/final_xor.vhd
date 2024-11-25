library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR_Block is
    Port ( input1  : in  std_logic_vector(127 downto 0); -- State
           input2  : in  std_logic_vector(127 downto 0); -- Round Key
           result  : out std_logic_vector(127 downto 0);
           clk     : in  std_logic  -- Clock signal for sequential XOR
           );
end XOR_Block;

architecture Behavioral of XOR_Block is
    signal temp_result : std_logic_vector(127 downto 0);
    signal counter     : integer range 0 to 15 := 0; -- For 16 chunks of 8 bits
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case counter is
                when 0  => temp_result(7 downto 0)    <= input1(7 downto 0) xor input2(7 downto 0);
                when 1  => temp_result(15 downto 8)   <= input1(15 downto 8) xor input2(15 downto 8);
                when 2  => temp_result(23 downto 16)  <= input1(23 downto 16) xor input2(23 downto 16);
                when 3  => temp_result(31 downto 24)  <= input1(31 downto 24) xor input2(31 downto 24);
                when 4  => temp_result(39 downto 32)  <= input1(39 downto 32) xor input2(39 downto 32);
                when 5  => temp_result(47 downto 40)  <= input1(47 downto 40) xor input2(47 downto 40);
                when 6  => temp_result(55 downto 48)  <= input1(55 downto 48) xor input2(55 downto 48);
                when 7  => temp_result(63 downto 56)  <= input1(63 downto 56) xor input2(63 downto 56);
                when 8  => temp_result(71 downto 64)  <= input1(71 downto 64) xor input2(71 downto 64);
                when 9  => temp_result(79 downto 72)  <= input1(79 downto 72) xor input2(79 downto 72);
                when 10 => temp_result(87 downto 80)  <= input1(87 downto 80) xor input2(87 downto 80);
                when 11 => temp_result(95 downto 88)  <= input1(95 downto 88) xor input2(95 downto 88);
                when 12 => temp_result(103 downto 96) <= input1(103 downto 96) xor input2(103 downto 96);
                when 13 => temp_result(111 downto 104) <= input1(111 downto 104) xor input2(111 downto 104);
                when 14 => temp_result(119 downto 112) <= input1(119 downto 112) xor input2(119 downto 112);
                when 15 => temp_result(127 downto 120) <= input1(127 downto 120) xor input2(127 downto 120);
                result <= temp_result; -- Assign result once all chunks are processed
                counter <= -1; -- Reset the counter
            end case;

            counter <= counter + 1; -- Increment counter
        end if;
    end process;
end Behavioral;
