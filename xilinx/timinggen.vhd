----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:51:10 08/02/2019 
-- Design Name: 
-- Module Name:    td8emu - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity td8emu is
    Port ( rtt : in  STD_LOGIC;
           wrtm : in  STD_LOGIC;
           dtp0 : inout  STD_LOGIC;
           dtp1 : inout  STD_LOGIC;
           clock : in  STD_LOGIC;
			  wtt : out STD_LOGIC;
			  rmt : in STD_LOGIC;
			  uc_mtd : out STD_LOGIC_VECTOR (5 downto 0);
			  data_available : out STD_LOGIC;
			  read_done : in STD_LOGIC;
			  rd : in STD_LOGIC_VECTOR (2 downto 0);
			  uc_rd : out STD_LOGIC_VECTOR (2 downto 0);
			  uc_wd : in STD_LOGIC_VECTOR (2 downto 0);
			  wd : out STD_LOGIC_VECTOR (2 downto 0);
			  write_done : in STD_LOGIC;
			  write_possible : out STD_LOGIC;
			  uc_write_enable : in STD_LOGIC;
			  write_enable : out STD_LOGIC);
end td8emu;

architecture Behavioral of td8emu is

	signal rtt0 : std_logic := '0';
	signal rtt1 : std_logic := '0';
	signal w_timing0 : std_logic := '0';
	signal w_timing1 : std_logic := '0';
	signal noise_filter : std_logic := '0';
	signal counter : std_logic_vector(8 downto 0) := (others => '0');
	signal s_wtt : std_logic := '0';
	signal wd_comp: std_logic := '0';
	signal wdreg: std_logic_vector(2 downto 0) := (others => '0');
	signal mtd: std_logic_vector(5 downto 0) := (others => '0');

begin

data_available_process: process(dtp1, read_done)
	begin
		if  read_done = '1' then			
			data_available <= '0';
		elsif rising_edge(dtp1) then
			data_available <= '1';
		end if;
	end process;

mark_track: process(dtp1) 
	begin
		if rising_edge(dtp1) then
			mtd(0) <= rmt;
			mtd(5 downto 1) <= mtd(4 downto 0);				
		end if;	
	end process;

uc_mtd <= mtd;	
	
read_data: process(dtp1) 
	begin
		if rising_edge(dtp1) then
			uc_rd <= rd;
		end if;
	end process;
	
write_complement: process(dtp0, dtp1)
	begin
		if dtp1 = '1' then
			wd_comp <= '0';
		elsif dtp0 = '1' then
			wd_comp <= '1';
		end if;
	end process;

write_data: process(dtp0) 
	begin 
		if rising_edge(dtp0) then 
			wdreg <= uc_wd;
		end if;
	end process;
	
wd(0) <= wdreg(0) XOR wd_comp;
wd(1) <= wdreg(1) XOR wd_comp;
wd(2) <= wdreg(2) XOR wd_comp;

write_possible_process: process(dtp0, write_done) 
	begin
		if write_done = '1' then			
				write_possible <= '0';
		elsif rising_edge(dtp0) then
			write_possible <= '1';
		end if;
	
	end process;


write_enable_process: process(dtp0)
	begin
		if rising_edge(dtp0) then
			write_enable <= uc_write_enable;
		end if;
	end process;

timinggen: process(clock)
	variable v_dtp0 : std_logic;
	variable v_dtp1 : std_logic;
	variable v_rtt : std_logic;
	variable v_comp_wd : std_logic;
	begin
		if rising_edge(clock) then
		   v_rtt := (rtt AND NOT wrtm) OR (NOT w_timing1 AND wrtm); 
			rtt0 <= v_rtt;
			rtt1 <= rtt0;
			v_dtp1 := rtt0 AND NOT rtt1 AND (wrtm OR NOT noise_filter);
			v_dtp0 := rtt1 AND NOT rtt0 AND (wrtm OR NOT noise_filter);
			counter <= counter + 1;
			if v_dtp0 = '1' OR v_dtp1 = '1' then
				noise_filter <= '1';
				if wrtm = '0' then
				counter <= "000000000";
				end if;
			end if;
			if counter = "111110100" then
				noise_filter <= '0';
			end if;
			if counter = "110011111" AND wrtm = '1' then
				counter <= "000000000";
				w_timing0 <= w_timing1;
				w_timing1 <= NOT w_timing0;
			end if;

		end if;
		
	end process;
	dtp0 <= rtt0 AND NOT rtt1 AND (wrtm OR NOT noise_filter);
	dtp1 <= rtt1 AND NOT rtt0 AND (wrtm OR NOT noise_filter);
	wtt <= NOT w_timing0;
end Behavioral;

