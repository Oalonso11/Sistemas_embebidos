module sub5(
    input  wire [4:0] A,
    input  wire [4:0] B,
    output wire signed [5:0] RES,
    output wire Bout
);

    wire b1, b2, b3, b4;

    full_subtractor FS0 (.A(A[0]), .B(B[0]), .Bin(1'b0), .D(RES[0]), .Bout(b1));
    full_subtractor FS1 (.A(A[1]), .B(B[1]), .Bin(b1),   .D(RES[1]), .Bout(b2));
    full_subtractor FS2 (.A(A[2]), .B(B[2]), .Bin(b2),   .D(RES[2]), .Bout(b3));
    full_subtractor FS3 (.A(A[3]), .B(B[3]), .Bin(b3),   .D(RES[3]), .Bout(b4));
    full_subtractor FS4 (.A(A[4]), .B(B[4]), .Bin(b4),   .D(RES[4]), .Bout(Bout));

    // Sexto bit de A-B usando extension de signo.
    assign RES[5] = A[4] ^ B[4] ^ Bout;

endmodule
