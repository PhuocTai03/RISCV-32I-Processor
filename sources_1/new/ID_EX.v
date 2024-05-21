`timescale 1ns / 1ps
module ID_EX(
    input               clk, reset_n,
    input [31:0]        pc_in, pcPlus4_in,
    input [31:0]        DataA_in, DataB_in, 
    input [4:0]         AddrA_in, AddrB_in, AddrD_in,
    input [31:0]        imm_in, 
    input               PCSel_in, RegWEn_in,
    input               ASel_in, BSel_in,
    input [3:0]         ALUSel_in,
    input               MemRW_in, 
    input [1:0]         WBSel_in,
    input [2:0]         funct3_in,
    output reg [31:0]   pc_out, pcPlus4_out,
    output reg [31:0]   DataA_out, DataB_out,
    output reg [4:0]    AddrA_out, AddrB_out, AddrD_out,
    output reg [31:0]   imm_out, 
    output reg          PCSel_out, RegWEn_out,
    output reg          ASel_out, BSel_out,
    output reg [3:0]    ALUSel_out,
    output reg          MemRW_out, 
    output reg [1:0]    WBSel_out,
    output reg [2:0]    funct3_out
);
    
    wire [2:0]  wire_ImmSel;
    wire        wire_BrUn;

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            pc_out      <= 0;
            pcPlus4_out <= 0;
            DataA_out   <= 0;
            DataB_out   <= 0;
            AddrA_out   <= 0;
            AddrB_out   <= 0;
            AddrD_out   <= 0;
            imm_out     <= 0;
            PCSel_out   <= 0;
            RegWEn_out  <= 0;
            ASel_out    <= 0;
            BSel_out    <= 0;
            ALUSel_out  <= 0;
            MemRW_out   <= 0;
            WBSel_out   <= 0;
            funct3_out  <= 0;
        end
        else begin
            pc_out      <= pc_in;
            pcPlus4_out <= pcPlus4_in;
            DataA_out   <= DataA_in;
            DataB_out   <= DataB_in;
            AddrA_out   <= AddrA_in;
            AddrB_out   <= AddrB_in;
            AddrD_out   <= AddrD_in;
            imm_out     <= imm_in;
            PCSel_out   <= PCSel_in;
            RegWEn_out  <= RegWEn_in;
            ASel_out    <= ASel_in;
            BSel_out    <= BSel_in;
            ALUSel_out  <= ALUSel_in;
            MemRW_out   <= MemRW_in;
            WBSel_out   <= WBSel_in;
            funct3_out  <= funct3_in;
        end
    end
endmodule
