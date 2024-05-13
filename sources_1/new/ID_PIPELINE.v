`timescale 1ns / 1ps
module ID_PIPELINE (
    input           clk, reset_n,
    input [31:0]    inst, pc_in, pcPlus4_in,
    input           RegWEn_in,
    input [31:0]    DataD_in,
    
    output [31:0]   pc_out, pcPlus4_out, 
    output [31:0]   DataA_out, DataB_out,
    output [31:0]   imm_out,    
    output [4:0]    AddrA_out, AddrB_out, AddrD_out,
    output          PCSel_out, RegWEn_out, ASel_out, BSel_out, MemRW_out,
    output [3:0]    ALUSel_out,
    output [1:0]    WBSel_out,
    output [2:0]    funct3_out);
    
    
    //reg wire
    wire   [4:0]    wire_AddrA, wire_AddrB, wire_AddrD;
    wire   [31:0]   wire_DataA, wire_DataB;
    assign          wire_AddrA = inst[19:15];
    assign          wire_AddrB = inst[24:20];
    assign          wire_AddrD = inst[11:7];
    
    //controller wire
    wire            wire_PCSel, wire_RegWEn, wire_BrUn, wire_BrEq, wire_BrLT,
                    wire_BrGE, wire_ASel, wire_BSel, wire_MemRW;
    wire   [2:0]    wire_ImmSel;
    wire   [1:0]    wire_WBSel;
    wire   [3:0]    wire_ALUSel;
    
    //ImmGen wire
    wire   [31:0]   wire_immm;
    
    REG_FILE    ID_REG(clk, RegWEn_in, wire_AddrD, DataD_in, wire_AddrA,
                             wire_DataA, wire_AddrB, wire_DataB);
    
    CONTROLLER  ID_CTL(wire_PCSel, inst, wire_ImmSel, wire_RegWEn,
                             wire_BrUn, wire_BrEq, wire_BrLT, wire_BrGE, 
                             wire_ASel, wire_BSel, wire_ALUSel, wire_MemRW, wire_WBSel);
    
    BranchComp  ID_BrComp(wire_DataA, wire_DataB, wire_BrUn, wire_BrEq, wire_BrLT, wire_BrGE);
    
    ImmGen      ID_ImmGen(inst[31:7], wire_immm, wire_ImmSel);
    
    ID_EX       REG_IDEX(.clk(clk), .reset_n(reset_n),
                         .pc_in(pc_in), .pcPlus4_in(pcPlus4_in),
                         .DataA_in(wire_DataA), .DataB_in(wire_DataB),
                         .AddrA_in(wire_AddrA), .AddrB_in(wire_AddrB), .AddrD_in(wire_AddrD),
                         .imm_in(wire_immm),
                         .PCSel_in(wire_PCSel), .RegWEn_in(wire_RegWEn),
                         .ASel_in(wire_ASel), .BSel_in(wire_BSel),
                         .ALUSel_in(wire_ALUSel),
                         .MemRW_in(wire_MemRW), 
                         .WBSel_in(wire_WBSel),
                         .funct3_in(inst[14:12]),
                         .pc_out(pc_out), .pcPlus4_out(pcPlus4_out),
                         .DataA_out(DataA_out), .DataB_out(DataB_out),
                         .AddrA_out(AddrA_out), .AddrB_out(AddrB_out), .AddrD_out(AddrD_out),
                         .imm_out(imm_out), 
                         .PCSel_out(PCSel_out), .RegWEn_out(RegWEn_out),
                         .ASel_out(ASel_out), .BSel_out(BSel_out),
                         .ALUSel_out(ALUSel_out),
                         .MemRW_out(MemRW_out), 
                         .WBSel_out(WBSel_out),
                         .funct3_out(funct3_out));
endmodule
