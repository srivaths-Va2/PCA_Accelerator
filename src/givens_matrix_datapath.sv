`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:24:56
// Design Name: givens_matrix_datapath
// Module Name: givens_matrix_datapath
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This is a Dual Port BRAM module to store the Givens Rotation Matrix
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
  Module: givens_matrix_datapath

  Description:
  This module represents the datapath for a Givens matrix, utilizing a block RAM (BRAM) to store
  and retrieve matrix data. It interfaces with the BRAM through control signals for clock, enable,
  write enable, address, and data input/output.

  Ports:
  - clk: Clock signal for synchronizing operations.
  - ena_givens: Enable signal for activating the BRAM.
  - wea_givens: Write enable signal for writing data to the BRAM.
  - addra_givens: Address input for selecting the BRAM location.
  - dina_givens: Data input for writing to the BRAM.
  - douta_givens: Data output for reading from the BRAM.
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

module givens_matrix_datapath(
        input logic clk,
        input logic ena_givens,
        input logic wea_givens,
        input logic [1 : 0] addra_givens,
        input logic [31 : 0] dina_givens,
        output logic [31 : 0] douta_givens,
        input logic ena_rotation,
        input logic wea_rotation,
        input logic [1 : 0] addra_rotation,
        input logic [31 : 0] dina_rotation,
        output logic [31 : 0] douta_rotation
    );
    
    // Instantiate the BRAM of the Givens matrix
    
    bram_givens GIVENS_MATRIX (
      .clka(clk),    // input wire clka
      .ena(ena_givens),      // input wire ena
      .wea(wea_givens),      // input wire [0 : 0] wea
      .addra(addra_givens),  // input wire [1 : 0] addra
      .dina(dina_givens),    // input wire [31 : 0] dina
      .douta(douta_givens),  // output wire [31 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(ena_rotation),      // input wire enb
      .web(wea_rotation),      // input wire [0 : 0] web
      .addrb(addra_rotation),  // input wire [1 : 0] addrb
      .dinb(dina_rotation),    // input wire [31 : 0] dinb
      .doutb(douta_rotation)  // output wire [31 : 0] doutb
    );
    

endmodule


