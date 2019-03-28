----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 10:07:19 PM
-- Design Name: 
-- Module Name: sender - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity sender is
port ( rst, clk, en, btn, ready : in std_logic;
       send : out std_logic;
       char : out std_logic_vector(7 downto 0));
end sender;

architecture Behavioral of sender is

type state is (idle, busyA, busyB, busyC);
signal curr : state := idle;

type str is array (0 to 5) of std_logic_vector(7 downto 0);
signal NetID : str := (x"6A", x"6D", x"6E", x"31", x"39", x"34"); --jmn194 NetID
signal i : std_logic_vector(2 downto 0) := "000";

begin
process(clk)
begin
if rising_edge(clk) then
    if en = '1' then
        if rst = '1' then
            send <= '0';
            char <= "00000000";
            i <= "000";
            curr <= idle;
        elsif (ready = '1' and btn = '1') then
            if (to_integer(unsigned(i)) < 6) then
                send <= '1';
                char <= NetID(to_integer(unsigned(i)));
                i <= std_logic_vector(unsigned(i) + 1);
                curr <= busyA;
            elsif (to_integer(unsigned(i)) = 6) then
                i <= "000";
                curr <= idle;
            end if;
        end if;
    end if;
    case curr is
        when idle =>

        when busyA =>
            curr <= busyB;
            
        when busyB =>
            send <= '0';
            curr <= busyC;
            
        when busyC =>
            if (ready = '1' and btn = '0') then
                curr <= idle;
            else
                curr <= busyC;
            end if;
        when others =>
            curr <= idle;
        
    end case;
end if;
end process;
end Behavioral;
