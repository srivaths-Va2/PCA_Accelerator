`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 17.11.2024 19:30:12
// Design Name: 
// Module Name: math_unit/processing_element
// Project Name: processing_element
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: To perform MAC operation
// 
// Dependencies: NA
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processing_element(
    input clk,
    input rst,
    input [7:0] in1,
    input [7:0] in2,
    output reg [15:0] psum, 
    output reg [7:0] out1
    );
    
    /*
    ALGORITHM
    1) If reset is enabled, then the psum output will be 0
    2) If reset is disabled, then the psum is calculated
    3) The processing element takes in 2 inputs. It multiplies both and stores the result in psum
    4) It also passes the output (in2) through for the next PE
    */
    
    reg [15:0] product;
    
    always @(negedge rst) 
    begin
        if (rst == 1'b0) 
        begin
            psum <= 16'd0;  // Reset psum to 0 when reset is asserted
        end
    end 
    
    always @(posedge clk) 
    begin
        if (rst == 1'b1) 
        begin
            // Perform multiplication and accumulate in psum
            product = in1 * in2; 
            psum <= psum + product;
        end
        // Pass through in2 for the next PE
        out1 <= in2;
    end
    
    /*
    always@(posedge clk or posedge rst) 
        begin
            if (rst == 1'b1) 
                begin
                    psum <= 16'd0; 
                end 
            else
                // Perform MAC
                begin
                    product = in1 * in2; 
                    psum <= psum + product; 
                end
        
        // Pass through in2 for the next PE
        out1 <= in2;
    end
    */
endmodule

