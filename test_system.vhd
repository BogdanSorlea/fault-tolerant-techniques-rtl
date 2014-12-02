--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:43:46 12/03/2014
-- Design Name:   
-- Module Name:   D:/work/vhdl/fault-tolerant-techniques-rtl/test_system.vhd
-- Project Name:  fault-tolerant-techniques-rtl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: system
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
 
ENTITY test_system IS
END test_system;
 
ARCHITECTURE behavior OF test_system IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT system
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         output : OUT  std_logic_vector(7 downto 0);
         manual_override_en : IN  std_logic;
         fail_state_check_en : IN  std_logic;
         watchdog_clear_skip_en : IN  std_logic;
         TMR_fail_en : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal manual_override_en : std_logic := '0';
   signal fail_state_check_en : std_logic := '0';
   signal watchdog_clear_skip_en : std_logic := '0';
   signal TMR_fail_en : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: system PORT MAP (
          clk => clk,
          reset => reset,
          output => output,
          manual_override_en => manual_override_en,
          fail_state_check_en => fail_state_check_en,
          watchdog_clear_skip_en => watchdog_clear_skip_en,
          TMR_fail_en => TMR_fail_en
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
      wait for 10 ns;	

      wait for clk_period*5;
		
		watchdog_clear_skip_en <= '1';
		
		wait for clk_period * 10;
		
		watchdog_clear_skip_en <= '0';
		
		wait for clk_period*5;
		
		TMR_fail_en <= '1';
		
		wait for clk_period;
		
		TMR_fail_en <= '0';
		
		wait for clk_period*5;

      -- insert stimulus here 

      wait;
   end process;

END;
