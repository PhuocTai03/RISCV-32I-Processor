`timescale 1ns / 1ps
module IF_PIPELINE(
    input           clk,
                    reset_n,
                    PCSel_in,
    input  [31:0]   alu_in,
                    tb_addr_in,
                    tb_inst_in,
    output [31:0]   inst_out, 
                    pc_out, 
                    pcPlus4_out
);
	wire   [31:0]  wire_pcNext,
	               wire_pc_in, 
	               wire_pc_out,
	               wire_pcPlus4_in, 
	               wire_pcPlus4_out,
	               wire_inst_in, 
	               wire_inst_out,
	               addr;          
	wire           wire_PCSel;
    assign         pcPlus4_out = wire_pcPlus4_out;
    assign         pc_out = wire_pc_out;
    assign         wire_PCSel = (PCSel_in === 1'bx)?1'b0:(PCSel_in === 1'bz)?1'b0:PCSel_in;   
    assign         inst_out = wire_inst_out;
    assign         addr = {2'b0, wire_pc_in[31:2]}; 
    
    MUX21  IF_MUX21(
                        .SEL        (wire_PCSel), 
                        .A          (wire_pcPlus4_in), 
                        .B          (alu_in), 
                        .Y          (wire_pcNext)
                    );
                    
	PC     IF_PC   (
                        .clk        (clk), 
                        .reset_n    (reset_n), 
                        .D          (wire_pcNext), 
                        .Q          (wire_pc_in)
	               );
	               
	IMEM   IF_IMEM (
                        .tb_addr    (tb_addr_in), 
                        .tb_inst    (tb_inst_in), 
                        .addr       (addr), 
                        .inst       (wire_inst_in)
                   ); 
                                 
	ADDER  IF_ADDER(
                        .A          (wire_pc_in), 
                        .B          (32'd4), 
                        .Y          (wire_pcPlus4_in)
                   );
    
    IF_ID  REG_IFID(
                        .clk        (clk), 
                        .reset_n    (reset_n), 
                        .inst_in    (wire_inst_in),
                        .inst_out   (wire_inst_out), 
                        .pc_in      (wire_pc_in),
                        .pc_out     (wire_pc_out),
                        .pcPlus4_in (wire_pcPlus4_in),
                        .pcPlus4_out(wire_pcPlus4_out)
                    );
endmodule
