module test;
	reg [31:0] a, b;
	reg sel;
	wire [31:0] out;
	
	mux_2x1 mux(out, sel, a, b);

	parameter sim_time = 1500;
	initial #sim_time $finish;
	
	initial begin
		a = 32'b00000000000000000000000000000000;
		b = 32'b11111111111111111111111111111111;
		sel = 1'b0; // print out 'a' when 'sel' = 0
		
		#10 sel = 1'b1; // print out 'a' when 'sel' = 0
	end

	initial begin 
		$display("sel  output");
		$monitor("%b   %h", sel, out);
	end	
endmodule
