module SEXT(norm, in, out);
input norm;
input[2:0] in;
output[3:0] out;

buf b3(out[3], in[2]);
buf b2(out[2], in[2]);
bufif1 b1n(out[1], in[1], norm);
bufif0 b1d(out[1], 1'b1, norm);
bufif1 b0n(out[0], in[0], norm);
bufif0 b0d(out[0], 1'b0, norm);

endmodule
