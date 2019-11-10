module BUFFIF4(A, sel, O);
input[3:0] A;
input sel;
output[3:0] O;

bufif1 b0(O[0], A[0], sel);
bufif1 b1(O[1], A[1], sel);
bufif1 b2(O[2], A[2], sel);
bufif1 b3(O[3], A[3], sel);

endmodule
