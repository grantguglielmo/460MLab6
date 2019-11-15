module BUFFIF6(A, sel, O);
input[5:0] A;
input sel;
output[5:0] O;

bufif1 b0(O[0], A[0], sel);
bufif1 b1(O[1], A[1], sel);
bufif1 b2(O[2], A[2], sel);
bufif1 b3(O[3], A[3], sel);
bufif1 b4(O[4], A[4], sel);
bufif1 b5(O[5], A[5], sel);

endmodule