library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GF_Multiplier is
    Port ( red_input  : in  std_logic_vector(7 downto 0);
           multiplier : in std_logic_vector(7 downto 0); -- 0x09, 0x0B, 0x0D, 0x0E
           result  : out std_logic_vector(7 downto 0));
end GF_Multiplier;


architecture Behavioral of GF_Multiplier is
    
    component shift_xor_check 
        port (
        input_vector : in std_logic_vector(7 downto 0);
        result       : out std_logic_vector(7 downto 0)
    );
    end component;
    
    component shift_three 
         Port ( byte_in  : in  std_logic_vector(7 downto 0);
        byte_out: out std_logic_vector(7 downto 0));
     end component;
     
     component shift_two 
       Port ( byte_in  : in  std_logic_vector(7 downto 0);
        byte_out: out std_logic_vector(7 downto 0));
        end component;
    signal temp_2x, temp_3x ,temp_1x : std_logic_vector(7 downto 0);
begin

    -- Select multiplication by 0x09, 0x0B, 0x0D, 0x0E using MUX
     u1: shift_xor_check
        port map (
            input_vector => red_input,
            result  => temp_1x
        );
    
    -- Second instance: input is m1, output is m2
    u2: shift_two
        port map (
            byte_in => red_input,
            byte_out => temp_2x
        );
    
    -- Third instance: input is m2, output is byte_out
    u3: shift_three
        port map (
            byte_in => red_input,
            byte_out => temp_3x
        );
    process(temp_1x, temp_2x, temp_3x, multiplier, red_input)
    --  variable a : std_logic_vector
    begin
        case multiplier is
            when x"09" => 
                
                result <= temp_3x xor red_input;  -- Multiply by 0x09
            when x"0b" =>
                result <= (temp_3x xor temp_1x xor red_input);  -- Multiply by 0x0B
            when x"0d" =>
                result <= (temp_3x xor temp_2x xor red_input);  -- Multiply by 0x0D
            when x"0e" =>
                result <= temp_1x xor temp_2x xor temp_3x;  -- Multiply by 0x0E
            when others =>
                result <= red_input;  -- Default: No multiplication
        end case;
    end process;
end Behavioral;