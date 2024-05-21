`timescale 1ns / 1ps
module WB_PIPELINE(
    input [1:0]         WBSel_in,
    input [31:0]        DataR_in,
    input [31:0]        ALU_Result_in,
    input [31:0]        pcPlus4_in,
    output [31:0]       DataWB
);

    MUX31  DUT_WB_MUX31(
                        .SEL(WBSel_in), 
                        .A(DataR_in), 
                        .B(ALU_Result_in), 
                        .C(pcPlus4_in), 
                        .Y(DataWB)
                    ); 

endmodule
