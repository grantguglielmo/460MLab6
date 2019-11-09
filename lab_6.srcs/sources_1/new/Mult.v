module Mult(A, B, Q);
input[7:0] A, B;
output[7:0] Q;
wire[9:0] lrg_frac;
wire[4:0] frac;
wire[3:0] exp_add, no_bias;
wire[2:0] exp_uncheck, offset, a_exp, b_exp;
wire norma, normb;
wire c0, c1, c2;

xor x0(Q[7], A[7], B[7]);  //sign

ADD3 comp0(A[6:4], 3'b101, a_exp, c0);                          //remove bias from exp, 2's comp
ADD3 comp1(B[6:4], 3'b101, b_exp, c1);
ADD4 exp({a_exp[2], a_exp}, {b_exp[2], b_exp}, exp_add, c2);    //SEXT and add exp's

nor nor0(norma, A[2], A[1], A[0]);                         //check if normalized A or B
nor nor1(normb, B[2], B[1], B[0]);
MUL5 product({norma, A[3:0]}, {normb, B[3:0]}, lrg_frac);  //Multiply fraction, return 10 bit product

NORM norm(lrg_frac, frac, offset);                  //Round and normalize fraction
ADD4 off(exp_add, {offset[2], offset}, no_bias);    //offset new exp
ADD3 bias(no_bias[2:0], 3'b011, exp_uncheck);       //readd bias

assign Q[3:0] = frac;
assign Q[6:4] = exp_uncheck;

endmodule