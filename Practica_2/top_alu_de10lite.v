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

    wire signed [4:0] A;
    wire signed [4:0] B;
    wire        [1:0] Sel;

    wire signed [9:0] Y;

    reg signed [9:0] resultado_mostrar;
    reg overflow;

    wire signo_neg;
    wire [9:0] magnitud;

    wire [3:0] centenas;
    wire [3:0] decenas;
    wire [3:0] unidades;


    // Entradas
    assign A   = SW[4:0];
    assign B   = SW[9:5];
    assign Sel = KEY;


    // ALU
    alu U_ALU (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Y(Y)
    );


    // Control de overflow
    always @(*) begin

        case (Sel)

            // Suma
            2'b00: begin
                if (Y > 10'sd15) begin
                    resultado_mostrar = 10'sd15;
                    overflow = 1'b1;
                end
                else if (Y < -10'sd16) begin
                    resultado_mostrar = -10'sd16;
                    overflow = 1'b1;
                end
                else begin
                    resultado_mostrar = Y;
                    overflow = 1'b0;
                end
            end


            // Resta
            2'b01: begin
                if (Y > 10'sd15) begin
                    resultado_mostrar = 10'sd15;
                    overflow = 1'b1;
                end
                else if (Y < -10'sd16) begin
                    resultado_mostrar = -10'sd16;
                    overflow = 1'b1;
                end
                else begin
                    resultado_mostrar = Y;
                    overflow = 1'b0;
                end
            end


            // Multiplicacion
            2'b10: begin
                resultado_mostrar = Y;
                overflow = 1'b0;
            end


            // Easter egg
            2'b11: begin
                resultado_mostrar = Y;
                overflow = 1'b0;
            end


            default: begin
                resultado_mostrar = 10'sd0;
                overflow = 1'b0;
            end

        endcase

    end


    // Signo y valor absoluto
    assign signo_neg = resultado_mostrar[9];

    assign magnitud =
        signo_neg
        ? (~resultado_mostrar + 10'd1)
        : resultado_mostrar;


    // Binario a BCD
    bin_to_bcd_10bit U_BCD (
        .bin(magnitud),
        .centenas(centenas),
        .decenas(decenas),
        .unidades(unidades)
    );


    // Unidades
    seven_seg_decoder U_HEX0 (
        .digit(unidades),
        .seg(HEX0)
    );


    // Decenas
    seven_seg_decoder U_HEX1 (
        .digit(
            ((centenas != 4'd0) || (decenas != 4'd0))
            ? decenas
            : 4'hF
        ),
        .seg(HEX1)
    );


    // Centenas
    seven_seg_decoder U_HEX2 (
        .digit(
            (centenas != 4'd0)
            ? centenas
            : 4'hF
        ),
        .seg(HEX2)
    );


    // Signo negativo
    seven_seg_decoder U_HEX3 (
        .digit(
            signo_neg
            ? 4'hA
            : 4'hF
        ),
        .seg(HEX3)
    );


    // Apagado
    assign HEX4 = 7'b1111111;


    // Overflow
    seven_seg_decoder U_HEX5 (
        .digit(
            overflow
            ? 4'd1
            : 4'hF
        ),
        .seg(HEX5)
    );


    // LEDs
    assign LEDR = SW;

endmodule
