`timescale 1ns / 1ps
module WB_PIPELINE(
    input               clk,
    input               reset_n,
    input               RegWEn_in,
    input [1:0]         WBSel_in,
    input [31:0]        DataR_in,
    input [31:0]        ALU_Result_in,
    input [31:0]        pcPlus4_in,
    input [4:0]         AddrD_in,
    ///
    output reg          RegWEn_out,    //luu tin hieu RegWEn khi chua kip write-back vao register files
    output reg [4:0]    AddrD_out,     //luu dia chi khi chua kip write-back vao register files
    output reg [31:0]   DataWB_out,    //luu gia tri khi chua kip write-back vao register files
    output [31:0]       DataWB         //gia tri duoc xu ly ngay lap tuc => phuc vu cho hazard forwarding
    );
    wire [31:0]         wire_DataWB;
    assign              DataWB = wire_DataWB;
    MUX31  DUT_WB_MUX31(
                        .SEL(WBSel_in), 
                        .A(DataR_in), 
                        .B(ALU_Result_in), 
                        .C(pcPlus4_in), 
                        .Y(wire_DataWB)
                    ); 
    always @(posedge clk) begin
        if(!reset_n) begin
            RegWEn_out  <= 0;
            AddrD_out   <= 0;
            DataWB_out  <= 0;
        end
        else begin
            RegWEn_out  <= RegWEn_in;
            AddrD_out   <= AddrD_in;
            DataWB_out  <= wire_DataWB;
        end
    end
endmodule
