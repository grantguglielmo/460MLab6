module INF(A, B, S, E);
input[2:0] A, B, S;
output[2:0] E;
wire nota0, nota1, notb0, notb1;
wire h0, h1, h2, h3, h4, h5;
wire inf0, inf1, inf2, inf3, inf;

//A or B is inf so answer is inf
AND3 and0(A[0], A[1], A[2], h0);
AND3 and1(B[0], B[1], B[2], h1);
or or0(h0, h1, inf0);

not not0(A[0], nota0);
AND3 and2(A[2], A[1], nota0, h2);     //A is 3
and and3(h2, B[2], inf1);             //exp overflow to inf

not not1(B[0], notb0);
AND3 and4(B[2], B[1], notb0, h3);     //B is 3
and and5(h3, A[2], inf2);             //exp overflow to inf

//A and B are 2 so infinity exp
not not2(A[1], nota1);
not not3(B[1], notb1);
AND3 and6(A[2], nota1, A[0], h4);
AND3 and7(B[2], notb1, B[0], h5);
or or1(h4, h5, inf3);

//if any infN is true then exp is inf(3'b111)
OR4 or2(inf0, inf1, inf2, inf3, inf);
or or3(S[0], inf, E[0]);
or or4(S[1], inf, E[1]);
or or5(S[2], inf, E[2]);

endmodule
