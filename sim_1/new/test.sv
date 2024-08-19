`timescale 1ns / 1ps
`ifndef TEST_SV
`define TEST_SV
`include "Packet.sv"

program automatic test (yourcpu_io.tb yourcpu_io);
    integer file_descriptor;
    logic [31:0] inst_arr[1023:0];    
    static int pkts_generated = 0;    

    initial begin
        reset();
        //gen();
        load_inst();
        driver1();
        #4000 $finish;
    end
    task load_inst();
        pkts_generated  = 16;
        //reset
        inst_arr[0]     = 32'hxxxxxxxx;
        inst_arr[1]     = 32'h0000b137;     //lui x2, 0xa (+1)
        inst_arr[2]     = 32'haa010113;     //addi x2, x2, 0xaa0 (-4096)
        inst_arr[3]     = 32'haaaa0237;     //lui x4, 0xaaaa0
        inst_arr[4]     = 32'h000001b7;     //lui x3, 0x0
        inst_arr[5]     = 32'h0101e193;     //ori x3, x3, 0x10
        
        //loop:
        inst_arr[6]     = 32'h00418193;     //addi x3, x3, 0x4
        inst_arr[7]     = 32'h00110113;     //addi x2, x2, 0x1
        inst_arr[8]     = 32'h0000a023;     //sw x0, 0(x3)
        inst_arr[9]     = 32'h00219123;     //sh x2, 2(x3)
        inst_arr[10]    = 32'h0001a083;     //lw x1, 0(x3)
        inst_arr[11]    = 32'h00000013;     //nop
        inst_arr[12]    = 32'h00000013;     //nop
        inst_arr[13]    = 32'hfe4094e3;     //bne x1, x4, -24	
        inst_arr[14]    = 32'h00000013;     //nop
        inst_arr[15]    = 32'h00000013;     //nop
        //done:
        inst_arr[16]     = 32'h0000026f;     //jal x4, done
        
    endtask
    
    task reset();
        yourcpu_io.reset_n = 1'b0;
        #100
        yourcpu_io.reset_n <= 1'b1;
    endtask
    
    task gen();
        Packet pkt2send;
        repeat (5) begin
            pkt2send = new($sformatf("Packet[%0d]", pkts_generated));
            if(!pkt2send.randomize()) begin
                $display("Error: Randomization failed");
                $finish; 
            end
            pkt2send.gen();
            pkt2send.display();
            inst_arr[pkts_generated] = pkt2send.inst;
            pkts_generated = pkts_generated + 1;
        end
    endtask
    
    task driver1();
        integer i;
        for (i = 0; i < pkts_generated; i = i + 1) begin
            $display("driver[%0d]", i);
            #1
            yourcpu_io.addr = i;
            yourcpu_io.data = inst_arr[i];
        end
    endtask
    task driver2();
        $writememh("D:\\Vivado\\CE409_Labs\\Lab45\\CE409_Lab45_21521391_DaoPhuocTai\\CE409_Lab45_21521391_DaoPhuocTai.srcs\\sources_1\\new\\imem.mem", inst_arr);
    endtask
endprogram: test
`endif