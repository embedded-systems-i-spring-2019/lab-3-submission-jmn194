----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 05:45:12 PM
-- Design Name: 
-- Module Name: echo - Behavioral
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

entity echo is
port ( clk, en, ready, newChar : in std_logic;
       charIn : in std_logic_vector(7 downto 0);
       send : out std_logic;
       charOut : out std_logic_vector(7 downto 0));
end echo;

architecture Behavioral of echo is

type state is (idle, busyA, busyB, busyC);
signal curr : state := idle;

begin
process(clk)
begin
if rising_edge(clk) then
    if en = '1' then

        case curr is
            when idle =>
                if newChar = '1' then
                    send <= '1';
                    charOut <= charIn;
                    curr <= busyA;
                end if;
            
            when busyA =>
                curr <= busyB;
                
            when busyB =>
                send <= '0';
                curr <= busyC;
                
            when busyC =>
                if ready = '1' then
                    curr <= idle;
                else
                    curr <= busyC;
                end if;
                
            when others =>
                curr <= idle;
                
        end case;
    end if;
end if;

end process;
end Behavioral;
