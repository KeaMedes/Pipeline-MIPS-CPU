`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:45 03/05/2014 
// Design Name: 
// Module Name:    CPU_module_WB 
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
module CPU_module_WB(
	input wire MemtoReg_wb,
	input wire[31:0] MemDout_wb,
	input wire[31:0] ALUResult_wb,
	
	output wire[31:0] RegWriteData_wb
);

	assign RegWriteData_wb=MemtoReg_wb?MemDout_wb:ALUResult_wb;
endmodule
