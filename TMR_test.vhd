--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:13:52 12/01/2014
-- Design Name:   
-- Module Name:   D:/work/vhdl/fault-tolerant-techniques-rtl/TMR_test.vhd
-- Project Name:  fault-tolerant-techniques-rtl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TMR_voter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TMR_test IS

	GENERIC (
		WIDTH : natural := 8
	);

END TMR_test;
 
ARCHITECTURE behavior OF TMR_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TMR_voter
		GENERIC (
			WIDTH : natural
		);
		PORT(
         A : IN  std_logic_vector(WIDTH - 1 downto 0);
         B : IN  std_logic_vector(WIDTH - 1 downto 0);
         C : IN  std_logic_vector(WIDTH - 1 downto 0);
         OUTPUT : OUT  std_logic_vector(WIDTH - 1 downto 0);
			ERR_DETECT : out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
   signal B : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
   signal C : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');

 	--Outputs
   signal OUTPUT : std_logic_vector(WIDTH - 1 downto 0);
	signal ERR_DETECT : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TMR_voter 
			GENERIC MAP(
				WIDTH => WIDTH
			)
			PORT MAP (
          A => A,
          B => B,
          C => C,
          OUTPUT => OUTPUT,
			 ERR_DETECT => ERR_DETECT
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		
		A <= (others => '0');
		B <= (others => '0');
		C <= (others => '0');
		
		wait for 100ns;
		
		A <= (others => '0');
		B <= (others => '0');
		C <= (others => '1');
		
		wait for 100ns;
		
		A <= (others => '0');
		B <= (others => '1');
		C <= (others => '1');
		
		wait for 100ns;
		
		A <= (others => '0');
		B <= (others => '1');
		C <= (others => '0');
		
		wait for 100ns;
		
		A <= (others => '1');
		B <= (others => '0');
		C <= (others => '0');
		
		wait for 100ns;
		
		A <= (others => '1');
		B <= (others => '1');
		C <= (others => '0');
		
		wait for 100ns;
		
		A <= "01010101";
		B <= "01000000";
		C <= "01010101";
		
		wait for 100ns;
		
		A <= "01010101";
		B <= "01000000";
		C <= "01000000";
		
		wait for 100ns;
		
		A <= "01000000";
		B <= "00000000";
		C <= "01000000";
		
		wait for 100ns;

      wait;
   end process;

END;
