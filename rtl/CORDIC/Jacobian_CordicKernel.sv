`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Srivaths Ramasubramanian
// 
// Create Date: 08.01.2025 22:40:47
// Design Name: Jacobian Unit
// Module Name: Jacobian_CordicKernel
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Artix-7 cpg236
// Tool Versions: Vivado 2024.1
// Description: The Cordic Math Kernel which ultimately computes the Givens Rotation Matrix
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Jacobian_CordicKernel(
    input clk,
    input s_axis_cartesian_tvalid,      // tvalid bit for arctan unit
    input [31:0] s_axis_cartesian_tdata,    // data input to arctan unit
    output m_axis_dout_tvalid,          // output from the sincos unit signifying that the outputs are ready
    output [31:0] m_axis_dout_tdata
    );
    
    logic m_axis_dout_tvalid_arctan;             // output wire from the arctan unit signifying that the output is computed after certain latency
    logic [15:0] m_axis_dout_tdata_arctan;       // output wire [15:0] from the arctan unit
    
    // for the shifter (shift one bit only), we have the signals
    logic [15:0] m_axis_din_tdata_sincos;
    
    // instantiate the modules
    
    // the arctan unit
    cordic_arctan arctan_unit (
      .aclk(clk),                                        // input wire aclk
      .s_axis_cartesian_tvalid(s_axis_cartesian_tvalid),  // input wire s_axis_cartesian_tvalid
      .s_axis_cartesian_tdata(s_axis_cartesian_tdata),    // input wire [31 : 0] s_axis_cartesian_tdata
      .m_axis_dout_tvalid(m_axis_dout_tvalid_arctan),            // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(m_axis_dout_tdata_arctan)              // output wire [15 : 0] m_axis_dout_tdata
    );
    
    always@(posedge clk)
        if(m_axis_dout_tvalid_arctan == 1'b1)
            m_axis_din_tdata_sincos <= (m_axis_dout_tdata_arctan >> 1);
        else if(m_axis_dout_tvalid_arctan == 1'b1)
            m_axis_din_tdata_sincos <= 0;
    
    // the sincos unit
    cordic_sincos sincos_unit (
      .aclk(clk),                                // input wire aclk
      .s_axis_phase_tvalid(m_axis_dout_tvalid_arctan),  // input wire s_axis_phase_tvalid
      .s_axis_phase_tdata(m_axis_din_tdata_sincos),    // input wire [15 : 0] s_axis_phase_tdata
      .m_axis_dout_tvalid(m_axis_dout_tvalid),    // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(m_axis_dout_tdata)      // output wire [31 : 0] m_axis_dout_tdata
    );
    
endmodule
