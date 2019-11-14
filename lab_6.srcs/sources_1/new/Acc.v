`define SIGNED_BIT_A                A[7]
`define EXPONENT_A                  A[6:4]
`define FRACTION_A                  A[3:0]

`define SIGNED_BIT_B                B[7]
`define EXPONENT_B                  B[6:4]
`define FRACTION_B                  B[3:0]

`define BIAS                        4'b0011

module Acc(A, B, Q);
input[7:0] A, B;
output[7:0] Q;

wire [3:0] nonBiasExpA, nonBiasExpB, nonBiasExp;
wire [3:0] incrExp, normExp;
wire [4:0] fractionBitsA, sFracA;
wire [4:0] fractionBitsB, sFracB;
wire [4:0] addFractionBitsA;
wire [4:0] addFractionBitsB;
wire [1:0] fractionSelectionFlag;
wire [5:0] sum;
wire [5:0] shiftedSum, normSum;
wire       addEnable;
wire       endOperationFlag;
wire       expUnderflowDetector;
wire       expOverflowDetector;

// Example: A = 10.0 and B = 0.1 (A = 2 and B = 0.5)
//          A = 1.0 x 2^(1) B = 1.0 x 2^(-1)
//          A = 1.0 x 2^(1) B = 0.001 x 2^(1)

// Get non-biased exponent from IEEE format
getNonBiasExp expA({1'b0, `EXPONENT_A}, nonBiasExpA);
getNonBiasExp expB({1'b0, `EXPONENT_B}, nonBiasExpB);

assign fractionBitsA = {1'b1, `FRACTION_A};
assign fractionBitsB = {1'b1, `FRACTION_B};

// Compare exponents and shift fraction with smallest exponent when necessary until exponents equal
matchExponent                exp(nonBiasExpA, nonBiasExpB, nonBiasExp, fractionSelectionFlag);
shiftFractionwithSmallestExp frac(fractionSelectionFlag, fractionBitsA, fractionBitsB, sFracA, sFracB, addEnable);

// Add fractions
assign addFractionBitsA = (`SIGNED_BIT_A) ? (-sFracA) : sFracA;
assign addFractionBitsB = (`SIGNED_BIT_B) ? (-sFracB) : sFracB;

fractionAdder sum_frac(addEnable, addFractionBitsA, addFractionBitsB, sum);

// Check if sum is zero; if zero, set endOperationFlag signal 
checkZeroFromSum checkSum(sum, endOperationFlag);

// If fraction overflow occurs, shift f to right by one and add one to exponent
shiftFractionWhenOverflow shiftFraction(endOperationFlag, sum, nonBiasExp, shiftedSum, incrExp);

// Normalize fraction
normFrac normalize(endOperationFlag, shiftedSum, incrExp, normSum, normExp);

// Check for exponent overflow
assign expOverflowDetector = (((normExp + `BIAS) >= 4'b1000) && !endOperationFlag) ? 1'b1 : 1'b0;
assign expUnderflowDetector = (((normExp + `BIAS) == 4'b0000) && !endOperationFlag) ? 1'b1 : 1'b0;

// Round bits and renormalize if necessary
assign Q[7] = ((!expOverflowDetector && !expUnderflowDetector && (normSum > 0)) || endOperationFlag) ? 1'b0 : 1'b1;
assign Q[6:4] = (!expOverflowDetector && !expUnderflowDetector && !endOperationFlag) ? (normExp[2:0] + `BIAS) : 3'b000;
assign Q[3:0] = (!expOverflowDetector && !expUnderflowDetector && !endOperationFlag) ? normSum[3:0] : 4'b0000;
endmodule

module getNonBiasExp(biasExp, nonBiasExp);
    input [3:0] biasExp;
    output wire [3:0] nonBiasExp;
    
    assign nonBiasExp = biasExp - `BIAS;
endmodule

module matchExponent(exponentA, exponentB, incrementedExp, fractionSelectionFlag);
    input [3:0] exponentA, exponentB;
    output wire [3:0] incrementedExp; 
    output wire [1:0] fractionSelectionFlag;
    
    assign incrementedExp = 
       (exponentA < exponentB) ? (exponentA + 1'b1) :
       (exponentA > exponentB) ? (exponentB + 1'b1) : exponentA;
    assign fractionSelectionFlag = 
       (exponentA < exponentB) ? 2'b00 :
       (exponentA > exponentB) ? 2'b01 : 2'b10;
endmodule

module shiftFractionwithSmallestExp(fractionSelectionFlag, fractionA, fractionB, sFracA, sFracB, addEnable);
    input [1:0] fractionSelectionFlag;
    input [4:0] fractionA, fractionB;
    wire  [4:0] tempF_A, tempF_B;
    output [4:0] sFracA, sFracB;
    output addEnable;
    
    assign tempF_A = fractionA;
    assign tempF_B = fractionB;
    
    assign sFracA = (!fractionSelectionFlag) ? (tempF_A >> 1'b1) : tempF_A;
    assign sFracB = (fractionSelectionFlag == 2'b01) ? (tempF_B >> 1'b1) : tempF_B;
    assign addEnable = (fractionSelectionFlag == 2'b10) ? 1'b1 : 1'b0;
endmodule

module fractionAdder(addEnable, fractionA, fractionB, sum);
    input addEnable;
    input [4:0] fractionA, fractionB; 
    output [5:0] sum;
    
    assign sum = (addEnable) ? (fractionA + fractionB) : 6'b000000;
endmodule

module checkZeroFromSum(sum, endOperationFlag);
    input [5:0] sum;
    output endOperationFlag;
    
    assign endOperationFlag = (!sum) ? 1'b1 : 1'b0;
endmodule

module shiftFractionWhenOverflow(endOperationFlag, origSum, biasExp, sum, exponent);
    input endOperationFlag;
    input [3:0] biasExp;
    input [5:0] origSum;
    output [5:0] sum;
    output [3:0] exponent;
    
    assign sum = ((origSum > 6'b010000) && !endOperationFlag) ? origSum >> 1 : origSum;
    assign exponent = ((origSum > 6'b010000) && !endOperationFlag) ? (biasExp + 1'b1) : biasExp;
endmodule

module normFrac(endOperationFlag, sum, exponent, normSum, normExp);
    input endOperationFlag;
    input [5:0] sum;
    input [3:0] exponent;
    output [5:0] normSum;
    output [3:0] normExp;
    
    assign normSum = ((sum[4] == 1'b0) && (!endOperationFlag)) ? (sum << 1'b1): sum;
    assign normExp = ((sum[4] == 1'b0) && (!endOperationFlag)) ? (exponent - 1'b1) : exponent;
endmodule