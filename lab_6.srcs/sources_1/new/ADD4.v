module ADD4(A, B, S, Cout);
input[3:0] A, B;
output[3:0] S;
output Cout;
wire c0, c1, c2;

HADD a0(A[0], B[0], S[0], c0);
FADD a1(A[1], B[1], c0, S[1], c1);
FADD a2(A[2], B[2], c1, S[2], c2);
FADD a3(A[3], B[3], c2, S[3], Cout);

endmodule
