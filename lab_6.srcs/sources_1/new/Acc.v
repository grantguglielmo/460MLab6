`define SIGNED_BIT_A                A[7]
`define EXPONENT_A                  A[6:4]
`define FRACTION_A                  A[3:0]

`define SIGNED_BIT_B                B[7]
`define EXPONENT_B                  B[6:4]
`define FRACTION_B                  B[3:0]

`define BIAS                        3'd3

module Acc(A, B, Q);
input[7:0] A, B;
output[7:0] Q;

wire [2:0] nonBiasExpA, nonBiasExpB, nonBiasExp;
wire [2:0] incrExp, normExp;
wire [3:0] fractionBitsA, sFracA;
wire [3:0] fractionBitsB, sFracB;
wire [3:0] addFractionBitsA;
wire [3:0] addFractionBitsB;
wire [1:0] fractionSelectionFlag;
wire [3:0] sum;
wire [3:0] shiftedSum, normSum;
wire       addEnable;
wire       endOperationFlag;
wire       expUnderflowDetector;
wire       expOverflowDetector;

// Example: A = 10.0 and B = 0.1 (A = 2 and B = 0.5)
//          A = 1.0 x 2^(1) B = 1.0 x 2^(-1)
//          A = 1.0 x 2^(1) B = 0.001 x 2^(1)

// Get non-biased exponent from IEEE format
getNonBiasExp expA(`EXPONENT_A, nonBiasExpA);
getNonBiasExp expB(`EXPONENT_B, nonBiasExpB);

assign fractionBitsA = `FRACTION_A;
assign fractionBitsB = `FRACTION_B;

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
shiftFractionWhenOverflow shiftFraction(endOperationFlag, sum, nonBiasExp, addFractionBitsA, addFractionBitsB, shiftedSum, incrExp);

// Normalize fraction
normFrac normalize(endOperationFlag, shiftedSum, incrExp, normSum, normExp);

// Check for exponent overflow
assign expOverflowDetector = ((nonBiasExpA < nonBiasExpB) && ((normExp + 1'b1) < 0) && !endOperationFlag) ? 1'b1 : 1'b0;
assign expUnderflowDetector = ((normSum[3] == normSum[2]) && ((normExp - 1'b1) > 0) && !endOperationFlag) ? 1'b1 : 1'b0;

// Round bits and renormalize if necessary
assign Q[7] = ((!expOverflowDetector && !expUnderflowDetector && (normSum > 0)) || endOperationFlag) ? 1'b0 : 1'b1;
assign Q[6:4] = (!expOverflowDetector && !expUnderflowDetector && !endOperationFlag) ? (normExp + `BIAS) 
                    : (endOperationFlag) ? 3'b100 : 3'b000;
assign Q[3:0] = (!expOverflowDetector && !expUnderflowDetector && !endOperationFlag) ? normSum : 4'b0000;
endmodule

module getNonBiasExp(biasExp, nonBiasExp);
    input [2:0] biasExp;
    output wire [2:0] nonBiasExp;
    
    assign nonBiasExp = biasExp - `BIAS;
endmodule

module matchExponent(exponentA, exponentB, incrementedExp, fractionSelectionFlag);
    input [2:0] exponentA, exponentB;
    output wire [2:0] incrementedExp; 
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
    input [3:0] fractionA, fractionB;
    wire  [3:0] tempF_A, tempF_B;
    output [3:0] sFracA, sFracB;
    output addEnable;
    
    assign tempF_A = fractionA;
    assign tempF_B = fractionB;
    
    assign sFracA = (!fractionSelectionFlag) ? (tempF_A >> 1'b1) : tempF_A;
    assign sFracB = (fractionSelectionFlag == 2'b01) ? (tempF_B >> 1'b1) : tempF_B;
    assign addEnable = (fractionSelectionFlag == 2'b10) ? 1'b1 : 1'b0;
endmodule

module fractionAdder(addEnable, fractionA, fractionB, sum);
    input addEnable;
    input [3:0] fractionA, fractionB; 
    output [3:0] sum;
    
    assign sum = (addEnable) ? (fractionA + fractionB) : 4'b0000;
endmodule

module checkZeroFromSum(sum, endOperationFlag);
    input sum;
    output endOperationFlag;
    
    assign endOperationFlag = (!sum) ? 1'b1 : 1'b0;
endmodule

module shiftFractionWhenOverflow(endOperationFlag, origSum, biasExp, fractionA, fractionB, sum, exponent);
    input endOperationFlag;
    input [3:0] fractionA, fractionB;
    input [2:0] biasExp;
    input [3:0] origSum;
    output [3:0] sum;
    output [2:0] exponent;
    
    assign sum = (((fractionA + fractionB) > 3'd7) && !endOperationFlag) ? origSum >> 1 : origSum;
    assign exponent = (((fractionA + fractionB) > 3'd7) && !endOperationFlag) ? (biasExp + 1'b1) : biasExp;
endmodule

module normFrac(endOperationFlag, sum, exponent, normSum, normExp);
    input endOperationFlag;
    input [3:0] sum;
    input [2:0] exponent;
    output [3:0] normSum;
    output [2:0] normExp;
    
    assign normSum = ((sum[3] == sum[2]) && (!endOperationFlag)) ? (sum << 1'b1): sum;
    assign normExp = ((sum[3] == sum[2]) && (!endOperationFlag)) ? (exponent - 1'b1) : exponent;
endmodule