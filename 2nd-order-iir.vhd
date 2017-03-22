library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iir is
  port (
    i_clk       : in  std_logic;
    i_coeff_clk : in std_logic;
    i_rstb      : in  std_logic;
    coeff_ready : in  std_logic;
    done        : out std_logic;
    -- coefficient
    i_bcoeff    : in  std_logic_vector(14 downto 0);
    i_acoeff    : in  std_logic_vector(14 downto 0);

    -- data input
    i_data      : in  std_logic_vector(11 downto 0);
    -- filtered data
    o_data      : out std_logic_vector(31 downto 0));
end iir;

architecture Behavioral of iir is

  type t_data_pipe      is array (0 to 3) of signed(11  downto 0);
  type t_fdata_pipe     is array (0 to 3) of signed(11  downto 0);
  type t_bcoeff         is array (0 to 2) of signed(14  downto 0);
  type t_acoeff         is array (0 to 2) of signed(14  downto 0);

  type t_mult           is array (0 to 2) of signed(26    downto 0);
  type t_fmult          is array (0 to 2) of signed(26    downto 0);
  type t_add_st0        is array (0 to 1) of signed(26+1  downto 0);
  type t_fadd_st0       is array (0 to 1) of signed(26+1  downto 0);

  signal r_bcoeff       : t_bcoeff;
  signal r_acoeff       : t_acoeff;
  signal p_data         : t_data_pipe;
  signal p_fdata        : t_fdata_pipe;
  signal r_mult         : t_mult;
  signal r_fmult        : t_fmult;
  signal r_add_st0      : t_add_st0;
  signal r_fadd_st0     : t_fadd_st0;
  signal r_add_st1      : signed(26+2  downto 0);
  signal r_fadd_st1     : signed(26+2  downto 0);
  signal r_final_sum    : signed(26+5  downto 0);

  signal out_buf        : signed(11 downto 0);
  signal coeff_loop     : integer range 0 to 16 := 0; --only needs to go from 0 to 15

begin

--- Coefficent input ---
  p_coeff_input : process (i_rstb, i_coeff_clk)
  begin
    if(coeff_ready='1') then
      r_bcoeff               <= (others=>(others=>'0'));
      r_acoeff               <= (others=>(others=>'0'));
      coeff_loop             <= 0;
    elsif(rising_edge(i_coeff_clk)) then
      if(coeff_loop /= 3) then
        r_bcoeff(coeff_loop) <= signed(i_bcoeff);
        r_acoeff(coeff_loop) <= signed(i_acoeff);
        coeff_loop           <= coeff_loop + 1;
      elsif(coeff_loop = 3) then
      -- do nothing
      end if;
    end if;
  end process p_coeff_input;


--- Data input ---

  p_data_input : process (i_rstb,i_clk)
  begin
    if(i_rstb='1') then
      p_data                 <= (others=>(others=>'0'));
      p_fdata                <= (others=>(others=>'0'));
    elsif(rising_edge(i_clk)) then
      p_data                 <= signed(i_data)&p_data(0 to p_data'length-2);
      p_fdata                <= out_buf & p_fdata(0 to p_fdata'length-2);
    end if;
  end process p_data_input;

--- Feedforward & Feedback ---

  p_mult : process (i_rstb,i_clk,p_data,r_bcoeff,p_fdata,r_acoeff)
  begin
    if(i_rstb='1') then
      r_mult                 <= (others=>(others=>'0'));
      r_fmult                <= (others=>(others=>'0'));
    elsif(i_clk='1') then
      for k in 0 to 2 loop
        r_mult(k)            <= p_data(k)  * r_bcoeff(k);
        r_fmult(k)           <= p_fdata(k) * r_acoeff(k);
      end loop;
    end if;
  end process p_mult;

  p_add_st0 : process (i_rstb,i_clk,r_mult,r_fmult)
  begin
    if(i_rstb='1') then
      r_add_st0              <= (others=>(others=>'0'));
      r_fadd_st0             <= (others=>(others=>'0'));
    elsif(i_clk='1') then
      r_add_st0(0)           <= resize(r_mult(0),28)  + resize(r_mult(1),28);
      r_fadd_st0(0)          <= resize(r_fmult(0),28) + resize(r_fmult(1),28);
      r_add_st0(1)           <= resize(r_mult(2),28);
      r_fadd_st0(1)          <= resize(r_fmult(2),28);
    end if;
  end process p_add_st0;

  p_add_st1 : process (i_rstb,i_clk,r_add_st0,r_fadd_st0)
  begin
    if(i_rstb='1') then
      r_add_st1              <= (others=>'0');
      r_fadd_st1             <= (others=>'0');
    elsif(i_clk='1') then
      r_add_st1              <= resize(r_add_st0(0),29)  + resize(r_add_st0(1),29);
      r_fadd_st1             <= resize(r_fadd_st0(0),29) + resize(r_fadd_st0(1),29);
    end if;
  end process p_add_st1;

  p_final_sum : process (i_rstb,i_clk,r_add_st1,r_fadd_st1)
  begin
    if(i_rstb='1') then
      r_final_sum            <= (others=>'0');
    elsif(i_clk='1') then
      r_final_sum            <= resize(r_add_st1,32) - resize(r_fadd_st1,32);
    end if;
  end process p_final_sum;

  p_output : process (i_rstb,i_clk,r_final_sum,p_fdata,out_buf)
  begin
    done                     <= '0';
    if(i_rstb='1') then
      o_data                 <= (others=>'0');
      done                   <= '0';
    elsif(i_clk='1') then
      done                   <= '1';
      out_buf                <= r_final_sum(26 downto 15); --this may cause a problem later on
      o_data                 <= std_logic_vector(r_final_sum);
    end if;
  end process p_output;

end Behavioral;
