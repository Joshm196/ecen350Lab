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
                   (Ctrl == 2'b10) ? {{38{extBit}}, Instr[25:0]} : // B-type (26-bit address)
   {{45{extBit}}, Instr[23:5]}; // CB-type (19-bit address)

endmodule