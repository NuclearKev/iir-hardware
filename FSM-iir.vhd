library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iir is
  port (
    i_clk       : in  std_logic;
    i_rstb      : in  std_logic;
    sample_trig : in  std_logic;
    done        : out std_logic;
    -- coefficient
    --i_bcoeff_0    : in  std_logic_vector(14 downto 0);
    --i_bcoeff_1    : in  std_logic_vector(14 downto 0);
    --i_bcoeff_2    : in  std_logic_vector(14 downto 0);
    --i_acoeff_1    : in  std_logic_vector(14 downto 0);
    --i_acoeff_2    : in  std_logic_vector(14 downto 0);

    -- data input
    i_data      : in  std_logic_vector(15 downto 0);
    -- filtered data
    o_data      : out std_logic_vector(15 downto 0));
end iir;

architecture Behavioral of iir is

  type t_data_pipe      is array (0 to 2) of signed(15  downto 0);
  type t_fdata_pipe     is array (0 to 1) of signed(15  downto 0);
  type t_bcoeff         is array (0 to 2) of signed(15  downto 0);
  type t_acoeff         is array (0 to 1) of signed(15  downto 0);

  type t_mult           is array (0 to 2) of signed(31    downto 0);
  type t_fmult          is array (0 to 1) of signed(31    downto 0);

  signal r_bcoeff    : t_bcoeff;
  signal r_acoeff    : t_acoeff;
  signal p_data      : t_data_pipe;
  signal p_fdata     : t_fdata_pipe;
  signal r_mult      : t_mult;
  signal r_fmult     : t_fmult;
  signal r_odata     : signed(15    downto 0);
  signal r_add       : signed(31+1  downto 0);
  signal r_fadd      : signed(31+1  downto 0);
  signal r_final_sum : signed(31+2  downto 0);

  	-- state machine signals
	type state_type is (idle_state, data_state, mult_state, add_state, final_state, data_out_state);
	signal state_reg, state_next : state_type;
  signal data, data_done, mult, mult_done, add, add_done, final, final_done, data_out, data_out_done : std_logic;

begin

  p_state_change : process (i_rstb,i_clk)
  begin
    if(i_rstb='1') then
      state_reg <= idle_state;
    elsif (rising_edge(i_clk)) then
      state_reg <= state_next;
    end if;
  end process p_state_change;

	process(state_reg, sample_trig,data_done,mult_done,add_done,final_done,data_out_done)
	begin
		-- defaults
    data <= '0';
    mult <= '0';
    add <= '0';
    data_out <= '0';

		case state_reg is
      when idle_state =>
        data_out <= '0';
        if(sample_trig = '1') then
          state_next <= data_state;
        else
          state_next <= idle_state;
        end if;
      when data_state =>
        data <= '1';
        if(data_done='1') then
          state_next <= mult_state;
          data <= '0';
        else
          state_next <= data_state;
        end if;
      when mult_state=>
        mult <= '1';
        if(mult_done='1') then
          state_next <= add_state;
          mult <= '0';
        else
          state_next <= mult_state;
        end if;
      when add_state =>
        add <= '1';
        if(add_done='1') then
          state_next <= final_state;
          add <= '0';
        else
          state_next <= add_state;
        end if;
      when final_state =>
        final <= '1';
        if(final_done='1') then
          state_next <= data_out_state;
          final <= '0';
         else
          state_next <= final_state;
        end if;
      when data_out_state =>
        data_out <= '1';
        if(data_out_done='1') then
          state_next <= idle_state;
          data_out <= '0';
        else
          state_next <= data_out_state;
        end if;
		end case;
	end process;

--- Data input ---
  p_data_input : process (i_rstb,i_clk,data)
  begin
    if(i_rstb='1') then
      p_data        <= (others=>(others=>'0'));
      p_fdata       <= (others=>(others=>'0'));
      data_done    <= '0';
    elsif(rising_edge(i_clk)) then
      if(data = '1') then
        p_data      <= signed(i_data)&p_data(0 to p_data'length-2); --this might need to change to a minus 8
        p_fdata(1)  <= p_fdata(0);
        p_fdata(0)  <= r_odata;
        r_bcoeff(0) <= x"2F61";
        r_bcoeff(1) <= x"A13C";
        r_bcoeff(2) <= x"2F61";
        r_acoeff(0) <= x"E86B";
        r_acoeff(1) <= x"0000";
        data_done  <= '1';
      else
        data_done  <= '0';
      end if;
    end if;
  end process p_data_input;

--- Feedforward & Feedback ---
  p_mult : process (i_rstb,i_clk,mult)
  begin
    if(i_rstb='1') then
      r_mult       <= (others=>(others=>'0'));
      r_fmult      <= (others=>(others=>'0'));
      mult_done    <= '0';
    elsif(rising_edge(i_clk)) then
      if(mult='1') then
        r_mult(0)  <= p_data(0)  * r_bcoeff(0);
        r_mult(1)  <= p_data(1)  * r_bcoeff(1);
        r_mult(2)  <= p_data(2)  * r_bcoeff(2);
        r_fmult(0) <= p_fdata(0) * r_acoeff(0);
        r_fmult(1) <= p_fdata(1) * r_acoeff(1);
        mult_done  <= '1';
      else
        mult_done  <= '0';
      end if;
    end if;
  end process p_mult;

  p_add : process (i_rstb,i_clk,add)
  begin
    if(i_rstb='1') then
      r_add         <=(others=>'0');
      r_fadd        <=(others=>'0');
      add_done      <= '0';
    elsif(rising_edge(i_clk)) then
      if(add = '1') then
        r_add       <= resize(r_mult(0),33)  + resize(r_mult(1),33) + resize(r_mult(2),33);
        r_fadd      <= resize(r_fmult(0),33) + resize(r_fmult(1),33);
        add_done    <= '1';
      else
        add_done    <= '0';
      end if;
    end if;
  end process p_add;

  p_final_sum : process (i_rstb,i_clk,final)
  begin
    if(i_rstb='1') then
      r_final_sum <= (others=>'0');
      final_done  <= '0';
    elsif(rising_edge(i_clk)) then
      if(final='1') then
        r_final_sum <= resize(r_add, 34) - resize(r_fadd,34);
        final_done <= '1';
      else
        final_done <= '0';
      end if;
    end if;
  end process p_final_sum;

--- Output ---
  p_output : process (i_rstb,i_clk,data_out)
  begin
    if(i_rstb='1') then
      o_data        <= (others=>'0');
      done          <= '0';
      data_out_done <= '0';
    elsif(rising_edge(i_clk)) then
      if(data_out = '1') then
        done        <= '1';
        r_odata     <= r_final_sum(33 downto 18);
        o_data      <= std_logic_vector(r_final_sum(33 downto 18));
        data_out_done <= '1';
      else
        done <= '0';
        data_out_done <= '0';
      end if;
    end if;
  end process p_output;

end Behavioral;
