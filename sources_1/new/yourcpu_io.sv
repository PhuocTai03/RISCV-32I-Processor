`timescale 1ns / 1ps
interface yourcpu_io(input bit clk);
    logic           reset_n;
    logic [31:0]    addr;
    logic [31:0]    data;
    clocking cb @(posedge clk);
        output reset_n;
        output addr;
        output data;
    endclocking
    modport tb(clocking cb, output reset_n, addr, data);
endinterface
