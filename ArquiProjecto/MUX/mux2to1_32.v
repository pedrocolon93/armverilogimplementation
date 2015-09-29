module mux_2x1(output [31:0] Y, input S, input [31:0] I0, I1);
	assign Y=S? I0:I1;
endmodule