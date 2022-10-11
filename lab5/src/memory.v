module memory #(
    parameter MEM_WIDTH = 32,
    parameter DEPTH = 128,
    parameter NUM_BYTES_PER_WORD = MEM_WIDTH/8,
    parameter MEM_ADDR_WIDTH = $clog2(DEPTH)
) (
    input clk,
    input en, 
    input [NUM_BYTES_PER_WORD-1:0] we,
    input [MEM_ADDR_WIDTH-1:0] addr,
    input [MEM_WIDTH-1:0] din,
    output reg [MEM_WIDTH-1:0] dout
);
    // No change needs to be made for this file
    // See page 133 of the Vivado Synthesis Guide for the template
    // https://www.xilinx.com/support/documentation/sw_manuals/xilinx2016_4/ug901-vivado-synthesis.pdf

    reg [MEM_WIDTH-1:0] mem [DEPTH-1:0];

    integer i;
    always @(posedge clk) begin
        if (en) begin
            for(i=0; i < NUM_BYTES_PER_WORD; i=i+1) begin
                if (we[i]) begin
                    mem[addr][i*8 +: 8] <= din[i*8 +: 8];
                end
            end
        dout <= mem[addr];
        end
    end
    
endmodule
