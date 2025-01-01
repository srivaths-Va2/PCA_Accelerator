`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 01.01.2025 20:58:44
// Design Name: covariance_MEISSA/systolic_meissa.v
// Module Name: systolic_meissa
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: Implements MEISSA based Systolic array
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolic_meissa#(
    parameter DATA_WIDTH = 8,
    parameter MATRIX_SIZE = 4 // (2x2)
    )(
        input clk,
        input rst,
        input [(MATRIX_SIZE * DATA_WIDTH) - 1 : 0] A,
        input [(MATRIX_SIZE * DATA_WIDTH) - 1 : 0] B,
        input[2 : 0] mode,
        output reg [(2 * MATRIX_SIZE * DATA_WIDTH) - 1 : 0] product,
        output reg done
    );
    
    /*
    always@(negedge rst)
        begin   
            if(rst == 1'b0)
                begin
                    product <= 0;
                end
        end
    */
    
    /*
    State Machine States for MEISSA multiplier
    1) 3'b000 -> Initial
    2) 3'b001 -> Load
    3) 3'b010 -> Process and Load
    4) 3'b011 -> Out and Process - 1
    5) 3'b100 -> Out and Process - 2
    6) 3'b101 -> Out
    */
    
    // defining the processing elements and data signals into them
    reg [DATA_WIDTH - 1 : 0] west_00, west_01, west_10, west_11;
    reg [DATA_WIDTH - 1 : 0] north_00, north_01, north_10, north_11;
    wire [DATA_WIDTH - 1 : 0] east_00, east_01, east_10, east_11;
    wire [DATA_WIDTH - 1 : 0] south_00, south_01, south_10, south_11;
    wire [2*DATA_WIDTH - 1 : 0] cell_product_00, cell_product_01, cell_product_10, cell_product_11;
    
    processing_element #(DATA_WIDTH)PE_00(clk, rst, west_00, north_00, east_00, south_00, cell_product_00);
    processing_element #(DATA_WIDTH)PE_01(clk, rst, west_01, north_01, east_01, south_01, cell_product_01);
    processing_element #(DATA_WIDTH)PE_10(clk, rst, west_10, north_10, east_10, south_10, cell_product_10);
    processing_element #(DATA_WIDTH)PE_11(clk, rst, west_11, north_11, east_11, south_11, cell_product_11);
    
    // Initialising the two adder trees
    reg [2 * DATA_WIDTH - 1 : 0] op_11, op_12;
    reg [2 * DATA_WIDTH - 1 : 0] op_21, op_22;
    
    wire [2 * DATA_WIDTH - 1 : 0] sum_1;
    wire [2 * DATA_WIDTH - 1 : 0] sum_2;
    
    adder_tree #(DATA_WIDTH) ADDER_TREE_0(op_11, op_12, sum_1);
    adder_tree #(DATA_WIDTH) ADDER_TREE_1(op_21, op_22, sum_2);
    
    always@(posedge clk or negedge rst)
        begin
            if(!rst)
                begin
                    west_00 <= 0;
                    west_01 <= 0;
                    west_10 <= 0;
                    west_11 <= 0;
                    north_00 <= 0;
                    north_01 <= 0;
                    north_10 <= 0;
                    north_11 <= 0;
                    op_11 <= 0;
                    op_12 <= 0;
                    op_21 <= 0;
                    op_22 <= 0;
                    product <= 0;
                    done <= 1'b0;
                end
            else begin
            case(mode)
                // Initial state
                3'b000 : begin
                    west_00 <= 0;
                    west_01 <= 0;
                    west_10 <= 0;
                    west_11 <= 0;
                    north_00 <= 0;
                    north_01 <= 0;
                    north_10 <= 0;
                    north_11 <= 0;
                    
                    done <= 1'b0;
                end
                
                // Load State
                3'b001 : begin
                    west_00 <= 0;
                    west_01 <= 0;
                    west_10 <= 0;
                    west_11 <= 0;
                    north_00 <= B[23:16];
                    north_01 <= B[31:24];
                    north_10 <= 0;
                    north_11 <= 0;
                    
                    done <= 1'b0;
                end
                
                // Process and Load State
                3'b010 : begin
                    west_00 <= A[7:0];
                    west_01 <= 0;
                    west_10 <= A[15:8];
                    west_11 <= 0;
                    north_00 <= B[7:0];
                    north_01 <= B[15:8];
                    north_10 <= B[23:16];
                    north_11 <= 0;
                    
                    // adder tree signals
                    op_11 <= cell_product_00;
                    op_12 <= cell_product_10;
                    // The result of the adder tree is c11
                    product[(2 * DATA_WIDTH) - 1 : 0] <= sum_1;
                    
                    done <= 1'b0;
                end
                
                // Out and Process States - 1
                3'b011 : begin
                    west_00 <= A[23:16];
                    west_01 <= A[7:0];
                    west_10 <= A[31:24];
                    west_11 <= A[15:8];
                    north_00 <= B[7:0];
                    north_01 <= B[15:8];
                    north_10 <= B[23:16];
                    north_11 <= B[31:24];
                    
                    // adder tree signals
                    op_11 <= cell_product_00;
                    op_12 <= cell_product_10;
                    op_21 <= cell_product_01;
                    op_22 <= cell_product_11;
                    // The result of the adder tree is c11
                    product[(6 * DATA_WIDTH) - 1 : 0] <= sum_1;
                    product[(4 * DATA_WIDTH) - 1 : 0] <= sum_2;
                    
                    done <= 1'b0;
                end
                
                // Out and Process States - 2
                3'b100 : begin
                    west_00 <= 0;
                    west_01 <= A[23:16];
                    west_10 <= 0;
                    west_11 <= A[31:24];
                    north_00 <= 0;
                    north_01 <= B[15:8];
                    north_10 <= 0;
                    north_11 <= B[31:24];
                    
                    // adder tree signals
                    op_21 <= cell_product_01;
                    op_22 <= cell_product_11;
                    // The result of the adder tree is c11
                    product[(8 * DATA_WIDTH) - 1 : 0] <= sum_2;
                    
                    done <= 1'b0;
                end
                
                // Out State
                3'b101 : begin
                    done <= 1'b1;
                end
            endcase
            
        end
     end
    
endmodule
