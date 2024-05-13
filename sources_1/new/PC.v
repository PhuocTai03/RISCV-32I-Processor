module PC(clk, reset_n, D, Q);
	input clk, reset_n;
	input [31:0] D;
	output reg [31:0] Q;

	always @(posedge clk) begin
		if(!reset_n)
			Q <= 0;
		else
			Q <= D;
	end
endmodule