module Acc0(A, B, Q);
input[7:0] A, B;
output[7:0] Q;
wire norma, normb, c0, c1, aorb, c2, c3, c4;
wire[2:0] a_exp, b_exp, exp_bias;
wire[3:0] exp_a,  exp_b, comp_e, exp_norm, offset, exp_no_bias;
wire[4:0] frac_a, frac_b, norm_frac;
wire[5:0] a_frac, b_frac, frac_sum, frac;

ADD3 comp0(A[6:4], 3'b101, a_exp, c0);              //remove bias from exp, 2's comp
ADD3 comp1(B[6:4], 3'b101, b_exp, c1);

or or0(norma, A[6], A[5], A[4]);                    //check if normalized A or B
or or1(normb, B[6], B[5], B[4]);

SEXT sext0(norma, a_exp, exp_a);                    //SEXT exp's and check underflow
SEXT sext1(normb, b_exp, exp_b);

COMP comp_exp(exp_a, exp_b, comp_e, aorb, exp_norm);
SHIFT shift_frac({norma, A[3:0]}, {normb, B[3:0]}, aorb, comp_e, frac_a, frac_b);

COMPF compa(frac_a, A[7], a_frac);
COMPF compb(frac_b, B[7], b_frac);

ADD6 add_frac(a_frac, b_frac, frac_sum, c2);
COMPF2 comp_frac(frac_a, A[7], frac_b, B[7], frac_sum, frac, Q[7]);

NORMF normalize(frac, norm_frac, offset);
ADD4 add_off(exp_norm, offset, exp_no_bias, c3);
ADD3 add_bias(exp_no_bias[2:0], 3'b011, exp_bias, c4);

EDGE edge_case(A[6:4], B[6:4], exp_no_bias, exp_bias, norm_frac, Q[6:4], Q[3:0]);

endmodule
