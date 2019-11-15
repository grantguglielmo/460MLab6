module NORMF(in_frac, out_frac, offset);
input[5:0] in_frac;
output[4:0] out_frac;
output[3:0] offset;
wire left1, non, right1, right2, right3, right4;

buf b0(left1, in_frac[5]);
and and0(non, !in_frac[5], in_frac[4]);
and and1(right1, !in_frac[5], !in_frac[4], in_frac[3]);
and and2(right2, !in_frac[5], !in_frac[4], !in_frac[3], in_frac[2]);
and and4(right3, !in_frac[5], !in_frac[4], !in_frac[3], !in_frac[2], in_frac[1]);
and and5(right4, !in_frac[5], !in_frac[4], !in_frac[3], !in_frac[2], !in_frac[1]);

BUFFIF5 b1(in_frac[5:1], left1, out_frac);
BUFFIF5 b2(in_frac[4:0] , non, out_frac);
BUFFIF5 b3({in_frac[3:0], 1'b0} , right1, out_frac);
BUFFIF5 b4({in_frac[2:0], 2'b00} , right2, out_frac);
BUFFIF5 b5({in_frac[1:0], 3'b000} , right3, out_frac);
BUFFIF5 b6({in_frac[0], 4'b0000} , right4, out_frac);

BUFFIF4 c0(4'b0001, left1, offset);
BUFFIF4 c1(4'b0000, non, offset);
BUFFIF4 c2(4'b1111, right1, offset);
BUFFIF4 c3(4'b1110, right2, offset);
BUFFIF4 c4(4'b1101, right3, offset);
BUFFIF4 c5(4'b1100, right4, offset);

endmodule
