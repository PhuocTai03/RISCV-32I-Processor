`timescale 1ns / 1ps
module yourcpu_pipeline(clk, reset_n, tb_addr, tb_inst);
    input           clk, reset_n;
    input [31:0]    tb_addr, tb_inst;
    //IF wire
    wire [31:0]     inst_ID, pc_ID, pcPlus4_ID;
    //ID wire
    wire            PCSel_IF, RegWEn_EX, ASel_EX, BSel_EX, MemRW_EX;
    wire [1:0]      WBSel_EX;
    wire [2:0]      funct3_EX;
    wire [3:0]      ALUSel_EX;
    wire [4:0]      AddrA_EX, AddrB_EX, AddrD_EX;             
    wire [31:0]     pc_EX, pcPlus4_EX, DataA_EX, DataB_EX, imm_EX;
    //EX wire
    wire            RegWEn_MA, MemRW_MA;
    wire [1:0]      WBSel_MA;
    wire [2:0]      funct3_MA;
    wire [4:0]      AddrD_MA;
    wire [31:0]     ALU_Result_EX, ALU_Result_MA, ALU_DataB_MA, pcPlus4_MA;
    //MA wire
    wire            RegWEn_WB;
    wire [1:0]      WBSel_WB;
    wire [4:0]      AddrD_WB;
    wire [31:0]     DataR_WB;
    wire [31:0]     ALU_Result_WB;
    wire [31:0]     pcPlus4_WB;
    wire [31:0]     DataWB_WB;
    //forwarding wire
    wire [1:0]      fwdSelA, fwdSelB;
    IF_PIPELINE DUT_IF  (
                            .clk            (clk), 
                            .reset_n        (reset_n), 
                            .tb_addr_in     (tb_addr), 
                            .tb_inst_in     (tb_inst),
                            .PCSel_in       (PCSel_IF), 
                            .alu_in         (ALU_Result_EX),
                             
                            .inst_out       (inst_ID), 
                            .pc_out         (pc_ID), 
                            .pcPlus4_out    (pcPlus4_ID)   
                        );    
    
    ID_PIPELINE DUT_ID  (   
                            .clk            (clk),
                            .reset_n        (reset_n), 
                            .inst           (inst_ID), 
                            .pc_in          (pc_ID), 
                            .pcPlus4_in     (pcPlus4_ID), 
                            .RegWEn_in      (RegWEn_WB), 
                            .AddrD_in       (AddrD_WB),
                            .DataD_in       (DataWB_WB),
                            
                            .pc_out         (pc_EX), 
                            .pcPlus4_out    (pcPlus4_EX), 
                            .AddrA_out      (AddrA_EX),
                            .DataA_out      (DataA_EX), 
                            .AddrB_out      (AddrB_EX),
                            .DataB_out      (DataB_EX), 
                            .AddrD_out      (AddrD_EX), 
                            .imm_out        (imm_EX),
                            .PCSel_out      (PCSel_IF), 
                            .RegWEn_out     (RegWEn_EX), 
                            .ASel_out       (ASel_EX), 
                            .BSel_out       (BSel_EX), 
                            .ALUSel_out     (ALUSel_EX), 
                            .MemRW_out      (MemRW_EX), 
                            .WBSel_out      (WBSel_EX), 
                            .funct3_out     (funct3_EX)
                        );
    
    EX_PIPELINE DUT_EX  (
                            .clk            (clk), 
                            .reset_n        (reset_n),
                            .pc_in          (pc_EX), 
                            .pcPlus4_in     (pcPlus4_EX),
                            .DataA_in       (DataA_EX), 
                            .DataB_in       (DataB_EX), 
                            .imm_in         (imm_EX), 
                            .ALU_Result_in  (ALU_Result_MA), 
                            .WB_Result_in   (DataWB_WB),
                            .AddrD_in       (AddrD_EX),
                            .RegWEn_in      (RegWEn_EX), 
                            .ASel_in        (ASel_EX), 
                            .BSel_in        (BSel_EX), 
                            .ALUSel_in      (ALUSel_EX),
                            .MemRW_in       (MemRW_EX),   
                            .WBSel_in       (WBSel_EX),
                            .funct3_in      (funct3_EX),
                            .fwdSelA        (fwdSelA), 
                            .fwdSelB        (fwdSelB),
                            
                            .ALU_Result_EX  (ALU_Result_EX),
                                
                            .RegWEn_out     (RegWEn_MA), 
                            .MemRW_out      (MemRW_MA),
                            .WBSel_out      (WBSel_MA),
                            .funct3_out     (funct3_MA),
                            .ALU_Result_out (ALU_Result_MA),
                            .DataB_out      (ALU_DataB_MA),
                            .pcPlus4_out    (pcPlus4_MA),
                            .AddrD_out      (AddrD_MA)
                        );
    MA_PIPELINE DUT_MA  (
                            .clk            (clk), 
                            .reset_n        (reset_n),
                            .RegWEn_in      (RegWEn_MA), 
                            .MemRW_in       (MemRW_MA),
                            .WBSel_in       (WBSel_MA),
                            .funct3_in      (funct3_MA),
                            .ALU_Result_in  (ALU_Result_MA),
                            .DataW_in       (ALU_DataB_MA),
                            .pcPlus4_in     (pcPlus4_MA),
                            .AddrD_in       (AddrD_MA),
                                
                            .RegWEn_out     (RegWEn_WB),
                            .WBSel_out      (WBSel_WB),
                            .DataR_out      (DataR_WB),
                            .ALU_Result_out (ALU_Result_WB),
                            .pcPlus4_out    (pcPlus4_WB),
                            .AddrD_out      (AddrD_WB)      
                        );
                       
    WB_PIPELINE DUT_WB(
                            .WBSel_in       (WBSel_WB),
                            .DataR_in       (DataR_WB),
                            .ALU_Result_in  (ALU_Result_WB),
                            .pcPlus4_in     (pcPlus4_WB),
 
                            .DataWB         (DataWB_WB)
                        );
    FowardingUnit DUT_FowardingUnit(
                            .reset_n        (reset_n), 
                            .RS1_EX         (AddrA_EX), 
                            .RS2_EX         (AddrB_EX), 
                            .RD_MA          (AddrD_MA), 
                            .RD_WB          (AddrD_WB), 
                            .RegWEn_MA      (RegWEn_MA), 
                            .RegWEn_WB      (RegWEn_WB),
                            
                            .fwdSelA        (fwdSelA), 
                            .fwdSelB        (fwdSelB)
                        );  
endmodule

