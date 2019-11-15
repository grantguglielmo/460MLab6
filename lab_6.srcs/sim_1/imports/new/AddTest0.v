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
        //0x53
        #100;
        A = 8'b01000101;
        B = 8'b01000111;
        //0x56
        #100;
        A = 8'b01000111;
        B = 8'b11000111;
        //0x00
        #100;
        A = 8'b11000111;
        B = 8'b00110001;
        //0xbe
        #100;
        A = 8'b01100000;
        B = 8'b01101010;
        //0x75
        #100;
        A = 8'b01100001;
        B = 8'b11101011;
        //0xd4
        #100;
        A = 8'b00000011;
        B = 8'b00000001;
        //0x04
        #100;
        A = 8'b00001000;
        B = 8'b00001010;
        //0x12
        #100;
        A = 8'b01111111;
        B = 8'b01111111;
        //0x7f
        #100;
        A = 8'b00000000;
        B = 8'b11011010;
        //0xda
        #100;
        A = 8'b00000000;
        B = 8'b00000000;
        //0x00
        #100;
        A = 8'b11111000;
        B = 8'b11101000;
        //0xfc
        #100;
        A = 8'b11010100;
        B = 8'b01011000;
        //0x30
        #100;
        $finish;
    end
endmodule
