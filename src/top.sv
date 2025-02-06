`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution : RV College of Engineering
// Engineers: Srivaths Ramasubramanian, Anjali Devarajan, Kousthub Kaivar, Vibha Shrestta, Shashank D
// 
// Create Date: 17.01.2025 11:48:53
// Design Name: top
// Module Name: top
// Project Name: PCA_Accelerator
// Target Devices: Xilinx Basys3 FPGA - cpg236
// Tool Versions: Vivado 2024.1
// Description: The top module would implement the components of the accelerator and realise its complete functionality
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    Top-level module for a hardware design implementing matrix operations using multiple processing units.
    
    Parameters:
    - DATA_SIZE: Bit-width of the input data.
    - MATRIX_SIZE: Dimension of the square matrices.
    - DATA_WIDTH: Bit-width for data processing.

    Inputs:
    - clk: Clock signal.
    - rst: Reset signal.
    - in_a, in_b: Input matrices for covariance computation.
    - input_arctan_valid: Valid signal for arctan input.

    Outputs:
    - done_TPU3: Completion signal for the third processing unit.

    This module integrates various sub-modules to perform matrix multiplication, 
    covariance computation, and other matrix operations using multiple processing units.
*/

module top#(parameter DATA_SIZE = 8, parameter MATRIX_SIZE = 4, parameter DATA_WIDTH = 8)(
    // all global signals
    input logic clk,
    input logic rst,
    // all Covariance Unit signals
    input logic [DATA_SIZE-1:0] in_a [MATRIX_SIZE-1:0],
    input logic [DATA_SIZE-1:0] in_b [MATRIX_SIZE-1:0],
    //output logic [DATA_SIZE-1:0] out_matrix_covariance [MATRIX_SIZE*MATRIX_SIZE-1:0],          // an intermediate signal
    //output logic done_TPU_covariance,                                   // an intermediate signal
    //output logic ena_covariance_A,                                      // an intermediate signal
    //output logic wea_covariance_A,                                      // an intermediate signal
    //output logic [1 : 0] addra_covariance_A,                            // an intermediate signal
    //output logic [31 : 0] dina_covariance_A,                            // an intermediate signal
    //output logic [31 : 0] douta_covariance_A,
    //output logic done_writing_covariance,                                // an intermediate signal 
    //input logic ena_covariance_rotation_B,                         // an intermediate signal
    //input logic wea_covariance_rotation_B,                      // an intermediate signal
    //input logic [1 : 0] addra_covariance_rotation_B,            // an intermediate signal
    //input logic [31 : 0] dina_covariance_rotation_B,            // an intermediate signal
    //output logic [31 : 0] douta_covariance_rotation_B,            // an intermediate signal                                                             
    // all Jacobian Unit signals
    //output logic [1 : 0] p,                                     // an intermediate signal
    //output logic [1 : 0] q,                                     // an intermediate signal
    //output logic [7 : 0] c_pq,                                  // an intermediate signal
    //output logic [7 : 0] c_pp,                                  // an intermediate signal
    //output logic [7 : 0] c_qq,                                   // an intermediate signal
    input logic input_arctan_valid,                             // an intermediate signal
    //output logic sincos_valid,                                  // an intermediate signal
    //output logic [7 : 0] output_cosine_data,                    // an intermediate signal
    //output logic [7 : 0] output_sine_data,                       // an intermediate signal
    //output logic ena_givens_A,
    //output logic wea_givens_A,
    //output logic [1 : 0] addra_givens_A,
    //output logic [31 : 0] dina_givens_A,
    //output logic [31 : 0] douta_givens_A,
    //output logic done_writing_givens,
    //input logic ena_rotation_B,
    //input logic wea_rotation_B,
    //input logic [1 : 0] addra_rotation_B,
    //input logic [31 : 0] dina_rotation_B,
    //output logic [31 : 0] douta_rotation_B,
    // all Rotation Unit signals
    //output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_covariance,
    //output logic done_flattened_array_conv_covariance,
    //output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_givens,
    //output logic done_flattened_array_conv_givens,
    //output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_covariance_nontranspose,
    //output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_givens_transpose,
    //output logic[DATA_WIDTH-1:0] TPU1_inarray_givens [MATRIX_SIZE-1:0],
    //output logic done_templateA_givens_TPU1,
    //output logic[DATA_WIDTH-1:0] TPU1_inarray_covariance [MATRIX_SIZE-1:0],
    //output logic done_templateB_covariance_TPU1,
    //output logic [DATA_WIDTH-1:0] TPU1_product_matrix[MATRIX_SIZE*MATRIX_SIZE - 1:0],      
    //output logic done_TPU1,
    //output logic[DATA_WIDTH-1:0] TPU2_inarray_givens [MATRIX_SIZE-1:0],
    //output logic done_templateB_givens_TPU2,
    //output logic [(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH)-1:0] TPU1_product_matrix_converted,
    //output logic[DATA_WIDTH-1:0] TPU2_inarray_TPU1_product_matrix [MATRIX_SIZE-1:0],     
    //output logic done_templateA_TPU1_product_matrix_TPU2,
    //output logic [DATA_WIDTH-1:0] TPU2_product_matrix[MATRIX_SIZE*MATRIX_SIZE-1:0],      
    //output logic done_TPU2,
    //output logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_identity,        
    //output logic done_flattened_array_conv_identity,
    //output logic[DATA_WIDTH-1:0] TPU3_inarray_identity [MATRIX_SIZE-1:0],      
    //output logic done_templateA_identity_TPU3,
    //output logic[DATA_WIDTH-1:0] TPU3_inarray_givens [MATRIX_SIZE-1:0], 
    //output logic done_templateB_givens_TPU3,
    //output logic [DATA_WIDTH-1:0] TPU3_product_matrix[MATRIX_SIZE*MATRIX_SIZE-1:0],      
    output logic done_TPU3                                     
    );
    
    /*--------------------------- All intermediate Covariance Unit Signals ---------------------------*/
    
    /* For the Covariance Unit TPU */
    logic [DATA_SIZE-1:0] out_matrix_covariance [MATRIX_SIZE*MATRIX_SIZE-1:0];
    logic done_TPU_covariance;
    
    /* For the TPU to Covariance BRAM Controller */
    logic ena_covariance_A;
    logic wea_covariance_A;
    logic [1 : 0] addra_covariance_A;
    logic [31 : 0] dina_covariance_A;
    logic done_writing_covariance;  
    
    /* For the Covariance BRAM */
    logic [31 : 0] douta_covariance_A;
    logic ena_covariance_rotation_B;
    logic wea_covariance_rotation_B;
    logic [1:0] addra_covariance_rotation_B;
    logic [31:0] dina_covariance_rotation_B;
    logic [31:0] douta_covariance_rotation_B; 
    
    /*--------------------------- All intermediate Jacobian Unit Signals ---------------------------*/
    
    /* For the Data Query Engine in the Jacobian Unit */
    logic [1 : 0] p;                                     
    logic [1 : 0] q;                                     
    logic [7 : 0] c_pq;                                  
    logic [7 : 0] c_pp;                                  
    logic [7 : 0] c_qq; 
    
    /* For the CORDIC Engine in the Jacobian Unit */
    logic sincos_valid;
    logic [7 : 0] output_cosine_data;
    logic [7 : 0] output_sine_data;
    
    /* For the Givens Controller in the Jacobian Unit */
    logic ena_givens_A;
    logic wea_givens_A;
    logic [1 : 0] addra_givens_A;
    logic [31 : 0] dina_givens_A;
    logic done_writing_givens;
    //logic done_writing_givens;
    
    /* For the Givens Matrix in the Jacobian unit */
    logic [31 : 0] douta_givens_A;
    logic ena_rotation_B;
    logic wea_rotation_B;
    logic [1 : 0] addra_rotation_B;
    logic [31 : 0] dina_rotation_B;
    logic [31 : 0] douta_rotation_B;
    
    /*--------------------------- All intermediate Rotation Unit Signals ---------------------------*/
    
    /* For the Matrix to Vector Converter for Input Covariance Matrix */
    logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_covariance;
    logic done_flattened_array_conv_covariance; 
    
    /* For the Matrix to Vector Converter for Input Givens Matrix */
    logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_givens;
    logic done_flattened_array_conv_givens;
    
    /*----------------- intermediate variables between flattened array converter and Template Engine (B) for Covariance matrix -----------------*/
    logic[MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_covariance_nontranspose;     // remove after testing
    
     /*----------------- intermediate variables between flattened array converter and Template Engine (A) for Givens matrix -----------------*/
    logic[MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_givens_transpose;     // remove after testing
    
    /*----------------- intermediate variables for Template Engine(A) between Transposer and TPU-1 for Givens matrix -----------------*/
    logic[DATA_WIDTH-1:0] TPU1_inarray_givens [MATRIX_SIZE-1:0];      // remove after testing
    logic done_templateA_givens_TPU1;       // remove after testing
    
    /*----------------- intermediate variables for Template Engine(B) between Buffer and TPU-1 for Covariance matrix -----------------*/
    logic[DATA_WIDTH-1:0] TPU1_inarray_covariance [MATRIX_SIZE-1:0];      // remove after testing
    logic done_templateB_covariance_TPU1;       // remove after testing
    
    /*----------------- intermediate variables for TPU-1 computing (R^T)C -----------------*/
    logic [DATA_WIDTH-1:0] TPU1_product_matrix[MATRIX_SIZE*MATRIX_SIZE - 1:0];      // remove after testing
    logic done_TPU1;                                                              // remove after testing
    
    /*----------------- intermediate variables for Template Engine(B) between Givens Matrix and TPU-2 for product matrix (R^T)CR -----------------*/
    logic[DATA_WIDTH-1:0] TPU2_inarray_givens [MATRIX_SIZE-1:0];      // remove after testing
    logic done_templateB_givens_TPU2;                                     // remove after testing
    
    /*----------------- intermediate variables for unpacked_packed array converter block to perform array conversion at the TPU-1 (R^T)C path -----------------*/
    logic [(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH)-1:0] TPU1_product_matrix_converted;        // remove after testing
    
    /*----------------- intermediate variables for Template Engine(A) between TPU1 Product Matrix and TPU-2 for product matrix (R^T)CR -----------------*/
    logic[DATA_WIDTH-1:0] TPU2_inarray_TPU1_product_matrix [MATRIX_SIZE-1:0];      // remove after testing
    logic done_templateA_TPU1_product_matrix_TPU2;                                     // remove after testing
    
    /*----------------- intermediate variables for TPU-2 computing ((R^T)C)R -----------------*/
    logic [DATA_WIDTH-1:0] TPU2_product_matrix[MATRIX_SIZE*MATRIX_SIZE-1:0];      // remove after testing
    logic done_TPU2; 
    
    /* ----------------- For the Identity BRAM ----------------- */
    logic [31 : 0] dina_identity_A;
    logic [31 : 0] douta_identity_A;
    logic ena_identity_B;
    logic wea_identity_B;
    logic [1:0] addra_identity_B;
    logic [31:0] dina_identity_B;
    logic [31:0] douta_identity_B; 
    
    /*----------------- intermediate variables for flattened array converters for Identity matrix -------------------*/
    logic ena_identity_A;
    logic wea_identity_A;
    logic [1 : 0] addra_identity_A;
    logic [MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1:0] flattened_array_identity;        // remove after testing
    logic done_flattened_array_conv_identity;                                        // remove after testing
    
    /*----------------- intermediate variables for Template Engine(A) between Identity matrix and TPU-3 for product matrix V = VR -----------------*/
    logic[DATA_WIDTH-1:0] TPU3_inarray_identity [MATRIX_SIZE-1:0];      // remove after testing
    logic done_templateA_identity_TPU3;  
    
    /*----------------- intermediate variables for Template Engine(B) between  Givens matrix and TPU-3 for product matrix V = VR -----------------*/
    logic[DATA_WIDTH-1:0] TPU3_inarray_givens [MATRIX_SIZE-1:0];      // remove after testing
    logic done_templateB_givens_TPU3;
    
    /*----------------- intermediate variables for TPU-3 computing V = VR -----------------*/
    logic [DATA_WIDTH-1:0] TPU3_product_matrix[MATRIX_SIZE*MATRIX_SIZE-1:0];      // remove after testing
    //logic done_TPU3; 
    
    
    
    
    /*--------------------------- ALL MODULE INSTANTIATIONS HERE ---------------------------*/
    
    /*--------------------------- Covariance Unit ---------------------------*/
    
    // Instantiate the TPU for covariance matrix computation
    matrix_multiply#(.DATA_SIZE(DATA_SIZE), .MATRIX_SIZE(MATRIX_SIZE))Covariance_Unit_TPU(
        in_a,
        in_b,
        rst,
        clk,
        out_matrix_covariance,
        done_TPU_covariance
    );
    
    // Instantiate the TPU to Covariance Matrix BRAM Controller
    controller_TPUtoBRAM TPU_CovarianceBRAM_Controller(
        clk,
        rst,
        out_matrix_covariance,
        done_TPU_covariance,
        ena_covariance_A,
        wea_covariance_A,
        addra_covariance_A,
        dina_covariance_A,
        done_writing_covariance
    );
    
    // Instantiate the Covariance matrix BRAM
    BRAM_CovarianceMatrix Covariance_BRAM(
        clk,
        ena_covariance_A,
        wea_covariance_A,
        addra_covariance_A,
        dina_covariance_A,
        douta_covariance_A,
        ena_covariance_rotation_B,
        wea_covariance_rotation_B,
        addra_covariance_rotation_B,
        dina_covariance_rotation_B,
        douta_covariance_rotation_B
    );
    
    /*--------------------------- Jacobian Unit ---------------------------*/
    
    // Instantiate the Data Query Engine
    data_query_engine#(.DATA_SIZE(DATA_SIZE), .MATRIX_SIZE(MATRIX_SIZE))DQE(
        clk,
        done_TPU_covariance,
        out_matrix_covariance,
        p,
        q,
        c_pq,
        c_pp,
        c_qq
    );
    
    // Instantiate the CORDIC Engine
    top_CORDIC CORDIC_ENGINE(
        clk,
        c_pq,
        c_pp,
        c_qq,
        input_arctan_valid,
        sincos_valid,
        output_cosine_data,
        output_sine_data
    );
    
    // Instantiate the Givens Controller
    controller_givensmatrix GIVENS_CONTROLLER(
        clk,
        sincos_valid,
        p,
        q,
        output_cosine_data,
        output_sine_data,
        ena_givens_A,
        wea_givens_A,
        addra_givens_A,
        dina_givens_A,
        done_writing_givens 
    );
    
    // Instantiate the Givens Matrix
    givens_matrix_datapath GIVENS_MATRIX(
        clk,
        ena_givens_A,
        wea_givens_A,
        addra_givens_A,
        dina_givens_A,
        douta_givens_A,
        ena_rotation_B,
        wea_rotation_B,
        addra_rotation_B,
        dina_rotation_B,
        douta_rotation_B
    );
    
    /*--------------------------- Rotation Unit ---------------------------*/
    
    // Instantiate the Matrix to Vector Converter for Covariance Matrix
    flattened_array_converter#(.DATA_WIDTH(DATA_WIDTH), .MATRIX_SIZE(MATRIX_SIZE))MVC_Covariance(
        clk,
        rst,
        done_writing_givens,
        douta_covariance_rotation_B,
        ena_covariance_rotation_B,
        wea_covariance_rotation_B,
        addra_covariance_rotation_B,
        flattened_array_covariance,
        done_flattened_array_conv_covariance
    );
    
    // Instantiate the Matrix to Vector Converter for Givens Matrix
    flattened_array_converter#(.DATA_WIDTH(DATA_WIDTH), .MATRIX_SIZE(MATRIX_SIZE))MVC_Givens(
        clk,
        rst,
        done_writing_givens,
        douta_rotation_B,
        ena_rotation_B,
        wea_rotation_B,
        addra_rotation_B,
        flattened_array_givens,
        done_flattened_array_conv_givens
    );
    
    // Instantiate the Matrix Buffer for the Covariance Vector
    matrix_buffer#(.DATA_WIDTH(DATA_WIDTH), .MATRIX_SIZE(MATRIX_SIZE))Buffer_CovarianceVector(
        flattened_array_covariance,
        flattened_array_covariance_nontranspose
    );
    
    // Instantiate the Matrix Transposer for the Covariance Vector
    matrix_transposer#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Transpose_GivensVector(
        flattened_array_givens,
        flattened_array_givens_transpose
    );
    
    // Deploying the Template Engine(A) for the Givens Matrix between the Transposer and the TPU-1
    template_engine_A#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Matrix_Padding_Unit_GivensVector(
        clk,
        rst,
        flattened_array_givens_transpose,
        TPU1_inarray_givens,
        done_templateA_givens_TPU1
    );
    
    // Deploying the Template Engine(B) for the Covariance Matrix between the Buffer and the TPU-1
    template_engine_B#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Matrix_Padding_Unit_CovarianceVector(
        clk,
        rst,
        flattened_array_covariance_nontranspose,
        TPU1_inarray_covariance,
        done_templateB_covariance_TPU1
    );
    
    // Deploying the TPU-1 for computing (R^T)C
    matrix_multiply#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_SIZE(DATA_WIDTH))TPU_1(
        TPU1_inarray_givens,
        TPU1_inarray_covariance,
        rst,
        clk,
        TPU1_product_matrix,
        done_TPU1
    );
    
    // Deploying the Template Engine (B) between Givens matrix and TPU-2 
    template_engine_B#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Matrix_Padding_Unit_GivensVector_toTPU2(
        clk,
        rst,
        flattened_array_givens,
        TPU2_inarray_givens,
        done_templateB_givens_TPU2
    );
    
    // Deploying a unpacked_packed array converter block to perform array conversion at the TPU-1 out-matrix path
    unpacked_packed_converter#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Data_Alignment_Unit_1(
        TPU1_product_matrix,
        TPU1_product_matrix_converted
    );
    
    // Deploying the Template Engine (A) between UPC_Converter for TPU1-product matrix and TPU-2 on the TPU1 product matrix signal path
    template_engine_A#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Matrix_Padding_Unit_ProductMatrix_toTPU2(
        clk,
        rst,
        TPU1_product_matrix_converted,
        TPU2_inarray_TPU1_product_matrix,
        done_templateA_TPU1_product_matrix_TPU2
    );
    
    // Deploying TPU-2 for computing product of (R^T)C and R
    matrix_multiply#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_SIZE(DATA_WIDTH))TPU_2(
        TPU2_inarray_TPU1_product_matrix,
        TPU2_inarray_givens,
        rst,
        clk,
        TPU2_product_matrix,
        done_TPU2
    );
    
    // Deploying the Identity Matrix
    BRAM_IdentityMatrix Identity_BRAM(
        clk,
        ena_identity_A,
        wea_identity_A,
        addra_identity_A,
        dina_identity_A,
        douta_identity_A,
        ena_identity_B,
        wea_identity_B,
        addra_identity_B,
        dina_identity_B,
        douta_identity_B
    );
    
    // Deploy the flattened array converter - Identity Matrix
    flattened_array_converter#(.DATA_WIDTH(DATA_WIDTH), .MATRIX_SIZE(MATRIX_SIZE))MVC_Identity(
        clk,
        rst,
        done_writing_givens,
        douta_identity_A,
        ena_identity_A,
        wea_identity_A,
        addra_identity_A,
        flattened_array_identity,
        done_flattened_array_conv_identity
    );
    
    // Deploying the Template Engine(A) for the Identity Matrix for computing product V = VR
    template_engine_A#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Matrix_Padding_Unit_IdentityVector(
        clk,
        rst,
        flattened_array_identity,
        TPU3_inarray_identity,
        done_templateA_identity_TPU3
    );
    
    // Deploying the Template Engine (B) for the Givens matrix for computing product V = VR
    template_engine_B#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_WIDTH(DATA_WIDTH))Matrix_Padding_Unit_GivensVector_TPU3(
        clk,
        rst,
        flattened_array_givens,
        TPU3_inarray_givens,
        done_templateB_givens_TPU3
    );
    
    // Deploying TPU-3 for computing product V = VR
    matrix_multiply#(.MATRIX_SIZE(MATRIX_SIZE), .DATA_SIZE(DATA_WIDTH))TPU_3(
        TPU3_inarray_identity,
        TPU3_inarray_givens,
        rst,
        clk,
        TPU3_product_matrix,
        done_TPU3
    );
    
endmodule

