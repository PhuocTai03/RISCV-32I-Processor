`timescale 1ns / 1ps

module yourcpu_test_top_pipeline();
    parameter simulation_cycle = 100;
    bit SystemClock;
    
    yourcpu_io  top_io  (SystemClock);
    test        t       (top_io.tb);
    
    yourcpu_pipeline dut    (   
                                .reset_n(top_io.reset_n), 
                                .clk    (SystemClock), 
                                .tb_addr(top_io.addr), 
                                .tb_inst(top_io.data)
                            );
    
    initial begin
        SystemClock = 0;
        forever begin
            #(simulation_cycle/2)
            SystemClock = !SystemClock;
        end
    end
endmodule
