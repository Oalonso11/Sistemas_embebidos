`timescale 1ns/1ps
module tb_signed_counter_fsm;
    reg clk = 0;
    reg reset = 1;
    reg tick = 0;
    reg pause_pulse = 0;
    reg inc_pulse = 0;
    reg dec_pulse = 0;
    wire signed [8:0] count;
    wire [1:0] state;
    integer i;

    signed_counter_fsm uut (
        .clk(clk), .reset(reset), .tick(tick),
        .pause_pulse(pause_pulse), .inc_pulse(inc_pulse),
        .dec_pulse(dec_pulse), .count(count), .state(state)
    );

    always #5 clk = ~clk;

    task tick_once;
        begin
            @(negedge clk); tick = 1;
            @(negedge clk); tick = 0;
            #1;
        end
    endtask

    task press_inc;
        begin
            @(negedge clk); inc_pulse = 1;
            @(negedge clk); inc_pulse = 0;
            #1;
        end
    endtask

    task press_dec;
        begin
            @(negedge clk); dec_pulse = 1;
            @(negedge clk); dec_pulse = 0;
            #1;
        end
    endtask

    task press_pause;
        begin
            @(negedge clk); pause_pulse = 1;
            @(negedge clk); pause_pulse = 0;
            #1;
        end
    endtask

    task check;
        input integer expected_count;
        input [1:0] expected_state;
        begin
            if ((count !== expected_count) || (state !== expected_state)) begin
                $display("ERROR: valor=%0d estado=%0d; esperado=%0d estado=%0d",
                    count, state, expected_count, expected_state);
                $finish;
            end
        end
    endtask

    initial begin
        #12;
        @(negedge clk); reset = 0;
        #1; check(0, 2'd0);          // RESET: cero y pausa

        press_inc();
        tick_once(); check(1, 2'd1);
        for (i = 0; i < 254; i = i + 1) tick_once();
        check(255, 2'd1);
        tick_once(); check(-256, 2'd1); // Desbordamiento positivo

        press_pause();
        tick_once(); check(-256, 2'd0); // La pausa conserva el numero

        press_dec();
        tick_once(); check(255, 2'd2);  // Desbordamiento negativo
        tick_once(); check(254, 2'd2);

        // Reinicio tambien desde un valor distinto de cero.
        @(negedge clk); reset = 1;
        #1; check(0, 2'd0);
        $display("OK: reset, incremento, decremento, pausa y limites verificados.");
        $finish;
    end
endmodule
