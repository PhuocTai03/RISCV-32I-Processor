`timescale 1ns / 1ps
module ADDER(
	input [31:0]   A, 
	               B,
	output [31:0]  Y
);
	assign Y = A + B;
endmodule
