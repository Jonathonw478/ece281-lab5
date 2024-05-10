-- Generated by ChatGPT, 14 April 2023
-- Modified by Capt Brian Yarbrough

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity twoscomp_decimal_tb is
end twoscomp_decimal_tb;

architecture Behavioral of twoscomp_decimal_tb is

    component twoscomp_decimal is
        port (
            i_bin: in std_logic_vector(7 downto 0);
            o_sign: out std_logic_vector(3 downto 0);
            o_hund: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;

    signal w_bin: std_logic_vector(7 downto 0) := (others => '0');
    signal w_sign: std_logic_vector(3 downto 0);
    signal w_hund: std_logic_vector(3 downto 0);
    signal w_tens: std_logic_vector(3 downto 0);
    signal w_ones: std_logic_vector(3 downto 0);
    
begin

    uut: entity work.twoscomp_decimal
        port map (
            i_bin => w_bin,
            o_sign => w_sign,
            o_hund => w_hund,
            o_tens => w_tens,
            o_ones => w_ones
        );
        
    process
    begin
        w_bin <= "00000000";
        wait for 10 ns;
        assert w_sign = '0' and w_hund = "0000" and w_tens = "0000" and w_ones = "0000" report "Bad convert 0" severity error;
        
        w_bin <= "11110000";
        wait for 10 ns;
        assert w_sign = '1' and w_hund = "0000" and w_tens = "0001" and w_ones = "0110" report "Bad convert -16" severity error;
        
        w_bin <= "00111010";
        wait for 10 ns;
        assert w_sign = '0' and w_hund = "0000" and w_tens = "0101" and w_ones = "1000" report "Bad convert 58" severity error;
        
        w_bin <= "01101111";
        wait for 10 ns;
        assert w_sign = '0' and w_hund = "0001" and w_tens = "0001" and w_ones = "0001" report "Bad convert 111" severity error;
        
        w_bin <= "10001000";
        wait for 10 ns;
        assert w_sign = '1' and w_hund = "0001" and w_tens = "0010" and w_ones = "0000" report "Bad convert -120" severity error;

        wait;
    end process;
    
end Behavioral;
