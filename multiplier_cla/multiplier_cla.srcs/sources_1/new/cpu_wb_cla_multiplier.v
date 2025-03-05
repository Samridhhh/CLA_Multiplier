`timescale 1ns/1ps

module cpu_wb_cla_multiplier #(parameter MULTICAND_WID = 32, parameter MULTIPLIER_WID = 32) (
    input  [MULTICAND_WID-1:0] multicand,
    input  [MULTIPLIER_WID-1:0] multiplier,
    output [(MULTICAND_WID + MULTIPLIER_WID - 1):0] product
);

    wire [MULTICAND_WID - 1:0] partial_products [MULTIPLIER_WID-1:0];
    wire [MULTICAND_WID:0] sum [MULTIPLIER_WID-1:0]; // Fixed for correct width
    wire [MULTIPLIER_WID:0] carry; // Carry propagation

    genvar i, j;
    
    generate
        // Generate Partial Products
        for (j = 0; j < MULTIPLIER_WID; j = j + 1) begin : partial_product_gen
            assign partial_products[j] = multicand & {MULTICAND_WID{multiplier[j]}};
        end

        // First row assignments
        assign sum[0] = {1'b0, partial_products[0]}; // Extended width
        assign carry[0] = 1'b0;

        // Summing rows using CLA Adders
        for (i = 1; i < MULTIPLIER_WID; i = i + 1) begin : cla_addition
            cpu_wb_cla_adder #(.DATA_WID(MULTICAND_WID + 1)) cla_adder_inst (
                .in1({carry[i-1], sum[i-1][MULTICAND_WID:1]}), // Shifted previous sum
                .in2({1'b0, partial_products[i]}), // Current row
                .carry_in(1'b0),
                .sum(sum[i]),
                .carry_out(carry[i])
            );
        end

        // Assigning Final Product
        assign product = {carry[MULTIPLIER_WID-1], sum[MULTIPLIER_WID-1]};

    endgenerate

endmodule
