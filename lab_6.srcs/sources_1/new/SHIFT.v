module SHIFT(in_a, in_b, aorb, comp_exp, frac_a, frac_b);
input aorb;
input[3:0] comp_exp;
input[4:0] in_a, in_b;
output[4:0] frac_a, frac_b;
wire left0a, left1a, left2a, left3a, left4a, left5a;
wire left0b, left1b, left2b, left3b, left4b, left5b;

and and0(left0a, !comp_exp[3], !comp_exp[2], !comp_exp[1], !comp_exp[0], !aorb);
and and1(left1a, !comp_exp[3], !comp_exp[2], !comp_exp[1], comp_exp[0], !aorb);
and and2(left2a, !comp_exp[3], !comp_exp[2], comp_exp[1], !comp_exp[0], !aorb);
and and3(left3a, !comp_exp[3], !comp_exp[2], comp_exp[1], comp_exp[0], !aorb);
and and4(left4a, !comp_exp[3], comp_exp[2], !comp_exp[1], !comp_exp[0], !aorb);
and and5(left5a, !comp_exp[3], comp_exp[2], !comp_exp[1], comp_exp[0], !aorb);

and and6(left0b, !comp_exp[3], !comp_exp[2], !comp_exp[1], !comp_exp[0], aorb);
and and7(left1b, !comp_exp[3], !comp_exp[2], !comp_exp[1], comp_exp[0], aorb);
and and8(left2b, !comp_exp[3], !comp_exp[2], comp_exp[1], !comp_exp[0], aorb);
and and9(left3b, !comp_exp[3], !comp_exp[2], comp_exp[1], comp_exp[0], aorb);
and and10(left4b, !comp_exp[3], comp_exp[2], !comp_exp[1], !comp_exp[0], aorb);
and and11(left5b, !comp_exp[3], comp_exp[2], !comp_exp[1], comp_exp[0], aorb);

BUFFIF5 b0(in_a, aorb, frac_a);
BUFFIF5 b1(in_a, left0a, frac_a);
BUFFIF5 b2({1'b0, in_a[4:1]}, left1a, frac_a);
BUFFIF5 b3({2'b00, in_a[4:2]}, left2a, frac_a);
BUFFIF5 b4({3'b000, in_a[4:3]}, left3a, frac_a);
BUFFIF5 b5({4'b0000, in_a[4]}, left4a, frac_a);
BUFFIF5 b6(5'b00000, left5a, frac_a);

BUFFIF5 c0(in_b, !aorb, frac_b);
BUFFIF5 c1(in_b, left0b, frac_b);
BUFFIF5 c2({1'b0, in_b[4:1]}, left1b, frac_b);
BUFFIF5 c3({2'b00, in_b[4:2]}, left2b, frac_b);
BUFFIF5 c4({3'b000, in_b[4:3]}, left3b, frac_b);
BUFFIF5 c5({4'b0000, in_b[4]}, left4b, frac_b);
BUFFIF5 c6(5'b00000, left5b, frac_b);

endmodule