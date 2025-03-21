-- Written for testing using EDAPlayground

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity testbench is
end testbench;
 
architecture behave of testbench is
 
  constant c_DEPTH : integer := 6;
  constant c_WIDTH : integer := 8;
   
  signal r_RESET   : std_logic := '0';
  signal r_CLOCK   : std_logic := '0';
  signal r_WR_EN   : std_logic := '0';
  signal r_WR_DATA : std_logic_vector(c_WIDTH-1 downto 0) := X"A5";
  signal w_FULL    : std_logic;
  signal r_RD_EN   : std_logic := '0';
  signal w_RD_DATA : std_logic_vector(c_WIDTH-1 downto 0);
  signal w_EMPTY   : std_logic;
  signal stop : std_logic := '0';
   
  component fifo is
    generic (
      g_data_bw : natural := 8;
      g_depth : integer := 32
      );
    port (
      i_clk      : in std_logic;
      i_rst : in std_logic;
 
      -- FIFO Write Interface
      i_write_en   : in  std_logic;
      i_data_in : in  std_logic_vector(g_data_bw-1 downto 0);
      o_full    : out std_logic;
 
      -- FIFO Read Interface
      i_read_en   : in  std_logic;
      o_data_out : out std_logic_vector(g_data_bw-1 downto 0);
      o_empty   : out std_logic
      );
  end component fifo;
 
   
begin
 
 	fifo_test : fifo
    generic map (
      g_data_bw => c_WIDTH,
      g_depth => c_DEPTH
      )
    port map (
      i_rst => r_RESET,
      i_clk      => r_CLOCK,
      i_write_en    => r_WR_EN,
      i_data_in  => r_WR_DATA,
      o_full     => w_FULL,
      i_read_en    => r_RD_EN,
      o_data_out  => w_RD_DATA,
      o_empty    => w_EMPTY
      );
 
 
  r_CLOCK <= not r_CLOCK after 5 ns when not stop;
 
  p_TEST : process is
  begin
    wait until r_CLOCK = '1';
    r_WR_EN <= '1';
    wait until r_CLOCK = '1';
    r_WR_DATA <= X"B6";
    wait until r_CLOCK = '1';
    r_WR_DATA <= X"C7";
    wait until r_CLOCK = '1';
    r_WR_DATA <= X"D8";
    wait until r_CLOCK = '1';
    r_WR_EN <= '0';
    r_RD_EN <= '1';
    wait until r_CLOCK = '1';
    r_RD_EN <= '0';
    r_WR_EN <= '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_RD_EN <= '1';
    wait until r_CLOCK = '1';
    r_WR_EN <= '0';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    
    stop <= '1';
 
  end process;
