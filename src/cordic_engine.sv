`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:19:51
// Design Name: top_CORDIC
// Module Name: cordic_engine
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The CORDIC engine would compute all the required trigonometric transformations
// The CORDIC inputs the data from the DQE and obtains the rotation angle 'theta'
// The value of 'theta' is used to compute the value of sine and cosine of the angle, to generate the Givens Rotation matrix
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Top-level module for the CORDIC algorithm implementation.

    This module computes the sine and cosine values using the CORDIC algorithm.
    It takes in clock and control signals, along with a valid input signal for
    arctan computation. The module outputs valid sine and cosine data.

    Inputs:
        - clk: Clock signal.
        - c_pq, c_pp, c_qq: Control signals for the inverse tangent module.
        - input_arctan_valid: Valid signal for arctan input data.

    Outputs:
        - sincos_valid: Valid signal indicating the output sine and cosine data are ready.
        - output_cosine_data: 8-bit output representing the cosine value.
        - output_sine_data: 8-bit output representing the sine value.

    Internal Logic:
        - Instantiates the inverse tangent module (inv_tan) to compute arctan.
        - Uses a divider shifter (divider_shifter) to process the arctan data.
        - Computes sine and cosine using the sin_cos unit.
*/

module top_CORDIC(
    input logic clk,
    input logic c_pq,
    input logic c_pp,
    input logic c_qq,
    input logic input_arctan_valid,
    output logic sincos_valid,
    output logic [7 : 0] output_cosine_data,
    output logic [7 : 0] output_sine_data
    //output logic ena_givens,
    //output logic wea_givens
    );
    
    logic output_arctan_valid;
    logic [7 : 0] output_arctan_data;
    logic [7 : 0] output_phase_data;
    
    // Instantiate the inverse tan module
    inv_tan INVTAN(
        clk,
        c_pq,
        c_pp,
        c_qq,
        input_arctan_valid,
        output_arctan_valid,
        output_arctan_data
    );
    
    // Instantiate the shifter
    divider_shifter DIV(
        output_arctan_data,
        output_phase_data
    );
    
    // Instantiate the sine socine unit
    sin_cos SINCOS(
        clk,
        output_arctan_valid,
        output_phase_data,
        sincos_valid,
        output_cosine_data,
        output_sine_data
    );
    
    
endmodule

