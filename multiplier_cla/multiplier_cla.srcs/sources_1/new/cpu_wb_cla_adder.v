module cpu_wb_cla_adder(
    input [15:0] in1, in2,
    input carry_in,
    output [15:0] sum,
    output carry_out
);

    wire [16:0] result;  // Extra bit for carry
    assign result = in1 + in2 + carry_in;
    
    assign sum = result[15:0];        // Lower 16 bits are the sum
    assign carry_out = result[16];    // 17th bit is carry_out

endmodule
