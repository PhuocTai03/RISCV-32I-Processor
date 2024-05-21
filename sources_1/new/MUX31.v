`timescale 1ns / 1ps
module MUX31 (SEL, A, B, C, Y);
    input   [31:0]  A, B, C;
    input   [1:0]   SEL;
    output  [31:0]  Y;

    assign          Y = (SEL == 2'b00)?A:(SEL == 2'b01)?B:(SEL == 2'b10)?C:32'bx;
endmodule
