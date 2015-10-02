/*
*************************************************************************
*************************** ARM Register File ***************************
************************** 31 32-bit registers **************************
***************** Inputs : RA, RB, REGEN, RC, RD, CLK, PC ***************
***************************** Outputs : A, B ****************************
*** 16 32-bit D Flip Flops, 2 32-bit 8*1 Input Muxes, 2 4*16 Decoders ***
*************************************************************************
*/

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