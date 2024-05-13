`timescale 1ns / 1ps
`ifndef PACKET
`define PACKET
class Packet;
    rand bit [6:0]  opcode;
    rand bit [4:0]  rs1, rs2, rd;
    rand bit [11:0] imm;
    rand bit [2:0]  funct3;
    rand bit [6:0]  funct7;
    string          name;
    bit [31:0]      inst;
    constraint opcode_constraint {opcode inside {7'b0010011, 7'b0110011};}
    constraint funct7_constraint1 {
        if(opcode == 7'b0110011) 
            if((funct3 != 3'b000) && (funct3 != 3'b101))
                funct7 == 7'b0000000;
            else
                funct7 inside {7'b0100000, 7'b0000000};
        else 
            if(funct3 == 3'b001)
                imm inside {[0:31]}; //slli
            else if(funct3 == 3'b101)
                imm[11:5] inside {7'b0000000, 7'b0100000}; 
    }
    extern function new(string name);
    extern function gen();
    extern function void display(string prefix = "NOTE");
    extern function void setInst(bit [31:0] newInst);
endclass

function Packet::new(string name);
    this.name <= name;
endfunction

function Packet::gen();
    if(this.opcode == 7'b0010011)
        this.inst <= {this.imm, this.rs1, this.funct3, this.rd, this.opcode};
    else
        this.inst <= {this.funct7, this.rs2, this.rs1, this.funct3, this.rd, this.opcode};
endfunction

function void Packet::display(string prefix = "NOTE");
    //$display("%s: Packet displayed", prefix);
    if(this.opcode == 7'b0010011) begin
        $display("Type: I - Name: %s", this.name);
        $display("Instruction: %h", this.inst);
    end
    else begin
        $display("Type: R - Name: %s", this.name);
        $display("Instruction: %h", this.inst);
    end
endfunction

function void Packet::setInst(bit [31:0] newInst);
    this.inst = newInst;
endfunction
`endif
