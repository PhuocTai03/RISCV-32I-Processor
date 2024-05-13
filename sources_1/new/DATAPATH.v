module DATAPATH(ImmSel, RegWEn, BrUn, BrEq, BrLT, BrGE, ASel, BSel, ALUSel, MemRW, WBSel, clk, inst, pc, pcPlus4, aluResult);
	input          clk;
	input          RegWEn, BrUn, ASel, BSel, MemRW;
	input [1:0]    WBSel;
	input [2:0]    ImmSel;
	input [3:0]    ALUSel;
	input [31:0]   inst, pc, pcPlus4;
    output         BrEq, BrLT, BrGE;
    output [31:0]  aluResult;
    
    
	wire [31:0]    wire_reg_RS1, wire_reg_RS2, wire_immGen_out, wire_ALU_inA,
				   wire_ALU_inB, wire_alu_result, wire_dmem_dataRead, wire_writeback;
    wire [4:0]     wire_reg_addrA, wire_reg_addrB, wire_reg_addrD;
    wire [2:0]     funct3;
    
    assign         funct3         = inst[14:12];
    assign         wire_reg_addrA = inst[19:15];
    assign         wire_reg_addrB = inst[24:20];
    assign         wire_reg_addrD = inst[11:7];
    assign         aluResult      = wire_alu_result;
    
    REG_FILE    DUT_REG(.clk(clk), .RegWEn(RegWEn), 
                        .AddrD(wire_reg_addrD), .DataD(wire_writeback), 
                        .AddrA(wire_reg_addrA), .DataA(wire_reg_RS1), 
                        .AddrB(wire_reg_addrB), .DataB(wire_reg_RS2));
	
    BranchComp  DUT_BranchComp(.A(wire_reg_RS1), .B(wire_reg_RS2), .BrUn(BrUn), .BrEq(BrEq), .BrLT(BrLT), .BrGE(BrGE));
    ImmGen      DUT_ImmGen(.dataIn(inst[31:7]), .dataOut(wire_immGen_out), .ImmSel(ImmSel));
    MUX21       DUT_AMUX21(.SEL(ASel), .A(wire_reg_RS1), .B(pc), .Y(wire_ALU_inA));
    MUX21       DUT_BMUX21(.SEL(BSel), .A(wire_reg_RS2), .B(wire_immGen_out), .Y(wire_ALU_inB));
    ALU         DUT_ALU(.A(wire_ALU_inA), .B(wire_ALU_inB), .ALUControl(ALUSel), .ALUResult(wire_alu_result));
    DMEM        DUT_DMEM(.clk(clk), .MemRW(MemRW), .funct3(funct3), .addr(wire_alu_result[9:0]), .DataW(wire_reg_RS2), .DataR(wire_dmem_dataRead));
    MUX31       DUT_WB_MUX31(.SEL(WBSel), .A(wire_dmem_dataRead), .B(wire_alu_result), .C(pcPlus4), .Y(wire_writeback));
endmodule