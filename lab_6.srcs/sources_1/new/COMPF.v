module COMPF(in, sign, out);
input sign;
input[4:0] in;
output[5:0] out;
wire[4:0] comp;

assign comp = (~in) + 1;

BUFFIF6 b0({1'b0, in}, !sign, out);
BUFFIF6 b1({1'b1, comp}, sign, out);

endmodule
