module multiplicador_corrimientos_5bits (
input wire signed [4:0] a,
input wire signed [4:0] b,
output wire signed [9:0] resultado
);
	wire signo_resultado;
	wire [4:0] magnitud_a, magnitud_b;
	wire [9:0] a_extendida, producto_magnitud;	
	
	assign signo_resultado = a [4] ^ b [4];
	assign magnitud_a = a[4] ? (~a + 5'b1) : a;
	assign magnitud_b = b[4] ? (~b + 5'b1) : b;
	assign a_extendida = {5'b0, magnitud_a};

	assign producto_magnitud =
		(magnitud_b[0] ? a_extendida : 10'b0)
		+ (magnitud_b[1] ? (a_extendida << 1) : 10'b0)
		+ (magnitud_b[2] ? (a_extendida << 2) : 10'b0)
		+ (magnitud_b[3] ? (a_extendida << 3) : 10'b0)
		+ (magnitud_b[4] ? (a_extendida << 4) : 10'b0);
		
	assign resultado = signo_resultado
		? (~producto_magnitud + 10'b1)
		: producto_magnitud;

endmodule