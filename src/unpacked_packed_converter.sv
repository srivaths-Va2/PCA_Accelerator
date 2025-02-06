`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:09:34
// Design Name: Data Alignment Unit
// Module Name: unpacked_packed_converter
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The Data Alignment Unit is a module that aligns the unpacked elements from the TPU to packed array format
// so that it can be processed by downstream tasks. This is a utility module for the project. It also does not consume
// clock cycles and is purely dataflow.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  Module: unpacked_packed_converter

  This module converts an unpacked array of data elements into a packed array.
  It takes an input array of size MATRIX_SIZE*MATRIX_SIZE, where each element
  is DATA_WIDTH bits wide, and outputs a single packed array of size 
  MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH bits.

  Parameters:
    MATRIX_SIZE - The dimension of the square matrix.
    DATA_WIDTH  - The bit width of each data element in the input array.

  Ports:
    array_in  - Input unpacked array of data elements.
    array_out - Output packed array of concatenated data elements.
*/

module unpacked_packed_converter#(parameter MATRIX_SIZE = 4, parameter DATA_WIDTH = 8)(
    input  logic [DATA_WIDTH-1:0] array_in [MATRIX_SIZE*MATRIX_SIZE-1:0],
    output logic [(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH)-1:0] array_out
    );
    
    genvar i;
    generate
        for (i = 0; i < MATRIX_SIZE*MATRIX_SIZE; i = i + 1) begin
            assign array_out[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = array_in[i];
        end
    endgenerate

endmodule

