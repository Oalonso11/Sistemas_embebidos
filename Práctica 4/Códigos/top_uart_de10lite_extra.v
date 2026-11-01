// Top del punto extra. Mismos 4 pines externos que la practica base.
// Peticion: 1 byte (0..255).
// Respuesta: 8 bytes little-endian, valor Q32 = x^(7/2)*2^32.
// Enviar una sola peticion y esperar los 8 bytes antes de enviar otra.
module top_uart_de10lite_extra #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  wire CLOCK_50,
    input  wire RESET_N,
    input  wire UART_RX,
    output wire UART_TX
);
    wire reset = ~RESET_N;
    wire [7:0] rx_data;
    wire rx_done;
    wire tx_busy;
    wire calc_busy;
    wire calc_done;
    wire [63:0] calc_result;

    reg [7:0] dato_calc;
    reg calc_start;
    reg [63:0] respuesta;
    reg [7:0] tx_data;
    reg tx_start;
    reg [2:0] byte_idx;
    reg [2:0] estado;

    localparam ESPERAR = 3'd0,
               CALCULAR = 3'd1,
               ENVIAR = 3'd2,
               ESPERAR_BUSY = 3'd3,
               ESPERAR_FIN = 3'd4;

    uart_rx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) RX0 (
        .clk(CLOCK_50), .reset(reset), .rx(UART_RX),
        .data_out(rx_data), .data_valid(rx_done)
    );

    potencia_7_2 CALC0 (
        .clk(CLOCK_50), .reset(reset),
        .start(calc_start), .dato(dato_calc),
        .resultado_q32(calc_result), .busy(calc_busy), .done(calc_done)
    );

    uart_tx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) TX0 (
        .clk(CLOCK_50), .reset(reset),
        .tx_start(tx_start), .data_in(tx_data),
        .tx(UART_TX), .busy(tx_busy)
    );

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            dato_calc <= 8'd0;
            calc_start <= 1'b0;
            respuesta <= 64'd0;
            tx_data <= 8'd0;
            tx_start <= 1'b0;
            byte_idx <= 3'd0;
            estado <= ESPERAR;
        end else begin
            calc_start <= 1'b0;
            tx_start <= 1'b0;
            case (estado)
                ESPERAR: begin
                    if (rx_done) begin
                        dato_calc <= rx_data;
                        calc_start <= 1'b1;
                        estado <= CALCULAR;
                    end
                end

                CALCULAR: begin
                    if (calc_done) begin
                        respuesta <= calc_result;
                        byte_idx <= 3'd0;
                        estado <= ENVIAR;
                    end
                end

                ENVIAR: begin
                    if (!tx_busy) begin
                        tx_data <= respuesta[8*byte_idx +: 8];
                        tx_start <= 1'b1;
                        estado <= ESPERAR_BUSY;
                    end
                end

                ESPERAR_BUSY: begin
                    if (tx_busy)
                        estado <= ESPERAR_FIN;
                end

                ESPERAR_FIN: begin
                    if (!tx_busy) begin
                        if (byte_idx == 3'd7)
                            estado <= ESPERAR;
                        else begin
                            byte_idx <= byte_idx + 1'b1;
                            estado <= ENVIAR;
                        end
                    end
                end

                default: estado <= ESPERAR;
            endcase
        end
    end
endmodule
