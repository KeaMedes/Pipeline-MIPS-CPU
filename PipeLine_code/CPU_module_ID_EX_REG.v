`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:54 03/05/2014 
// Design Name: 
// Module Name:    CPU_module_ID_EX_REG 
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
/*
Tools for this file:
for line in open('data.txt'):
    name, digit = line.strip().split()
    #print 'FDR #(%{digit}s) fdr_%s(.D(%{name}s_id), .R(Flush), .C(clk), .Q(%{name}s_ex)' % locals()
    print 'FDR #({digit}) fdr_{name}(.D({name}_id), .R(Flush), .C(clk), .Q({name}_ex));'.format(**locals())
	 
MemtoReg 1
RegWrite 1
MemWrite 1
MemRead 1
ALUCode 5
ALUSrcA 1
ALUSrcB 1
RegDst 1
Sa 32
Imm 32
RsData 32
RtData 32
RsAddr 5
RtAddr 5
RdAddr 5
*/
module CPU_module_ID_EX_REG(
	input wire clk, rst,
	input wire Stall,	//data hazard
	input wire Z,
	
	input wire MemtoReg_id,
	input wire RegWrite_id,
	input wire MemWrite_id,
	input wire MemRead_id,
	input wire[10:0] ALUCode_id,
	input wire ALUSrcA_id, 
	input wire ALUSrcB_id,
	input wire ALUSrcB_szextend_id,
	input wire RegDst_id,
	input wire[4:0] Sa_id,
	input wire[31:0] Imm_sextend_id,
	input wire[15:0] Imm_zextend_id,
	input wire[31:0] RsData_id,
	input wire[31:0] RtData_id,
	input wire[4:0] RsAddr_id,
	input wire[4:0] RtAddr_id,
	input wire[4:0] RdAddr_id,
	input wire[31:0] BranchAddr_id,
	
	output wire MemtoReg_ex,
	output wire RegWrite_ex,
	output wire MemWrite_ex,
	output wire MemRead_ex,
	output wire[10:0] ALUCode_ex,
	output wire ALUSrcA_ex, 
	output wire ALUSrcB_ex, 
	output wire ALUSrcB_szextend_ex,
	output wire RegDst_ex,
	output wire[4:0] Sa_ex,
	output wire[31:0] Imm_sextend_ex,
	output wire[15:0] Imm_zextend_ex,
	
	output wire[31:0] RsData_ex,
	output wire[31:0] RtData_ex,
	output wire[4:0] RsAddr_ex,
	output wire[4:0] RtAddr_ex,
	output wire[4:0] RdAddr_ex,
	output wire[31:0] BranchAddr_ex
);
	wire Flush = rst | Stall | Z;
	reg[182:0] cache;
	wire[182:0] cache_data={MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUSrcA_id, ALUSrcB_id,
									ALUSrcB_szextend_id, RegDst_id,	//1 bits signal
									RsAddr_id, RtAddr_id, RdAddr_id,	Sa_id, //5 bits signal
									ALUCode_id,	//11 bits signal
									Imm_zextend_id,	//15 bits singal
									Imm_sextend_id, RsData_id, RtData_id, BranchAddr_id	//32 bits signal
									};
	always @(posedge clk)
	begin
		if (Flush)
			cache <= 183'b0;
		else
			cache <= cache_data;
	end 
	
	assign	{MemtoReg_ex, RegWrite_ex, MemWrite_ex, MemRead_ex, ALUSrcA_ex, ALUSrcB_ex,
				ALUSrcB_szextend_ex, RegDst_ex,	//1 bits signal
				RsAddr_ex, RtAddr_ex, RdAddr_ex,	Sa_ex, //5 bits signal
				ALUCode_ex,	//11 bits signal
				Imm_zextend_ex, //15 bits signal
				Imm_sextend_ex, RsData_ex, RtData_ex, BranchAddr_ex	//32 bits signal
									} = cache;
	/*
	FDR #(1) fdr_MemtoReg(.D(MemtoReg_id), .R(Flush), .C(clk), .Q(MemtoReg_ex));
	FDR #(1) fdr_RegWrite(.D(RegWrite_id), .R(Flush), .C(clk), .Q(RegWrite_ex));
	FDR #(1) fdr_MemWrite(.D(MemWrite_id), .R(Flush), .C(clk), .Q(MemWrite_ex));
	FDR #(1) fdr_MemRead(.D(MemRead_id), .R(Flush), .C(clk), .Q(MemRead_ex));
	FDR #(8) fdr_ALUCode(.D(ALUCode_id), .R(Flush), .C(clk), .Q(ALUCode_ex));
	FDR #(1) fdr_ALUSrcA(.D(ALUSrcA_id), .R(Flush), .C(clk), .Q(ALUSrcA_ex));
	FDR #(1) fdr_ALUSrcB(.D(ALUSrcB_id), .R(Flush), .C(clk), .Q(ALUSrcB_ex));
	FDR #(1) fdr_ALUSrcB_szextend(.D(ALUSrcB_szextend_id), .R(Flush), .C(clk), .Q(ALUSrcB_szextend_ex));
	FDR #(1) fdr_RegDst(.D(RegDst_id), .R(Flush), .C(clk), .Q(RegDst_ex));
	FDR #(32) fdr_Sa(.D(Sa_id), .R(Flush), .C(clk), .Q(Sa_ex));
	FDR #(32) fdr_Imm_sextend(.D(Imm_sextend_id), .R(Flush), .C(clk), .Q(Imm_sextend_ex));
	FDR #(32) fdr_Imm_zextend(.D(Imm_zextend_id), .R(Flush), .C(clk), .Q(Imm_zextend_ex));
	FDR #(32) fdr_RsData(.D(RsData_id), .R(Flush), .C(clk), .Q(RsData_ex));
	FDR #(32) fdr_RtData(.D(RtData_id), .R(Flush), .C(clk), .Q(RtData_ex));
	FDR #(5) fdr_RsAddr(.D(RsAddr_id), .R(Flush), .C(clk), .Q(RsAddr_ex));
	FDR #(5) fdr_RtAddr(.D(RtAddr_id), .R(Flush), .C(clk), .Q(RtAddr_ex));
	FDR #(5) fdr_RdAddr(.D(RdAddr_id), .R(Flush), .C(clk), .Q(RdAddr_ex));
	*/
endmodule
