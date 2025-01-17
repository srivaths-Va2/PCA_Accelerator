`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 17.01.2025 11:48:53
// Design Name: top
// Module Name: top_CovUnit
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The top module would implement the components of the accelerator and realise its complete functionality
// For the moment, it interfaces the TPU to the BRAM of the covariance matrix, serving as the input to the Jacobian unit
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: top_CovUnit

    Description:
    This module serves as the top-level unit for covariance computation, integrating
    a matrix multiplication unit (TPU) and a Controller-BRAM interface. It processes
    two input matrices 'in_a' and 'in_b', each of size MATRIX_SIZE, and outputs the
    result 'douta' along with a 'done_writing' signal indicating completion.

    Parameters:
    - MATRIX_SIZE: Size of the input matrices.
    - DATA_SIZE: Bit-width of the matrix elements.

    Inputs:
    - clk: Clock signal.
    - rst: Reset signal.
    - in_a: First input matrix of size MATRIX_SIZE.
    - in_b: Second input matrix of size MATRIX_SIZE.

    Outputs:
    - douta: 32-bit output data.
    - done_writing: Signal indicating the completion of writing the output.
*/

module top_CovUnit#(parameter MATRIX_SIZE = 4, DATA_SIZE = 8)(
    input logic clk,
    input logic rst,
    input logic[DATA_SIZE - 1 : 0]in_a[MATRIX_SIZE - 1: 0],
    input logic[DATA_SIZE - 1 : 0]in_b[MATRIX_SIZE - 1 : 0],
    output [31:0] douta,
    output done_writing
    );
    
    // Instantiate the intermediate wires
    logic[DATA_SIZE - 1 : 0]out_matrix[MATRIX_SIZE * MATRIX_SIZE - 1 : 0];
    logic done_TPU;
    
    // Instantiate the TPU
    matrix_multiply#(MATRIX_SIZE, DATA_SIZE)TPU(
        in_a,
        in_b,
        rst,
        clk,
        out_matrix,
        done_TPU
    );
    
    // Instantiate the Controller-BRAM interface
    top_Controller_BRAM cont_bram(
        clk,
        rst,
        out_matrix,
        done_TPU,
        douta,
        done_writing
    );
    
endmodule
