module INF(A, B, S, E);
input[2:0] A, B, S;
output[2:0] E;
wire nota0, nota1, notb0, notb1;
wire h0, h1, h2, h3, h4, h5;
wire inf0, inf1, inf2, inf3, inf;

//A or B is inf so answer is inf
and and0(h0, A[0], A[1], A[2]);
and and1(h1, B[0], B[1], B[2]);
or or0(inf0, h0, h1);

not not0(nota0, A[0]);
and and2(h2, A[2], A[1], nota0);      //A is 3
and and3(inf1, h2, B[2]);             //exp overflow to inf

not not1(notb0, B[0]);
and and4(h3, B[2], B[1], notb0);      //B is 3
and and5(inf2, h3, A[2]);             //exp overflow to inf

//A and B are 2 so infinity exp
not not2(nota1, A[1]);
not not3(notb1, B[1]);
and and6(h4, A[2], nota1, A[0]);
and and7(h5, B[2], notb1, B[0]);
or or1(inf3, h4, h5);

//if any infN is true then exp is inf(3'b111)
or or2(inf, inf0, inf1, inf2, inf3);
or or3(E[0], S[0], inf);
or or4(E[1], S[1], inf);
or or5(E[2], S[2], inf);

endmodule
