module MultTest0();
reg[7:0] A, B;
wire[7:0] float;
reg[2:0] C, D;
wire[2:0] Sum;
wire Cout;
reg[4:0] L, R;
wire[9:0] Product;
reg[9:0] lrg_frac;
wire[4:0] round;
wire[2:0] offset;

Mult multiplier(A, B, float);
ADD3 adder(C, D, Sum, Cout);
MUL5 fixed_mul(L, R, Product);
NORM normailize(lrg_frac, round, offset);

initial begin
    A = 8'b00100011;
    B = 8'b00101111;
    #100;
    #100;
    #100;
end
endmodule
