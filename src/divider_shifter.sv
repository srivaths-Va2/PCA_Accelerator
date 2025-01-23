`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:15:06
// Design Name: divider_shifter
// Module Name: divider_shifter
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The shifter would shift the input phase of 2x to create x. The shifter right shifts by one bit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: divider_shifter

    Description:
    This module performs a right shift operation on an 8-bit input signal,
    effectively dividing the input value by 2. The result is assigned to
    the 8-bit output signal.

    Inputs:
    - in: An 8-bit input signal to be divided by 2.

    Outputs:
    - out: An 8-bit output signal representing the result of the division.
*/

module divider_shifter(
    input [7:0] in,
    output reg [7:0] out
    );
    
    assign out = (in >> 1);
    
endmodule
