/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////


module mux_2x1(output [31:0] Y, input S, input [31:0] I0, I1);
	assign Y=S? I0:I1;
endmodule

module mux_2x1_2b(output [1:0] Y, input S, input [1:0] I0, I1);
	assign Y=S? I0:I1;
endmodule


/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
/////////////////////////////////
module internal_shifter (
	input [31:0] amount, value,
	input [1:0] shift_type,
	output reg [31:0] shift_out
);
	reg [63:0] temp;
	always @(amount, value, shift_type) 
	begin
		case(shift_type)
			0:begin
				//Logical Shift Left
				shift_out[31:0] = value[31:0]<<amount;
			end
			1:begin
				//Logical Shift Right
				shift_out[31:0] = value[31:0]>>amount;
			end

			2:begin
				//right arithmetic
				shift_out[31:0] = $signed(value[31:0])>>>amount;
			end
			3:begin
				  temp = {value, value} >> amount;
				  shift_out[31:0] = temp[31:0];
			end
		endcase //shift_type
	end
endmodule

module shifter(input[31:0] input_register_value, input[11:0] shifter_operand, input selector, output [31:0] out);
	wire[31:0] amounttointernal,valuetointernal;
	wire[1:0] shifttypetointernal;
	
	mux_2x1 amount_mux(amounttointernal,
		selector,
			{27'b0000_0000_0000_0000_0000_0000_000,shifter_operand[11:8],1'b0}, 
				{27'b0000_0000_0000_0000_0000_0000_000,shifter_operand[11:7]});

	mux_2x1 value_mux(valuetointernal,
			selector,
				{24'b0000_0000_0000_0000_0000_0000,shifter_operand[7:0]},
					input_register_value[31:0]);

	mux_2x1_2b shift_type_mux(shifttypetointernal,
			selector,
				2'b11,
					shifter_operand[6:5]);

	internal_shifter intsh(amounttointernal,valuetointernal,shifttypetointernal,out);
endmodule


module internal_shifter_tester;
	reg[31:0]input_register_value;

	reg[11:0]shifter_operand;
	
	reg selector;

	wire[31:0] out;

	shifter sh(input_register_value,shifter_operand,selector,out);
	parameter simtime = 1500;
	initial #simtime $finish;
	initial begin
		input_register_value = 5;
		shifter_operand =  12'b00000_11_0_0101;
		selector = 1;
	end
	initial begin
		$monitor("%b %b",shifter_operand,out);
	end
endmodule	