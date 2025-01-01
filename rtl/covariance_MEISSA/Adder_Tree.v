`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 01.01.2025 22:31:15
// Design Name: covariance_MEISSA/adder_tree.v
// Module Name: adder_tree
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: The adder tree within the MEISSA array
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_tree#(
    parameter DATA_WIDTH = 8
)(
        input [2 * DATA_WIDTH - 1 : 0] op1,
        input [2 * DATA_WIDTH - 1 : 0] op2,
        output [2 * DATA_WIDTH - 1 : 0] sum
    );
    
    assign sum = op1 + op2;
    
endmodule
