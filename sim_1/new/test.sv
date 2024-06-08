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
        gen();
        //load_inst();
        driver1();
        #4000 $finish;
    end
    task load_inst();
        pkts_generated  = 24;
        //reset
        inst_arr[0]     = 32'hxxxxxxxx;
        
        //addi x1, x0, 3		x1 = 3
        inst_arr[1] = 32'h00300093;
        
        //addi x2, x1, 1		x2 = 4
        inst_arr[2] = 32'h00108113;
        
        //sub x3, x2, x1		x3 = 1
        inst_arr[3] = 32'h401101b3;
        
        //xor x4, x1, x2		x4 = 7	
        inst_arr[4] = 32'h0020c233;
        
        //sw   x3, 20(x1)		M[23] = 1
        inst_arr[5] = 32'h0030aa23;
        
        //lw   x5, 20(x1)		x5 = 1
        inst_arr[6] = 32'h0140a283;
        
        //addi x0, x0, 0		nop
        inst_arr[7] = 32'h00000013;
        
        //add  x6, x5, x1		x6 = 4 =>stall
        inst_arr[8] = 32'h00128333;
        
        //beq x1, x2, 16		not jump
        inst_arr[9] = 32'h01208463;
        
        //addi x0, x0, 0		nop
        inst_arr[10] = 32'h00000013;
        
        //addi x0, x0, 0		nop
        inst_arr[11] = 32'h00000013;
        
        //addi x7, x2,  1		x7 = 5
        inst_arr[12] = 32'h00110393;
        
        //addi x8, x7, 1 		x8 = 6 x7 = 5, x8 = 6 => ?úng
        inst_arr[13] = 32'h00138413;
                
        //beq x3, x5, 16		jump
        inst_arr[14] = 32'h00518863;
        
        //addi x0, x0, 0		nop
        inst_arr[15] = 32'h00000013;
        
        //addi x0, x0, 0		nop
        inst_arr[16] = 32'h00000013;
        
        //addi x9, x8, 1		skip
        inst_arr[17] = 32'h00140493;
                
        //addi x10, x9, 1		x10 = 1 x9 = 0, x10 = 1 => ?úng
        inst_arr[18] = 32'h00148513;		

        //addi x11, x10, 1      x11 = 2
        inst_arr[19] = 32'h00150593;
        
        //addi x12, x11, 1      x12 = 3
        inst_arr[20] = 32'h00158613;
        
        //addi x13, x12, 1      x13 = 4
        inst_arr[21] = 32'h00160693;
        
        //addi x14, x13, 1      x14 = 5
        inst_arr[22] = 32'h00168713;
        
        //addi x15, x14, 1      x15 = 6
        inst_arr[23] = 32'h00170793;
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