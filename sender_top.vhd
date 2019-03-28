----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 10:58:01 PM
-- Design Name: 
-- Module Name: sender_top - Behavioral
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

entity sender_top is
port ( TXD, clk : in std_logic;
       btn : in std_logic_vector(1 downto 0);
       CTS, RTS, RXD : out std_logic);
end sender_top;

architecture Behavioral of sender_top is

component Debounce is
Port (btn, clk : in std_logic;	
      dbnc : out std_logic);
end component;

component clock_div is
port ( clk : in std_logic;
       div : out std_logic);
end component;

component sender is
port ( rst, clk, en, btn, ready : in std_logic;
       send : out std_logic;
       char : out std_logic_vector(7 downto 0));
end component;

component uart is
port ( clk, en, send, rx, rst      : in std_logic;
       charSend                    : in std_logic_vector (7 downto 0);
       ready, tx, newChar          : out std_logic;
       charRec                     : out std_logic_vector (7 downto 0));
end component;

signal dbnc : std_logic_vector(1 downto 0);
signal div : std_logic;
signal ready, send : std_logic;
signal charSend : std_logic_vector(7 downto 0);

begin

u1: debounce port map ( btn => btn(0),
                        clk => clk,
                        dbnc => dbnc(0));
                        
u2: debounce port map ( btn => btn(1),
                        clk => clk,
                        dbnc => dbnc(1));
                        
u3: clock_div port map ( clk => clk,
                         div => div);                  
                         
u4: sender port map ( btn => dbnc(1),
                      clk => clk,
                      en => div,
                      ready => ready,
                      rst => dbnc(0),
                      char => charSend,
                      send => send);       
                      
u5: uart port map ( charSend => charSend, 
                    clk => clk,
                    en => div,
                    rst => dbnc(0),
                    rx => TXD,
                    send => send, 
                    ready => ready,
                    tx => RXD);
                       
RTS <= '0';
CTS <= '0';                                                                                         
end Behavioral;
