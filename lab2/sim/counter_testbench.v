`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000

module counter_testbench();
    reg clock = 0;
    reg ce = 0;
    wire [3:0] LEDS;

    counter ctr (
        .clk(clock),
        .ce(ce),
        .LEDS(LEDS)
    );

    // Notice that this code causes the `clock` signal to constantly
    // switch up and down every 4 time steps.
    always #(4) clock <= ~clock;

    initial begin
        `ifdef IVERILOG
            $dumpfile("counter_testbench.fst");
            $dumpvars(0, counter_testbench);
        `endif
        `ifndef IVERILOG
            $vcdpluson;
        `endif

        // TODO: Change input values and step forward in time to test
        // your counter and its clock enable/disable functionality.
        for (integer i = 0, currNum = 0; i < 34 ; i++) begin
            #(`MS)
            currNum = ce ? currNum + 1 : currNum;
            assert(LEDS == currNum % 16) 
            else $display("ERROR: Expected count to be %d, but got %d.", currNum % 16, LEDS);
            ce = ~ce;
        end

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule

