`timescale 1ns / 1ps

module Booth_mult_8x8_Top (
    input  [7:0] a, b,
    output [15:0] p
);

    wire signed [15:0] pp0, pp1, pp2, pp3;

    // 1. Partial Product Generation (Radix-4 Booth)
    booth_pp B0(a, {b[1], b[0], 1'b0}, pp0);
    booth_pp B1(a, {b[3], b[2], b[1]}, pp1);
    booth_pp B2(a, {b[5], b[4], b[3]}, pp2);
    booth_pp B3(a, {b[7], b[6], b[5]}, pp3);

    // 2. Alignment Shifting
    wire [15:0] pp0_s = pp0;
    wire [15:0] pp1_s = pp1 << 2;
    wire [15:0] pp2_s = pp2 << 4;
    wire [15:0] pp3_s = pp3 << 6;

    // 3. CSA Reduction Stage (Fixed Logic)
    // Compresses 4 PPs to 2 final vectors (sum_vec and carry_vec)
    wire [15:0] s1, c1, sum_vec, carry_vec;

    assign s1 = pp0_s ^ pp1_s ^ pp2_s;
    assign c1 = ((pp0_s & pp1_s) | (pp1_s & pp2_s) | (pp0_s & pp2_s)) << 1;

    assign sum_vec   = s1 ^ c1 ^ pp3_s;
    assign carry_vec = ((s1 & c1) | (c1 & pp3_s) | (s1 & pp3_s)) << 1;

    // 4. THE SWAPPABLE FINAL STAGE
    // Replace 'Final_Vector_Merge_StdCell' with your custom 16-bit modules
    // e.g., adder_16bit_rca or adder_16bit_cla
    Final_Vector_Merge_Block FINAL_ADDER_INST (
        .X(sum_vec),
        .Y(carry_vec),
        .Result(p)
    );

endmodule

// For Phase 1 (Baseline): This uses the '+' operator for Standard Cell mapping.

module Final_Vector_Merge_Block (
    input  [15:0] X, Y,
    output [15:0] Result
);
    // Baseline: Maps directly to library adder cells
    assign Result = X + Y; 
endmodule


module booth_pp (
    input  [7:0] a,
    input  [2:0] booth,
    output reg signed [15:0] pp
);
    always @(*) begin
        case (booth)
            3'b000, 3'b111: pp = 16'sd0;
            3'b001, 3'b010: pp = {{8{a[7]}}, a};            // +A
            3'b011:         pp = {{7{a[7]}}, a, 1'b0};      // +2A
            3'b100:         pp = -({{7{a[7]}}, a, 1'b0});   // -2A
            3'b101, 3'b110: pp = -({{8{a[7]}}, a});         // -A
            default:        pp = 16'sd0;
        endcase
    end
endmodule
