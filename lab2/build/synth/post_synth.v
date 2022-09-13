// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
// Date        : Mon Sep 12 21:22:51 2022
// Host        : c111-2.eecs.berkeley.edu running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force -file post_synth.v
// Design      : z1top
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module counter
   (LEDS,
    CLK_125MHZ_FPGA_IBUF_BUFG,
    SWITCHES_IBUF);
  output [3:0]LEDS;
  input CLK_125MHZ_FPGA_IBUF_BUFG;
  input [0:0]SWITCHES_IBUF;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK_125MHZ_FPGA_IBUF_BUFG;
  wire [3:0]LEDS;
  wire [0:0]SWITCHES_IBUF;
  wire [26:1]data0;
  wire led_cnt_value;
  wire \led_cnt_value[3]_i_1_n_0 ;
  wire \led_cnt_value[3]_i_4_n_0 ;
  wire [26:0]numCycles;
  wire numCycles0_carry__0_n_0;
  wire numCycles0_carry__0_n_1;
  wire numCycles0_carry__0_n_2;
  wire numCycles0_carry__0_n_3;
  wire numCycles0_carry__1_n_0;
  wire numCycles0_carry__1_n_1;
  wire numCycles0_carry__1_n_2;
  wire numCycles0_carry__1_n_3;
  wire numCycles0_carry__2_n_0;
  wire numCycles0_carry__2_n_1;
  wire numCycles0_carry__2_n_2;
  wire numCycles0_carry__2_n_3;
  wire numCycles0_carry__3_n_0;
  wire numCycles0_carry__3_n_1;
  wire numCycles0_carry__3_n_2;
  wire numCycles0_carry__3_n_3;
  wire numCycles0_carry__4_n_0;
  wire numCycles0_carry__4_n_1;
  wire numCycles0_carry__4_n_2;
  wire numCycles0_carry__4_n_3;
  wire numCycles0_carry__5_n_3;
  wire numCycles0_carry_n_0;
  wire numCycles0_carry_n_1;
  wire numCycles0_carry_n_2;
  wire numCycles0_carry_n_3;
  wire \numCycles[0]_i_2_n_0 ;
  wire \numCycles[0]_i_3_n_0 ;
  wire \numCycles[0]_i_4_n_0 ;
  wire \numCycles[0]_i_5_n_0 ;
  wire \numCycles[0]_i_6_n_0 ;
  wire \numCycles[0]_i_7_n_0 ;
  wire \numCycles[0]_i_8_n_0 ;
  wire \numCycles[26]_i_1_n_0 ;
  wire [0:0]numCycles_0;
  wire [3:0]p_0_in;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    \led_cnt_value[0]_i_1 
       (.I0(LEDS[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \led_cnt_value[1]_i_1 
       (.I0(LEDS[0]),
        .I1(LEDS[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \led_cnt_value[2]_i_1 
       (.I0(LEDS[1]),
        .I1(LEDS[0]),
        .I2(LEDS[2]),
        .O(p_0_in[2]));
  LUT5 #(
    .INIT(32'h00000040)) 
    \led_cnt_value[3]_i_1 
       (.I0(\led_cnt_value[3]_i_4_n_0 ),
        .I1(SWITCHES_IBUF),
        .I2(LEDS[3]),
        .I3(numCycles[0]),
        .I4(\numCycles[0]_i_2_n_0 ),
        .O(\led_cnt_value[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h02)) 
    \led_cnt_value[3]_i_2 
       (.I0(SWITCHES_IBUF),
        .I1(numCycles[0]),
        .I2(\numCycles[0]_i_2_n_0 ),
        .O(led_cnt_value));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \led_cnt_value[3]_i_3 
       (.I0(LEDS[2]),
        .I1(LEDS[0]),
        .I2(LEDS[1]),
        .I3(LEDS[3]),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \led_cnt_value[3]_i_4 
       (.I0(LEDS[1]),
        .I1(LEDS[0]),
        .I2(LEDS[2]),
        .O(\led_cnt_value[3]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \led_cnt_value_reg[0] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(led_cnt_value),
        .D(p_0_in[0]),
        .Q(LEDS[0]),
        .R(\led_cnt_value[3]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \led_cnt_value_reg[1] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(led_cnt_value),
        .D(p_0_in[1]),
        .Q(LEDS[1]),
        .R(\led_cnt_value[3]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \led_cnt_value_reg[2] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(led_cnt_value),
        .D(p_0_in[2]),
        .Q(LEDS[2]),
        .R(\led_cnt_value[3]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \led_cnt_value_reg[3] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(led_cnt_value),
        .D(p_0_in[3]),
        .Q(LEDS[3]),
        .R(\led_cnt_value[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry
       (.CI(\<const0> ),
        .CO({numCycles0_carry_n_0,numCycles0_carry_n_1,numCycles0_carry_n_2,numCycles0_carry_n_3}),
        .CYINIT(numCycles[0]),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[4:1]),
        .S(numCycles[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry__0
       (.CI(numCycles0_carry_n_0),
        .CO({numCycles0_carry__0_n_0,numCycles0_carry__0_n_1,numCycles0_carry__0_n_2,numCycles0_carry__0_n_3}),
        .CYINIT(\<const0> ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[8:5]),
        .S(numCycles[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry__1
       (.CI(numCycles0_carry__0_n_0),
        .CO({numCycles0_carry__1_n_0,numCycles0_carry__1_n_1,numCycles0_carry__1_n_2,numCycles0_carry__1_n_3}),
        .CYINIT(\<const0> ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[12:9]),
        .S(numCycles[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry__2
       (.CI(numCycles0_carry__1_n_0),
        .CO({numCycles0_carry__2_n_0,numCycles0_carry__2_n_1,numCycles0_carry__2_n_2,numCycles0_carry__2_n_3}),
        .CYINIT(\<const0> ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[16:13]),
        .S(numCycles[16:13]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry__3
       (.CI(numCycles0_carry__2_n_0),
        .CO({numCycles0_carry__3_n_0,numCycles0_carry__3_n_1,numCycles0_carry__3_n_2,numCycles0_carry__3_n_3}),
        .CYINIT(\<const0> ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[20:17]),
        .S(numCycles[20:17]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry__4
       (.CI(numCycles0_carry__3_n_0),
        .CO({numCycles0_carry__4_n_0,numCycles0_carry__4_n_1,numCycles0_carry__4_n_2,numCycles0_carry__4_n_3}),
        .CYINIT(\<const0> ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[24:21]),
        .S(numCycles[24:21]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 numCycles0_carry__5
       (.CI(numCycles0_carry__4_n_0),
        .CO(numCycles0_carry__5_n_3),
        .CYINIT(\<const0> ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .O(data0[26:25]),
        .S({\<const0> ,\<const0> ,numCycles[26:25]}));
  LUT2 #(
    .INIT(4'h2)) 
    \numCycles[0]_i_1 
       (.I0(\numCycles[0]_i_2_n_0 ),
        .I1(numCycles[0]),
        .O(numCycles_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \numCycles[0]_i_2 
       (.I0(\numCycles[0]_i_3_n_0 ),
        .I1(\numCycles[0]_i_4_n_0 ),
        .I2(\numCycles[0]_i_5_n_0 ),
        .I3(\numCycles[0]_i_6_n_0 ),
        .I4(\numCycles[0]_i_7_n_0 ),
        .I5(\numCycles[0]_i_8_n_0 ),
        .O(\numCycles[0]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFDF)) 
    \numCycles[0]_i_3 
       (.I0(numCycles[16]),
        .I1(numCycles[15]),
        .I2(numCycles[17]),
        .I3(numCycles[18]),
        .O(\numCycles[0]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hDFFF)) 
    \numCycles[0]_i_4 
       (.I0(numCycles[20]),
        .I1(numCycles[19]),
        .I2(numCycles[22]),
        .I3(numCycles[21]),
        .O(\numCycles[0]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFD)) 
    \numCycles[0]_i_5 
       (.I0(numCycles[8]),
        .I1(numCycles[7]),
        .I2(numCycles[10]),
        .I3(numCycles[9]),
        .O(\numCycles[0]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \numCycles[0]_i_6 
       (.I0(numCycles[12]),
        .I1(numCycles[11]),
        .I2(numCycles[14]),
        .I3(numCycles[13]),
        .O(\numCycles[0]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \numCycles[0]_i_7 
       (.I0(numCycles[4]),
        .I1(numCycles[3]),
        .I2(numCycles[6]),
        .I3(numCycles[5]),
        .O(\numCycles[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFF7FF)) 
    \numCycles[0]_i_8 
       (.I0(numCycles[25]),
        .I1(numCycles[26]),
        .I2(numCycles[23]),
        .I3(numCycles[24]),
        .I4(numCycles[2]),
        .I5(numCycles[1]),
        .O(\numCycles[0]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \numCycles[26]_i_1 
       (.I0(numCycles[0]),
        .I1(\numCycles[0]_i_2_n_0 ),
        .O(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[0] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(numCycles_0),
        .Q(numCycles[0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[10] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[10]),
        .Q(numCycles[10]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[11] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[11]),
        .Q(numCycles[11]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[12] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[12]),
        .Q(numCycles[12]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[13] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[13]),
        .Q(numCycles[13]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[14] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[14]),
        .Q(numCycles[14]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[15] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[15]),
        .Q(numCycles[15]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[16] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[16]),
        .Q(numCycles[16]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[17] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[17]),
        .Q(numCycles[17]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[18] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[18]),
        .Q(numCycles[18]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[19] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[19]),
        .Q(numCycles[19]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[1] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[1]),
        .Q(numCycles[1]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[20] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[20]),
        .Q(numCycles[20]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[21] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[21]),
        .Q(numCycles[21]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[22] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[22]),
        .Q(numCycles[22]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[23] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[23]),
        .Q(numCycles[23]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[24] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[24]),
        .Q(numCycles[24]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[25] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[25]),
        .Q(numCycles[25]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[26] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[26]),
        .Q(numCycles[26]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[2] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[2]),
        .Q(numCycles[2]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[3] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[3]),
        .Q(numCycles[3]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[4] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[4]),
        .Q(numCycles[4]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[5] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[5]),
        .Q(numCycles[5]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[6] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[6]),
        .Q(numCycles[6]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[7] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[7]),
        .Q(numCycles[7]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[8] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[8]),
        .Q(numCycles[8]),
        .R(\numCycles[26]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \numCycles_reg[9] 
       (.C(CLK_125MHZ_FPGA_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data0[9]),
        .Q(numCycles[9]),
        .R(\numCycles[26]_i_1_n_0 ));
endmodule

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
  wire CLK_125MHZ_FPGA;
  wire CLK_125MHZ_FPGA_IBUF;
  wire CLK_125MHZ_FPGA_IBUF_BUFG;
  wire [5:0]LEDS;
  wire [3:0]LEDS_OBUF;
  wire [1:0]SWITCHES;
  wire [0:0]SWITCHES_IBUF;

  BUFG CLK_125MHZ_FPGA_IBUF_BUFG_inst
       (.I(CLK_125MHZ_FPGA_IBUF),
        .O(CLK_125MHZ_FPGA_IBUF_BUFG));
  IBUF CLK_125MHZ_FPGA_IBUF_inst
       (.I(CLK_125MHZ_FPGA),
        .O(CLK_125MHZ_FPGA_IBUF));
  GND GND
       (.G(\<const0> ));
  OBUF \LEDS_OBUF[0]_inst 
       (.I(LEDS_OBUF[0]),
        .O(LEDS[0]));
  OBUF \LEDS_OBUF[1]_inst 
       (.I(LEDS_OBUF[1]),
        .O(LEDS[1]));
  OBUF \LEDS_OBUF[2]_inst 
       (.I(LEDS_OBUF[2]),
        .O(LEDS[2]));
  OBUF \LEDS_OBUF[3]_inst 
       (.I(LEDS_OBUF[3]),
        .O(LEDS[3]));
  OBUF \LEDS_OBUF[4]_inst 
       (.I(\<const0> ),
        .O(LEDS[4]));
  OBUF \LEDS_OBUF[5]_inst 
       (.I(\<const0> ),
        .O(LEDS[5]));
  IBUF \SWITCHES_IBUF[0]_inst 
       (.I(SWITCHES[0]),
        .O(SWITCHES_IBUF));
  counter ctr
       (.CLK_125MHZ_FPGA_IBUF_BUFG(CLK_125MHZ_FPGA_IBUF_BUFG),
        .LEDS(LEDS_OBUF),
        .SWITCHES_IBUF(SWITCHES_IBUF));
endmodule
