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