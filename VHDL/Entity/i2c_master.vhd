--Still needs clean up
library IEEE;
use IEEE.std_logic_1164.all;

entity i2c_master is
generic(
	g_clk_spd : integer;
    g_scl_clk_spd :integer;
);
port(
	i_clk : in std_logic;
    i_rst : in std_logic;
    i_slave_address : in std_logic_vector(6 downto 0); 
    i_read_write : in std_logic;	--0 write 1 read
    i_byte : in std_logic_vector(7 downto 0);
    i_start : in std_logic;
    io_sda : inout std_logic;	--Serial data line
    o_scl : out std_logic;	--Serial clock line
    o_done : out std_logic
);
end entity;

architecture rtl of i2c_master is

    type t_state_machine is (s_idle, s_start, s_start_hold, s_slave_address, s_slave_address_ack_hold, s_slave_address_ack, s_byte, s_byte_ack_hold, s_byte_ack, s_stop);
    signal r_state_machine : t_state_machine := s_idle;
    
    signal r_scl, r_scl_prev : std_logic := '1';
    signal r_done : std_logic := '0';
    signal r_bit_cnt : integer range 0 to 8 := 0;
    
    signal r_address_byte, r_address : std_logic_vector(7 downto 0);
    signal r_byte : std_logic_vector(7 downto 0) := (others => '0');
    
    constant clk_div : integer := (g_clk_spd/g_scl_clk_spd);
    signal r_clk_div_counter : integer range 0 to clk_div - 1 := 0;

begin
  
  
  p_clk_gen : process(i_clk)
  begin
      if rising_edge(i_clk) then
          if r_state_machine = s_idle or r_state_machine = s_start or r_state_machine = s_stop then
              r_scl <= '1';
          elsif r_state_machine = s_start_hold then
              r_scl <= '0';
              r_clk_div_counter <= 0;
          else
              r_scl_prev <= r_scl;
              if r_clk_div_counter = clk_div - 1 then
                  r_clk_div_counter <= 0;
                  r_scl <= not r_scl;
              else
                  r_clk_div_counter <= r_clk_div_counter + 1;
              end if;
          end if;
      end if;
  end process p_clk_gen;

  
   p_state_machine : process(i_clk)
    begin
    	if rising_edge(i_clk) then
            if i_rst = '1' then
                r_state_machine <= s_idle;
                io_sda <= '1';
                r_bit_cnt <= 0;
                r_done <= '0';
            else
        
            case r_state_machine is

            when s_idle =>
              io_sda <= '1';
              if i_start = '1' and rising_edge(i_clk) then
             	r_done <= '0';
              	r_state_machine <= s_start;
              end if;

            when s_start =>   
                r_address_byte <= i_slave_address & i_read_write;
                r_byte <= i_byte;
                r_bit_cnt <= 7;
                io_sda <= '0';
                r_state_machine <= s_start_hold;
              
              when s_start_hold => 	
                r_state_machine <= s_slave_address;

            when s_slave_address =>
              if r_scl_prev = '1' and r_scl = '0' then
                io_sda <= r_address_byte(r_bit_cnt);
                if r_bit_cnt = 0 then
                  r_state_machine <= s_slave_address_ack_hold;
                else
                  r_bit_cnt <= r_bit_cnt - 1;
                end if;
		 	  end if;
              
           when s_slave_address_ack_hold =>
           	if r_scl = '0' and r_scl_prev = '1' then --falling edge
            	io_sda <= 'Z';
            	r_state_machine <= s_slave_address_ack;
            end if;
            
           when s_slave_address_ack =>
        	  if r_scl = '1' and r_scl_prev = '0' then --rising edge
        		if io_sda = '0' then  -- Slave acknowledged
                  r_bit_cnt <= 7;
                  r_state_machine <= s_byte;
       			 else
         	     	r_state_machine <= s_idle;
                 	r_done <= '1';  -- Operation is done
        		 end if;
               end if;
           
           when s_byte =>
 			if r_scl_prev = '1' and r_scl = '0' then
                io_sda <= r_byte(r_bit_cnt);
                if r_bit_cnt = 0 then
                  r_state_machine <= s_byte_ack_hold;
                else
                  r_bit_cnt <= r_bit_cnt - 1;
                end if;
		 	  end if;
            
            when s_byte_ack_hold =>
           	if r_scl = '1' and r_scl_prev = '0' then --falling edge
            	io_sda <= 'Z';
            	r_state_machine <= s_byte_ack;
            end if;
            
            when s_byte_ack =>
            	if r_scl and not r_scl_prev then -- falling edge
                  if io_sda = '0' then  -- Slave acknowledged
                    r_state_machine <= s_stop;
                   else
                      r_state_machine <= s_idle;
                      r_done <= '1';  -- Operation is done
                      end if;
                  end if;

        when s_stop =>
              r_done <= '1';
              io_sda <= '1';
              r_state_machine <= s_idle;

        when others =>
          r_state_machine <= s_idle;
          
        end case;
        
  		end if; 	
     end if;	
      
  end process p_state_machine;
 
  o_scl <= r_scl;
  
end architecture rtl;
