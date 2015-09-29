module test_alu;
//Inputs
reg [31: 0] IL, IR; //Left and right operand
reg [3:0] IF; //Function select input
reg CIN; //Carry in input
//OUTPUTS
wire [31:0] ALUOUT;
wire COUT, V, ZERO, N; //Las salidas deben ser tipo wire
parameter sim_time = 160;
ALU alu1(ALUOUT, ZERO, N, COUT, V, IL, IR, IF, CIN); // Instanciación del módulo

initial #sim_time $finish; // Especifica cuando termina simulación

initial begin
IF = 4'b0000; //Genera las combinaciones de las entradas
IL = 25;
IR = 20;
CIN = 1'b1;

repeat (15) #10 IF = IF + 4'b0001;
end

initial begin
$display (" IF 	  C N V Z 		   IL 	  IL 	  ALUOUT"); //imprime header
$monitor ("   %b%b%b%b  %b %b %b %b         %d %d %d", IF[3], IF[2], IF[1], IF[0], COUT, N, V, ZERO, IL ,IR, ALUOUT); //imprime las señales
end

endmodule