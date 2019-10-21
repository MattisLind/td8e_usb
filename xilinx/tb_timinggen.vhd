--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:45:50 08/03/2019
-- Design Name:   
-- Module Name:   C:/Users/mattis/td8emu/tb_timinggen.vhd
-- Project Name:  td8emu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: td8emu
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
 
ENTITY tb_timinggen IS
END tb_timinggen;
 
ARCHITECTURE behavior OF tb_timinggen IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT td8emu
    PORT(
         rtt : IN  std_logic;
         wrtm : IN  std_logic;
         dtp0 : INOUT  std_logic;
         dtp1 : INOUT  std_logic;
         clock : IN  std_logic;
         wtt : OUT  std_logic;
         rmt : IN  std_logic;
         uc_mtd : OUT  std_logic_vector(5 downto 0);
         data_available : OUT  std_logic;
         read_done : IN  std_logic;
         rd : IN  std_logic_vector(2 downto 0);
         uc_rd : OUT  std_logic_vector(2 downto 0);
         uc_wd : IN  std_logic_vector(2 downto 0);
         wd : OUT  std_logic_vector(2 downto 0);
         write_done : IN  std_logic;
         write_possible : OUT  std_logic;
         uc_write_enable : IN  std_logic;
         write_enable : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rtt : std_logic := '0';
   signal wrtm : std_logic := '0';
   signal clock : std_logic := '0';
   signal rmt : std_logic := '0';
   signal read_done : std_logic := '0';
   signal rd : std_logic_vector(2 downto 0) := (others => '0');
   signal uc_wd : std_logic_vector(2 downto 0) := (others => '0');
   signal write_done : std_logic := '0';
   signal uc_write_enable : std_logic := '0';

	--BiDirs
   signal dtp0 : std_logic;
   signal dtp1 : std_logic;

 	--Outputs
   signal wtt : std_logic;
   signal uc_mtd : std_logic_vector(5 downto 0);
   signal data_available : std_logic;
   signal uc_rd : std_logic_vector(2 downto 0);
   signal wd : std_logic_vector(2 downto 0);
   signal write_possible : std_logic;
   signal write_enable : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: td8emu PORT MAP (
          rtt => rtt,
          wrtm => wrtm,
          dtp0 => dtp0,
          dtp1 => dtp1,
          clock => clock,
          wtt => wtt,
          rmt => rmt,
          uc_mtd => uc_mtd,
          data_available => data_available,
          read_done => read_done,
          rd => rd,
          uc_rd => uc_rd,
          uc_wd => uc_wd,
          wd => wd,
          write_done => write_done,
          write_possible => write_possible,
          uc_write_enable => uc_write_enable,
          write_enable => write_enable
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	
      -- hold reset state for 100 ns.
      wait for 100 ns;	


      wait for clock_period*10;

      -- insert stimulus here 
		-- read 
		-- 1 is a low to high trnasition 0 is a high to low transition (mark track)
		-- 0 is a low to high trnasition 1 is a high to low transition (data tracks)
		-- 
		wrtm <= '0';
		wait for 16 ns;
		rtt <= '1';
		wait for 8300 ns;
		rmt <= '1';
		rd <= "111";
		wait for 8300 ns;
		-- This create the DTP1 pulse
		rtt <= '0';
		wait for 1000 ns;
		read_done <= '1';
		wait for 1000 ns;
		read_done <= '0';
		wait for 1000 ns;
		-- false timing pulse
		rtt <= '1';
		wait for 1000 ns;
		rtt <= '0';
		wait for 4300 ns;
		rmt <= '0';
		rd <= "000";
		wait for 8300 ns;
		-- This create the DTP0 pulse
		rtt <= '1';
		wait for 8300 ns;
		rmt <= '1';
		rd <= "111";
		wait for 8300 ns;
		-- This is a DTP1 pulse
		rtt <= '0';
		wait for 1000 ns;
		read_done <= '1';
		wait for 1000 ns;
		read_done <= '0';
		-- We have read the mark track and decided that now it is time to write.
		uc_write_enable <= '1';
		uc_wd <= "101";
		write_done <= '1';
		wait for 1000 ns;
		write_done <= '0';
		wait for 5300 ns;
		rmt <= '0';
		rd <= "000";
		wait for 8300 ns;
		-- dtp0 now we should start writing and also ask for mor data.
		rtt <= '1';
		wait for 1000 ns;
		uc_wd <= "010";
		write_done <= '1';
		wait for 1000 ns;
		write_done <= '0';
		wait for 14600 ns;
		-- dtp1
		rtt <= '0';
		wait for 16600 ns;
		-- dtp0 - turn of writing prior to this
		rtt <= '1';
		wait for 16600 ns;
		rtt <= '0';
		wait for 1000 ns;
		uc_write_enable <= '0';
		wait for 16600 ns;
		rtt <= '1';
		wait for 16600 ns;
		rtt <= '0';
		wait for 1000 ns;
		wrtm <= '1';
		write_done <= '1';
		wait for 1000 ns;
		write_done <= '0';
      wait;
   end process;

END;
