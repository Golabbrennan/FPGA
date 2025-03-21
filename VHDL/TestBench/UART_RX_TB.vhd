-- Written for testing using EDAPlayground

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity testbench is
end testbench;
 
architecture tb of testbench is
 
  component UART_RX is
    generic (
       	g_baud : integer := 115200;
        g_clk_spd : integer := 10000000;
      );
    port (
      i_clk       : in  std_logic;
      i_rst		  : in std_logic;
      i_rx_serial : in  std_logic;
      o_rx_valid     : out std_logic;
      o_rx_byte   : out std_logic_vector(7 downto 0)
      );
  end component;
 
   
  constant c_clks_per_bit : integer := 87;
 
  constant c_BIT_PERIOD : time := 8680 ns;
   
  signal r_CLOCK       : std_logic := '0';
  signal r_rst 		   : std_logic := '0';
  signal w_data_valid  : std_logic := '0';
  signal w_data_byte   : std_logic_vector(7 downto 0);
  signal r_data_serial : std_logic := '1';
  signal stop          : std_logic := '0';
 
   
  -- Low-level byte-write
  procedure UART_WRITE_BYTE (
    i_rx_in       : in  std_logic_vector(7 downto 0);
    signal o_serial : out std_logic) is
  begin
  
 	wait for C_BIT_PERIOD;
    -- Send Start Bit
    o_serial <= '0';
    wait for c_BIT_PERIOD;
 
    -- Send Data Byte
    for ii in 0 to 7 loop
      o_serial <= i_rx_in(ii);
      wait for c_BIT_PERIOD;
    end loop;  -- ii
 
    -- Send Stop Bit
    o_serial <= '1';
    wait for c_BIT_PERIOD;
    end UART_WRITE_BYTE;
 
begin
 
  -- Instantiate UART Receiver
  UART_RECEIVER : UART_RX
    generic map (
      g_baud => 115200,
      g_clk_spd => 10000000
      )
    port map (
      i_clk       => r_CLOCK,
      i_rst       => r_rst,
      i_rx_serial => r_data_serial,
      o_rx_valid  => w_data_valid,
      o_rx_byte   => w_data_byte
      );
 
  r_CLOCK <= not r_CLOCK after 50 ns when not stop;
   
  process is
  begin
 
    -- Send a command to the UART
    wait until rising_edge(r_CLOCK);
    	UART_WRITE_BYTE(X"89", r_data_serial);
    wait until rising_edge(r_CLOCK);
 
    -- Check that the correct command was received
    if w_data_byte = X"89" then
      report "Test Passed - Correct Byte Received" severity note;
    else
      report "Test Failed - Incorrect Byte Received" severity failure;
    end if;
    
    wait until rising_edge(r_CLOCK);
    UART_WRITE_BYTE(X"12", r_data_serial);
    wait until rising_edge(r_CLOCK);
 
    -- Check that the correct command was received
    if w_data_byte = X"12" then
      report "Test Passed - Correct Byte Received" severity note;
    else
      report "Test Failed - Incorrect Byte Received" severity failure;
    end if;
    
    wait until rising_edge(r_CLOCK);
    UART_WRITE_BYTE(X"3f", r_data_serial);
    wait until rising_edge(r_CLOCK);
 
    -- Check that the correct command was received
    if w_data_byte = X"3f" then
      report "Test Passed - Correct Byte Received" severity note;
    else
      report "Test Failed - Incorrect Byte Received" severity failure;
    end if;
    
 	stop <= '1';
    assert false report "Tests Complete" severity note;
     
  end process;
   
end architecture;
