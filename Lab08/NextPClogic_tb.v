`timescale 1ns / 1ps

`define STRLEN 20
module NextPClogic_tb;

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
    reg [63:0] CurrentPC, SignExtImm64;
    reg Branch, ALUZero, Uncondbranch;
    reg [7:0] passed;
    
    // Outputs
    wire [63:0] NextPC;

    // Instantiate the Unit Under Test (UUT)
    NextPClogic uut (
        .NextPC(NextPC), 
        .CurrentPC(CurrentPC), 
        .SignExtImm64(SignExtImm64),
        .Branch(Branch), 
        .ALUZero(ALUZero), 
        .Uncondbranch(Uncondbranch)
    );

    initial begin
        // Initialize Inputs
        $dumpfile("NextPClogic.vcd");
        $dumpvars(0, NextPClogic_tb);
        CurrentPC = 64'h0;
        SignExtImm64 = 64'h0;
        Branch = 0;
        ALUZero = 0;
        Uncondbranch = 0;
        passed = 0;
        
        // test 1: all signals 0
        #10; CurrentPC = 64'h4;
        SignExtImm64 = 64'h4;
        Branch = 0;
        ALUZero = 0;
        Uncondbranch = 0;
        $display("Test 1 - CurrentPC = %h, SignExtImm64 = %h, Branch = %b, ALUZero = %b, Uncondbranch = %b", CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      #10; passTest(NextPC, 64'h8, "Default", passed); 

        // test 2: ALUZero = 1
        #10; CurrentPC = 64'h4;
        SignExtImm64 = 64'h4;
        Branch = 1;
        ALUZero = 1;
        Uncondbranch = 0;
        $display("Test 2 - CurrentPC = %h, SignExtImm64 = %h, Branch = %b, ALUZero = %b, Uncondbranch = %b", CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      #10; passTest(NextPC, 64'h14, "ALUZero = 1", passed); 

        // test 3: ALUZero = 0
        #10; CurrentPC = 64'h4;
        SignExtImm64 = 64'h4;
        Branch = 1;
        ALUZero = 0;
        Uncondbranch = 0;
        $display("Test 3 - CurrentPC = %h, SignExtImm64 = %h, Branch = %b, ALUZero = %b, Uncondbranch = %b", CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        #10; passTest(NextPC, 64'h8, "ALUZero = 0", passed);

        // test 4: Uncondbranch = 1
        #10; CurrentPC = 64'h4;
        SignExtImm64 = 64'h8;
        Branch = 0;
        ALUZero = 0;
        Uncondbranch = 1;
        $display("Test 4 - CurrentPC = %h, SignExtImm64 = %h, Branch = %b, ALUZero = %b, Uncondbranch = %b", CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      #10; passTest(NextPC, 64'h24, "Unconditional Branch", passed);

        // test 5: negative offset for conditional branch
        #10; CurrentPC = 64'h8;
        SignExtImm64 = 64'hFFFFFFFFFFFFFFF8; // negative
        Branch = 1;
        ALUZero = 1;
        Uncondbranch = 0;
        $display("Test 5 - CurrentPC = %h, SignExtImm64 = %h, Branch = %b, ALUZero = %b, Uncondbranch = %b", CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      #10; passTest(NextPC, 64'hFFFFFFFFFFFFFFE8, "Negative Offset Branch", passed);

        // test 6: negative offset for unconditional branch
        #10; CurrentPC = 64'h8;
        SignExtImm64 = 64'hFFFFFFFFFFFFFFF8; // negative
        Branch = 0;
        ALUZero = 0;
        Uncondbranch = 1;
        $display("Test 6 - CurrentPC = %h, SignExtImm64 = %h, Branch = %b, ALUZero = %b, Uncondbranch = %b", CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
      #10; passTest(NextPC, 64'hFFFFFFFFFFFFFFE8, "Unconditional Negative Offset Branch", passed);

        #10;
        allPassed(passed, 6);
    end
      
endmodule