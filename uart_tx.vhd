----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 12:22:39 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
port ( clk, en, send, rst : in std_logic;
       char : in std_logic_vector(7 downto 0);
       ready : out std_logic;
       tx : out std_logic);
end uart_tx;

architecture Behavioral of uart_tx is

    type state is (idle, start, data);
    signal curr : state := idle;
    signal d : std_logic_vector (7 downto 0) := x"00";
    signal count : natural;
    

begin
process(clk, rst, en)
begin
if rising_edge(clk) then
    if rst = '1' then
        curr <= idle;
        d <= x"00";
        count <= 0;
        ready <= '0';
        tx <= '0';
    else
        if en = '1' then
        case curr is
            when idle =>
                ready <= '1';
                curr <= start;
                tx <= '1';

            when start =>
                if (send = '1' and en = '1') then
                    d <= char;
                    curr <= data;
                    count <= 0;
                    tx <= '0';
                end if;
                
            when data =>
                if count < 8 then
                    tx <= d(count);
                    count <= count + 1;
                else
                    curr <= idle;
                    tx <= '1';
                    ready <= '0';
                    count <= 0;
                end if;
                
            when others =>
                curr <= idle;
        end case;
        end if;
    end if;
end if;
end process;
end Behavioral;