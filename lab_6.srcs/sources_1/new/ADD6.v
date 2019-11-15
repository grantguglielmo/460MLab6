module ADD6(A, B, S, Cout);
input[5:0] A, B;
output[5:0] S;
output Cout;
wire c0, c1, c2, c3, c4;

HADD a0(A[0], B[0], S[0], c0);
FADD a1(A[1], B[1], c0, S[1], c1);
FADD a2(A[2], B[2], c1, S[2], c2);
FADD a3(A[3], B[3], c2, S[3], c3);
FADD a4(A[4], B[4], c3, S[4], c4);
FADD a5(A[5], B[5], c4, S[5], Cout);

endmodule
