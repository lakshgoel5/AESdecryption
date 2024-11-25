library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Only include this library

entity InverseSubBytes is
   Port (
      clk : in std_logic;
      input_byte_address : in std_logic_vector(7 downto 0);
      inv_sub_byte : out std_logic_vector(7 downto 0)
   );
end InverseSubBytes;

architecture Behavioral of InverseSubBytes is

    -- memory of INV_SBOX lookup table
    COMPONENT blk_mem_gen_2
    PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
    END COMPONENT;

    signal mem_data_out : std_logic_vector(7 downto 0);
--    constant clock_period : time := 10 ns;
begin

    -- Memory for INV_SBOX lookup table
    M1: blk_mem_gen_2
        Port map (
    clka => clk,
    ena => '1',
    addra => input_byte_address,
    douta => inv_sub_byte
  );

end Behavioral;