//-------------------------------------------------------------------------------
// IR encoder for next state
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

module encoderOLD(output reg [6:0] out, input [31:0] IR);
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
// module enc_tester;
// 	wire [6:0] out;
// 	reg [31:0] IR;
	
// 	encoder encode(out, IR);

// 	parameter sim_time = 70;
// 	initial #sim_time $finish;

// 	initial begin
// 		IR = 32'b11100110100110000000000000000010; // 32 bit immediate shifter
// 	end
// 	initial begin	
// 		$display("out 	  IR                               ");
// 		$monitor("%b   %b", out, IR);
// 	end
// endmodule