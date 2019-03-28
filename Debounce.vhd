----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 05:55:35 PM
-- Design Name: 
-- Module Name: Debounce - debounce
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

entity Debounce is
Port (btn, clk : in std_logic;	--btn is the button input, clk is the clock signal
      dbnc : out std_logic);	--dbnc is the output signal after debouncing the input
end Debounce;

architecture debounce of Debounce is
--count represents an intermediate signal allowing counting to 2.5 million
  signal count : std_logic_vector (21 downto 0) := (others => '0');
--shift_reg acts as a check for whether or not a button is still held
--each bit is used to verify values, then shifted to the next position
  signal shift_reg : std_logic_vector(1 downto 0) := (others => '0');
begin

process(clk) begin
  if rising_edge(clk) then
--this moves the rightmost bit of shift_reg to the leftmost bit
    shift_reg(1) <= shift_reg(0);
--loads the current value of btn to the rightmost bit of shift_reg
    shift_reg(0) <= btn;
--counting to 20ms using the 125MHz clock
    if (unsigned(count) < 2499999) then
      dbnc <= '0';
--checks the leftmost bit of shift_reg to see if the prior value of the button was high
      if shift_reg(1) = '1' then
        count <= std_logic_vector( unsigned(count) + 1 ); --increment only if the button is still held
      else count <= (others => '0'); --reset count when the button is released
    end if;
    else dbnc <= '1';	--set dbnc high once count > 2.5 million
         if (btn = '0') then
           dbnc <= '0'; --reset dbnc when the button is released
           count <= (others => '0'); --reset count when the button is released
         end if;
    end if;
  end if;
end process;

end debounce;
