`define SIGNED_BIT_A                A[7]
`define EXPONENT_A                  A[6:4]
`define F_A                         A[3:0]

`define SIGNED_BIT_B                B[7]
`define EXPONENT_B                  B[6:4]
`define F_B                         B[3:0]

module Acc(A, B, Q);
input[7:0] A, B;
output[7:0] Q;
wire nonBiasExpA, nonBiasExpB;
wire [3:0] sum;
wire [3:0] tempF_A;
wire [3:0] tempF_B;

assign tempF_A = `F_A;
assign tempF_B = `F_B;

// Eliminate exponent bias
assign nonBiasExpA = `EXPONENT_A - 2'd3;
assign nonBiasExpB = `EXPONENT_B - 2'd3;

// Compare exponents and shift fraction with smallest exponent when necessary until exponents equal
assign nonBiasExpA = (nonBiasExpA < nonBiasExpB) ? (nonBiasExpA + 1'b1): nonBiasExpA;
assign nonBiasExpB = (nonBiasExpB < nonBiasExpA) ? (nonBiasExpB + 1'b1): nonBiasExpB;
assign tempF_A = (nonBiasExpA < nonBiasExpB) ? (tempF_A >> 1'b1): tempF_A;
assign tempF_B = (nonBiasExpB < nonBiasExpA) ? (tempF_B >> 1'b1): tempF_B;

// Check signed bit
assign tempF_A = (`SIGNED_BIT_A) ? -tempF_A : tempF_A; 
assign tempF_B = (`SIGNED_BIT_B) ? -tempF_B : tempF_B;

// Add fractions
assign sum = (nonBiasExpA == nonBiasExpB) ? (tempF_A + tempF_B) : sum;

// Check if sum is zero
assign Q[6:4] = (!sum) ? 3'b100 : Q[6:4];
assign Q[3:0] = (!sum) ? 3'b000 : Q[3:0];           

// If fraction overflow occurs, shift f to right by one and add one to exponent
assign sum = ((tempF_A + tempF_B) > 3'd7) ? sum >> 1 : sum;
assign nonBiasExpA = ((tempF_A + tempF_B) > 3'd7) ? (nonBiasExpA + 1'b1) : nonBiasExpA;
assign nonBiasExpB = ((tempF_A + tempF_B) > 3'd7) ? (nonBiasExpB + 1'b1) : nonBiasExpB;

// Normalize fraction
// Check for exponent overflow
// Round bits and renormalize if necessary

endmodule
