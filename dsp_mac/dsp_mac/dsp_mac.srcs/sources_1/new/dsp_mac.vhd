
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dsp_mac is
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        valid_in  : in  std_logic;

        a         : in  signed(15 downto 0);
        b         : in  signed(15 downto 0);

        acc_out   : out signed(47 downto 0);
        valid_out : out std_logic
    );
end dsp_mac;

architecture RTL of dsp_mac is

    signal acc_reg : signed(47 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                acc_reg   <= (others => '0');
                valid_out <= '0';

            else
                valid_out <= valid_in;

                if valid_in = '1' then
                    acc_reg <= acc_reg + resize(a * b, 48);
                end if;

            end if;

        end if;
    end process;

    acc_out <= acc_reg;

end RTL;
