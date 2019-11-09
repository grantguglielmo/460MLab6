module NORM(full_frac, frac, offset);
input[9:0] full_frac;
output[4:0] frac;
output[2:0] offset;
wire b9n, b8n, b7n;
wire no_norm, left_norm, right_norm1, right_norm2;

not not0(b9n, full_frac[9]);
not not1(b8n, full_frac[8]);
not not2(b7n, full_frac[7]);
buf buf0(left_norm, full_frac[9]);
and and0(no_norm, b9n, full_frac[8]);
and and1(right_norm1, b9n, b8n, full_frac[7]);
and and2(right_norm2, b9n, b8n, b7n);

BUFFIF5 buff1(full_frac[9:5], left_norm, frac);
BUFFIF5 buff2(full_frac[8:4], no_norm, frac);
BUFFIF5 buff3(full_frac[7:3], right_norm1, frac);
BUFFIF5 buff4(full_frac[6:2], right_norm2, frac);

BUFFIF3 buff5(3'b001, left_norm, offset);
BUFFIF3 buff6(3'b000, no_norm, offset);
BUFFIF3 buff7(3'b111, right_norm1, offset);
BUFFIF3 buff8(3'b110, right_norm2, offset);

endmodule
