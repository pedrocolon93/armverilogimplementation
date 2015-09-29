//MAS: 00 B  //  01 H  //  10 w  // 11 undefined
// need to check for real values ---^
// 1 = read  //  0 = write

module ram512x8 (output reg [31:0]dataOut, done, input enable, readWrite, input [8:0]address, input [31:0]dataIn, input [1:0]MAS, input [1:0]A);
	reg [31:0]mem[0:511];
	always @ (enable, readWrite, sel)
	begin
		if (enable)
		begin
			done = 1'b0;
			if (readWrite)
			begin
				case(MAS)
					2'b00:
					begin
						case(A):
							2'b00:	dataOut[7:0] = mem[address + 8b0000011];
							2'b01:	dataOut[7:0] = mem[address + 8b0000010];
							2'b10:	dataOut[7:0] = mem[address + 8b0000001];
							2'b11:	dataOut[7:0] = mem[address];
						endcase
						dataOut[31:8] = 24'b0000_0000_0000_0000_0000_0000;
						#15;
					end
					2'b01:	
					begin	
						case(A[1]):
							1'b0:
							begin
								dataOut[15:8] = mem[address + 8b0000010];
								dataOut[7:0] = mem[address + 8b0000011];
							end
							1'b1:
							begin
								dataOut[15:8] = mem[address];
								dataOut[7:0] = mem[address + 8b0000001];
							end
						endcase
						dataOut[31:16] = 16'b0000_0000_0000_0000;
						#20;
					end
					2'b10:	
					begin	
						dataOut[31:0] = {mem[address], mem[address + 8b0000001], mem[address + 8b0000010], mem[address + 8b0000011]};
						#30;
					end
					
					//2'b11:    see what to do here
				
				endcase
			end
			else
			begin
				case(sel)
					2'b00:	
					begin	
						case(A):
							2'b00:	mem[address + 8b0000011] = dataIn[7:0];
							2'b01:	mem[address + 8b0000010] = dataIn[7:0];
							2'b10:	mem[address + 8b0000001] = dataIn[7:0];
							2'b11:	mem[address] = dataIn[7:0];
						endcase
						#25;
					end
					2'b01:	
					begin
						case(A[1]):
							1'b0:
							begin
								mem[address + 8b0000010] = dataOut[15:8];
								mem[address + 8b0000011] = dataOut[7:0];
							end
							1'b1:
							begin
								mem[address] = dataOut[15:8] ;
								mem[address + 8b0000001] = dataOut[7:0] ;
							end
						endcase
						#35;
					end
					2'b10:	
					begin	
						mem[address + 8'b00000011] = dataIn[7:0];
						mem[address + 8'b00000010] = dataIn[15:8];
						mem[address + 8'b00000001] = dataIn[23:16];
						mem[address] = dataIn[31:24];
						#60;
					end
					
					//2'b11:
				
				endcase
			end
			done = 1'b1;
		end
		else
			dataOut = 32'bz;
	end
endmodule