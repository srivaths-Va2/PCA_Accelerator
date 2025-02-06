`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:09:34
// Design Name: matrix_transposer
// Module Name: matrix_transposer
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The matrix transposer would perform matrix transpose operation on the input matrix. It is a purely
// dataflow circuit, and does not incur any delay to the output. It performs matrix transpose operation on the large 
// 128 bit flattened array input
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  Module: matrix_transposer

  This module transposes a square matrix of a specified size and data width.
  It takes a flattened input matrix and outputs its transposed version, both
  represented as a single-dimensional logic vector.

  Parameters:
    MATRIX_SIZE - The size of the matrix (number of rows/columns).
    DATA_WIDTH  - The bit width of each matrix element.

  Ports:
    mat_in  - Input logic vector representing the matrix to be transposed.
    mat_out - Output logic vector representing the transposed matrix.
*/

module matrix_transposer #(parameter MATRIX_SIZE = 4, parameter DATA_WIDTH=8)
	(	
		input logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] mat_in, //input matrix
		output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] mat_out //transposed matrix
	);
	 

	
	wire [DATA_WIDTH-1:0] Amat [0:MATRIX_SIZE - 1][0:MATRIX_SIZE - 1]; //Matrix form of the input
	wire [DATA_WIDTH-1:0] Bmat [0:MATRIX_SIZE - 1][0:MATRIX_SIZE - 1]; //Matrix form of the output
	
	genvar i,j;
	
	//Converts the input to a matrix form
	generate
		for (i = 0; i < MATRIX_SIZE; i = i + 1) begin: loop1
			for (j = 0; j < MATRIX_SIZE; j = j + 1) begin: loop2
					assign Amat[i][j] = mat_in[MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-MATRIX_SIZE*i*DATA_WIDTH-j*DATA_WIDTH-1:MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-MATRIX_SIZE*i*DATA_WIDTH-j*DATA_WIDTH-DATA_WIDTH];
			end
		end
	endgenerate
	
	// Computes the transpose
	generate
		for (i = 0; i < MATRIX_SIZE; i = i + 1) begin: loop3
			for (j = 0; j < MATRIX_SIZE; j = j + 1) begin: loop4
					assign Bmat[j][i]=Amat[i][j];
			end
		end
	endgenerate
	
	// Converts the transpose to a matrix form
	generate
		for (i = 0; i < MATRIX_SIZE; i = i + 1) begin: loop5
			for (j = 0; j < MATRIX_SIZE; j = j + 1) begin: loop6
					assign mat_out[MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-MATRIX_SIZE*i*DATA_WIDTH-j*DATA_WIDTH-1:MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-MATRIX_SIZE*i*DATA_WIDTH-j*DATA_WIDTH-DATA_WIDTH]=Bmat[i][j];
			end
		end
	endgenerate
	
	
endmodule

