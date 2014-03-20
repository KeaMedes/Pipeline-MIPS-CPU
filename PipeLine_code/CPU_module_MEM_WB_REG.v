`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:12 03/07/2014 
// Design Name: 
// Module Name:    CPU_module_MEM_WB_REG 
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
module CPU_module_MEM_WB_REG(
	input wire clk, rst,
	input wire MemtoReg_mem,
	input wire RegWrite_mem,
	input wire[31:0] ALUResult_mem,
	input wire[4:0] RegWriteAddr_mem,
	
	output wire MemtoReg_wb,
	output wire RegWrite_wb,
	output wire[31:0] ALUResult_wb,
	output wire[4:0] RegWriteAddr_wb
);
	reg[38:0] cache;
	wire[38:0] cache_data = {MemtoReg_mem, RegWrite_mem,
									RegWriteAddr_mem,
									ALUResult_mem};
	always @(posedge clk)
	begin
		if (rst)
			cache <= 39'b0;
		else
			cache <= cache_data;
	end
	
	assign {MemtoReg_wb, RegWrite_wb,
									RegWriteAddr_wb,
									ALUResult_wb} = cache;
	/*
	FDR #(1) fdr_MemtoReg(.D(MemtoReg_mem), .R(rst), .C(clk), .Q(MemtoReg_wb));
	FDR #(1) fdr_RegWrite(.D(RegWrite_mem), .R(rst), .C(clk), .Q(RegWrite_wb));
	FDR #(32) fdr_ALUResult(.D(ALUResult_mem), .R(rst), .C(clk), .Q(ALUResult_wb));
	FDR #(5) fdr_RegWriteAddr(.D(RegWriteAddr_mem), .R(rst), .C(clk), .Q(RegWriteAddr_wb));
	*/
endmodule
