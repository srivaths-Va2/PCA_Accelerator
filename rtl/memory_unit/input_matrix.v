`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 14.11.2024 22:43:33
// Design Name: memory_unit/input_matrix.v
// Module Name: input_matrix
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: To store the input matrix for which SVD has to be computed
// 
// Dependencies: memory_unit/shift_register.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module input_matrix(
    input clk,
    input rst,
    input[31:0] S_00, input[31:0] S_01, input[31:0] S_02, input[31:0] S_03,
    input[31:0] S_10, input[31:0] S_11, input[31:0] S_12, input[31:0] S_13,
    input[31:0] S_20, input[31:0] S_21, input[31:0] S_22, input[31:0] S_23,
    input[31:0] S_30, input[31:0] S_31, input[31:0] S_32, input[31:0] S_33,
    output out_00, output out_01, output out_02, output out_03,
    output out_10, output out_11, output out_12, output out_13,
    output out_20, output out_21, output out_22, output out_23,
    output out_30, output out_31, output out_32, output out_33
    );
    
    reg [31:0] input_matrix[0:3][0:3];
    
    // define the shift registers
    shift_register S00(clk, rst, input_matrix[0][0], out_00);
    shift_register S01(clk, rst, input_matrix[0][1], out_01);
    shift_register S02(clk, rst, input_matrix[0][2], out_02);
    shift_register S03(clk, rst, input_matrix[0][3], out_03);
    shift_register S10(clk, rst, input_matrix[1][0], out_10);
    shift_register S11(clk, rst, input_matrix[1][1], out_11);
    shift_register S12(clk, rst, input_matrix[1][2], out_12);
    shift_register S13(clk, rst, input_matrix[1][3], out_13);
    shift_register S20(clk, rst, input_matrix[2][0], out_20);
    shift_register S21(clk, rst, input_matrix[2][1], out_21);
    shift_register S22(clk, rst, input_matrix[2][2], out_22);
    shift_register S23(clk, rst, input_matrix[2][3], out_23);
    shift_register S30(clk, rst, input_matrix[3][0], out_30);
    shift_register S31(clk, rst, input_matrix[3][1], out_31);
    shift_register S32(clk, rst, input_matrix[3][2], out_32);
    shift_register S33(clk, rst, input_matrix[3][3], out_33);
    
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                begin
                    // reset the matrix to 0
                    input_matrix[0][0] <= 32'b0; input_matrix[0][1] <= 32'b0; input_matrix[0][2] <= 32'b0; input_matrix[0][3] <= 32'b0;
                    input_matrix[1][0] <= 32'b0; input_matrix[1][1] <= 32'b0; input_matrix[1][2] <= 32'b0; input_matrix[1][3] <= 32'b0;
                    input_matrix[2][0] <= 32'b0; input_matrix[2][1] <= 32'b0; input_matrix[2][2] <= 32'b0; input_matrix[2][3] <= 32'b0;
                    input_matrix[3][0] <= 32'b0; input_matrix[3][1] <= 32'b0; input_matrix[3][2] <= 32'b0; input_matrix[3][3] <= 32'b0;
                end
            
            else if(rst == 1'b0)
                begin
                    // set the matrix to input value
                    input_matrix[0][0] <= S_00; input_matrix[0][1] <= S_01; input_matrix[0][2] <= S_02; input_matrix[0][3] <= S_03;
                    input_matrix[1][0] <= S_10; input_matrix[1][1] <= S_11; input_matrix[1][2] <= S_12; input_matrix[1][3] <= S_13;
                    input_matrix[2][0] <= S_20; input_matrix[2][1] <= S_21; input_matrix[2][2] <= S_22; input_matrix[2][3] <= S_23;
                    input_matrix[3][0] <= S_33; input_matrix[3][1] <= S_32; input_matrix[3][2] <= S_31; input_matrix[3][3] <= S_30;
                end
        end
    
endmodule
