`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:54:50 03/05/2014 
// Design Name: 
// Module Name:    CPU_module_EX_MEM_REG 
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
module CPU_module_EX_MEM_REG(
	input clk, rst,
	input MemtoReg_ex,
	input RegWrite_ex,
	input MemWrite_ex,
	input MemRead_ex,	//actually, MemRead is not used at most cases
	input wire[31:0] ALUResult_ex,
	input wire[4:0] RegWriteAddr_ex,
	input wire[31:0] MemWriteData_ex,
	
	output MemtoReg_mem,
	output RegWrite_mem,
	output MemWrite_mem,
	output MemRead_mem,	//actually, MemRead is not used at most cases
	output wire[31:0] ALUResult_mem,
	output wire[4:0] RegWriteAddr_mem,
	output wire[31:0] MemWriteData_mem
);
	reg[72:0] cache;
	wire[72:0] cache_data = {MemtoReg_ex, RegWrite_ex, MemWrite_ex, MemRead_ex,
									RegWriteAddr_ex,
									ALUResult_ex, MemWriteData_ex};
	always @(posedge clk)
	begin
		if (rst)
			cache <= 73'b0;
		else
			cache <= cache_data;
	end
	
	assign {MemtoReg_mem, RegWrite_mem, MemWrite_mem, MemRead_mem,
									RegWriteAddr_mem,
									ALUResult_mem, MemWriteData_mem} = cache;
	/*
	FDR #(1) fdr_MemtoReg(.D(MemtoReg_ex), .R(rst), .C(clk), .Q(MemtoReg_mem));
	FDR #(1) fdr_RegWrite(.D(RegWrite_ex), .R(rst), .C(clk), .Q(RegWrite_mem));
	FDR #(1) fdr_MemWrite(.D(MemWrite_ex), .R(rst), .C(clk), .Q(MemWrite_mem));
	FDR #(1) fdr_MemRead(.D(MemRead_ex), .R(rst), .C(clk), .Q(MemRead_mem));
	FDR #(32) fdr_ALUResult(.D(ALUResult_ex), .R(rst), .C(clk), .Q(ALUResult_mem));
	FDR #(32) fdr_MemWriteData(.D(MemWriteData_ex), .R(rst), .C(clk), .Q(MemWriteData_mem));
	FDR #(5) fdr_RegWriteAddr(.D(RegWriteAddr_ex), .R(rst), .C(clk), .Q(RegWriteAddr_mem));
	*/
endmodule
