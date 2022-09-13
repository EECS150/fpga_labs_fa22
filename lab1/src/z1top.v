`timescale 1ns / 1ps

module z1top(
  input CLK_125MHZ_FPGA,
  input [3:0] BUTTONS,
  input [1:0] SWITCHES,
  output [5:0] LEDS
  //output [5:0] LEDS
);
  wire tmp1, tmp2;
  xor(tmp1, BUTTONS[0], BUTTONS[1]);
  and(tmp2, BUTTONS[2], BUTTONS[3]);
  nor(LEDS[1], tmp1, tmp2);
  //and(LEDS[0], BUTTONS[0], SWITCHES[0]);
  assign LEDS[0] = 0;
  assign LEDS[5:2] = 0;
endmodule
