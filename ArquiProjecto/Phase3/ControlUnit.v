// mux to inverter with inputs if 1 bit
module mux_4x1_1b(output reg Y, input [1:0] S, input I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0;
		2'b01: assign Y=I1;
		2'b10: assign Y=I2;
		2'b11: assign Y=I3;
	endcase
endmodule
//-------------------------------------------------------------------------------
//inverter
module inverter(output reg out, input in, inv);
	always @ (in, inv)
	if(inv)	
		out = ~in;
	else
		out = in;
endmodule
//-------------------------------------------------------------------------------
// 4bit mux selector upon conditions
module NSASel(output reg [1:0]M, input [2:0]ns, input sts);
	always @ (ns, sts)
	case(ns)
		3'b000: M = 2'b00; 	//encoder
		3'b001: M = 2'b01;	//?
		3'b010: M = 2'b10;	//pipeline
		3'b011: M = 2'b11;	//incrementer
		3'b100: 
			case(sts)
				0: M = 2'b00;	//encoder
				1: M = 2'b10;	//pipeline
			endcase
		3'b101:
			case(sts)
				0: M = 2'b11;	//incrementer
				1: M = 2'b10;	//pipeline
			endcase
		3'b110:
			case(sts)
				0: M = 2'b11;	//incrementer
				1: M = 2'b00;	//encoder
			endcase
		3'b111: M = 2'b01;  // (clear)
	endcase
endmodule
//-------------------------------------------------------------------------------
// IR encoder for next state
module encoder(output reg [5:0]out, input [32:0]IR);
	always @(IR)
	case(IR[37:35])
		3'b000: begin
			if (IR[4])
				if (IR[7]) 		//multiplies & extra load/stores
					if(IR[20])
						case(IR[23])
							0: 
							1:
						endcase
					else
						case(IR[23])
							0: 
							1:
						endcase
				else
					if (IR[20]) 		//data processing register shift
						case (IR[24:21])
							0:  out = 6;	//and
							1:  out = 8;	//eor
							2:  out = 10;	//sub
							3:  out = 12;	//rsb
							4:  out = 14;	//add
							5:  out = 16; 	//adc
							6:  out = 18; 	//sbc
							7:  out = 20; 	//rsc
							8:  out = 22; 	//tst
							9:  out = 24;	//teq
							10: out = 26;	//cmp
							11: out = 28;	//cmn
							12: out = 30;	//orr
							13: out = 32;	//mov
							14: out = 34;	//bic
							15: out = 36;	//mvn
						endcase
					else
						if (IR[24:23] == 2'b10) ;		//miscellaneous instructions
						else		//data processing register shift
							case (IR[24:21])
								0:  out = 6;	//and
								1:  out = 8;	//eor
								2:  out = 10;	//sub
								3:  out = 12;	//rsb
								4:  out = 14;	//add
								5:  out = 16; 	//adc
								6:  out = 18; 	//sbc
								7:  out = 20; 	//rsc
								8:  out = 22; 	//tst
								9:  out = 24;	//teq
								10: out = 26;	//cmp
								11: out = 28;	//cmn
								12: out = 30;	//orr
								13: out = 32;	//mov
								14: out = 34;	//bic
								15: out = 36;	//mvn
							endcase
			else
				if (IR[20])		//data processing immediate shift
					case (IR[24:21])
						0:  out = 5;	//and
						1:  out = 7;	//eor
						2:  out = 9;	//sub
						3:  out = 11;	//rsb
						4:  out = 13;	//add
						5:  out = 15; 	//adc
						6:  out = 17; 	//sbc
						7:  out = 19; 	//rsc
						8:  out = 21; 	//tst
						9:  out = 23;	//teq
						10: out = 25;	//cmp
						11: out = 27;	//cmn
						12: out = 29;	//orr
						13: out = 31;	//mov
						14: out = 33;	//bic
						15: out = 35;	//mvn
					endcase
				else
					if (IR[24:23] == 2'b10) ;  		//miscellaneous instructions
					else 		//data processing immediate shift
						case (IR[24:21])
							0:  out = 5;	//and
							1:  out = 7;	//eor
							2:  out = 9;	//sub
							3:  out = 11;	//rsb
							4:  out = 13;	//add
							5:  out = 15; 	//adc
							6:  out = 17; 	//sbc
							7:  out = 19; 	//rsc
							8:  out = 21; 	//tst
							9:  out = 23;	//teq
							10: out = 25;	//cmp
							11: out = 27;	//cmn
							12: out = 29;	//orr
							13: out = 31;	//mov
							14: out = 33;	//bic
							15: out = 35;	//mvn
						endcase
		end
		3'b001: begin
			if (IR[20]) ;		//data processing immediate
			else
				if (IR[24:23] == 2'b10 && IR[21]==0) out = 1;		//undefined instruction
				else if (IR[24:23] == 2'b10 && IR[21]==1) ;		//move immediate to status register
				else ;		//data processing immediate
		end
		3'b010: begin					//load/store immediate offset
			if(IR[20])
				case(IR[23])
					0: 
					1:
				endcase
			else
				if(IR[23])		//check -> sub/add
					if(IR[24])		//check -> addressing
						case(IR[21])	//check -> indexed
							0:			//offset addresing
							1: 			//pre-indexed
						endcase
					else ;	//normal 
				else
					if(IR[24])		//check -> addressing
						case(IR[21])	//check -> indexed
							0:			//offset addresing
							1: 			//pre-indexed
						endcase
					else ;	//normal 
		end
		3'b011: begin
			if(IR[4]) out = 1;		// arquitecturally undefined & media instructions
			else 
				if(IR[20])		//load/store register offset
					case(IR[23])		//check -> sub/add
						0: 
						1:
					endcase
				else
					case(IR[23])		//check -> sub/add
						0: 
						1:
					endcase
		end
		3'b100: ;		//load/store multiples
		3'b101: ;		//branch and branch with link
		3'b110: out = 1;		//does not apply
		3'b111: out = 1;		//does not apply
	endcase
endmodule
//-------------------------------------------------------------------------------
// IR condition evaluator
module condEval(output reg out, input [31:0]IR, input [31:0] tsr);
	always @ (IR, tsr)
	case(IR[31:28])
		4'b0000: if (str[30]) out = 1;				// Z=1
				 else out = 0;
		4'b0001: if (~str[30]) out = 1;				// Z=0
				 else out = 0;
		4'b0010: if (str[29]) out = 1;				// C=1
				 else out = 0;
		4'b0011: if (~str[29]) out = 1;				// C=0
				 else out = 0;
		4'b0100: if (str[31]) out = 1;				// N=1
				 else out = 0;
		4'b0101: if (~str[31]) out = 1;				// N=0
				 else out = 0;
		4'b0110: if (str[28]) out = 1;				// V=1
				 else out = 0;
		4'b0111: if (~str[28]) out = 1;				// V=0
				 else out = 0;
		4'b1000: if (str[29] == 1 && str[30] == 0) out = 1; 	// C=1 & Z=0
				 else out = 0;
		4'b1001: if (str[29] == 0 || str[30] == 1) out = 1;	// C=0 or Z=1
				 else out = 0;
		4'b1010: if (str[31] == str[28]) out = 1;		// N=Z
				 else out = 0;
		4'b1011: if (str[31] != str[28]) out = 1;		// N!=V
				 else out = 0;
		4'b1100: if (str[30] == 0 && str[31] == str[28]) out = 1;	// Z=0 & N=V
				 else out = 0;
		4'b1101: if (str[30] == 1 || str[31] != str[28]) out = 1;	//Z=1 or N=!Z
				 else out = 0;
		4'b1110: out = 1;
		4'b1111: out = 0;
	endcase
endmodule
//-------------------------------------------------------------------------------
//state adder 
module adder(output reg [5:0]out, input [5:0]cs, input[3:0] add);
	always @ (cs)
	out = cs + add;
endmodule
//-------------------------------------------------------------------------------
//state adder register
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
//-------------------------------------------------------------------------------
//6bit mux selector for state choosing (may increase depending on final states quantity)
module mux_4x1_6b(output reg[5:0] Y, input [1:0] S, input [5:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[5:0];
		2'b01: assign Y=I1[5:0];
		2'b10: assign Y=I2[5:0];
		2'b11: assign Y=I3[5:0];
	endcase
endmodule
//-------------------------------------------------------------------------------
//ROM (output may increce, depending on signals requiered, 1bit per signal)
module ROM (output reg [44:0]out, input [5:0]state, input clk);
	reg [31:0]mem[0:44];
	initial begin 
		//fetch
		//			   44   42   39 38    33 32 31 30 29   25   21   17   14   10  7  6  5  4  3    1   0
		// 			 | s0s1 NS  Inv pl   |s0 E1 E0 C1 RA   RB   RC   S3S1 S7S4 ShT E2 E3 E4 E5 MAS R/W MFA
		mem[0][44:0] = 00___011__0__00000_0__1__0__1__1111_0000_0000_000__1101_000_0__0__0__1__01___0___0; 
		mem[1][44:0] = 00___011__0__00000_0__0__1__1__1111_0000_1111_000__1101_000_0__0__0__0__01___0___1; 
		mem[2][44:0] = 00___101__1__00011_0__1__0__1__1111_0000_0000_000__1101_000_1__1__1__0__01___0___1; 
		mem[3][44:0] = 00___000__0__00000_0__1__0__1__1111_0000_0000_000__1101_000_0__0__0__0__01___0___0; 

		//execute


		//put rom memory here (in theory)
	end
	always @ (posedge clk)
		out = mem[state][44:0];

endmodule
//-------------------------------------------------------------------------------
//control unit box (output depends on ROM output)
module ControlUnit (output [44:0]out, input clk, clr, mfc, input [31:0]IR, statusReg);
	wire [5,0]state, stateSel stateSel1, stateSel2, stateSel3, addToR;
	wire [1:0]mux6bsel;
	wire invIn, invOut, ms0, ms1;
	wire [44:0]innerOut;

	ROM 		rom 	 (innerOut,   state, 			clk);
	mux_4x1_6b 	mux6b 	 (state, 	  mux6bsel, 		stateSel, 	stateSel1,  stateSel2, 	stateSSel3);
	IncReg 		incR 	 (stateSel,   addToR, 			1, 			clr, 		clk);
	adder 		adderAlu (addToR, 	  state, 			1);
	condEval 	condEval (invIn, 	  IR, 				statusReg);
	encoder 	iREnc 	 (stateSSel3, IR);
	NSASel 		stateSel (mux6bsel,   innerOut[42:38], 	invOut);
	inverter 	inv 	 (invOut, 	  invIn, 			innerOut[39]);
	mux_4x1_1b 	mux1b 	 (invIn, 	  innerOut[44:43],	mfc, 		0, 			0, 			0);
	
	always @(posedge clk)
		out = innerOut;
endmodule
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//tester
module CU_tester;

endmodule
//------------------------------------------
module condEval_tester;

endmodule
//------------------------------------------
module encoder_tester;

endmodule
//------------------------------------------
module ROM_tester;

endmodule