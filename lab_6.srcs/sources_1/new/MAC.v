module MAC(CLK, left, top, right, bottom, out);
input CLK;
input[7:0] left, top;
output[7:0] right, bottom, out;
wire[7:0] mult, acc;

Reg8(left, CLK, right);     //pass left to right
Reg8(top, CLK, bottom);     //pass top to bottom
Reg8(acc, CLK, out);        //store mac value to out

Mult m(left, top, mult);    //multiply left and top
Acc a(mult, out, acc);      //add product to prev out

endmodule
