`define OPCODE_ANDREG 11'b10001010000
`define OPCODE_ORRREG 11'b10101010000
`define OPCODE_ADDREG 11'b10001011000
`define OPCODE_SUBREG 11'b11001011000

`define OPCODE_ADDIMM 11'b1001000100x
`define OPCODE_SUBIMM 11'b1101000100x

`define OPCODE_MOVZ   11'b11010010100

`define OPCODE_B      11'b000101xxxxx
`define OPCODE_CBZ    11'b10110100000

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
            OPCODE_ANDREG:
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
            OPCODE_ORRREG:
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
            OPCODE_ADDREG:
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
            OPCODE_SUBREG:
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
            OPCODE_ADDIMM:
            begin
                reg2loc       = 1'b0;
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
            OPCODE_SUBIMM:
            begin
                reg2loc       = 1'b0;
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

			//
            "OPCODE":
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0000;
                signop        = 2'bxx;
            end

			//
            "OPCODE":
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0000;
                signop        = 2'bxx;
            end

			//
            "OPCODE":
            begin
                reg2loc       = 1'b0;
                alusrc        = 1'b0;
                mem2reg       = 1'b0;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'b0000;
                signop        = 2'bxx;
            end

        default:
            begin
                reg2loc       = 1'bx;
                alusrc        = 1'bx;
                mem2reg       = 1'bx;
                regwrite      = 1'b0;
                memread       = 1'b0;
                memwrite      = 1'b0;
                branch        = 1'b0;
                uncond_branch = 1'b0;
                aluop         = 4'bxxxx;
                signop        = 2'bxx;
            end
	endcase
     end

endmodule

