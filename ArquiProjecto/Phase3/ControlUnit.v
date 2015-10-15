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
		3'b000: M = 2'b11; 
		3'b001: M = 2'b10;
		3'b010: M = 2'b01;
		3'b011: M = 2'b00;
		3'b100: 
			case(sts)
				0: M = 2'b11;
				1: M = 2'b01;
			endcase
		3'b101:
			case(sts)
				0: M = 2'b00;
				1: M = 2'b01;
			endcase
		3'b110:
			case(sts)
				0: M = 2'b00;
				1: M = 2'b11;
			endcase
		3'b111: ;  // lo que necesitemos
	endcase
endmodule
//-------------------------------------------------------------------------------
// IR encoder for next state
module encoder(output reg [5:0]out, input [32:0]IR);
	always @(IR)
	case(IR[37:35])
		3'b000: begin
			if (IR[4])
				if (IR[7]) ;
				else
					if (IR[20]) ;
					else
						if (IR[24:23] == 2'b10) ;
						else ;
			else
				if (IR[20]) ;
				else
					if (IR[24:23] == 2'b10) ;
					else ;
		  end
		3'b001: begin
			if (IR[20]) ;
			else
				if (IR[24:23] == 2'b10)
					if (IR[21]) ;
					else ;
				else ;
		  end
		3'b010: ;
		3'b011: begin
			if(IR[4])
				if(IR[8:5]) 
					if(IR[24:20]) ;
					else ;
				else ;
			else ;
		  end
		3'b100: ;
		3'b101: ;
		3'b110: ;//does not apply
		3'b111: ;//does not apply
	endcase
endmodule
//-------------------------------------------------------------------------------
// IR condition evaluator
module condEval(output reg out, input [31:0]IR, input [31:0] statusReg);
	always @ (IR, statusReg)
	case(IR[31:28])
		4'b0000: if (statusReg[30]) out = 1;				// Z=1
				 else out = 0;
		4'b0001: if (~statusReg[30]) out = 1;				// Z=0
				 else out = 0;
		4'b0010: if (statusReg[29]) out = 1;				// C=1
				 else out = 0;
		4'b0011: if (~statusReg[29]) out = 1;				// C=0
				 else out = 0;
		4'b0100: if (statusReg[31]) out = 1;				// N=1
				 else out = 0;
		4'b0101: if (~statusReg[31]) out = 1;				// N=0
				 else out = 0;
		4'b0110: if (statusReg[28]) out = 1;				// V=1
				 else out = 0;
		4'b0111: if (~statusReg[28]) out = 1;				// V=0
				 else out = 0;
		4'b1000: if (statusReg[29] == 1 && statusReg[30] == 0) out = 1; 	// C=1 & Z=0
				 else out = 0;
		4'b1001: if (statusReg[29] == 0 || statusReg[30] == 1) out = 1;	// C=0 or Z=1
				 else out = 0;
		4'b1010: if (statusReg[31] == statusReg[28]) out = 1;		// N=Z
				 else out = 0;
		4'b1011: if (statusReg[31] != statusReg[28]) out = 1;		// N!=V
				 else out = 0;
		4'b1100: if (statusReg[30] == 0 && statusReg[31] == statusReg[28]) out = 1;	// Z=0 & N=V
				 else out = 0;
		4'b1101: if (statusReg[30] == 1 || statusReg[31] != statusReg[28]) out = 1;	//Z=1 or N=!Z
				 else out = 0;
		default: out = 1;
	endcase
endmodule
//-------------------------------------------------------------------------------
//state adder 
module adder(output reg [5:0]out, input [5:0]currentState, input[3:0] add);
	always @ (currentState)
	out = currentState + add;
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
		//decode

		//execute

		//put rom memory here (in theory)
	end
	always @ (posedge clk)
		out = mem[state][44:0];

endmodule
//-------------------------------------------------------------------------------
//control unit box (output depends on ROM output)
module ControlUnit (output [44:0]out, input clk, clk_en, clr, mfc, input [31:0]IR, statusReg);
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