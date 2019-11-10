module INF(A, B, sum, S, E);
input[2:0] A, B, S;
input[3:0] sum;
output[2:0] E;
wire notneg, h0, h1, inf0, inf1, inf;

//A or B is inf so answer is inf
and and0(h0, A[2], A[1], A[0]);
and and1(h1, B[2], B[1], B[0]);
or or0(inf0, h0, h1);

//A + B + offset > 3, exp is inf
not not0(notneg, sum[3]);
and and2(inf1, notneg, sum[2]);

//if any infN is true then exp is inf(3'b111)
or or2(inf, inf0, inf1);
or or3(E[0], S[0], inf);
or or4(E[1], S[1], inf);
or or5(E[2], S[2], inf);

endmodule
