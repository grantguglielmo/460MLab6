module DFF(D, CLK, Q, Qn);
input D, CLK;
output Q, Qn;
wire CLKn;
wire w0, w1, w2, w3, w4, w5;

not inv(CLKn, CLK);

nand n0(w0, D, CLK);
nand n1(w1, w0, CLK);
nand n2(w2, w0, w3);
nand n3(w3, w1, w2);
nand n4(w4, w2, CLKn);
nand n5(w5, w3, CLKn);
nand n6(Q, w4, Qn);
nand n7(Qn, w5, Q);

endmodule
