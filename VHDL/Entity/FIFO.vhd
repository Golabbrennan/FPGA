library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIFO is
generic
(
  g_data_bw : integer := 8;	--Bit width of data
  g_depth : integer := 8 --Sets size of fifo stack
);
port
(
  i_clk : in std_logic;
  i_rst : in std_logic;
  --Write
  i_data_in : in std_logic_vector(g_data_bw - 1 downto 0);
  i_write_en : in std_logic;
  o_full : out std_logic; 
  --Read
  i_read_en : in std_logic;
  o_empty : out std_logic;
  o_data_out : out std_logic_vector(g_data_bw - 1 downto 0)
);
end entity;

architecture rtl of FIFO is

    type t_fifo_data is array (0 to g_depth-1) of std_logic_vector(g_data_bw-1 downto 0);
    
    signal r_fifo_data : t_fifo_data := (others => (others => '0'));
    
    signal r_read_index, r_write_index : integer range 0 to g_depth-1 := 0;
    signal r_fifo_count : unsigned(0 to g_depth) := (others => '0');
    signal r_fifo_full, r_fifo_empty : std_logic := '0';
    
begin
	
  process (i_clk) is
  begin
    if rising_edge(i_clk) then
      if (i_rst = '1') then
        r_fifo_count <= (others => '0');
        r_read_index <= 0;
        r_write_index <= 0;
      else
        
        if (i_write_en = '1' and r_fifo_full = '0') then
          if (r_write_index = g_depth-1) then
            r_write_index <= 0;
          else
            r_write_index <= r_write_index + 1;
          end if;
          r_fifo_count <= r_fifo_count + 1;
        end if;
        
        if (i_read_en = '1' and r_fifo_empty = '0') then
          if (r_read_index = g_depth-1) then
            r_read_index <= 0;
          else
            r_read_index <= r_read_index+1;
          end if;
          r_fifo_count <= r_fifo_count - 1;
        end if;
        
        if (i_write_en = '1') then
          r_fifo_data(r_write_index) <= i_data_in;
        end if;
                
      end if;
    end if;
    o_data_out <= r_fifo_data(r_read_index);
  end process;  

  r_fifo_empty <= '1' when r_fifo_count = 0 else '0';
  o_empty <= r_fifo_empty;
  r_fifo_full <= '1' when r_fifo_count = g_depth else '0';
  o_full <= r_fifo_full;


end architecture;
