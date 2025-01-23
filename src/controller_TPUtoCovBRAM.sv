`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 16.01.2025 11:51:55
// Design Name: controller
// Module Name: controller_TPUtoBRAM
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This is the FSM that controls the operations of the accelerator. 
// At the moment, it controls the read and write of data output from the TPU to the intermediate BRAM that
// stores the covariance matrix
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: controller_TPUtoBRAM

    Description:
    This module manages the data transfer from a TPU to a BRAM. It operates as a finite 
    state machine with states to initialize, wait for TPU completion, and sequentially 
    write data to BRAM. The module slices the input data from the TPU into four segments 
    and writes each segment to a different address in the BRAM.

    Inputs:
    - clk: Clock signal.
    - rst: Reset signal.
    - data_from_TPU: Array of sixteen 8-bit data inputs from the TPU.
    - done: Signal indicating TPU computation completion.

    Outputs:
    - ena: Enable signal for BRAM.
    - wea: Write enable signal for BRAM.
    - addra: Address signal for BRAM.
    - dina: Data input to BRAM.
    - done_writing: Signal indicating completion of writing to BRAM.
*/

module controller_TPUtoBRAM
(
    input clk,
    input rst,
    input[7:0] data_from_TPU[15:0],
    input done,     // from the TPU
    output reg ena,     // enable signal to BRAM
    output reg wea,     // write activate signal to BRAM
    output reg [1 : 0] addra,      // address to BRAM
    output reg [31:0] dina,
    output reg done_writing         // signifies that writing is complete
);

reg [2:0] PS, NS;

parameter [2:0] S0 = 3'b000;
parameter [2:0] S1 = 3'b001;
parameter [2:0] S2 = 3'b010;
parameter [2:0] S3 = 3'b011;
parameter [2:0] S4 = 3'b100;
parameter [2:0] S5 = 3'b101;
parameter [2:0] S6 = 3'b110;

// PS and NS logic
always@(posedge clk or posedge rst)
    begin
        if(rst == 1'b1)
            PS <= S0;
        else if(rst == 1'b0)
            PS <= NS;
    end


always@(PS, done)
    begin
        case(PS)
            // The state of the machine for initiatilization
            S0 : begin
                wea <= 0;
                ena <= 0;
                done_writing <= 0;
                // next state logic
                NS <= (done) ? S1 : S0;
            end
            
            // The state of the machine when done signal of TPU is 1, ie - TPU is done computing
            S1 : begin
                    wea <= 0;
                    ena <= 0;
                    done_writing <= 0;
                    NS <= S2;
            end
            
            // The state when we can start writing to the BRAM
            S2 : begin
                wea <= 1'b1;
                ena <= 1'b1;
                done_writing <= 0;
                NS <= S3;
            end
            
            // The state when we slice the logic and write to the zero location
            S3 : begin
                wea <= 1'b1;
                ena <= 1'b1;
                done_writing <= 0;
                addra <= 2'b00;
                dina <= {data_from_TPU[3], data_from_TPU[2], data_from_TPU[1], data_from_TPU[0]};
                NS <= S4;
            end
            
            // The state when we slice the logic and write to the first location
            S4 : begin
                wea <= 1'b1;
                ena <= 1'b1;
                done_writing <= 0;
                addra <= 2'b01;
                dina <= {data_from_TPU[7], data_from_TPU[6], data_from_TPU[5], data_from_TPU[4]};
                NS <= S5;
            end
            
            // The state when we slice the logic and write to the second location
            S5 : begin
                wea <= 1'b1;
                ena <= 1'b1;
                done_writing <= 0;
                addra <= 2'b10;
                dina <= {data_from_TPU[11], data_from_TPU[10], data_from_TPU[9], data_from_TPU[8]};
                NS <= S6;
            end
            
            // The state when we slice the logic and write to the third location
            S6 : begin
                wea <= 1'b1;
                ena <= 1'b1;
                done_writing <= 1;
                addra <= 2'b11;
                dina <= {data_from_TPU[15], data_from_TPU[14], data_from_TPU[13], data_from_TPU[12]};
                NS <= S0;
            end
            
            default : begin
                wea <= 1'b0;
                ena <= 1'b0;
                done_writing <= 1'b0;
                addra <= 2'b00;
                NS <= S0;
            end
            
        endcase
    end

endmodule