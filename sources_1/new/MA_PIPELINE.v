`timescale 1ns / 1ps
module MA_PIPELINE(
    input           clk, reset_n,
    input           RegWEn_in, MemRW_in,
    input [1:0]     WBSel_in,
    input [2:0]     funct3_in,
    input [31:0]    ALU_Result_in,
    input [31:0]    DataW_in,
    input [31:0]    pcPlus4_in,
    input [4:0]     AddrD_in,
    //
    output          RegWEn_out,
    output [1:0]    WBSel_out,
    output [31:0]   DataR_out,
    output [31:0]   ALU_Result_out,
    output [31:0]   pcPlus4_out,
    output [4:0]    AddrD_out
    );
    
    wire   [31:0]   wire_DataR;
    DMEM    MA_DMEM(
                    .clk            (clk), 
                    .MemRW          (MemRW_in), 
                    .funct3         (funct3_in), 
                    .addr           (ALU_Result_in), 
                    .DataW          (DataW_in), 
                    .DataR          (wire_DataR)
                    );
                                  
    MA_WB   REG_MAWB(
                    .clk            (clk), 
                    .reset_n        (reset_n),
                    .RegWEn_in      (RegWEn_in),
                    .WBSel_in       (WBSel_in),
                    .AddrD_in       (AddrD_in),
                    .DataR_in       (wire_DataR),
                    .ALU_Result_in  (ALU_Result_in),
                    .pcPlus4_in     (pcPlus4_in),
                    
                    .RegWEn_out     (RegWEn_out),
                    .WBSel_out      (WBSel_out),
                    .AddrD_out      (AddrD_out),
                    .DataR_out      (DataR_out),
                    .ALU_Result_out (ALU_Result_out),
                    .pcPlus4_out    (pcPlus4_out)
                    );
endmodule
