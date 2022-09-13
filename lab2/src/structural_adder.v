module structural_adder #(parameter last = 14) (
    input [13:0] a,
    input [13:0] b,
    output [14:0] sum
);
	wire [last:0] cOut;
	assign cOut[0] = 1'b0;
	generate
		for (genvar i = 0; i < last; i = i + 1) begin:adders
			full_adder generated_adder(.a(a[i]), .b(b[i]), .carry_in(cOut[i]), .sum(sum[i]), .carry_outs(cOut[i+1]));	
		end
	endgenerate
	assign sum[last] = cOut[last];
endmodule
