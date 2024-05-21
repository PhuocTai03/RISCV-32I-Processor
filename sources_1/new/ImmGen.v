module ImmGen(
	input [24:0]   dataIn,
	input [2:0]    ImmSel,
	output [31:0]  dataOut
);
	reg [31:0]     immGenOut;
	always @(dataIn or ImmSel) begin
        case (ImmSel)
            //I - type
            3'b000: immGenOut <= {{21{dataIn[24]}}, dataIn[23:13]};
            
            //J - type
            3'b001: immGenOut <= {{12{dataIn[24]}}, dataIn[12:5], dataIn[13], dataIn[23:14], 1'b0};
            
            //S - type
            3'b010: immGenOut <= {{21{dataIn[24]}}, dataIn[23:18], dataIn[4:0]};
            
            //U - type
            3'b011: immGenOut <= {{13{dataIn[24]}}, dataIn[23:5]};
            
            //B - type
            3'b100: immGenOut <= {{20{dataIn[24]}}, dataIn[0], dataIn[23:18], dataIn[4:1] ,1'b0};
            
            default: immGenOut <= 32'bx;
        endcase
	end
	assign dataOut = immGenOut;
endmodule