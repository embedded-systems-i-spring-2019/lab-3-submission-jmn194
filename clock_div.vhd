----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 05:07:53 PM
-- Design Name: 
-- Module Name: clock_div - clock_div
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_div is
  Port(
  clk : in std_logic;		--clk will act as the clock input signal
  div : out std_logic);		--div represents the divided output clock signal
end clock_div;

architecture clock_div of clock_div is
--count will represent an intermediate 11 bit signal allowing counting to 1085 = 125MHz / 115200Hz
  signal count : std_logic_vector (10 downto 0) := (others => '0');
begin

process(clk) begin
  if rising_edge(clk) then	--runs when the clock goes high

--checks the value of count to determine how to proceed
--if count is under 1085, keep incrementing count and keeping div low
--once count reaches 1085, set div high for a cycle and reset the count
    if (unsigned(count) < 1085) then
      count <= std_logic_vector( unsigned(count) + 1 );	--increment count
      div <= '0';	--set div to 0
    else
      div <= '1';	--set div to 1
      count <= (others => '0');	--reset count
    end if;
  end if;
end process;

end clock_div;
