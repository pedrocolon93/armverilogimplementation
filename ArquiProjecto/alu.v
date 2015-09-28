module ALU(output reg [31:0]ALU_OUTPUT, output reg Z,N,C, V, input  [31:0]LEFT_OP, RIGHT_OP, input  [3:0]FN, input  CIN);
	always @(LEFT_OP, RIGHT_OP, FN, CIN)
		begin
			case(FN)
			//AND
			4'b0000: 
			begin
				//Set the output and C flag
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] && RIGHT_OP[31:0];
				
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
			begin
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
			begin
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
			begin
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
			begin
				{C,ALU_OUTPUT[31:0]} = LEFT_OP[31:0] - RIGHT_OP[31:0] + CIN - 1;
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
			begin
				{C,ALU_OUTPUT[31:0]} =  RIGHT_OP[31:0] - LEFT_OP[31:0] + CIN - 1;
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
			begin
				{C} = LEFT_OP[31:0] && RIGHT_OP[31:0];

				if(LEFT_OP[31:0] && RIGHT_OP[31:0]==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=(LEFT_OP[31:0] && RIGHT_OP[31:0]))
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //TEQ
			4'b1001:
			begin 
				{C} = LEFT_OP[31:0] ^ RIGHT_OP[31:0];
				
				N =  LEFT_OP[31] ^ RIGHT_OP[31];

				if(LEFT_OP[31:0] ^ RIGHT_OP[31:0]==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=(LEFT_OP[31] ^ RIGHT_OP[31]))
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //CMP
			4'b1010:
			begin 
				{C} = LEFT_OP[31:0] -  RIGHT_OP[31:0];
				//Set the N flag
				N = (LEFT_OP[31:0] -  RIGHT_OP[31:0]);
				//Set the Z flag
				if((LEFT_OP[31:0] -  RIGHT_OP[31:0])==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=(LEFT_OP[31:0] -  RIGHT_OP[31:0]))
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //CMN
			4'b1011:
			begin
				{C} = LEFT_OP[31:0] +  RIGHT_OP[31:0];
				N = LEFT_OP[31:0] +  RIGHT_OP[31:0];
				//Set the Z flag
				if((LEFT_OP[31:0] +  RIGHT_OP[31:0])==0)
					Z = 1;
				else
					Z = 0;
				//Set the overflow flag
				//Check for 2's complement overflow
				if((LEFT_OP[31]==RIGHT_OP[31]))
					if(LEFT_OP[31]!=(LEFT_OP[31:0] +  RIGHT_OP[31:0]))
						V=1;
					else
						V=0;
				else 
					V=0;
			end
			// //ORR
			4'b1100: 
			begin
				ALU_OUTPUT[31:0] = LEFT_OP[31:0] || RIGHT_OP[31:0];
			end
			// //MOV
			4'b1101:
			begin
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
			begin
				ALU_OUTPUT[31:0] = LEFT_OP[31:0] && !RIGHT_OP[31:0];
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
			begin
				ALU_OUTPUT[31:0] = !RIGHT_OP[31:0];
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
// 
// ,  
endmodule
