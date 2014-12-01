----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:13:03 12/01/2014 
-- Design Name: 
-- Module Name:    TMR_voter - Behavioral 
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

entity TMR_voter is

	generic (
		WIDTH : natural := 32
	);
	
	port (
		A : in std_logic_vector(WIDTH - 1 downto 0);
		B : in std_logic_vector(WIDTH - 1 downto 0);
		C : in std_logic_vector(WIDTH - 1 downto 0);
		ERR_DETECT : out std_logic;
		OUTPUT : out std_logic_vector(WIDTH - 1 downto 0)
	);

end TMR_voter;

architecture Behavioral of TMR_voter is
	signal AANDB, AANDC, BANDC : std_logic_vector(WIDTH - 1 downto 0);
	signal AXORB, AXORC, BXORC : std_logic_vector(WIDTH - 1 downto 0);
begin

	AANDB <= A and B;
	AANDC <= A and C;
	BANDC <= B and C;
	AXORB <= A xor B;
	AXORC <= A xor C;
	BXORC <= B xor C;
	
	OUTPUT <= AANDB or BANDC or AANDC;
	ERR_DETECT <= '1' when ((unsigned(AXORB) > 0) or (unsigned(AXORC) > 0) or (unsigned(BXORC) > 0)) else '0';

end Behavioral;


