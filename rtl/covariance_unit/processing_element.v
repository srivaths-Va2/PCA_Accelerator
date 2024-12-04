`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 04.12.2024 22:12:26
// Design Name: 
// Module Name: covariance_unit/processing_element
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: To perform MAC operation
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processing_element#(
    parameter DATA_WIDTH = 8
    )
    (   
        input clk,
        input rst,
        input[DATA_WIDTH - 1 : 0] a_in,
        input[DATA_WIDTH - 1 : 0] b_in,
        input[2 * DATA_WIDTH - 1 : 0] psum_in,
        output reg[DATA_WIDTH - 1 : 0] a_out,
        output reg[DATA_WIDTH - 1 : 0] b_out,
        output reg[2 * DATA_WIDTH - 1 : 0] psum_out
    );
    
    // internal product register
    reg[2 * DATA_WIDTH - 1 : 0] product;
    
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                begin
                    a_out <= 0;
                    b_out <= 0;
                    psum_out <= 0;
                    product <= 0;
                end
            
            else
                begin
                    product <= a_in * b_in;
                    psum_out <= psum_in + product;
                    
                    a_out <= a_in;
                    b_out <= b_in;
                end
        end

endmodule
