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
	input [31:0]amount, value,
	input shift_type,
	output reg [31:0] shift_out
);
	reg I;
	always @(amount, value, shift_type) 
	begin
		case(shift_type)
			0:begin
				//left logic
				shift_out[31:0] = value[31:0]<<amount;
			end
			1:begin
				//right logic
				shift_out[31:0] = value[31:0]>>amount;
			end

			2:begin
				//left arithmetic
				shift_out[31:0] = value[31:0]<<<amount;
			end
			3:begin
				//right arithmetic
				shift_out[31:0] = value[31:0]>>>amount;
			end
		endcase // shift_type
	end
endmodule

module shifter(input[31:0] input_register, input[11:0] shifter_operand, input selector, output [31:0] out);
	wire[31:0] amounttointernal,valuetointernal;
	wire[1:0] shifttypetointernal;
	//
	mux_2x1 amount_mux(amounttointernal,selector,{27'b0000_0000_0000_0000_0000_0000_000,shifter_operand[11:8],1'b0}, {27'b0000_0000_0000_0000_0000_0000_000,shifter_operand[11:7]});
	mux_2x1 value_mux(valuetointernal,selector,{24'b0000_0000_0000_0000_0000_0000,shifter_operand[7:0]},input_register[31:0]);
	
	mux_2x1_2b shift_type_mux(shifttypetointernal,selector,2'b01,shifter_operand[6:5]);

	internal_shifter intsh(amounttointernal,valuetointernal,selector,out);
endmodule


module internal_shifter_tester;
	reg[31:0]input_register;

	reg[11:0]shifter_operand;
	
	reg selector;

	wire[31:0] out;

	shifter sh(input_register,shifter_operand,selector,out);
	parameter simtime = 1500;
	initial #simtime $finish;
	initial begin
		input_register = 2;
		shifter_operand =  12'b000100000001;
		selector = 0;
	end
	initial begin
		$monitor("%d %d",shifter_operand,out);
	end
endmodule	