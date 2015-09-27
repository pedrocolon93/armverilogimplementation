module register (
	clk, // Clock
	clr, // Clear content output of D Latch. Active Low
	E, // Enable. Active Low
	D, // Input to D Latch
	Q, // Output of D Latch
	Q_n // Inverted Output
);
	input clk, clr, E;
	input [31:0] D;
	output reg [31:0] Q;
	output [31:0] Q_n;

	assign Q_n = ~Q;

	always @ (posedge clk)
	 	if(!E && clr)
	 		Q <= D; // if E is low and clr is high then output the input
	 	else if(!E)
	 		Q <= 32'b00000000000000000000000000000000; // if E is low and clr is low then clear the output
	 	else
	 		Q <= Q; // if E is high then nothing happens (output stays as output) 

endmodule