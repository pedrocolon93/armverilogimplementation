module mux_4x1(output reg[31:0] Y, input [1:0] S, input [31:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[31:0];
		2'b01: assign Y=I1[31:0];
		2'b10: assign Y=I2[31:0];
		2'b11: assign Y=I3[31:0];
	endcase
endmodule