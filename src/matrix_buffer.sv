`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:09:34
// Design Name: matrix_buffer
// Module Name: matrix_buffer
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The matrix buffer would serve as a simple buffer to pass the inputs to the outputs. It is a buffer
// that passes the 128 bit vector from input to output 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  Module: matrix_buffer

  This module represents a buffer for a matrix of configurable size and data width.
  It takes an input matrix and outputs the same matrix without any transposition.

  Parameters:
    MATRIX_SIZE - The size of the matrix (number of rows/columns).
    DATA_WIDTH - The bit width of each matrix element.

  Ports:
    mat_in  - The input matrix, represented as a flattened 1D array.
    mat_out - The output matrix, identical to the input matrix.
*/

module matrix_buffer#(parameter MATRIX_SIZE = 4, parameter DATA_WIDTH=8)(
    input logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] mat_in, //input matrix
    output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] mat_out //output non-transposed matrix
    );
    
    assign mat_out = mat_in;
    
endmodule

