`timescale 1ns/1ps

`define CLK_PERIOD 8
`define B_SAMPLE_CNT_MAX 5
`define B_PULSE_CNT_MAX 5

`define CLOCK_FREQ 125_000_000
`define BAUD_RATE 25_000_000 
`define CYCLES_PER_CHAR ((`CLOCK_FREQ / `BAUD_RATE) * 10) // Number of cycles to send one packet using the UART
`define CYCLES_PER_SECOND (`CYCLES_PER_CHAR * 6)

module system_tb();

  reg clk = 0;
  reg rst; 
  reg [2:0] buttons;
  reg [1:0] switches;
  reg [7:0] off_chip_data_in;
  reg  off_chip_data_in_valid; 
  reg  off_chip_data_out_ready;
  wire off_chip_data_out_valid;
  wire off_chip_data_in_ready;
  wire [7:0] off_chip_data_out;

  wire FPGA_SERIAL_RX;
  wire FPGA_SERIAL_TX;
  wire [5:0] leds;

  localparam integer SYMBOL_EDGE_TIME = `CLOCK_FREQ / `BAUD_RATE;
  localparam CHAR0     = 8'h41; // ~ 'A'
  localparam MEM_DEPTH = 256;
  localparam FIFO_DEPTH = 8;
  localparam NUM_CHARS = 26;

  // Generate system clock
  always #(`CLK_PERIOD/2) clk <= ~clk;

  reg [7:0] tests_failed = 0;

  z1top #(
      .B_SAMPLE_CNT_MAX(`B_SAMPLE_CNT_MAX),
      .B_PULSE_CNT_MAX(`B_PULSE_CNT_MAX),
      .CLOCK_FREQ(`CLOCK_FREQ),
      .BAUD_RATE(`BAUD_RATE),
      .CYCLES_PER_SECOND(`CYCLES_PER_SECOND)
  ) top (
      .CLK_125MHZ_FPGA(clk),
      .BUTTONS({buttons, rst}),
      .SWITCHES(switches),
      .LEDS(leds),
      .AUD_PWM(),
      .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
      .FPGA_SERIAL_TX(FPGA_SERIAL_TX)
  );

  /* An off-chip UART here that uses the RX and TX lines
     emulating the host (computer) */
  uart #(
      .BAUD_RATE(`BAUD_RATE),
      .CLOCK_FREQ(`CLOCK_FREQ)
  ) off_chip_uart (
      .clk(clk),
      .reset(rst),
      .data_in(off_chip_data_in),
      .data_in_valid(off_chip_data_in_valid),
      .data_in_ready(off_chip_data_in_ready),
      .data_out(off_chip_data_out),
      .data_out_valid(off_chip_data_out_valid),
      .data_out_ready(off_chip_data_out_ready),
      .serial_in(FPGA_SERIAL_TX),
      .serial_out(FPGA_SERIAL_RX)
  );

  /* Define a task that sends data to z1_top via the off_chip_uart */
  task off_chip_uart_send;
    input [7:0] data;
    begin
        while (!off_chip_data_in_ready) begin
            @(posedge clk);
        end
        #1;
        $display("Sending byte: %d.", data);
        off_chip_data_in_valid = 'b1;
        off_chip_data_in = data;
        @(posedge clk); 
        #1;
        off_chip_data_in_valid = 'b0;
    end
  endtask

  /* Define a task that checks data received by the off_chip_uart from z1_top */
  task off_chip_uart_receive;
    input [7:0] data;
    begin
      while (!off_chip_data_out_valid) begin
            @(posedge clk);
        end
        #1;
        off_chip_data_out_ready = 1'b0;   
        assert(off_chip_data_out == data) $display("PASSED! Expected : %d Actual %d", data, off_chip_data_out); else begin
          $error("FAILED! Expected : %d Actual %d, TX_FIFO_out is %d", data, off_chip_data_out, top.data_in);
          tests_failed += 1;
        end
        @(posedge clk);
        off_chip_data_out_ready = 1'b1;   // so the off_chip_rx_fifo will clear the "has byte" again
    end
  endtask 


  /* Define a wrapper for write */
  task write_packet;
    input [7:0] addr;
    input [7:0] data;
    input bool_delay;
    begin
      off_chip_uart_send(8'd49);

      if (bool_delay) repeat (2) @(posedge clk);

      off_chip_uart_send(addr);

      if (bool_delay) repeat (1) @(posedge clk);

      off_chip_uart_send(data);

    end
  endtask

  /* Define a wrapper for read */
  task read_packet;
    input [7:0] addr;
    input [7:0] expected_data;
    input bool_delay;
    begin

      off_chip_uart_send(8'd48);
      
      if(bool_delay) repeat (2) @(posedge clk);
      off_chip_uart_send(addr);
    
      if(bool_delay) repeat (1) @(posedge clk);
      
      wait(top.tx_fifo.rd_en == 1'b1);
      @(posedge clk);

      off_chip_uart_receive(expected_data);

    end
  endtask 

  initial begin

    `ifndef IVERILOG
        $vcdpluson;
	      $vcdplusmemon;
    `endif
    `ifdef IVERILOG
        $dumpfile("system_tb.fst");
        $dumpvars(0, system_tb);
        for(z = 0; z < MEM_DEPTH; z = z + 1) begin
            // to show each entry of the 2D reg in your mem on the waveform
            $dumpvars(0, top.mem_ctrl.mem.mem[z]);
        end
        for(z = 0; z < FIFO_DEPTH; z = z + 1) begin
            // to show each entry of the 2D regs in your FIFOs on the waveform
            // Uncomment the following lines and replace "data" with the name of your 2D reg
            // $dumpvars(0, top.rx_fifo.data[z]);
            // $dumpvars(0, top.tx_fifo.data[z]);
        end
    `endif
    off_chip_data_in = 8'd0;
    off_chip_data_in_valid = 1'b0;
    off_chip_data_out_ready = 1'b1;
    buttons = 0;
    switches = 0;

    /* Simulate pushing the reset button and holding it for a while */
    rst = 1'b0;
    repeat (5) @(posedge clk); #1;
    rst = 1'b1;
    repeat (40) @(posedge clk); #1;
    rst = 1'b0;

    // simple W-R test
    $display("------- Running simple test -------");
    assert(FPGA_SERIAL_TX == 1'b1);
    assert(FPGA_SERIAL_RX == 1'b1);
    $display("------- Write a Byte -------");
    write_packet(8'd11, CHAR0,1'b0);
    repeat(`CYCLES_PER_CHAR * 5) @(posedge clk);
    $display("------- Read a Byte -------");
    read_packet(8'd11, CHAR0,1'b0);

    repeat(10) @(posedge clk);

    // consecutive W, then R 
    $display("------- Running harder test -------");
    assert(FPGA_SERIAL_TX == 1'b1);
    assert(FPGA_SERIAL_RX == 1'b1);
    for(integer i = 0; i < NUM_CHARS; i += 1) begin
          write_packet(8'd0+i, CHAR0+i,1'b0);
    end
    for(integer i = NUM_CHARS-1; i >= 0; i -= 1) begin
          read_packet(8'd0+i, CHAR0+i,1'b0);
    end

    $display("All tests done!");

    if (tests_failed == 0) 
        $display("\nAll tests PASSED!\n");
    else
        $display("\n%d tests FAILED.\n", tests_failed);

    `ifndef IVERILOG
        $vcdplusoff;
        $vcdplusmemoff;
    `endif
    $finish();

  end

  //   initial begin
  //     fork
  //     begin while(1)begin
  //       wait(top.mem_ctrl.rx_fifo_rd_en == 1'b0);
  //       wait(top.mem_ctrl.rx_fifo_rd_en == 1'b1);
  //       @ (posedge clk);
  //       @ (posedge clk);
  //       //$display("RX FIFO out is %d, cmd is %d, pkt_rd_count is %d", top.mem_ctrl.din, top.mem_ctrl.cmd, top.mem_ctrl.pkt_rd_cnt);
  //       //wait(top.mem_ctrl.curr_state == 3'd2 || top.mem_ctrl.curr_state == 3'd3);
  //       end
  //     end
  //   begin

  //       while(1)begin
  //       wait(top.mem_ctrl.pkt_rd_cnt == 3);
  //       @ (posedge clk);
  //       @ (posedge clk);
  //       //$display("RX FIFO out is %d, pkt_rd_count is %d", top.mem_ctrl.din, top.mem_ctrl.pkt_rd_cnt);
  //       //wait(top.mem_ctrl.curr_state == 3'd2 || top.mem_ctrl.curr_state == 3'd3);
  //       wait(top.mem_ctrl.pkt_rd_cnt == 0);
  //       end

  //   end
  // join
  // end
  
  initial begin
      repeat (`CYCLES_PER_CHAR * 500) @(posedge clk);
      $error("Timing out");
      $fatal();
  end
endmodule




