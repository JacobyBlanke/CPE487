-- counter.vhd --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	port (
		clk : in std_logic;
		count : out std_logic_vector(15 downto 0); 
		mpx : out std_logic_vector(1 downto 0)); 
end counter;

architecture Behavioral of counter is
	signal cnt : std_logic_vector(38 downto 0); -- 39-bit counter
	
	component fsm is
	  port (
	    X : in std_logic;
      	CLK : in std_logic;
      	RESET : in std_logic;
      	Y : out std_logic_vector(2 downto 0);
      	Z : out std_logic
	  );
	end component;
	
	signal fsm_in : std_logic;
  	signal fsm_out : std_logic;
  	signal state : std_logic_vector (2 downto 0);
  	signal add : std_logic := '0'; --low for add, high for sub
  	signal state_digit : std_logic_vector(3 downto 0); -- state as a hex digit, 1..5

begin
  
  fsm00011 : fsm
	port map (
	  X => fsm_in,
	  CLK => clk,
	  RESET => '0',
	  Y => state,
	  Z => fsm_out
	);

	process(clk)
	begin
	  if rising_edge(clk) then
			if (fsm_out = '1') then
				add <= not add;
			end if;
 
			if (add = '0') then
				cnt <= cnt + 1;
			else
				cnt <= cnt - 1;
			end if;
		end if;
	end process;
			
	fsm_in <= cnt(27);
 	count <= cnt (38 DOWNTO 23); -- 16 bits
	mpx <= cnt(18 DOWNTO 17); -- 2 bit
end Behavioral;
