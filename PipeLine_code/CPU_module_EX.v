`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:30:00 01/27/2014 
// Design Name: 
// Module Name:    CPU_module_EX 
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
module CPU_module_EX(
	//1 level data forwarding(ex)
	//RegWrite_mem = 1& (RegWriteAddr_men=RsAddr_ex | RegWriteAddr_mem = RtAddr_ex)
	input wire[4:0] RegWriteAddr_mem,
	input RegWrite_mem,
	input wire[31:0] ALUResult_mem,
	//2 level data forwarding(men)
	//RegWrite_wb = 1&(RegWriteAddr_wb = RsAddr_ex | RegWriteAddr_wb = RtAddr_ex) & not ex
	input wire[4:0] RegWriteAddr_wb,
	input RegWrite_wb,
	input wire[31:0] RegWriteData_wb,
	// 1\2 level data forwarding
	input wire[4:0] RsAddr_ex,
	input wire[4:0] RtAddr_ex,
	
	//RdAddr_ex and Rt_Addr_ex, selected by RegDst_ex
	//transfer to next phase, become RegWriteAddr_ex
	input wire[4:0] RdAddr_ex,
	input RegDst_ex,
	
	//data for next phase
	//other signals, MemWrite, for example, would transfer directly from ID_EX reg
	//to EX_MEM reg
	output wire[4:0] RegWriteAddr_ex,
	output reg[31:0] ALUResult_ex,	//applied as rd data or memory address
	output wire[31:0] MemWriteData_ex,	//if sw, equal to B
	
	//signal from ID
	input wire[10:0] ALUCode_ex,
	input ALUSrcA_ex,
	input ALUSrcB_ex,
	input ALUSrcB_szextend_ex,
	
	//data from ID
	input wire[31:0] Imm_sextend_ex,
	input wire[15:0] Imm_zextend_ex,
	input wire[4:0] Sa_ex,
	input wire[31:0] RsData_ex,
	input wire[31:0] RtData_ex,
	
	output wire Z
	//for test
	//output wire[31:0] ALU_A,
	//output wire[31:0] ALU_B
	
);

	parameter ADD = 11'b10000000000;
	parameter AND = 11'b01000000000;
	parameter XOR = 11'b00100000000;
	parameter SUB = 11'b00010000000;
	parameter SLT = 11'b00001000000;
	parameter SLTU = 11'b00000100000;
	parameter SLL = 11'b00000010000;
	parameter SRL = 11'b00000001000;
	parameter SRA = 11'b00000000100;
	parameter BEQ = 11'b00000000010;
	parameter BNE = 11'b00000000001;
	wire[31:0] ALU_A, ALU_B;
	wire[1:0] ForwardA, ForwardB;
	//data forwarding
	assign ForwardA[0] = RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_mem!=RsAddr_ex)&&(RegWriteAddr_wb==RsAddr_ex);
	assign ForwardA[1] = RegWrite_mem&&(RegWriteAddr_mem!=0)&&(RegWriteAddr_mem==RsAddr_ex);
	assign ForwardB[0] = RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_mem!=RtAddr_ex)&&(RegWriteAddr_wb==RtAddr_ex);
	assign ForwardB[1] = RegWrite_mem&&(RegWriteAddr_mem!=0)&&(RegWriteAddr_mem==RtAddr_ex);
	wire[31:0] A = (ForwardA == 2'b00) ? RsData_ex : ((ForwardA == 2'b01) ? RegWriteData_wb : ALUResult_mem);
	wire[31:0] B = (ForwardB == 2'b00) ? RtData_ex : ((ForwardB == 2'b01) ? RegWriteData_wb : ALUResult_mem);
	//choose from register data and immediate data
	assign ALU_A = (ALUSrcA_ex == 1'b0) ? A : {27'b0,Sa_ex};
	assign ALU_B = (ALUSrcB_ex == 1'b0) ? B : (ALUSrcB_szextend_ex == 1'b0 ? {16'b0,Imm_zextend_ex} : Imm_sextend_ex);
	//add\sub
	wire Binvert = ~(ALUCode_ex == ADD);
	//wire[31:0] add_sub_rst = ALU_A + ALU_B^{32{Binvert}}+Binvert;
	//wire[31:0] add_sub_rst = ALU_A + ALU_B^32'hFFFFFFFF+32'h00000001;
	wire[31:0] add_sub_rst = Binvert ? (ALU_A - ALU_B) : (ALU_A + ALU_B);
	wire[31:0] and_rst = ALU_A & ALU_B;	//and
	wire[31:0] xor_rst = ALU_A ^ ALU_B;	//xor
	wire[31:0] or_rst = ALU_A | ALU_B;	//or
	wire[31:0] sll_rst = ALU_B << ALU_A[4:0];
	wire[31:0] srl_rst = ALU_B >> ALU_A[4:0];
	//sra
	reg signed[31:0] ALU_B_Reg;
	always @(ALU_B)
	begin
		ALU_B_Reg = ALU_B;
	end
	wire[31:0] sra_rst = ALU_B_Reg >>> A[4:0];
	wire[31:0] sltu_rst = ((~ALU_A[31])&&ALU_B[31])||((ALU_A[31]~^ALU_B[31])&&add_sub_rst[31]);
	wire[31:0] slt_rst = (ALU_A[31]&&(~ALU_B[31]))||((ALU_A[31]^~ALU_B[31])&&add_sub_rst[31]);
	
	always @*
	begin
		case(ALUCode_ex)
		ADD : ALUResult_ex = add_sub_rst;
		AND : ALUResult_ex = and_rst;
		XOR : ALUResult_ex = xor_rst;
		SUB : ALUResult_ex = add_sub_rst;
		SLT : ALUResult_ex = slt_rst;
		SLTU : ALUResult_ex = sltu_rst;
		SLL : ALUResult_ex = sll_rst;
		SRL : ALUResult_ex = srl_rst;
		SRA : ALUResult_ex = sra_rst;
		BEQ : ALUResult_ex = add_sub_rst;
		BNE : ALUResult_ex = add_sub_rst;
		default : ALUResult_ex = 32'b0;
		endcase
	end	
	//data write to memory, if sw, equal to B
	assign MemWriteData_ex = B;
	
	//RegWriteAddr_ex
	assign RegWriteAddr_ex = (RegDst_ex == 0) ? RtAddr_ex : RdAddr_ex;

	assign Z = (ALUResult_ex == 32'b0 && ALUCode_ex == BEQ) || (ALUResult_ex != 32'b0 && ALUCode_ex == BNE);
endmodule
