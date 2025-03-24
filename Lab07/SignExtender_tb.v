`timescale 1ns / 1ps

`define STRLEN 20
module SignExtender_tb;

	task passTest;
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin 
			$display ("%s passed", testType);
			passed = passed + 1; 
		end else begin
			$display ("%s failed: %h should be %h", testType, actualOut, expectedOut);
		end
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) 
			$display ("All tests passed");
		else 
			$display("Some tests failed");
	endtask
	
	// Inputs
  	reg [25:0] Instr;
  reg [7:0] passed;
  reg [1:0] Ctrl;

	// Outputs
	wire [63:0] BusImm;

	// Instantiate the Unit Under Test (UUT)
	SignExtender uut (
		.Instr(Instr), 
      	.BusImm(BusImm),
      	.Ctrl(Ctrl)
	);

	initial begin
		// Initialize Inputs
      $dumpfile("SignExtender.vcd");
      $dumpvars(0,SignExtender_tb);
      Instr = 0;
		passed = 0;
      	Ctrl = 2'b00;

        // I-type - extracting bits 21-10, performing sign extension up to 64 bits, and checking to see if the output is the same as the output i manually calculated.
      #10; Instr = 26'h10; Ctrl = 2'b00; #10; passTest(BusImm, 64'h0, "I-type: 0x10", passed); // positive immediate field
      #10; Instr = 26'h2FFFFFF; Ctrl =  2'b00; #10; passTest(BusImm, 64'hFFFFFFFFFFFFFFFF, "I-type: 0x2FFFFFF", passed); // negative immediate field
      
        // D-type - extract bits 20-12, perform sign extension to 64 bits.. same as I-type, except extract different bits
      #10; Instr = 26'h8; Ctrl = 2'b01; #10; passTest(BusImm, 64'h0, "D-type: 0x8", passed); // positive immediate field
      #10; Instr = 26'h2F0FFFF;  Ctrl = 2'b01; #10; passTest(BusImm, 64'hFFFFFFFFFFFFFF0F, "D-type: 0x2F0FFFF", passed); // negative immediate field

      // B-type - extract bits 25-0 (all instruction bits), perform sign extension to 64 bits, and compare output
      #10; Instr = 26'h100; Ctrl = 2'b10; #10; passTest(BusImm, 64'h100, "B-type: 0x100", passed); // positive immediate field
      #10; Instr = 26'h2FFFFFF; Ctrl = 2'b10; #10; passTest(BusImm, 64'hFFFFFFFFFEFFFFFF, "B-type: 0x2FFFFFF", passed); // negative immediate field
      
        // CB-type - extract bits 23-5, perform sign extension to 64 bits, and compare output
      #10; Instr = 26'hF0; Ctrl = 2'b11; #10; passTest(BusImm, 64'h7, "CB-type: 0xF0", passed); // positive immediate field
      #10; Instr = 26'h800000; Ctrl = 2'b11; #10; passTest(BusImm, 64'hFFFFFFFFFFFC0000, "CB-type: 0x800000", passed); // negative immediate field

		#10;
      allPassed(passed, 8);
	end
      
endmodule