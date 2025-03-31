module RegisterFile(
    output reg [63:0] BusA,
    output reg [63:0] BusB,
    input  [63:0] BusW,
    input  [4:0] RA, RB, RW,
    input  RegWr, Clk
);

    // 32 registers, each 64-bit wide
    reg [63:0] registers [31:0];

    // Read operation with 2-cycle delay
    reg [63:0] readA_stage1, readB_stage1;
    reg [63:0] readA_stage2, readB_stage2;

    always @(posedge Clk) begin
        readA_stage1 <= (RA == 5'b11111) ? 64'b0 : registers[RA];
        readB_stage1 <= (RB == 5'b11111) ? 64'b0 : registers[RB];
    end
    
    always @(posedge Clk) begin
        readA_stage2 <= readA_stage1;
        readB_stage2 <= readB_stage1;
    end

    assign BusA = readA_stage2;
    assign BusB = readB_stage2;

    // Write operation with 3-cycle delay
    reg [63:0] write_stage1, write_stage2, write_stage3;
    reg [4:0] write_addr_stage1, write_addr_stage2, write_addr_stage3;
    reg write_enable_stage1, write_enable_stage2, write_enable_stage3;

    always @(posedge Clk) begin
        write_stage1        <= BusW;
        write_addr_stage1   <= RW;
        write_enable_stage1 <= RegWr;
    end
    
    always @(posedge Clk) begin
        write_stage2        <= write_stage1;
        write_addr_stage2   <= write_addr_stage1;
        write_enable_stage2 <= write_enable_stage1;
    end
    
    always @(posedge Clk) begin
        write_stage3        <= write_stage2;
        write_addr_stage3   <= write_addr_stage2;
        write_enable_stage3 <= write_enable_stage2;
    end
    
    always @(negedge Clk) begin
        if (write_enable_stage3 && write_addr_stage3 != 5'b11111) begin
            registers[write_addr_stage3] <= write_stage3;
        end
    end
    
endmodule
