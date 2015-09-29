module ram_test;
	reg en;
	reg [8:0]adr;
	reg [31:0]data;
	reg [1:0]rw;
	reg [1:0]dataSize;
	reg [1:0]dataPlace;

	wire [31:0]out;
	wire finished;

	ram512x8 ram(out, finished, en, rw, adr, data, dataSize, dataPlace);

	initial begin
		rw = 0'b0;
		adr = 8'b0010000;
		data = 32'h0000000f;
		dataSize = 2'b00;
		dataPlace = 2'b11;

		en = 1'b1;
		rw = 0'b0;
		adr = 8'b0010000;
		data = 32'h00000002;
		dataSize = 2'b00;
		dataPlace = 2'b10;

		rw = 0'b0;
		adr = 8'b0010000;
		data = 32'h00000004;
		dataSize = 2'b00;
		dataPlace = 2'b01;

		rw = 0'b0;
		adr = 8'b0010000;
		data = 32'h00000008;
		dataSize = 2'b00;
		dataPlace = 2'b00;
	end

	initial begin
		$display("data");
		$monitor("%h", out);
	end
endmodule