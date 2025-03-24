`timescale 1ns/1ps

module SignExtender_tb;
    reg [25:0] Instr;
    reg [1:0] Ctrl;
    wire [63:0] BusImm;

    SignExtender uut (.BusImm(BusImm), .Instr(Instr), .Ctrl(Ctrl));

    task check_output(input [63:0] expected);
        if (BusImm !== expected) 
            $display("ERROR: Ctrl=%b Instr=%h => Expected %h, Got %h", Ctrl, Instr, expected, BusImm);
        else 
            $display("PASS: Ctrl=%b Instr=%h => BusImm %h", Ctrl, Instr, BusImm);
    endtask

    initial begin
        // Test I-type (ADD, SUB) - 12-bit sign extension
        Ctrl = 2'b00; Instr = 26'h00000A; #10; check_output(64'h000000000000000A);
        Ctrl = 2'b00; Instr = 26'hFFF800; #10; check_output(64'hFFFFFFFFFFFFF800);

        // Test D-type (LDUR, STUR) - 9-bit sign extension
        Ctrl = 2'b01; Instr = 26'h000080; #10; check_output(64'h0000000000000080);
        Ctrl = 2'b01; Instr = 26'hFFFFC0; #10; check_output(64'hFFFFFFFFFFFFFFC0);

        // Test B-type (Branch) - 26-bit sign extension
        Ctrl = 2'b10; Instr = 26'h0200000; #10; check_output(64'h0000000002000000);
        Ctrl = 2'b10; Instr = 26'hFE00000; #10; check_output(64'hFFFFFFFFFE000000);

        // Test CB-type (CBZ, CBNZ) - 19-bit sign extension
        Ctrl = 2'b11; Instr = 26'h000400; #10; check_output(64'h0000000000000400);
        Ctrl = 2'b11; Instr = 26'hFFFFE0; #10; check_output(64'hFFFFFFFFFFFFFFE0);

        $finish;
    end
endmodule
