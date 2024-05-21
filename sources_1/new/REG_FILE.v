`timescale 1ns / 1ps
module REG_FILE(
	input          clk, 
	               reset_n,
	               RegWEn,
	input [4:0]    AddrA,
	input [4:0]    AddrB,
	input [4:0]    AddrD,
	input [31:0]   DataD,

	output [31:0]  DataA,
	output [31:0]  DataB
    );
	reg [31:0]     registers [31:0];
	integer i;
 	always @(*) begin
        if(!reset_n)
            for(i = 0; i < 32; i = i + 1)
                registers[i] <= 0;
        else if(RegWEn == 1)
            registers[AddrD] <= DataD;
    end
	assign DataA = registers[AddrA];
	assign DataB = registers[AddrB];
endmodule