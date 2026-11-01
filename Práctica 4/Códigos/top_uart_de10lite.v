module top_uart_de10lite #(
    parameter CLK_FREQ  = 50000000,
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
    reg [7:0] tx_data;
    reg tx_start;

    uart_rx #(
        .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)
    ) RX0 (
        .clk(CLOCK_50), .reset(reset), .rx(UART_RX),
        .data_out(rx_data), .data_valid(rx_done)
    );

    uart_tx #(
        .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)
    ) TX0 (
        .clk(CLOCK_50), .reset(reset),
        .tx_start(tx_start), .data_in(tx_data),
        .tx(UART_TX), .busy(tx_busy)
    );

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            tx_data <= 8'd0;
            tx_start <= 1'b0;
        end else begin
            tx_start <= 1'b0;
            if (rx_done && !tx_busy) begin
                tx_data <= rx_data + 8'd1;
                tx_start <= 1'b1;
            end
        end
    end
endmodule
