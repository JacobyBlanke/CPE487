library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    dig : in std_logic_vector(2 downto 0);
    data : in std_logic_vector(3 downto 0);
    anode : out std_logic_vector(7 downto 0);
    seg : out std_logic_vector(6 downto 0)
  );
end entity;

architecture comb of top is

  component leddec is
    port(
        dig   : in std_logic_vector(2 downto 0);
        data  : in std_logic_vector(3 downto 0);
        anode : out std_logic_vector(7 downto 0);
        seg   : out std_logic_vector(6 downto 0)
    );
  end component;
  
begin

  u_leddec : entity work.leddec
    port map (
      dig => dig,
      data => data,
      anode => anode,
      seg => seg
    );

end comb;
