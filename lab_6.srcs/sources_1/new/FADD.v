module FADD(A, B, Cin, S, Cout);
input A, B, Cin;
output S, Cout;
wire x0, x1, x2;

HADD(A, B, x0, x1);
HADD(x0, Cin, S, x2);
or o(x1, x2, Cout);

endmodule