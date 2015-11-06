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
module NSASel(output reg [1:0] M, input [2:0] ns, input sts);
	always @ (ns, sts)
	case(ns)
		3'b000: M = 2'b00;	//encoder
		3'b001: M = 2'b01;	//0
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
		3'b111: M = 2'b01;	//0
	endcase
endmodule
//-------------------------------------------------------------------------------
// IR encoder for next state
module encoder(output reg [5:0] out, input [31:0] IR);
	always @(IR)
	case(IR[37:35])
		3'b000: begin
			if (IR[4]) begin
				if (IR[7]) begin		//multiplies & extra load/stores
					if(IR[20]) begin			//load
						if(IR[23]) begin			//add
							if(IR[24]) begin			//offset or pre-indexed (P)
								if(IR[21]) out = 74;		//pre-indexed (W)
								else out = 72;				//offset addresing
							end
							else begin				//post-indexed 
								if(IR[21]) out = 1;	//unpredictable
								else out = 76;			//normal
							end
						end
						else begin				//sub
							if(IR[24]) begin			//offset or pre-indexed (P)
								if(IR[21]) out = 75;		//pre-indexed (W)
								else out = 73;				//offset addresing
							end
							else begin				//post-indexed 
								if(IR[21]) out = 1;	//unpredictable 
								else out = 78;			//normal
							end
						end
					end
					else begin				//store
						if(IR[23]) begin			//add
							if(IR[24]) begin			//offset or pre-indexed (P)
								if(IR[21]) out = 84;		//pre-indexed (W)
								else out = 82;				//offset addresing
							end
							else begin				//post-indexed 
								if(IR[21]) out = 1;	//unpredictable
								else out = 86;			//normal
							end
						end
						else begin				//sub
							if(IR[24]) begin			//offset or pre-indexed (P)
								if(IR[21]) out = 85;		//pre-indexed (W)
								else out = 83;				//offset addresing
							end
							else begin				//post-indexed 
								if(IR[21]) out = 1;	//unpredictable
								else out = 88;			//normal
							end
						end
					end
				end
				else out = 1;
					/*if (IR[20])	out = 1;	//data processing register shift
						/*case (IR[24:21])
							0:  out = 6;	//and
							1:  out = 8;	//eor
							2:  out = 10;	//sub
							3:  out = 12;	//rsb
							4:  out = 14;	//add
							5:  out = 16;	//adc
							6:  out = 18;	//sbc
							7:  out = 20;	//rsc
							8:  out = 22;	//tst
							9:  out = 24;	//teq
							10: out = 26;	//cmp
							11: out = 28;	//cmn
							12: out = 30;	//orr
							13: out = 32;	//mov
							14: out = 34;	//bic
							15: out = 36;	//mvn
						endcase */
					/*else
						if (IR[24:23] == 2'b10) out = 1;		//miscellaneous instructions
						else out = 1;		//data processing register shift
							/*case (IR[24:21])
								0: ; 	//and
								1: ; 	//eor
								2: ; 	//sub
								3: ; 	//rsb
								4: ; 	//add
								5: ;  	//adc
								6: ;  	//sbc
								7: ;  	//rsc
								8: ;  	//tst
								9: ; 	//teq
								10: ;	//cmp
								11: ;	//cmn
								12: ;	//orr
								13: ;	//mov
								14: ;	//bic
								15: ;	//mvn
							endcase */
			end
			else begin
				if (IR[20])	begin	//data processing immediate shift
					case (IR[24:21])
						0:  out = 6;	//and
						1:  out = 8;	//eor
						2:  out = 10;	//sub
						3:  out = 12;	//rsb
						4:  out = 14;	//add
						5:  out = 16;	//adc
						6:  out = 18;	//sbc
						7:  out = 20;	//rsc
						8:  out = 22;	//tst
						9:  out = 24;	//teq
						10: out = 26;	//cmp
						11: out = 28;	//cmn
						12: out = 30;	//orr
						13: out = 32;	//mov
						14: out = 34;	//bic
						15: out = 36;	//mvn
					endcase
				end
				else begin
					if (IR[24:23] == 2'b10) out = 1 ;//;		//miscellaneous instructions
					else begin		//data processing immediate shift
						case (IR[24:21])
							0:  out = 6;	//and
							1:  out = 8;	//eor
							2:  out = 10;	//sub
							3:  out = 12;	//rsb
							4:  out = 14;	//add
							5:  out = 16;	//adc
							6:  out = 18;	//sbc
							7:  out = 20;	//rsc
							8:  out = 22;	//tst
							9:  out = 24;	//teq
							10: out = 26;	//cmp
							11: out = 28;	//cmn
							12: out = 30;	//orr
							13: out = 32;	//mov
							14: out = 34;	//bic
							15: out = 36;	//mvn
						endcase
					end
				end
			end
		end  //done
		3'b001: begin
			if (IR[20])	begin	//data processing immediate (32-bit)
				case (IR[24:21])
					0:  out = 5;	//and
					1:  out = 7;	//eor
					2:  out = 9;	//sub
					3:  out = 11;	//rsb
					4:  out = 13;	//add
					5:  out = 15;	//adc
					6:  out = 17;	//sbc
					7:  out = 19;	//rsc
					8:  out = 21;	//tst
					9:  out = 23;	//teq
					10: out = 25;	//cmp
					11: out = 27;	//cmn
					12: out = 29;	//orr
					13: out = 31;	//mov
					14: out = 33;	//bic
					15: out = 35;	//mvn
				endcase
			end
			else begin
				if (IR[24:23] == 2'b10 && IR[21]==0) out = 1;		//undefined instruction
				else if (IR[24:23] == 2'b10 && IR[21]==1) out = 1;		//move immediate to status register
				else begin		//data processing immediate (32-bit)
					case (IR[24:21])
						0:  out = 5;	//and
						1:  out = 7;	//eor
						2:  out = 9;	//sub
						3:  out = 11;	//rsb
						4:  out = 13;	//add
						5:  out = 15;	//adc
						6:  out = 17;	//sbc
						7:  out = 19;	//rsc
						8:  out = 21;	//tst
						9:  out = 23;	//teq
						10: out = 25;	//cmp
						11: out = 27;	//cmn
						12: out = 29;	//orr
						13: out = 31;	//mov
						14: out = 33;	//bic
						15: out = 35;	//mvn
					endcase
				end
			end
		end  //done
		3'b010: begin		//load/store immediate offset
			if(IR[20]) begin			//load
				if(IR[23]) begin			//add
					if(IR[24]) begin			//offset or pre-indexed (P)
						if(IR[21]) out = 40;		//pre-indexed (W)
						else out = 36;				//offset addresing
					end
					else begin				//post-indexed 
						if(IR[21]) out = 1;	//privilage loads/store 
						else out = 44;			//normal
					end
				end
				else begin				//sub
					if(IR[24]) begin			//offset or pre-indexed (P)
						if(IR[21]) out = 41;		//pre-indexed (W)
						else out = 37;				//offset addresing
					end
					else begin				//post-indexed 
						if(IR[21]) out = 1;	//privilage loads/store 
						else out = 46;			//normal
					end 
				end
			end
			else begin				//store
				if(IR[23]) begin			//add
					if(IR[24]) begin			//offset or pre-indexed (P)
						if(IR[21]) out = 58;		//pre-indexed (W)
						else out = 54;				//offset addresing
					end
					else begin				//post-indexed 
						if(IR[21]) out = 1;	//privilage loads/store 
						else out = 62;			//normal
					end
				end
				else begin				//sub
					if(IR[24]) begin			//offset or pre-indexed (P)
						if(IR[21]) out = 59;		//pre-indexed (W)
						else out = 55;				//offset addresing
					end
					else begin				//post-indexed 
						if(IR[21]) out = 1;	//privilage loads/store 
						else out = 64;			//normal
					end
				end
			end
		end //done
		3'b011: begin 
			if(IR[4]) out = 1;		//arquitecturally undefined & media instructions
			else begin					//load/store register offset
				if(IR[20]) begin			//load
					if(IR[23]) begin			//add
						if(IR[24]) begin			//offset or pre-indexed (P)
							if(IR[21]) out = 42;		//pre-indexed (W)
							else out = 38;				//offset addresing
						end
						else begin				//post-indexed 
							if(IR[21]) out = 1;	//privilage loads/store 
							else out = 48;			//normal
						end
					end
					else begin				//sub
						if(IR[24]) begin			//offset or pre-indexed (P)
							if(IR[21]) out = 43;		//pre-indexed (W)
							else out = 39;				//offset addresing
						end
						else begin				//post-indexed 
							if(IR[21]) out = 1;	//privilage loads/store 
							else out = 50;			//normal
						end
					end
				end
				else begin				//store
					if(IR[23]) begin			//add
						if(IR[24]) begin			//offset or pre-indexed (P)
							if(IR[21]) out = 60;		//pre-indexed (W)
							else out = 56;				//offset addresing
						end
						else begin				//post-indexed 
							if(IR[21]) out = 1;	//privilage loads/store 
							else out = 66;			//normal
						end
					end
					else begin				//sub
						if(IR[24]) begin			//offset or pre-indexed (P)
							if(IR[21]) out = 61;		//pre-indexed (W)
							else out = 57;				//offset addresing
						end
						else begin				//post-indexed 
							if(IR[21]) out = 1;	//privilage loads/store 
							else out = 68;			//normal
						end
					end
				end
			end
		end //done
		3'b100: out = 1;		//load/store multiples
		3'b101: begin
			if (IR[24])	out = 92;		//branch with link
			else out = 93;			//branch
		end //done
		3'b110: out = 1;		//does not apply
		3'b111: out = 1;		//does not apply
	endcase
endmodule
//-------------------------------------------------------------------------------
// IR condition evaluator
module condEval(output reg out, input [31:0] IR, input [31:0] str);
	always @ (IR, str)
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
		4'b1000: if (str[29] == 1 && str[30] == 0) out = 1;		// C=1 & Z=0
				 else out = 0;
		4'b1001: if (str[29] == 0 || str[30] == 1) out = 1;		// C=0 or Z=1
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
module adder(output reg [5:0] out, input [5:0] cs, input [3:0] add);
	always @ (cs)
	out = cs + add;
endmodule
//-------------------------------------------------------------------------------
//state adder register
module IncReg(output reg [5:0] Q, input [5:0] D, input EN, CLR, CLK);
	initial Q = 5'b00000;	//Start registers with 0
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D;	//Enable Sync. Only occurs when Clk is high
		else if(!CLR)	//clear
			Q = 5'b00000;	//Clear Async
		else
			Q <= Q;	//enable off. output what came out before
endmodule
//-------------------------------------------------------------------------------
//6bit mux selector for state choosing (may increase depending on final states quantity)
module mux_4x1_6b(output reg [5:0] Y, input [1:0] S, input [5:0] I0, I1, I2, I3);
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
module ROM (output reg [44:0] out, input [5:0] state, input clk);
	reg [44:0]mem[31:0];
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
module ControlUnit (output reg [44:0] out, input clk, clr, mfc, input [31:0] IR, statusReg);
	
	wire [5:0] state, stateSel0, stateSel1, stateSel2, stateSel3, addToR;
	wire [1:0] mux6bsel;
	wire invIn, invOut, ms0, ms1;
	wire [44:0] innerOut;
	
	ROM			rom		 (innerOut,   state, 			clk);
	mux_4x1_6b	mux6b	 (state, 	  mux6bsel, 		stateSel0, 	stateSel1,  stateSel2, 	stateSel3);
	IncReg		incR	 (stateSel0,   addToR, 			1'b1,		clr, 		clk);
	adder		adderAlu (addToR, 	  state, 			4'b0001);
	condEval	condEv	 (invIn, 	  IR, 				statusReg);
	encoder		iREnc	 (stateSel3, IR);
	NSASel		stateSel (mux6bsel,   innerOut[42:40], 	invOut);
	inverter	inv		 (invOut, 	  invIn, 			innerOut[39]);
	mux_4x1_1b	mux1b	 (invIn, 	  innerOut[44:43],	mfc, 		1'b0, 		1'b0, 		1'b0);
	
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