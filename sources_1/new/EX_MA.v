`timescale 1ns / 1ps

module EX_MA(
    input               clk,reset_n,    
    input [4:0]         AddrD_in,
    input               RegWEn_in, MemRW_in,
    input [1:0]         WBSel_in,
    input [2:0]         funct3_in,
    input [31:0]        ALU_Result_in,
    input [31:0]        DataB_in,
    input [31:0]        pcPlus4_in,
    
    output reg  [4:0]   AddrD_out,
    output reg          RegWEn_out, MemRW_out,
    output reg  [1:0]   WBSel_out,
    output reg  [2:0]   funct3_out,
    output reg  [31:0]  ALU_Result_out,
    output reg  [31:0]  DataB_out,
    output reg  [31:0]  pcPlus4_out);
    
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            AddrD_out     <= 0;
            RegWEn_out    <= 0;
            MemRW_out     <= 0;
            WBSel_out     <= 0;
            funct3_out    <= 0;
            ALU_Result_out<= 0;
            DataB_out     <= 0;
            pcPlus4_out   <= 0;
        end
        else begin
            AddrD_out     <= AddrD_in;
            RegWEn_out    <= RegWEn_in;
            MemRW_out     <= MemRW_in;
            WBSel_out     <= WBSel_in;
            funct3_out    <= funct3_in;
            ALU_Result_out<= ALU_Result_in;
            DataB_out     <= DataB_in;
            pcPlus4_out   <= pcPlus4_in;                                
        end
    end
endmodule
