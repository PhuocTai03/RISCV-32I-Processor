module CONTROLLER(PCSel, inst, ImmSel, RegWEn, BrUn, BrEq, BrLT, BrGE, ASel, BSel, ALUSel, MemRW, WBSel);
    parameter R_type        = 7'b0110011;
    parameter I_type        = 7'b0010011;
    parameter I_type_load   = 7'b0000011;
    parameter I_type_jalr   = 7'b1100111;
    parameter S_type        = 7'b0100011;
    parameter B_type        = 7'b1100011;
    parameter J_type        = 7'b1101111;
    parameter U_type_lui    = 7'b0110111;
    parameter U_type_auipc  = 7'b0010111;
    
    input          BrEq, BrLT, BrGE;
	input  [31:0]  inst;
	output         PCSel, RegWEn, BrUn, ASel, BSel, MemRW;
	output [1:0]   WBSel;
	output [2:0]   ImmSel;
	output [3:0]   ALUSel;
	
	wire [6:0]     opcode;
	wire [2:0]     funct3;
	wire [6:0]     funct7;
	reg  [14:0]    controlSignal;

    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];
    
	always @(*) begin
		case(opcode)
				R_type: case(funct3)
				    3'b000: case(funct7)
				        7'b0000000: controlSignal <= 15'b0xxx1x000010001; //add
				        7'b0100000: controlSignal <= 15'b0xxx1x000011001; //sub
				            endcase
				    3'b001:         controlSignal <= 15'b0xxx1x001000001; //sll
				    3'b010:         controlSignal <= 15'b0xxx1x000100001; //slt
				    3'b011:         controlSignal <= 15'b0xxx1x001011001; //sltu
				    3'b100:         controlSignal <= 15'b0xxx1x000111001; //xor
				    3'b101: case(funct7)
				        7'b0000000: controlSignal <= 15'b0xxx1x001001001; //srl
				        7'b0100000: controlSignal <= 15'b0xxx1x001100001; //sra
				            endcase
				    3'b110:         controlSignal <= 15'b0xxx1x000001001; //or
				    3'b111:         controlSignal <= 15'b0xxx1x000000001; //and
				endcase
				I_type:     case(funct3)
				    3'b000:         controlSignal <= 15'b00001x010010001; //addi
				    3'b001:         controlSignal <= 15'b00001x011000001; //slli
				    3'b010:         controlSignal <= 15'b00001x010100001; //slti
				    3'b011:         controlSignal <= 15'b00001x011011001; //sltiu
				    3'b100:         controlSignal <= 15'b00001x010111001; //xori
				    3'b101: case(inst[31:25])
				        7'b0000000: controlSignal <= 15'b00001x011001001; //srli
				        7'b0100000: controlSignal <= 15'b00001x011100001; //srai
				            endcase
				    3'b110:         controlSignal <= 15'b00001x010001001; //ori
				    3'b111:         controlSignal <= 15'b00001x010000001; //andi
				endcase
				I_type_load: case(funct3)
				    3'b000:         controlSignal <= 15'b00001x010010000; //lb
				    3'b001:         controlSignal <= 15'b00001x010010000; //lh
				    3'b010:         controlSignal <= 15'b00001x010010000; //lw
				    3'b100:         controlSignal <= 15'b00001x010010000; //lbu
				    3'b101:         controlSignal <= 15'b00001x010010000; //lhu
				endcase
				I_type_jalr:        controlSignal <= 15'b10001x010010010; //jarl
				S_type:     case(funct3)
				    3'b000:         controlSignal <= 15'b00100x0100101xx; //sb
				    3'b001:         controlSignal <= 15'b00100x0100101xx; //sh
				    3'b010:         controlSignal <= 15'b00100x0100101xx; //sw
				endcase
				B_type:     case(funct3)
				    3'b000:         controlSignal <= { BrEq, 14'b100001100100xx}; //beq 
				    3'b001:         controlSignal <= {!BrEq, 14'b100001100100xx}; //bne
				    3'b100:         controlSignal <= { BrLT, 14'b100001100100xx}; //blt
				    3'b101:         controlSignal <= { BrGE, 14'b100001100100xx}; //bge
				    3'b110:         controlSignal <= { BrLT, 14'b100011100100xx}; //bltu
				    3'b111:         controlSignal <= {!BrLT, 14'b100011100100xx}; //bgeu
				endcase
				J_type:             controlSignal <= 15'b10011x110010010; //jal
				U_type_lui:         controlSignal <= 15'b00111x010110001; //lui
				U_type_auipc:       controlSignal <= 15'b00111x111010001; //auipc
				
				default:
					controlSignal <= 15'bxxxxxxxxxxxxxxx; 
		endcase
	end
	assign {PCSel, ImmSel, RegWEn, BrUn, ASel, BSel, ALUSel, MemRW, WBSel} = controlSignal;
endmodule
