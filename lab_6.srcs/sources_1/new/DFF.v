module DFF(D, CLK, Q, Qn);
input D, CLK;
output Q, Qn;
wire CLKn;
wire w0, w1, w2, w3, w4, w5;

not inv(CLK, CLKn);

nand n0(D, CLK, w0);
nand n1(w0, CLK, w1);
nand n2(w0, w3, w2);
nand n3(w1, w2, w3);
nand n4(w2, CLKn, w4);
nand n5(w3, CLKn, w5);
nand n6(w4, Qn, Q);
nand n7(w5, Q, Qn);

endmodule
