module register_test;

        // Inputs
        reg [31:0] D;
        reg clr, clk, E;

        // Outputs
        wire [31:0] Q;
        wire [31:0] Q_n;

        register reg1bit (clk, clr, E, D, Q, Q_n);

        initial 
          begin

  		    // 20 cycles
            clk = 1'b0;
            repeat(40)
            #10 clk = ~clk;

          end

   initial
     begin

        $display("Make Q Output High:");
        clk = 1;
        clr = 1;
        E = 0;
        D = 32'b11111111111111111111111111111111;
        #1;
		$display("D = %0h, E = %0h, Q = %0h, Q_n = %0h, clr = %0h, clk = %0h, time = %0h ", D, E, Q, Q_n, clr, clk, $time);

        $display("Make Q Output Low:");
        clk = 0;
        clk = 1;
        clr = 1;
        E = 0;
        D = 32'b00000000000000000000000000000000;
        #1;
        $display("D = %0h, E = %0h, Q = %0h, Q_n = %0h, clr = %0h, clk = %0h, time = %0h ", D, E, Q, Q_n, clr, clk, $time);
        
        $display("Testing the Reset With D = 1:");
        clk = 0;
        clk = 1;
        E = 0;        
        clr = 0;
        D = 32'b11111111111111111111111111111111;
        #1;
        $display("D = %0h, E = %0h, Q = %0h, Q_n = %0h, clr = %0h, clk = %0h, time = %0h ", D, E, Q, Q_n, clr, clk, $time);

        $display("Testing the Reset With D = 1 && E = 0:");
        clk = 0;
        clk = 1;
        E = 1;        
        clr = 0;
        D = 32'b11111111111111111111111111111111;
        #1;
        $display("D = %0h, E = %0h, Q = %0h, Q_n = %0h, clr = %0h, clk = %0h, time = %0h ", D, E, Q, Q_n, clr, clk, $time);

        $display("Testing the Reset With D = 1, CLEAR = 1 && E = 0:");
        clk = 0;
        clk = 1;
        E = 1;        
        clr = 1;
        D = 32'b11111111111111111111111111111111;
        #1;
        $display("D = %0h, E = %0h, Q = %0h, Q_n = %0h, clr = %0h, clk = %0h, time = %0h ", D, E, Q, Q_n, clr, clk, $time);
    
    end

endmodule