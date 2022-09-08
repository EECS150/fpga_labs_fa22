// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
// Date        : Fri Sep  2 09:57:00 2022
// Host        : c111-9.eecs.berkeley.edu running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force post_route.v
// Design      : z1top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "7ca7c456" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module z1top
   (CLK_125MHZ_FPGA,
    BUTTONS,
    SWITCHES,
    LEDS);
  input CLK_125MHZ_FPGA;
  input [3:0]BUTTONS;
  input [1:0]SWITCHES;
  output [5:0]LEDS;

  wire \<const0> ;
  wire [3:0]BUTTONS;
  wire [3:0]BUTTONS_IBUF;
  wire [5:0]LEDS;
  wire [1:1]LEDS_OBUF;

  IBUF \BUTTONS_IBUF[0]_inst 
       (.I(BUTTONS[0]),
        .O(BUTTONS_IBUF[0]));
  IBUF \BUTTONS_IBUF[1]_inst 
       (.I(BUTTONS[1]),
        .O(BUTTONS_IBUF[1]));
  IBUF \BUTTONS_IBUF[2]_inst 
       (.I(BUTTONS[2]),
        .O(BUTTONS_IBUF[2]));
  IBUF \BUTTONS_IBUF[3]_inst 
       (.I(BUTTONS[3]),
        .O(BUTTONS_IBUF[3]));
  GND GND
       (.G(\<const0> ));
  OBUF \LEDS_OBUF[0]_inst 
       (.I(\<const0> ),
        .O(LEDS[0]));
  OBUF \LEDS_OBUF[1]_inst 
       (.I(LEDS_OBUF),
        .O(LEDS[1]));
  LUT4 #(
    .INIT(16'h0999)) 
    \LEDS_OBUF[1]_inst_i_1 
       (.I0(BUTTONS_IBUF[0]),
        .I1(BUTTONS_IBUF[1]),
        .I2(BUTTONS_IBUF[3]),
        .I3(BUTTONS_IBUF[2]),
        .O(LEDS_OBUF));
  OBUF \LEDS_OBUF[2]_inst 
       (.I(\<const0> ),
        .O(LEDS[2]));
  OBUF \LEDS_OBUF[3]_inst 
       (.I(\<const0> ),
        .O(LEDS[3]));
  OBUF \LEDS_OBUF[4]_inst 
       (.I(\<const0> ),
        .O(LEDS[4]));
  OBUF \LEDS_OBUF[5]_inst 
       (.I(\<const0> ),
        .O(LEDS[5]));
endmodule
