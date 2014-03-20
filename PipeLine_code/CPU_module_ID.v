`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:58:59 01/27/2014 
// Design Name: 
// Module Name:    CPU_module_ID 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CPU_module_ID(
	input clk, rst,
	input wire[31:0] Instruction_id, 
	//for branch hazard
	input wire[31:0] NextPC_id, 
	//for 3-level data forwarding
	//RegWrite_wb =1 & (RegWriteAddr_wb=RsAddr_id | RegWriteAddr_wb = RtAddr_id)
	input RegWrite_wb, 
	input wire[4:0] RegWriteAddr_wb,
	input wire[31:0] RegWriteData_wb, 
	//for data hazard
	//MemRead_ex=1 & (RegWriteAddr_ex = RsAddr_id | RegWriteAddr_ex = RtAddr_id)
	input MemRead_ex, 
	input wire[4:0] RegWriteAddr_ex,
	
	//Control Signal in ID phase for next phase
	output MemtoReg_id,	//high if the data for write back is from memory, else from alu
	output RegWrite_id,	//write reg
	output MemWrite_id, 	//write memory
	output MemRead_id,	//read memory
	output wire[10:0] ALUCode_id,
	output ALUSrcA_id,	//0: rs, 1: Sa
	output ALUSrcB_id,	//0: rt, 1: Imm
	output ALUSrcB_szextend_id,	//1: sign-extend, 0:zero-extend
	output RegDst_id,	//0: rt, 1: rd
	//insert bubble if data hazard
	output Stall,
	output PC_IFWrite,
	//for branch hazard, construct IF_Flush and newxPC
	//output  reg Z,
	output J_Valid,
	output JR_Valid,
	output wire[31:0] BranchAddr_id,
	output wire[31:0] JAddr,
	output wire[31:0] JRAddr,
	//data for ex phase
	output wire[31:0] Imm_sextend_id,	//sign-extended immediate number
	output wire[15:0] Imm_zextend_id,	//zero-extended immediate number
	output wire[4:0] Sa_id,	//zero-extended immediate number for bits shift
	output wire[4:0] RsAddr_id,
	output wire[4:0] RtAddr_id,
	output wire[4:0] RdAddr_id,
	output wire[31:0] RsData_id,
	output wire[31:0] RtData_id
	
	//for test
	//input wire[4:0] RegFilesAddr_test,
	//output wire[31:0] RegFilesData_test
);

	//parameter for ALUCode_id

	//Decoder
	wire[5:0] op = Instruction_id[31:26];
	wire[5:0] func = Instruction_id[5:0];
	wire R_INST = (op == 6'b000000);
	wire ADD = (R_INST && func == 6'b100000);
	wire ADDU = (R_INST && func == 6'b100001);
	wire SUB = (R_INST && func == 6'b100010);
	wire SUBU = (R_INST && func == 6'b100011);
	wire AND = (R_INST && func == 6'b100100);
	wire OR = (R_INST && func == 6'b100101);
	wire XOR = (R_INST && func == 6'b100110);
	wire SLT = (R_INST && func == 6'b101010);
	wire SLTU = (R_INST && func == 6'b101011);
	wire SLLV = (R_INST && func == 6'b000100);
	wire SRLV = (R_INST && func == 6'b100010);
	wire SLL = (R_INST && func == 6'b000000);
	wire SRL = (R_INST && func == 6'b000010);
	wire SRA = (R_INST && func == 6'b000011);
	wire JR = (R_INST && func == 6'b001000);
	wire J = (op == 6'b000010);
	wire JAL = (op == 6'b000011);
	wire ADDI = (op == 6'b001000);
	wire ADDIU = (op == 6'b001001);
	wire ANDI = (op == 6'b001100);
	wire ORI = (op == 6'b001101);
	wire XORI = (op == 6'b001110);
	wire SLTI = (op == 6'b001010);
	wire SLTIU = (op == 6'b001011);
	wire BEQ = (op == 6'b000100);
	wire BNE = (op == 6'b000101);
	//wire BGEZ = (op == 6'b000001);
	//wire BGTZ = (op == 6'b000111);
	//wire BLEZ = (op == 6'b000110);
	//wire BLTZ = (op == 6'b000001);
	wire LW = (op == 6'b100011);
	wire SW = (op == 6'b101011);
	//unknown encode
	wire NOR = 1'b0;
	wire SRAV = 1'b0;
	wire R_type1 = ADD | ADDU | SUB | SUBU | AND | OR | NOR | XOR | SLT | SLTU | SLLV | SRLV | SRAV;
	wire R_type2 = SLL | SRL | SRA;
	wire JR_type = JR;
	wire J_type = J;
	wire I_type = ADDI | ADDIU | ANDI | ORI | XORI | SLTI | SLTIU;
	//wire Branch = BEQ | BNE;
	

	
	
	assign RegWrite_id = LW | R_type1 | R_type2 | I_type;
	assign RegDst_id = R_type1 | R_type2;
	assign MemWrite_id = SW;
	assign MemRead_id = LW;
	assign MemtoReg_id = LW;
	assign ALUSrcA_id = R_type2;
	assign ALUSrcB_id = LW | SW | I_type;
	assign JR_Valid = JR;
	assign J_Valid = J;
	//need to be rechecked
	assign ALUSrcB_szextend_id = ~(ANDI | ORI | XORI);
	
	//signals for ALUCOde
	wire ALUSrcB_szextend = ADDI | ADDIU | SW | LW | SLTI | SLTIU;
	wire add_inst = ADD | ADDU | ADDI | ADDIU | SW | LW;
	wire and_inst = AND | ANDI;
	wire xor_inst = XOR | XORI;
	wire sub_inst = SUB | SUBU;
	wire slt_inst = SLT | SLTI;
	wire sltu_inst = SLTU | SLTIU;
	wire sll_inst = SLL | SLLV;
	wire srl_inst = SRL | SRLV;
	wire sra_inst = SRA | SRAV;
	wire beq_inst = BEQ;
	wire bne_inst = BNE;
	assign ALUCode_id = {add_inst, and_inst, xor_inst, sub_inst, 
								slt_inst, sltu_inst, sll_inst, srl_inst,  sra_inst, beq_inst, bne_inst};
								
	//BranchTest
	//the branch address calculating in ex phase is put here for branch hazard efficency
	//if Z is 0, the branch instruction is valid, thus branch hazard happen, flush
	//IF_flush = Z || J || JR, implemented in top module
	/*
	always @*
	begin
	case({BEQ, BNE, BGEZ, BGTZ, BLEZ, BLTZ})
		6'b000001 :Z = RsData_id[31]; //alu_bltz : 
		6'b000010 : Z = RsData_id[31] || ~(|RsData_id[31:0]); //alu_blez
		6'b000100 : Z = ~RsData_id[31] && (|RsData_id[31:0]);	//alu_bgtz
		6'b001000 : Z = ~RsData_id[31];	//alu_bgez
		6'b010000 : Z = |(RsData_id[31:0] ^ RtData_id[31:0]);	//alu_bne
		6'b100000 : Z = &(RsData_id[31:0] ~^ RtData_id[31:0]);	//alu_beq
		default : Z = 0;
	endcase
	end*/


	//Address Calculation
	assign BranchAddr_id = NextPC_id+(Imm_sextend_id << 2);
	assign JRAddr = RsData_id;
	assign JAddr = {NextPC_id[31:28], Instruction_id[25:0], 2'b00};
	assign Imm_sextend_id = {{16{Instruction_id[15]}}, Instruction_id[15:0]};	//sign-extend
	assign Imm_zextend_id = {16'b0, Instruction_id[15:0]};
	assign Sa_id = {27'b0, Instruction_id[10:6]};	//zero-extend

	//Register file with data forwarding
	reg[31:0] regfiles[31:0];
	assign RsAddr_id = Instruction_id[25:21];
	assign RtAddr_id = Instruction_id[20:16];
	assign RdAddr_id = Instruction_id[15:11];
	wire RsSel = RegWrite_wb&&(~(RegWriteAddr_wb==0))&&(RegWriteAddr_wb==RsAddr_id);
	wire RtSel = RegWrite_wb&&(~(RegWriteAddr_wb==0))&&(RegWriteAddr_wb==RtAddr_id);
	assign RsData_id = (RsSel ? RegWriteData_wb : ((RsAddr_id == 5'b0) ? 32'b0 : regfiles[RsAddr_id]));
	assign RtData_id = (RtSel ? RegWriteData_wb : ((RtAddr_id == 5'b0) ? 32'b0 : regfiles[RtAddr_id]));
	//regfiles would be used in two phase, and would only write in WB phase
	//as a result, the w_enable signal would be RegWrite_wb
	//it can be read and write at the same time, so if no data hazard, everything is ok
	integer i;
	always @(posedge clk)
	begin
		if (rst)
		begin			
			for (i=0; i<32; i=i+1)
			regfiles[i] <= 32'b0;
		end
		else
		if (RegWrite_wb)
			regfiles[RegWriteAddr_wb] <= RegWriteData_wb;
	end
	//Data for test
	//assign RegFilesData_test = regfiles[RegFilesAddr_test];
	
	//Hazard Detector
	assign Stall = ((RegWriteAddr_ex==RsAddr_id)||(RegWriteAddr_ex==RtAddr_id))&&MemRead_ex;
	assign PC_IFWrite = ~Stall;
	
endmodule
