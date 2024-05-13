module DMEM(clk, MemRW, funct3, addr, DataW, DataR);
    input           clk, MemRW;
    input [2:0]     funct3;
    input [9:0]     addr;
    input [31:0]    DataW;
    output [31:0]   DataR;
    
    reg [31:0]      data_temp;
    reg [31:0]      SRAM_Cell [1023:0];
    
	always@(posedge clk) begin
        if(MemRW) begin
            case(funct3)
                3'b000: SRAM_Cell[addr] <= DataW[7:0];  //sb
                3'b001: SRAM_Cell[addr] <= DataW[15:0]; //sh
                3'b010: SRAM_Cell[addr] <= DataW;       //sw
            endcase
        end
        else begin
            case(funct3)
                3'b000: data_temp <= {{25{SRAM_Cell[addr][7]}}, SRAM_Cell[addr][6:0]};    //lb
                3'b001: data_temp <= {{17{SRAM_Cell[addr][15]}}, SRAM_Cell[addr][14:0]};  //lh
                3'b010: data_temp <= SRAM_Cell[addr];                                   //lw
                3'b100: data_temp <= {24'b0, SRAM_Cell[addr][7:0]};                  //lbu
                3'b101: data_temp <= {16'b0, SRAM_Cell[addr][15:0]};                 //lhu
            endcase
        end
    end
	assign DataR = data_temp;
endmodule