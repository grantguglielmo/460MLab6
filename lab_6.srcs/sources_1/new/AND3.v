module AND3(A, B, C, O);
input A, B, C;
output O;
wire hold;

and a0(A, B, hold);
and a1(hold, C, O);

endmodule
