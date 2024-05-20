`timescale 1ns / 1ps 
module MA_WB(
    input               clk, reset_n,
    input               RegWEn_in,
    input [1:0]         WBSel_in,  
    input [4:0]         AddrD_in, 
    input [31:0]        DataR_in,
    input [31:0]        ALU_Result_in,
    input [31:0]        pcPlus4_in,
    
    output reg          RegWEn_out,
    output reg [1:0]    WBSel_out,
    output reg [4:0]    AddrD_out,
    output reg [31:0]   DataR_out,    
    output reg [31:0]   ALU_Result_out,
    output reg [31:0]   pcPlus4_out
    );
    
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            RegWEn_out      <= 0;
            WBSel_out       <= 0;
            AddrD_out       <= 0;
            DataR_out       <= 0;
            ALU_Result_out  <= 0;
            pcPlus4_out     <= 0;
        end
        else begin
            RegWEn_out      <= RegWEn_in;
            WBSel_out       <= WBSel_in;
            AddrD_out       <= AddrD_in;
            DataR_out       <= DataR_in;
            ALU_Result_out  <= ALU_Result_in;
            pcPlus4_out     <= pcPlus4_in;
        end
    end
endmodule
