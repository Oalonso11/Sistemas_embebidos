module signed_counter_fsm (
    input wire clk,
    input wire reset,
    input wire tick,
    input wire pause_pulse,
    input wire inc_pulse,
    input wire dec_pulse,
    output reg signed [8:0] count,
    output reg [1:0] state
);
    // Misma estructura de FSM que la del semaforo: estado y siguiente estado.
    localparam [1:0] S_PAUSE = 2'd0;
    localparam [1:0] S_UP    = 2'd1;
    localparam [1:0] S_DOWN  = 2'd2;

    reg [1:0] next_state;

    // Logica combinacional: elegir el siguiente estado.
    // Prioridad: pausa, incremento, decremento.
    always @(*) begin
        next_state = state;
        if (pause_pulse)
            next_state = S_PAUSE;
        else if (inc_pulse)
            next_state = S_UP;
        else if (dec_pulse)
            next_state = S_DOWN;
    end

    // Logica secuencial: el reloj siempre es clk, NO tick.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_PAUSE;
            count <= 9'sd0;
        end else begin
            state <= next_state;

            if (tick) begin
                case (next_state)
                    S_UP:   count <= count + 9'd1;
                    S_DOWN: count <= count - 9'd1;
                    default: count <= count; // Pausa
                endcase
            end
        end
    end
endmodule
