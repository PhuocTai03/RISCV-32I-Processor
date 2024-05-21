`timescale 1ns / 1ps
module BranchComp(
    input [31:0]    A, B,
    input           BrUn,
    output reg      BrEq, BrLT, BrGE
);  
    always @(*) begin
        BrEq = (A == B);
        if(BrUn)
            BrLT = (A < B);
        else
            BrLT = ($signed(A) < $signed(B));
        BrGE = !BrLT;
    end
endmodule
