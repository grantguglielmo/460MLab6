module EDGE(exp_sum, exp_bias, frac, exp_out, frac_out);
input[3:0] exp_sum;
input[2:0] exp_bias;
input[4:0] frac;
output[2:0] exp_out;
output[3:0] frac_out;
wire inf, denorm0, denorm1, denorm2, denorm3, denorm4, denorm, norm;

and and0(inf, frac[4], exp_sum[2], !exp_sum[3]);
and and1(denorm0, exp_sum[3], exp_sum[2], exp_sum[1], !exp_sum[0], !frac[4]);
and and2(denorm1, exp_sum[3], exp_sum[2], !exp_sum[1], exp_sum[0]);
and and3(denorm2, exp_sum[3], exp_sum[2], !exp_sum[1], !exp_sum[0]);
and and4(denorm3, exp_sum[3], !exp_sum[2], exp_sum[1], exp_sum[0]);
and and5(denorm4, exp_sum[3], !exp_sum[2], exp_sum[1], !exp_sum[0]);
or or0(denorm, denorm0, denorm1, denorm2, denorm3, denorm4);
nor nor0(norm, denorm, inf);

BUFFIF3 b0(exp_bias, norm, exp_out);
BUFFIF3 b1(3'b111, inf, exp_out);
BUFFIF3 b2(3'b000, denorm, exp_out);

BUFFIF4 c0(frac[3:0], norm, frac_out);
BUFFIF4 c1(frac[3:0], inf, frac_out);
BUFFIF4 c2(frac[4:1], denorm0, frac_out);
BUFFIF4 c3({1'b0, frac[3:0]}, denorm1, frac_out);
BUFFIF4 c4({2'b00, frac[2:0]}, denorm2, frac_out);
BUFFIF4 c5({3'b000, frac[1:0]}, denorm3, frac_out);
BUFFIF4 c6({4'b0000, frac[0]}, denorm4, frac_out);


endmodule
