--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:07:42 12/02/2014
-- Design Name:   
-- Module Name:   D:/work/vhdl/fault-tolerant-techniques-rtl/simple_watchdog_test.vhd
-- Project Name:  fault-tolerant-techniques-rtl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: simple_watchdog
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
 
ENTITY simple_watchdog_test IS
END simple_watchdog_test;
 
ARCHITECTURE behavior OF simple_watchdog_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT simple_watchdog
    PORT(
         clk : IN  std_logic;
         watchdog_clear : IN  std_logic;
         reset : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal watchdog_clear : std_logic := '0';

 	--Outputs
   signal reset : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: simple_watchdog PORT MAP (
          clk => clk,
          watchdog_clear => watchdog_clear,
          reset => reset
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		watchdog_clear <= '1';
      wait for 100 ns;	
		
		watchdog_clear <= '0';
      wait for clk_period*5;
		
		watchdog_clear <= '1';
		wait for clk_period;
		
		watchdog_clear <= '0';
		wait for clk_period*10;
		
		watchdog_clear <= '1';
		wait for clk_period;
		
		watchdog_clear <= '0';
		wait for clk_period*15;
		
		

      -- insert stimulus here 

      wait;
   end process;

END;
