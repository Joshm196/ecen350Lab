module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK
		   );

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [1:0] 			     signop;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A: Read data 1 (on diagram)
   wire [63:0] 			     regoutB;     // Output B

   // ALU connections
   wire [63:0] 			     aluout;
   wire 			     zero;

   // Sign Extender connections
   wire [63:0] 			     extimm;

   // PC update logic
   NextPClogic nextpclogic(
     .NextPC(nextpc),
     .CurrentPC(currentpc),
     .SignExtImm64(extimm),
     .Branch(branch),
     .ALUZero(zero),
     .Uncondbranch(uncond_branch)
   );
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Parts of instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .opcode(opcode)
		   );

   /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
  RegisterFile register_file(
    .BusA(regoutA), //Read data 1 (Feeds into ALU's Input which is not in the same order of output input)
    .BusB(regoutB),
    .BusW(MemtoRegOut),
    .RA(rm),
    .RB(rn),
    .RW(rd),
    .RegWr(regwrite),
    .Clk(CLK)
  );

  SignExtender sign_extender(
    .BusImm(extimm),
    .Instr(instruction[25:0]),
    .Ctrl(signop)
  );

  wire [63:0] ALU_inputB = alusrc ? extimm : regoutB;

  ALU alu(
    .BusA(regoutA), //Read data 1 (This is the input not output so regoutA can go here)
    .BusB(ALU_inputB),
    .ALUCtrl(aluctrl),
    .BusW(aluout),
    .Zero(zero)
  );

  wire [63:0] readdata;

  DataMemory data_memory(
    .ReadData(readdata),
    .Address(aluout),
    .WriteData(regoutB),
    .MemoryRead(memread),
    .MemoryWrite(memwrite),
    .Clock(CLK)
  );
  // memtoreg mux
  assign MemtoRegOut = mem2reg ? readdata : aluout;

endmodule





`timescale 1ns / 1ps

`define SIZE 1024

