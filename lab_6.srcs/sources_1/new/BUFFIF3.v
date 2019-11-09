module BUFFIF3(A, sel, O);
input[2:0] A;
input sel;
output[2:0] O;

bufif1 b0(O[0], A[0], sel);
bufif1 b1(O[1], A[1], sel);
bufif1 b2(O[2], A[2], sel);

endmodule
