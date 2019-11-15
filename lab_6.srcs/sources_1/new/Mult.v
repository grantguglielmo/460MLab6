module Mult(A, B, Q);
input[7:0] A, B;
output[7:0] Q;
wire[9:0] lrg_frac;
wire[4:0] frac;
wire[3:0] exp_add, no_bias, exp_a, exp_b, offset;
wire[2:0] exp_uncheck, exp_check, a_exp, b_exp;
wire sign;
wire norma, normb;
wire c0, c1, c2, c3, c4;

xor x0(sign, A[7], B[7]);  //sign

ADD3 comp0(A[6:4], 3'b101, a_exp, c0);              //remove bias from exp, 2's comp
ADD3 comp1(B[6:4], 3'b101, b_exp, c1);

or or0(norma, A[6], A[5], A[4]);                    //check if normalized A or B
or or1(normb, B[6], B[5], B[4]);

SEXT sext0(norma, a_exp, exp_a);                    //SEXT exp's and check underflow
SEXT sext1(normb, b_exp, exp_b);

ADD4 exp(exp_a, exp_b, exp_add, c2);                        //add exp's
MUL5 product({norma, A[3:0]}, {normb, B[3:0]}, lrg_frac);   //Multiply fraction, return 10 bit product

NORM norm(lrg_frac, frac, offset);                      //Round and normalize fraction
ADD4 off(exp_add, offset, no_bias, c3);                 //offset new exp
ADD3 bias(no_bias[2:0], 3'b011, exp_uncheck, c4);       //readd bias

//Check if inf/NaN/zero/denorm
INF inf_check(A[6:4], B[6:4], no_bias, exp_uncheck, exp_check);
ZERO zero_check(no_bias, exp_check, frac[4:0], Q[6:4], Q[3:0]);

assign Q[7] = (Q[6:0] == 7'b0000000) ? 0 : sign;

endmodule