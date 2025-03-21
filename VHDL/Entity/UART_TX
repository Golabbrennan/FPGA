library IEEE;
use IEEE.std_logic_1164.all;

entity UART_TX is
  generic(
    g_baud_rate : integer := 115200;
    g_clk_rate : integer := 10000000;
    );
  port(
    i_clk : in std_logic := '0';
    i_rst : in std_logic := '0';
    i_TX_valid : in std_logic := '0';
    i_TX_byte : in std_logic_vector(7 downto 0);
    o_TX_active : out std_logic := '0';
    o_TX_serial : out std_logic := '1';
    o_TX_done : out std_logic := '0';
    );
end entity;

architecture rtl of UART_TX is

  constant c_clks_per_bit : integer := (g_clk_rate/g_baud_rate);

  type t_state_machine is (s_idle, s_start, s_transmit, s_stop);
  signal r_state : t_state_machine := s_idle;
  
  signal r_TX_done, r_TX_serial, r_TX_active : std_logic := '0';
  signal r_clk_count : integer range 0 to c_clks_per_bit - 1 := 0;
  signal r_bit_index : integer range 0 to 7 := 0;
  signal r_TX_data : std_logic_vector(7 downto 0) := (others => '0');

begin

  P_state : process(i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        r_clk_count <= 0;
        r_bit_index <= 0;
        r_TX_done <= '0';
        r_TX_active <= '0';
        r_TX_serial <= '0';	
        r_state <= s_idle;
      else
        case r_state is
          
          when s_idle =>
            r_TX_active <= '0';
            r_TX_done <= '0';
            r_TX_serial <= '1';	
            
            if i_TX_valid = '1' then
              r_TX_data <= i_TX_byte;
              r_clk_count <= 0;
              r_bit_index <= 0;
              r_state <= s_start;
            end if;
            
          when s_start =>
            r_TX_serial <= '0';
            r_TX_active <= '1';
            if r_clk_count = c_clks_per_bit-1 then
              r_clk_count <= 0;
              r_state <= s_transmit;
            else
              r_clk_count <= r_clk_count + 1;
            end if;

          when s_transmit =>
            if r_clk_count = c_clks_per_bit-1 then
              r_clk_count <= 0;  
              if r_bit_index = 7 then
                r_state <= s_stop;
              else
                r_bit_index <= r_bit_index + 1;
              end if;
            else
              r_clk_count <= r_clk_count + 1;
            end if;
            
            r_TX_serial <= r_TX_data(r_bit_index);

          when s_stop =>
            r_TX_serial <= '1';
            if r_clk_count = c_clks_per_bit-1 then
              r_TX_done <= '1';
              r_state <= s_idle;
            else
              r_clk_count <= r_clk_count + 1;
            end if;
            
          when others =>
            r_state <= s_idle;
        end case;
        
      end if;
    end if;
    
  end process;
  
  o_TX_done <= r_TX_done;
  o_TX_active <= r_TX_active;
  o_TX_serial <= r_TX_serial;
  
end architecture;
