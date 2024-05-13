`timescale 1ns / 1ps
module MA_WB(
    input               clk, reset_n,
    input               RegWEn_in,  
    input [4:0]         AddrD_in, 
    input [31:0]        DataWB_in, 
    
    output reg          RegWEn_out,
    output [4:0]        AddrD_out,
    output reg [31:0]   DataWB_out);
    
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            RegWEn_out      <= 0;
            DataWB_out      <= 0;
        end
        else begin
            RegWEn_out      <= RegWEn_in;
            DataWB_out      <= DataWB_in;
        end
    end
endmodule
