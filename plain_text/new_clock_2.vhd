---Code your design here
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Timing_block_2 is
Port (
clk_in : in STD_LOGIC; -- 100 MHz input clock
--reset : in STD_LOGIC; -- Reset signal
mux_select : out STD_LOGIC_VECTOR (1 downto 0); -- Signal for the mux
anodes : out STD_LOGIC_VECTOR (3 downto 0) -- Anodes signal for display
);
end Timing_block_2;




architecture Behavioral of Timing_block_2 is
constant N : integer := 100;-- <need to select correct value between 25,000 and 416,666>
signal counter: integer := 0;
signal new_clk : STD_LOGIC := '0';

--self

--self
begin


--Process 1 for dividing the clock from 100 Mhz to 1Khz - 60hz
new_clk_p: process(clk_in)
begin
--    if reset='1' then
--        counter<=0;
--        new_clk<='0';
    if rising_edge(clk_in) then
      if(counter=N) then
          new_clk<= not new_clk;
          counter<=0;
      else
        counter <= counter+1;
        end if;
    end if;
end process;

--check if begin, end needed in if
--check reset

--Process 2 for mux select signal
MUX_select_p: process(new_clk)
variable yo:std_logic_vector(1 downto 0) := "00";
begin
    if rising_edge(new_clk) then
        yo:=yo+1;
    end if;
    mux_select<=yo;
    
    if(yo="00") then
        anodes<="0111";
    elsif(yo="01") then
        anodes<="1011";
    elsif(yo="10") then
        anodes<="1101";
    elsif(yo="11") then
        anodes<="1110";
   else 
        anodes<="1110";
    end if;
    
end process;


--Process 3 for anode signal


end Behavioral;





