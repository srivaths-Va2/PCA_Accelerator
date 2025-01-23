`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 17.01.2025 11:48:53
// Design Name: top
// Module Name: top
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
    Top-level module for a matrix processing system using CORDIC and Givens rotation.

    Parameters:
    - DATA_SIZE: Bit-width of the input data elements.
    - MATRIX_SIZE: Dimension of the input matrices.

    Inputs:
    - clk: Clock signal.
    - rst: Reset signal.
    - in_a: First input matrix with elements of size DATA_SIZE.
    - in_b: Second input matrix with elements of size DATA_SIZE.
    - input_arctan_valid: Validity signal for arctan input.

    Outputs:
    - douta_givens: Output data from the Givens matrix datapath.

    Description:
    This module integrates several components including a matrix multiplier (TPU),
    a data query engine, a CORDIC unit, a Givens controller, and a Givens matrix
    datapath. It processes input matrices using CORDIC-based Givens rotations.
*/

module top#(parameter DATA_SIZE = 8, MATRIX_SIZE = 4)(
    input logic clk,
    input logic rst,
    input logic[DATA_SIZE - 1 : 0]in_a[MATRIX_SIZE - 1: 0],
    input logic[DATA_SIZE - 1 : 0]in_b[MATRIX_SIZE - 1 : 0],
    input logic input_arctan_valid,
    output logic [31 : 0] douta_givens 
    );
    
    // define the intermediate connections
    
    logic[DATA_SIZE - 1 : 0]out_matrix[MATRIX_SIZE * MATRIX_SIZE - 1 : 0];
    logic done_TPU;
    logic [31:0] douta_cov;
    logic done_writing_cov;
    
    // pin connections between data query engine and the CORDIC unit
    logic [1 : 0] p;
    logic [1 : 0] q;
    logic [7 : 0] c_pq;
    logic [7 : 0] c_pp;
    logic [7 : 0] c_qq;   
    
    // pin connections between CORDIC and Givens controller
    logic [7 : 0] sin_data;
    logic [7 : 0] cos_data;
    logic sincos_valid;
    
    // pin connections between Givens controller and Givens datapath
    logic ena_givens;
    logic wea_givens;
    logic [1 : 0] addra_givens;
    logic [7 : 0] dina_givens;
    
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
    
    // The Data Query Engine
    data_query_engine#(.DATA_SIZE(DATA_SIZE), .MATRIX_SIZE(MATRIX_SIZE))DQE(
        clk,
        out_matrix,
        p,
        q,
        c_pq,
        c_pp,
        c_qq
    );
    
    // The CORDIC unit
    top_CORDIC CORDIC_ENGINE(
        clk,
        c_pq,
        c_pp,
        c_qq,
        input_arctan_valid,
        sincos_valid,
        cos_data,
        sin_data
    );
    
    // The Givens controller
    controller_givensmatrix GIVENS_CONTROLLER(
        clk,
        p,
        q,
        cos_data,
        sin_data,
        ena_givens,
        wea_givens,
        addra_givens,
        dina_givens
    );
    
    // The Givens BRAM
    givens_matrix_datapath GIVENS_DATAPATH(
        clk,
        ena_givens,
        wea_givens,
        addra_givens,
        dina_givens,
        douta_givens
    );
    
endmodule
