library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_2X1_gate is
Port ( d1 : in STD_LOGIC_vector (7 downto 0);
        d2 : in STD_LOGIC_vector (7 downto 0);
        o : out STD_LOGIC_vector (7 downto 0);
         s1 : in STD_LOGIC);
end mux_2X1_gate;
architecture Behavioral of mux_2X1_gate is
    component AND_gate
        Port (
            X : in STD_LOGIC_vector (7 downto 0);
            Y : in STD_LOGIC;
            Z : out STD_LOGIC_vector (7 downto 0)
        );
    end component;
    component OR_gate
        Port (
            M : in STD_LOGIC_vector (7 downto 0);
            N : in STD_LOGIC_vector (7 downto 0);
            u : out STD_LOGIC_vector (7 downto 0)
        );
    end component;
    component NOT_gate
        Port (
            p : in STD_LOGIC;
            q : out STD_LOGIC
        );
    end component;
    signal not_s: STD_LOGIC;
    signal and_1, and_2: STD_LOGIC_vector (7 downto 0);
begin
  U1: NOT_gate
  port map(
    p=> s1,
    q=> not_s
  );
  U2: AND_gate
  port map(
    X=>d1, Y=>s1, Z=> and_1
  );
  U3: AND_gate
  port map(
    X=> d2, Y=>not_s, Z=>and_2
  );
  U4: OR_gate
  port map(
    M=>and_1, N=>and_2, u=>o
  );
end Behavioral;