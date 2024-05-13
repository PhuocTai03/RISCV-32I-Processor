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
        pkts_generated  = 27;
        inst_arr[0]     = 32'hxxxxxxxx;
        inst_arr[1]     = 32'h00300093; //addi x1, x0, 3
        inst_arr[2]     = 32'h00108113; //addi x2, x1, 1
        inst_arr[3]     = 32'h401101b3; //sub x3, x2, x1
        inst_arr[4]     = 32'h0020c233;
        inst_arr[5]     = 32'h0020e2b3;
        inst_arr[6]     = 32'h0020f333;
        inst_arr[7]     = 32'h003113b3;
        inst_arr[8]     = 32'h00315433;
        inst_arr[9]     = 32'hffa48493;
        inst_arr[10]    = 32'h4034d533;
        inst_arr[11]    = 32'h0084a5b3;
        inst_arr[12]    = 32'h0084b5b3;
        inst_arr[13]    = 32'h0055c613;
        inst_arr[14]    = 32'h00766693;
        inst_arr[15]    = 32'h0086f713;
        inst_arr[16]    = 32'h00161793;
        inst_arr[17]    = 32'h00c20463;
        inst_arr[18]    = 32'h00d20463;
        inst_arr[19]    = 32'h0017d813;
        inst_arr[20]    = 32'h4014d893;
        inst_arr[21]    = 32'h0028a913;
        inst_arr[22]    = 32'h00f8b993; //sltiu x19, x17, 15
        inst_arr[23]    = 32'h3e898b93; //addi x23, x19, 1000
        inst_arr[24]    = 32'h3f798423; //sb x23, 1000(x19)
        inst_arr[25]    = 32'hff28dae3; //bge x17, x18, -12
        inst_arr[26]    = 32'hff27dae3; //bge x15, x18, -12 => loop
        inst_arr[27]    = 32'h00010b17;
        inst_arr[28]    = 32'h00438ae7;
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
            yourcpu_io.addr <= i;
            yourcpu_io.data <= inst_arr[i];
        end
    endtask
    task driver2();
        $writememh("D:\\Vivado\\CE409_Labs\\Lab45\\CE409_Lab45_21521391_DaoPhuocTai\\CE409_Lab45_21521391_DaoPhuocTai.srcs\\sources_1\\new\\imem.mem", inst_arr);
    endtask
endprogram: test
`endif