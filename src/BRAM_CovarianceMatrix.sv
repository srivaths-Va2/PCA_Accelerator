`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 16.01.2025 11:57:11
// Design Name: BRAM_CovarianceMatrix
// Module Name: BRAM_CovarianceMatrix
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This is a BRAM module, which is to store the results of the covariance matrix
// This is an IP catalog design provided by Vivado
// 
// Dependencies: The IP Catalog - Block Memory Generator
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Project Name: PCA_Accelerator
    Target Devices: Xilinx Basys3 FPGA - cpg236
    Tool Versions: Vivado 2024.1

    Description:
    This configuration is intended for implementing the PCA_Accelerator project
    on the Xilinx Basys3 FPGA platform. It specifies the target device and the
    compatible tool version for synthesis and implementation.
*/

/*

------------------------------------ INBUILT VIVADO IP------------------------------------ 

This is a design implemented using Vivado's inbuilt IP Catalog. It is configured to the below parameters
1) Interface Type - Native
2) Memory Type - Single Port RAM
3) ECC Type - No ECC
4) Generate Memory Address of 32 bits - No
5) Write Width - 32 bits
6) Read Width - 32 bits
7) Write Depth - 4 bits
8) Read Depth - 4 bits
9) Init COE file loaded - No initialisation of memory
10) Vivado's expected latency = 2 clock cycles

--------------------------------------------------------------------------------------------

*/


module BRAM_CovarianceMatrix(
        input clk,
        input ena,
        input wea,
        input [1:0] addra,
        input [31:0] dina,
        output [31:0] douta
    );
    
      BRAM_Cov cov (
      clk,
      ena,
      wea,
      addra,
      dina,
      douta
    );
endmodule
