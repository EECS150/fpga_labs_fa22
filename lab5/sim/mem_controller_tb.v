`timescale 1ns/1ns

`define CLK_PERIOD 8

/* mem_controller_tb v2 */

module mem_controller_tb();

    localparam FIFO_WIDTH = 8;
    localparam FIFO_DEPTH = 8;
    localparam MEM_DEPTH = 256;
    localparam NUM_WRITES = 10;
    localparam NUM_READS = 10;
    localparam CHAR0 = 8'd65; /* ASCII 'A' */

    reg clk = 0;
    reg rst = 0;

    always #(`CLK_PERIOD/2) clk <= ~clk;

    
    /* Mem <-> RX_FIFO and TX_FIFO signals */
    wire mem_rx_empty;
    wire mem_tx_full;
    wire mem_rx_rd_en;
    wire mem_tx_wr_en;
    wire [FIFO_WIDTH-1:0] rx_dout;
    wire [FIFO_WIDTH-1:0] tx_din;
    wire [5:0] LEDS;

    /* TB <-> RX_FIFO signals */
    // Enqueue signals (Write to RX_FIFO)
    reg tb_rx_wr_en = 0;
    reg [FIFO_WIDTH-1:0] tb_rx_din;
    wire tb_rx_full;

    // Dequeue signals (Read from TX_FIFO)
    wire tb_tx_empty;
    wire [FIFO_WIDTH-1:0] tb_tx_dout;
    reg tb_tx_rd_en = 0;

    fifo #(
        .WIDTH(FIFO_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) rx_fifo (
        .clk(clk),
        .rst(rst),

        .wr_en(tb_rx_wr_en),  // input
        .din(tb_rx_din),      // input
        .full(tb_rx_full),    // output

        .empty(mem_rx_empty),  // output
        .dout(rx_dout),    // output
        .rd_en(mem_rx_rd_en)   // input
    );

    fifo #(
        .WIDTH(FIFO_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) tx_fifo (
        .clk(clk),
        .rst(rst),

        .wr_en(mem_tx_wr_en),  // input
        .din(tx_din),      // input
        .full(mem_tx_full),    // output

        .empty(tb_tx_empty),  // output
        .dout(tb_tx_dout),    // output
        .rd_en(tb_tx_rd_en)   // input
    );

    mem_controller #(.FIFO_WIDTH(FIFO_WIDTH)) 
    mem_ctrl (
      .clk(clk),.rst(rst),
      .rx_fifo_empty(mem_rx_empty),
      .tx_fifo_full(mem_tx_full),
      .din(rx_dout),    
      .rx_fifo_rd_en(mem_rx_rd_en),
      .tx_fifo_wr_en(mem_tx_wr_en),
      .dout(tx_din),
      .state_leds(LEDS)
    );

    /* Test Vectors */
    /* WRITE (8'd49, 8'd<addr>, 8'd<data>) in first to last byte order */
    reg [23:0] test_write [NUM_WRITES-1 : 0];
    /* READ (8'd48, 8'd<addr>) in first to last byte order */
    reg [15:0] test_read [NUM_READS-1 : 0];
    reg [7:0] test_read_vals [NUM_READS-1: 0];
    reg [7:0] tests_failed = 0;

    reg verified_write = 0;

    // This task will push some data to the RX_FIFO through the write interface
    task write_to_rx_fifo;
        input [FIFO_WIDTH-1:0] write_data;
        begin
        #1;

        // Wait until the fifo is not full
        wait(tb_rx_full == 0);

        // If we are already full, don't write
        if (tb_rx_full) begin
            tb_rx_wr_en = 1'b0;
        end
        // Else write
        else begin
            tb_rx_wr_en = 1'b1;
        end

        // Write should be performed when enq_ready and enq_valid are HIGH
        tb_rx_din = write_data;

        // Wait for the clock edge to perform the write
        @(posedge clk); #1;

        // Deassert write
        tb_rx_wr_en = 1'b0;
        end
    endtask

    // This task will read some data from the TX_FIFO through the read interface
    task read_from_tx_fifo;
        output [FIFO_WIDTH-1:0] rd_data;
        begin
        #1;

        // Wait until the fifo is not empty
        wait(tb_tx_empty == 0);

        if (tb_tx_empty) begin
            tb_tx_rd_en = 1'b0;
        end
        else begin
            tb_tx_rd_en = 1'b1;
        end

        // Deassert read
        @(posedge clk); #1;

        rd_data = tb_tx_dout;
        tb_tx_rd_en = 1'b0;
        end
    endtask


    task send_n_writes;
        input [7:0] n;
        begin

            for (integer w = 0; w < n; w += 1) begin

                write_to_rx_fifo(test_write[w][7:0]);   /* command */
                write_to_rx_fifo(test_write[w][15:8]);  /* addr */  
                write_to_rx_fifo(test_write[w][23:16]); /* data */

                wait (verified_write == 1);

            end
            
        end
    endtask

    reg [7:0] verify_addr;
    reg [7:0] verify_data;

    task verify_n_writes;
        input [7:0] n;
        begin
            for (integer w = 0; w < n; w += 1) begin

                verified_write = 0;

                verify_addr = test_write[w][15:8];
                verify_data = test_write[w][23:16];
               
                // wait (tb_rx_dout == 8'd49);               

                // wait (~rx_fifo_empty && mem_rx_rd_en) begin
                //     @(posedge clk);
                //     #1; 
                //     verify_addr = rx_dout;
                // end

                // wait (~rx_fifo_empty && mem_rx_rd_en) begin
                //     @(posedge clk);
                //     #1; 
                //     verify_data = rx_dout;
                // end

                repeat (10) @(posedge clk);
                assert (mem_ctrl.mem.mem[verify_addr] == verify_data) $display("PASSED! Expected : %d Actual %d", verify_data, mem_ctrl.mem.mem[verify_addr]); else $error("FAILED! Expected : %d Actual %d", verify_data, mem_ctrl.mem.mem[verify_addr]);

                verified_write = 1;
                #1;

            end
        end
    endtask

    reg verified_read = 0;

    task send_n_reads;
        input [7:0] n;
        begin

            for (integer w = 0; w < n; w += 1) begin

                write_to_rx_fifo(test_read[w][7:0]);   /* command */
                write_to_rx_fifo(test_read[w][15:8]);  /* addr */ 

                wait (verified_read == 1);

            end
            
        end
    endtask

    reg [FIFO_WIDTH-1 : 0] read_data;

    task verify_n_reads;
        input [7:0] n;

        begin
            for (integer w = 0; w < n; w += 1) begin

                verified_read = 0;

                read_from_tx_fifo(read_data);

                assert (read_data == test_read_vals[w]) $display("PASSED! Expected : %d Actual %d", test_read_vals[w], read_data); else begin
                    $error("FAILED! Expected : %d Actual %d", test_read_vals[w], read_data);
                    tests_failed += 1;
                end

                @(posedge clk); // Wait for the cycle to end
                verified_read = 1;
                #1;

            end
        end
    endtask
    

    integer i, z;
    initial begin: TB

        `ifndef IVERILOG
            $vcdpluson;
            $vcdplusmemon;
        `endif
        `ifdef IVERILOG
            $dumpfile("mem_controller_tb.fst");
            $dumpvars(0, mem_controller_tb);
            for(z = 0; z < MEM_DEPTH; z = z + 1) begin
                // to show each entry of the 2D reg in your mem on the waveform
                $dumpvars(0, mem_ctrl.mem.mem[z]);
            end
            for(z = 0; z < FIFO_DEPTH; z = z + 1) begin
                // to show each entry of the 2D regs in your FIFOs on the waveform
                // Uncomment the following lines and replace "data" with the name of your 2D reg
                // $dumpvars(0, rx_fifo.data[z]);
                // $dumpvars(0, tx_fifo.data[z]);
            end
        `endif

        /* Initialize write sequence */
        for (i = 0; i < NUM_WRITES; i += 1) begin
            test_write[i][7:0] = 8'd49;
            test_write[i][15:8] = 10 + i;
            test_write[i][23:16] = CHAR0 + i;

            test_read[i][7:0] = 8'd48;
            test_read[i][15:8] = test_write[i][15:8];

            test_read_vals[i] = test_write[i][23:16];
        end

        rst = 1'b1;
        repeat (5) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        repeat (10) @(posedge clk);
       
        /* 1 write */
        $display("Sending a write packet...");
        write_to_rx_fifo(test_write[0][7:0]);
        write_to_rx_fifo(test_write[0][15:8]);
        write_to_rx_fifo(test_write[0][23:16]);

        repeat (10) @(posedge clk);

        /* 1 read */
        $display("Sending a read packet...");
        write_to_rx_fifo(test_read[0][7:0]);
        write_to_rx_fifo(test_read[0][15:8]);
        read_from_tx_fifo(read_data);

        repeat (10) @(posedge clk);

        /* Probe memory to test whether writes reach memory correctly */
        $display("Running consecutive writing tests...");
        fork
            send_n_writes(8);
            verify_n_writes(8);
        join

        @(posedge clk);

        /* Test read results */
        $display("Running consecutive reading tests...");
        fork
            send_n_reads(8);
            verify_n_reads(8);
        join

        repeat (10) @(posedge clk);

        $display("Running interruption tests...");

        /* Interrupt a write command with rx_fifo_empty = 1 after cmd, then after addr */

        write_to_rx_fifo(test_write[8][7:0]);

        repeat (5) @(posedge clk);

        write_to_rx_fifo(test_write[8][15:8]);

        repeat (5) @(posedge clk);

        write_to_rx_fifo(test_write[8][23:16]);

        repeat (10) @(posedge clk);

        /* Check write */

        assert (mem_ctrl.mem.mem[test_write[8][15:8]] == test_write[8][23:16]) $display("PASSED! Expected : %d Actual %d", test_write[8][23:16], mem_ctrl.mem.mem[test_write[8][15:8]]); else begin
            $error("FAILED! Expected : %d Actual %d", test_write[8][23:16], mem_ctrl.mem.mem[test_write[8][15:8]]);
            tests_failed += 1;
        end

        repeat (10) @(posedge clk);

        /* Send a simple write */

        write_to_rx_fifo(test_write[9][7:0]);
        write_to_rx_fifo(test_write[9][15:8]);
        write_to_rx_fifo(test_write[9][23:16]);

        repeat (5) @(posedge clk); 

        /* Interrupt a read command by leaving tx_fifo_full = 1 for a while */

        verified_read = 1; // skip verification for 9 reads

        /* Send 10 reads */
        send_n_reads(10);

        verified_read = 0;

        /* TX_FIFO of DEPTH 8 should be full */

        /* Drain FIFO */

        for (integer t = 0; t < 10; t += 1) begin
            read_from_tx_fifo(read_data);
        end

        assert (read_data == test_read_vals[9]) $display("PASSED! Expected : %d Actual %d", test_read_vals[9], read_data); else begin
            $error("FAILED! Expected : %d Actual %d", test_read_vals[9], read_data);
            tests_failed += 1;
        end

        repeat (10) @(posedge clk);
        
        if (tests_failed == 0) 
            $display("\nAll tests PASSED!\n");
        else
            $display("\n%d tests FAILED.\n", tests_failed);

        repeat (50) @(posedge clk);


        `ifndef IVERILOG
            $vcdplusoff;
            $vcdplusmemoff;
        `endif
        $finish();
    end

    initial begin
        repeat (75000) @(posedge clk);
        $error("Timing out");
        $fatal();
    end

endmodule
