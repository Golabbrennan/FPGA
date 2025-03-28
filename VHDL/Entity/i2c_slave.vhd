--Still needs cleanup
library IEEE;
use IEEE.std_logic_1164.all;

entity i2c_slave is
generic(
	g_slave_addr : std_logic_vector(6 downto 0) := "1010101";
);
port (
    i_clk         : in std_logic;
    i_rst         : in std_logic;  
    i_scl         : in std_logic;  -- Serial clock from master
    io_sda        : inout std_logic  -- Serial data (bidirectional)
);
end entity;

architecture rtl of i2c_slave is
    type t_state_machine is (s_idle, s_address, s_ack_hold, s_ack, s_byte, s_byte_ack_hold, s_byte_ack, s_stop);
    signal r_state_machine : t_state_machine := s_idle;

    signal r_scl, r_scl_prev : std_logic := '1';
    signal r_bit_cnt : integer range 0 to 8 := 0;
    signal r_received_address, r_received_byte : std_logic_vector(7 downto 0) := "00000000";
    signal r_falling_edge, r_rising_edge : std_logic;
	signal correct_address : std_logic;
begin

	p_detect_edge : process(i_clk) is
    begin
    	r_scl_prev <= r_scl;
        r_scl <= i_scl;
    end process;
	
    r_falling_edge <= '1' when (r_scl_prev = '1' and r_scl = '0') else '0';
	r_rising_edge <= '1' when (r_scl_prev = '0' and r_scl = '1') else '0';


  -- FSM driven by falling edge of SCL
  process(i_clk)
  begin
      if i_rst = '1' then
        r_state_machine <= s_idle;
        r_bit_cnt <= 0;
      else
        case r_state_machine is
        
          when s_idle =>
          	if io_sda = '0' and i_scl = '1' then --FIX STARTING POINT SO SLAVE DOESNT RESPOND TO RECEIVE IF NOT FOR THEM
              r_bit_cnt <= 7;
              r_state_machine <= s_address;
            end if;

          when s_address =>
         	r_received_address(r_bit_cnt) <= io_sda;
          	if r_rising_edge then
              if r_bit_cnt = 0 then
                r_state_machine <= s_ack_hold;
              else
                r_bit_cnt <= r_bit_cnt - 1;
              end if;
            end if;

           when s_ack_hold =>
            if r_falling_edge then
                r_state_machine <= s_ack;
            end if;
                
           when s_ack =>
              if (r_rising_edge and not io_sda) then
                	r_state_machine <= s_byte;
                    r_bit_cnt <= 7;
              elsif r_rising_edge then
                	r_state_machine <= s_idle;
              end if;
          
            
          when s_byte =>
          	r_received_byte(r_bit_cnt) <= io_sda;
           	if r_rising_edge then
              if r_bit_cnt = 0 then
                r_state_machine <= s_byte_ack_hold;
              else
                r_bit_cnt <= r_bit_cnt - 1;
              end if;
            end if;

          when s_byte_ack_hold =>
            if r_falling_edge then
                r_state_machine <= s_byte_ack;
            end if;
                
           when s_byte_ack =>
              if (r_rising_edge and not io_sda) then
                	r_state_machine <= s_stop;
              elsif r_rising_edge then
                	r_state_machine <= s_idle;
              end if;

          when s_stop =>
            r_state_machine <= s_idle;

          when others =>
            r_state_machine <= s_idle;
        end case;
     end if;
    end process; 
    
    correct_address <= '0' when (r_received_address(7 downto 1) = g_slave_addr) else 'Z';
    io_sda <= correct_address when r_state_machine = s_ack or 			r_state_machine = s_byte_ack else 'Z';
    
end architecture rtl;
