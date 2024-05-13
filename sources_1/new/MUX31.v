`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 09:23:54 PM
// Design Name: 
// Module Name: MUX31
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module MUX31 (SEL, A, B, C, Y);
    input   [31:0]  A, B, C;
    input   [1:0]   SEL;
    output  [31:0]  Y;

    assign          Y = (SEL == 2'b00)?A:(SEL == 2'b01)?B:C;
endmodule
