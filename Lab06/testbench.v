`timescale 1ns / 1ps


module SignExtenderTest;
    // Inputs
    reg [25:0] Instr;
    reg [1:0] Ctrl;
    
    // Output
    wire [63:0] BusImm;

    // Instantiate the Unit Under Test (UUT)
    SignExtender uut (
        .BusImm(BusImm), 
        .Instr(Instr), 
        .Ctrl(Ctrl)
    );

    // Test Cases
    initial begin
        // Display header
        $display("Time\tCtrl\tInstr\t\tBusImm");
        $monitor("%0t\t%b\t%h\t%h", $time, Ctrl, Instr, BusImm);

        // Test I-type (12-bit sign extension)
        Ctrl = 2'b00; Instr = 26'h00000A; #10;
        Ctrl = 2'b00; Instr = 26'hFFF800; #10;

        // Test D-type (9-bit sign extension)
        Ctrl = 2'b01; Instr = 26'h000080; #10;
        Ctrl = 2'b01; Instr = 26'hFFFFC0; #10;

        // Test B-type (26-bit sign extension)
        Ctrl = 2'b10; Instr = 26'h0200000; #10;
        Ctrl = 2'b10; Instr = 26'hFE00000; #10;

        // Test CB-type (19-bit sign extension)
        Ctrl = 2'b11; Instr = 26'h000400; #10;
        Ctrl = 2'b11; Instr = 26'hFFFFE0; #10;

        $finish;
    end
endmodule
