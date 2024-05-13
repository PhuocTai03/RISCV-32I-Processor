module ALU (A, B, ALUControl, ALUResult);
	input [3:0]        ALUControl;
	input [31:0]       A, B;
	output reg [31:0]  ALUResult;

	always @(ALUControl or A or B) begin
		case(ALUControl)
			4'b0000: ALUResult = A & B;
			4'b0001: ALUResult = A | B;
			4'b0010: ALUResult = A + B;
			4'b0011: ALUResult = A - B;
			4'b0100: ALUResult = ($signed(A) < $signed(B))?32'd1:32'd0;
			4'b0101: ALUResult = !(A|B);
			4'b0110: ALUResult = B << 12;
			4'b0111: ALUResult = A ^ B;
			4'b1000: ALUResult = A << B[4:0];
			4'b1001: ALUResult = A >> B[4:0]; 
			4'b1010: ALUResult = A + (B << 12); //auipc
			4'b1011: ALUResult = ($unsigned(A) < $unsigned(B))?32'd1:32'd0;
			4'b1100: begin
			     if (A[31] == 1'b0)
                    ALUResult = A >> B[4:0];
                 else
                    ALUResult = ~((~A) >> B[4:0]); //sra
			end
			default: ALUResult = 0;
		endcase
	end
endmodule