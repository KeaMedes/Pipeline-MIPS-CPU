`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:06 03/05/2014 
// Design Name: 
// Module Name:    CPU_module_IF 
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
module CPU_module_IF(
	input wire clk,
	input wire rst,
	input wire Z, J, JR,
	input wire PC_IFWrite,	//bubble insert if low
	input wire[31:0] JAddr, BranchAddr_ex, JRAddr,
	//input wire IF_Flush,
	
	output wire[31:0] Inst_IF,
	output wire[31:0] NextPC_IF
);

	assign NextPC_IF = pc_current + 4;
	
	wire[2:0] PCSource = {JR, J, Z};
	//input and output for d flip flop
	wire[31:0] pc_current;
	wire[31:0] PC_next = JR ? JRAddr : (J ? JAddr : (Z ? BranchAddr_ex : NextPC_IF));
	
	
	//we implement the PC register as a D-flip flop, enable by PC_IFWrite
	//so, if PC_IFWrite is in low, the PC reg can not read data, resulting a bubble
	//OFDE16 fde0(.D(PC_next[15:0]), .C(clk), .E(PC_IFWrite), .O(pc_current));
	//OFDE16 fde1(.D(PC_next[31:16]), .C(clk), .E(PC_IFWrite), .O(pc_current));
	/*
	reg[31:0] pc;
	always @(posedge clk)
	begin
		if (rst == 1)
			pc <= 0;
		else
		begin
			if (!PC_IFWrite)	//not bubble
				pc <= PC_next;
			else
				pc <= pc;
		end
	end*/
	reg[31:0] pc;
	always @(posedge clk)
	begin
		if (rst)
			pc <= 32'b0;
		else if(PC_IFWrite)
			pc <= PC_next;
	end
	assign pc_current = pc;
	
	/*
	reg[31:0] Inst_cache[31:0] = {
	32'h8c080080,32'h21080001,32'hac080080,32'h2009000a,
	32'h0109482a,32'h1520fffa,32'h00004820,32'h08000006,
	32'h00000000,32'h00000000,32'h00000000,32'h00000000,
	32'h00000000,32'h00000000,32'h00000000,32'h00000000,
	32'h00000000,32'h00000000,32'h00000000,32'h00000000,
	32'h00000000,32'h00000000,32'h00000000,32'h00000000,
	32'h00000000,32'h00000000,32'h00000000,32'h00000000,
	32'h00000000,32'h00000000,32'h00000000,32'h00000000
	};
	assign Inst_IF = Inst_cache[pc_current[6:2]];*/
	/*
	FDRE #(32) PC(.D(PC_next), .R(rst), .C(clk), .Q(pc_current), .CE(PC_IFWrite));
	*/
	//Inst cache
	//Port A for writre, Port B for read, but disabled
	
	
	//the reason we output Inst_ID directly, but not Inst_IF here is
	//because Ram contains cache by itself
	/*
	Inst_Cache INST_CACHE (
	.clka(clk),
	.rsta(IF_Flush | rst),
	.wea(1'b0), // Bus [0 : 0] 
	.addra(pc_current[11:2]), // Bus [9 : 0] 
	.dina(32'b0), // Bus [31 : 0] 
	.douta(Inst_ID)
	); // Bus [31 : 0] 
	//Moreover, we need PCWrite to make the data_out unchanged
	*/
	
	/*
	Inst_Cache INST_CACHE (
	.clka(~clk),
	.wea(1'b0), // Bus [0 : 0] 
	.addra(10'b0), // Bus [9 : 0] 
	.dina(32'b0), // Bus [31 : 0]
	.clkb(~clk),
	.addrb(pc_current[11:2]), // Bus [9 : 0] 
	.doutb(Inst_IF)); // Bus [31 : 0]*/
	
	Inst_Cache INST_CACHE (
	.clka(~clk),
	.wea(1'b0), // Bus [0 : 0] 
	.addra(pc_current[11:2]), // Bus [9 : 0] 
	.dina(32'b0), // Bus [31 : 0] 
	.douta(Inst_IF)); // Bus [31 : 0] 
endmodule
