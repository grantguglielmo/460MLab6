`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2019 03:29:07 PM
// Design Name: 
// Module Name: AddTest0
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


module AddTest0();
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Q;
    
    Acc0 adder(A, B, Q);
    
    initial begin
        A = 8'b01001100; // x4C
        B = 8'b00110111; // x37
        #100;
        A = 8'b11100111; // xE7
        B = 8'b00011000; // x18 // Add with big negative number
        #100;
        A = 8'b01101000; // x68
        B = 8'b01101000; // x68 // Overflow test
        #100;
        A = 8'b11101000; // xE8
        B = 8'b11101000; // xE8 // Underflow test
        #100;
        A = 8'b11111000; // xF8
        B = 8'b11101000; // xE8 // 111 exp test case
        #100;
        A = 8'b10001000; // x88
        B = 8'b11101000; // xE8 // 000 exp test case
        #100;
        A = 8'b00000000; // x00
        B = 8'b00000000; // x00 // Another 000 exp test case
        #100;
    end
endmodule
