`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
//
// Create Date: 23.01.2025 20:21:23
// Design Name: controller_givensmatrix
// Module Name: controller_givensmatrix
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The controller is responsible to write the output from the CORDIC engine to the correct locations
// of the Givens rotation matrix, in order to make it ready for rotations
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: controller_givensmatrix

    Description:
    This module implements a controller for a Givens rotation matrix. It processes
    input signals `p` and `q` to determine the appropriate Givens rotation matrix
    elements using the provided cosine (`cos_data`) and sine (`sin_data`) values.
    The module outputs control signals and data for enabling, writing, and addressing
    the Givens matrix.

    Inputs:
    - clk: Clock signal.
    - p: 2-bit input to select the row of the matrix.
    - q: 2-bit input to select the column of the matrix.
    - cos_data: 8-bit cosine data input.
    - sin_data: 8-bit sine data input.

    Outputs:
    - ena_givens: Enable signal for the Givens matrix.
    - wea_givens: Write enable signal for the Givens matrix.
    - addra_givens: 2-bit address for the Givens matrix.
    - dina_givens: 32-bit data input for the Givens matrix.
*/

module controller_givensmatrix(
        input logic clk,
        input logic [1 : 0] p,
        input logic [1 : 0] q,
        input logic [7 : 0] cos_data,
        input logic [7 : 0] sin_data,
        output logic ena_givens,
        output logic wea_givens,
        output logic [1 : 0] addra_givens,
        output logic [31 : 0] dina_givens  
    );
    
    always@(posedge clk)
        begin   
            case({p, q})
                // case when p = 0 and q is varying
                4'b00_01 : begin
                        ena_givens <= 1'b1;
                        wea_givens <= 1'b1;
                        addra_givens <= 2'b00;
                        dina_givens <= {cos_data, sin_data, 8'b0000_0000, 8'b0000_0000};
                        addra_givens <= 2'b01;
                        dina_givens <= {(-1 * sin_data), cos_data, 8'b0000_0000, 8'b0000_0000};
                    end
                4'b00_10 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b00;
                    dina_givens <= {cos_data, 8'b0000_0000, sin_data, 8'b0000_0000};
                    addra_givens <= 2'b10;
                    dina_givens <= {(-1 * sin_data), 8'b0000_0000, cos_data, 8'b0000_0000};
                end
                4'b00_11 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b00;
                    dina_givens <= {cos_data, 8'b0000_0000, 8'b0000_0000, sin_data};
                    addra_givens <= 2'b11;
                    dina_givens <= {(-1 * sin_data), 8'b0000_0000, 8'b0000_0000, cos_data};
                end
                
                // case when p = 1 and q is varying
                4'b01_00 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b01;
                    dina_givens <= {sin_data, cos_data, 8'b0000_0000, 8'b0000_0000};
                    addra_givens <= 2'b00;
                    dina_givens <= {cos_data, (-1 * sin_data), 8'b0000_0000, 8'b0000_0000};
                end
                4'b01_10 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b01;
                    dina_givens <= {8'b0000_0000, cos_data, sin_data, 8'b0000_0000};
                    addra_givens <= 2'b10;
                    dina_givens <= {8'b0000_0000, (-1 * sin_data), cos_data, 8'b0000_0000};
                end
                4'b01_11 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b01;
                    dina_givens <= {8'b0000_0000, cos_data, 8'b0000_0000, sin_data};
                    addra_givens <= 2'b11;
                    dina_givens <= {8'b0000_0000, (-1 * sin_data), 8'b0000_0000, cos_data};
                end
                
                // case when p = 2 and q is varying
                4'b10_00 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b10;
                    dina_givens <= {sin_data, 8'b0000_0000, cos_data, 8'b0000_0000};
                    addra_givens <= 2'b00;
                    dina_givens <= {cos_data, 8'b0000_0000, (-1 * sin_data), 8'b0000_0000};
                end
                4'b10_01 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b10;
                    dina_givens <= {8'b0000_0000, sin_data, cos_data, 8'b0000_0000};
                    addra_givens <= 2'b01;
                    dina_givens <= {8'b0000_0000, cos_data, (-1 * sin_data), 8'b0000_0000};
                end
                4'b10_11 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b10;
                    dina_givens <= {8'b0000_0000, 8'b0000_0000, cos_data, sin_data};
                    addra_givens <= 2'b11;
                    dina_givens <= {8'b0000_0000, 8'b0000_0000, (-1 * sin_data), cos_data};
                end
                
                // case when p = 3 and q is varying
                4'b11_00 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b11;
                    dina_givens <= {8'b0000_0000, 8'b0000_0000, sin_data, cos_data};
                    addra_givens <= 2'b00;
                    dina_givens <= {8'b0000_0000, 8'b0000_0000, cos_data, (-1 * sin_data)};
                end
                4'b11_01 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b11;
                    dina_givens <= {8'b0000_0000, sin_data, 8'b0000_0000, cos_data};
                    addra_givens <= 2'b01;
                    dina_givens <= {8'b0000_0000, cos_data, 8'b0000_0000, (-1 * sin_data)};
                end
                4'b11_10 : begin
                    ena_givens <= 1'b1;
                    wea_givens <= 1'b1;
                    addra_givens <= 2'b11;
                    dina_givens <= {8'b0000_0000, 8'b0000_0000, sin_data, cos_data};
                    addra_givens <= 2'b10;
                    dina_givens <= {8'b0000_0000, 8'b0000_0000, cos_data, (-1 * sin_data)};
                end
            endcase
        end
    
endmodule

