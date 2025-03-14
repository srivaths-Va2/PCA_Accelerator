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
// Description: This is a Dual Port BRAM module, which is to store the results of the covariance matrix
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
5) Port A Write Width - 32 bits
6) Port A Read Width - 32 bits
7) Port A Write Depth - 4 bits
8) Port A Read Depth - 4 bits
9) Port B Write Width - 32 bits
10) Port B Read Width - 32 bits
11) Port B Write Depth - 4 bits
12) Port B Read Depth - 4 bits
13) Init COE file loaded - No initialisation of memory
14) Vivado's expected latency = 2 clock cycles

--------------------------------------------------------------------------------------------

*/


module BRAM_CovarianceMatrix(
        input logic clk,
        // port A inputs
        input logic ena_from_TPU,
        input logic wea_from_TPU,
        input logic [1:0] addra_from_TPU,
        input logic [31:0] dina_from_TPU,
        output logic [31:0] douta_from_TPU,
        // port B inputs
        input logic ena_from_rotation,
        input logic wea_from_rotation,
        input logic [1:0] addra_from_rotation,
        input logic [31:0] dina_from_rotation,
        output logic [31:0] douta_from_rotation
    );
    
      BRAM_Cov your_instance_name (
      .clka(clk),    // input wire clka
      .ena(ena_from_TPU),      // input wire ena
      .wea(wea_from_TPU),      // input wire [0 : 0] wea
      .addra(addra_from_TPU),  // input wire [1 : 0] addra
      .dina(dina_from_TPU),    // input wire [31 : 0] dina
      .douta(douta_from_TPU),  // output wire [31 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(ena_from_rotation),      // input wire enb
      .web(wea_from_rotation),      // input wire [0 : 0] web
      .addrb(addra_from_rotation),  // input wire [1 : 0] addrb
      .dinb(dina_from_rotation),    // input wire [31 : 0] dinb
      .doutb(douta_from_rotation)  // output wire [31 : 0] doutb
    );

endmodule
