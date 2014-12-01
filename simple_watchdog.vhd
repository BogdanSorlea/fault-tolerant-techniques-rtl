----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:52:12 12/01/2014 
-- Design Name: 
-- Module Name:    simple_watchdog - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_watchdog is

	generic (
		LIMIT : natural := 10
	);

	port (
		clk : in std_logic;
		watchdog_clear : in std_logic;
		reset : out std_logic
	);

end simple_watchdog;

architecture Behavioral of simple_watchdog is

	signal count : std_logic_vector(36 downto 0);

begin

	process(clk, watchdog_clear)
	begin
		if watchdog_clear = '1' then
			count <= (others => '0');
			reset <= '0';
		elsif rising_edge(clk) then
			if (unsigned(count) = LIMIT) then
				count <= (others => '0');
				reset <= '1';
			else
				count <= std_logic_vector(unsigned(count) + 1);
				reset <= '0';
			end if;
			
		end if;
	end process;

end Behavioral;

