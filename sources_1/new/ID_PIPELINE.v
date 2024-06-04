`timescale 1ns / 1ps
module ID_PIPELINE (
    input           clk, 
                    reset_n,
    input [31:0]    inst, 
                    pc_in, 
                    pcPlus4_in,
    input           RegWEn_in,
    input [4:0]     AddrD_in,   //writeback address
    input [31:0]    DataD_in,   //writeback data
    output [31:0]   pc_out,
                    pcPlus4_out, 
    output [31:0]   DataA_out,
                    DataB_out,
    output [31:0]   imm_out,    
    output [4:0]    AddrA_out,
                    AddrB_out, 
                    AddrD_out,
    output          PCSel_out,
                    RegWEn_out, 
                    ASel_out, 
                    BSel_out, 
                    MemRW_out,
    output [3:0]    ALUSel_out,
    output [1:0]    WBSel_out,
    output [2:0]    funct3_out
);
    //reg wire
    wire   [4:0]    wire_AddrA, 
                    wire_AddrB, 
                    wire_AddrD;
    wire   [31:0]   wire_DataA, 
                    wire_DataB;
    //controller wire
    wire            wire_PCSel, 
                    wire_RegWEn, 
                    wire_BrUn, 
                    wire_BrEq, 
                    wire_BrLT,
                    wire_BrGE, 
                    wire_ASel, 
                    wire_BSel, 
                    wire_MemRW;
    wire   [2:0]    wire_ImmSel;
    wire   [1:0]    wire_WBSel;
    wire   [3:0]    wire_ALUSel;
    //ImmGen wire
    wire   [31:0]   wire_immm;
    assign          wire_AddrA =    (
                                        inst[6:0] == 7'b0110111 ||  //U-type don't have rs1
                                        inst[6:0] == 7'b1101111     //J-type don't have rs1
                                    )?5'bx:inst[19:15];
    assign          wire_AddrB =    (
                                        inst[6:0] == 7'b0010011 ||  //I-type don't have rs2 (addi, ...)
                                        inst[6:0] == 7'b0000011 ||  //I-tyle don't have rs2 (lw,lb, ...)
                                        inst[6:0] == 7'b1101111 ||  //J-type don't have rs2 (jal)
                                        inst[6:0] == 7'b1100111 ||  //jalr
                                        inst[6:0] == 7'b0110111 ||  //lui
                                        inst[6:0] == 7'b0010111     //auipc
                                    )?5'bx:inst[24:20];
    assign          wire_AddrD =   inst[11:7];
    
    REG_FILE    ID_REG(
                            .clk            (clk),
                            .reset_n        (reset_n),
                            .RegWEn         (RegWEn_in), 
                            .AddrD          (AddrD_in), 
                            .DataD          (DataD_in), 
                            .AddrA          (wire_AddrA),
                            .DataA          (wire_DataA), 
                            .AddrB          (wire_AddrB), 
                            .DataB          (wire_DataB)
                        );
    
    CONTROLLER  ID_CTL(
                            .PCSel          (wire_PCSel), 
                            .inst           (inst), 
                            .ImmSel         (wire_ImmSel), 
                            .RegWEn         (wire_RegWEn),
                            .BrUn           (wire_BrUn), 
                            .BrEq           (wire_BrEq), 
                            .BrLT           (wire_BrLT), 
                            .BrGE           (wire_BrGE), 
                            .ASel           (wire_ASel), 
                            .BSel           (wire_BSel), 
                            .ALUSel         (wire_ALUSel), 
                            .MemRW          (wire_MemRW), 
                            .WBSel          (wire_WBSel)
                    );
    
    BranchComp  ID_BrComp(
                            .A              (wire_DataA), 
                            .B              (wire_DataB), 
                            .BrUn           (wire_BrUn), 
                            .BrEq           (wire_BrEq), 
                            .BrLT           (wire_BrLT),
                            .BrGE           (wire_BrGE)
                        );
    
    ImmGen      ID_ImmGen(
                            .dataIn         (inst[31:7]),
                            .ImmSel         (wire_ImmSel), 
                            .dataOut        (wire_immm)
                        );
    
    ID_EX       REG_IDEX(
                            .clk            (clk), 
                            .reset_n        (reset_n),
                            .pc_in          (pc_in), 
                            .pcPlus4_in     (pcPlus4_in),
                            .DataA_in       (wire_DataA),
                            .DataB_in       (wire_DataB),
                            .AddrA_in       (wire_AddrA), 
                            .AddrB_in       (wire_AddrB), 
                            .AddrD_in       (wire_AddrD),
                            .imm_in         (wire_immm),
                            .PCSel_in       (wire_PCSel), 
                            .RegWEn_in      (wire_RegWEn),
                            .ASel_in        (wire_ASel), 
                            .BSel_in        (wire_BSel),
                            .ALUSel_in      (wire_ALUSel),
                            .MemRW_in       (wire_MemRW), 
                            .WBSel_in       (wire_WBSel),
                            .funct3_in      (inst[14:12]),
                            
                            .pc_out         (pc_out), 
                            .pcPlus4_out    (pcPlus4_out),
                            .DataA_out      (DataA_out), 
                            .DataB_out      (DataB_out),
                            .AddrA_out      (AddrA_out), 
                            .AddrB_out      (AddrB_out), 
                            .AddrD_out      (AddrD_out),
                            .imm_out        (imm_out), 
                            .PCSel_out      (PCSel_out), 
                            .RegWEn_out     (RegWEn_out),
                            .ASel_out       (ASel_out), 
                            .BSel_out       (BSel_out),
                            .ALUSel_out     (ALUSel_out),
                            .MemRW_out      (MemRW_out), 
                            .WBSel_out      (WBSel_out),
                            .funct3_out     (funct3_out)
                        );
endmodule
