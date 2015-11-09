// IR condition evaluator
// condEval	condEv	 (condOut, 	IR, 		     statusReg);
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
		default: out = 1;
	endcase
endmodule
//-------------------------------------------------------------------------------
// mux to inverter with inputs if 1 bit
//mux4x11b	mux1b	 (invIn, 	  innerOut[52:51],	mfc, 		condOut);
module mux4x11b(output reg Y, input [1:0] S, input I0, I1);
	always @ (S, I0, I1)
	case (S)
		2'b00: assign Y=I0;
		2'b01: assign Y=I1;
		default: Y=I1;
	endcase
endmodule
//-------------------------------------------------------------------------------
//inverter
//inverter	inv		 (invOut, 	  invIn, 			innerOut[47]);
module inverter(output reg out, input in, inv);
	always @ (in, inv)
	if(inv)	
		out = ~in;
	else
		out = in;
endmodule
//-------------------------------------------------------------------------------
// 4bit mux selector upon conditions
//NSASel		stateSel (ms, 		  innerOut[50:48], invOut);
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
// encoder		iREnc	 (stateSel0,  IR);
module encoder(output reg [6:0] out, input [31:0] IR);
	always @(IR)
	case(IR[27:25])
		3'b000: begin
			if (IR[4]) begin
				if (IR[7]) begin		//multiplies & extra load/stores
					if(IR[20]) begin			//load
						if(IR[23]) begin			//add
							if(IR[24]) begin			//offset or pre-indexed (P)
								if(IR[21]) out = 74;		//pre-indexed (W)
								else out = 95;				//offset addresing
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
					if (IR[24:23] == 2'b10) out = 1 ;//;		//miscellaneous instructions
					else begin		//data processing immediate shift
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
			end
		end  //done
		3'b001: begin
			if (IR[20])	begin	//data processing immediate (32-bit)
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
				if (IR[24:23] == 2'b10 && IR[21:20] == 2'b00) out = 1;		//undefined instruction
				else if (IR[24:23] == 2'b10 && IR[21:20] == 2'b10) out = 1;		//move immediate to status register
				else begin		//data processing immediate (32-bit)
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
		end  //done
		3'b010: begin		//load/store immediate offset
			if(IR[20]) begin			//load
				if(IR[23]) begin			//add
					if(IR[24]) begin			//offset or pre-indexed (P)
						if(IR[21]) out = 40;		//pre-indexed (W)
						else out = 96;				//offset addresing
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
			if (IR[24])	out = 93;		//branch with link
			else out = 94;			//branch
		end //done
		3'b110: out = 1;		//does not apply
		3'b111: out = 1;		//does not apply
	endcase
endmodule
//-------------------------------------------------------------------------------
//6bit mux selector for state choosing (may increase depending on final states quantity)
// 	mux4x16b	mux6b	 (state, 	  ms,		 		stateSel0, 	7'b0000000,  innerOut[46:40], stateSel3);
module mux4x16b(output reg [6:0] Y, input [1:0] S, input [6:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[6:0];
		2'b01: assign Y=I1[6:0];
		2'b10: assign Y=I2[6:0];
		2'b11: assign Y=I3[6:0];
		default: Y=I1;
	endcase
endmodule
//-------------------------------------------------------------------------------
//state adder 
// adder		adderAlu (addToR, 	  state, 			4'b0001);
module cuAdder(output reg [6:0] out, input [6:0] cs, input [3:0] add);
	initial out = 7'b0000000;
	always @ (cs)
	out = cs + add;
endmodule
//-------------------------------------------------------------------------------
//state adder register
// IncReg		incR	 (stateSel3,  addToR, 			1'b1,		clr, 		clk);
module IncReg(output reg [6:0] Q, input [6:0] D, input EN, CLR, CLK);
	initial Q = 6'b000000;	//Start registers with 0
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D;	//Enable Sync. Only occurs when Clk is high
		else if(!CLR)	//clear
			Q = 6'b000000;	//Clear Async
		else
			Q <= Q;	//enable off. output what came out before
endmodule
//-------------------------------------------------------------------------------
//ROM (output may increce, depending on signals requiered, 1bit per signal)
// ROM			rom		 (innerOut,   state, 			clk);
module ROM (output reg [52:0] out, input [6:0] state, input clk);
	reg [52:0]mem[96:0];
	initial begin 
		//fetch and decode
		//			        52   50  47  46     |39  38  37   33 32   28     26   22     20    17    13  12  11 10 9  8  7  6   5      3   1   0
		// 			     | s0s1 NS  Inv pl     |clr E0  RA   S8 RB   S9S10  RC   S11S16 S2-S0 S6-S3 S12 Sel E1 E2 E3 E4 S7 S15 S13S14 MAS R/W MFA
		mem[0][52:0]  = 53'b00011000000010100000000000000000000000000111101000010;
		mem[1][52:0]  = 53'b00011000000001100000111100000000000110100110101000010;
		mem[2][52:0]  = 53'b00011000000001011110000000111100101010000111101000010;
		mem[3][52:0]  = 53'b00101100000111100000000000000000000000000101101000101;
		mem[4][52:0]  = 53'b01100100000011100000000000000000000000000111101000010;
		//Data Proccesign
			//0000
		mem[6][52:0]  = 53'b01010100000011000001000000000001001000010111100000010;
		mem[5][52:0]  = 53'b01010100000011000001000001000001001000011111100000010;
			//0001
		mem[8][52:0]  = 53'b01010100000011000001000000000001001000110111100000010;
		mem[7][52:0]  = 53'b01010100000011000001000001000001001000111111100000010;
			//0010
		mem[10][52:0] = 53'b01010100000011000001000000000001001001010111100000010;
		mem[9][52:0]  = 53'b01010100000011000001000001000001001001011111100000010;
			//0011
		mem[12][52:0] = 53'b01010100000011000001000000000001001001110111100000010;
		mem[11][52:0] = 53'b01010100000011000001000001000001001001111111100000010;
			//0100
		mem[14][52:0] = 53'b01010100000011000001000000000001001010010111100000010;
		mem[13][52:0] = 53'b01010100000011000001000001000001001010011111100000010;
			//0101
		mem[16][52:0] = 53'b01010100000011000001000000000001001010110111100000010;
		mem[15][52:0] = 53'b01010100000011000001000001000001001010111111100000010;
			//0110
		mem[18][52:0] = 53'b01010100000011000001000000000001001011010111100000010;
		mem[17][52:0] = 53'b01010100000011000001000001000001001011011111100000010;
			//0111
		mem[20][52:0] = 53'b01010100000011000001000000000001001011110111100000010;
		mem[19][52:0] = 53'b01010100000011000001000001000001001011111111100000010;
			//1000
		mem[22][52:0] = 53'b01010100000011100001000000000000001100010111100000010;
		mem[21][52:0] = 53'b01010100000011100001000001000000001100011111100000010;
			//1001
		mem[24][52:0] = 53'b01010100000011100001000000000000001100110111100000010;
		mem[23][52:0] = 53'b01010100000011100001000001000000001100111111100000010;
			//1010
		mem[26][52:0] = 53'b01010100000011100001000000000000001101010111100000010;
		mem[25][52:0] = 53'b01010100000011100001000001000000001101011111100000010;
			//1011
		mem[28][52:0] = 53'b01010100000011100001000000000000001101110111100000010;
		mem[27][52:0] = 53'b01010100000011100001000001000000001101111111100000010;
			//1100
		mem[30][52:0] = 53'b01010100000011000001000000000001001110010111100000010;
		mem[29][52:0] = 53'b01010100000011000001000001000001001110011111100000010;
			//1101
		mem[32][52:0] = 53'b01010100000011000001000000000001001110110111100000010;
		mem[31][52:0] = 53'b01010100000011000001000001000001001110111111100000010;
			//1110
		mem[34][52:0] = 53'b01100100000011000001000000000001001111010111100000010;
		mem[33][52:0] = 53'b01010100000011000001000001000001001111011111100000010;
			//1111
		mem[36][52:0] = 53'b01010100000011000001000000000001001111110111100000010;
		mem[35][52:0] = 53'b01010100000011000001000001000001001111111111100000010;
		
		//load
			//immediate
		mem[96][52:0] = 53'b01010101101001100001000000000000101010010110100000010;
		mem[37][52:0] = 53'b01010101101001100001000000000000101001010110100000010;
			//register
		mem[38][52:0] = 53'b01010101101001100001000001000000000010010110100000010;
		mem[39][52:0] = 53'b01010101101001100001000001000000000001010110100000010;
			//immediate pre-indexed
		mem[40][52:0] = 53'b01010101101001000001000000000010101010010110100000010;
		mem[41][52:0] = 53'b01010101101001000001000000000010101001010110100000010;
			//register pre-indexed
		mem[42][52:0] = 53'b01010101101001000001000001000010000010010110100000010;
		mem[43][52:0] = 53'b01010101101001000001000001000010000001010110100000010;
			//immediate post-indexed
		mem[44][52:0] = 53'b01011100000011100000000011000000000110110110100000010;
		mem[46][52:0] = 53'b01011100000011100000000011000000000110110110100000010;	
		mem[45][52:0] = 53'b01010101101001000001000000000010101010010111100000010;
		mem[47][52:0] = 53'b01010101101001000001000000000010101001010111100000010;
			//register post-indexed
		mem[48][52:0] = 53'b01011100000011100000000011000000000110110110100000010;
		mem[50][52:0] = 53'b01011100000011100000000011000000000110110110100000010;
		mem[49][52:0] = 53'b01010101101001000001000001000010000010010111100000010;
		mem[51][52:0] = 53'b01011100000011000001000001000010000001010111100000010;
		
		mem[52][52:0] = 53'b00101101101001100000000000000000000000010111000010011;
		mem[53][52:0] = 53'b01010100000011000000000000000010111110110111110000010;
		
		//store
			//immediate
		mem[54][52:0] = 53'b01010110001101100001000000000000101010010110100000010;
		mem[55][52:0] = 53'b01010110001101100001000000000000101001010110100000010;
			//register
		mem[56][52:0] = 53'b01010110001101100001000001000000000010010110100000010;
		mem[57][52:0] = 53'b01010100000011100001000001000000000001010110100000010;
			//immediate pre-indexed
		mem[58][52:0] = 53'b01010110001101000001000000000010101010010110100000010;
		mem[59][52:0] = 53'b01010110001101000001000000000010101001010110100000010;
			//register pre-indexed
		mem[60][52:0] = 53'b01010110001101000001000001000010000010010110100000010;
		mem[61][52:0] = 53'b01010110001101000001000001000010000001010110100000010;
			//immediate post-indexed
		mem[62][52:0] = 53'b01011100000011100000000011000000000110110110100000010;
		mem[64][52:0] = 53'b01011100000011100000000011000000000110110110100000010;	
		mem[63][52:0] = 53'b01010110001101000001000000000010101010010111100000010;
		mem[65][52:0] = 53'b01010110001101000001000000000010101001010111100000010;
			//register post-indexed
		mem[66][52:0] = 53'b01011100000011100000000011000000000110110110100000010;
		mem[68][52:0] = 53'b01011100000011100000000011000000000110110110100000010;
		mem[67][52:0] = 53'b01010110001101000001000001000010000010010111100000010;
		mem[69][52:0] = 53'b01011100000011000001000001000010000001010111100000010;
		
		mem[70][52:0] = 53'b01011100000011100000000010000000000110110111000010001;
		mem[71][52:0] = 53'b00101110001111100000000000000000000110110111100010011;
		mem[72][52:0] = 53'b01010100000011000000000000000000000110110111100000010;
		
		//misc load
			//immediate
		mem[95][52:0] = 53'b01010110100001100001000000000000110010010110111000010;
		mem[73][52:0] = 53'b01010110100001100001000000000000110001010110111000010;
			//immediate pre-indexed
		mem[74][52:0] = 53'b01010110100001000001000000000010110010010110111000010;
		mem[75][52:0] = 53'b01010110100001000001000000000010110001010110111000010;
			//immediate post-indexed
		mem[76][52:0] = 53'b01011100000011100000000011000000000110110110101000010;
		mem[78][52:0] = 53'b01011100000011100000000011000000000110110110101000010;	
		mem[77][52:0] = 53'b01010110100001000001000000000010110010000111111000010;
		mem[79][52:0] = 53'b01011100000011000001000000000010110001000111111000010;
		
		mem[80][52:0] = 53'b00101110100001100000000000000000000110110111000010011;
		mem[81][52:0] = 53'b01010100000011000000000000000010111110110111110000010;
		
		//misc store
			//immediate
		mem[82][52:0] = 53'b01010110110101100001000000000000110010000110111000010;
		mem[83][52:0] = 53'b01010110110101100001000000000000110001000110111000010;
			//immediate pre-indexed
		mem[84][52:0] = 53'b01010110110101000001000000000010110010000110111000010;
		mem[85][52:0] = 53'b01010110110101000001000000000010110001000110111000010;
			//immediate post-indexed
		mem[86][52:0] = 53'b01011100000011100000000011000000000110110110101000010;
		mem[88][52:0] = 53'b01011100000011100000000011000000000110110110101000010;	
		mem[87][52:0] = 53'b01010110110101000001000000000010110010000111111000010;
		mem[89][52:0] = 53'b01011100000011000001000000000010110001000111111000010;
		
		mem[90][52:0] = 53'b01011100000011100000000010000000000110100111000010001;
		mem[91][52:0] = 53'b00101110110111100000000000000000000110110111100010011;
		mem[92][52:0] = 53'b01010100000011100000000000000000000110100111101000010;
		
		//b&L
		mem[93][52:0] = 53'b00011100000011000000111100111100001110110000000000010;
		//b
		mem[94][52:0] = 53'b00010100000011011110000000111100011010010100000000010;

		//Mloads	<-----\ to be done later
		//MStores	<-----/		   ... maybe

	end
	// always @ (posedge clk)
	always @ (state)
		out = mem[state][52:0];
endmodule
//-------------------------------------------------------------------------------
//control unit box (output depends on ROM output)
module ControlUnit (output reg [39:0] out, input clk, mfc, input [31:0] IR, statusReg);
	
	wire [6:0] state, stateSel0, stateSel3, addToR;
	wire [1:0] ms;
	wire invIn, invOut, condOut;
	wire [52:0] innerOut;  

	condEval	condEv	 (condOut, 	  IR, 				statusReg);//Sirve
	mux4x11b	mux1b	 (invIn, 	  innerOut[52:51],	mfc, 		condOut);
	inverter	inv		 (invOut, 	  invIn, 			innerOut[47]);
	NSASel		stateSel (ms, 		  innerOut[50:48], invOut);
	encoder		iREnc	 (stateSel0,  IR);//Sirve
	mux4x16b	mux6b	 (state, 	  ms,		 		stateSel0, 	7'b0000000,  innerOut[46:40], stateSel3);
	cuAdder		adderAlu (addToR, 	  state, 			4'b0001);
	IncReg		incR	 (stateSel3,  addToR, 			1'b0,		innerOut[39], 		clk);
	ROM			rom		 (innerOut,   state, 			clk);
	
	always @(posedge clk)
		out = innerOut[39:0];
endmodule
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//tester
/*module CUtester;

	reg clk, mfc;
	reg [31:0]IR, SR;
	wire [39:0]out;

	ControlUnit cu(out, clk, mfc, IR, SR);

	parameter simtime = 130;
	initial #simtime $finish;

	initial begin
		SR = 0;
		clk = 1;
		mfc = 0;
		SR = 32'b11110000000000000000000000000000;
		#7 mfc = 1; // RAM read finished
		   IR = 32'b11100010000000010000000000000000; // pass the IR instruction to control unit
		#8 IR = 32'b11100011100000000001000000101000;
		#8 IR = 32'b11100111110100010010000000000000;
		#16 IR = 32'b11100101110100010011000000000010;
		#16 IR = 32'b11100000100000000101000000000000;
		#8 IR = 32'b11100000100000100101000000000101;
		#8 IR = 32'b11100010010100110011000000000001;
		#8 IR = 32'b00011010111111111111111111111101;
		#6 IR = 32'b11100101110000010101000000000011;		 
		#12 IR = 32'b11101010000000000000000000000001;
		#8 IR = 32'b00001011000001010000011100000100;
		#18 IR = 32'b11101010111111111111111111111111;
	end

	initial forever #1 clk = ~clk; // Change Clock Every Time Unit

	initial begin
		$display("clk out                                        IR                           		State   	MuxSel InvIn   InvOut  CondOut  AdderOut	EncOut	    IncRegOut	    Time");
		$monitor("%b   %b   %b 	%b 	%b 	   %b 	   %b 	   %b 	    %b 	%b 	%b 	    %0d", clk, out, IR, cu.state, cu.ms, cu.invIn, cu.invOut, cu.condOut, cu.addToR, cu.stateSel0, cu.stateSel3, $time);
	end
endmodule*/
//-------------------------------------------------------------------------------
/*module invtester;
	wire out;
	reg in, inv;

	inverter tp(out, in, inv);

	parameter simtime = 30;
	initial #simtime $finish;

	initial begin
		in = 1;
		inv = 0;

		#2 repeat (2) #2 inv = ~inv;
		
		#8 in = 0;

		#2 repeat (2) #2 inv = ~inv;
	end
	initial begin	
		$display("out in inv");
		$monitor("%b   %b  %b", out, in, inv);
	end
endmodule*/
//-------------------------------------------------------------------------------
/*module nsatester;
	wire[1:0] M;
	reg [2:0] ns;
	reg sts;

	NSASel sel(M, ns, sts);

	parameter simtime = 70;
	initial #simtime $finish;

	initial begin
		ns = 3'b000;
		sts = 1;
		#2 repeat (7) #1 ns= ns+1'b1;
		#18 sts = 0;
		#18 repeat (7) #1 ns= ns-1'b1;

	end
	initial begin	
		$display("M  ns  sts");
		$monitor("%b %b %b", M, ns, sts);
	end
endmodule */
//-------------------------------------------------------------------------------
/*module condtester;
	wire out;
	reg reg [31:0] IR;
	reg [31:0] str;
	
	condEval cond(out, IR, str);

	parameter simtime = 70;
	initial #simtime $finish;

	initial begin
		IR = 00000000000000000000000000000000;
		str = 00110000000000000000000000000000;
		#1 repeat (15) #1 begin 
			IR = IR + 32'b00010000000000000000000000000000;
		end
	end
	initial begin	
		$display("out IR                                str");
		$monitor("%b   %b  %b", out, IR, str);
	end
endmodule */
//-------------------------------------------------------------------------------
/*module enctester;
	wire [6:0] out;
	reg [31:0] IR;
	
	encoder encode(out, IR);

	parameter simtime = 70;
	initial #simtime $finish;

	initial begin
		IR = 32'b11100110100110000000000000000010; // 32 bit immediate shifter
	end
	initial begin	
		$display("out 	  IR                               ");
		$monitor("%b   %b", out, IR);
	end
endmodule*/
//-------------------------------------------------------------------------------
/*module romtester;
	wire [52:0] out;
	reg [6:0] state;
	reg clk;

	parameter simtime = 15;
	initial #simtime $finish;

	ROM romVar (out, state, clk);

	initial begin
		clk = 0;
		state = 0;
		#1 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
		#2 state = state + 1;
	end

	initial forever #1 clk = ~clk; // Change Clock Every Time Unit

	initial begin
		$display("clk out       											    state    TIME");
		$monitor("%b   %b   %b %0d", clk, out, state, $time);
	end

endmodule*/