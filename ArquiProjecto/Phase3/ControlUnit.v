module ControlUnit (output [31:0]out, input clk, clk_en, rst_n, input mfc, input [31:0]IR, input statusReg);

endmodule

module mux_4x1_1b(output reg Y, input [1:0] S, input I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0;
		2'b01: assign Y=I1;
		2'b10: assign Y=I2;
		2'b11: assign Y=I3;
	endcase
endmodule

module inverter(output reg out, input in, inv);

endmodule

module NSASel(output reg [1:0]M, input [2:0]ns, input sts);

endmodule

module encoder(output reg [3:0]out, input [32:0]IR);

endmodule

module adder(output reg [3:0]out, input [3:0]currentState, input[3:0] add);

endmodule

module IncReg(output reg [3:0] Q, input [3:0] D, input EN, CLR, CLK);
	initial Q = 4'b0000; // Start registers with 0
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q = 4'b0000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

module mux_4x1_4b(output reg[3:0] Y, input [1:0] S, input [3:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[3:0];
		2'b01: assign Y=I1[3:0];
		2'b10: assign Y=I2[3:0];
		2'b11: assign Y=I3[3:0];
	endcase
endmodule

module ROM (output reg [31:0]out, input [3:0]state, input clk);

endmodule