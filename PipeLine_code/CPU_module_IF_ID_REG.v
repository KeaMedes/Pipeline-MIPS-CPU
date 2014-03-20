`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:22 03/05/2014 
// Design Name: 
// Module Name:    CPU_module_IF_ID_REG 
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
module CPU_module_IF_ID_REG(
	input wire rst, clk,
	input wire[31:0] Inst_IF,
	input wire[31:0] NextPC_IF,
	input wire PC_IFWrite,	//data hazard
	input wire IF_Flush,	//branch hazard
	
	output wire[31:0] Inst_ID,
	output wire[31:0] NextPC_ID
);
	reg[63:0] cache;
	wire[63:0] cache_data = {NextPC_IF,Inst_IF};
	always @(posedge clk)
	begin
		if (rst | IF_Flush)
			cache <= 64'b0;
		else	if(PC_IFWrite)
			cache <= cache_data;
	end
	
	//assign {NextPC_ID, Inst_ID} = cache;
	assign NextPC_ID = cache[63:32];
	assign Inst_ID = cache[31:0];
	/*
	FDRE #(32) fdre_Inst(.D(Inst_IF), .C(clk), .CE(PC_IFWrite), .R(rst | IF_Flush), .Q(Inst_ID));
	FDRE #(32) fdre_NextPC(.D(NextPC_IF), .C(clk), .CE(PC_IFWrite), .R(rst | IF_Flush), .Q(NextPC_ID));
	*/
endmodule
