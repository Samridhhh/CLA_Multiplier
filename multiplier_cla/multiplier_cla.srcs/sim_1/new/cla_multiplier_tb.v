`timescale 1ns/1ps

module cpu_wb_cla_multiplier_tb;
  parameter MULTICAND_WID = 32;
  parameter MULTIPLIER_WID = 32;

  // Inputs
  reg [MULTICAND_WID-1:0] multicand;
  reg [MULTIPLIER_WID-1:0] multiplier;

  // Output
  wire [(MULTICAND_WID + MULTIPLIER_WID - 1):0] product;

  // Instantiate the CLA Multiplier
  cpu_wb_cla_multiplier #(.MULTICAND_WID(MULTICAND_WID), .MULTIPLIER_WID(MULTIPLIER_WID)) cla_multiplier_inst (
    .multicand(multicand),
    .multiplier(multiplier),
    .product(product)
  );

  // Test Stimulus
  initial begin
    $monitor("Time=%0t | multicand=%h multiplier=%h | product=%h", $time, multicand, multiplier, product);

    // Test case 1: 0 * 0
    multicand = 32'd0; multiplier = 32'd0;
    #10;

    // Test case 2: 10 * 10
    multicand = 32'd10; multiplier = 32'd10;
    #10;

    // Test case 3: 1000 * 50
    multicand = 32'd1000; multiplier = 32'd50;
    #10;

    // Test case 4: Large numbers
    multicand = 32'h7FFFFFFF; multiplier = 32'h0000FFFF;
    #10;

    // Test case 5: Max values
    multicand = 32'hFFFFFFFF; multiplier = 32'hFFFFFFFF;
    #10;

    // End simulation
    $stop;
  end

endmodule
