`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 04.12.2024 22:58:05
// Design Name: 
// Module Name: covariance_unit/systolic_array_top
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: the top module realises the functionality of the systolic array fully integrated with control and datapath units
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolic_array_top#(
    parameter DATA_WIDTH = 8,
    parameter MAX_CLK = 4,
    parameter N = 2
    )
    (
    input clk,
    input rst,
    input start,
    input[2 * DATA_WIDTH - 1 : 0] A_in,
    input[2 * DATA_WIDTH - 1 : 0] B_in,
    output[2 * DATA_WIDTH - 1 : 0] a_out,
    output[2 * DATA_WIDTH - 1 : 0] b_out,
    output[4 * DATA_WIDTH - 1 : 0] psum_out,
    output done
    );
    
    // intermediate wires
    wire pe_reg, pe_enable;
    wire[1:0] current_row, current_col;
    
    // control unit
    systolic_array_control_unit#(MAX_CLK, N)SA_CU(clk, rst, start, pe_rst, pe_enable, current_row, current_col, done);
    
    // datapath
    systolic_array#(DATA_WIDTH) SA_DU(clk, rst, A_in, B_in, a_out, b_out, psum_out);
    
endmodule
