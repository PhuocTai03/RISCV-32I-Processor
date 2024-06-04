`timescale 1ns / 1ps
//-----------SELECTION TABLE-------------
//  fwdSel(A/B)     *      ALU_in(A/B)  *
//      00          *       regfile     *       //default
//      01          *       alu_ma      *
//      10          *       ma_wb       *
//      11          *       32'bx       *
//---------------------------------------  
module FowardingUnit(
    input           reset_n,
    input [4:0]     RS1_EX, 
                    RS2_EX, 
                    RD_MA, 
                    RD_WB,
    input           RegWEn_MA,
                    RegWEn_WB,
    output reg[1:0] fwdSelA, 
                    fwdSelB
    );
    always @(*) begin
        fwdSelA = 2'b00;
        fwdSelB = 2'b00;
        if(!reset_n) begin
            fwdSelA = 2'b00;
            fwdSelB = 2'b00;
        end
        else begin
            if((RegWEn_MA == 1'b1) && (RD_MA == RS1_EX) && (RD_MA != 0))
                fwdSelA = 2'b01;
            else if((RegWEn_WB == 1'b1) && (RD_WB == RS1_EX) && (RD_WB != 0))
                fwdSelA = 2'b10;
            if((RegWEn_MA == 1'b1) && (RD_MA == RS2_EX) && (RD_MA != 0))
                fwdSelB = 2'b01;
            else if((RegWEn_WB == 1'b1) && (RD_WB == RS2_EX) && (RD_WB != 0))
                fwdSelB = 2'b10;
        end
    end
endmodule