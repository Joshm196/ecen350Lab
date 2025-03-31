`timescale 1ns / 1ps

module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
    input [63:0] CurrentPC, SignExtImm64; 
    input Branch, ALUZero, Uncondbranch; 
    output [63:0] NextPC; 
    
    assign NextPC = (Uncondbranch | (Branch && ALUZero)) ? // if B or CBZ
                    (CurrentPC + (SignExtImm64 << 2)) : // convert instruction offset to byte offset, then add to current pc address
                    (CurrentPC + 4); // otherwise, go to next instruction
    
endmodule