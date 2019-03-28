----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 05:55:28 PM
-- Design Name: 
-- Module Name: echo_top - Behavioral
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

entity echo_top is
port ( TXD, clk : in std_logic;
       btn : in std_logic_vector(1 downto 0);
       CTS, RTS, RXD : out std_logic);
end echo_top;

architecture Behavioral of echo_top is

component clock_div is
port ( clk : in std_logic;
       div : out std_logic);
end component;

component echo is
port ( clk, en, ready, newChar : in std_logic;
       charIn : in std_logic_vector(7 downto 0);
       send : out std_logic;
       charOut : out std_logic_vector(7 downto 0));
end component;

component uart is
port ( clk, en, send, rx, rst      : in std_logic;
       charSend                    : in std_logic_vector (7 downto 0);
       ready, tx                   : out std_logic;
       charRec                     : out std_logic_vector (7 downto 0));
end component;

--signal dbnc : std_logic_vector(1 downto 0);
signal div : std_logic;
signal ready, send : std_logic;
signal charSend : std_logic_vector(7 downto 0);

begin

u3: clock_div port map ( clk => clk,
                         div => div);         
                                           
u4: echo port map ( clk => clk,
                    en => div,
                    ready => ready,
                    newChar => TXD,
                    charIn => charSend,
                    send => send,
                    charOut => charSend);
                      
u5: uart port map ( clk => clk,
                    en => div,
                    send => send,
                    rst => '0',
                    charSend => charSend,
                    ready => ready,
                    rx => TXD,
                    tx => RXD);
                       
RTS <= '0';
CTS <= '0';                                                                                         
end Behavioral;