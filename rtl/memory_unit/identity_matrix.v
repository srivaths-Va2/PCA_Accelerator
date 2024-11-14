`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 12.11.2024 21:47:38
// Design Name: memory_unit/identity_matrix
// Module Name: identity_matrix
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: To store the identity matrix for SVD. Uses SISO buffers to efficiently reduce resource utilization
// 
// Dependencies: memory_unit/shift_reg.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module identity_matrix(
    input clk,
    input rst,
    output I_00, output I_01, output I_02, output I_03,
    output I_10, output I_11, output I_12, output I_13,
    output I_20, output I_21, output I_22, output I_23,
    output I_30, output I_31, output I_32, output I_33
    );
   
    reg [31:0] identity [0:3][0:3];
    
    // define the shift registers
    shift_register S00(clk, rst, identity[0][0], I_00);
    shift_register S01(clk, rst, identity[0][1], I_01);
    shift_register S02(clk, rst, identity[0][2], I_02);
    shift_register S03(clk, rst, identity[0][3], I_03);
    shift_register S10(clk, rst, identity[1][0], I_10);
    shift_register S11(clk, rst, identity[1][1], I_11);
    shift_register S12(clk, rst, identity[1][2], I_12);
    shift_register S13(clk, rst, identity[1][3], I_13);
    shift_register S20(clk, rst, identity[2][0], I_20);
    shift_register S21(clk, rst, identity[2][1], I_21);
    shift_register S22(clk, rst, identity[2][2], I_22);
    shift_register S23(clk, rst, identity[2][3], I_23);
    shift_register S30(clk, rst, identity[3][0], I_30);
    shift_register S31(clk, rst, identity[3][1], I_31);
    shift_register S32(clk, rst, identity[3][2], I_32);
    shift_register S33(clk, rst, identity[3][3], I_33);
    
    // main loop
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                begin
                    // reset the identity matrix
                    identity[0][0] <= 32'b0; identity[0][1] <= 32'b0; identity[0][2] <= 32'b0; identity[0][3] <= 32'b0;
                    identity[1][0] <= 32'b0; identity[1][1] <= 32'b0; identity[1][2] <= 32'b0; identity[1][3] <= 32'b0;
                    identity[2][0] <= 32'b0; identity[2][1] <= 32'b0; identity[2][2] <= 32'b0; identity[2][3] <= 32'b0;
                    identity[3][0] <= 32'b0; identity[3][1] <= 32'b0; identity[3][2] <= 32'b0; identity[3][3] <= 32'b0;
                end
            
            else if(rst == 1'b0)
                begin
                    // reset the identity matrix
                    identity[0][0] <= 32'b1; identity[0][1] <= 32'b0; identity[0][2] <= 32'b0; identity[0][3] <= 32'b0;
                    identity[1][0] <= 32'b0; identity[1][1] <= 32'b1; identity[1][2] <= 32'b0; identity[1][3] <= 32'b0;
                    identity[2][0] <= 32'b0; identity[2][1] <= 32'b0; identity[2][2] <= 32'b1; identity[2][3] <= 32'b0;
                    identity[3][0] <= 32'b0; identity[3][1] <= 32'b0; identity[3][2] <= 32'b0; identity[3][3] <= 32'b1;
                end
            
        end  
    
endmodule
