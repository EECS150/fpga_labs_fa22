module z1top #(
    parameter CLOCK_FREQ = 125_000_000,
    parameter BAUD_RATE = 115_200,
    /* verilator lint_off REALCVT */
    // Sample the button signal every 500us
    parameter integer B_SAMPLE_CNT_MAX = 0.0005 * CLOCK_FREQ,
    // The button is considered 'pressed' after 100ms of continuous pressing
    parameter integer B_PULSE_CNT_MAX = 0.100 / 0.0005,
    /* lint_on */
    parameter CYCLES_PER_SECOND = 125_000_000
) (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS,
    output AUD_PWM,
    output AUD_SD,
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);
    
    wire [2:0] buttons_pressed;
    wire reset;
    wire [1:0] switches_sync;
    
    button_parser #(
        .WIDTH(4),
        .SAMPLE_CNT_MAX(B_SAMPLE_CNT_MAX),
        .PULSE_CNT_MAX(B_PULSE_CNT_MAX)
    ) bp (
        .clk(CLK_125MHZ_FPGA),
        .in(BUTTONS),
        .out({buttons_pressed, reset})
    );

    synchronizer #(.WIDTH(2)) switch_sync (
        .clk(CLK_125MHZ_FPGA),
        .async_signal(SWITCHES),
        .sync_signal(switches_sync)
    );

    wire [7:0] data_in;
    wire [7:0] data_out;
    wire data_in_valid, data_in_ready, data_out_valid, data_out_ready;

//---------------------- LED OUTPUT ---------------------

    wire [5:0] fl_leds;
    wire [5:0] mem_state_leds;

    assign LEDS = switches_sync[0] ? fl_leds : mem_state_leds;

//------------------------- UART ---------------------------
    // This UART is on the FPGA and communicates with your desktop
    // using the FPGA_SERIAL_TX, and FPGA_SERIAL_RX signals. The ready/valid
    // interface for this UART is used on the FPGA design.
    uart # (.CLOCK_FREQ(CLOCK_FREQ),.BAUD_RATE(BAUD_RATE)) 
    on_chip_uart (
        .clk(CLK_125MHZ_FPGA),
        .reset(reset),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .data_out_ready(data_out_ready),
        .serial_in(FPGA_SERIAL_RX),
        .serial_out(FPGA_SERIAL_TX)
    );
//------------------------- RX FIFO ---------------------------
    wire rx_fifo_full;
    assign data_out_ready = ~rx_fifo_full;
    wire [7:0] rx_dout;
    wire rx_fifo_empty;
    wire rx_rd_en, fl_rx_rd_en, mem_rx_rd_en;

    assign rx_rd_en = switches_sync[0] ? fl_rx_rd_en : mem_rx_rd_en;

    fifo #(.WIDTH(8), .DEPTH(8)) 
    rx_fifo (
        .clk(CLK_125MHZ_FPGA), .rst(reset),
        .wr_en(data_out_valid && ~rx_fifo_full),
        .din(data_out),
        .full(rx_fifo_full),
        .rd_en(rx_rd_en),
        .dout(rx_dout),
        .empty(rx_fifo_empty)
    );


//------------------------- TX FIFO ---------------------------
    wire [7:0] tx_din, fl_din, mem_din;
    assign tx_din = switches_sync[0] ? fl_din : mem_din;

    wire tx_fifo_full, tx_wr_en, fl_tx_wr_en, mem_tx_wr_en;
    assign tx_wr_en = switches_sync[0] ? fl_tx_wr_en : mem_tx_wr_en;

    wire tx_fifo_empty;
    reg tx_fifo_empty_delayed;
    assign data_in_valid = ~tx_fifo_empty_delayed;
    always @(posedge CLK_125MHZ_FPGA) begin
        tx_fifo_empty_delayed <= tx_fifo_empty;
    end

    fifo #(.WIDTH(8), .DEPTH(8)) 
    tx_fifo (
        .clk(CLK_125MHZ_FPGA), .rst(reset),
        .wr_en(tx_wr_en),
        .din(tx_din),
        .full(tx_fifo_full),
        .rd_en(data_in_ready && ~tx_fifo_empty),
        .dout(data_in),
        .empty(tx_fifo_empty)
    );



//------------------------- MEM CONTROLLER ---------------------------
    mem_controller #(.FIFO_WIDTH(8)) 
    mem_ctrl (
      .clk(CLK_125MHZ_FPGA),.rst(reset),
      .rx_fifo_empty(rx_fifo_empty),
      .tx_fifo_full(tx_fifo_full),
      .din(rx_dout),    
      .rx_fifo_rd_en(mem_rx_rd_en),
      .tx_fifo_wr_en(mem_tx_wr_en),
      .dout(mem_din),
      .state_leds(mem_state_leds)
    );

/*
//---------------------- Audio Code Below (Extra Credit) ---------------------
    
    wire [9:0] code;
    wire [23:0] fcw, fl_fcw;
    assign fcw = switches_sync[1] ? fl_fcw : 24'b0;
    wire next_sample;

    dac dac (
        .clk(CLK_125MHZ_FPGA),
        .rst(reset),
        .code(code),
        .next_sample(next_sample),
        .pwm(AUD_PWM)
    );

    nco nco (
        .clk(CLK_125MHZ_FPGA),
        .rst(reset),
        .fcw(fcw),
        .next_sample(next_sample),
        .code(code)
    );

    fixed_length_piano #(
        .CYCLES_PER_SECOND(CYCLES_PER_SECOND)) 
    fl_piano (
        .clk(CLK_125MHZ_FPGA),.rst(reset),
        .buttons(buttons_pressed),
        .leds(fl_leds),
        .ua_tx_din(fl_din),
        .ua_tx_wr_en(fl_tx_wr_en),
        .ua_tx_full(tx_fifo_full),
        .ua_rx_dout(rx_dout),
        .ua_rx_empty(rx_fifo_empty),
        .ua_rx_rd_en(fl_rx_rd_en),
        .fcw(fl_fcw)
    );

    assign AUD_SD = switches_sync[1]; // Enable the audio output

*/

endmodule
