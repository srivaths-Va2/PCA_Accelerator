`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:09:34
// Design Name: data_query_engine
// Module Name: data_query_engine
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The DQE (Data Query Engine) would output the values of c_pp, c_pq and c_qq from the TPU
// directly to the CORDIC engine for generating the Givens rotation matrix
// By ensuring that the DQE is directly operated on the TPU output, it reduces the need for further memory access back to
// the covariance BRAM
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/*

The data query engine would input the data from the TPU, and compare against every element
to output the largest off diagonal element. The values of p, q and the associated values of 
c_pp, c_qq are also outputted

*/

/*
    Module: data_query_engine

    Parameters:
    - MATRIX_SIZE: Size of the matrix (default is 4).
    - DATA_SIZE: Bit-width of the data elements (default is 8).

    Inputs:
    - clk: Clock signal.
    - data_from_TPU: Array of data elements from the TPU, with size MATRIX_SIZE*MATRIX_SIZE.

    Outputs:
    - p: Row index of the maximum off-diagonal element.
    - q: Column index of the maximum off-diagonal element.
    - c_pq: Value of the maximum off-diagonal element.
    - c_pp: Value of the diagonal element at position (p, p).
    - c_qq: Value of the diagonal element at position (q, q).

    Description:
    This module identifies the maximum off-diagonal element in a matrix received from a TPU.
    It outputs the indices of this element and the values of the diagonal elements at these indices.
*/

module data_query_engine#(parameter MATRIX_SIZE = 4, DATA_SIZE = 8)(
    input logic clk,
    input logic [DATA_SIZE-1:0] data_from_TPU [MATRIX_SIZE*MATRIX_SIZE-1:0],
    output logic [1 : 0] p,
    output logic [1 : 0] q,
    output logic [7 : 0] c_pq,
    output logic [7 : 0] c_pp,
    output logic [7 : 0] c_qq
    );
    
    /*
    Algorithm
    1) initialise the maximum off diagonal element to a very small value
    2) initialise the max_row and max_col variables to 0
    3) calculate row and column indices-
        row = index // 4
        col = index % 4
    4) if row != col then check if queried element is greater than initialised max_diag element
    5) If greater, then output the value of max_diag element
    6) p will be the value of max_row and q will be the value of max_col
    */
    
    // Initialise a variable to store the max_off_diag element for time being
    //logic [7 : 0] max_off_diag;
    // Initialise a variable to store the value of row and col 
    logic [1 : 0] row;
    logic [1 : 0] col;
    
    // iterator variable
    integer index;
    
    initial
        begin
            c_pq = 8'b000_00000;
        end
    
    always@(posedge clk)
        begin
            for(index = 0; index < 16; index = index + 1)
                begin
                    row = (index / 4);
                    col = (index % 4);
                    
                    // check if row is not equal to column, thus giving us an off-diagonal element
                    if(row != col)
                        begin
                            if(data_from_TPU[index] > c_pq)
                                begin
                                    c_pq <= data_from_TPU[index];
                                    p <= row;
                                    q <= col;
                                    c_pp <= data_from_TPU[(p * 4) + p];
                                    c_qq <= data_from_TPU[(q * 4) + q];
                                end
                        end
                end
        end
    
    
    
    
endmodule
