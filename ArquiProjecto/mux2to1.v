//n bit signal, each input (a,b) can have 32 bits, one sel signal. one 32 bit output (out)

module mux (out, a, b, sel);

	input [31:0] a, b; // Inputs 1, 2 of 32 bits
	output [31:0] out; // Output of mux
	input sel;  // Select is active high

	assign out = sel ? b : a; // if 'sel' is high 'out' is 'a', else it is 'b'

endmodule