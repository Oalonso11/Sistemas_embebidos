// Calcula x^(7/2) = x^3 * sqrt(x), x = 0..255.
// No usa $sqrt ni real: raiz binaria restauradora mediante restas.
// Formato de salida: entero sin signo Q32 (resultado real * 2^32).
// El calculo toma 36 ciclos a partir de start.
module potencia_7_2 (
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [7:0]  dato,
    output reg  [63:0] resultado_q32,
    output reg         busy,
    output reg         done
);
    // sqrt(dato * 2^64) = sqrt(dato) * 2^32.
    // 72 bits = 8 bits de entrada + 64 ceros fraccionarios.
    reg [71:0] radicando;
    reg [39:0] resto;
    reg [35:0] raiz;
    reg [5:0]  paso;
    reg [23:0] cubo;

    wire [15:0] cuadrado_in = dato * dato;
    wire [23:0] cubo_in = cuadrado_in * dato;

    // En cada paso bajamos dos bits del radicando.
    wire [39:0] resto_temporal = (resto << 2) | {38'd0, radicando[71:70]};
    wire [39:0] prueba = {2'b00, raiz, 2'b01}; // 4*raiz + 1
    wire restar = resto_temporal >= prueba;
    wire [35:0] raiz_siguiente = {raiz[34:0], restar};
    wire [59:0] producto = cubo * raiz_siguiente;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            radicando    <= 72'd0;
            resto        <= 40'd0;
            raiz         <= 36'd0;
            paso         <= 6'd0;
            cubo         <= 24'd0;
            resultado_q32 <= 64'd0;
            busy         <= 1'b0;
            done         <= 1'b0;
        end else begin
            done <= 1'b0;
            if (!busy) begin
                if (start) begin
                    radicando <= {dato, 64'd0};
                    resto     <= 40'd0;
                    raiz      <= 36'd0;
                    cubo      <= cubo_in;
                    paso      <= 6'd0;
                    busy      <= 1'b1;
                end
            end else begin
                radicando <= {radicando[69:0], 2'b00};
                raiz <= raiz_siguiente;
                if (restar)
                    resto <= resto_temporal - prueba;
                else
                    resto <= resto_temporal;

                if (paso == 6'd35) begin
                    resultado_q32 <= {4'd0, producto};
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    paso <= paso + 1'b1;
                end
            end
        end
    end
endmodule
