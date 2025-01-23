`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:17:22
// Design Name: sin_cos
// Module Name: sin_cos
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The since cosine unit would output the value of sine and cosine of the input phase to the Givens
// Rotation matrix
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  Module: sin_cos

  This module calculates the sine and cosine values for a given input phase.
  It takes an 8-bit phase input and outputs 8-bit sine and cosine values.
  The module uses an instantiated sine_cosine unit to perform the calculations.

  Inputs:
    - clk: Clock signal.
    - input_phase_valid: Validity signal for the input phase data.
    - input_phase_data: 8-bit input phase data.

  Outputs:
    - output_sincos_valid: Validity signal for the output sine and cosine data.
    - output_cosine_data: 8-bit cosine value corresponding to the input phase.
    - output_sine_data: 8-bit sine value corresponding to the input phase.
*/

/*

------------------------------------ INBUILT VIVADO IP------------------------------------ 

This is a design implemented using Vivado's inbuilt IP Catalog. It is configured to the below parameters
1) Functional Selection - Sin and Cos
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

module sin_cos(
    input logic clk,
    input logic input_phase_valid,
    input logic [7 : 0] input_phase_data,
    output logic output_sincos_valid,
    output logic [7 : 0] output_cosine_data,
    output logic [7 : 0] output_sine_data
    );
    
    // intermediate variable for sine cosine storage
    logic [15 : 0] output_sine_cosine_data;
    
    // logic to assign sine and cosine
    assign output_cosine_data = output_sine_cosine_data[15 : 8];
    assign output_sine_data = output_sine_cosine_data[7 : 0];
    
    // Instantiate the sine cosine module
    sine_cosine sincos_unit (
      .aclk(clk),                                // input wire aclk
      .s_axis_phase_tvalid(input_phase_valid),  // input wire s_axis_phase_tvalid
      .s_axis_phase_tdata(input_phase_data),    // input wire [7 : 0] s_axis_phase_tdata
      .m_axis_dout_tvalid(output_sincos_valid),    // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(output_sine_cosine_data)      // output wire [15 : 0] m_axis_dout_tdata
    );
endmodule

