module HADD(A, B, S, C);
input A, B;
output S, C;

xor x(A, B, S);
and a(A, B, C);

endmodule
