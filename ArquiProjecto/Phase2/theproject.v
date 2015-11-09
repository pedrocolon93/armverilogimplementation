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
module ALU(output reg [31:0]ALU_OUTPUT, output reg Z,N,C, V, input  [31:0] LEFT_OP,RIGHT_OP, input  [3:0]FN, input  CIN);
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

//---------------------------------------------------------------------------------------------------------------------------------------
module mux_4x1(output reg[31:0] Y, input [1:0] S, input [31:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[31:0];
		2'b01: assign Y=I1[31:0];
		2'b10: assign Y=I2[31:0];
		2'b11: assign Y=I3[31:0];
	endcase
endmodule

module mux_4x1_2b(output reg[1:0] Y, input [1:0] S, input [1:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[1:0];
		2'b01: assign Y=I1[1:0];
		2'b10: assign Y=I2[1:0];
		2'b11: assign Y=I3[1:0];
	endcase
endmodule

module mux_4x1_4b(output reg[3:0] Y, input [1:0] S, input [3:0] I0, I1, I2, I3);
	always @ (S, I0, I1, I2, I3)
	case (S)
		2'b00: assign Y=I0[3:0];
		2'b01: assign Y=I1[3:0];
		2'b10: assign Y=I2[3:0];
		2'b11: assign Y=I3[3:0];
	endcase
endmodule
//---------------------------------------------------------------------------------------------------------------------------------------
module mux_8x1(output reg[31:0] Y, input [2:0] S, input [31:0] I0, I1, I2, I3, I4,I5,I6,I7);
	always @ (S, I0, I1, I2, I3, I4,I5,I6,I7)
	case (S)
		0: assign Y=I0[31:0];
		1: assign Y=I1[31:0];
		2: assign Y=I2[31:0];
		3: assign Y=I3[31:0];
		4: assign Y=I4;
		5: assign Y=I5;
		6: assign Y=I6;
		7: assign Y=I7;
	endcase
endmodule

module mux_8x1_2b(output reg[1:0] Y, input [2:0] S, input [1:0] I0, I1, I2, I3, I4,I5,I6,I7);
	always @ (S, I0, I1, I2, I3, I4,I5,I6,I7)
	case (S)
		0: assign Y=I0;
		1: assign Y=I1;
		2: assign Y=I2;
		3: assign Y=I3;
		4: assign Y=I4;
		5: assign Y=I5;
		6: assign Y=I6;
		7: assign Y=I7;
	endcase
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module mux_2x1(output [31:0] Y, input S, input [31:0] I0, I1);
	assign Y=S? I1:I0;
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module mux_2x1_1b(output Y, input S, input I0, I1);
	assign Y=S? I1:I0;
endmodule
module mux_2x1_2b(output [1:0] Y, input S, input [1:0] I0, I1);
	assign Y=S? I1:I0;
endmodule

module mux_2x1_4b(output [3:0] Y, input S, input [3:0] I0, I1);
	assign Y=S? I1:I0;
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
/*MAS: 00 B  //  01 H  //  10 w  // 11 undefined
1 = read  //  0 = write*/
module ram512x8 (output reg [31:0]dataOut, output reg done, input enable, readWrite, input [7:0]address, input [31:0]dataIn, input [1:0]MAS);
	reg [7:0]mem[0:511];
	always @ (enable, readWrite, MAS, dataIn, address)
	begin
		if (enable) begin
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
					2'b10:	begin
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
					2'b00:	mem[address][7:0] = dataIn[7:0];
					2'b01:	begin
						mem[address][7:0] = dataIn[15:8];
						mem[address + 8'b0000001][7:0] = dataIn[7:0] ;
					end
					2'b10:	begin
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
		else begin
			dataOut = 32'bz;
			done = 0;
		end
	end
endmodule
//---------------------------------------------------------------------------------------------------------------------------------------
module ramdummyreadfile (output reg [31:0]dataOut, output reg done, input enable, readWrite, input [7:0]address, input [31:0]dataIn, input [1:0]MAS);
	reg [7:0]mem[0:511];
	initial begin
	  $readmemb("data.bin", mem) ;
	  done = 0;
	end
	always @ (enable, readWrite, MAS, dataIn, address)
	begin
		if (enable) begin

			done = 0;
			if (readWrite) begin
				//Reading
				$display("reading");
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
					2'b00:	mem[address][7:0] = dataIn[7:0];
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


//---------------------------------------------------------------------------------------------------------------------------------------
module reg_12b(output reg [11:0] Q, input [11:0] D, input EN, CLR, CLK);
	initial	Q <= 12'b000000000000; // Start registers with 0
	always @ (posedge CLK, negedge CLR)
		if(!EN)
			Q <= D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q <= 12'b000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module reg_12to32_SE(output reg [32:0] Q, input [12:0] D, input EN, CLR, CLK);
	initial	Q <= 12'b000000000000; // Start registers with 0
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

//---------------------------------------------------------------------------------------------------------------------------------------
module reg_32(output reg [31:0] Q, input [31:0] D, input EN, CLR, CLK);
	initial	Q = 32'b0000000000000000000000000000000; // Start registers with 0
	always @ (posedge CLK, negedge CLR)
		if(!EN)
			Q <= D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q <= 32'b0000000000000000000000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module dec4x16_32b(output reg [15:0] D, input[3:0] A, input EN);
	always @(EN, A)
	begin
		if (!EN)
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
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module reg_32b(output reg [31:0] Q, input [31:0] D, input EN, CLR, CLK);
	initial	Q = 32'b0000000000000000000000000000000; // Start registers with 0
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q = 32'b0000000000000000000000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule
module reg_32b_MAGIC(output reg [31:0] Q, input [31:0] D, input EN, CLR, CLK);
	initial	Q = 32'b0000000000000011000001001001001; // Start registers with 0
	always @ (negedge CLK, negedge CLR)
		if(!EN)
			Q = D; // Enable Sync. Only occurs when Clk is high
		else if(!CLR) // clear
			Q = 32'b0000000000000000000000000000000; // Clear Async
		else
			Q <= Q; // enable off. output what came out before
endmodule
//---------------------------------------------------------------------------------------------------------------------------------------
module mux8x1_32b(output reg [31:0] O, input [31:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, input [3:0] SEL);
	always @ (SEL, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15) // if I change the input and enable is high then 
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

//---------------------------------------------------------------------------------------------------------------------------------------
module registerFile (output [31:0] A, B, input[31:0] PC, input [3:0] REGEN, input REGCLR, input [3:0] M0SEL, input [3:0] M1SEL, input REGCLK, RFE);
	wire [15:0] decoder2RegEnable; // 16 lines of one bit for Register Enables
	
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

	reg_32b R0  (reg0ToMux,  PC, decoder2RegEnable[0],  REGCLR, REGCLK);
	reg_32b R1  (reg1ToMux,  PC, decoder2RegEnable[1],  REGCLR, REGCLK);
	reg_32b R2  (reg2ToMux,  PC, decoder2RegEnable[2],  REGCLR, REGCLK);
	reg_32b R3  (reg3ToMux,  PC, decoder2RegEnable[3],  REGCLR, REGCLK);
	reg_32b R4  (reg4ToMux,  PC, decoder2RegEnable[4],  REGCLR, REGCLK);
	reg_32b R5  (reg5ToMux,  PC, decoder2RegEnable[5],  REGCLR, REGCLK);
	reg_32b R6  (reg6ToMux,  PC, decoder2RegEnable[6],  REGCLR, REGCLK);
	reg_32b R7  (reg7ToMux,  PC, decoder2RegEnable[7],  REGCLR, REGCLK);
	reg_32b R8  (reg8ToMux,  PC, decoder2RegEnable[8],  REGCLR, REGCLK);
	reg_32b R9  (reg9ToMux,  PC, decoder2RegEnable[9],  REGCLR, REGCLK);
	reg_32b R10 (reg10ToMux, PC, decoder2RegEnable[10], REGCLR, REGCLK);
	reg_32b R11 (reg11ToMux, PC, decoder2RegEnable[11], REGCLR, REGCLK);
	reg_32b_MAGIC R12 (reg12ToMux, PC, decoder2RegEnable[12], REGCLR, REGCLK);
	reg_32b R13 (reg13ToMux, PC, decoder2RegEnable[13], REGCLR, REGCLK);
	reg_32b R14 (reg14ToMux, PC, decoder2RegEnable[14], REGCLR, REGCLK);
	reg_32b R15 (reg15ToMux, PC, decoder2RegEnable[15], REGCLR, REGCLK);

	mux8x1_32b M0 (A, reg0ToMux, reg1ToMux, reg2ToMux, reg3ToMux, reg4ToMux, reg5ToMux, reg6ToMux, reg7ToMux, 
		reg8ToMux, reg9ToMux, reg10ToMux, reg11ToMux, reg12ToMux, reg13ToMux, reg14ToMux, reg15ToMux, M0SEL);

	mux8x1_32b M1 (B, reg0ToMux, reg1ToMux, reg2ToMux, reg3ToMux, reg4ToMux, reg5ToMux, reg6ToMux, reg7ToMux, 
		reg8ToMux, reg9ToMux, reg10ToMux, reg11ToMux, reg12ToMux, reg13ToMux, reg14ToMux, reg15ToMux, M1SEL);
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module internal_shifter (
	input [31:0] amount, value,
	input [1:0] shift_type,
	output reg [31:0] shift_out
);
	reg [63:0] temp;
	always @(amount, value, shift_type) 
	begin
		// $display("Changing shifter output");
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
				//rotate right
				temp = {value, value} >> amount;
				shift_out[31:0] = temp[31:0];
			end
		endcase //shift_type
	end
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module shifter(input[31:0] input_register, input[11:0] shifter_operand, input selector, output [31:0] out);
	wire[31:0] amounttointernal,valuetointernal;
	wire[1:0] shifttypetointernal;
	//
	mux_2x1 amount_mux(amounttointernal,selector,{27'b0000_0000_0000_0000_0000_0000_000,shifter_operand[11:8],1'b0}, {27'b0000_0000_0000_0000_0000_0000_000,shifter_operand[11:7]});
	mux_2x1 value_mux(valuetointernal,selector,{24'b0000_0000_0000_0000_0000_0000,shifter_operand[7:0]},input_register[31:0]);
	
	mux_2x1_2b shift_type_mux(shifttypetointernal,selector,1,shifter_operand[6:5]);

	internal_shifter intsh(amounttointernal,valuetointernal,shifttypetointernal,out);
endmodule

//---------------------------------------------------------------------------------------------------------------------------------------
module adder(input [31:0] pc, right, output reg [31:0] out);
	always @(pc, right)
		out = pc+right;
endmodule	
//---------------------------------------------------------------------------------------------------------------------------------------
// Control unit 
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
//mux_4x1_1b	mux1b	 (invIn, 	  innerOut[52:51],	mfc, 		condOut);
module mux_4x1_1b(output reg Y, input [1:0] S, input I0, I1);
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
// 	mux_4x1_6b	mux6b	 (state, 	  ms,		 		stateSel0, 	7'b0000000,  innerOut[46:40], stateSel3);
module mux_4x1_6b(output reg [6:0] Y, input [1:0] S, input [6:0] I0, I1, I2, I3);
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
		mem[0][52:0]  = 53'b00___011_0___0000001_0___1___0000_0__0000_00_____0000_00_____000___0000__0___0___1__1__1__1__0__1___00_____00__1___0;
		mem[1][52:0]  = 53'b00___011_0___0000000_1___1___0000_0__1111_00_____0000_00_____000___1101__0___0___1__1__0__1__0__1___00_____00__1___0;
		mem[2][52:0]  = 53'b00___011_0___0000000_1___0___1111_0__0000_00_____1111_00_____101___0100__0___0___1__1__1__1__0__1___00_____00__1___0;
		mem[3][52:0]  = 53'b00___101_1___0000011_1___1___0000_0__0000_00_____0000_00_____000___0000__0___0___1__0__1__1__0__1___00_____01__0___1;
		mem[4][52:0]  = 53'b01___100_1___0000001_1___1___0000_0__0000_00_____0000_00_____000___0000__0___0___1__1__1__1__0__1___00_____00__1___0;
		//Data Proccesign
			//0000
		mem[6][52:0]  = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0000__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[5][52:0]  = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0000__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0001
		mem[8][52:0]  = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0001__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[7][52:0]  = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0001__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0010
		mem[10][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0010__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[9][52:0]  = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0010__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0011
		mem[12][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0011__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[11][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0011__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0100
		mem[14][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0100__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[13][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0100__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0101
		mem[16][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0101__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[15][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0101__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0110
		mem[18][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0110__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[17][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0110__1___1___1__1__1__1__0__0___00_____00__1___0;
			//0111
		mem[20][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___0111__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[19][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___0111__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1000
		mem[22][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_00_____0000_00_____001___1000__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[21][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_01_____0000_00_____001___1000__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1001
		mem[24][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_00_____0000_00_____001___1001__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[23][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_01_____0000_00_____001___1001__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1010
		mem[26][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_00_____0000_00_____001___1010__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[25][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_01_____0000_00_____001___1010__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1011
		mem[28][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_00_____0000_00_____001___1011__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[27][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_01_____0000_00_____001___1011__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1100
		mem[30][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___1100__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[29][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___1100__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1101
		mem[32][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___1101__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[31][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___1101__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1110
		mem[34][52:0] = 53'b01___100_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___1110__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[33][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___1110__1___1___1__1__1__1__0__0___00_____00__1___0;
			//1111
		mem[36][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_00_____0000_01_____001___1111__1___0___1__1__1__1__0__0___00_____00__1___0;
		mem[35][52:0] = 53'b01___010_1___0000001_1___0___0000_1__0000_01_____0000_01_____001___1111__1___1___1__1__1__1__0__0___00_____00__1___0;
		
		//load
			//immediate
		mem[96][52:0] = 53'b01___010_1___0110100_1___1___0000_1__0000_00_____0000_00_____101___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[37][52:0] = 53'b01___010_1___0110100_1___1___0000_1__0000_00_____0000_00_____101___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//register
		mem[38][52:0] = 53'b01___010_1___0110100_1___1___0000_1__0000_01_____0000_00_____000___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[39][52:0] = 53'b01___010_1___0110100_1___1___0000_1__0000_01_____0000_00_____000___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//immediate pre-indexed
		mem[40][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_00_____0000_10_____101___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[41][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_00_____0000_10_____101___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//register pre-indexed
		mem[42][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_01_____0000_10_____000___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[43][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_01_____0000_10_____000___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//immediate post-indexed
		mem[44][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[46][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;	
		mem[45][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_00_____0000_10_____101___0100__1___0__1__1__1__1__0__0___00_____00__1___0;
		mem[47][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_00_____0000_10_____101___0010__1___0__1__1__1__1__0__0___00_____00__1___0;
			//register post-indexed
		mem[48][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[50][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[49][52:0] = 53'b01___010_1___0110100_1___0___0000_1__0000_01_____0000_10_____000___0100__1___0__1__1__1__1__0__0___00_____00__1___0;
		mem[51][52:0] = 53'b01___011_1___0000001_1___0___0000_1__0000_01_____0000_10_____000___0010__1___0__1__1__1__1__0__0___00_____00__1___0;
		
		mem[52][52:0] = 53'b00___101_1___0110100_1___1___0000_0__0000_00_____0000_00_____000___0000__1___0__1__1__1__0__0__0___01_____00__1___1;
		mem[53][52:0] = 53'b01___010_1___0000001_1___0___0000_0__0000_00_____0000_10_____111___1101__1___0__1__1__1__1__1__0___00_____00__1___0;
		
		//store
			//immediate
		mem[54][52:0] = 53'b01___010_1___1000110_1___1___0000_1__0000_00_____0000_00_____101___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[55][52:0] = 53'b01___010_1___1000110_1___1___0000_1__0000_00_____0000_00_____101___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//register
		mem[56][52:0] = 53'b01___010_1___1000110_1___1___0000_1__0000_01_____0000_00_____000___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[57][52:0] = 53'b01___010_1___0000001_1___1___0000_1__0000_01_____0000_00_____000___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//immediate pre-indexed
		mem[58][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_00_____0000_10_____101___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[59][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_00_____0000_10_____101___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//register pre-indexed
		mem[60][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_01_____0000_10_____000___0100__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[61][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_01_____0000_10_____000___0010__1___0__1__1__0__1__0__0___00_____00__1___0;
			//immediate post-indexed
		mem[62][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[64][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;	
		mem[63][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_00_____0000_10_____101___0100__1___0__1__1__1__1__0__0___00_____00__1___0;
		mem[65][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_00_____0000_10_____101___0010__1___0__1__1__1__1__0__0___00_____00__1___0;
			//register post-indexed
		mem[66][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[68][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__0___00_____00__1___0;
		mem[67][52:0] = 53'b01___010_1___1000110_1___0___0000_1__0000_01_____0000_10_____000___0100__1___0__1__1__1__1__0__0___00_____00__1___0;
		mem[69][52:0] = 53'b01___011_1___0000001_1___0___0000_1__0000_01_____0000_10_____000___0010__1___0__1__1__1__1__0__0___00_____00__1___0;
		
		mem[70][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_10_____0000_00_____000___1101__1___0__1__1__1__0__0__0___01_____00__0___1;
		mem[71][52:0] = 53'b00___101_1___1000111_1___1___0000_0__0000_00_____0000_00_____000___1101__1___0__1__1__1__1__0__0___01_____00__1___1;
		mem[72][52:0] = 53'b01___010_1___0000001_1___0___0000_0__0000_00_____0000_00_____000___1101__1___0__1__1__1__1__0__0___00_____00__1___0;
		
		//misc load
			//immediate
		mem[95][52:0] = 53'b01___010_1___1010000_1___1___0000_1__0000_00_____0000_00_____110___0100__1___0__1__1__0__1__1__1___00_____00__1___0;
		mem[73][52:0] = 53'b01___010_1___1010000_1___1___0000_1__0000_00_____0000_00_____110___0010__1___0__1__1__0__1__1__1___00_____00__1___0;
			//immediate pre-indexed
		mem[74][52:0] = 53'b01___010_1___1010000_1___0___0000_1__0000_00_____0000_10_____110___0100__1___0__1__1__0__1__1__1___00_____00__1___0;
		mem[75][52:0] = 53'b01___010_1___1010000_1___0___0000_1__0000_00_____0000_10_____110___0010__1___0__1__1__0__1__1__1___00_____00__1___0;
			//immediate post-indexed
		mem[76][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__1___00_____00__1___0;
		mem[78][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__1___00_____00__1___0;	
		mem[77][52:0] = 53'b01___010_1___1010000_1___0___0000_1__0000_00_____0000_10_____110___0100__0___0__1__1__1__1__1__1___00_____00__1___0;
		mem[79][52:0] = 53'b01___011_1___0000001_1___0___0000_1__0000_00_____0000_10_____110___0010__0___0__1__1__1__1__1__1___00_____00__1___0;
		
		mem[80][52:0] = 53'b00___101_1___1010000_1___1___0000_0__0000_00_____0000_00_____000___1101__1___0__1__1__1__0__0__0___01_____00__1___1;
		mem[81][52:0] = 53'b01___010_1___0000001_1___0___0000_0__0000_00_____0000_10_____111___1101__1___0__1__1__1__1__1__0___00_____00__1___0;
		
		//misc store
			//immediate
		mem[82][52:0] = 53'b01___010_1___1011010_1___1___0000_1__0000_00_____0000_00_____110___0100__0___0__1__1__0__1__1__1___00_____00__1___0;
		mem[83][52:0] = 53'b01___010_1___1011010_1___1___0000_1__0000_00_____0000_00_____110___0010__0___0__1__1__0__1__1__1___00_____00__1___0;
			//immediate pre-indexed
		mem[84][52:0] = 53'b01___010_1___1011010_1___0___0000_1__0000_00_____0000_10_____110___0100__0___0__1__1__0__1__1__1___00_____00__1___0;
		mem[85][52:0] = 53'b01___010_1___1011010_1___0___0000_1__0000_00_____0000_10_____110___0010__0___0__1__1__0__1__1__1___00_____00__1___0;
			//immediate post-indexed
		mem[86][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__1___00_____00__1___0;
		mem[88][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_11_____0000_00_____000___1101__1___0__1__1__0__1__0__1___00_____00__1___0;	
		mem[87][52:0] = 53'b01___010_1___1011010_1___0___0000_1__0000_00_____0000_10_____110___0100__0___0__1__1__1__1__1__1___00_____00__1___0;
		mem[89][52:0] = 53'b01___011_1___0000001_1___0___0000_1__0000_00_____0000_10_____110___0010__0___0__1__1__1__1__1__1___00_____00__1___0;
		
		mem[90][52:0] = 53'b01___011_1___0000001_1___1___0000_0__0000_10_____0000_00_____000___1101__0___0__1__1__1__0__0__0___01_____00__0___1;
		mem[91][52:0] = 53'b00___101_1___1011011_1___1___0000_0__0000_00_____0000_00_____000___1101__1___0__1__1__1__1__0__0___01_____00__1___1;
		mem[92][52:0] = 53'b01___010_1___0000001_1___1___0000_0__0000_00_____0000_00_____000___1101__0___0__1__1__1__1__0__1___00_____00__1___0;
		
		//b&L
		mem[93][52:0] = 53'b00___011_1___0000001_1___0___0000_0__1111_00_____1111_00_____001___1101__1___0__0__0__0__0__0__0___00_____00__1___0;
		//b
		mem[94][52:0] = 53'b00___010_1___0000001_1___0___1111_0__0000_00_____1111_00_____011___0100__1___0__1__0__0__0__0__0___00_____00__1___0;

		//Mloads	<-----\___ to be done later
		//MStores	<-----/		   ... maybe

	end
	always @ (state)
		$display("State %d",state);
	always @ (posedge clk)
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
	mux_4x1_1b	mux1b	 (invIn, 	  innerOut[52:51],	mfc, 		condOut);
	inverter	inv		 (invOut, 	  invIn, 			innerOut[47]);
	NSASel		stateSel (ms, 		  innerOut[50:48], invOut);
	encoder		iREnc	 (stateSel0,  IR);//Sirve
	mux_4x1_6b	mux6b	 (state, 	  ms,		 		stateSel0, 	7'b0000000,  innerOut[46:40], stateSel3);
	cuAdder		adderAlu (addToR, 	  state, 			4'b0001);
	IncReg		incR	 (stateSel3,  addToR, 			1'b0,		innerOut[39], 		clk);
	ROM			rom		 (innerOut,   state, 			clk);
	
	// always @(posedge clk)
	// 	out = innerOut[39:0];
	always @(innerOut)
		out = innerOut[39:0];
endmodule



//---------------------------------------------------------------------------------------------------------------------------------------
module datapath;
	//CU Signals
	reg E0,E1,E2,E3,E4;//Enables the register that holds pc+4
	wire E5;
	reg S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16;//Selects whether its pc or pc+4


	wire [3:0] RA; // Selector of A Mux is 3 bits
	wire [3:0] RB; // Selector of B Mux is 3 bits
	wire [3:0] RC; // Register Enable Selectors (Input to Decoders 0 and 1)
	wire RD;  // Register Clear Selectors (Input to Decoders 0 and 1)


	reg MFA;//Signals for memory
	reg RW;
	wire [1:0]MAS;
	wire MFC;

	reg shift_type;//shifter

	//Flags
	wire N, COUT, V, ZERO;//ALU Flags
	
	//Clock
	reg CLK; // Register Clock Enable (All Clocks of Registers are Shared)
	reg clr;

	//General wires
	wire CIN;		
	
	wire [31:0] PC, LEFT_OP, B,TSROUT;


	wire [31:0] alu_in_sel_mux_to_alu, register_to_mux, adder_to_register;
	wire [31:0] mar_to_ram;
	wire [1:0] mux_reg_output, mux_mas_out, mux_misc_out,CUMAS;

	reg [31:0]data;
	
	wire [31:0] mem_data;
	wire [31:0] ir_out, mdr_out, mdr_in;
	wire [11:0] twelve_bit_shift_reg_out;
	reg [31:0]input_register;

	wire [31:0] shifter_output;
	wire [31:0] ser_out;

	wire [31:0] status_register_out;
	reg [3:0] RA_CU, RB_CU, RC_CU;
	wire SC;

	wire [39:0] cuSignals;
	 
	//ControlUnit (output reg [39:0] out, input clk, clr, mfc, input [31:0] IR, statusReg);
	ControlUnit cu (cuSignals, CLK, MFC, ir_out, shifter_output);

	//Register file muxes
	//mux_2x1_4b ra_mux(RA,S8,RA_CU,ir_out[19:16]);
	mux_2x1_4b ra_mux(RA, cuSignals[33], cuSignals[37:34], ir_out[19:16]);
	//mux_4x1_4b rb_mux(RB,{S10,S9},RB_CU,ir_out[3:0],ir_out[15:12],ir_out[19:16]);
	mux_4x1_4b rb_mux(RB, cuSignals[28:27], cuSignals[32:29], ir_out[3:0], ir_out[15:12], ir_out[19:16]);
	//mux_4x1_4b rc_mux(RC,{S16,S11},RC_CU,ir_out[15:12],ir_out[19:16],0);
	mux_4x1_4b rc_mux(RC, cuSignals[22:21], cuSignals[26:23], ir_out[15:12], ir_out[19:16],4'b0000);

	//Register file
	registerFile registerFile (LEFT_OP, B, PC, RC, cuSignals[39], RA, RB, CLK, cuSignals[38]);
	
	//Input mux
	//mux_8x1 alu_input_select_mux(alu_in_sel_mux_to_alu, {S2,S1,S0}, B, shifter_output, ir_out, ser_out,4,{{20{1'b0}},ir_out[11:0]},{{20{1'b0}},ir_out[11:0]},mdr_out);
	mux_8x1 alu_input_select_mux(alu_in_sel_mux_to_alu, cuSignals[20:18], B, shifter_output, ir_out, ser_out,4,{{20{1'b0}},ir_out[11:0]},{{20{1'b0}},ir_out[11:0]},mdr_out);
	
	//Alu
	//mux_2x1_1b alu_cin_mux(CIN,S12,SC,TSROUT[29]);
	mux_2x1_1b alu_cin_mux(CIN, cuSignals[13], SC, TSROUT[29]);
	//ALU alu1(PC, ZERO, N, COUT, V, LEFT_OP, alu_in_sel_mux_to_alu, {S6,S5,S4,S3}, CIN);
	ALU alu1(PC, ZERO, N, COUT, V, LEFT_OP, alu_in_sel_mux_to_alu, cuSignals[17:14], CIN);
	//Status register
	//mux_2x1_1b sr_mux(E5,S15,1,ir_out[20]);
	mux_2x1_1b sr_mux(E5, cuSignals[6], 1, ir_out[20]);
	reg_32 status_register(TSROUT, {N,Z,C,V,28'b0000_0000_0000_0000_0000_0000_0000}, E5, cuSignals[39], CLK);
	//Right side
	//mux_2x1 mdr_mux(mdr_in, S7, PC,ir_out);
	mux_2x1 mdr_mux(mdr_in, cuSignals[7], PC, ir_out);
	reg_32 mdr(mdr_out, mdr_in, cuSignals[8], cuSignals[39], CLK);

	
	//reg_32 mar(mar_to_ram,PC,E3,1'b1,CLK);
	reg_32 mar(mar_to_ram, PC, cuSignals[9], cuSignals[39], CLK);


	//ram512x8 ram(mem_data, finished, en, rw, mar_to_ram[7:0], data, dataSize);
	mux_8x1_2b misc_mux(mux_misc_out, {ir_out[20],ir_out[6],ir_out[5]}, 0 ,2'b01, 2'b10, 2'b10, 2'b10, 0, 2'b00, 2'b01);
	mux_2x1_2b reg_mux(mux_reg_output, ir_out[22], 2'b00, 2'b01);
	//mux_4x1_2b mas_mux(MAS,{S14,S13},CUMAS,mux_misc_out,mux_reg_output,0);
	mux_4x1_2b mas_mux(MAS, cuSignals[5:4], cuSignals[3:2], mux_misc_out, mux_reg_output, 0);
	//ramdummyreadfile ram(mem_data, finished, en, rw, mar_to_ram[7:0], mdr_out, MAS);
	//									Enable  	  Read/Write    Input Address    Input Data Datasize
	ramdummyreadfile ram(mem_data, MFC, cuSignals[0], cuSignals[1], mar_to_ram[7:0], mdr_out, MAS);

	//reg_32 ir(ir_out, mem_data,E3,1'b1,CLK);
	reg_32 ir(ir_out, mem_data, cuSignals[10], cuSignals[39], CLK);


	//shifter sh(B,ir_out[11:0],shift_type,shifter_output);
	shifter sh(B, ir_out[11:0], cuSignals[12], shifter_output);

	//reg_32 ser(ser_out,{{18{ir_out[11]}},ir_out[11:0],2'b00},E1,1'b1,CLK);
	reg_32 ser(ser_out, {{18{ir_out[11]}},ir_out[11:0],2'b00}, cuSignals[11], cuSignals[39], CLK);
	


	//Vamos a probar 
	parameter sim_time = 40;
	initial #sim_time $finish;

	initial begin 
		CLK = 1;
	end

	initial forever #2 CLK = ~CLK; // Change Clock Every Time Unit
	
	initial begin 

	end
	initial begin
		// $display ("CLK PC RA RB RC"); //imprime header
		// $monitor ("%d",PC);
		$monitor ("CLK %d PC %b RA %d RB %d RC %d MARTORAM %0d MFC %d MEMDATA %b CUSIGNALS %b ENABLERAM %b READ/WRITERAM %b",CLK, PC, RA, RB, RC, mar_to_ram, MFC,mem_data,cuSignals,cuSignals[0], cuSignals[1]); //imprime las señales
	end
endmodule	