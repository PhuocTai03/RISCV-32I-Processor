`timescale 1ns / 1ps
module IF_ID(clk, reset_n, inst_in, pc_in, pcPlus4_in, inst_out, pc_out, pcPlus4_out);
    input               clk;
    input               reset_n;
    input [31:0]        inst_in, pc_in, pcPlus4_in;
    output reg [31:0]   inst_out, pc_out, pcPlus4_out;

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            pc_out      <= 0;
            inst_out    <= 0;
            pcPlus4_out <= 0;
        end
        else begin
             pc_out     <= pc_in;
             inst_out   <= inst_in;
             pcPlus4_out<= pcPlus4_in;
        end 
    end
endmodule
