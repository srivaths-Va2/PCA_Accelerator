`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 16.01.2025 11:57:11
// Design Name: BRAM_IdentityMatrix
// Module Name: BRAM_IdentityMatrix
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This is a Dual Port BRAM module, which is to store the Identity matrix for Rotations
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
13) Init COE file loaded - Initialisation of memory at ip.coe
14) Vivado's expected latency = 2 clock cycles

--------------------------------------------------------------------------------------------

*/


module BRAM_IdentityMatrix(
    input logic clk,
    input logic ena_identity_A,
    input logic wea_identity_A,
    input logic [1 : 0] addra_identity_A,
    input logic [31 : 0] dina_identity_A,
    output logic [31 : 0] douta_identity_A,
    input logic ena_identity_B,
    input logic wea_identity_B,
    input logic [1 : 0] addra_identity_B,
    input logic [31 : 0] dina_identity_B,
    output logic [31 : 0] douta_identity_B
    );
    
    BRAM_Identity BRAM_I (
      .clka(clk),    // input wire clka
      .ena(ena_identity_A),      // input wire ena
      .wea(wea_identity_A),      // input wire [0 : 0] wea
      .addra(addra_identity_A),  // input wire [1 : 0] addra
      .dina(dina_identity_A),    // input wire [31 : 0] dina
      .douta(douta_identity_A),  // output wire [31 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(ena_identity_B),      // input wire enb
      .web(wea_identity_B),      // input wire [0 : 0] web
      .addrb(addra_identity_B),  // input wire [1 : 0] addrb
      .dinb(dina_identity_B),    // input wire [31 : 0] dinb
      .doutb(douta_identity_B)  // output wire [31 : 0] doutb
    );
endmodule
