`timescale 1ns / 1ps

// 1. Transaction Class with Constraints
class booth_tx;
    rand bit signed [7:0] a;
    rand bit signed [7:0] b;

    // Constraint: Weight corner cases heavily, but allow all other values
    constraint corner_cases {
        a dist { 8'sd127 :/ 1, 8'sd_128 :/ 1, 8'sd0 :/ 1, [-127:126] :/ 5 };
        b dist { 8'sd127 :/ 1, 8'sd_128 :/ 1, 8'sd0 :/ 1, [-127:126] :/ 5 };
    }
endclass

// 2. Testbench Top
module tb_booth;
    logic signed [7:0] a, b;
    logic signed [15:0] p;
    logic signed [15:0] expected_p;

    // Instantiate DUT
    Booth_mult_8x8_Top dut (
        .a(a),
        .b(b),
        .p(p)
    );

    booth_tx tx;

    initial begin
        tx = new();
        
        $display("==================================================");
        $display("Starting Constrained Random Verification");
        $display("==================================================");

        repeat(50) begin
            // Generate random constrained values
            if (!tx.randomize()) $fatal("Randomization failed!");
            
            a = tx.a;
            b = tx.b;
            #10; // Wait for combinational logic to settle
            
            // Reference model check
            expected_p = a * b;

            if (p !== expected_p) begin
                // Detailed Error Display
                $display("\n[FAIL] Time: %0t | A: %0d, B: %0d", $time, a, b);
                $display("       Expected: %0d | Actual: %0d", expected_p, p);
                
                // Hierarchical debugging (probing internal DUT wires)
                $display("       --- Internal Datapath Debug ---");
                $display("       PP0: %0d (0x%0h)", $signed(dut.pp0), dut.pp0);
                $display("       PP1: %0d (0x%0h) | Shifted: %0d", $signed(dut.pp1), dut.pp1, $signed(dut.pp1_s));
                $display("       PP2: %0d (0x%0h) | Shifted: %0d", $signed(dut.pp2), dut.pp2, $signed(dut.pp2_s));
                $display("       PP3: %0d (0x%0h) | Shifted: %0d", $signed(dut.pp3), dut.pp3, $signed(dut.pp3_s));
                $display("       CSA Sum: %0d | CSA Carry: %0d", $signed(dut.sum_vec), $signed(dut.carry_vec));
                $stop; 
            end else begin
                // Standard Success Display
                $display("[PASS] %0d * %0d = %0d", a, b, p);
            end
        end
        $display("==================================================");
        $display("Verification Complete: All tests passed.");
        $display("==================================================");
        $finish;
    end
endmodule
