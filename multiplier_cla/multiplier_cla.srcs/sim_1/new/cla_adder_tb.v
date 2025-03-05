`timescale 1ns / 1ps

module cla_adder_tb;
    reg [15:0] in1, in2;
    reg carry_in;
    wire [15:0] sum;
    wire carry_out;

    // Instantiate the CLA Adder
    cpu_wb_cla_adder uut (
        .in1(in1),
        .in2(in2),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        // Monitor values for debugging
        $monitor("Time=%0t | in1=%h | in2=%h | carry_in=%b | sum=%h | carry_out=%b", 
                 $time, in1, in2, carry_in, sum, carry_out);

        // Test case 1
        in1 = 16'h7FFF;  // 32767
        in2 = 16'h1234;  // 4660
        carry_in = 1'b1;
        #10;

        // Test case 2
        in1 = 16'hFFFF;  // -1 (two's complement)
        in2 = 16'hFFFF;  // -1
        carry_in = 1'b1;
        #10;

        // Test case 3
        in1 = 16'h8000;  // -32768
        in2 = 16'h8000;  // -32768
        carry_in = 1'b0;
        #10;

        // Test case 4
        in1 = 16'h0000;  // 0
        in2 = 16'h0000;  // 0
        carry_in = 1'b0;
        #10;

        // End simulation
        $finish;
    end
endmodule
