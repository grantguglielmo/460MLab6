module MultTest0();
reg[7:0] A, B;
wire[7:0] float;
reg[2:0] C, D;
wire[2:0] Sum;
wire Cout;
reg[4:0] L, R;
wire[9:0] Product;

Mult multiplier(A, B, float);
ADD3 adder(C, D, Sum, Cout);
MUL5 fixed_mul(L, R, Product);

initial begin
    A = 8'b01110000;
    B = 8'b01110000;
    C = 3'b001;
    D = 3'b010;
    L = 5'b00001;
    R = 5'b01011;
    #100;
    L = 5'b01011;
    C = 3'b010;
    #100;
    C = 3'b000;
    #100;
    C = 3'b011;
end
endmodule
