module HADD(A, B, S, C);
input A, B;
output S, C;

xor x(S, A, B);
and a(C, A, B);

endmodule
