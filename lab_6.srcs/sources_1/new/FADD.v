module FADD(A, B, Cin, S, Cout);
input A, B, Cin;
output S, Cout;
wire x0, x1, x2;

HADD add0(A, B, x0, x1);
HADD add1(x0, Cin, S, x2);
or o(Cout, x1, x2);

endmodule