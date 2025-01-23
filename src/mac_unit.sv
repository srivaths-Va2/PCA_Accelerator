`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 16.01.2025 18:56:10
// Design Name: mac_unit
// Module Name: mac_unit
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This MAC unit is the processing element of the systolic array, and it offers FP support (2QN)
// 
// Dependencies: FP_Mul.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  A MAC (Multiply-Accumulate) unit module with parameterized data size.

  Parameters:
    data_size: Width of the input and output data buses.

  Ports:
    clk: Clock signal input.
    reset: Reset signal input.
    in_a: First input operand of size data_size.
    in_b: Second input operand of size data_size.
    out_a: Output register for the first operand.
    out_b: Output register for the second operand.
    out_sum: Accumulated sum output register.

  Functionality:
    - Multiplies inputs in_a and in_b using a fixed-point multiplier.
    - Accumulates the product into out_sum on each negative clock edge.
    - Resets outputs to zero when reset is asserted.
*/

module mac_unit#(parameter data_size = 8)
(
     input logic clk, 
     input logic reset,
     input logic [data_size-1:0] in_a,
     input logic [data_size-1:0] in_b,
     output reg [data_size-1:0] out_a,
     output reg [data_size-1:0] out_b,
     output reg [data_size-1:0] out_sum
 ); // appropriate sizing ensured in the top module

// temporary variable to store value of product
reg[data_size-1:0] temp_prod, fp_prod;

assign fp_prod = temp_prod;

// initialise the FP multiplier
fixed_point_multiplier FPMul(in_a, in_b, temp_prod);

always_ff @(negedge clk)
	begin
		if(reset)
			begin
				out_a <= 0;
				out_b <= 0;
				out_sum <= 0;
			end
		else
			begin
				out_a <= in_a;
				out_b <= in_b;
				//out_sum <= (in_a*in_b) + out_sum;
				out_sum <= fp_prod + out_sum;
			end
	end
endmodule
