`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:09:34
// Design Name: Matrix Padding Unit (MPU)
// Module Name: template_engine_A
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The Matrix Padding Unit would dispatch and schedule input rows to the TPU for matrix multiplication
// It helps to automate the dispatch of rows to the TPU. The MPU also pads zeros at the correct places to ensure that
// the products are computed correctly in the systolic array
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: template_engine_A

    Description:
    This module implements a state machine to process a flattened matrix input
    and generate a 2D array output for a TPU (Tensor Processing Unit). The module
    operates over a series of states (S0 to S9) to sequentially populate the TPU_inarray
    output with segments of the input data. The 'done_templateA' signal indicates
    the completion of the processing cycle.

    Parameters:
    - MATRIX_SIZE: The size of the matrix (default is 4).
    - DATA_WIDTH: The width of the data elements (default is 8).

    Inputs:
    - clk: Clock signal.
    - rst: Reset signal.
    - flattened_array_input: A flattened array input of size MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH.

    Outputs:
    - TPU_inarray: A 2D array output for the TPU, with each element having DATA_WIDTH bits.
    - done_templateA: A signal indicating the completion of the template processing.
*/


module template_engine_A#(parameter MATRIX_SIZE = 4, DATA_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic[MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_input,
    output logic [DATA_WIDTH-1:0] TPU_inarray [MATRIX_SIZE-1:0], 
    output logic done_templateA
    );
    
    // Assign the state machine states
    parameter [3 : 0] S0 = 4'b0000;
    parameter [3 : 0] S1 = 4'b0001;
    parameter [3 : 0] S2 = 4'b0010;
    parameter [3 : 0] S3 = 4'b0011;
    parameter [3 : 0] S4 = 4'b0100;
    parameter [3 : 0] S5 = 4'b0101;
    parameter [3 : 0] S6 = 4'b0110;
    parameter [3 : 0] S7 = 4'b0111;
    parameter [3 : 0] S8 = 4'b1000;
    parameter [3 : 0] S9 = 4'b1001;
    
    reg[2 : 0] PS, NS;
    
    // next state logic
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                PS <= S0;
            else
                PS <= NS;
        end
    
    always@(PS)
        begin
            case(PS)
                // Initialisation state - send all zeros
                S0 : begin
                    TPU_inarray <= {8'h00, 8'h00, 8'h00, 8'h00};
                    done_templateA <= 1'b0;
                    NS <= S1;
                end
                
                // state S1
                S1 : begin
                    TPU_inarray <= {flattened_array_input[127 : 120], 8'h00, 8'h00, 8'h00};
                    done_templateA <= 1'b0;
                    NS <= S2;
                end
                
                // state S2
                S2 : begin
                    TPU_inarray <= {flattened_array_input[119:112], flattened_array_input[95:88], 8'h00, 8'h00};
                    done_templateA <= 1'b0;
                    NS <= S3;
                end
                
                // state S3
                S3 : begin
                    TPU_inarray <= {flattened_array_input[111:104], flattened_array_input[87:80], flattened_array_input[63:56], 8'h00};
                    done_templateA <= 1'b0;
                    NS <= S4;
                end
                
                // state S4
                S4 : begin
                    TPU_inarray <= {flattened_array_input[103:96], flattened_array_input[79:72], flattened_array_input[55:48], flattened_array_input[31:24]};
                    done_templateA <= 1'b0;
                    NS <= S5;
                end
                
                // state S5
                S5 : begin
                    TPU_inarray <= {8'h00, flattened_array_input[71:64], flattened_array_input[47:40], flattened_array_input[23:16]};
                    done_templateA <= 1'b0;
                    NS <= S6;
                end
                
                // state S6
                S6 : begin
                    TPU_inarray <= {8'h00, 8'h00, flattened_array_input[39:32], flattened_array_input[15:8]};
                    done_templateA <= 1'b0;
                    NS <= S7;
                end
                
                // state S7
                S7 : begin
                    TPU_inarray <= {8'h00, 8'h00, 8'h00, flattened_array_input[7:0]};
                    done_templateA <= 1'b0;
                    NS <= S8;
                end
                
                // state S8
                S8 : begin
                    TPU_inarray <= {8'h00, 8'h00, 8'h00, 8'h00};
                    done_templateA <= 1'b1;
                    NS <= S9;
                end
                
                // state S9
                S9 : begin
                    done_templateA <= 1'b1;
                    NS <= S0;
                end
                
            endcase
        end
    
endmodule

