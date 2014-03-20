`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:16 03/05/2014 
// Design Name: 
// Module Name:    CPU_module_MEM 
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
module CPU_module_MEM(
	input wire[31:0] ALUResult_mem,
	input wire clk,
	input wire[31:0] MemWriteData_mem,
	input wire MemRead_mem,
	input wire MemWrite_mem,
	
	output wire[31:0] MemDout_wb	//RAM generated by IPCore contain a fd by itself,
											//as the result, the data output would be MemDout_wb, but not
											//MemDout_mem
	);
	wire wea = MemWrite_mem;
	wire[7:0] addr = ALUResult_mem[9:2];
	wire[31:0] data_out;
	wire[31:0] data_in = MemWriteData_mem;
	Data_Cache DATA_CACHE (
	.clka(clk),
	.wea(wea), // Bus [0 : 0] 
	.addra(addr), // Bus [7 : 0] 
	.dina(data_in), // Bus [31 : 0] 
	.douta(data_out)); // Bus [31 : 0]

	assign MemDout_wb = data_out;


endmodule
