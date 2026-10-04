library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hexcount is
  port (
    clk_100MHz : in std_logic;
    anode : out std_logic_vector(7 downto 0);
		seg : out std_logic_vector(6 downto 0)
	);
end hexcount;

architecture Behavioral of hexcount is
  component counter is
    port (
      clk : in std_logic;
		  count : out std_logic_vector(3 downto 0)
		);
  end component;
  
  component leddec is
    port (
			dig : in std_logic_vector(2 downto 0);
			data : in std_logic_vector(3 downto 0);
			anode : out std_logic_vector(7 downto 0);
			seg : out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal S : std_logic_vector(3 DOWNTO 0);
	signal clk_r : std_logic := '0'; -- Added clk signal which will run slower than the clk from the board
	signal clk_ct : std_logic_vector(2 downto 0) := "000"; -- Added clk_ct to track cycles of system clock; also used to control dig
	
  begin
    C1 : counter
      port map (
        clk => clk_r, -- Change counter to map clk to the slowed clk_r instead of clk_100MHz
        count => S
	    );
	  
	  L1 : leddec
	    port map (
	      dig => clk_ct, -- Mapped to a signal now instead of constant "000"
	      data => S, 
	      anode => anode, 
	      seg => seg
	   );
	   
	   -- Add clocked process which will change the value of clk_r every 10th cycle of clk_100MHz
	   process(clk_100MHz)
	   begin
	     if rising_edge(clk_100MHz) then
	       if (clk_ct = "111") then
	         clk_r <= not clk_r;
	         clk_ct <= "000";
	       else
	         clk_ct <= std_logic_vector(unsigned(clk_ct) + 1);
	       end if;
	     end if;
	   end process;
end Behavioral;
