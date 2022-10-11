`timescale 1ns/1ns

`define CLK_PERIOD 8

module mem_controller_tb();

    localparam FIFO_WIDTH = 8;
    localparam MEM_DEPTH = 256;
    localparam NUM_WRITES = 10;
    localparam NUM_READS = 10;
    localparam CHAR0 = 8'd65; /* ASCII 'A' */

    reg clk = 0;
    reg rst = 0;

    always #(`CLK_PERIOD/2) clk <= ~clk;

    reg rx_fifo_empty;
    reg tx_fifo_full;
    wire mem_rx_rd_en;
    wire mem_tx_wr_en;
    reg [7:0] rx_dout;
    wire [7:0] tx_din;
    wire [5:0] LEDS;

    mem_controller #(.FIFO_WIDTH(FIFO_WIDTH)) 
    mem_ctrl (
      .clk(clk),.rst(rst),
      .rx_fifo_empty(rx_fifo_empty),
      .tx_fifo_full(tx_fifo_full),
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

    task send_n_writes;
        input [7:0] n;
        input [7:0] start;
        begin

            for (integer w = 0; w < n; w += 1) begin

                @(posedge clk);
                #1;
                rx_fifo_empty = 1'b0;
               
                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk);
                    #1; 
                    rx_dout = test_write[start+w][7:0]; /* command */                   
                end

                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk);
                    #1; 
                    rx_dout = test_write[start+w][15:8]; /* addr */
                end

                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk);
                    #1; 
                    rx_dout = test_write[start+w][23:16]; /* data */
                    rx_fifo_empty = 1'b1; /* Sent all bytes for this command sequence */
                    @(posedge clk); 
                end 

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
               
                wait (rx_dout == 8'd49);               

                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk);
                    #1; 
                    verify_addr = rx_dout;
                end

                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk);
                    #1; 
                    verify_data = rx_dout;
                end

                repeat (5) @(posedge clk);
                assert (mem_ctrl.mem.mem[verify_addr] == verify_data) $display("PASSED! Expected : %d Actual %d", verify_data, mem_ctrl.mem.mem[verify_addr]); else $error("FAILED! Expected : %d Actual %d", verify_data, mem_ctrl.mem.mem[verify_addr]);

                verified_write = 1;
                #1;

            end
        end
    endtask

    reg verified_read = 0;

    task send_n_reads;
        input [7:0] n;
        input [7:0] start;
        begin

            for (integer w = 0; w < n; w += 1) begin

                @(posedge clk);
                #1;
                rx_fifo_empty = 1'b0;
               
                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk)
                    #1; 
                    rx_dout = test_read[start+w][7:0]; /* command */
                end

                wait (~rx_fifo_empty && mem_rx_rd_en) begin
                    @(posedge clk);
                    #1; 
                    rx_dout = test_read[start+w][15:8]; /* addr */      
                    rx_fifo_empty = 1'b1;  /* Sent all bytes for this command sequence */
                    @(posedge clk);              
                end

                wait (verified_read == 1);

            end
            
        end
    endtask

    task verify_n_reads;
        input [7:0] n;
        
        begin
            for (integer w = 0; w < n; w += 1) begin

                verified_read = 0;

                wait (mem_tx_wr_en == 1);
                #1;
                assert (tx_din == test_read_vals[w]) $display("PASSED! Expected : %d Actual %d", test_read_vals[w], tx_din); else begin
                    $error("FAILED! Expected : %d Actual %d", test_read_vals[w], tx_din);
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

        rx_fifo_empty = 1'b1;
        tx_fifo_full = 1'b0;

        rst = 1'b1;
        @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        repeat (10) @(posedge clk);

        /* 1 write */
        #1
        rx_fifo_empty = 1'b0;
        @(posedge clk);
        #1; 
        rx_dout = test_write[0][7:0];
        @(posedge clk);
        #1; 
        rx_dout = test_write[0][15:8];
        @(posedge clk);
        #1; 
        rx_dout = test_write[0][23:16];
        rx_fifo_empty = 1'b1;
        @(posedge clk); 

        repeat (10) @(posedge clk);

        /* 1 read */
        #1
        rx_fifo_empty = 1'b0;
        @(posedge clk);
        #1; 
        rx_dout = test_read[0][7:0];
        @(posedge clk);
        #1; 
        rx_dout = test_read[0][15:8];
        rx_fifo_empty = 1'b1;   // empty should be asserted as soon as the last output updates
        @(posedge clk);

        repeat (10) @(posedge clk);

        /* Probe memory to test whether writes reach memory correctly */

        fork
            send_n_writes(8, 0);
            verify_n_writes(8);
        join

        @(posedge clk);

        /* Test read results */

        fork
            send_n_reads(8, 0);
            verify_n_reads(8);
        join

        repeat (10) @(posedge clk);

        $display("Running interruption tests...");

        /* Interrupt a write command with rx_fifo_empty = 1 after cmd, then after addr */

        #1;
        rx_fifo_empty = 1'b0;
        @(posedge clk);

        #1;
        rx_dout = test_write[8][7:0]; 
        rx_fifo_empty = 1'b1;
        @(posedge clk);

        repeat (4) @(posedge clk);

        #1;
        rx_fifo_empty = 1'b0;
        @(posedge clk);

        #1; 
        rx_dout = test_write[8][15:8];  
        rx_fifo_empty = 1'b1;
        @(posedge clk);

        repeat (4) @(posedge clk);

        #1;
        rx_fifo_empty = 1'b0;
        @(posedge clk);

        #1; 
        rx_dout = test_write[8][23:16];
        rx_fifo_empty = 1'b1;
        @(posedge clk);

        /* Check write */

        repeat (4) @(posedge clk);

        assert (mem_ctrl.mem.mem[test_write[8][15:8]] == test_write[8][23:16]) $display("PASSED! Expected : %d Actual %d", test_write[8][23:16], mem_ctrl.mem.mem[test_write[8][15:8]]); else begin
            $error("FAILED! Expected : %d Actual %d", test_write[8][23:16], mem_ctrl.mem.mem[test_write[8][15:8]]);
            tests_failed += 1;
        end

        repeat (10) @(posedge clk);

        /* Send a simple write */

        #1
        rx_fifo_empty = 1'b0;
        @(posedge clk);
        #1; 
        rx_dout = test_write[9][7:0];
        @(posedge clk);
        #1; 
        rx_dout = test_write[9][15:8];
        @(posedge clk);
        #1; 
        rx_dout = test_write[9][23:16];
        rx_fifo_empty = 1'b1;
        // @(posedge clk); 

        /* Interrupt a read command with rx_fifo_empty = 1 after cmd, then leave tx_fifo_full = 1 for a while */
    
        repeat (5) @(posedge clk);

        #1;
        rx_fifo_empty = 1'b0;
        @(posedge clk);

        #1; 
        rx_dout = test_read[9][7:0]; 
        rx_fifo_empty = 1'b1;
        @(posedge clk);

        repeat (4) @(posedge clk);

        #1;
        rx_fifo_empty = 1'b0;
        @(posedge clk);

        #1;
        rx_dout = test_read[9][15:8];
        rx_fifo_empty = 1'b1;
        @(posedge clk);

        #1;
        tx_fifo_full = 1'b1;
        @(posedge clk);

        repeat (4) @(posedge clk);

        #1;
        tx_fifo_full = 1'b0;

        wait (mem_tx_wr_en == 1); 
        #1;

        assert (tx_din == test_read_vals[9]) $display("PASSED! Expected : %d Actual %d", test_read_vals[9], tx_din); else begin
            $error("FAILED! Expected : %d Actual %d", test_read_vals[9], tx_din);
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