module DataMemory(ReadData , Address , WriteData , MemoryRead , MemoryWrite , Clock);
   input [63:0]      WriteData;
   input [63:0]      Address;
   input             Clock, MemoryRead, MemoryWrite;
   output reg [63:0] ReadData;

   reg [7:0] 	     memBank [`SIZE-1:0];


   // This task is used to write arbitrary data to the Data Memory by
   // the intialization block.
   task initset;
      input [63:0] addr;
      input [63:0] data;
      begin
	 memBank[addr] =  data[63:56] ; // Big-endian for the win...
	 memBank[addr+1] =  data[55:48];
	 memBank[addr+2] =  data[47:40];
	 memBank[addr+3] =  data[39:32];
	 memBank[addr+4] =  data[31:24];
	 memBank[addr+5] =  data[23:16];
	 memBank[addr+6] =  data[15:8];
	 memBank[addr+7] =  data[7:0];
      end
   endtask


   initial
     begin
        // preseting some data in the data memory used by test #1

        // Address 0x0 gets 0x1
        initset( 64'h0,  64'h1);  //Counter variable
        initset( 64'h8,  64'ha);  //Part of mask
        initset( 64'h10, 64'h5);  //Other part of mask
        initset( 64'h18, 64'h0ffbea7deadbeeff); //big constant
        initset( 64'h20, 64'h0); //clearing space

        // Add any data you need for your tests here.

     end

   // This always block reads the data memory and places a double word
   // on the ReadData bus.
   always @(posedge Clock)
     begin
        if(MemoryRead)
          begin
             ReadData[63:56] <=  memBank[Address];
             ReadData[55:48] <=  memBank[Address+1];
             ReadData[47:40] <=  memBank[Address+2];
             ReadData[39:32] <=  memBank[Address+3];
             ReadData[31:24] <=  memBank[Address+4];
             ReadData[23:16] <=  memBank[Address+5];
             ReadData[15:8] <=  memBank[Address+6];
             ReadData[7:0] <=  memBank[Address+7];
          end
     end

   // This always block takes data from the WriteData bus and writes
   // it into the DataMemory.
   always @(posedge Clock)
     begin
        if(MemoryWrite)
          begin
             memBank[Address] <= #3 WriteData[63:56] ;
             memBank[Address+1] <= #3 WriteData[55:48];
             memBank[Address+2] <= #3 WriteData[47:40];
             memBank[Address+3] <= #3 WriteData[39:32];
             memBank[Address+4] <= #3 WriteData[31:24];
             memBank[Address+5] <= #3 WriteData[23:16];
             memBank[Address+6] <= #3 WriteData[15:8];
             memBank[Address+7] <= #3 WriteData[7:0];
             // Could be useful for debugging:
             // $display("Writing Address:%h Data:%h",Address, WriteData);
          end
     end
endmodule


`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA; // outputs of data read
    output [63:0] BusB; 
    input [63:0] BusW; // writing data
    input [4:0] RW, RA, RB; // read address A, B and Write
    input RegWr, Clk;
    
    reg [63:0] registers[31:0]; // 32x64 register
     
    assign #2 BusA = RA == 31 ? 0 : registers[RA]; // data from registers to specific bus
    assign #2 BusB = RB == 31 ? 0 : registers[RB]; // 2 tic delay
     
    always @ (negedge Clk) begin // based on negative clock edge
        if(RegWr) // prevent writes to reg 31
            registers[RW] <= #3 BusW; // write with 3 tic delay
    end
endmodule // end of module


`timescale 1ns / 1ps

module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
    input [63:0] CurrentPC, SignExtImm64; 
    input Branch, ALUZero, Uncondbranch; 
    output [63:0] NextPC; 
    
    assign NextPC = (Uncondbranch | (Branch && ALUZero)) ? // if B or CBZ
                    (CurrentPC + (SignExtImm64 << 2)) : // convert instruction offset to byte offset, then add to current pc address
                    (CurrentPC + 4); // otherwise, go to next instruction
    
endmodule

`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    output  [63:0] BusW; // 64 bits
    input   [63:0] BusA, BusB; // 64 bits
    input   [3:0] ALUCtrl; // 4 bit alu control for and, or, add, sub, or passb
    output  Zero; // single bit
    
    reg     [63:0] BusW; // 64 bit output register
    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)
            `AND: begin
                BusW = BusA & BusB; // assign output to the "and" operation performed on BusA and BusB using '&'
            end
            `OR: begin
                BusW = BusA | BusB; // assign output to the "or" operation performed on BusA and BusB using '|'
            end
            `ADD: begin
                BusW = BusA + BusB; // assign sum to BusA + BusB
            end
            `SUB: begin
                BusW = BusA - BusB; // assign difference to BusA - BusB
            end
            `PassB: begin
                BusW = BusB; // directly assign output to BusB
            end
            default: begin
                BusW = 0; // default case - assign output to 0
            end
        endcase
    end

    assign Zero = BusW == 0; // using dataflow - the value of zero is based on whether the condition (BusW == 0) is true or false. if true, Zero is 1, else, 0.
endmodule // end module

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2025 10:49:37 PM
// Design Name: 
// Module Name: SignExtender
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SignExtender(BusImm, Instr, Ctrl); 
   output [63:0] BusImm; // output 64-bit extended immediate
   input [25:0]  Instr; // instruction bits 25-0
   input [1:0] Ctrl; // 2-bit control signal
   
   wire extBit; 
   assign extBit = (Ctrl == 2'b00) ? Instr[21] :  // I-type - sign extend bit 21
                   (Ctrl == 2'b01) ? Instr[20] :  // D-type - sign extend bit 20
                   (Ctrl == 2'b10) ? Instr[25] :  // B-type - sign extend bit 25
                   Instr[23]; // CB-type - sign extend bit 23

  assign BusImm = (Ctrl == 2'b00) ? {{52{extBit}}, Instr[21:10]} : // I-type (12-bit immediate)
                   (Ctrl == 2'b01) ? {{55{extBit}}, Instr[20:12]} : // D-type (9-bit immediate)
    (Ctrl == 2'b10) ? {{38{extBit}}, Instr[25:0], 2'b00} : // B-type (26-bit address)
  {{45{extBit}}, Instr[23:5], 2'b00}; // CB-type (19-bit address)

endmodule


`timescale 1ns / 1ps
/*
 * Module: InstructionMemory
 *
 * Implements read-only instruction memory
 * 
 */
