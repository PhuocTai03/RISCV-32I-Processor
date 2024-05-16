`timescale 1ns / 1ps
module HazardUnit(
    input           reset_n,
    input [4:0]     RS1_EX, RS2_EX, RD_MA, RD_WB,
    input           RegWEn_MA, RegWEn_WB,
    output [1:0]    hazardSelA, hazardSelB
    );
    
        assign hazardSelA = 0;
        assign hazardSelB = 0;
    assign          hazardSelA = (!reset_n)?2'b00:
                                 ((RegWEn_MA == 1'b1) & (RD_MA == RS1_EX))?2'b01:
                                 ((RegWEn_WB == 1'b1) & (RD_WB == RS1_EX))?2'b10:2'b00;
    assign          hazardSelB = (!reset_n)?2'b00:
                                 ((RegWEn_MA == 1'b1) & (RD_MA == RS2_EX))?2'b01:
                                 ((RegWEn_WB == 1'b1) & (RD_WB == RS2_EX))?2'b10:2'b00;
endmodule