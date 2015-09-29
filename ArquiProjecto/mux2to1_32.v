module mux_2x1 (output [31:0] Y, input S, [31:0] I0, [31:0] I1);
	assign Y=(S)? I1:I0;
endmodule