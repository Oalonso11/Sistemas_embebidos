module adder5(
    input  wire [4:0] A,
    input  wire [4:0] B,
    output wire signed [5:0] SUM,
    output wire Cout
);

    wire c1, c2, c3, c4;

    full_adder FA0 (.A(A[0]), .B(B[0]), .Cin(1'b0), .S(SUM[0]), .Cout(c1));
    full_adder FA1 (.A(A[1]), .B(B[1]), .Cin(c1),   .S(SUM[1]), .Cout(c2));
    full_adder FA2 (.A(A[2]), .B(B[2]), .Cin(c2),   .S(SUM[2]), .Cout(c3));
    full_adder FA3 (.A(A[3]), .B(B[3]), .Cin(c3),   .S(SUM[3]), .Cout(c4));
    full_adder FA4 (.A(A[4]), .B(B[4]), .Cin(c4),   .S(SUM[4]), .Cout(Cout));

    // Sexto bit del resultado al sumar A y B extendidos con signo.
    // Permite conservar los 5 Full Adders pedidos por la practica.
    assign SUM[5] = A[4] ^ B[4] ^ Cout;

endmodule
