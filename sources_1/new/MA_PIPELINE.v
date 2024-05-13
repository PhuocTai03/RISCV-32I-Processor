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
    output          RegWEn_out,
    output [4:0]    AddrD_out,
    output [31:0]   DataWB_out
    );
    
    wire   [31:0]   wire_DataR, wire_DataWB;
    //use MA_PIPELINE.wire_DataWB for pileline
    DMEM    MA_DMEM(
                    .clk            (clk), 
                    .MemRW          (MemRW_in), 
                    .funct3         (funct3_in), 
                    .addr           (ALU_Result_in), 
                    .DataW          (DataW_in), 
                    .DataR          (wire_DataR));
    
    MUX31  DUT_WB_MUX31(
                    .SEL(WBSel_in), 
                    .A(wire_DataR), 
                    .B(ALU_Result_in), 
                    .C(pcPlus4_in), 
                    .Y(wire_DataWB)); 
                                  
    MA_WB   REG_MAWB(
                    .clk            (clk), 
                    .reset_n        (reset_n),
                    .RegWEn_in      (RegWEn_in),
                    .AddrD_in       (AddrD_in),
                    .DataWB_in      (wire_DataWB),
                    
                    .RegWEn_out     (RegWEn_out),
                    .AddrD_out       (AddrD_out),
                    .DataWB_out     (DataWB_out));
endmodule
