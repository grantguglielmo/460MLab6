module OR4(A, B, C, D, O);
input A, B, C, D;
output O;
wire hold0, hold1;

or or0(A, B, hold0);
or or1(C, D, hold1);
or or2(hold0, hold1, O);

endmodule
