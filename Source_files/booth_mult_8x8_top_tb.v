`timescale 1ns / 1ps

module Booth_mult_tb;
    reg [7:0] a, b;
    wire [15:0] p;
    
    // Verification signals
    reg signed [15:0] expected_p;
    reg test_error; 
    integer i, j;

    // Instantiate your Top Module
    Booth_mult_8x8_Top uut (.a(a), .b(b), .p(p));

    initial begin
        a = 0; b = 0; test_error = 0;
        $display("Starting NCLaunch Simulation...");

        // Loop through critical ranges
        for (i = -128; i <= 127; i = i + 1) begin
            for (j = -128; j <= 127; j = j + 1) begin
                a = i[7:0];
                b = j[7:0];
                expected_p = $signed(a) * $signed(b);
                
                #5; // Wait for logic to propagate
                
                if (p !== expected_p) begin
                    test_error = 1;
                    $display("Error at: a=%d, b=%d | Got=%d, Expected=%d", $signed(a), $signed(b), p, expected_p);
                end else begin
                    test_error = 0;
                end
            end
        end
        $display("Simulation Finished.");
        $finish;
    end
endmodule
