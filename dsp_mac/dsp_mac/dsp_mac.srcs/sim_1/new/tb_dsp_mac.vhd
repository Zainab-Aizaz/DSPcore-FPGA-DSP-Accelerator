
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_dsp_mac is
end tb_dsp_mac;

architecture SIM of tb_dsp_mac is

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal valid_in  : std_logic := '0';

    signal a         : signed(15 downto 0);
    signal b         : signed(15 downto 0);

    signal acc_out   : signed(47 downto 0);
    signal valid_out : std_logic;

begin

    clk <= not clk after 5 ns;

    DUT: entity work.dsp_mac
        port map (
            clk       => clk,
            rst       => rst,
            valid_in  => valid_in,
            a         => a,
            b         => b,
            acc_out   => acc_out,
            valid_out => valid_out
        );

    stimulus: process
    begin

        -- Reset
        rst <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        assert acc_out = to_signed(0, 48)
            report "RESET FAILED"
            severity error;

        -- First multiplication: 2 * 3 = 6
        rst <= '0';
        valid_in <= '1';
        a <= to_signed(2, 16);
        b <= to_signed(3, 16);

        wait until rising_edge(clk);
        wait for 1 ns;

        assert acc_out = to_signed(6, 48)
            report "TEST 1 FAILED"
            severity error;

        -- Second multiplication: 4 * 5 = 20
        -- Accumulator: 6 + 20 = 26
        a <= to_signed(4, 16);
        b <= to_signed(5, 16);

        wait until rising_edge(clk);
        wait for 1 ns;

        assert acc_out = to_signed(26, 48)
            report "TEST 2 FAILED"
            severity error;

        -- Negative multiplication: -3 * 2 = -6
        -- Accumulator: 26 - 6 = 20
        a <= to_signed(-3, 16);
        b <= to_signed(2, 16);

        wait until rising_edge(clk);
        wait for 1 ns;

        assert acc_out = to_signed(20, 48)
            report "TEST 3 FAILED"
            severity error;

        -- Invalid input: accumulator must hold
        valid_in <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert acc_out = to_signed(20, 48)
            report "ENABLE TEST FAILED"
            severity error;

        assert valid_out = '0'
            report "VALID SIGNAL TEST FAILED"
            severity error;

        report "ALL DSP MAC TESTS PASSED"
            severity note;

        wait;

    end process;

end SIM;
