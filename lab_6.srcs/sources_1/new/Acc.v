`define SIGNED_BIT_A                A[7]
`define EXPONENT_A                  A[6:4]
`define F_A                         A[3:0]

`define SIGNED_BIT_B                B[7]
`define EXPONENT_B                  B[6:4]
`define F_B                         B[3:0]

module Acc(A, B, Q);
input[7:0] A, B;
output[7:0] Q;
wire nonBiasExpA, nonBiasExpB, nonBiasExp;
wire [3:0] sum;
wire [3:0] tempF_A;
wire [3:0] tempF_B;
wire expUnderflowDetector;
wire expOverflowDetector;
reg accumulator;

initial begin
    accumulator <= 0;
end

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
assign nonBiasExp = (nonBiasExpA == nonBiasExpB) ? nonBiasExp : nonBiasExp;

// Check if sum is zero
assign Q[6:4] = (!sum) ? 3'b100 : Q[6:4];
assign Q[3:0] = (!sum) ? 3'b000 : Q[3:0];           

// If fraction overflow occurs, shift f to right by one and add one to exponent
assign sum = ((tempF_A + tempF_B) > 3'd7) ? sum >> 1 : sum;
assign nonBiasExpA = ((tempF_A + tempF_B) > 3'd7) ? (nonBiasExpA + 1'b1) : nonBiasExpA;
assign nonBiasExpB = ((tempF_A + tempF_B) > 3'd7) ? (nonBiasExpB + 1'b1) : nonBiasExpB;

// Normalize fraction
assign sum = (sum[3] == sum[2]) ? (sum << 1'b1) : sum;
assign nonBiasExp = (sum[3] == sum[2]) ? nonBiasExp - 1'b1 : nonBiasExp;

// Check for exponent overflow
assign expOverflowDetector = ((nonBiasExpA < nonBiasExpB) && ((nonBiasExp + 1'b1) < 0)) ? 1'b1 : 1'b0;
assign expUnderflowDetector = ((sum[3] == sum[2]) && ((nonBiasExp - 1'b1) > 0)) ? 1'b1 : 1'b0;

// Round bits and renormalize if necessary
assign Q[7] = (!expOverflowDetector && !expUnderflowDetector && (sum > 0)) ? 1'b0 : 1'b1;
assign Q[6:4] = (!expOverflowDetector && !expUnderflowDetector) ? (nonBiasExp + 3'd3) : 3'b000;
assign Q[3:0] = (!expOverflowDetector && !expUnderflowDetector) ? sum : 4'b0000;
endmodule
