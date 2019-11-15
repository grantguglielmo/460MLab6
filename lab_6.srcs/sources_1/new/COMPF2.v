module COMPF2(frac_a, a_s, frac_b, b_s, in, out, sign);
input a_s, b_s;
input[4:0] frac_a, frac_b;
input[5:0] in;
output[5:0] out;
output sign;
wire neg;
wire[5:0] comp;

assign comp = (~in) + 1;
assign neg = ((frac_a > frac_b) && a_s) || ((frac_b > frac_a) && b_s);

BUFFIF6 b0(in, !neg, out);
BUFFIF6 b1(comp, neg, out);

assign sign = neg;

endmodule