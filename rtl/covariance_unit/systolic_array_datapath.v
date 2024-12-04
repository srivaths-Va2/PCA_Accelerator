`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 04.12.2024 22:15:34
// Design Name: 
// Module Name: covariance_unit/systolic_array
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: A 2x2 systolic array datapath realised from the base PEs
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolic_array#(
    parameter DATA_WIDTH = 8
    )
    (
        input clk,
        input rst,
        input [2 * DATA_WIDTH - 1 : 0] A_in,  // flattened inputs, as verilog doesnt support post defined arrays
        input [2 * DATA_WIDTH - 1 : 0] B_in,  // flattened inputs, as verilog doesnt support post defined arrays
        output [2 * DATA_WIDTH - 1 : 0] a_out, // flattened output
        output [2 * DATA_WIDTH - 1 : 0] b_out, // flattened output
        output [4 * DATA_WIDTH - 1 : 0] psum_out // flattened output partial sum
    );
    

    // intermediate wire connections
    wire [DATA_WIDTH - 1 : 0] a_out_00, a_out_01, a_out_10, a_out_11;
    wire [DATA_WIDTH - 1 : 0] b_out_00, b_out_01, b_out_10, b_out_11;
    wire [2 * DATA_WIDTH - 1 : 0] psum_out_00, psum_out_01, psum_out_10, psum_out_11;
    
    // PE(0, 0)
    processing_element#(DATA_WIDTH)PE_00(clk, rst, A_in[DATA_WIDTH - 1 : 0], B_in[DATA_WIDTH - 1 : 0], 0, a_out_00, b_out_00, psum_out_00);
    
    // PE(0, 1)
    processing_element#(DATA_WIDTH)PE_01(clk, rst, a_out_00, B_in[2*DATA_WIDTH-1:DATA_WIDTH], 0, a_out_01, b_out_01, psum_out_01);
    
    // PE(1, 0)
    processing_element#(DATA_WIDTH)PE_10(clk, rst, A_in[2*DATA_WIDTH-1:DATA_WIDTH], b_out_00, 0, a_out_10, b_out_10, psum_out_10);
    
    // PE(1, 1)
    processing_element#(DATA_WIDTH)PE_11(clk, rst, a_out_10, b_out_01, psum_out_10, a_out_11, b_out_11, psum_out_11);
    
    // Connect outputs
    assign a_out = {a_out_01, a_out_11}; // combine outputs into a vector
    assign b_out = {b_out_10, b_out_11}; // combine outputs into a vector
    assign psum_out = {psum_out_00, psum_out_01, psum_out_10, psum_out_11}; // output psum vector
    
endmodule
