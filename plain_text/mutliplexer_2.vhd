library ieee;
use ieee.std_logic_1164.all;
entity multiplexer_2 is
Port ( d1 : in std_logic_vector(3 downto 0);
        d2 : in std_logic_vector(3 downto 0);
        d3 : in std_logic_vector(3 downto 0);
        d4 : in std_logic_vector(3 downto 0);
        o : out std_logic_vector(3 downto 0);
        s: in std_logic_vector(1 downto 0)
             );
end multiplexer_2;
architecture Behavioral of multiplexer_2 is
    component mux_2X1_gate_2
        Port ( d1 : in std_logic_vector(3 downto 0);
                d2 : in std_logic_vector(3 downto 0);
                o : out std_logic_vector(3 downto 0);
                s1 : in STD_LOGIC
             );
    end component;
    signal m_1, m_2:std_logic_vector(3 downto 0);
begin
  U1: mux_2X1_gate_2
  port map(
    d1=> d1,
    d2=> d2,
    s1=>s(0),
    o=>m_1
  );
  U2:mux_2X1_gate_2
  port map(
    d1=>d3,
    d2=>d4,
    s1=>s(0),
    o=>m_2
  );
  U3: mux_2X1_gate_2
  port map(
    d1=>m_1,
    d2=>m_2,
    s1=>s(1),
    o=>o
  );
end Behavioral;