module BCD_to_Excess3(w,
			x,
			y,
			z,
			A,		
			B,
			C,
			D);
////////////////////////////////////////////////
//			PORT DECLARATIONS
////////////////////////////////////////////////
input A;
input B;
input C;
input D;

output w;
output x;
output y;
output z;
////////////////////////////////////////////////
//			SIGNAL DECLARATIONS
////////////////////////////////////////////////
wire A;
wire B;
wire C;
wire D;

wire w;
wire x;
wire y;
wire z;
////////////////////////////////////////////////
//			INTERNAL WIRE DECLARATIONS
////////////////////////////////////////////////
wire notB;
wire notC;
wire notD;

wire CD_sum;
wire CD_sum_inv;
////////////////////////////////////////////////
//			COMBINATIONAL LOGIC
////////////////////////////////////////////////
not G1(notB, B);
not G2(notC, C);
not G3(notD, D);

or(CD_sum,C,D);
not(CD_sum_inv,CD_sum);

assign z = notD;
assign y = (C & D) | CD_sum_inv;
assign x = (notB & CD_sum)| (B & CD_sum_inv);
assign w = A | (B & (CD_sum));
endmodule
