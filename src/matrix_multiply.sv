`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 17.01.2025 13:31:51
// Design Name: Systolic Array - Google's TPU
// Module Name: matrix_multiply
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: This module computes the matrix multiplication of input matrices A and B 
// 
// Dependencies: mac.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/*
  Module: matrix_multiply

  This module performs matrix multiplication on two input matrices `in_a` and `in_b`, each of size `MATRIX_SIZE`.
  The result is output as a linear array `out_matrix` with elements aligned by rows. The module uses a series of
  multiply-accumulate (MAC) units to compute the product. The computation is synchronized with a clock signal `clk`
  and can be reset using the `reset` signal. The `done` signal indicates the completion of the multiplication process.

  Parameters:
    MATRIX_SIZE - The size of the input matrices (default is 4).
    DATA_SIZE - The bit-width of each matrix element (default is 8).

  Inputs:
    in_a - The first input matrix.
    in_b - The second input matrix.
    reset - Resets the computation process.
    clk - Clock signal for synchronization.

  Outputs:
    out_matrix - The resulting matrix product as a linear array.
    done - Signal indicating the completion of the matrix multiplication.
*/

 // the output is row aligned => row_1 = 0 1 2 3 so on
 // output is represented as a linear array of elements
 // the output elements can have one extra bit for carry

module matrix_multiply#(parameter MATRIX_SIZE = 4, DATA_SIZE = 8)
 (
    input logic [DATA_SIZE-1:0] in_a [MATRIX_SIZE-1:0],
    input logic [DATA_SIZE-1:0] in_b [MATRIX_SIZE-1:0],
    input logic reset, clk,
 // the output is row aligned => row_1 = 0 1 2 3 so on
 // output is represented as a linear array of elements
 // the output elements can have one extra bit for carry
    output logic [DATA_SIZE-1:0] out_matrix [MATRIX_SIZE*MATRIX_SIZE-1:0],
    output logic done
 );

	logic [DATA_SIZE-1:0] row_wire [MATRIX_SIZE*MATRIX_SIZE-1:0];
	logic [DATA_SIZE-1:0] col_wire [MATRIX_SIZE*MATRIX_SIZE-1:0];
	
	// for counter to trigger done signal
	logic[4:0] counter;

	// add all the blocks which are not connected directly to the inputs
	genvar i, j;
	generate
		//localparam in_wire_count = 0, out_wire_count = 0;
		// iterate over rows
		for(i = 1; i<MATRIX_SIZE; i++)
		begin
			//iterate over columns
			for(j=1; j<MATRIX_SIZE; j++)
			begin
				// logic of wiring connection => use MATRIX_SIZE*i to get first mu's wiring and add column no. incrementally
				localparam in_wire_count = MATRIX_SIZE*i+j;
				// similarly the out wire will be in the next row so use i+1
				localparam out_wire_count = MATRIX_SIZE*(i+1)+j;
				mac_unit #(.data_size(DATA_SIZE)) mu (.in_a(row_wire[in_wire_count]), .in_b(col_wire[in_wire_count]), .out_a(row_wire[in_wire_count+1]), .out_b(col_wire[out_wire_count]), .out_sum(out_matrix[in_wire_count]), .reset(reset), .clk(clk));
			end
		end
		// now generate 1st row of each col except top right block
		for(i=1; i<MATRIX_SIZE; i++)
			begin
				localparam in_wire_count = MATRIX_SIZE*i;
				localparam out_wire_count = MATRIX_SIZE*(i+1);
				mac_unit #(.data_size(DATA_SIZE)) mu_row (.in_a(row_wire[i]), .in_b(in_b[i]), .out_a(row_wire[i+1]), .out_b(col_wire[i+MATRIX_SIZE]), .out_sum(out_matrix[i]), .reset(reset), .clk(clk));
			end
		// now generate 1st col of each row except top right block
		for(j=1; j<MATRIX_SIZE; j++)
			begin
				localparam in_wire_count = MATRIX_SIZE*j;
				mac_unit #(.data_size(DATA_SIZE)) mu_col (.in_a(in_a[j]), .in_b(col_wire[in_wire_count]), .out_a(row_wire[in_wire_count+1]), .out_b(col_wire[in_wire_count+MATRIX_SIZE]), .out_sum(out_matrix[in_wire_count]), .reset(reset), .clk(clk));
			end

                // now add the top left block
		mac_unit #(.data_size(DATA_SIZE)) mu_top (.in_a(in_a[0]), .in_b(in_b[0]), .out_a(row_wire[1]), .out_b(col_wire[MATRIX_SIZE]), .out_sum(out_matrix[0]), .reset(reset), .clk(clk));
	endgenerate
	
	// for counting the number of clock cycles
	   
   always@(posedge clk)
       begin
           if(reset == 1'b1)
           begin
               counter <= 5'b00000;
               done <= 1'b0;
           end
           else if(reset == 1'b0)
               begin
                  if(counter < 5'b10000)
                  begin
                   counter <= counter + 1;
                   done <= 1'b0;
                  end
                  
                  else if(counter == 5'b10000)
                   begin
                       counter <= 5'b00000;
                       done <= 1'b1;
                   end 
                   
               end
       end

endmodule

