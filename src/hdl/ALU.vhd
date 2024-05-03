--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD         000
--|     SUBTRACT    001
--|     AND         010
--|     OR          011
--|     R SHIFT     100
--|     L SHIFT     101
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
-- TODO
        Port ( i_clk		: in  STD_LOGIC; -- is there a clock signal input?
               i_A		    : in  STD_LOGIC_VECTOR (7 downto 0);
               i_B          : in  STD_LOGIC_VECTOR (7 downto 0);
               i_op         : in STD_LOGIC_VECTOR (2 downto 0);
               o_result     : out STD_LOGIC_VECTOR (7 downto 0);
               o_flags      : out STD_LOGIC_VECTOR (2 downto 0) --  is this supposed to be a vector?
               );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
    component adder is 
        port (
        i_A     : in std_logic_vector (7 downto 0);
        i_B     : in std_logic_vector (7 downto 0);
        i_cIn   : in std_logic;
        o_add   : out std_logic_vector (7 downto 0);
        o_cOut  : out std_logic
        );
    end component;
    
    component gates is
        port (
        i_A         : in std_logic_vector (7 downto 0);
        i_B         : in std_logic_vector (7 downto 0);
        i_select    :  in std_logic;
        o_andOr     : out std_logic_vector (7 downto 0)
        );
    end component;

    -- adder signals
    signal w_s0 : std_logic_vector (2 downto 0) := "00";
    signal w_addResult  : std_logic_vector (8 downto 0) := "000000000";
    -- gate signals
    signal w_B, w_and, w_or, w_gatesResult  :   std_logic_vector (7 downto 0)  :=   "00000000";
    

begin
	-- PORT MAPS ----------------------------------------
    -- how do i port map a mux?
    adder_inst : adder
    port map(
        i_A     => i_A,
        i_B     => w_B,
        i_cIn   => i_op(0),
        o_cOut  => o_flags(2),
        o_add   => w_addResult
    );
    
    gates_inst   :   gates
    port map(
        i_A         => i_A,
        i_B         => i_B,
        i_select    => i_op(0),
        o_andOR     => w_gatesResult
    );
   
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	w_B <= i_B when i_op(0) = '0' else
	       not i_B;
	
    w_addResult <= std_logic_vector(unsigned('0'&i_A) + unsigned('0'&w_B)) when i_op = "000" else
                   std_logic_vector(unsigned('0'&i_A) - not unsigned('0'&w_B)) when i_op = "001";
                   
    w_gatesResult   <=  std_logic_vector(unsigned('0'&i_A) and unsigned('0'&w_B)) when i_op = "010" else
                        std_logic_vector(unsigned('0'&i_A) or not unsigned('0'&w_B)) when i_op = "011";

    --cOut logic     
    
    -- What's wrong with these lines?   
--    o_flags(0) <= '1' when (o_result = "00000000");  
    o_flags(1) <= w_addResult(8);    
--    o_flags(2) <= '1' when (o_result(7) = '1');
    
end behavioral;
