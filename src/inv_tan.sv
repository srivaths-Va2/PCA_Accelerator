`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:14:00
// Design Name: inv_tan
// Module Name: inv_tan
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The inverse tan module is stage-1 of the CORDIC engine
// The inverse tan module would compute twice of the rotation angle from the values of c_pq, c_pp and c_qq
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  Module: inv_tan

  This module calculates the inverse tangent (arctan) of a given input.
  It takes three 8-bit logic inputs: c_pq, c_pp, and c_qq, and computes
  the numerator and denominator for the arctangent operation. The result
  is processed by an arctangent unit, which outputs the arctan value.

  Parameters:
    DATA_SIZE - Defines the size of the data inputs and outputs.

  Inputs:
    clk - Clock signal for synchronization.
    c_pq - 8-bit logic input for the numerator calculation.
    c_pp - 8-bit logic input for the denominator calculation.
    c_qq - 8-bit logic input for the denominator calculation.
    input_arctan_valid - Validity signal for the input data.

  Outputs:
    output_arctan_valid - Validity signal for the output data.
    output_arctan_data - 8-bit logic output representing the arctan result.
*/

/*

------------------------------------ INBUILT VIVADO IP------------------------------------ 

This is a design implemented using Vivado's inbuilt IP Catalog. It is configured to the below parameters
1) Functional Selection - Arc Tan
2) Architectural Configuration - Parallel
3) Pipelining Mode - Maximum
4) Data Format - SignedFraction
5) Phase Format - Radians
6) Input Width - 8 bits
7) Output Width - 8 bits
8) Round Mode - Truncate
9) AXI4 Stream - Not Configured
10) Vivado's expected latency = 12 clock cycles

--------------------------------------------------------------------------------------------

*/

module inv_tan(
    input logic clk,
    input logic[7:0] c_pq,
    input logic[7:0] c_pp,
    input logic[7:0] c_qq,
    input logic input_arctan_valid,
    output logic output_arctan_valid,
    output logic [7 : 0] output_arctan_data
    );
    
    parameter DATA_SIZE = 8;
    
    // intermediate variables
    logic[DATA_SIZE - 1 : 0] numerator;
    logic[DATA_SIZE - 1 : 0] denominator; 
    logic[2 * DATA_SIZE - 1 : 0] inp_arctan_data;
    
    // Processing logic to input to the arctangent unit
    assign numerator = 2 * c_pq;
    assign denominator = (c_pp - c_qq);
    assign inp_arctan_data = {denominator, numerator};
    
    arctangent invtan (
      .aclk(clk),                                        // input wire aclk
      .s_axis_cartesian_tvalid(input_arctan_valid),  // input wire s_axis_cartesian_tvalid
      .s_axis_cartesian_tdata(inp_arctan_data),    // input wire [15 : 0] s_axis_cartesian_tdata
      .m_axis_dout_tvalid(output_arctan_valid),            // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(output_arctan_data)              // output wire [7 : 0] m_axis_dout_tdata
    );

endmodule

