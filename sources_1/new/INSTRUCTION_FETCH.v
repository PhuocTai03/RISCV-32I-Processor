module INSTRUCTION_FETCH(clk, reset_n, PCSel, alu, inst, pc, pcPlus4, tb_addr, tb_inst);
	input          clk, reset_n, PCSel;
	input  [31:0]  alu, tb_addr, tb_inst;
	output [31:0]  inst, pc, pcPlus4;
	
	wire   [31:0]  wire_pcNext, wire_pc, wire_pcPlus4, addr;
	wire           wire_PCSel;
    assign         pcPlus4 = wire_pcPlus4;
    assign         pc = wire_pc;
    assign         wire_PCSel = (PCSel === 1'bx)?1'b0:(PCSel === 1'bz)?1'b0:PCSel;   
    assign         addr = {2'b0, wire_pc[31:2]};
	PC     DUT_PC(clk, reset_n, wire_pcNext, wire_pc);
	ADDER  DUT_ADDER(wire_pc, 32'd4, wire_pcPlus4);	
	IMEM   DUT_IMEM(tb_addr, tb_inst, addr, inst);
    MUX21  DUT_MUX21(wire_PCSel, wire_pcPlus4, alu, wire_pcNext);
endmodule