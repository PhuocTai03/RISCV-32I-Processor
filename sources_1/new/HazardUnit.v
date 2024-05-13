`timescale 1ns / 1ps
module HazardUnit(
    input           reset_n,
    input [4:0]     RS1_EX, RS2_EX, RD_MA, RD_WB,
    input           RegWEn_MA, RegWEn_WB,
    output [1:0]    hazardSelA, hazardSelB
    );
    
    assign          hazardSelA = (!reset_n)?2'b00:
                                 ((RegWEn_MA == 1'b1) & (RD_MA == RS1_EX))?2'b01:
                                 ((RegWEn_WB == 1'b1) & (RD_WB == RS1_EX))?2'b10:2'b00;
    assign          hazardSelB = (!reset_n)?2'b00:
                                 ((RegWEn_MA == 1'b1) & (RD_MA == RS2_EX))?2'b01:
                                 ((RegWEn_WB == 1'b1) & (RD_WB == RS2_EX))?2'b10:2'b00;
endmodule


//module Hazard_unit(
//    input reset_n, RegWriteM, RegWriteW,RegWriteW_delay,
//    input [4:0] RD_M, RD_W,RD_W_delay, Rs1_E, Rs2_E,
//    output [1:0] ForwardAE, ForwardBE );
  
    
    
//    assign ForwardAE = (reset_n == 1'b0) ? 2'b00 : 
//                       ((RegWriteM == 1'b1)  & (RD_M == Rs1_E)) ? 2'b10 :
//                       ((RegWriteW == 1'b1)  & (RD_W == Rs1_E)) ? 2'b01 : 
//                       ((RegWriteW_delay == 1'b1)  & (RD_W_delay == Rs1_E)) ? 2'b11 :2'b00;
                       
//    assign ForwardBE = (reset_n == 1'b0) ? 2'b00 : 
//                       ((RegWriteM == 1'b1)  & (RD_M == Rs2_E)) ? 2'b10 :
//                       ((RegWriteW == 1'b1)  & (RD_W == Rs2_E)) ? 2'b01 : 
//                       ((RegWriteW_delay == 1'b1)  & (RD_W_delay == Rs2_E)) ? 2'b11 :2'b00;

//endmodule