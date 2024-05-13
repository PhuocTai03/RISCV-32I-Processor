`timescale 1ns / 1ps
module yourcpu(clk, reset_n, tb_addr, tb_inst);
	input          clk, reset_n;
	input [31:0]   tb_addr, tb_inst;
	wire           PCSel, BrUn, BrEq, BrLT, BrGE, RegWEn, ASel, BSel, MemRW;
	wire [1:0]     WBSel;
	wire [2:0]     ImmSel;
	wire [3:0]     ALUSel;
	wire [31:0]    inst, alu, pc, pcPlus4;
    
	INSTRUCTION_FETCH  DUT_IF(clk, reset_n, PCSel, alu, inst, pc, pcPlus4, tb_addr, tb_inst);
	CONTROLLER         DUT_CTL(PCSel, inst, ImmSel, RegWEn, BrUn, BrEq, BrLT, BrGE, ASel, BSel, ALUSel, MemRW, WBSel);
	DATAPATH           DUT_DP(ImmSel, RegWEn, BrUn, BrEq, BrLT, BrGE, ASel, BSel, ALUSel, MemRW, WBSel, clk, inst, pc, pcPlus4, alu);
endmodule


	


