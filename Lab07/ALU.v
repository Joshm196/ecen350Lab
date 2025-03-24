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
