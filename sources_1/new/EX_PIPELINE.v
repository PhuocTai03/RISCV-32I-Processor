`timescale 1ns / 1ps
module EX_PIPELINE(
    input           clk, reset_n,
    input [31:0]    pc_in, pcPlus4_in,
    input [31:0]    DataA_in, DataB_in, 
    input [31:0]    imm_in, 
    input [31:0]    ALU_Result_in, WB_Result_in, WB_Result2_in,
    input [4:0]     AddrD_in,
    input           RegWEn_in, ASel_in, BSel_in, MemRW_in,   
    input [3:0]     ALUSel_in,
    input [1:0]     WBSel_in,
    input [2:0]     funct3_in,
    input [1:0]     hazardSelA, hazardSelB,
    ///
    output          RegWEn_out, MemRW_out,
    output [1:0]    WBSel_out,
    output [2:0]    funct3_out,
    output [31:0]   ALU_Result_out,
    output [31:0]   DataB_out,
    output [31:0]   pcPlus4_out,
    output [4:0]    AddrD_out
    );
    
    wire   [31:0]   wire_ALU_inA, wire_ALU_inB, wire_alu_result,
                    wire_forwardingA, wire_forwardingB;
    
    
    MUX41   EX_AMUX41(hazardSelA, DataA_in, ALU_Result_in, WB_Result_in, WB_Result2_in, wire_forwardingA);
    MUX41   EX_BMUX41(hazardSelB, DataB_in, ALU_Result_in, WB_Result_in, WB_Result2_in, wire_forwardingB);
    MUX21   EX_AMUX21(ASel_in, wire_forwardingA, pc_in, wire_ALU_inA);
    MUX21   EX_BMUX21(BSel_in, wire_forwardingB, imm_in, wire_ALU_inB);
    ALU     EX_ALU(wire_ALU_inA, wire_ALU_inB, ALUSel_in, wire_alu_result);
    EX_MA   REG_EXMA(
            .clk        (clk),
            .reset_n    (reset_n),    
            .AddrD_in   (AddrD_in),
            .RegWEn_in  (RegWEn_in),
            .MemRW_in   (MemRW_in),
            .WBSel_in   (WBSel_in),
            .funct3_in  (funct3_in),
            .ALU_Result_in(wire_alu_result),
            .DataB_in   (wire_forwardingB),
            .pcPlus4_in (pcPlus4_in),
    
            .AddrD_out  (AddrD_out),
            .RegWEn_out (RegWEn_out),
            .MemRW_out  (MemRW_out),
            .WBSel_out  (WBSel_out),
            .funct3_out (funct3_out),
            .ALU_Result_out(ALU_Result_out),
            .DataB_out  (DataB_out),
            .pcPlus4_out(pcPlus4_out)
            );
endmodule

