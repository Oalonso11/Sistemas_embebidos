module top_alu_de10lite(
    input  wire [9:0] SW,
    input  wire [1:0] KEY,
    output wire [9:0] LEDR,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

    // Entradas
    wire signed [4:0] A;
    wire signed [4:0] B;
    wire [1:0] Sel;

    // Salida de la ALU
    wire signed [9:0] Y;

    // Magnitud para mostrar en displays
    wire signo_neg;
    wire [9:0] magnitud;

    // BCD
    wire [3:0] centenas;
    wire [3:0] decenas;
    wire [3:0] unidades;

    assign A   = SW[4:0];
    assign B   = SW[9:5];
    assign Sel = KEY;   // KEY activo normal, 11 => 123

    // Instancia de la ALU
    alu U_ALU (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Y(Y)
    );

    // Signo y magnitud
    assign signo_neg = Y[9];
    assign magnitud  = signo_neg ? (~Y + 10'd1) : Y;

    // Conversión a BCD
    bin_to_bcd_10bit U_BCD (
        .bin(magnitud),
        .centenas(centenas),
        .decenas(decenas),
        .unidades(unidades)
    );

    // Displays: unidades, decenas, centenas
    seven_seg_decoder U_HEX0 (
        .digit(unidades),
        .seg(HEX0)
    );

    seven_seg_decoder U_HEX1 (
        .digit(decenas),
        .seg(HEX1)
    );

    seven_seg_decoder U_HEX2 (
        .digit(centenas),
        .seg(HEX2)
    );

    // Signo en HEX3: "-" si negativo, blank si positivo
    seven_seg_decoder U_HEX3 (
        .digit(signo_neg ? 4'hA : 4'hF),
        .seg(HEX3)
    );

    // HEX4 y HEX5 apagados
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

    // LEDs opcionales para ver entradas/estado
    assign LEDR[4:0] = SW[4:0];   // A
    assign LEDR[9:5] = SW[9:5];   // B

endmodule