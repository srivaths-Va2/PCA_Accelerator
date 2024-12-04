`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 04.12.2024 22:47:02
// Design Name: 
// Module Name: covariance_unit/systolic_array
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: the control unit for the systolic array
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolic_array_control_unit#(
    parameter MAX_CLK = 4,
    parameter N = 2
    )(
    input clk,
    input rst,
    input start,
    output reg pe_rst,
    output reg pe_enable,
    output reg [1:0] current_row,
    output reg [1:0] current_col,
    output reg done
    );
    
    /*
    The systolic array comprises of a control unit. The control unit will synchronize the operations of the datapath
    we have the signals at the output
    1) pe_rst --> resets the processing elements
    2) pe_enable --> enables the processing elements
    3) row_select --> selects the corresponding row of the systolic array
    4) col_select --> selects the corresponding column of the systolic array
    5) done --> once multiplication is done, then, the output signal "done", is triggered
    
    For a 4x4 systolic array, it would take 16 clock cycles to compute the output
    
    */
    
    // intermediate states
    parameter IDLE = 2'b00;
    parameter RST = 2'b01;
    parameter COMPUTE = 2'b10;
    parameter FINISH = 2'b11;
    
    reg[1:0] state, next_state;
    
    reg[3:0] cycle_count;
    
    // present and next state transitions
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                state <= IDLE;
            else
                state <= next_state;
        end
    
    // logic for cycle counter
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                begin
                    cycle_count <= 4'd0;
                end
            else if(state == COMPUTE)
                begin
                    cycle_count <= cycle_count + 1;
                end
            else if(cycle_count == MAX_CLK)
                begin
                    cycle_count <= 4'd0;
                end
        end
    
    // logic for row and column selection
    always@(posedge clk or posedge rst)
        begin
            if(rst == 1'b1)
                begin
                    current_row <= 2'd0;
                    current_col <= 2'd0;
                end
            
            else if(state == COMPUTE)
                begin
                    current_row <= (cycle_count % N);
                    current_col <= (cycle_count / N);
                end
            else
                begin
                    current_row <= 2'd0;
                    current_col <= 2'd0;
                end
        end    
        
    // intermediate state generation
    always@(*)
        begin
            pe_rst = 1'b0;
            pe_enable = 1'b0;
            done = 1'b0;
            next_state = state;
                
            case(state)
                    IDLE : begin
                        if(start)
                            next_state = RST;
                        end
                        
                    RST : begin
                        pe_rst = 1'b1;
                        next_state = COMPUTE;
                    end
                        
                    COMPUTE : begin
                        pe_enable = 1'b1;    
                        if(cycle_count == MAX_CLK - 1)
                            next_state = FINISH;
                    end
                        
                    FINISH : begin
                        done = 1'b1;
                        next_state = IDLE;
                    end
                        
                    default : begin
                        next_state = IDLE;
                    end

            endcase
        end

endmodule
