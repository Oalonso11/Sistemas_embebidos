module alu(
    input  wire signed [4:0] A,
    input  wire signed [4:0] B,
    input  wire [1:0] Sel,
    output reg  signed [9:0] Y
);

    wire signed [5:0] suma;
    wire signed [5:0] resta;
    wire signed [9:0] producto;
    wire Cout_suma;
    wire Bout_resta;

    adder5 U_SUM (
        .A(A),
        .B(B),
        .SUM(suma),
        .Cout(Cout_suma)
    );

    sub5 U_SUB (
        .A(A),
        .B(B),
        .RES(resta),
        .Bout(Bout_resta)
    );

    multiplicador_corrimientos_5bits U_MUL (
        .a(A),
        .b(B),
        .resultado(producto)
    );

    always @(*) begin
        case (Sel)
            2'b00: Y = {{4{suma[5]}}, suma};
            2'b01: Y = {{4{resta[5]}}, resta};
            2'b10: Y = producto;
			2'b11: Y = 10'sd123;   // CAso gracioso
            default: Y = 10'sd0;
        endcase
    end

endmodule
