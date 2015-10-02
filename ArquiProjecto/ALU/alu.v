/*
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

	always @(LEFT_OP, RIGHT_OP, FN, CIN)
		begin
			case(FN)
			//AND
			4'b0000: 
			#5 begin
				//Set the output and C flag
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] & RIGHT_OP[31:0];
				

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
			// //EOR
			4'b0001: 
			#5 begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] ^ RIGHT_OP[31:0];
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
			// //SUB
			4'b0010: 
			#5 begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] -  RIGHT_OP[31:0];
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
			#5 begin
				{C,ALU_OUTPUT[31:0]} = RIGHT_OP[31:0]-  LEFT_OP[31:0];
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
			#5 begin
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
			#5 begin
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
			#5 begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] - RIGHT_OP[31:0] - !CIN;
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
			#5 begin
				{C,ALU_OUTPUT[31:0]} =  RIGHT_OP[31:0] - LEFT_OP[31:0] - ~CIN;
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
			#5 begin
				{C,TEMP[31:0]} = LEFT_OP[31:0] && RIGHT_OP[31:0];
				N = TEMP[31];

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
			// //TEQ
			4'b1001:
			#5 begin 
				{C,TEMP[31:0]} =  LEFT_OP[31:0] ^ RIGHT_OP[31:0];

				N =  TEMP[31];

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
			// //CMP
			4'b1010:
			#5 begin 
				{C,TEMP[31:0]} = LEFT_OP[31:0] -  RIGHT_OP[31:0];
				//Set the N flag
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
			#5 begin
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
			#5 begin
				ALU_OUTPUT[31:0] = LEFT_OP[31:0] | RIGHT_OP[31:0];
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
			// //MOV
			4'b1101:
			#5 begin
			 	ALU_OUTPUT[31:0] = RIGHT_OP[31:0];

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
			// //BIC
			4'b1110: 
			#5 begin
				ALU_OUTPUT[31:0] = LEFT_OP[31:0] & ~RIGHT_OP[31:0];
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
			// //MVN
			4'b1111: 
			#5 begin
				ALU_OUTPUT[31:0] = ~RIGHT_OP[31:0];
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
			endcase // FN
		end
endmodule