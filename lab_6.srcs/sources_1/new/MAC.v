module MAC(CLK, left, top, right, bottom, out);
input CLK;
input[7:0] left, top;
output[7:0] right, bottom, out;
wire[7:0] mult, acc;

Reg8 r(left, CLK, right);     //pass left to right
Reg8 b(top, CLK, bottom);     //pass top to bottom
Reg8 o(acc, CLK, out);        //store mac value to out

Mult m(left, top, mult);    //multiply left and top
Acc0 a(mult, out, acc);      //add product to prev out

endmodule
