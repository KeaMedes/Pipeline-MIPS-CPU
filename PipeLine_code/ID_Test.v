`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:07:23 03/07/2014
// Design Name:   CPU_module_ID
// Module Name:   D:/School Works/PipeLine/ID_Test.v
// Project Name:  PipeLine
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_module_ID
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ID_Test;

	// Inputs
	reg clk;
	reg [31:0] Instruction_id;
	reg [31:0] NextPC_id;
	reg RegWrite_wb;
	reg [4:0] RegWriteAddr_wb;
	reg [31:0] RegWriteData_wb;
	reg MemRead_ex;
	reg [4:0] RegWriteAddr_ex;

	// Outputs
	wire MemtoReg_id;
	wire RegWrite_id;
	wire MemWrite_id;
	wire MemRead_id;
	wire [3:0] ALUCode_id;
	wire ALUSrcA_id;
	wire ALUSrcB_id;
	wire ALUSrcB_szextend_id;
	wire RegDst_id;
	wire Stall;
	wire PC_IFWrite;
	wire Z;
	wire J_Valid;
	wire JR_Valid;
	wire [31:0] BranchAddr;
	wire [31:0] JAddr;
	wire [31:0] JRAddr;
	wire [31:0] Imm_sextend_id;
	wire [31:0] Imm_zextend_id;
	wire [31:0] Sa_id;
	wire [4:0] RsAddr_id;
	wire [4:0] RtAddr_id;
	wire [4:0] RdAddr_id;
	wire [31:0] RsData_id;
	wire [31:0] RtData_id;

	// Instantiate the Unit Under Test (UUT)
	CPU_module_ID uut (
		.clk(clk), 
		.Instruction_id(Instruction_id), 
		.NextPC_id(NextPC_id), 
		.RegWrite_wb(RegWrite_wb), 
		.RegWriteAddr_wb(RegWriteAddr_wb), 
		.RegWriteData_wb(RegWriteData_wb), 
		.MemRead_ex(MemRead_ex), 
		.RegWriteAddr_ex(RegWriteAddr_ex), 
		.MemtoReg_id(MemtoReg_id), 
		.RegWrite_id(RegWrite_id), 
		.MemWrite_id(MemWrite_id), 
		.MemRead_id(MemRead_id), 
		.ALUCode_id(ALUCode_id), 
		.ALUSrcA_id(ALUSrcA_id), 
		.ALUSrcB_id(ALUSrcB_id), 
		.ALUSrcB_szextend_id(ALUSrcB_szextend_id), 
		.RegDst_id(RegDst_id), 
		.Stall(Stall), 
		.PC_IFWrite(PC_IFWrite), 
		.Z(Z), 
		.J_Valid(J_Valid), 
		.JR_Valid(JR_Valid), 
		.BranchAddr(BranchAddr), 
		.JAddr(JAddr), 
		.JRAddr(JRAddr), 
		.Imm_sextend_id(Imm_sextend_id), 
		.Imm_zextend_id(Imm_zextend_id), 
		.Sa_id(Sa_id), 
		.RsAddr_id(RsAddr_id), 
		.RtAddr_id(RtAddr_id), 
		.RdAddr_id(RdAddr_id), 
		.RsData_id(RsData_id), 
		.RtData_id(RtData_id)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		Instruction_id = 0;
		NextPC_id = 0;
		RegWrite_wb = 0;
		RegWriteAddr_wb = 0;
		RegWriteData_wb = 0;
		MemRead_ex = 0;
		RegWriteAddr_ex = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

