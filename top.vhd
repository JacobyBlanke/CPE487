library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    clk : in std_logic;
    dig : in std_logic_vector (2 downto 0);
    anode : out std_logic_vector(7 downto 0);
    seg : out std_logic_vector(6 downto 0)
  );
end entity;

architecture rtl of top is
  component counter is
    port(
        clk   : in std_logic;
        count : out std_logic_vector(3 downto 0)
    );
  end component;

  component leddec is
    port(
        dig   : in std_logic_vector(2 downto 0);
        data  : in std_logic_vector(3 downto 0);
        anode : out std_logic_vector(7 downto 0);
        seg   : out std_logic_vector(6 downto 0)
    );
  end component;

  signal data_r  : std_logic_vector(3 downto 0);

begin

  u_counter : entity work.counter
    port map (
      clk => clk,
      count => data_r
    );
 
  u_leddec : entity work.leddec
    port map (
      dig => dig,
      data => data_r,
      anode => anode,
      seg => seg
    );
  
  process(clk)
  begin
    if rising_edge(clk) then
    
    end if;
  end process;
end rtl;
