`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 12.11.2024 22:42:55
// Design Name: memory_unit/shift_register
// Module Name: shift_register
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: A SISO buffer
// 
// Dependencies: NA
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_register(
    input clk,
    input rst,
    input in,
    output reg out
    );
    
    reg [31:0] shift_reg;  // 32-bit internal shift register

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            shift_reg <= 32'b0;  // Reset the shift register to 0
            out <= 1'b0;         // Reset the output to 0
        end else begin
            shift_reg <= {shift_reg[30:0], in};  // Shift left and insert 'in' at LSB
            out <= shift_reg[0];                 // Output the LSB after each shift
        end
    end
endmodule


