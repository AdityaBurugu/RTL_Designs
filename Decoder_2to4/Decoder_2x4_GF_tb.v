module Decoder_2x4_GF_tb();
////////////////////////////////////////////////
//			SIGNAL DECLARATIONS
////////////////////////////////////////////////
reg A;
reg B;
reg E;

wire [3:0]D;
////////////////////////////////////////////////
//			DUT DECLARATIONS
////////////////////////////////////////////////
Decoder_2x4_GF DUT(.D(D),
		.A(A),
		.B(B),
		.E(E));
////////////////////////////////////////////////
//			TESTCASES
////////////////////////////////////////////////
initial 
begin
E = 1'b1;
A = 1'b0;
B = 1'b0;

#10 
E = 1'b1;
A = 1'b0;
B = 1'b1;

#10 
E = 1'b1;
A = 1'b1;
B = 1'b0;

#10 
E = 1'b1;
A = 1'b1;
B = 1'b1;

#10 
E = 1'b0;
A = 1'b0;
B = 1'b0;

#10 
E = 1'b0;
A = 1'b0;
B = 1'b1;

#10 
E = 1'b0;
A = 1'b1;
B = 1'b0;

#10 
E = 1'b0;
A = 1'b1;
B = 1'b1;

#10 $stop;
end
endmodule
