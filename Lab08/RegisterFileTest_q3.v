`timescale 1ns / 1ps


`define STRLEN 32
module RegisterFileTest_v;


   task passTest;
      input [63:0] actualOut, expectedOut;
      input [`STRLEN*8:0] testType;
      inout [7:0] 	  passed;
      
      if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
      else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
   endtask
   
   task allPassed;
      input [7:0] passed;
      input [7:0] numTests;
      
      if(passed == numTests) $display ("All tests passed");
      else $display("Some tests failed");
   endtask

   // Inputs
   reg [63:0] 	  BusW;
   reg [4:0] 	  RA;
   reg [4:0] 	  RB;
   reg [4:0] 	  RW;
   reg 		  RegWr;
   reg 		  Clk;
   reg [7:0] 	  passed;

   // Outputs
   wire [63:0] 	  BusA;
   wire [63:0] 	  BusB;

   // Instantiate the Unit Under Test (UUT)
   RegisterFile uut (
		     .BusA(BusA), 
		     .BusB(BusB), 
		     .BusW(BusW), 
		     .RA(RA), 
		     .RB(RB), 
		     .RW(RW), 
		     .RegWr(RegWr), 
		     .Clk(Clk)
		     );

   initial begin
      // Initialize Inputs
	   $dumpfile("RegisterFile.vcd");
	   $dumpvars(0, RegisterFileTest_v);
      BusW = 0;
      RA = 0;
      RB = 0;
      RW = 0;
      RegWr = 0;
      Clk = 1;
      passed = 0;
      
      #10;

      // Add stimulus here
      {RA, RB, RW, BusW, RegWr} = {5'd31, 5'd31, 5'd31, 64'h0, 1'b0};
      #10
	passTest(BusA, 64'd0, "Initial $0 Check 1", passed);
      passTest(BusB, 64'd0, "Initial $0 Check 2", passed);
      #10; Clk = 0; #10; Clk = 1;
      
      {RA, RB, RW, BusW, RegWr} = {5'd31, 5'd31, 5'd31, 64'h12345678, 1'b1};
      passTest(BusA, 64'd0, "Initial $0 Check 3", passed);
      passTest(BusB, 64'd0, "Initial $0 Check 4", passed);
      #10; Clk = 0; #10; Clk = 1;
      passTest(BusA, 64'd0, "$0 Stays 0 Check 1", passed);
      passTest(BusB, 64'd0, "$0 Stays 0 Check 2", passed);

      // This segment clears all registers
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd0, 64'h0, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd1, 64'h1, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd2, 64'h2, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd3, 64'h3, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd4, 64'h4, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd5, 64'h5, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd6, 64'h6, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd7, 64'h7, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd8, 64'h8, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd9, 64'h9, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd10, 64'd10, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd11, 64'd11, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd12, 64'd12, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd13, 64'd13, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd14, 64'd14, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd15, 64'd15, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd16, 64'd16, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd17, 64'd17, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd18, 64'd18, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd19, 64'd19, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd20, 64'd20, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd21, 64'd21, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd22, 64'd22, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd23, 64'd23, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd24, 64'd24, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd25, 64'd25, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd26, 64'd26, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd27, 64'd27, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd28, 64'd28, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd29, 64'd29, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd30, 64'd30, 1'b1};#10; Clk = 0; #10; Clk = 1;
      {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd0, 5'd31, 64'd31, 1'b1};#10; Clk = 0; #10; Clk = 1;

	   // Ra = 0, Rb = 1, Rw = 0, RegWr = 0, BusW = 0x0
     {RA, RB, RW, BusW, RegWr} = {5'd0, 5'd1, 5'd0, 64'h0, 1'b0};
      #4;
     passTest(BusA, 64'd0, "Initial BusA 1", passed);
     passTest(BusB, 64'd1, "Initial BusB 1", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'd0, "Updated BusA 2", passed);
     passTest(BusB, 64'd1, "Updated BusB 2", passed);

	   // Ra = 2, Rb = 3, Rw = 1, RegWr = 0, BusW = 0x1000
     {RA, RB, RW, BusW, RegWr} = {5'd2, 5'd3, 5'd1, 64'h1000, 1'b0};
      #4;
     passTest(BusA, 64'd2, "Initial BusA 2", passed);
     passTest(BusB, 64'd3, "Initial BusB 2", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'd2, "Updated BusA 2", passed);
     passTest(BusB, 64'd3, "Updated BusB 2", passed);

	   // Ra = 4, Rb = 5, Rw = 0, RegWr = 1, BusW = 0x1000
     {RA, RB, RW, BusW, RegWr} = {5'd4, 5'd5, 5'd0, 64'h1000, 1'b1};
      #4;
     passTest(BusA, 64'd4, "Initial BusA 3", passed);
     passTest(BusB, 64'd5, "Initial BusB 3", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'd4, "Updated BusA 3", passed);
     passTest(BusB, 64'd5, "Updated BusB 3", passed);

	   // Ra = 6, Rb = 7, Rw = 1, RegWr = 1, BusW = 0x1010
     {RA, RB, RW, BusW, RegWr} = {5'd6, 5'd7, 5'd10, 64'h1010, 1'b1};
      #4;
     passTest(BusA, 64'd6, "Initial BusA 4", passed);
     passTest(BusB, 64'd7, "Initial BusB 4", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'd6, "Updated BusA 4", passed);
     passTest(BusB, 64'd7, "Updated BusB 4", passed);

	   // Ra = 8, Rb = 9, Rw = 11, RegWr = 1, BusW = 0x103000
     {RA, RB, RW, BusW, RegWr} = {5'd8, 5'd9, 5'd11, 64'h103000, 1'b1};
      #4;
     passTest(BusA, 64'd8, "Initial BusA 5", passed);
     passTest(BusB, 64'd9, "Initial BusB 5", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'd8, "Updated BusA 5", passed);
     passTest(BusB, 64'd9, "Updated BusB 5", passed);

	   // Ra = A, Rb = B, Rw = C, RegWr = 0, BusW = 0x0
     {RA, RB, RW, BusW, RegWr} = {5'ha, 5'hb, 5'hc, 64'h0, 1'b0};
      #4;
     passTest(BusA, 64'h1010, "Initial BusA 6", passed);
     passTest(BusB, 64'h103000, "Initial BusB 6", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'h1010, "Updated BusA 6", passed);
     passTest(BusB, 64'h103000, "Updated BusB 6", passed);

	   // Ra = C, Rb = D, Rw = D, RegWr = 1, BusW = 0xABCD
     {RA, RB, RW, BusW, RegWr} = {5'hc, 5'hd, 5'hd, 64'hABCD, 1'b1};
      #4;
     passTest(BusA, 64'hc, "Initial BusA 7", passed);
     passTest(BusB, 64'hd, "Initial BusB 7", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'hc, "Updated BusA 7", passed);
     passTest(BusB, 64'hABCD, "Updated BusB 7", passed);

	   // Ra = E, Rb = F, Rw = E, RegWr = 0, BusW = 0x9080009
     {RA, RB, RW, BusW, RegWr} = {5'he, 5'hf, 5'he, 64'h9080009, 1'b0};
      #4;
     passTest(BusA, 64'he, "Initial BusA 8", passed);
     passTest(BusB, 64'hf, "Initial BusB 8", passed);
      #6; Clk = 0; #10; Clk = 1;
     passTest(BusA, 64'he, "Updated BusA 8", passed);
     passTest(BusB, 64'hf, "Updated BusB 8", passed);


      allPassed(passed, 68);
   end
   
endmodule
