`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 23.01.2025 20:09:34
// Design Name: matrix_vector_converter
// Module Name: flattened_array_converter
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The Matrix to Vector Converter (MVC) is a module that would create a large vector from all the rows of the BRAM. 
// It repeatedly reads off memory and appends rows one behind the other, to create the vector 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Module: flattened_array_converter

    Description:
    This module converts a 4x4 matrix of data from the Givens BRAM into a flattened array.
    It operates as a state machine with six states, reading each row of the matrix and 
    combining them into a single output array. The conversion process is controlled by 
    an enable signal and a clock, and it outputs a 'done' signal upon completion.

    Parameters:
    - MATRIX_SIZE: Size of the matrix (default is 4).
    - DATA_WIDTH: Width of each data element (default is 8 bits).

    Inputs:
    - clk: Clock signal.
    - rst: Reset signal.
    - ena_flattened_array_controller: Enable signal for the controller.
    - data_from_givens: 32-bit input data from the Givens BRAM.

    Outputs:
    - ena_givens: Enable signal for the Givens BRAM.
    - wea_givens: Write enable signal for the Givens BRAM.
    - addra_givens: Address signal for the Givens BRAM.
    - flattened_array: Output flattened array of the matrix.
    - done_flattened_array_conv: Signal indicating completion of the conversion.
*/

module flattened_array_converter#(parameter MATRIX_SIZE = 4, parameter DATA_WIDTH=8)(
    input logic clk,
    input logic rst,
    input logic ena_flattened_array_controller,
    input logic [31 : 0] data_from_givens,
    output logic ena_givens,
    output logic wea_givens,
    output logic [1 : 0] addra_givens,
    output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array,
    output logic done_flattened_array_conv 
    );
    
    logic [31 : 0] givens_row_0;
    logic [31 : 0] givens_row_1;
    logic [31 : 0] givens_row_2;
    logic [31 : 0] givens_row_3;
    
    // Assign the state machine states
    parameter [2 : 0] S0 = 3'b000;
    parameter [2 : 0] S1 = 3'b001;
    parameter [2 : 0] S2 = 3'b010;
    parameter [2 : 0] S3 = 3'b011;
    parameter [2 : 0] S4 = 3'b100;
    parameter [2 : 0] S5 = 3'b101;
    
    reg[2 : 0] PS, NS;
    
    // next state logic
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                PS <= S0;
            
            else if(ena_flattened_array_controller == 1'b0)
                PS <= S0;
            
            else if(ena_flattened_array_controller == 1'b1)
                PS <= NS;
        end
    
    always@(PS)
        //if(ena_flattened_array_controller == 1'b1)
            begin
                case(PS)
                    // Initialisation state
                    S0 : begin
                        flattened_array <= 0;
                        done_flattened_array_conv <= 0;
                        NS <= S1;
                    end
                    
                    // Read the first row of the Givens BRAM
                    S1 : begin
                        ena_givens <= 1'b1;
                        wea_givens <= 1'b0;
                        addra_givens <= 2'b00;
                        givens_row_0 <= data_from_givens;
                        done_flattened_array_conv <= 0;
                        NS <= S2;
                    end
                    
                    // Read the second row of the Givens BRAM
                    S2 : begin
                        ena_givens <= 1'b1;
                        wea_givens <= 1'b0;
                        addra_givens <= 2'b01;
                        givens_row_1 <= data_from_givens;
                        done_flattened_array_conv <= 0;
                        NS <= S3;
                    end
                    
                    // Read the third row of the Givens BRAM
                    S3 : begin
                        ena_givens <= 1'b1;
                        wea_givens <= 1'b0;
                        addra_givens <= 2'b10;
                        givens_row_2 <= data_from_givens;
                        done_flattened_array_conv <= 0;
                        NS <= S4;
                    end
                    
                    // Read the fourth row of the Givens BRAM
                    S4 : begin
                        ena_givens <= 1'b1;
                        wea_givens <= 1'b0;
                        addra_givens <= 2'b11;
                        givens_row_3 <= data_from_givens;
                        done_flattened_array_conv <= 0;
                        NS <= S5;
                    end
                    
                    // Combine all rows
                    S5 : begin
                        flattened_array <= {givens_row_0, givens_row_1, givens_row_2, givens_row_3};
                        done_flattened_array_conv <= 1;
                        NS <= S1;
                    end
                    
                endcase 
           end 
    
endmodule

