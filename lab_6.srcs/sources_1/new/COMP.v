module COMP(exp_a, exp_b, comp_e, aorb, exp_norm);
input[3:0] exp_a, exp_b;
output aorb;
output[3:0] comp_e, exp_norm;
wire[3:0] comp_a, comp_b, comp, inv_a, inv_b;
wire a_lrg, c0, c1, c2;

assign aorb = exp_a >= exp_b;

assign inv_a = ~exp_a;
assign inv_b = ~exp_b;

ADD4 add0(inv_a, 4'b0001, comp_a, c0);
ADD4 add1(inv_b, 4'b0001, comp_b, c1);

BUFFIF4 b0(comp_a, !aorb, comp);
BUFFIF4 b1(comp_b, aorb, comp);

BUFFIF4 b2(exp_a, aorb, exp_norm);
BUFFIF4 b3(exp_b, !aorb, exp_norm);

ADD4 add2(comp, exp_norm, comp_e, c2);

endmodule
