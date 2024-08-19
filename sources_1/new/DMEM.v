module DMEM(clk, MemRW, funct3, addr, DataW, DataR);
    input           clk, MemRW;
    input [2:0]     funct3;
    input [9:0]     addr;
    input [31:0]    DataW;
    output [31:0]   DataR;
    
    reg [31:0]      data_temp;
    reg [7:0]      SRAM_Cell [4095:0];
    integer i;
    initial begin
        for(i = 0; i < 4096; i = i + 1)
            SRAM_Cell[i] <= 0;
    end
	always@(posedge clk) begin
        if(MemRW) begin
            case(funct3)
                3'b000: SRAM_Cell[addr] <= DataW[7:0];      //sb
                3'b001: begin
                    SRAM_Cell[addr] <= DataW[7:0];          //sh
                    SRAM_Cell[addr + 1] <= DataW[15:8];
                end
                3'b010: begin
                    SRAM_Cell[addr]     <= DataW[7:0];      //sw
                    SRAM_Cell[addr + 1] <= DataW[15:8];
                    SRAM_Cell[addr + 2] <= DataW[23:16];
                    SRAM_Cell[addr + 3] <= DataW[31:24];
                end
            endcase
        end
     end
     always @(*) begin
            case(funct3)
                3'b000: data_temp <= {{25{SRAM_Cell[addr][7]}}, SRAM_Cell[addr][6:0]};                              //lb
                3'b001: data_temp <= {{17{SRAM_Cell[addr + 1][7]}}, SRAM_Cell[addr + 1][6:0], SRAM_Cell[addr]};     //lh
                3'b010: data_temp <= {SRAM_Cell[addr +3], SRAM_Cell[addr +2], SRAM_Cell[addr +1], SRAM_Cell[addr]}; //lw                                   //lw
                3'b100: data_temp <= {24'b0, SRAM_Cell[addr]};                                                      //lbu
                3'b101: data_temp <= {16'b0, SRAM_Cell[addr + 1], SRAM_Cell[addr]};                                 //lhu
            endcase
     end
	assign DataR = data_temp;
endmodule