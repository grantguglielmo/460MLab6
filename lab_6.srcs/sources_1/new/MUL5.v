module MUL5(A, B, P);
input[4:0] A, B;
output[9:0] P;
wire p01, p10, p02, p20, p03, p30, p04, p40;
wire p11, p12, p21, p13, p31, p14, p41;
wire p22, p23, p32, p24, p42, p33, p34, p43, p44;
wire c10, c20, c30, c40, c02, c12, c22, c32;
wire c03, c13, c23, c33, c04, c14, c24, c34;
wire c01, c11, c21, s20, s30, s40, s12, s22, s32;
wire s13, s23, s33, s14, s24, s34;


//calculate partial products
and partial00(P[0], A[0], B[0]);

and partial01(p01, A[0], B[1]);
and partial10(p10, A[1], B[0]);

and partial02(p02, A[0], B[2]);
and partial11(p11, A[1], B[1]);
and partial20(p20, A[2], B[0]);

and partial03(p03, A[0], B[3]);
and partial12(p12, A[1], B[2]);
and partial21(p21, A[2], B[1]);
and partial30(p30, A[3], B[0]);

and partial04(p04, A[0], B[4]);
and partial13(p13, A[1], B[3]);
and partial22(p22, A[2], B[2]);
and partial31(p31, A[3], B[1]);
and partial40(p40, A[4], B[0]);

and partial14(p14, A[1], B[4]);
and partial23(p23, A[2], B[3]);
and partial32(p32, A[3], B[2]);
and partial41(p41, A[4], B[1]);

and partial24(p24, A[2], B[4]);
and partial33(p33, A[3], B[3]);
and partial42(p42, A[4], B[2]);

and partial34(p34, A[3], B[4]);
and partial43(p43, A[4], B[3]);

and partial44(p44, A[4], B[4]);

HADD S10(p10, p01, P[1], c10);
HADD S20(p20, p11, s20, c20);
HADD S30(p30, p21, s30, c30);
HADD S40(p40, p31, s40, c40);

FADD S02(p02, s20, c10, P[2], c02);
FADD S12(p12, s30, c20, s12, c12);
FADD S22(p22, s40, c30, s22, c22);
FADD S32(p32, p41, c40, s32, c32);

FADD S03(p03, s12, c02, P[3], c03);
FADD S13(p13, s22, c12, s13, c13);
FADD S23(p23, s32, c22, s23, c23);
FADD S33(p33, p42, c32, s33, c33);

FADD S04(p04, s13, c03, P[4], c04);
FADD S14(p14, s23, c13, s14, c14);
FADD S24(p24, s33, c23, s24, c24);
FADD S34(p34, p43, c33, s34, c34);

HADD S01(s14, c04, P[5], c01);
FADD S11(s24, c14, c01, P[6], c11);
FADD S21(s34, c24, c11, P[7], c21);
FADD S31(p44, c34, c21, P[8], P[9]);

endmodule
