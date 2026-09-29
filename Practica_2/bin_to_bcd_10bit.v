module bin_to_bcd_10bit(
    input  wire [9:0] bin,
    output reg  [3:0] centenas,
    output reg  [3:0] decenas,
    output reg  [3:0] unidades
);

    integer valor;

    always @(*) begin
        valor = bin;

        centenas = valor / 100;
        decenas  = (valor % 100) / 10;
        unidades = valor % 10;
    end

endmodule