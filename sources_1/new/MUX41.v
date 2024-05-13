`timescale 1ns / 1ps
module MUX41 (SEL, A, B, C, D, Y);
    input   [31:0]  A, B, C, D;
    input   [1:0]   SEL;
    output  [31:0]  Y;

    assign          Y = (SEL == 2'b00)?A:(SEL == 2'b01)?B:(SEL == 2'b10)?C:D;
endmodule

