`timescale 1ns / 1ps
module yourcpu_pipeline(clk, reset_n, tb_addr, tb_inst);
    input          clk, reset_n;
	input [31:0]   tb_addr, tb_inst;
	//IF wire
	wire [31:0]    inst_IF, pc_IF, pcPlus4_IF;
    IF_PIPELINE DUT_IF  (
                            .clk        (clk), 
                            .reset_n    (reset_n), 
                            .tb_addr_in (tb_addr), 
                            .tb_inst_in (tb_inst),
                            .PCSel_in   (PCSel_ID), 
                            .alu_in     (ALU_Result_EX), 
                            .inst_out   (inst_IF), 
                            .pc_out     (pc_IF), 
                            .pcPlus4_out(pcPlus4_IF)   
                        );    
    //ID wire
	wire           PCSel_ID, RegWEn_ID, ASel_ID, BSel_ID, MemRW_ID;
	wire [1:0]     WBSel_ID;
	wire [2:0]     funct3_ID;
	wire [3:0]     ALUSel_ID;
	wire [4:0]     AddrA_ID, AddrB_ID, AddrD_ID;             
	wire [31:0]    inst_ID, pc_ID, pcPlus4_ID, DataA_ID, DataB_ID, imm_ID;
    ID_PIPELINE DUT_ID  (   
                            .clk        (clk),
                            .reset_n    (reset_n), 
                            .inst       (inst), 
                            .pc_in      (pc_IF), 
                            .pcPlus4_in (pcPlus4_IF), 
                            .RegWEn_in  (RegWEn_WB), 
                            .DataD_in   (DataWB_MA),
                            .pc_out     (pc_ID), 
                            .pcPlus4_out(pcPlus4_ID), 
                            .AddrA_out  (AddrA_ID), 
                            .DataA_out  (DataA_ID), 
                            .AddrB_out  (AddrB_ID), 
                            .DataB_out  (DataB_ID), 
                            .AddrD_out  (AddrD_ID), 
                            .imm_out    (imm_ID),
                            .PCSel_out  (PCSel_ID), 
                            .RegWEn_out (RegWEn_ID), 
                            .ASel_out   (ASel_ID), 
                            .BSel_out   (BSel_ID), 
                            .ALUSel_out (ALUSel_ID), 
                            .MemRW_out  (MemRW_ID), 
                            .WBSel_out  (WBSel_ID), 
                            .funct3_out (funct3_ID)
                        );
    //EX wire
	wire [4:0]  AddrD_EX;
    wire        RegWEn_EX, MemRW_EX;
    wire [1:0]  WBSel_EX;
    wire [2:0]  funct3_EX;
    wire [31:0] ALU_Result_EX, ALU_DataB_EX, pcPlus4_EX;
    EX_PIPELINE DUT_EX  (
                            .clk        (clk), 
                            .reset_n    (reset_n),
                            .pc_in      (pc_ID), 
                            .pcPlus4_in (pcPlus4_ID),
                            .DataA_in   (DataA_ID), 
                            .DataB_in   (DataB_ID), 
                            .imm_in     (imm_ID), 
                            .ALU_Result_in(ALU_Result_EX), 
                            .WB_Result_in(DataWB_WB), 
                            //.Data_W_delay(),
                            .AddrD_in   (AddrD_ID),
                            .RegWEn_in  (RegWEn_ID), 
                            .ASel_in    (ASel_ID), 
                            .BSel_in    (BSel_ID), 
                            .MemRW_in   (MemRW_ID),   
                            .ALUSel_in  (ALUSel_ID),
                            .WBSel_in   (WBSel_ID),
                            .funct3_in  (funct3_ID),
                            .hazardSelA(hazardSelA), 
                            .hazardSelB(hazardSelB),
                                
                            .AddrD_out  (AddrD_EX),
                            .RegWEn_out (RegWEn_EX), 
                            .MemRW_out  (MemRW_EX),
                            .WBSel_out  (WBSel_EX),
                            .funct3_out (funct3_EX),
                            .ALU_Result_out(ALU_Result_EX),
                            .DataB_out  (ALU_DataB_EX),
                            .pcPlus4_out(pcPlus4_EX)
                        );
    wire        RegWEn_WB;
    wire [4:0]  AddrD_MA;
    wire [31:0] DataWB_WB;    
    MA_PIPELINE DUT_MA  (
                            .clk        (clk), 
                            .reset_n    (reset_n),
                            .RegWEn_in  (RegWEn_EX), 
                            .MemRW_in   (MemRW_EX),
                            .WBSel_in   (WBSel_EX),
                            .funct3_in  (funct3_EX),
                            .ALU_Result_in(ALU_Result_EX),
                            .DataW_in   (ALU_DataB_EX),
                            .pcPlus4_in (pcPlus4_EX),
                            .AddrD_in   (AddrD_EX),    
                            .RegWEn_out (RegWEn_WB),
                            .AddrD_out  (AddrD_MA),
                            .DataWB_out (DataWB_WB)
                        );
    
    wire [1:0]  hazardSelA, hazardSelB;
    HazardUnit DUT_HazardUnit(
                            .reset_n(reset_n), 
                            .RS1_EX(AddrA_ID), 
                            .RS2_EX(AddrB_ID), 
                            .RD_MA(AddrD_EX), 
                            .RD_WB(AddrD_MA), 
                            .RegWEn_MA(RegWEn_EX), 
                            .RegWEn_WB(RegWEn_WB),
                            .hazardSelA(hazardSelA), 
                            .hazardSelB(hazardSelB)
                        );
    
endmodule

