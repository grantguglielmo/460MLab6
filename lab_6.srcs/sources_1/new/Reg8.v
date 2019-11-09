module Reg8(D, CLK, Q);
input CLK;
input[7:0] D;
output[7:0] Q;

DFF b0(.D(D[0]), .CLK(CLK), .Q(Q[0]), .Qn());
DFF b1(.D(D[1]), .CLK(CLK), .Q(Q[1]), .Qn());
DFF b2(.D(D[2]), .CLK(CLK), .Q(Q[2]), .Qn());
DFF b3(.D(D[3]), .CLK(CLK), .Q(Q[3]), .Qn());
DFF b4(.D(D[4]), .CLK(CLK), .Q(Q[4]), .Qn());
DFF b5(.D(D[5]), .CLK(CLK), .Q(Q[5]), .Qn());
DFF b6(.D(D[6]), .CLK(CLK), .Q(Q[6]), .Qn());
DFF b7(.D(D[7]), .CLK(CLK), .Q(Q[7]), .Qn());

endmodule
