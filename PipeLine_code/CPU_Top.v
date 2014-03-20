`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:29:59 03/07/2014 
// Design Name: 
// Module Name:    CPU_Top 
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
module CPU_Top(
	input clk, rst,
	output MemRead_mem_LED
);

	wire[31:0] JRAddr, JAddr, BranchAddr_id, Inst_if, NextPC_if, Inst_id, BranchAddr_ex;
CPU_module_IF IF (
    .clk(clk), 
    .rst(rst), 
	 //.IF_Flush(J || JR || Z),
    .Z(Z), 
    .J(J), 
    .JR(JR), 
    .PC_IFWrite(PC_IFWrite), 
    .JAddr(JAddr), 
    .BranchAddr_ex(BranchAddr_ex), 
    .JRAddr(JRAddr), 
    .Inst_IF(Inst_if), 
    .NextPC_IF(NextPC_if)
    );
	 
	 wire[31:0] NextPC_id;
CPU_module_IF_ID_REG IF_ID (
    .rst(rst), 
    .clk(clk), 
    .Inst_IF(Inst_if), 
    .NextPC_IF(NextPC_if), 
    .PC_IFWrite(PC_IFWrite), 
    .IF_Flush(J || JR || Z), 
    .Inst_ID(Inst_id), 
    .NextPC_ID(NextPC_id)
    );
	 
	 wire [31:0] RegWriteData_wb, Imm_sextend_id, RsData_id, RtData_id;
	 wire [15:0] Imm_zextend_id;
	 wire [4:0] Sa_id;
	 wire [4:0] RegWriteAddr_wb, RegWriteAddr_ex, RsAddr_id, RtAddr_id, RdAddr_id;
	 wire [10:0] ALUCode_id;
	// wire [4:0] RegFilesAddr_test;
	// wire [31:0] RegFilesData_test;
CPU_module_ID ID (
    .clk(clk), 
	 .rst(rst),
    .Instruction_id(Inst_id), 
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
   // .Z(Z), 
    .J_Valid(J), 
    .JR_Valid(JR), 
    .BranchAddr_id(BranchAddr_id), 
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
	 //.RegFilesAddr_test(RegFilesAddr_test),
	 //.RegFilesData_test(RegFilesData_test)
    );
	 
	 wire [31:0] Imm_sextend_ex, RsData_ex, RtData_ex;
	 wire [4:0] RsAddr_ex, RtAddr_ex, RdAddr_ex;
	 wire [10:0] ALUCode_ex;	 
	 wire [15:0] Imm_zextend_ex;
	 wire [4:0] Sa_ex;
CPU_module_ID_EX_REG ID_EX (
    .clk(clk), 
    .rst(rst), 
    .Stall(Stall),
    .Z(Z),
    .MemtoReg_id(MemtoReg_id), 
    .RegWrite_id(RegWrite_id), 
    .MemWrite_id(MemWrite_id), 
    .MemRead_id(MemRead_id), 
    .ALUCode_id(ALUCode_id), 
    .ALUSrcA_id(ALUSrcA_id), 
    .ALUSrcB_id(ALUSrcB_id), 
    .ALUSrcB_szextend_id(ALUSrcB_szextend_id), 
    .RegDst_id(RegDst_id), 
    .Sa_id(Sa_id), 
    .Imm_sextend_id(Imm_sextend_id), 
    .Imm_zextend_id(Imm_zextend_id), 
    .RsData_id(RsData_id), 
    .RtData_id(RtData_id), 
    .RsAddr_id(RsAddr_id), 
    .RtAddr_id(RtAddr_id), 
    .RdAddr_id(RdAddr_id), 
	 .BranchAddr_id(BranchAddr_id),
    .MemtoReg_ex(MemtoReg_ex), 
    .RegWrite_ex(RegWrite_ex), 
    .MemWrite_ex(MemWrite_ex), 
    .MemRead_ex(MemRead_ex), 
    .ALUCode_ex(ALUCode_ex), 
    .ALUSrcA_ex(ALUSrcA_ex),
    .ALUSrcB_ex(ALUSrcB_ex),
    .ALUSrcB_szextend_ex(ALUSrcB_szextend_ex), 
    .RegDst_ex(RegDst_ex), 
    .Sa_ex(Sa_ex), 
    .Imm_sextend_ex(Imm_sextend_ex), 
    .Imm_zextend_ex(Imm_zextend_ex), 
    .RsData_ex(RsData_ex), 
    .RtData_ex(RtData_ex), 
    .RsAddr_ex(RsAddr_ex), 
    .RtAddr_ex(RtAddr_ex), 
    .RdAddr_ex(RdAddr_ex),
	 .BranchAddr_ex(BranchAddr_ex)
    );
	 
	 wire[4:0] RegWriteAddr_mem;
	 wire[31:0] ALUResult_mem, ALUResult_ex, MemWriteData_ex;
	 //wire[31:0] ALU_A, ALU_B;	// for test
CPU_module_EX EX (
    .RegWriteAddr_mem(RegWriteAddr_mem), 
    .RegWrite_mem(RegWrite_mem), 
    .ALUResult_mem(ALUResult_mem), 
    .RegWriteAddr_wb(RegWriteAddr_wb), 
    .RegWrite_wb(RegWrite_wb), 
    .RegWriteData_wb(RegWriteData_wb), 
    .RsAddr_ex(RsAddr_ex), 
    .RtAddr_ex(RtAddr_ex), 
    .RdAddr_ex(RdAddr_ex), 
    .RegDst_ex(RegDst_ex), 
    .RegWriteAddr_ex(RegWriteAddr_ex), 
    .ALUResult_ex(ALUResult_ex), 
    .MemWriteData_ex(MemWriteData_ex), 
    .ALUCode_ex(ALUCode_ex), 
    .ALUSrcA_ex(ALUSrcA_ex), 
    .ALUSrcB_ex(ALUSrcB_ex), 
    .ALUSrcB_szextend_ex(ALUSrcB_szextend_ex), 
    .Imm_sextend_ex(Imm_sextend_ex), 
    .Imm_zextend_ex(Imm_zextend_ex), 
    .Sa_ex(Sa_ex), 
    .RsData_ex(RsData_ex), 
    .RtData_ex(RtData_ex),
	 .Z(Z)
    //.ALU_A(ALU_A), 
    //.ALU_B(ALU_B)
    );
	 
	 wire[4:0] RegWriteAddr;
	 wire[31:0] MemWriteData_mem;
	 wire MemRead_mem;
CPU_module_EX_MEM_REG EX_MEM (
    .clk(clk), 
    .rst(rst), 
    .MemtoReg_ex(MemtoReg_ex), 
    .RegWrite_ex(RegWrite_ex), 
    .MemWrite_ex(MemWrite_ex), 
    .MemRead_ex(MemRead_ex), 
    .ALUResult_ex(ALUResult_ex), 
    .RegWriteAddr_ex(RegWriteAddr_ex), 
    .MemWriteData_ex(MemWriteData_ex), 
    .MemtoReg_mem(MemtoReg_mem), 
    .RegWrite_mem(RegWrite_mem), 
    .MemWrite_mem(MemWrite_mem), 
    .MemRead_mem(MemRead_mem), 
    .ALUResult_mem(ALUResult_mem), 
    .RegWriteAddr_mem(RegWriteAddr_mem), 
    .MemWriteData_mem(MemWriteData_mem)
    );
	 
	 wire[31:0] MemDout_wb;
CPU_module_MEM MEM (
    .ALUResult_mem(ALUResult_mem), 
    .clk(clk), 
    .MemWriteData_mem(MemWriteData_mem), 
    .MemRead_mem(MemRead_mem), 
    .MemWrite_mem(MemWrite_mem), 
    .MemDout_wb(MemDout_wb)
    );
	 
	 wire[31:0] ALUResult_wb;
CPU_module_MEM_WB_REG MEM_WB (
    .clk(clk), 
    .rst(rst), 
    .MemtoReg_mem(MemtoReg_mem), 
    .RegWrite_mem(RegWrite_mem), 
    .ALUResult_mem(ALUResult_mem), 
    .RegWriteAddr_mem(RegWriteAddr_mem), 
    .MemtoReg_wb(MemtoReg_wb), 
    .RegWrite_wb(RegWrite_wb), 
    .ALUResult_wb(ALUResult_wb), 
    .RegWriteAddr_wb(RegWriteAddr_wb)
    );
CPU_module_WB WB (
    .MemtoReg_wb(MemtoReg_wb), 
    .MemDout_wb(MemDout_wb), 
    .ALUResult_wb(ALUResult_wb), 
    .RegWriteData_wb(RegWriteData_wb)
    );
	assign MemRead_mem_LED = MemRead_mem;
endmodule
