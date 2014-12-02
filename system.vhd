----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:23:54 12/02/2014 
-- Design Name: 
-- Module Name:    system - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity system is

	generic (
		width : natural := 8
	);

	port (
		clk : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(width - 1 downto 0);
		manual_override_en : in std_logic := '0';
		fail_state_check_en : in std_logic := '0';
		watchdog_clear_skip_en : in std_logic := '0';
		TMR_fail_en : in std_logic := '0'
	);

end system;

architecture Behavioral of system is

	component TMR_voter
		generic (
			WIDTH : natural := 8
		);
		port (
			A : in std_logic_vector(WIDTH - 1 downto 0);
			B : in std_logic_vector(WIDTH - 1 downto 0);
			C : in std_logic_vector(WIDTH - 1 downto 0);
			OUTPUT : out std_logic_vector(WIDTH - 1 downto 0);
			ERR_DETECT : out std_logic
		);
	end component;
	
	component simple_watchdog
		generic (
			LIMIT : natural := 10
		);
		port(
			clk : in std_logic;
			watchdog_clear : in std_logic;
			reset : out std_logic
		);
	end component;

	type state_type is (init, read_sensors, preprocessing, IMU_computations, actuate, manual_override, illegal_state);

	signal state : state_type;
	signal internal_reset, watchdog_clear : std_logic;
	signal TMR_failed, state_check_failed, watchdog_failed : std_logic;
	signal TMR_input_original, TMR_input_eventually_failing : std_logic_vector(width - 1 downto 0);
	
	signal tmp_output : std_logic_vector(width - 1 downto 0); -- dummy signal, to trick the syntesizer into synthesizing
	

begin

	TMR_input_original <= "01100111";
	TMR_input_eventually_failing <= not(TMR_input_original) when TMR_fail_en = '1' else TMR_input_original;
	
	-- map component "state check" here and connect state_check_failed signal to the "failed" output flag
	state_check_failed <= '0';
	
	TMR: TMR_voter
		generic map (
			WIDTH => width
		) port map (
			A => TMR_input_original,
			B => TMR_input_original,
			C => TMR_input_eventually_failing,
			OUTPUT => tmp_output,
			ERR_DETECT => TMR_failed
		);
		
	WATCHDOG: simple_watchdog
		generic map (
			LIMIT => 10
		) port map (
			clk => clk,
			watchdog_clear => watchdog_clear,
			reset => watchdog_failed
		);

	internal_reset <= reset or TMR_failed or state_check_failed or watchdog_failed;

	process (clk, internal_reset)
	begin
		if internal_reset = '1' then
			state <= init;
		elsif (rising_edge(clk)) then
			case state is
			
			-- init state could include bootstrapping (that might fix some of the faults)
			-- in which case the system would stay in this state until flagged otherwise
			-- this applies for other states as well (read_sensors, preprocessing, etc.)
			-- however, we will not have more state variables than needed
			-- and therefore we'll consider immediate transition to next state (at next clock cycle)
			-- wherever there is no point in doing otherwise
			
				when init =>					
					if manual_override_en = '1' then
						state <= manual_override;
					elsif fail_state_check_en = '1' then	-- this is how we "fake" an illegal transition
						state <= illegal_state;
					else
						state <= read_sensors;	
					end if;
				when read_sensors =>
					if manual_override_en = '1' then
						state <= manual_override;
					elsif fail_state_check_en = '1' then
						state <= illegal_state;
					else
						state <= preprocessing;	
					end if;
				when preprocessing =>
					if manual_override_en = '1' then
						state <= manual_override;
					elsif fail_state_check_en = '1' then
						state <= illegal_state;
					else
						state <= IMU_computations;	
					end if;
				when IMU_computations =>
					if manual_override_en = '1' then
						state <= manual_override;
					elsif fail_state_check_en = '1' then
						state <= illegal_state;
					else
						state <= actuate;	
					end if;
				when actuate =>
					if manual_override_en = '1' then
						state <= manual_override;
					elsif fail_state_check_en = '1' then
						state <= illegal_state;
					else
						state <= read_sensors;	
					end if;
				when manual_override =>
					if manual_override_en = '1' then
						state <= manual_override;
					elsif fail_state_check_en = '1' then
						state <= illegal_state;
					else
						state <= read_sensors;	
					end if;
				when illegal_state =>
					state <= illegal_state;
			end case;
		end if;
	end process;


	process (state, watchdog_clear_skip_en, tmp_output)
	begin
	
		case state is
			when init =>
				watchdog_clear <= '0';
				output <= "0" & tmp_output(width - 2 downto 0);
			when read_sensors =>
				watchdog_clear <= '0';
				output <= "1" & tmp_output(width - 2 downto 0);
			when preprocessing =>
				watchdog_clear <= '0';
				output <= "00" & tmp_output(width - 3 downto 0);
			when IMU_computations =>
				if watchdog_clear_skip_en = '1' then	-- this is how we "fake" a computation timeout (failure to reset watchdog)
					watchdog_clear <= '0';
				else
					watchdog_clear <= '1';
				end if;
				output <= "01" & tmp_output(width - 3 downto 0);
			when actuate =>
				watchdog_clear <= '0';
				output <= "10" & tmp_output(width - 3 downto 0);
			when manual_override =>
				watchdog_clear <= '1';	-- while in manual override you don't want blinking red lights to signal computation timeout
				output <= "11" & tmp_output(width - 3 downto 0);
			when illegal_state =>
				watchdog_clear <= '0';
				output <= tmp_output;
		end case;
	end process;

end Behavioral;

