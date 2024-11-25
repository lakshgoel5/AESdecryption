---Code your design here
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity seven_seg_decoder_2 is
Port (
variables : in STD_LOGIC_VECTOR (3 downto 0); -- Reset signal
cathodes : out STD_LOGIC_VECTOR (7 downto 0)-- Anodes signal for display
);
end seven_seg_decoder_2;

architecture Behavioural of seven_seg_decoder_2 is
begin
P1: process(variables)
          variable a : STD_LOGIC;
        variable b : STD_LOGIC;
        variable c : STD_LOGIC;
        variable d : STD_LOGIC;
    begin
    a:= variables(3);
     b:= variables(2);
     c:= variables(1);
     d:= variables(0);
     if(variables = "----")
     then
     cathodes<="11111101";
--     end if;
        else     
        cathodes(7) <= ((not a) and (not b) and (not c) and (d)) or ((not a) and ( b) and (not c) and (not d)) 
        or (( a) and ( b) and (not c) and (d))
        or (( a) and (not b) and ( c) and (d));
        cathodes(6) <= ((not a) and ( b) and (not c) and ( d)) or (( a) and ( b) and (not c) and (not d)) or
         (( b) and ( c) and (not d)) or (( a) and ( c) and ( d));
        cathodes(5) <= ((not a) and ( not b) and ( c) and (not d)) or 
        (( a) and ( b) and (not c) and (not d)) or (( b) and ( c) and (a));
        cathodes(4) <= ((not a) and ( not b) and (not  c) and ( d)) or ((not a) and (  b) and ( not c) and (not d)) or 
        ((  b) and ( c) and ( d)) or (( a) and ( not b) and ( c) and (not d));
        cathodes(3) <= ((not a) and ( d)) or ((not a) and (  b) and (not  c)) or 
        (( not b) and ( not c) and ( d));
        cathodes(2) <= ((not a) and ( not b) and ( c)) or ((not a) and ( not b) and ( d)) or 
        ((not a) and ( c) and ( d)) or (( a) and (  b) and ( not c) and ( d));
        cathodes(1) <= ((not a) and ( not b) and (not  c) ) or ((not a) and (  b) and ( c) and ( d)) or 
        (( a) and (  b) and ( not c) and (not d));
        cathodes(0) <= '0';
end if;
    end process;
end Behavioural;