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
    
    Acc adder(A, B, Q);
    
    initial begin
        A = 8'b01001100; // x4C
        B = 8'b00110111; // x37
        #100;
    end
endmodule
