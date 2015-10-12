/*
Shifter operand === RIGHT_OP
0000 AND Logical AND Rd := Rn AND shifter_operand
0001 EOR Logical Exclusive OR Rd := Rn EOR shifter_operand
0010 SUB Subtract Rd := Rn - shifter_operand
0011 RSB Reverse Subtract Rd := shifter_operand - Rn
0100 ADD Add Rd := Rn + shifter_operand
0101 ADC Add with Carry Rd := Rn + shifter_operand + Carry Flag
0110 SBC Subtract with Carry Rd := Rn - shifter_operand - NOT(Carry Flag)
0111 RSC Reverse Subtract with Carry Rd := shifter_operand - Rn - NOT(Carry Flag)
1000 TST Test Update flags after Rn AND shifter_operand
1001 TEQ Test Equivalence Update flags after Rn EOR shifter_operand
1010 CMP Compare Update flags after Rn - shifter_operand
1011 CMN Compare Negated Update flags after Rn + shifter_operand
1100 ORR Logical (inclusive) OR Rd := Rn OR shifter_operand
1101 MOV Move Rd := shifter_operand (no first operand)
1110 BIC Bit Clear Rd := Rn AND NOT(shifter_operand)
1111 MVN Move Not Rd := NOT shifter_operand (no first operand)
*/
module ALU(output reg [31:0]ALU_OUTPUT, output reg Z,N,C, V, input  [31:0]LEFT_OP, RIGHT_OP, input  [3:0]FN, input  CIN);
	reg [31:0] TEMP;
	reg CTEMP;

	always @(LEFT_OP, RIGHT_OP, FN, CIN)
		begin
			case(FN)
			//AND
			4'b0000: 
			// #5 
			begin
				//Set the output and C flag

				{ALU_OUTPUT[31:0]} = LEFT_OP[31:0] & RIGHT_OP[31:0];
				C = CIN;

				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				
			end
			// //EOR
			4'b0001: 
			// #5 
			begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] ^ RIGHT_OP[31:0];
				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
			end
			// //SUB
			4'b0010: 
			// #5 
			begin
				{CTEMP,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] -  RIGHT_OP[31:0];
				C = ~CTEMP;
				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=ALU_OUTPUT[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //RSB
			4'b0011: 
			// #5 
			begin
				{CTEMP,ALU_OUTPUT[31:0]} = RIGHT_OP[31:0]-  LEFT_OP[31:0];
				C = ~CTEMP;
				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=ALU_OUTPUT[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //ADD
			4'b0100: 
			// #5 
			begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] +  RIGHT_OP[31:0];
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=ALU_OUTPUT[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //ADC
			4'b0101: 
			// #5 
			begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] + RIGHT_OP[31:0] + CIN;
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=ALU_OUTPUT[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //SBC
			4'b0110: 
			// #5 
			begin
				{CTEMP,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] - RIGHT_OP[31:0] - ~CIN;
				C = ~CTEMP;
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=ALU_OUTPUT[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //RSC
			4'b0111: 
			// #5 
			begin
				{CTEMP,ALU_OUTPUT[31:0]} =  RIGHT_OP[31:0] - LEFT_OP[31:0] - ~CIN;
				C = ~CTEMP;
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=ALU_OUTPUT[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //TST
			4'b1000: 
			// #5 
			begin
				{TEMP[31:0]} = LEFT_OP[31:0] & RIGHT_OP[31:0];
				N = TEMP[31];

				if(TEMP==0)
					Z = 1;
				else
					Z = 0;
			end
			// //TEQ
			4'b1001:
			// #5 
			begin 
				{TEMP[31:0]} =  LEFT_OP[31:0] ^ RIGHT_OP[31:0];

				N =  TEMP[31];

				if(TEMP==0)
					Z = 1;
				else
					Z = 0;
				
			end
			// //CMP
			4'b1010:
			// #5 
			begin 
				{CTEMP,TEMP[31:0]} = LEFT_OP[31:0] -  RIGHT_OP[31:0];
				//Set the N flag
				C = ~CTEMP;
				N = TEMP[31];
				//Set the Z flag
				if(TEMP==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=TEMP[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //CMN
			4'b1011:
			// #5 
			begin
				{C,TEMP[31:0]} = LEFT_OP[31:0] +  RIGHT_OP[31:0];
				N = TEMP[31];
				//Set the Z flag
				if(TEMP==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=TEMP[31])
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //ORR
			4'b1100: 
			// #5 
			begin
				ALU_OUTPUT[31:0] = LEFT_OP[31:0] | RIGHT_OP[31:0];
				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
			end
			// //MOV
			4'b1101:
			// #5 
			begin
			 	ALU_OUTPUT[31:0] = RIGHT_OP[31:0];

			 	//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
			end
			// //BIC
			4'b1110: 
			// #5 
			begin
				ALU_OUTPUT[31:0] = LEFT_OP[31:0] & ~RIGHT_OP[31:0];
				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
			end
			// //MVN
			4'b1111: 
			// #5 
			begin
				ALU_OUTPUT[31:0] = ~RIGHT_OP[31:0];
				//Set the N flag
				N = ALU_OUTPUT[31];
				//Set the Z flag
				if(ALU_OUTPUT==0)
					Z = 1;
				else
					Z = 0;
			end
			endcase // FN
		end
endmodule

//

module mux_4x1(output reg[31:0] Y, input [1:0] S, input [31:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[31:0];
		2'b01: assign Y=I1[31:0];
		2'b10: assign Y=I2[31:0];
		2'b11: assign Y=I3[31:0];
	endcase
endmodule

//
module mux_2x1(output [31:0] Y, input S, input [31:0] I0, I1);
	assign Y=S? I0:I1;
endmodule

module mux_2x1_2b(output [1:0] Y, input S, input [1:0] I0, I1);
	assign Y=S? I0:I1;
endmodule

//
/*MAS: 00 B  //  01 H  //  10 w  // 11 undefined
1 = read  //  0 = write
changed mem value for test purposes */

module ram512x8 (output reg [31:0]dataOut, output reg done, input enable, readWrite, input [8:0]address, input [31:0]dataIn, input [1:0]MAS);
	reg [8:0]mem[0:512];
	always @ (enable, readWrite, MAS, dataIn, address)
	begin
		if (enable)
		begin
			done = 0;
			if (readWrite) begin
				//Reading
				case(MAS)

					2'b00:	begin
						dataOut[7:0] = mem[address][7:0];
						dataOut[31:8] = 24'b0000_0000_0000_0000_0000_0000;
						
					end
					2'b01:	begin	
						dataOut[15:8] = mem[address][7:0];
						dataOut[7:0] = mem[address + 8'b0000001][7:0];
						dataOut[31:16] = 16'b0000_0000_0000_0000;
						
					end
					2'b10:	begin // #30;
						dataOut[31:0] = {mem[address][7:0], 
										 mem[address + 8'b0000001][7:0], 
										 mem[address + 8'b0000010][7:0], 
										 mem[address + 8'b0000011][7:0]};
						
					end
					default: dataOut = dataOut;
				endcase
			end
			else begin
				//Writing
				case(MAS)
					2'b00:	begin	
						
						mem[address][7:0] = dataIn[7:0];
						
					end
					2'b01:	begin
						
						mem[address][7:0] = dataIn[15:8];
						mem[address + 8'b0000001][7:0] = dataIn[7:0] ;
				
					end
					2'b10:	begin //#60;
						mem[address + 8'b00000011][7:0] = dataIn[7:0];
						mem[address + 8'b00000010][7:0] = dataIn[15:8];
						mem[address + 8'b00000001][7:0] = dataIn[23:16];
						mem[address][7:0] = dataIn[31:24];
						
					end
					default: dataOut = dataOut;
				endcase
			end
			done = 1;
		end
		else
			dataOut = 32'bz;
	end
endmodule

module reg_32b(output reg [12:0] Q, input [12:0] D, input EN, CLR, CLK);
	initial
		begin
			Q <= 12'b000000000000; // Start registers with 0
		end
	always @ (posedge CLK, negedge CLR)
		if(!EN)
			Q <= D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q <= 12'b000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

module reg_12to32_SE(output reg [32:0] Q, input [12:0] D, input EN, CLR, CLK);
	initial
		begin
			Q <= 12'b000000000000; // Start registers with 0
		end
	always @ (posedge CLK, negedge CLR)
		if(!EN)
			Q <= {D[11], D[11], D[11], D[11], D[11], D[11], D[11], D[11], D[11], 
				D[11], D[11], D[11], D[11], D[11], D[11], D[11], D[11], D[11], 
				D[11], D[11], D[11], D}; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q <= 12'b000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

module reg_32(output reg [31:0] Q, input [31:0] D, input EN, CLR, CLK);
	initial
		begin
			Q <= 32'b0000000000000000000000000000000; // Start registers with 0
		end
	always @ (posedge CLK, negedge CLR)
		if(!EN)
			Q <= D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q <= 32'b0000000000000000000000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

module dec4x16_32b(output reg [15:0] D, input[3:0] A, input EN);
	always @(EN, A)
		begin
			if (!EN) 
				begin
					case(A)
							4'b0000: D = 16'b1111111111111110;
							4'b0001: D = 16'b1111111111111101;
							4'b0010: D = 16'b1111111111111011;
							4'b0011: D = 16'b1111111111110111;
							4'b0100: D = 16'b1111111111101111;
							4'b0101: D = 16'b1111111111011111;
							4'b0110: D = 16'b1111111110111111;
							4'b0111: D = 16'b1111111101111111;
							4'b1000: D = 16'b1111111011111111;
							4'b1001: D = 16'b1111110111111111;
							4'b1010: D = 16'b1111101111111111;
							4'b1011: D = 16'b1111011111111111;
							4'b1100: D = 16'b1110111111111111;
							4'b1101: D = 16'b1101111111111111;
							4'b1110: D = 16'b1011111111111111;
							4'b1111: D = 16'b0111111111111111;
							default: D = 16'b1111111111111111;				
					endcase		
				end
		end
endmodule

module reg_32b(output reg [31:0] Q, input [31:0] D, input EN, CLR, CLK);
	initial
		begin
			Q = 32'b0000000000000000000000000000000; // Start registers with 0
		end
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q = 32'b0000000000000000000000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

module mux8x1_32b(output reg [31:0] O, input [31:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, input [3:0] SEL);
	always @ (SEL, I0, I1, I2, I3, I4, I5, I6, I7) // if I change the input and enable is high then 
		case(SEL)
			4'b0000: O = I0;
			4'b0001: O = I1;
			4'b0010: O = I2;
			4'b0011: O = I3;
			4'b0100: O = I4;
			4'b0101: O = I5;
			4'b0110: O = I6;
			4'b0111: O = I7;
			4'b1000: O = I8;
			4'b1001: O = I9;
			4'b1010: O = I10;
			4'b1011: O = I11;
			4'b1100: O = I12;
			4'b1101: O = I13;
			4'b1110: O = I14;
			4'b1111: O = I15;
			default:O = O;
		endcase
endmodule

module registerFile (output [31:0] A, B, input[31:0] PC, input [3:0] REGEN, input [3:0] REGCLR, input [3:0] M0SEL, input [3:0] M1SEL, input REGCLK, RFE);
	wire [15:0] decoder2RegEnable; // 16 lines of one bit for Register Enables
	wire [15:0]	decoder2RegClear; // 16 lines of one bit for Register Clears
	
	wire [31:0] reg0ToMux; // 1 line of 32 bits
	wire [31:0] reg1ToMux; // 1 line of 32 bits
	wire [31:0] reg2ToMux; // 1 line of 32 bits
	wire [31:0] reg3ToMux; // 1 line of 32 bits
	wire [31:0] reg4ToMux; // 1 line of 32 bits
	wire [31:0] reg5ToMux; // 1 line of 32 bits
	wire [31:0] reg6ToMux; // 1 line of 32 bits
	wire [31:0] reg7ToMux; // 1 line of 32 bits
	wire [31:0] reg8ToMux; // 1 line of 32 bits
	wire [31:0] reg9ToMux; // 1 line of 32 bits
	wire [31:0] reg10ToMux; // 1 line of 32 bits
	wire [31:0] reg11ToMux; // 1 line of 32 bits
	wire [31:0] reg12ToMux; // 1 line of 32 bits
	wire [31:0] reg13ToMux; // 1 line of 32 bits
	wire [31:0] reg14ToMux; // 1 line of 32 bits
	wire [31:0] reg15ToMux; // 1 line of 32 bits

	dec4x16_32b	D0 (decoder2RegEnable, REGEN, RFE); // Enable selector
	dec4x16_32b	D1 (decoder2RegClear, REGCLR, RFE); // Clear Selector

	reg_32b R0  (reg0ToMux,  PC, decoder2RegEnable[0],  decoder2RegClear[0], REGCLK);
	reg_32b R1  (reg1ToMux,  PC, decoder2RegEnable[1],  decoder2RegClear[1], REGCLK);
	reg_32b R2  (reg2ToMux,  PC, decoder2RegEnable[2],  decoder2RegClear[2], REGCLK);
	reg_32b R3  (reg3ToMux,  PC, decoder2RegEnable[3],  decoder2RegClear[3], REGCLK);
	reg_32b R4  (reg4ToMux,  PC, decoder2RegEnable[4],  decoder2RegClear[4], REGCLK);
	reg_32b R5  (reg5ToMux,  PC, decoder2RegEnable[5],  decoder2RegClear[5], REGCLK);
	reg_32b R6  (reg6ToMux,  PC, decoder2RegEnable[6],  decoder2RegClear[6], REGCLK);
	reg_32b R7  (reg7ToMux,  PC, decoder2RegEnable[7],  decoder2RegClear[7], REGCLK);
	reg_32b R8  (reg8ToMux,  PC, decoder2RegEnable[8],  decoder2RegClear[8], REGCLK);
	reg_32b R9  (reg9ToMux,  PC, decoder2RegEnable[9],  decoder2RegClear[9], REGCLK);
	reg_32b R10 (reg10ToMux, PC, decoder2RegEnable[10], decoder2RegClear[10],REGCLK);
	reg_32b R11 (reg11ToMux, PC, decoder2RegEnable[11], decoder2RegClear[11],REGCLK);
	reg_32b R12 (reg12ToMux, PC, decoder2RegEnable[12], decoder2RegClear[12],REGCLK);
	reg_32b R13 (reg13ToMux, PC, decoder2RegEnable[13], decoder2RegClear[13],REGCLK);
	reg_32b R14 (reg14ToMux, PC, decoder2RegEnable[14], decoder2RegClear[14],REGCLK);
	reg_32b R15 (reg15ToMux, PC, decoder2RegEnable[15], decoder2RegClear[15],REGCLK);

	mux8x1_32b M0 (A, reg0ToMux, reg1ToMux, reg2ToMux, reg3ToMux, reg4ToMux, reg5ToMux, reg6ToMux, reg7ToMux, 
		reg8ToMux, reg9ToMux, reg10ToMux, reg11ToMux, reg12ToMux, reg13ToMux, reg14ToMux, reg15ToMux, M0SEL);

	mux8x1_32b M1 (B, reg0ToMux, reg1ToMux, reg2ToMux, reg3ToMux, reg4ToMux, reg5ToMux, reg6ToMux, reg7ToMux, 
		reg8ToMux, reg9ToMux, reg10ToMux, reg11ToMux, reg12ToMux, reg13ToMux, reg14ToMux, reg15ToMux, M1SEL);
endmodule

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



