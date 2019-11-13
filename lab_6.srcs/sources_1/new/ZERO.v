module ZERO(sum_exp, in_exp, in_frac, out_exp, out_frac);
input[4:0] in_frac;
input[3:0] sum_exp;
input[2:0] in_exp;
output[2:0] out_exp;
output[3:0] out_frac;
wire bit0, bit1, bit2, denorm2, denorm3, denorm4;
wire infn, denorm0, denorm1, denorm, norm, denorm_bit, denorm5;

//denorm when not inf, and exp sum < -2

not not0(bit0, sum_exp[0]);
not not1(bit1, sum_exp[1]);
not not2(bit2, sum_exp[2]);
not not3(denorm_bit, in_frac[4]);
nand nand0(infn, in_exp[2], in_exp[1], in_exp[0]);
and and0(denorm0, sum_exp[3], sum_exp[2], sum_exp[1], bit0, denorm_bit, infn);
and and1(denorm1, sum_exp[3], sum_exp[2], bit1, sum_exp[0], infn);
and and2(denorm2, sum_exp[3], sum_exp[2], bit1, bit0, infn);
and and3(denorm3, sum_exp[3], bit2, sum_exp[1], sum_exp[0], infn);
and and4(denorm4, sum_exp[3], bit2, sum_exp[1], bit0, infn);
and and5(denorm5, sum_exp[3], bit2, bit1, infn);
or or0(denorm, denorm0, denorm1, denorm2, denorm3, denorm4, denorm5);
not not4(norm, denorm);

BUFFIF4 b0(in_frac[3:0], norm, out_frac);
BUFFIF4 b1(in_frac[4:1], denorm0, out_frac);
BUFFIF4 b5(in_frac[4:1], denorm1, out_frac);
BUFFIF4 b2({1'b0, in_frac[4:2]}, denorm2, out_frac);
BUFFIF4 b3({2'b00, in_frac[4:3]}, denorm3, out_frac);
BUFFIF4 b4({3'b000, in_frac[4]}, denorm4, out_frac);
BUFFIF4 b12(4'b0000, denorm5, out_frac);

bufif0 b6(out_exp[0], in_exp[0], denorm);
bufif1 b7(out_exp[0], 3'b000, denorm);
bufif0 b8(out_exp[1], in_exp[1], denorm);
bufif1 b9(out_exp[1], 3'b000, denorm);
bufif0 b10(out_exp[2], in_exp[2], denorm);
bufif1 b11(out_exp[2], 3'b000, denorm);

endmodule
