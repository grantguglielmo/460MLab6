module Mult(A, B, Q);
input[7:0] A, B;
output[7:0] Q;
wire[9:0] lrg_frac;
wire[3:0] no_bias, exp_add, exp_check;
wire norma, normb;
wire c0, c1;

xor x0(A[7], B[7], Q[7]);  //sign

ADD3 exp(A[6:4], B[6:4], no_bias, c0);              //add exp's
ADD3 bias(no_bias, 3'b101, exp_add, c1);            //account for bias in exp
INF inf_check(A[6:4], B[6:4], exp_add, exp_check);  //check if exp should be infinity

NOR3 nor0(A[2], A[1], A[0], norma);
NOR3 nor1(B[2], B[1], B[0], normb);
MUL5 frac({norma, A[3:0]}, {normb, B[3:0]}, lrg_frac);

endmodule