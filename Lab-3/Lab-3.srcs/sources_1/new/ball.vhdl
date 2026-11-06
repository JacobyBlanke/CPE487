LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--red, green, and blue have been made into vectors
ENTITY ball IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		green     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		blue      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
	--Ball 1
	CONSTANT size  : INTEGER := 8;
	SIGNAL ball_on : STD_LOGIC;
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100"; -- +4 

  --Ball 2 (circle). starting x and y are different so they dont overlap with ball1, and theres additional x motion with slower y motion
  CONSTANT radius : INTEGER := 12;
	SIGNAL ball2_on : STD_LOGIC; 
	SIGNAL ball2_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(200, 11);
	SIGNAL ball2_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
	SIGNAL ball2_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100"; -- +4 
	SIGNAL ball2_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000010"; -- +2
BEGIN

  --process to pick which color information to show (ball1 has priority, then ball2, otherwise just background color info)
	colour : PROCESS (ball_on, ball2_on) IS
	BEGIN
		IF ball_on = '1' THEN
			red   <= "111";
			green <= "000";
			blue  <= "00";
		ELSIF ball2_on = '1' THEN
			red   <= "000";
			green <= "111";
			blue  <= "00";
		ELSE
			red   <= "111";
			green <= "111";
			blue  <= "11";
		END IF;
	END PROCESS;

	-- process to draw ball current pixel address is covered by ball position
	sq_draw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= ball_x - size) AND
		   (pixel_col <= ball_x + size) AND
		   (pixel_row >= ball_y - size) AND
		   (pixel_row <= ball_y + size) THEN
			ball_on <= '1';
		ELSE
			ball_on <= '0';
		END IF;
	END PROCESS;

	--draws circle, (col - x)^2 + (row - y)^2 <= radius^2
	ci_draw : PROCESS (ball2_x, ball2_y, pixel_row, pixel_col) IS
		VARIABLE dx, dy : INTEGER RANGE -2047 TO 2047;
	BEGIN
		dx := CONV_INTEGER(pixel_col) - CONV_INTEGER(ball2_x);
		dy := CONV_INTEGER(pixel_row) - CONV_INTEGER(ball2_y);
		IF (((dx * dx) + (dy * dy)) <= (radius * radius)) THEN
			ball2_on <= '1';
		ELSE
			ball2_on <= '0';
		END IF;
	END PROCESS;
	
	-- process to move ball once every frame (i.e. once every vsync pulse)
	mball : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(v_sync);

		-- Ball 1: bounce off top / bottom
		IF ball_y + size >= 600 THEN
			ball_y_motion <= "11111111100"; -- -4
		ELSIF ball_y <= size THEN
			ball_y_motion <= "00000000100"; -- +4
		END IF;
		ball_y <= ball_y + ball_y_motion;

		-- Ball 2: bounce off left / right
		IF ball2_x + radius >= 800 THEN
			ball2_x_motion <= "11111111100"; -- -4
		ELSIF ball2_x <= radius THEN
			ball2_x_motion <= "00000000100"; -- +4
		END IF;
		-- Ball 2: bounce off top / bottom
		IF ball2_y + radius >= 600 THEN
			ball2_y_motion <= "11111111110"; -- -2
		ELSIF ball2_y <= radius THEN
			ball2_y_motion <= "00000000010"; -- +2
		END IF;
		ball2_x <= ball2_x + ball2_x_motion;
		ball2_y <= ball2_y + ball2_y_motion;
	END PROCESS;
END Behavioral;