module InstructionMemory(Data, Address);
   parameter T_rd = 20;
   parameter MemSize = 40;
   
   output [31:0] Data;
   input [63:0]  Address;
   reg [31:0] 	 Data;
   
   /*
    * ECEN 350 Processor Test Functions
    * Texas A&M University
    */
   
   always @ (Address) begin

      case(Address)

	/* Test Program 1:
	 * Program loads constants from the data memory. Uses these constants to test
	 * the following instructions: LDUR, ORR, AND, CBZ, ADD, SUB, STUR and B.
	 * 
	 * Assembly code for test:
	 * 
	 * 0: LDUR X9, [XZR, 0x0]    //Load 1 into x9
	 * 4: LDUR X10, [XZR, 0x8]   //Load a into x10
	 * 8: LDUR X11, [XZR, 0x10]  //Load 5 into x11
	 * C: LDUR X12, [XZR, 0x18]  //Load big constant into x12
	 * 10: LDUR X13, [XZR, 0x20]  //load a 0 into X13
	 * 
	 * 14: ORR X10, X10, X11  //Create mask of 0xf
	 * 18: AND X12, X12, X10  //Mask off low order bits of big constant
	 * 
	 * loop:
	 * 1C: CBZ X12, end  //while X12 is not 0
	 * 20: ADD X13, X13, X9  //Increment counter in X13
	 * 24: SUB X12, X12, X9  //Decrement remainder of big constant in X12
	 * 28: B loop  //Repeat till X12 is 0
	 * 2C: STUR X13, [XZR, 0x20]  //store back the counter value into the memory location 0x20
	 */
	

	63'h000: Data = 32'hF84003E9;
	63'h004: Data = 32'hF84083EA;
	63'h008: Data = 32'hF84103EB;
	63'h00c: Data = 32'hF84183EC;
	63'h010: Data = 32'hF84203ED;
	63'h014: Data = 32'hAA0B014A;
	63'h018: Data = 32'h8A0A018C;
	63'h01c: Data = 32'hB400008C;
	63'h020: Data = 32'h8B0901AD;
	63'h024: Data = 32'hCB09018C;
	63'h028: Data = 32'h17FFFFFD;
	63'h02c: Data = 32'hF80203ED;
	63'h030: Data = 32'hF84203ED;  //One last load to place stored value on memdbus for test checking.

	/* Add code for your tests here */

	
	default: Data = 32'hXXXXXXXX;
      endcase
   end
endmodule


`define OPCODE_ANDREG 11'b10001010000
`define OPCODE_ORRREG 11'b10101010000
`define OPCODE_ADDREG 11'b10001011000
`define OPCODE_SUBREG 11'b11001011000

`define OPCODE_ADDIMM 11'b1001000100x
`define OPCODE_SUBIMM 11'b1101000100x

`define OPCODE_MOVZ   11'b11010010100

`define OPCODE_B      11'b000101xxxxx
`define OPCODE_CBZ    11'b10110100xxx

`define OPCODE_LDUR   11'b11111000010
`define OPCODE_STUR   11'b11111000000

module control(
	       output reg 	reg2loc,
	       output reg 	alusrc,
	       output reg 	mem2reg,
	       output reg 	regwrite,
	       output reg 	memread,
	       output reg 	memwrite,
	       output reg 	branch,
	       output reg 	uncond_branch,
	       output reg [3:0] aluop,
	       output reg [1:0] signop,
	       input [10:0] 	opcode
	       );

    always @(*)
        begin
            casez (opcode)

          /* Add cases here for each instruction your processor supports */
          
      
			//R-Type: AND
            `OPCODE_ANDREG:
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0000;
                signop        = 2'bxx;
            end

			//R-Type: ORR
            `OPCODE_ORRREG:
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0001;
                signop        = 2'bxx;
            end

			//R-Type: ADD
            `OPCODE_ADDREG:
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0010;
                signop        = 2'bxx;
            end

			//R-Type: SUB
            `OPCODE_SUBREG:
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0110;
                signop        = 2'bxx;
            end

			//I-Type: ADDI
            `OPCODE_ADDIMM:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'b1;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0010;
                signop        = 2'b00;
            end

			//I-Type: SUBI
            `OPCODE_SUBIMM:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'b1;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0110;
                signop        = 2'b00;
            end

			//MOVZ 
            `OPCODE_MOVZ:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'b1;
                mem2reg       = 1'b0;
                regwrite      = 1'b1;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b1000;
                signop        = 2'b00;
            end

			//B  
            `OPCODE_B:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'bx;
                mem2reg       = 1'bx;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b1;
                aluop         = 4'bxxxx;
                signop        = 2'b10;
            end

			//CBZ 
            `OPCODE_CBZ:
            begin
                reg2loc       = 1'b1;
                alusrc        = 1'b0;
                mem2reg       = 1'bx;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b1;
                uncond_branch = 1'b0;
                aluop         = 4'b0111;
                signop        = 2'b01;
            end

			//LDUR
            `OPCODE_LDUR:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'b1;
                mem2reg       = 1'b1;
                regwrite      = 1'b1;
                memread       = 1'b1;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0010;
                signop        = 2'b11;
            end

			//STUR
            `OPCODE_STUR:
            begin
                reg2loc       = 1'b1;
                alusrc        = 1'b1;
                mem2reg       = 1'bx;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b1;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0010;
                signop        = 2'b11;
            end


        default:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'bx;
                mem2reg       = 1'bx;
                regwrite      = 1'bx;
                memread       = 1'bx;
                memwrite      = 1'bx;
                branch        = 1'bx;
                uncond_branch = 1'bx;
                aluop         = 4'bxxxx;
                signop        = 2'bxx;
            end
	endcase
     end

endmodule
