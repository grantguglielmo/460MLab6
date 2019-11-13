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
wire [1:0] fractionSelectionFlag;
wire       addEnable;
wire [3:0] sum;
wire       endOperationFlag;
wire [4:0] tempF_A;
wire [4:0] tempF_B;
wire [4:0] shiftedFraction;
wire expUnderflowDetector;
wire expOverflowDetector;

// Get non-biased exponent
getNonBiasExp expA(`EXPONENT_A, nonBiasExpA);
getNonBiasExp expB(`EXPONENT_B, nonBiasExpB);

// Convert to 2's complement
convertFractionToTwosComplement fractionA(`FRACTION_A, tempF_A);
convertFractionToTwosComplement fractionB(`FRACTION_B, tempF_B);

// Compare exponents and shift fraction with smallest exponent when necessary until exponents equal
matchExponent                exp(nonBiasExpA, nonBiasExpB, nonBiasExp, fractionSelectionFlag);
shiftFractionwithSmallestExp frac(fractionSelectionFlag, tempF_A, tempF_B, addEnable);

// Add fractions
fractionAdder sum_frac(addEnable, tempF_A, tempF_B, sum);

// Check if sum is zero
checkZeroFromSum checkSum(sum, endOperationFlag, Q);

// If fraction overflow occurs, shift f to right by one and add one to exponent
shiftFractionWhenOverflow shiftFraction(endOperationFlag, tempF_A, tempF_B, sum, nonBiasExp);

// Normalize fraction
normFrac normalize(endOperationFlag, sum, nonBiasExp);

// Check for exponent overflow
assign expOverflowDetector = ((nonBiasExpA < nonBiasExpB) && ((nonBiasExp + 1'b1) < 0)) ? 1'b1 : 1'b0;
assign expUnderflowDetector = ((sum[3] == sum[2]) && ((nonBiasExp - 1'b1) > 0)) ? 1'b1 : 1'b0;

// Round bits and renormalize if necessary
assign Q[7] = (!expOverflowDetector && !expUnderflowDetector && (sum > 0)) ? 1'b0 : 1'b1;
assign Q[6:4] = (!expOverflowDetector && !expUnderflowDetector) ? (nonBiasExp + 3'd3) : 3'b000;
assign Q[3:0] = (!expOverflowDetector && !expUnderflowDetector) ? sum : 4'b0000;
endmodule

module getNonBiasExp(biasExp, nonBiasExp);
    input [2:0] biasExp;
    output wire [2:0] nonBiasExp;
    
    assign nonBiasExp = biasExp - `BIAS;
endmodule

module convertFractionToTwosComplement(fractionBits, signedBit, twosComplementFraction);
    input [3:0] fractionBits;
    input signedBit;
    output wire [4:0] twosComplementFraction;
    
    assign twosComplementFraction = (signedBit) ? {1'b1, (~fractionBits) + 1'b1} : {1'b0, fractionBits}; 
endmodule

module matchExponent(exponentA, exponentB, incrementedExp, fractionSelectionFlag);
    input [2:0] exponentA, exponentB;
    output wire incrementedExp; 
    output wire [1:0] fractionSelectionFlag;
    
    assign incrementedExp = 
       (exponentA < exponentB) ? (exponentA + 1'b1) :
       (exponentA > exponentB) ? (exponentB + 1'b1) : exponentA;
    assign fractionSelectionFlag = 
       (exponentA < exponentB) ? 2'b00 :
       (exponentA > exponentB) ? 2'b01 : 2'b10;
endmodule

module shiftFractionwithSmallestExp(fractionSelectionFlag, fractionA, fractionB, addEnable);
    input [1:0] fractionSelectionFlag;
    inout [4:0] fractionA, fractionB;
    output addEnable;
    
    assign fractionA = (!fractionSelectionFlag) ? (fractionA >> 1'b1) : fractionA;
    assign fractionB = (fractionSelectionFlag == 2'b01) ? (fractionB >> 1'b1) : fractionB;
    assign addEnable = (fractionSelectionFlag == 2'b10) ? 1'b1 : 1'b0;
endmodule

module fractionAdder(addEnable, fractionA, fractionB, sum);
    input addEnable;
    input [4:0] fractionA, fractionB, sum;
    
    assign sum = (addEnable) ? (fractionA + fractionB) : 4'b0000;
endmodule

module checkZeroFromSum(sum, endOperationFlag, Q);
    input sum;
    output endOperationFlag;
    output [7:0] Q;
    
    assign Q[7] = (!sum) ? 1'b0: Q[7];
    assign Q[6:4] = (!sum) ? 3'b100 : Q[6:4];
    assign Q[3:0] = (!sum) ? 4'b0000 : Q[3:0]; 
    assign endOperationFlag = (!sum) ? 1'b1 : 1'b0;
endmodule

module shiftFractionWhenOverflow(endOperationFlag, fractionA, fractionB, sum, exponent);
    input endOperationFlag;
    input [4:0] fractionA, fractionB;
    inout [4:0] sum;
    inout [2:0] exponent;
    
    assign sum = (((fractionA + fractionB) > 3'd7) && !endOperationFlag) ? sum >> 1 : sum;
    assign exponent = (((fractionA + fractionB) > 3'd7) && !endOperationFlag) ? (exponent + 1'b1) : exponent;
endmodule

module normFrac(endOperationFlag, sum, exponent);
    input endOperationFlag;
    inout [4:0] sum;
    inout [2:0] exponent;
    
    assign sum = ((sum[3] == sum[2]) && (!endOperationFlag)) ? (sum << 1'b1) : sum;
    assign exponent = ((sum[3] == sum[2]) && (!endOperationFlag)) ? exponent - 1'b1 : exponent;
endmodule