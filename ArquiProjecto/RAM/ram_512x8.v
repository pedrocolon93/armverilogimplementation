/*MAS: 00 B  //  01 H  //  10 w  // 11 undefined
1 = read  //  0 = write
changed mem value for test purposes */

module ram512x8 (output reg [31:0]dataOut, output reg done, input enable, readWrite, input [8:0]address, input [31:0]dataIn, input [1:0]MAS, A);
	reg [8:0]mem[0:512];
	always @ (enable, readWrite, MAS, dataIn, A, address)
	begin
		if (enable)
		begin
			done = 0;
			if (readWrite) begin
				//Reading
				case(MAS)
					2'b00:	begin
						case(A)
							2'b00:	dataOut[7:0] = mem[address + 8'b0000011][7:0];
							2'b01:	dataOut[7:0] = mem[address + 8'b0000010][7:0];
							2'b10:	dataOut[7:0] = mem[address + 8'b0000001][7:0];
							2'b11:	dataOut[7:0] = mem[address][7:0];
						endcase
						dataOut[31:8] = 24'b0000_0000_0000_0000_0000_0000;
						// #15;
					end
					2'b01:	begin	
						case(A[1])
							1'b0:	begin
								dataOut[15:8] = mem[address + 8'b0000010][7:0];
								dataOut[7:0] = mem[address + 8'b0000011][7:0];
							end
							1'b1:	begin
								dataOut[15:8] = mem[address][7:0];
								dataOut[7:0] = mem[address + 8'b0000001][7:0];
							end
						endcase
						dataOut[31:16] = 16'b0000_0000_0000_0000;
						// #20;
					end
					2'b10:	begin	
						dataOut[31:0] = {mem[address][7:0], 
										 mem[address + 8'b0000001][7:0], 
										 mem[address + 8'b0000010][7:0], 
										 mem[address + 8'b0000011][7:0]};
						// #30;
					end
				endcase
			end
			else begin
				//Writing
				case(MAS)
					2'b00:	begin	
						case(A)
							2'b00:	mem[address + 8'b0000011][7:0] = dataIn[7:0];
							2'b01:	mem[address + 8'b0000010][7:0] = dataIn[7:0];
							2'b10:	mem[address + 8'b0000001][7:0] = dataIn[7:0];
							2'b11:	mem[address][7:0] = dataIn[7:0];
						endcase
						// #25;
					end
					2'b01:	begin
						case(A[1])
							1'b0:	begin
								mem[address + 8'b0000010][7:0] = dataIn[15:8];
								mem[address + 8'b0000011][7:0] = dataIn[7:0];
							end
							1'b1:	begin
								mem[address][7:0] = dataIn[15:8];
								mem[address + 8'b0000001][7:0] = dataIn[7:0] ;
							end
						endcase
						//#35;
					end
					2'b10:	begin	
						mem[address + 8'b00000011][7:0] = dataIn[7:0];
						mem[address + 8'b00000010][7:0] = dataIn[15:8];
						mem[address + 8'b00000001][7:0] = dataIn[23:16];
						mem[address][7:0] = dataIn[31:24];
						//#60;
					end
				endcase
			end
			done = 1;
		end
		else
			dataOut = 32'bz;
	end
endmodule