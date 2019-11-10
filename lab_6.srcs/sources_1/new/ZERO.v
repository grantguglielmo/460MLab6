module ZERO(sum_exp, in_exp, in_frac, out_exp, out_frac);
input[4:0] in_frac;
input[3:0] sum_exp;
input[2:0] in_exp;
output[2:0] out_exp;
output[3:0] out_frac;
wire infn, denorm0, denorm, norm;

//denorm when not inf, and exp sum < -2
nand nand0(infn, in_exp[2], in_exp[1], in_exp[0]);
nand nand1(denorm0, sum_exp[2], sum_exp[1]);
and and1(denorm, sum_exp[3], denorm0, infn);
not not0(norm, denorm);

BUFFIF4 b0(in_frac[3:0], norm, out_frac);
BUFFIF4 b1(in_frac[4:1], denorm, out_frac);

xor x0(out_exp[0], in_exp[0], denorm);
xor x1(out_exp[1], in_exp[1], denorm);
xor x2(out_exp[2], in_exp[2], denorm);

endmodule
