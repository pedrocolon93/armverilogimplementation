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
	always @ (in, inv)
	if(inv)	
		out = ~in;
	else
		out = in;
endmodule

module NSASel(output reg [1:0]M, input [2:0]ns, input sts);
	always @ (ns, sts)
	case(ns)
		3'b000: M = 2'b11; 
		3'b001: M = 2'b10;
		3'b010: M = 2'b01;
		3'b011: M = 2'b00;
		3'b100: 
			case(sts)
				0: M = 2'b11;
				1: M = 2'b01;
			endcase
		3'b101:
			case(sts)
				0: M = 2'b00;
				1: M = 2'b01;
			endcase
		3'b110:
			case(sts)
				0: M = 2'b00;
				1: M = 2'b11;
			endcase
		3'b111: ;  // lo que necesitemos
endmodule

module encoder(output reg [5:0]out, input [32:0]IR);
	always @()
	case(IR[24:21])
		4'b0000:
		4'b0001:
		4'b0010:
		4'b0011:
		4'b0100:
		4'b0101:
		4'b0110:
		4'b0111:
		4'b1000:
		4'b1001:
		4'b1010:
		4'b1011:
		4'b1100:
		4'b1101:
		4'b1110:
		4'b1111:
	endcase
endmodule

module condEval(output reg [5:0]out, input [31:0]IR, input [31:0] statusReg);
	always @ (IR, statusReg)
	case(IR[31:28])
		4'b0000:
		4'b0001:
		4'b0010:
		4'b0011:
		4'b0100:
		4'b0101:
		4'b0110:
		4'b0111:
		4'b1000:
		4'b1001:
		4'b1010:
		4'b1011:
		4'b1100:
		4'b1101:
		4'b1110:
		4'b1111:
	endcase
endmodule

module adder(output reg [5:0]out, input [5:0]currentState, input[3:0] add);
	always @ (currentState)
	out = currentState + add;
endmodule

module IncReg(output reg [5:0] Q, input [5:0] D, input EN, CLR, CLK);
	initial Q = 5'b00000; // Start registers with 0
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q = 5'b00000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

module mux_4x1_4b(output reg[5:0] Y, input [1:0] S, input [5:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[5:0];
		2'b01: assign Y=I1[5:0];
		2'b10: assign Y=I2[5:0];
		2'b11: assign Y=I3[5:0];
	endcase
endmodule

module ROM (output reg [31:0]out, input [5:0]state, input clk);
	reg [31:0]mem[0:63];
	initial begin 
		//put rom memory here (in theory)
	end
	always @ (posedge clk)
		out = mem[state][31:0];

endmodule

module ControlUnit (output [31:0]out, input clk, clk_en, rst_n, input mfc, input [31:0]IR, input statusReg);

endmodule
