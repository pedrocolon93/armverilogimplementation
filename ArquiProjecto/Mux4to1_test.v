module test;

	//inputs declared as memory locations (regs)
	// 32 bits: a && b && c && d && out
	reg [31:0] a, b, c, d;
	reg [1:0] sel; // select has two bits

	//outputs are wires to connect to other locations
	wire [31:0] out;
	//select is only one bit

	mux muxInstance1 (out, a, b, c, d, sel);

	initial
	//here i do the testing assignments of mux 4to1
		begin

			//assignments
			a = 32'b00000000000000000000000000000000;
			b = 32'b11111111111111111111111111111111;
			c = 32'b00000000000000000000000000001111;
			d = 32'b11110000000000000000000000000000;

			#1;

			//here i do the printing of mux 4to1
			//display only displays the string
			$display("Testing the mux4to1 Inputs After Assignments:");
			$display("SELECT = %b, OUTPUT = %b", sel, out);
			
			sel = 2'b00; // print out 'a' when 'sel' = 0
			#1;

			//here i do the printing of mux 4to1
			//display only displays the string
			$display("Testing the mux4to1 Inputs After Select => 0:");
			$display("SELECT = %b, OUTPUT = %b", sel, out);
			sel = 2'b01; // print out 'b' when 'sel' = 1
			#1;

			//here i do the printing of mux 4to1
			//display only displays the string
			$display("Testing the mux4to1 Inputs After Select => 1:");
			$display("SELECT = %b, OUTPUT = %b", sel, out);
			sel = 2'b10; // print out 'c' when 'sel' = 2
			#1;

			//here i do the printing of mux 4to1
			//display only displays the string
			$display("Testing the mux4to1 Inputs After Select => 2:");
			$display("SELECT = %b, OUTPUT = %b", sel, out);
			sel = 2'b11; // print out 'd' when 'sel' = 3
			#1;

			//here i do the printing of mux 4to1
			//display only displays the string
			$display("Testing the mux4to1 Inputs After Select => 3:");
			$display("SELECT = %b, OUTPUT = %b", sel, out);
		end
endmodule
