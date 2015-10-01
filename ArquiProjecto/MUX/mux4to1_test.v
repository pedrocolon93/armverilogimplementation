module test;
	reg [31:0] i0, i1, i2, i3;
	reg [1:0] sel; 
	wire [31:0] out;

	mux_4x1 mux(out, sel, i0, i1, i2, i3);

	parameter sim_time = 1500;
	initial #sim_time $finish;
	
	initial	begin
		i0 = 32'b00000000000000000000000000000000;
		i1 = 32'b11111111111111111111111111111111;
		i2 = 32'b00000000000000000000000000001111;
		i3 = 32'b11110000000000000000000000000000;
		sel = 0;

		#10 repeat (3) #10 sel = sel + 1;
	end

	initial begin 
		$display("sel  output");
		$monitor("%b   %h", sel, out);
	end
endmodule
