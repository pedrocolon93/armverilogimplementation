//n bit signal, each input (a,b) can have 32 bits, one sel signal. one 32 bit output (out)

module mux (out, a, b, c, d, sel);

	input [31:0] a, b, c, d; // Inputs 1, 2, 3 & 4 of 32 bits
	output [31:0] out; // Output of mux
	input [1:0] sel;  // Select is active high
	reg out; // Output is a volatile memory location
	always @(a or b or c or d or sel) begin
		case (sel) // give output the selected input value
			2'b00: out = a;
			2'b01: out = b;
			2'b10: out = c;
			2'b11: out = d;
			default: out = out;
		endcase
	end
endmodule