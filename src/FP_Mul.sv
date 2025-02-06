`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 16.01.2025 18:59:26
// Design Name: fixed_point_multiplier
// Module Name: FP_Mul
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This is a fixed point multipler, which computes product of two inputs in 2QN, ie-Q(3, 5) format,
// also outputs the correct product in 2QN format. Consequentially, it only supports a small range of inputs
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: fixed_point_multiplier

    Description:
    This module performs fixed-point multiplication of two 8-bit unsigned inputs, 'a' and 'b'.
    The result is an 8-bit unsigned output 'prod', which is a quantized version of the 
    16-bit intermediate multiplication result. The quantization is done by selecting bits 
    12 to 5 from the intermediate result, effectively scaling down the product.

    Inputs:
    - a: 8-bit unsigned multiplicand.
    - b: 8-bit unsigned multiplier.

    Output:
    - prod: 8-bit unsigned quantized product of the inputs.
*/

module fixed_point_multiplier(
    input[7:0] a,
    input[7:0] b,
    output[7:0] prod
    );
    
    reg [15:0] f_result;
    reg [7:0] multiplicand;
	reg [7:0] multiplier;
	reg [7:0] quantized_result;
	
    assign multiplicand = a;
    assign multiplier = b;
        
    assign f_result = multiplicand[7:0] * multiplier[7:0]; //We remove the sign bit for multiplication
    assign quantized_result = f_result[12:5];  
        
    assign prod = quantized_result;

endmodule

