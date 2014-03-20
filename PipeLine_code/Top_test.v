`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:29:37 03/12/2014
// Design Name:   CPU_Top
// Module Name:   D:/School Works/PipeLine/Top_test.v
// Project Name:  PipeLine
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Top_test;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire MemRead_mem_LED;

	// Instantiate the Unit Under Test (UUT)
	CPU_Top uut (
		.clk(clk), 
		.rst(rst), 
		.MemRead_mem_LED(MemRead_mem_LED)
	);

	initial begin
		// Initialize Inputs
		//clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		
		#100;
      
		rst = 1;
		
		#100;
		
		rst = 0;
		// Add stimulus here

	end
   always
	begin
	 #20;
	 clk = 1'b0;
	 #20;
	 clk = 1'b1;
	end   
endmodule

