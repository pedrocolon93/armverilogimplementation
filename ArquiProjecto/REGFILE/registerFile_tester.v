module registerFileTestBench;

	reg [31:0] PC;	// Input from ALU. 32 bits
	reg [3:0] RA; // Selector of A Mux is 3 bits
	reg [3:0] RB; // Selector of B Mux is 3 bits
	reg [3:0] RC; // Register Enable Selectors (Input to Decoders 0 and 1)
	reg [3:0] RD;  // Register Clear Selectors (Input to Decoders 0 and 1)
	reg CLK; // Register Clock Enable (All Clocks of Registers are Shared)
	reg RFE; // Decoder and Mux Enabler (All Enables of Decoders are Shared)
	reg [3:0] TEST; // keep track of what is the current test

	wire [31:0] A, B; // Outputs of the Register File. Can be Wire Since I do not Assign Values to A, B (Outputs)

	registerFile registerFile (A, B, PC, RC, RD, RA, RB, CLK, RFE); // Instance of Entire Register File

	//initialize values
	initial 
		begin
			/*
				Registers Start Cleared
			*/
			CLK = 0; //Start Clock Assertion Level Low
			PC = 0; // Initialize PC with Value 0
			RFE = 0; // turn on enable decoder
			TEST = 0;
		end

	initial fork
		repeat (18) 
			//Loop to Change Clock & Increment PC & TEST. Clock Goes High, PC & TEST Increment Every Even Number of Time Units
			begin
				#2 CLK = ~CLK; // Change Clock Every Time Unit
				if (!CLK)
					begin
						PC <= PC + 1;
						TEST <= TEST + 1;
						$display ("TEST  A         							B         							PC         							CLK 	RFE  	RA		RB		RC 		RD  	TIME");
						$display ("%d    %b   	%b   	%b   	%b   	%b   	%b   	%b   	%b   	%b   	%0d", TEST, A, B, PC, CLK, RFE, RA, RB, RC, RD, $time);
						$display ("",);
					end
			end

	// Test 0: Pass PC = 0 to R0, Then Watch R0 = PC Value Pass to Mux A
	#1 RC = 0; // R0 Enable Selected
	#1 RA = 0; // Select MUX A R0

	// Test 1: Let R0 Increment
	#5 ;

	// Test 2: Change Enable from R0 to R1 to Stop A at Last stored PC Value (R0 value)
	#9 RC = 1;
	#9 RA = 1;

	// Test 3: Change Mux B output to PC through R1. Stop Mux A Output at Last Stored Value. Deselect MUX A so Output is the Same as Previous Test
	#13 RA = 4'bx;
	#13 RB = 1;

	// Test 4: Pass PC to R4 then Output Mux A. Stop Mux B Output at Last Stored Value
	#17 RC = 3;
	#17 RA = 3;
	#17 RB = 4'bx;

	// Test 5: Let Both A and B Output Latest R4 Value
	#21 RA = 3;
	#21 RB = 3;

	// Test 6: Let Both Outputs Increment
	#25 ;

	// Test 7: Clear B Output
	#29 RC = 4'bx;
	#29 RB = 0;
	#29 RD = 0;

	// Test 8: Clear A Output
	#33 RA = 0;
	#33 RD = 0;

	join

endmodule