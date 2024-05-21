`timescale 1ns / 1ps
//-----------SELECTION TABLE-------------
//  hazardSel(A/B)  *      ALU_in(A/B)  *
//      00          *       regfile     *       //default
//      01          *       alu_ma      *
//      10          *       ma_wb       *
//      11          *       ma_wb_hold  *
//---------------------------------------  
module HazardUnit(
    input           reset_n,
    input [4:0]     RS1_EX, 
                    RS2_EX, 
                    RD_MA, 
                    RD_WB,
                    //RD_WB2,             
    input           RegWEn_MA,
                    RegWEn_WB,
                    //RegWEn_WB2,
    output reg[1:0] hazardSelA, 
                    hazardSelB
    );
    always @(*) begin
        hazardSelA = 2'b00;
        hazardSelB = 2'b00;
        if(!reset_n) begin
            hazardSelA = 2'b00;
            hazardSelB = 2'b00;
        end
        else begin
            if((RegWEn_MA == 1'b1) && (RD_MA == RS1_EX))
                hazardSelA = 2'b01;
            else if((RegWEn_WB == 1'b1) && (RD_WB == RS1_EX))
                hazardSelA = 2'b10;
//            else if((RegWEn_WB2 == 1'b1) && (RD_WB2 == RS1_EX))
//                hazardSelA = 2'b11;
            if((RegWEn_MA == 1'b1) && (RD_MA == RS2_EX))
                hazardSelB = 2'b01;
            else if((RegWEn_WB == 1'b1) && (RD_WB == RS2_EX))
                hazardSelB = 2'b10;
//            else if((RegWEn_WB2 == 1'b1) && (RD_WB2 == RS2_EX))
//                hazardSelB = 2'b11;
        end
    end
endmodule