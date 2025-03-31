`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA; // outputs of data read
    output [63:0] BusB; 
    input [63:0] BusW; // writing data
    input [4:0] RW, RA, RB; // read address A, B and Write
    input RegWr, Clk;
    
    reg [63:0] registers[31:0]; // 32x64 register
     
    assign #2 BusA = (RA == 0) ? 0 : registers[RA]; // data from registers to specific bus
    assign #2 BusB = (RB == 0) ? 0 : registers[RB]; // 2 tic delay
     
    always @ (negedge Clk) begin // based on negative clock edge
        if(RegWr && RW != 5'b11111) // prevent writes to reg 31
            registers[RW] <= #3 BusW; // write with 3 tic delay
    end
endmodule // end of module
