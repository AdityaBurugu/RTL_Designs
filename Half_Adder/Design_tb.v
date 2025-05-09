module Half_Adder_tb();
////////////////////////////////////////////////
//			SIGNAL DECLARATIONS
////////////////////////////////////////////////
reg A;
reg B;

wire Sum;
wire Carry;
////////////////////////////////////////////////
//			DUT DECLARATIONS
////////////////////////////////////////////////
Half_Adder DUT(.Sum(Sum),
		.Carry(Carry),
		.A(A),
		.B(B));
////////////////////////////////////////////////
//			TESTCASES
////////////////////////////////////////////////
initial 
begin
A = 1'b0;
B = 1'b0;

#10 
A = 1'b0;
B = 1'b1;

#10 
A = 1'b1;
B = 1'b0;

#10 
A = 1'b1;
B = 1'b1;

#10 $stop;

end
endmodule

