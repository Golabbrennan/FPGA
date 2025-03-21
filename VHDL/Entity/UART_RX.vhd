library IEEE;
use IEEE.std_logic_1164.all;


entity UART_RX is
  generic(
    g_baud : integer := 9600; --Baud rate Bits/Second (9600, 19200, 115200, others)
    g_clk_spd : integer;
    );
  port(
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_rx_serial : in std_logic;
    o_rx_valid : out std_logic;
    o_rx_byte : out std_logic_vector(7 downto 0)
    );
end entity;


architecture rtl of UART_RX is

  constant c_clk_cycles_per_bit : integer := (g_clk_spd/g_baud);

  type t_state_machine is (s_idle, s_start, s_receive, s_stop, s_clean_up);
  signal r_state_machine : t_state_machine := s_idle;
  
  signal r_rx_valid, r_rx_sync, r_rx : std_logic := '0';
  signal r_rx_byte : std_logic_vector(7 downto 0) := (others => '0');
  signal r_clk_count : integer range 0 to c_clk_cycles_per_bit-1 := 0;
  signal r_bit_index : integer range 0 to 7 := 0;

begin

  p_sample : process(i_clk)
  begin
    if rising_edge(i_clk) then
      r_rx_sync <= i_rx_serial;
      r_rx <= r_rx_sync; 
    end if;
  end process;

  p_state : process(i_clk)
  begin
    if rising_edge(i_clk) then
      if i_rst = '1' then
        r_clk_count <= 0;
        r_bit_index <= 0;
        r_rx_byte <= (others => '0');
        r_rx_valid <= '0';
        r_state_machine <= s_idle;
      else
        
        case r_state_machine is

          when s_idle => 				
            if r_rx = '0' then
              r_clk_count <= 0;
              r_state_machine <= s_start;
            end if;

          when s_start =>					
            if r_clk_count = (c_clk_cycles_per_bit-1)/2 then
              if r_rx = '0' then
                r_clk_count <= 0;
                r_state_machine <= s_receive;
              else
                r_state_machine <= s_idle;
              end if;
            else
              r_clk_count <= r_clk_count + 1;
            end if;

          when s_receive => 			
            if r_clk_count = c_clk_cycles_per_bit-1 then     
              r_rx_byte(r_bit_index) <= r_rx;
              r_clk_count <= 0;

              if r_bit_index = 7 then
                r_bit_index <= 0;
                r_state_machine <= s_stop;
              else
                r_bit_index <= r_bit_index + 1;
              end if;
              
            else
              r_clk_count <= r_clk_count + 1;
            end if;

          when s_stop => 			

            if r_clk_count = c_clk_cycles_per_bit-1 then     
              r_clk_count <= 0;
              r_rx_valid <= '1';
              r_state_machine <= s_clean_up;
            else
              r_clk_count <= r_clk_count + 1;
            end if;

          when s_clean_up => 			
            r_clk_count <= 0;
            r_rx_valid <= '0';
            r_state_machine <= s_idle;

          when others => 					
            r_state_machine <= s_idle;
            
        end case;
      end if;
    end if;
  end process;

  o_rx_valid <= r_rx_valid;
  o_rx_byte <= r_rx_byte;

end architecture;
