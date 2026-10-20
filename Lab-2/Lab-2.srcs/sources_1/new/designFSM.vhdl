-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
	port (X, CLK, RESET: in std_logic;
    Y : out std_logic_vector(2 downto 0);
    Z : out std_logic);
end fsm;

 architecture fsmMealy00011 of fsm is
 	type state_type is (A, B, C, D, E);
     signal PS, NS : state_type;
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then PS <= A;
         elsif (rising_edge(CLK)) then PS <= NS;
         end if;
   	end process clockAndReset;
 -- From state A, a 1 outputs a 0 and goes to state A
 -- From state A, a 0 outputs a 0 and goes to state B
 -- B: 1/0 -> A
 -- B: 0/0 -> C
 -- C: 1/0 -> A
 -- C: 0/0 -> D
 -- D: 1/0 -> E 
 -- D: 0/0 -> D
 -- E: 1/1 -> A 
 -- E: 0/0 -> B    
     stateAndOutputLogic : process(PS, X)
     begin
     case PS is
     	when A =>
         	if (X = '1') then Z<='0'; NS <= A;
             else Z <= '0'; NS <= B;
             end if;
         when B =>
         	 if (X = '1') then Z <= '0'; NS <= A;
             else Z <= '0'; NS <= C;
             end if;
         when C =>
          	if (X = '1') then Z <= '0'; NS <= A;
             else Z <= '0'; NS <= D;
             end if;
         when D =>
         	 if (X = '1') then Z <= '0'; NS <= E;
             else Z <= '0'; NS <= D;
             end if;
         when E =>
         	 if (X = '1') then Z <= '1'; NS <= A;
             else Z <= '0'; NS <= B;
             end if;
         end case;
     end process stateAndOutputLogic;
    
     with PS select
     Y <= "000" when A,
     	  "001" when B,
          "010" when C,
          "011" when D,
          "100" when E,
          "000" when others;
 end fsmMealy00011; 
