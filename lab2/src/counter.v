module counter (
  input clk,
  input ce,
  output [3:0] LEDS
);
    // Some initial code has been provided for you
    // You can change this code if needed
    reg [3:0] led_cnt_value = 4'd0;
    assign LEDS = led_cnt_value;

    // TODO: Instantiate a reg net to count the number of cycles
    // required to reach one second. Note that our clock period is 8ns.
    // Think about how many bits are needed for your reg.
    reg [26:0] numCycles = 27'd0;
    wire [26:0] maxCycles;
    assign maxCycles = 27'd125000000;

    always @(posedge clk) begin
      // TODO: update the reg if clock is enabled (ce is 1).
      // Once the requisite number of cycles is reached, increment the count.
      numCycles <= numCycles + 1;
      if (numCycles == maxCycles) begin
        if (ce) begin
          led_cnt_value <= led_cnt_value < 4'b1111 ? led_cnt_value + 1 : 4'd0;
        end
        numCycles <= 27'd0;
      end
    end
endmodule

