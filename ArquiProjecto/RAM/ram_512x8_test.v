module ram_test;
	reg en;
	reg rw;
	reg [8:0]adr;
	reg [31:0]data;
	reg [1:0]dataSize;
	reg [1:0]dataPlace;

	wire [31:0]out;
	wire finished;

	ram512x8 ram(out, finished, en, rw, adr, data, dataSize, dataPlace);

	parameter sim_time = 1500;
	initial #sim_time $finish;

	initial begin
		en = 1'b0;
		rw = 1'b0;
		adr = 8'b0000000;
		data = 32'h00000002;
		dataSize = 2'b00;
		dataPlace = 2'b11;

		#1 repeat (3) #10 begin  //write B
			en = 1'b1;
			data = data + 1;
			dataPlace = dataPlace - 2'b01;
		end
		#40 repeat(4) #15 begin		//read B
			rw = 1'b1;
			dataPlace = dataPlace + 2'b01;
		end
		

		#65 repeat(2) #15 begin		//write H
			rw = 1'b0;
			dataSize = 2'b01;
			data = data + 1;
			dataPlace = dataPlace - 2'b10;
		end
		#130 repeat(2) #15 begin		//read H
			rw = 1'b1;
			dataPlace = dataPlace + 2'b10;
		end


		#200 repeat(1) #15 begin		//write W
			rw = 1'b0;
			dataSize = 2'b10;
			data = data + 1;
		end
		#265 repeat(1) #15 begin		//read W
			rw = 1'b1;
		end
	end

	initial begin
		$display("data     size dP RW EN");
		$monitor("%h %b   %b %b  %b", out, dataSize, dataPlace, rw, en);
	end
endmodule