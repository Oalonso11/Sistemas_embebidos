module full_adder(
	input wire A,
	input wire B,
	input wire Cin,
	output wire S,
	output wire Cout
);

	//S = A XOR B XOR Cin
	assign S = A ^ B ^ Cin;
	
	//Cout = AB + A*Cin + B*Cin
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule