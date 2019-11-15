module MACTest0();
reg CLK, start;
reg[7:0] A [2:0] [2:0];
reg[7:0] B [2:0] [2:0];
wire[7:0] N [2:0] [2:0];
wire[71:0] N_flat;
wire[71:0] A_flat;
wire[71:0] B_flat;

assign A_flat = {A[2][2], A[2][1], A[2][0], A[1][2], A[1][1], A[1][0], A[0][2], A[0][1], A[0][0]};
assign B_flat = {B[2][2], B[2][1], B[2][0], B[1][2], B[1][1], B[1][0], B[0][2], B[0][1], B[0][0]};
assign N[0][0] = N_flat[7:0];
assign N[0][1] = N_flat[15:8];
assign N[0][2] = N_flat[23:16];
assign N[1][0] = N_flat[31:24];
assign N[1][1] = N_flat[39:32];
assign N[1][2] = N_flat[47:40];
assign N[2][0] = N_flat[55:48];
assign N[2][1] = N_flat[63:56];
assign N[2][2] = N_flat[71:64];

Top matrix_mul(CLK, start, A_flat, B_flat, N_flat);

always #50 CLK=~CLK;

initial begin
    CLK = 0;
    start = 0;
    A[0][0] = 8'b00111000;
    A[0][1] = 8'b00110100;
    A[0][2] = 8'b00110010;
    A[1][0] = 8'b00111000;
    A[1][1] = 8'b00110100;
    A[1][2] = 8'b00110010;
    A[2][0] = 8'b00111000;
    A[2][1] = 8'b00110100;
    A[2][2] = 8'b00110010;
    
    B[0][0] = 8'b00110000;
    B[0][1] = 8'b00110000;
    B[0][2] = 8'b00110000;
    B[1][0] = 8'b00110000;
    B[1][1] = 8'b00110000;
    B[1][2] = 8'b00110000;
    B[2][0] = 8'b00110000;
    B[2][1] = 8'b00110000;
    B[2][2] = 8'b00110000;
    
    #10;
    start = 1;
    #100;
    start = 0;
    #790;
    $finish;
end
endmodule
