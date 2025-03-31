`timescale 1ns/1ps

module RegisterFile(
    output reg [63:0] BusA,
    output reg [63:0] BusB,
    input  [63:0] BusW,
    input  [4:0] RA, RB, RW, 
    input  RegWr, Clk
);

    // 32 registers, each 64-bit wide
    reg [63:0] registers [31:0];

    // Ensure register 31 is always zero
    wire [63:0] register31;
    assign register31 = 64'b0;

    // Initialize all registers to zero (Use reset instead if needed)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 64'b0;
        end
    end

    // Read operation with 2-cycle delay using pipeline registers
    reg [63:0] readA_stage1, readA_stage2;
    reg [63:0] readB_stage1, readB_stage2;

    always @(posedge Clk) begin
        readA_stage1 <= (RA == 5'b11111) ? register31 : registers[RA];
        readB_stage1 <= (RB == 5'b11111) ? register31 : registers[RB];
    end

    always @(posedge Clk) begin
        readA_stage2 <= readA_stage1;
        readB_stage2 <= readB_stage1;
    end

    assign BusA = readA_stage2;
    assign BusB = readB_stage2;

    // Write operation with 3-cycle delay using pipeline registers
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

    // Perform actual write on negative edge
    always @(negedge Clk) begin
        if (write_enable_stage3 && write_addr_stage3 != 5'b11111) begin
            registers[write_addr_stage3] <= write_stage3;
        end
    end

endmodule
