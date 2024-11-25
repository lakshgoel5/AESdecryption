library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity four_subbytes is
    Port (
        clk          : in std_logic;
        start : in std_logic;
        input_row_0  : in std_logic_vector(31 downto 0);
        input_row_1  : in std_logic_vector(31 downto 0);
        input_row_2  : in std_logic_vector(31 downto 0);
        input_row_3  : in std_logic_vector(31 downto 0);

        output_row_0 : out std_logic_vector(31 downto 0);
        output_row_1 : out std_logic_vector(31 downto 0);
        output_row_2 : out std_logic_vector(31 downto 0);
        output_row_3 : out std_logic_vector(31 downto 0);
        subbox_done: out std_logic:='0'
    );
end four_subbytes;

architecture Behavioral of four_subbytes is

    component InverseSubBytes
        Port (
            clk               : in std_logic;
            input_byte_address: in std_logic_vector(7 downto 0);
            inv_sub_byte      : out std_logic_vector(7 downto 0)
        );
    end component;

    type byte_array is array (0 to 3) of std_logic_vector(7 downto 0);

    signal row_0, row_1, row_2, row_3 : byte_array;
    signal output_byte                 : std_logic_vector(7 downto 0);
    signal result_row_0, result_row_1, result_row_2, result_row_3 : std_logic_vector(31 downto 0);

    signal current_byte_idx : integer range 0 to 16 := 0;
    signal processing       : boolean := false;
    signal cycle_count      : integer := 0;
    signal selected_byte    : std_logic_vector(7 downto 0);

begin

    -- Instance of the InverseSubBytes module
    InvSubBytes: InverseSubBytes
        Port map (
            clk => clk,
            input_byte_address => selected_byte,
            inv_sub_byte => output_byte
        );

    process(clk)
    begin
        if rising_edge(clk) then
        if(start ='1') then
            if processing = false then
                -- Load input rows into 8-bit segments for processing
                row_0 <= (input_row_0(31 downto 24), input_row_0(23 downto 16), input_row_0(15 downto 8), input_row_0(7 downto 0));
                row_1 <= (input_row_1(31 downto 24), input_row_1(23 downto 16), input_row_1(15 downto 8), input_row_1(7 downto 0));
                row_2 <= (input_row_2(31 downto 24), input_row_2(23 downto 16), input_row_2(15 downto 8), input_row_2(7 downto 0));
                row_3 <= (input_row_3(31 downto 24), input_row_3(23 downto 16), input_row_3(15 downto 8), input_row_3(7 downto 0));
                processing <= true;
                current_byte_idx <= 0;
                cycle_count <= 0;
            elsif processing = true then
                if cycle_count = 3 then  -- After 2 cycles, retrieve and store the result
                    case current_byte_idx / 4 is
                        when 0 => result_row_0((3 - (current_byte_idx mod 4)) * 8 + 7 downto (3 - (current_byte_idx mod 4)) * 8) <= output_byte;
                        when 1 => result_row_1((3 - (current_byte_idx mod 4)) * 8 + 7 downto (3 - (current_byte_idx mod 4)) * 8) <= output_byte;
                        when 2 => result_row_2((3 - (current_byte_idx mod 4)) * 8 + 7 downto (3 - (current_byte_idx mod 4)) * 8) <= output_byte;
                        when 3 => result_row_3((3 - (current_byte_idx mod 4)) * 8 + 7 downto (3 - (current_byte_idx mod 4)) * 8) <= output_byte;
                        when others => null;
                    end case;
                    current_byte_idx <= current_byte_idx + 1;
                    cycle_count <= 0;
                    if current_byte_idx = 16 then
                        processing <= false;  -- All bytes processed
                        subbox_done <= '1';
                    end if;
                else
                    cycle_count <= cycle_count + 1;
                end if;
            end if;
            else
                subbox_done <='0';
            end if;
        end if;
        
        
    end process;

    -- Select the byte to be used as input to InverseSubBytes
    selected_byte <= row_0(current_byte_idx mod 4) when current_byte_idx / 4 = 0 else
                     row_1(current_byte_idx mod 4) when current_byte_idx / 4 = 1 else
                     row_2(current_byte_idx mod 4) when current_byte_idx / 4 = 2 else
                     row_3(current_byte_idx mod 4);

    -- Assign output rows
    output_row_0 <= result_row_0;
    output_row_1 <= result_row_1;
    output_row_2 <= result_row_2;
    output_row_3 <= result_row_3;

end Behavioral;