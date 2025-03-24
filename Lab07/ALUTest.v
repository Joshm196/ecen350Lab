`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module ALUTest_v;

	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

  
  
	initial begin
      $dumpfile("ALU.vcd");
      $dumpvars(0,ALUTest_v);
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

                // Here is one example test vector, testing the ADD instruction:
		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h2}; #40; passTest({Zero, BusW}, 65'h0ABCD1234, "ADD 0x1234,0xABCD0000", passed);
		//Reformate and add your test vectors from the prelab here following the example of the testvector above.	
		{BusA, BusB, ALUCtrl} = {64'h2, 64'h4, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "AND1", passed); // result of 0x2 AND 0x4
		{BusA, BusB, ALUCtrl} = {64'h1, 64'h0, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "AND2", passed); // result of 0x1 AND 0x0
		{BusA, BusB, ALUCtrl} = {64'h5, 64'hC, 4'h0}; #40; passTest({Zero, BusW}, {1'b0, 64'h4}, "AND3", passed); // result of 0x5 AND 0xC

		{BusA, BusB, ALUCtrl} = {64'h2, 64'h4, 4'h1}; #40; passTest({Zero, BusW}, {1'b0, 64'h6}, "OR1", passed); // result of 0x2 OR 0x4
		{BusA, BusB, ALUCtrl} = {64'h8, 64'h1, 4'h1}; #40; passTest({Zero, BusW}, {1'b0, 64'h9}, "OR2", passed); // result of 0x8 OR 0x1
		{BusA, BusB, ALUCtrl} = {64'h3, 64'hA, 4'h1}; #40; passTest({Zero, BusW}, {1'b0, 64'hB}, "OR3", passed); // result of 0x3 OR 0xA

		{BusA, BusB, ALUCtrl} = {64'h6, 64'h9, 4'h2}; #40; passTest({Zero, BusW}, {1'b0, 64'hF}, "ADD1", passed); // result of 0x6 + 0x9
		{BusA, BusB, ALUCtrl} = {64'h7, 64'h2, 4'h2}; #40; passTest({Zero, BusW}, {1'b0, 64'h9}, "ADD2", passed); // result of 0x7 + 0x2
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'h2}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "ADD3", passed); // result of 0x0 + 0x0

		{BusA, BusB, ALUCtrl} = {64'hA, 64'h4, 4'h6}; #40; passTest({Zero, BusW}, {1'b0, 64'h6}, "SUB1", passed); // result of 0xA - 0x4
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'h6}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "SUB2", passed); // result of 0x0 - 0x0
		{BusA, BusB, ALUCtrl} = {64'hC, 64'h1, 4'h6}; #40; passTest({Zero, BusW}, {1'b0, 64'hB}, "SUB3", passed); // result of 0xC - 0x1

		{BusA, BusB, ALUCtrl} = {64'h5, 64'h0, 4'h7}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "PassB1", passed); // result is 0x0
		{BusA, BusB, ALUCtrl} = {64'h7, 64'h2, 4'h7}; #40; passTest({Zero, BusW}, {1'b0, 64'h2}, "PassB2", passed); // result is 0x2
		{BusA, BusB, ALUCtrl} = {64'h1, 64'h0, 4'h7}; #40; passTest({Zero, BusW}, {1'b1, 64'h0}, "PassB3", passed); // result is 0x0

		allPassed(passed, 16);
	end
      
endmodule

