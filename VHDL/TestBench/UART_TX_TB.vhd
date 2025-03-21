-- Written for testing using EDAPlayground

library IEEE;
use IEEE.std_logic_1164.all;


entity testbench is
end entity;


architecture tb of testbench is
 
  component UART_TX is
    generic (
      g_baud_rate : integer := 115200;
      g_clk_rate : integer := 10000000
      );
    port (
      i_clk       : in  std_logic;
      i_rst		  : in  std_logic;
      i_TX_valid     : in  std_logic;
      i_TX_byte   : in  std_logic_vector(7 downto 0);
      o_TX_active : out std_logic;
      o_TX_serial : out std_logic;
      o_TX_done   : out std_logic
      );
  end component UART_TX;
 
  
  constant c_CLKS_PER_BIT : integer := 87;
 
  constant c_BIT_PERIOD : time := 8680 ns;
   
  signal r_CLOCK     : std_logic := '0';
  signal r_rst 		 : std_logic := '0';
  signal r_TX_DV     : std_logic := '0';
  signal r_TX_BYTE   : std_logic_vector(7 downto 0) := (others => '0');
  signal w_TX_SERIAL : std_logic;
  signal w_TX_DONE   : std_logic;
  signal stop : std_logic := '0';
 
 begin
  
UART_TX_INST : UART_TX 
  generic map (
    g_baud_rate => 115200,
    g_clk_rate =>  10000000
      )
    port map (
      i_clk       => r_CLOCK,
      i_rst 	  => r_rst,
      i_TX_valid     => r_TX_DV,
      i_TX_byte   => r_TX_BYTE,
      o_TX_active => open,
      o_TX_serial => w_TX_SERIAL,
      o_TX_done   => w_TX_DONE
      );
 
  r_CLOCK <= not r_CLOCK after 50 ns when not stop;
   
  process is
  begin
 
    wait until rising_edge(r_CLOCK);
    wait until rising_edge(r_CLOCK);
    r_TX_DV   <= '1';
    r_TX_BYTE <= X"AB";
    wait until rising_edge(r_CLOCK);
    r_TX_DV   <= '0';
    wait until w_TX_DONE = '1';
    wait until rising_edge(r_CLOCK);
    r_TX_DV   <= '1';
    r_TX_BYTE <= X"11";
    wait until rising_edge(r_CLOCK);
    r_TX_DV   <= '0';
    wait until w_TX_DONE = '1';
    wait until rising_edge(r_CLOCK);
    
    stop <= '1';
    assert false report "Tests Complete" severity note;
    
  end process;
   
end architecture;
