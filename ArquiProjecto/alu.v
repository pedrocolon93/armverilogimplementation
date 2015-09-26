module ALU(output reg [31:0]ALU_OUTPUT, output reg COUT, V, input  [31:0]LEFT_OP, RIGHT_OP, input  [3:0]FN, input  CIN);
	always @(LEFT_OP, RIGHT_OP, FN, CIN)
		begin
			case(FN)
			//AND
			4'b0000: ALU_OUTPUT[31:0] = LEFT_OP[31:0] && RIGHT_OP[31:0];
			// //EOR
			4'b0001: ALU_OUTPUT[31:0] = LEFT_OP[31:0] ^ RIGHT_OP[31:0];
			// //SUB
			4'b0010: ALU_OUTPUT[31:0] = LEFT_OP[31:0] -  RIGHT_OP[31:0];
			// //RSB
			4'b0011: ALU_OUTPUT[31:0] = RIGHT_OP[31:0]-  LEFT_OP[31:0] ;
			// //ADD
			4'b0100: ALU_OUTPUT[31:0] = LEFT_OP[31:0] +  RIGHT_OP[31:0];
			// //ADC
			// 4'b0101:
			// //SBC
			// 4'b0110:
			// //RSC
			// 4'b0111:
			// //TST
			// 4'b1000:
			// //TEQ
			// 4'b1001:
			// //CMP
			// 4'b1010:
			// //CMN
			// 4'b1011:
			// //ORR
			// 4'b1100:
			// //MOV
			// 4'b1101:
			// //BIC
			// 4'b1110:
			// //MVN
			// 4'b1111:

			endcase // FN
		end
// 
// ,  
endmodule
