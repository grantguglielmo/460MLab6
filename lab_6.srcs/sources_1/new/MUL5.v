module MUL5(A, B, P);
input[4:0] A, B;
output[9:0] P;
wire p00, p01, p10, p02, p20, p03, p30, p04, p40;
wire p11, p12, p21, p13, p31, p14, p41;
wire p22, p23, p32, p24, p42;
wire p33, p34, p43;
wire p44;

//calculate partial products
and partial00(A[0], B[0], p00);

and partial01(A[0], B[1], p01);
and partial10(A[1], B[0], p10);

and partial02(A[0], B[2], p02);
and partial11(A[1], B[1], p11);
and partial20(A[2], B[0], p20);

and partial03(A[0], B[3], p03);
and partial12(A[1], B[2], p12);
and partial21(A[2], B[1], p21);
and partial30(A[3], B[0], p30);

and partial04(A[0], B[4], p04);
and partial13(A[1], B[3], p13);
and partial22(A[2], B[2], p22);
and partial31(A[3], B[1], p31);
and partial40(A[4], B[0], p40);

and partial14(A[1], B[4], p14);
and partial23(A[2], B[3], p23);
and partial32(A[3], B[2], p32);
and partial41(A[4], B[1], p41);

and partial24(A[2], B[4], p24);
and partial33(A[3], B[3], p33);
and partial42(A[4], B[2], p42);

and partial34(A[3], B[4], p34);
and partial43(A[4], B[3], p43);

and partial44(A[4], B[4], p44);


endmodule
