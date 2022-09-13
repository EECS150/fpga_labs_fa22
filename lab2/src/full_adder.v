module full_adder (
    input a,
    input b,
    input carry_in,
    output sum,
    output carry_outs
);
    // Insert your RTL here to calculate the sum and carry out bits
    // Remove these assign statements once you write your own RTL
	assign sum = a ^ b ^ carry_in; 
	assign carry_outs = (carry_in && (a ^ b)) || (a && b);
endmodule
