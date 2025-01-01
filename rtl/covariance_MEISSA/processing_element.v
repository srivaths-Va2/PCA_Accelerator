`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 01.01.2025 20:22:21
// Design Name: covariance_MEISSA/processing_element.v
// Module Name: processing_element
// Project Name: PCA_Accelerator 
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: The processing element within the MEISSA array
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processing_element#(
    parameter DATA_WIDTH=8
    )
    (
    input clk,
    input rst,
    input[2:0] mode,            // state machine states
    input[DATA_WIDTH - 1 : 0] input_west,
    input[DATA_WIDTH - 1 : 0] input_north,
    output reg [DATA_WIDTH - 1 : 0] output_east,
    output reg [DATA_WIDTH - 1 : 0] output_south,
    output reg [2 * DATA_WIDTH - 1 : 0] cell_product
    );
    
    // In MEISSA, the units are simple Multipliers and not MACs. There is not any addition, but only multiplication
    // All inputs can arrive aimultaneously
    // The operations would be forwarded to the adder tree, which would compute the final matrix product
    
    /*
    State Machine States for MEISSA multiplier
    1) 3'b000 -> Initial
    2) 3'b001 -> Load
    3) 3'b010 -> Process and Load
    4) 3'b011 -> Out and Process
    5) 3'b100 -> Out
    */
    
    always@(posedge clk or negedge rst)
        begin
            if(rst == 1'b0)
                begin
                    output_east <= 0;
                    output_south <= 0;
                    cell_product <= 0;
                end
            
            else
                begin
                    // pass inputs to outputs
                    output_east <= input_west;
                    output_south <= input_north;
                    // multiply the inputs to generate product of cell
                    cell_product <= input_west * input_north;
                end
        end
    
endmodule
