module NOR3(A, B, C, O);
input A, B, C;
output O;
wire hold;

nor nor0(A, B, hold);
nor nor1(hold, C, O);

endmodule