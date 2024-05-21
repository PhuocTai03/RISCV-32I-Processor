module IMEM(
    input [31:0]    addr, 
                    tb_addr, 
                    tb_inst,
    output [31:0]   inst
);

    reg [31:0] RAM [1023:0];
    always @(*) RAM[tb_addr] <= tb_inst;
    
    //initial $readmemh("imem.mem", RAM);
    assign inst = RAM[addr];
endmodule 