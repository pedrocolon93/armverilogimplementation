module test;

	//inputs declared as memory locations (regs)
	// 32 bits: a && b && out
	reg [31:0] a, b;
	reg sel;

	//outputs are wires to connect to other locations
	wire [31:0] out;
	//select is only one bit

	mux muxInstance1 (out, a, b, sel);

	initial
	//here i do the testing assignments of mux 2to1
		begin

			//here i do the printing of mux 2to1
			//display only displays the string
			$display("Testing the mux2to1 Inputs Before Assignments:  SELECT = %b , A = %b , B = %b:	OUTPUT = %b", sel, a, b, out);
			
			//assignments
			a = 32'b00000000000000000000000000000000;
			b = 32'b11111111111111111111111111111111;
			#1;

			//here i do the printing of mux 2to1
			//display only displays the string
			$display("Testing the mux2to1 Inputs After A & B Assignemnts:  SELECT = %b , A = %b , B = %b:	OUTPUT = %b", sel, a, b, out);

			sel = 1'b0; // print out 'a' when 'sel' = 0
			#1;

			//here i do the printing of mux 2to1
			//display only displays the string
			$display("Testing the mux2to1 Inputs After Select => 0:  SELECT = %b , A = %b , B = %b:	OUTPUT = %b", sel, a, b, out);

			sel = 1'b1; // print out 'a' when 'sel' = 0
			#1;

			//here i do the printing of mux 2to1
			//display only displays the string
			$display("Testing the mux2to1 Inputs After Select => 1:  SELECT = %b , A = %b , B = %b:	OUTPUT = %b", sel, a, b, out);

		end
endmodule
