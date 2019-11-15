module Top(CLK, Start, Ai, Bi, N);
input CLK, Start;
input[71:0] Ai, Bi;
output wire[71:0] N;
reg[2:0] run;
reg[7:0] a0, a1, a2, b0, b1, b2;
wire[7:0] r00, r01, r02, r10, r11, r12, r20, r21, r22;
wire[7:0] b00, b01, b02, b10, b11, b12, b20, b21, b22;

initial begin
    run <= 0;
    a0 <= 0;
    a1 <= 0;
    a2 <= 0;
    b0 <= 0;
    b1 <= 0;
    b2 <= 0;
end

MAC mac00(CLK, a0, b0, r00, b00, N[7:0]);
MAC mac01(CLK, r00, b1, r01, b01, N[15:8]);
MAC mac02(CLK, r01, b2, r02, b02, N[23:16]);

MAC mac10(CLK, a1, b00, r10, b10, N[31:24]);
MAC mac11(CLK, r10, b01, r11, b11, N[39:32]);
MAC mac12(CLK, r11, b02, r12, b12, N[47:40]);

MAC mac20(CLK, a2, b10, r20, b20, N[55:48]);
MAC mac21(CLK, r20, b11, r21, b21, N[63:56]);
MAC mac22(CLK, r21, b12, r22, b22, N[71:64]);

always @(posedge CLK) begin
    if(run > 0) begin
        case(run)
            4'b111: begin
                a0 <= Ai[15:8];
                a1 <= Ai[31:24];
                b0 <= Bi[31:24];
                b1 <= Bi[15:8];
            end
            4'b110: begin
                a0 <= Ai[23:16];
                a1 <= Ai[39:32];
                a2 <= Ai[55:48];
                b0 <= Bi[55:48];
                b1 <= Bi[39:32];
                b2 <= Bi[23:16];
            end
            4'b101: begin
                a0 <= 0;
                a1 <= Ai[47:40];
                a2 <= Ai[63:56];
                b0 <= 0;
                b1 <= Bi[63:56];
                b2 <= Bi[47:40];
            end
            4'b100: begin
                a1 <= 0;
                a2 <= Ai[71:64];
                b1 <= 0;
                b2 <= Bi[71:64];
            end
            4'b011: begin
                a2 <= 0;
                b2 <= 0;
            end
            4'b010: begin
            end
            4'b001: begin
            end
            default: begin
            end
        endcase
        run <= run - 1;
    end
    else if(Start) begin
        run <= 7;
        a0 <= Ai[7:0];
        b0 <= Bi[7:0];
    end
    else begin end
end

endmodule
