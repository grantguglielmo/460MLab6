module DFF(D, CLK, Q, Qn);
input D, CLK;
output Q, Qn;
wire CLKn, Qi, Qni, Dn;
wire w0, w1, w2, w3, w4, w5;

not inv(CLKn, CLK);
not inv1(Dn, D);

and n0(w0, D, CLKn);
and n1(w1, Dn, CLKn);
nor n2(w2, w0, w3);
nor n3(w3, w1, w2);
and n4(w4, w2, CLK);
and n5(w5, w3, CLK);
nor n6(Qi, w4, Qn);
nor n7(Qni, w5, Q);

assign Q = (Qi === 1'bX) ? 1'b0 : Qi;
assign Qn = (Qni === 1'bX) ? 1'b1 : Qni;

endmodule
