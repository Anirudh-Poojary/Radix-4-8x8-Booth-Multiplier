
`timescale 1ns/1ps

//---------------- TRANSACTION CLASS ----------------//

class multiplier_transaction;

    rand bit signed [7:0] a;
    rand bit signed [7:0] b;

    constraint op_range {
        a inside {[-128:127]};
        b inside {[-128:127]};
    }

endclass


//---------------- TESTBENCH ----------------//

module tb;

    logic signed [7:0] a, b;
    wire signed [15:0] p;

    logic signed [15:0] expected;

    integer errors = 0;
    integer tests = 0;

    multiplier_transaction tr;

    // DUT instantiation
    Booth_mult_8x8_Top DUT (
        .a(a),
        .b(b),
        .p(p)
    );


    //---------------- FUNCTIONAL COVERAGE ----------------//

    covergroup mult;

        cp_a: coverpoint a {
            bins zero    = {0};
            bins maximum = {127};
            bins minimum = {-128};
            bins pos     = {[1:126]};
            bins neg     = {[-127:-1]};
        }

        cp_b: coverpoint b {
            bins zero    = {0};
            bins maximum = {127};
            bins minimum = {-128};
            bins pos     = {[1:126]};
            bins neg     = {[-127:-1]};
        }

        sign_cross: cross cp_a, cp_b;

    endgroup

    mult coverage = new();


    //---------------- CHECK TASK ----------------//

    task automatic check(
        input logic signed [7:0] x,
        input logic signed [7:0] y
    );

        begin
            a = x;
            b = y;

            #10;

            expected =
                $signed({{8{x[7]}}, x}) *
                $signed({{8{y[7]}}, y});

            tests++;

            if (p !== expected) begin
                $display("FAIL: A=%0d B=%0d P=%0d Expected=%0d",
                         x, y, p, expected);
                errors++;
            end
            else begin
                $display("PASS: A=%0d B=%0d P=%0d",
                         x, y, p);
            end

            coverage.sample();

        end

    endtask


    //---------------- MAIN TEST SEQUENCE ----------------//

    initial begin

        tr = new();

        // 1. Directed testing: corner cases

        check(0, 0);
        check(0, 127);
        check(0, -128);

        check(127, 0);
        check(-128, 0);

        check(127, 127);
        check(-128, -128);

        check(127, -128);
        check(-128, 127);

        check(1, -1);
        check(-1, -1);
        check(-1, 1);


        // 2. Constrained-random testing

        repeat (5000) begin

            if (!tr.randomize())
                $fatal("Randomization failed");

            check(tr.a, tr.b);

        end


        // 3. Final report

        $display("--------------------------------");
        $display("Total Tests = %0d", tests);
        $display("Errors      = %0d", errors);
        $display("Coverage    = %0.2f%%",
                 coverage.get_coverage());
        $display("--------------------------------");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED");

        $finish;

    end

endmodule
